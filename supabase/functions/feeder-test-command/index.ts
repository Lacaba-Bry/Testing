import { createClient } from "jsr:@supabase/supabase-js@2";

// =====================================================
// CAREFUR ADMIN MOTOR TEST
// Edge Function: motor-test
//
// Website actions:
//   queue  -> create one 120-degree feeder command
//   status -> return the command state for the dashboard
//
// The ESP32 does NOT call this function. It continues to use
// feeder-rotate with x-device-secret authentication.
// =====================================================

const ALLOWED_ORIGINS = [
  "http://localhost:5173",
  "http://127.0.0.1:5173",
  "https://carefur.me",
  "https://www.carefur.me",
];

const TEST_STEPS = 533;
const TEST_DIRECTION = "clockwise";
const COMMAND_EXPIRATION_MS = 5 * 60 * 1000;

// =====================================================
// CORS
// =====================================================

function corsHeaders(req: Request) {
  const origin = req.headers.get("origin") || "";
  const allowed = ALLOWED_ORIGINS.includes(origin);

  return {
    ...(allowed
      ? {
          "Access-Control-Allow-Origin": origin,
        }
      : {}),

    "Access-Control-Allow-Methods":
      "POST, OPTIONS",

    "Access-Control-Allow-Headers":
      "authorization, x-client-info, apikey, content-type",

    "Access-Control-Max-Age":
      "86400",

    "Vary":
      "Origin",
  };
}

// =====================================================
// JSON RESPONSE HELPER
// =====================================================

function jsonResponse(
  req: Request,
  body: Record<string, unknown>,
  status = 200,
) {
  return new Response(
    JSON.stringify(body),
    {
      status,
      headers: {
        ...corsHeaders(req),
        "Content-Type": "application/json",
        "Cache-Control": "no-store",
      },
    },
  );
}

// =====================================================
// STATUS MAPPING
// =====================================================

function mapStatus(status: string) {
  switch (status) {
    case "pending":
      return "queued";

    case "claimed":
      return "running";

    case "completed":
      return "completed";

    case "failed":
      return "failed";

    case "cancelled":
      return "expired";

    default:
      return status;
  }
}

// =====================================================
// MAIN EDGE FUNCTION
// =====================================================

