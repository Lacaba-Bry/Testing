
import {
  createClient
} from "jsr:@supabase/supabase-js@2";

// =====================================================
// CAREFUR SMART FEEDER
// Edge Function: feeder-rotate
// =====================================================

// Device authentication

const DEVICE_SECRET =
  Deno.env.get("DEVICE_SECRET");

const DEVICE_CODE =
  "carefur-feeder-01";

// Supabase server configuration

const SUPABASE_URL =
  Deno.env.get("SUPABASE_URL");

const SERVICE_ROLE_KEY =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

// Maximum age of an unclaimed test command

const COMMAND_EXPIRATION_MS =
  5 * 60 * 1000;

// Allowed test movements

const ALLOWED_STEPS = [
  50,
  100,
  267,
  533
];

const ALLOWED_EVENTS = [
  "rotation_started",
  "rotation_completed",
  "rotation_failed"
];

// =====================================================
// DATABASE CLIENT
// =====================================================

function getDatabase() {

  if (
    !SUPABASE_URL ||
    !SERVICE_ROLE_KEY
  ) {
    throw new Error(
      "Supabase server configuration missing"
    );
  }

  return createClient(
    SUPABASE_URL,
    SERVICE_ROLE_KEY,
    {
      auth: {
        persistSession: false,
        autoRefreshToken: false
      }
    }
  );
}

// =====================================================
// JSON RESPONSE
// =====================================================

function jsonResponse(
  data: Record<string, unknown>,
  status = 200
): Response {

  return new Response(
    JSON.stringify(data),
    {
      status,
      headers: {
        "Content-Type": "application/json",
        "Cache-Control": "no-store"
      }
    }
  );
}

// =====================================================
// VALIDATE DEVICE
// =====================================================

function isValidDevice(
  body: Record<string, unknown>
): boolean {

  const deviceCode =
    body.device_code ?? body.device_id;

  return deviceCode === DEVICE_CODE;
}

// =====================================================
// ACTION: PING
// =====================================================

function handlePing() {

  console.log(
    "CareFur device connected:",
    DEVICE_CODE
  );

  return jsonResponse({
    ok: true,
    message: "CareFur ESP32 connected",
    device_id: DEVICE_CODE,
    server_time: new Date().toISOString()
  });
}

// =====================================================
// ACTION: CLAIM MOTOR COMMAND
// =====================================================

