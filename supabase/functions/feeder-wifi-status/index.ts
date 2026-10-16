import { createClient } from "jsr:@supabase/supabase-js@2";

// No router passwords enter this service. The ESP32 authenticates with a
// dedicated device-only secret; dashboard reads require an authenticated admin.
const DEVICE_CODE = "carefur-feeder-01";
const ALLOWED_ORIGINS = [
  "http://localhost:5173", "http://127.0.0.1:5173",
  "https://carefur.me", "https://www.carefur.me",
];
function headers(req: Request) {
  const origin = req.headers.get("origin") || "";
  return {
    ...(ALLOWED_ORIGINS.includes(origin) ? { "Access-Control-Allow-Origin": origin } : {}),
    "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info, x-device-secret",
    "Access-Control-Allow-Methods": "POST, OPTIONS", "Vary": "Origin",
    "Cache-Control": "no-store", "Content-Type": "application/json",
  };
}
function reply(req: Request, obj: Record<string, unknown>, status = 200) {
  return new Response(JSON.stringify(obj), { status, headers: headers(req) });
}
function safeString(value: unknown, max = 64): string {
  return typeof value === "string" ? value.slice(0, max) : "";
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    if (!ALLOWED_ORIGINS.includes(req.headers.get("origin") || ""))
      return reply(req, { error: "Origin not allowed" }, 403);
    return new Response(null, { status: 204, headers: headers(req) });
  }
  if (req.method !== "POST") return reply(req, { error: "Method not allowed" }, 405);
  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const deviceSecret = Deno.env.get("DEVICE_SECRET");
  if (!url || !anon || !service || !deviceSecret)
    return reply(req, { error: "Function not configured" }, 500);

  let body: Record<string, unknown>;
  try {
    const raw = await req.json();
    if (!raw || typeof raw !== "object" || Array.isArray(raw)) throw Error();
    body = raw as Record<string, unknown>;
  } catch { return reply(req, { error: "Invalid JSON" }, 400); }

  const db = createClient(url, service, { auth: { persistSession: false } });
  const provided = req.headers.get("x-device-secret") || "";
  const validDevice = provided.length > 0 && provided === deviceSecret && body.device_code === DEVICE_CODE;
  async function requireAdmin() {
    const bearer = req.headers.get("authorization") || "";
    if (!bearer.startsWith("Bearer ")) return false;
    const auth = createClient(url!, anon!, { auth: { persistSession: false } });
    const { data: authData, error: authError } = await auth.auth.getUser(bearer.substring(7));
    if (authError || !authData.user) return false;
    const { data: profile } = await db.from("users").select("role").eq("id", authData.user.id).single();
    return profile?.role === "admin";
  }
  if (body.action === "report") {
    // Authenticate every write; never accept client-supplied timestamps or other device IDs.
    if (!validDevice)
      return reply(req, { error: "Unauthorized device" }, 401);
    if (typeof body.connected !== "boolean")
      return reply(req, { error: "Invalid connected value" }, 400);
    const connected = body.connected;
    const rssi = typeof body.rssi === "number" && Number.isInteger(body.rssi) && body.rssi >= -120 && body.rssi <= 0 ? body.rssi : null;
    const record = {
      device_code: DEVICE_CODE,
      connected,
      saved_ssid: safeString(body.saved_ssid, 32),
      saved_networks: Array.isArray(body.saved_networks)
        ? [...new Set(body.saved_networks.filter((v): v is string => typeof v === "string" && v.length > 0 && v.length <= 32))].slice(0, 5)
        : [],
      connected_ssid: connected ? safeString(body.connected_ssid, 32) : "",
      ip_address: connected ? safeString(body.ip_address, 45) : "",
      rssi: connected ? rssi : null,
      paused: body.paused === true,
      last_seen: new Date().toISOString(),
    };
    const { error } = await db.from("device_wifi_status").upsert(record, { onConflict: "device_code" });
    if (error) { console.error("Heartbeat write failed", error.message); return reply(req, { error: "Could not save status" }, 500); }
    return reply(req, { ok: true });
  }
  if (body.action === "claim_switch") {
    if (!validDevice) return reply(req, { error: "Unauthorized device" }, 401);
    // Expire stale switch requests instead of unexpectedly switching hours later.
    const { data: command, error } = await db.from("feeder_wifi_switch_requests")
      .select("request_id, target_ssid, requested_at")
      .eq("device_code", DEVICE_CODE).eq("state", "pending").maybeSingle();
    if (error) return reply(req, { error: "Could not fetch switch request" }, 500);
    if (!command || Date.now() - new Date(command.requested_at).getTime() > 120000)
      return reply(req, { ok: true, switch: false });
    const { data: updated, error: updateError } = await db.from("feeder_wifi_switch_requests")
      .update({ state: "delivered", delivered_at: new Date().toISOString() })
      .eq("device_code", DEVICE_CODE).eq("request_id", command.request_id).eq("state", "pending")
      .select("request_id").maybeSingle();
    if (updateError) return reply(req, { error: "Could not claim switch" }, 500);
    return reply(req, { ok: true, switch: Boolean(updated), ssid: updated ? command.target_ssid : "" });
  }
  if (body.action === "read" || body.action === "queue_switch") {
    if (!(await requireAdmin())) return reply(req, { error: "Admin session required" }, 403);
    const { data, error } = await db.from("device_wifi_status")
      .select("device_code, connected, saved_ssid, saved_networks, connected_ssid, ip_address, rssi, paused, last_seen")
      .eq("device_code", DEVICE_CODE).maybeSingle();
    if (error) return reply(req, { error: "Could not fetch Wi-Fi status" }, 500);
    const ageMs = data?.last_seen ? Date.now() - new Date(data.last_seen).getTime() : Infinity;
    const online = Boolean(data?.connected && ageMs >= 0 && ageMs < 10000);
    if (body.action === "read") {
      const { data: switchRequest } = await db.from("feeder_wifi_switch_requests")
        .select("target_ssid, state, requested_at").eq("device_code", DEVICE_CODE).maybeSingle();
      return reply(req, { ok: true, status: data, online, switch_request: switchRequest });
    }
    const target = typeof body.ssid === "string" ? body.ssid : "";
    if (!online) return reply(req, { error: "Feeder is offline. Use its local setup hotspot." }, 409);
    if (!Array.isArray(data?.saved_networks) || !data.saved_networks.includes(target))
      return reply(req, { error: "Only a network previously saved on this ESP32 can be selected remotely." }, 400);
    if (target === data.connected_ssid) return reply(req, { error: "Feeder is already on that network." }, 409);
    const { error: queueError } = await db.from("feeder_wifi_switch_requests").upsert({
      device_code: DEVICE_CODE, request_id: crypto.randomUUID(), target_ssid: target,
      state: "pending", requested_at: new Date().toISOString(), delivered_at: null,
    }, { onConflict: "device_code" });
    if (queueError) return reply(req, { error: "Could not queue Wi-Fi switch" }, 500);
    return reply(req, { ok: true, queued: true });
  }
  return reply(req, { error: "Unknown action" }, 400);
});