Deno.serve(async (req: Request) => {
  // ===================================================
  // CORS PREFLIGHT
  // ===================================================

  if (req.method === "OPTIONS") {
    const origin =
      req.headers.get("origin") || "";

    if (!ALLOWED_ORIGINS.includes(origin)) {
      return new Response(
        JSON.stringify({
          error: "Origin not allowed",
        }),
        {
          status: 403,
          headers: {
            ...corsHeaders(req),
            "Content-Type":
              "application/json",
          },
        },
      );
    }

    return new Response("ok", {
      status: 200,
      headers: corsHeaders(req),
    });
  }

  // ===================================================
  // POST ONLY
  // ===================================================

  if (req.method !== "POST") {
    return jsonResponse(
      req,
      {
        error: "Method not allowed",
      },
      405,
    );
  }

  // ===================================================
  // SUPABASE ENVIRONMENT VARIABLES
  // ===================================================

  const supabaseUrl =
    Deno.env.get("SUPABASE_URL");

  const anonKey =
    Deno.env.get("SUPABASE_ANON_KEY");

  const serviceRoleKey =
    Deno.env.get(
      "SUPABASE_SERVICE_ROLE_KEY",
    );

  if (
    !supabaseUrl ||
    !anonKey ||
    !serviceRoleKey
  ) {
    console.error(
      "Required Supabase environment variables missing",
    );

    return jsonResponse(
      req,
      {
        error: "Server not configured",
      },
      500,
    );
  }

  // ===================================================
  // USER AUTHENTICATION
  // ===================================================

  const authorization =
    req.headers.get("authorization") || "";

  if (
    !authorization.startsWith(
      "Bearer ",
    )
  ) {
    return jsonResponse(
      req,
      {
        error: "Please sign in first",
      },
      401,
    );
  }

  const accessToken =
    authorization.slice(7);

  const authClient =
    createClient(
      supabaseUrl,
      anonKey,
      {
        auth: {
          persistSession: false,
          autoRefreshToken: false,
        },
      },
    );

  const {
    data: authData,
    error: authError,
  } =
    await authClient.auth.getUser(
      accessToken,
    );

  if (
    authError ||
    !authData.user
  ) {
    return jsonResponse(
      req,
      {
        error: "Invalid user session",
      },
      401,
    );
  }

  // ===================================================
  // SERVICE ROLE DATABASE CLIENT
  // ===================================================

  const db =
    createClient(
      supabaseUrl,
      serviceRoleKey,
      {
        auth: {
          persistSession: false,
          autoRefreshToken: false,
        },
      },
    );

  // ===================================================
  // CHECK ADMIN ROLE
  // ===================================================

  const {
    data: profile,
    error: profileError,
  } =
    await db
      .from("users")
      .select("role")
      .eq(
        "id",
        authData.user.id,
      )
      .single();

  if (
    profileError ||
    profile?.role !== "admin"
  ) {
    return jsonResponse(
      req,
      {
        error:
          "Admin access required",
      },
      403,
    );
  }

  // ===================================================
  // PARSE REQUEST BODY
  // ===================================================

  let body:
    Record<string, unknown>;

  try {
    const parsed =
      await req.json();

    if (
      !parsed ||
      typeof parsed !== "object" ||
      Array.isArray(parsed)
    ) {
      throw new Error(
        "Invalid body",
      );
    }

    body =
      parsed as Record<
        string,
        unknown
      >;
  } catch {
    return jsonResponse(
      req,
      {
        error:
          "Invalid JSON request",
      },
      400,
    );
  }

  const action =
    body.action;

  const deviceId =
    body.device_id;

  // ===================================================
  // VALIDATE DEVICE ID
  // ===================================================

  if (
    typeof deviceId !==
      "string" ||
    deviceId.length === 0
  ) {
    return jsonResponse(
      req,
      {
        error:
          "A feeder device is required",
      },
      400,
    );
  }

  // ===================================================
  // LOAD ACTIVE FEEDER DEVICE
  // ===================================================

  const {
    data: device,
    error: deviceError,
  } =
    await db
      .from("devices")
      .select(
        "id, device_code, device_name, device_type, status",
      )
      .eq(
        "id",
        deviceId,
      )
      .eq(
        "device_type",
        "feeder",
      )
      .eq(
        "status",
        "active",
      )
      .maybeSingle();

  if (deviceError) {
    console.error(
      "Device lookup error:",
      deviceError.message,
    );

    return jsonResponse(
      req,
      {
        error:
          "Could not verify feeder device",
      },
      500,
    );
  }

  if (!device?.device_code) {
    return jsonResponse(
      req,
      {
        error:
          "Active feeder device not found",
      },
      404,
    );
  }

  // ===================================================
  // ACTION: QUEUE
  // ===================================================

  if (action === "queue") {
    // Clear stale pending commands so a dead browser session
    // cannot block testing forever.

    const cutoff =
      new Date(
        Date.now() -
          COMMAND_EXPIRATION_MS,
      ).toISOString();

    const {
      error: expireError,
    } =
      await db
        .from(
          "feeder_test_commands",
        )
        .update({
          status: "cancelled",
        })
        .eq(
          "device_code",
          device.device_code,
        )
        .eq(
          "status",
          "pending",
        )
        .lt(
          "created_at",
          cutoff,
        );

    if (expireError) {
      console.error(
        "Expiration error:",
        expireError.message,
      );

      return jsonResponse(
        req,
        {
          error:
            "Could not check old commands",
        },
        500,
      );
    }

    // Check for any existing unfinished command.

    const {
      data: outstanding,
      error: outstandingError,
    } =
      await db
        .from(
          "feeder_test_commands",
        )
        .select(
          "id, status",
        )
        .eq(
          "device_code",
          device.device_code,
        )
        .in(
          "status",
          [
            "pending",
            "claimed",
          ],
        )
        .limit(1);

    if (outstandingError) {
      console.error(
        "Command lookup error:",
        outstandingError.message,
      );

      return jsonResponse(
        req,
        {
          error:
            "Could not check pending commands",
        },
        500,
      );
    }

    if (
      outstanding?.length
    ) {
      return jsonResponse(
        req,
        {
          error:
            "There is already a pending motor test for this feeder.",
        },
        409,
      );
    }

    // Create new motor-test command.

    const {
      data: command,
      error: insertError,
    } =
      await db
        .from(
          "feeder_test_commands",
        )
        .insert({
          device_code:
            device.device_code,

          steps:
            TEST_STEPS,

          direction:
            TEST_DIRECTION,

          status:
            "pending",

          requested_by:
            authData.user.id,
        })
        .select(
          "id, device_code, steps, direction, status, created_at",
        )
        .single();

    if (
      insertError ||
      !command
    ) {
      console.error(
        "Command insertion failed:",
        insertError?.message,
      );

      return jsonResponse(
        req,
        {
          error:
            "Could not queue motor test",
        },
        500,
      );
    }

    return jsonResponse(
      req,
      {
        ok: true,

        command: {
          ...command,

          status:
            mapStatus(
              command.status,
            ),

          device_id:
            device.id,

          device_name:
            device.device_name,
        },
      },
      202,
    );
  }

  // ===================================================
  // ACTION: STATUS
  // ===================================================

  if (action === "status") {
    const commandId =
      body.command_id;

    if (
      typeof commandId !==
        "string" ||
      !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
        commandId,
      )
    ) {
      return jsonResponse(
        req,
        {
          error:
            "Invalid command ID",
        },
        400,
      );
    }

    const {
      data: command,
      error: commandError,
    } =
      await db
        .from(
          "feeder_test_commands",
        )
        .select(
          "id, device_code, steps, direction, status, created_at, claimed_at, completed_at",
        )
        .eq(
          "id",
          commandId,
        )
        .eq(
          "device_code",
          device.device_code,
        )
        .maybeSingle();

    if (commandError) {
      console.error(
        "Status lookup failed:",
        commandError.message,
      );

      return jsonResponse(
        req,
        {
          error:
            "Could not read motor-test status",
        },
        500,
      );
    }

    if (!command) {
      return jsonResponse(
        req,
        {
          error:
            "Motor-test command not found",
        },
        404,
      );
    }

    return jsonResponse(
      req,
      {
        ok: true,

        command: {
          ...command,

          status:
            mapStatus(
              command.status,
            ),

          device_id:
            device.id,

          device_name:
            device.device_name,
        },
      },
    );
  }

  // ===================================================
  // UNKNOWN ACTION
  // ===================================================

  return jsonResponse(
    req,
    {
      error: "Unknown action",
    },
    400,
  );
});