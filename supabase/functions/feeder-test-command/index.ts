
import {
  createClient
} from "jsr:@supabase/supabase-js@2";

// =====================================
// CAREFUR FEEDER TEST COMMAND
// =====================================

// Allowed website origins.

const ALLOWED_ORIGINS = [
  "http://localhost:5173",
  "http://127.0.0.1:5173",
  "https://carefur.me",
  "https://www.carefur.me"
];

// =====================================
// CORS HEADERS
// =====================================

function corsHeaders(req: Request) {

  const origin =
    req.headers.get("origin") || "";

  const allowed =
    ALLOWED_ORIGINS.includes(origin);

  return {
    ...(allowed
      ? { "Access-Control-Allow-Origin": origin }
      : {}),

    "Access-Control-Allow-Methods":
      "POST, OPTIONS",

    "Access-Control-Allow-Headers":
      "authorization, apikey, content-type, x-client-info",

    "Access-Control-Max-Age": "600",

    "Vary": "Origin"
  };
}

// =====================================
// JSON RESPONSE
// =====================================

function jsonResponse(
  req: Request,
  body: Record<string, unknown>,
  status = 200
) {

  return new Response(
    JSON.stringify(body),
    {
      status,

      headers: {
        ...corsHeaders(req),

        "Content-Type":
          "application/json",

        "Cache-Control":
          "no-store"
      }
    }
  );
}

// =====================================
// MAIN FUNCTION
// =====================================

Deno.serve(async (req: Request) => {

  // =====================================
  // 1. HANDLE CORS PREFLIGHT
  // =====================================

  if (req.method === "OPTIONS") {

    const origin =
      req.headers.get("origin") || "";

    if (!ALLOWED_ORIGINS.includes(origin)) {

      return jsonResponse(
        req,
        { error: "Origin not allowed" },
        403
      );
    }

    return new Response(
      null,
      {
        status: 204,
        headers: corsHeaders(req)
      }
    );
  }

  // =====================================
  // 2. ALLOW POST ONLY
  // =====================================

  if (req.method !== "POST") {

    return jsonResponse(
      req,
      { error: "Method not allowed" },
      405
    );
  }

  // =====================================
  // 3. SUPABASE CONFIGURATION
  // =====================================

  const supabaseUrl =
    Deno.env.get("SUPABASE_URL");

  const anonKey =
    Deno.env.get("SUPABASE_ANON_KEY");

  const serviceRoleKey =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (
    !supabaseUrl ||
    !anonKey ||
    !serviceRoleKey
  ) {

    console.error(
      "Required Supabase environment variables missing"
    );

    return jsonResponse(
      req,
      { error: "Server not configured" },
      500
    );
  }

  // =====================================
  // 4. VERIFY LOGGED-IN USER
  // =====================================

  const authorization =
    req.headers.get("authorization") || "";

  if (!authorization.startsWith("Bearer ")) {

    return jsonResponse(
      req,
      { error: "Please sign in first" },
      401
    );
  }

  const accessToken =
    authorization.slice(7);

  const authClient =
    createClient(
      supabaseUrl,
      anonKey
    );

  const {
    data: authData,
    error: authError
  } = await authClient.auth.getUser(
    accessToken
  );

  if (
    authError ||
    !authData.user
  ) {

    return jsonResponse(
      req,
      { error: "Invalid user session" },
      401
    );
  }

  // =====================================
  // 5. SERVER-SIDE DATABASE CLIENT
  // =====================================

  const db = createClient(
    supabaseUrl,
    serviceRoleKey,
    {
      auth: {
        persistSession: false,
        autoRefreshToken: false
      }
    }
  );

  // =====================================
  // 6. CHECK ADMIN PERMISSION
  // =====================================

  const {
    data: profile,
    error: profileError
  } = await db
    .from("users")
    .select("role")
    .eq("id", authData.user.id)
    .single();

  if (
    profileError ||
    profile?.role !== "admin"
  ) {

    return jsonResponse(
      req,
      { error: "Admin access required" },
      403
    );
  }

  // =====================================
  // 7. READ MOTOR COMMAND
  // =====================================

  let body;

  try {

    body = await req.json();

  } catch {

    return jsonResponse(
      req,
      { error: "Invalid JSON request" },
      400
    );
  }

  const {
    device_code,
    steps,
    direction
  } = body ?? {};

  // =====================================
  // 8. VALIDATE MOTOR COMMAND
  // =====================================

  if (
    device_code !== "carefur-feeder-01" ||
    ![50, 100, 267, 533].includes(steps) ||
    !["clockwise", "counterclockwise"]
      .includes(direction)
  ) {

    return jsonResponse(
      req,
      { error: "Invalid motor test request" },
      400
    );
  }

  // =====================================
  // 9. CHECK EXISTING COMMANDS
  // =====================================

  const {
    data: outstanding,
    error: lookupError
  } = await db
    .from("feeder_test_commands")
    .select("id")
    .eq("device_code", device_code)
    .in("status", ["pending", "claimed"])
    .limit(1);

  if (lookupError) {

    console.error(
      "Command lookup error:",
      lookupError.message
    );

    return jsonResponse(
      req,
      { error: "Could not check pending commands" },
      500
    );
  }

  if (outstanding?.length) {

    return jsonResponse(
      req,
      {
        error:
          "There is already a pending motor test."
      },
      409
    );
  }

  // =====================================
  // 10. CREATE MOTOR COMMAND
  // =====================================

  const {
    data: command,
    error: insertError
  } = await db
    .from("feeder_test_commands")
    .insert({
      device_code,
      steps,
      direction,
      requested_by: authData.user.id
    })
    .select("id")
    .single();

  if (
    insertError ||
    !command
  ) {

    console.error(
      "Command insertion failed:",
      insertError?.message
    );

    return jsonResponse(
      req,
      { error: "Could not queue motor test" },
      500
    );
  }

  // =====================================
  // 11. RETURN CONFIRMATION
  // =====================================

  return jsonResponse(
    req,
    {
      ok: true,
      message: "Motor test command queued",
      command_id: command.id,
      status: "pending"
    },
    202
  );

});