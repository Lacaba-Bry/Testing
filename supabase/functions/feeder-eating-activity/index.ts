import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "content-type, x-device-secret, apikey, authorization",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Cache-Control": "no-store",
};
function respond(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });
}
function sameSecret(provided: string, expected: string): boolean {
  if (!provided || !expected) return false;
  const encoder = new TextEncoder();
  const a = encoder.encode(provided), b = encoder.encode(expected);
  const n = Math.max(a.length, b.length);
  let diff = a.length ^ b.length;
  for (let i = 0; i < n; i++) diff |= (a[i] ?? 0) ^ (b[i] ?? 0);
  return diff === 0;
}
Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response(null, { status: 204, headers: cors });
  if (req.method !== "POST") return respond({ ok: false, error: "POST required" }, 405);
  const expected = Deno.env.get("DEVICE_SECRET") ?? "";
  if (!sameSecret(req.headers.get("x-device-secret") ?? "", expected))
    return respond({ ok: false, error: "Unauthorized device" }, 401);
  const url = Deno.env.get("SUPABASE_URL");
  const key = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !key) return respond({ ok: false, error: "Backend not configured" }, 500);
  let body: Record<string, unknown>;
  try { body = await req.json(); } catch { return respond({ ok: false, error: "Invalid JSON" }, 400); }
  const deviceCode = String(body.device_code ?? "");
  const sessionId = String(body.session_id ?? "");
  const eventType = String(body.event_type ?? "");
  const drop = Number(body.relative_drop ?? 0);
  const duration = Number(body.duration_seconds ?? 0);
  if (!/^[a-zA-Z0-9_-]{4,80}$/.test(deviceCode) ||
      !/^[a-zA-Z0-9_-]{8,150}$/.test(sessionId) ||
      !sessionId.startsWith(deviceCode + "-") ||
      !["started", "ended"].includes(eventType) ||
      !Number.isFinite(drop) || drop < 0 || drop > 50000 ||
      !Number.isSafeInteger(duration) || duration < 0 || duration > 86400 * 4)
    return respond({ ok: false, error: "Invalid activity event" }, 400);
  const now = Date.now();
  let happenedAt: string;
  let timeSource = "server_received";
  if (body.occurred_at) {
    const value = String(body.occurred_at);
    const parsed = Date.parse(value);
    if (!Number.isFinite(parsed) || parsed < now - 48 * 3600000 || parsed > now + 10 * 60000)
      return respond({ ok: false, error: "Event timestamp outside allowed range" }, 400);
    happenedAt = new Date(parsed).toISOString();
    timeSource = "device_rtc";
  } else happenedAt = new Date(now).toISOString();
  const db = createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
  const { data: device, error: deviceError } = await db.from("devices")
    .select("device_code,status,device_type").eq("device_code", deviceCode).maybeSingle();
  if (deviceError) return respond({ ok: false, error: "Device verification unavailable" }, 500);
  if (!device || device.status !== "active" || device.device_type !== "feeder")
    return respond({ ok: false, error: "Unknown or inactive feeder" }, 403);
  if (eventType === "started") {
    const { error } = await db.from("feeder_eating_sessions").insert({
      session_id: sessionId, device_code: deviceCode, started_at: happenedAt,
      time_source: timeSource,
    });
    if (error && error.code !== "23505") return respond({ ok: false, error: "Could not save session start" }, 500);
    return respond({ ok: true, session_id: sessionId });
  }
  const { data: existing, error: readError } = await db.from("feeder_eating_sessions")
    .select("started_at, ended_at, device_code")
    .eq("session_id", sessionId).maybeSingle();
  if (readError) return respond({ ok: false, error: "Could not read session" }, 500);
  if (!existing) return respond({ ok: false, error: "Start event must be uploaded first" }, 409);
  if (existing.device_code !== deviceCode) return respond({ ok: false, error: "Device mismatch" }, 403);
  if (existing.ended_at) return respond({ ok: true, session_id: sessionId, already_ended: true });
  // Limit finish timestamp to not precede start if RTC clock moved backwards.
  const finishAt = new Date(Math.max(Date.parse(existing.started_at), Date.parse(happenedAt))).toISOString();
  const { error } = await db.from("feeder_eating_sessions")
    .update({ ended_at: finishAt, duration_seconds: duration,
      relative_weight_drop: Math.round(drop * 100) / 100, updated_at: new Date().toISOString() })
    .eq("session_id", sessionId).is("ended_at", null);
  if (error) return respond({ ok: false, error: "Could not save session end" }, 500);
  return respond({ ok: true, session_id: sessionId });
});