async function handleClaim() {

  const db = getDatabase();

  // -------------------------------------
  // 1. EXPIRE OLD PENDING COMMANDS
  // -------------------------------------

  const cutoff = new Date(
    Date.now() - COMMAND_EXPIRATION_MS
  ).toISOString();

  const {
    error: expirationError
  } = await db
    .from("feeder_test_commands")
    .update({
      status: "cancelled"
    })
    .eq("device_code", DEVICE_CODE)
    .eq("status", "pending")
    .lt("created_at", cutoff);

  if (expirationError) {

    console.error(
      "Command expiration error:",
      expirationError.message
    );

    return jsonResponse(
      {
        ok: false,
        error: "Could not check expired commands"
      },
      500
    );
  }

  // -------------------------------------
  // 2. CHECK FOR A CLAIMED COMMAND
  // -------------------------------------

  // A previously claimed command must
  // never be delivered for execution again.

  const {
    data: activeCommand,
    error: activeError
  } = await db
    .from("feeder_test_commands")
    .select("id")
    .eq("device_code", DEVICE_CODE)
    .eq("status", "claimed")
    .limit(1);

  if (activeError) {

    console.error(
      "Active command lookup failed:",
      activeError.message
    );

    return jsonResponse(
      {
        ok: false,
        error: "Could not check active command"
      },
      500
    );
  }

  if (activeCommand?.length) {

    return jsonResponse({
      ok: true,
      rotate: false,
      message:
        "A command is already claimed. Resolve it before requesting another movement."
    });
  }

  // -------------------------------------
  // 3. FIND NEXT PENDING COMMAND
  // -------------------------------------

  const {
    data: pending,
    error: pendingError
  } = await db
    .from("feeder_test_commands")
    .select(
      "id, device_code, steps, direction, status, created_at"
    )
    .eq("device_code", DEVICE_CODE)
    .eq("status", "pending")
    .gte("created_at", cutoff)
    .order("created_at", {
      ascending: true
    })
    .limit(1)
    .maybeSingle();

  if (pendingError) {

    console.error(
      "Pending command lookup failed:",
      pendingError.message
    );

    return jsonResponse(
      {
        ok: false,
        error: "Could not retrieve motor command"
      },
      500
    );
  }

  if (!pending) {

    return jsonResponse({
      ok: true,
      rotate: false,
      message: "No pending motor commands"
    });
  }

  // -------------------------------------
  // 4. VALIDATE COMMAND
  // -------------------------------------

  if (
    !ALLOWED_STEPS.includes(pending.steps) ||
    !["clockwise", "counterclockwise"]
      .includes(pending.direction)
  ) {

    await db
      .from("feeder_test_commands")
      .update({
        status: "cancelled"
      })
      .eq("id", pending.id)
      .eq("status", "pending");

    return jsonResponse(
      {
        ok: false,
        error: "Invalid motor command"
      },
      400
    );
  }

  // -------------------------------------
  // 5. ATOMICALLY CLAIM COMMAND
  // -------------------------------------

  // The status condition is checked when
  // the database performs the UPDATE.
  //
  // A command that another request has
  // already claimed cannot be claimed again.

  const {
    data: claimed,
    error: claimError
  } = await db
    .from("feeder_test_commands")
    .update({
      status: "claimed",
      claimed_at: new Date().toISOString()
    })
    .eq("id", pending.id)
    .eq("device_code", DEVICE_CODE)
    .eq("status", "pending")
    .gte("created_at", cutoff)
    .select(
      "id, device_code, steps, direction, status"
    )
    .maybeSingle();

  if (claimError) {

    console.error(
      "Command claim failed:",
      claimError.message
    );

    return jsonResponse(
      {
        ok: false,
        error: "Could not claim motor command"
      },
      500
    );
  }

  if (!claimed) {

    return jsonResponse({
      ok: true,
      rotate: false,
      message: "Command is no longer available"
    });
  }

  // -------------------------------------
  // 6. DELIVER CLAIMED COMMAND
  // -------------------------------------

  console.log(
    "Motor command claimed:",
    claimed.id
  );

  return jsonResponse({
    ok: true,
    rotate: true,
    command_id: claimed.id,
    device_code: claimed.device_code,
    steps: claimed.steps,
    direction: claimed.direction,
    status: "claimed"
  });
}

// =====================================================
// ACTION: COMPLETE MOTOR COMMAND
// =====================================================

async function handleComplete(
  body: Record<string, unknown>
) {

  const commandId = body.command_id;

  const result = body.result;

  // -------------------------------------
  // 1. VALIDATE ACKNOWLEDGMENT
  // -------------------------------------

  if (
    typeof commandId !== "string" ||
    !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
      .test(commandId)
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid command ID"
      },
      400
    );
  }

  if (
    result !== "completed" &&
    result !== "failed"
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid command result"
      },
      400
    );
  }

  const db = getDatabase();

  // -------------------------------------
  // 2. UPDATE CLAIMED COMMAND
  // -------------------------------------

  const {
    data: updated,
    error
  } = await db
    .from("feeder_test_commands")
    .update({
      status: result,
      completed_at: new Date().toISOString()
    })
    .eq("id", commandId)
    .eq("device_code", DEVICE_CODE)
    .eq("status", "claimed")
    .select("id, status")
    .maybeSingle();

  if (error) {

    console.error(
      "Command completion error:",
      error.message
    );

    return jsonResponse(
      {
        ok: false,
        error: "Could not update motor command"
      },
      500
    );
  }

  if (!updated) {

    // If the acknowledgment was already
    // accepted, do not treat a repeated
    // acknowledgment as a new execution.

    const {
      data: existing,
      error: lookupError
    } = await db
      .from("feeder_test_commands")
      .select("id, status")
      .eq("id", commandId)
      .eq("device_code", DEVICE_CODE)
      .maybeSingle();

    if (lookupError) {

      return jsonResponse(
        {
          ok: false,
          error: "Could not verify command status"
        },
        500
      );
    }

    if (
      existing &&
      existing.status === result
    ) {

      return jsonResponse({
        ok: true,
        command_id: existing.id,
        status: existing.status,
        already_acknowledged: true
      });
    }

    return jsonResponse(
      {
        ok: false,
        error:
          "Command is not claimable or is in a different final state"
      },
      409
    );
  }

  // -------------------------------------
  // 3. RETURN CONFIRMATION
  // -------------------------------------

  console.log(
    "Motor command acknowledged:",
    commandId,
    result
  );

  return jsonResponse({
    ok: true,
    message: "Motor command acknowledged",
    command_id: updated.id,
    status: updated.status
  });
}

