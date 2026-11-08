import { createClient } from "jsr:@supabase/supabase-js@2";

const ORIGINS = new Set([
  "https://admin.carefur.me", "http://localhost:5173", "http://127.0.0.1:5173",
]);
function headers(req: Request) {
  const origin = req.headers.get("origin") || "";
  return {
    ...(ORIGINS.has(origin) ? { "Access-Control-Allow-Origin": origin } : {}),
    "Access-Control-Allow-Headers": "authorization, apikey, x-client-info, content-type",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Content-Type": "application/json", "Cache-Control": "no-store", Vary: "Origin",
  };
}
function reply(req: Request, data: unknown, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: headers(req) });
}
function phonePH(value: unknown): string | null {
  if (typeof value !== "string") return null;
  const s = value.replace(/[\s().-]/g, "");
  if (/^09\d{9}$/.test(s)) return "+63" + s.slice(1);
  if (/^639\d{9}$/.test(s)) return "+" + s;
  if (/^\+639\d{9}$/.test(s)) return s;
  return null;
}
function datePH(v: string) {
  return new Intl.DateTimeFormat("en-PH", {
    timeZone: "Asia/Manila", dateStyle: "medium", timeStyle: "short",
  }).format(new Date(v));
}

type Paid = {
  success: boolean; already_paid: boolean; booking_id: string;
  booking_code?: string; access_code?: string;
  owner_name?: string; phone?: string; pet_name?: string;
  room_number?: string; check_in_at?: string; expected_check_out_at?: string;
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return ORIGINS.has(req.headers.get("origin") || "")
      ? new Response(null, { status: 204, headers: headers(req) })
      : reply(req, { error: "Origin not allowed" }, 403);
  }
  if (req.method !== "POST") return reply(req, { error: "POST required" }, 405);
  if (req.headers.get("origin") && !ORIGINS.has(req.headers.get("origin")!))
    return reply(req, { error: "Origin not allowed" }, 403);

  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  const smsKey = Deno.env.get("TEXTBEE_API_KEY");
  if (!url || !anon) return reply(req, { error: "Supabase configuration missing" }, 500);
  const token = (req.headers.get("authorization") || "").replace(/^Bearer\s+/i, "").trim();
  if (!token) return reply(req, { error: "Sign in required" }, 401);
  const db = createClient(url, anon, {
    global: { headers: { Authorization: `Bearer ${token}` } },
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: who, error: authErr } = await db.auth.getUser(token);
  if (authErr || !who.user) return reply(req, { error: "Invalid session" }, 401);
  const { data: staff, error: roleErr } = await db.from("users")
    .select("role").eq("id", who.user.id).maybeSingle();
  if (roleErr || !["admin", "staff"].includes(String(staff?.role)))
    return reply(req, { error: "Staff required" }, 403);

  let body: { request_id?: string; action?: string };
  try { body = await req.json(); } catch { return reply(req, { error: "Invalid JSON" }, 400); }
  if (!/^[0-9a-f]{8}-[0-9a-f-]{27,}$/i.test(body?.request_id || ""))
    return reply(req, { error: "Invalid request ID" }, 400);
  if (!["paid", "retry_sms"].includes(body?.action || ""))
    return reply(req, { error: "Invalid action" }, 400);

  const id = body.request_id!;
  let paid: Paid;
  try {
    const { data, error } = await db.rpc("carefur_convert_paid_reservation", { p_request_id: id });
    if (error) return reply(req, { error: error.message }, 409);
    paid = data as Paid;
    if (!paid?.success || !paid.booking_id) return reply(req, { error: "Boarding conversion failed" }, 500);
  } catch (error) {
    console.error("Paid reservation conversion failed", error);
    return reply(req, { error: "Could not transfer reservation" }, 500);
  }

  // Claim SMS separately: retrying never creates another booking.
  const { data: claimed, error: claimError } = await db.rpc("carefur_claim_paid_reservation_sms", {
    p_request_id: id,
  });
  if (claimError) return reply(req, {
    success: true, booking_id: paid.booking_id, sms_status: "not_sent",
    warning: claimError.message,
  });
  if (!claimed) return reply(req, {
    success: true, booking_id: paid.booking_id, sms_status: "already_queued_or_sending",
    message: "Boarding exists; confirmation SMS was already queued or is being processed.",
  });

  let smsStatus = "failed";
  let smsError: string | null = null;
  try {
    // A retry rotates the unredeemed boarding access code to avoid needing
    // to store plain-text codes in the database.
    let code = paid.access_code;
    if (!code) {
      const { data, error } = await db.rpc("carefur_refresh_paid_access_code", { p_request_id: id });
      if (error) throw new Error(error.message);
      code = data as string;
    }
    const { data: reservation, error: reservationError } = await db.from("reservation_requests")
      .select("owner_name,phone,pet_name,requested_room_number,check_in_at,expected_check_out_at,boarding_booking_id")
      .eq("id", id).single();
    if (reservationError) throw new Error(reservationError.message);
    const recipient = phonePH(reservation?.phone);
    if (!recipient) throw new Error("Owner phone number is not a valid Philippine mobile number");
    if (!smsKey) throw new Error("TEXTBEE_API_KEY secret is missing");
    const { data: booking, error: bookingErr } = await db.from("bookings")
      .select("booking_code").eq("id", paid.booking_id).single();
    if (bookingErr) throw new Error(bookingErr.message);
    const message = [
      "CareFur - Snuggles Premium Pet Hotel",
      `Payment confirmed for ${reservation.pet_name || "your pet"}.`,
      `Booking: ${booking.booking_code}`,
      `Room: ${reservation.requested_room_number || "Assigned"}`,
      `Check-in: ${datePH(reservation.check_in_at)}`,
      `Check-out: ${datePH(reservation.expected_check_out_at)}`,
      `Your Boarding Access Code: ${code}`,
      "Open the CareFur app and enter this code once to link your boarding.",
      "Do not share your code.",
    ].join("\n");
    const deviceId = Deno.env.get("TEXTBEE_DEVICE_ID")?.trim();
    const response = await fetch("https://api.textbee.dev/api/v1/gateway/send-sms", {
      method: "POST",
      headers: { "Content-Type": "application/json", "x-api-key": smsKey },
      body: JSON.stringify({ recipients: [recipient], message, ...(deviceId ? { deviceId } : {}) }),
      signal: AbortSignal.timeout(15000),
    });
    if (!response.ok) throw new Error(`TextBee HTTP ${response.status}`);
    smsStatus = "queued"; // provider accepted the SMS; not proof of phone delivery
  } catch (e) {
    smsError = e instanceof Error ? e.message : "SMS request failed";
    console.error("Paid reservation SMS failed", smsError);
  }
  const { error: finishError } = await db.rpc("carefur_finish_paid_reservation_sms", {
    p_request_id: id, p_status: smsStatus, p_error: smsError,
  });
  if (finishError) console.error("Could not save SMS status", finishError.message);
  return reply(req, {
    success: true, booking_id: paid.booking_id,
    sms_status: smsStatus,
    ...(smsError ? { sms_error: smsError } : {}),
    message: smsStatus === "queued"
      ? "Payment confirmed, boarding created and SMS queued."
      : "Payment confirmed and boarding created, but SMS needs retry.",
  });
});