// =====================================================
// ACTION: REPORT MOTOR EVENT
// =====================================================

function handleEvent(
  body: Record<string, unknown>
) {

  const event = body.event;

  const steps = body.steps;

  const direction = body.direction;

  if (
    typeof event !== "string" ||
    !ALLOWED_EVENTS.includes(event)
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid rotation event"
      },
      400
    );
  }

  if (
    typeof steps !== "number" ||
    !Number.isInteger(steps) ||
    steps < 1 ||
    steps > 10000
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid motor steps"
      },
      400
    );
  }

  if (
    direction !== "clockwise" &&
    direction !== "counterclockwise"
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid direction"
      },
      400
    );
  }

  const rawWeight = body.raw_weight;

  if (
    rawWeight !== undefined &&
    (
      typeof rawWeight !== "number" ||
      !Number.isFinite(rawWeight)
    )
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid raw weight"
      },
      400
    );
  }

  const source =
    typeof body.source === "string"
      ? body.source
      : "esp32";

  console.log(
    "CareFur motor event:",
    {
      device_code: DEVICE_CODE,
      event,
      steps,
      direction,
      source,
      raw_weight: rawWeight ?? null
    }
  );

  return jsonResponse({
    ok: true,
    message: "Motor rotation event received",
    device_code: DEVICE_CODE,
    event,
    steps,
    direction,
    source,
    raw_weight: rawWeight ?? null,
    received_at: new Date().toISOString()
  });
}

// =====================================================
// MAIN EDGE FUNCTION
// =====================================================

Deno.serve(async (req: Request) => {

  // -------------------------------------
  // 1. REQUIRE POST
  // -------------------------------------

  if (req.method !== "POST") {

    return jsonResponse(
      {
        ok: false,
        error: "Method not allowed"
      },
      405
    );
  }

  // -------------------------------------
  // 2. AUTHENTICATE ESP32
  // -------------------------------------

  const receivedSecret =
    req.headers.get("x-device-secret");

  if (!DEVICE_SECRET) {

    console.error(
      "DEVICE_SECRET is not configured"
    );

    return jsonResponse(
      {
        ok: false,
        error: "Device authentication unavailable"
      },
      500
    );
  }

  if (
    !receivedSecret ||
    receivedSecret !== DEVICE_SECRET
  ) {

    return jsonResponse(
      {
        ok: false,
        error: "Unauthorized device"
      },
      401
    );
  }

  // -------------------------------------
  // 3. PARSE JSON
  // -------------------------------------

  let body: Record<string, unknown>;

  try {

    const parsed: unknown =
      await req.json();

    if (
      typeof parsed !== "object" ||
      parsed === null ||
      Array.isArray(parsed)
    ) {

      throw new Error("Invalid JSON body");
    }

    body =
      parsed as Record<string, unknown>;

  } catch {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid JSON request"
      },
      400
    );
  }

  // -------------------------------------
  // 4. VALIDATE DEVICE IDENTIFIER
  // -------------------------------------

  if (!isValidDevice(body)) {

    return jsonResponse(
      {
        ok: false,
        error: "Invalid device ID"
      },
      400
    );
  }

  const action =
    body.action ?? "event";

  // -------------------------------------
  // 5. HANDLE REQUEST
  // -------------------------------------

  try {

    switch (action) {

      case "ping":
        return handlePing();

      case "claim":
        return await handleClaim();

      case "complete":
        return await handleComplete(body);

      case "poll":
        return await handleClaim();

      case "event":
        return handleEvent(body);

      default:

        return jsonResponse(
          {
            ok: false,
            error: "Unknown action"
          },
          400
        );
    }

  } catch (error) {

    console.error(
      "CareFur feeder error:",
      error
    );

    return jsonResponse(
      {
        ok: false,
        error: "Internal server error"
      },
      500
    );
  }

});