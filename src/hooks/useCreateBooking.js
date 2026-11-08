import { compartmentForPeriod } from "../utils/feederCompartments";
import {
  useCallback,
  useState,
} from "react";

import { supabase } from "../services/supabaseClient";
import { getFeedingValidationIssue } from "../utils/feedingValidation";

export default function useCreateBooking() {
  const [creating, setCreating] =
    useState(false);

  const [error, setError] =
    useState(null);

  const [result, setResult] =
    useState(null);

  const clearError = useCallback(() => {
    setError(null);
  }, []);

  const resetBookingResult = useCallback(() => {
    setError(null);
    setResult(null);
  }, []);

  const createBooking = useCallback(
    async (formData) => {
      setCreating(true);
      setError(null);
      setResult(null);

      try {
        validateBookingData(formData);

        const payload =
          buildBookingPayload(formData);

        const {
          data,
          error: functionError,
        } = await supabase.functions.invoke(
          "create-booking",
          {
            body: payload,
          },
        );

        if (functionError) {
          const message =
            await getFunctionErrorMessage(
              functionError,
            );

          throw new Error(message);
        }

        if (data?.error) {
          throw new Error(data.error);
        }

        if (!data?.booking?.id) {
          throw new Error(
            "The server did not return the created booking.",
          );
        }

        setResult(data);

        return data;
      } catch (createError) {
        const message =
          createError instanceof Error
            ? createError.message
            : "Unable to create the booking.";

        console.error(
          "Booking creation failed:",
          createError,
        );

        setError(message);

        throw new Error(message);
      } finally {
        setCreating(false);
      }
    },
    [],
  );

  return {
    creating,
    error,
    result,
    createBooking,
    clearError,
    resetBookingResult,
  };
}

function validateBookingData(formData) {
  if (!formData) {
    throw new Error("Booking information is missing.");
  }

  // Validate date/time inputs in the same fixed operating timezone used by
  // the Edge Function. This avoids browser/device timezone differences.
  const checkIn = parseCareFurDateTime(formData.checkIn);
  const checkOut = parseCareFurDateTime(formData.checkOut);

  if (!formData.checkIn || !Number.isFinite(checkIn)) {
    throw new Error("Select a valid check-in date.");
  }

  if (!formData.checkOut || !Number.isFinite(checkOut)) {
    throw new Error("Select a valid check-out date.");
  }

  if (checkOut <= checkIn) {
    throw new Error("Check-out must be after check-in.");
  }

  if (!formData.roomId) {
    throw new Error("Select a boarding room.");
  }

  const hasExistingPet = Boolean(formData.petId);
  const hasNewPet = Boolean(formData.newCustomer?.pet);

  if (!hasExistingPet && !hasNewPet) {
    throw new Error("Select an existing pet or enter a new pet.");
  }

  if (hasExistingPet && hasNewPet) {
    throw new Error("Choose either an existing pet or a new pet, not both.");
  }

  if (hasNewPet) {
    validateNewCustomer(formData.newCustomer);
  }

  validateFeeding(formData.feeding);
}

/**
 * Converts booking form values to comparable epoch milliseconds.
 * - YYYY-MM-DD means midnight Asia/Manila.
 * - YYYY-MM-DDTHH:mm (datetime-local) means Asia/Manila wall time.
 * - ISO strings with Z/offset retain their represented instant.
 */
function parseCareFurDateTime(value) {
  if (typeof value !== "string" || !value.trim()) return NaN;

  const normalized = value.trim();
  const localMatch = normalized.match(
    /^(\d{4})-(\d{2})-(\d{2})(?:[T ]([01]\d|2[0-3]):([0-5]\d)(?::([0-5]\d)(?:\.(\d{1,3}))?)?)?$/,
  );

  if (localMatch) {
    const [, year, month, day, hour = "00", minute = "00", second = "00", fraction = "0"] = localMatch;
    const calendar = new Date(Date.UTC(Number(year), Number(month) - 1, Number(day)));

    if (
      calendar.getUTCFullYear() !== Number(year) ||
      calendar.getUTCMonth() !== Number(month) - 1 ||
      calendar.getUTCDate() !== Number(day)
    ) {
      return NaN;
    }

    // Manila is UTC+08:00 year-round. Construct an explicit-offset ISO value
    // so the browser's local timezone cannot change the validation result.
    const milliseconds = Number(fraction.padEnd(3, "0"));
    return Date.parse(
      `${year}-${month}-${day}T${hour}:${minute}:${second}.${String(milliseconds).padStart(3, "0")}+08:00`,
    );
  }

  // Preserve only explicit-timezone timestamps as absolute instants.
  if (!/(?:Z|[+-]\d{2}:?\d{2})$/i.test(normalized)) return NaN;
  const parsed = Date.parse(normalized);
  return Number.isFinite(parsed) ? parsed : NaN;
}

function validateNewCustomer(newCustomer) {
  const owner =
    newCustomer?.owner ?? {};

  const pet =
    newCustomer?.pet ?? {};

  if (!owner.id) {
    if (!owner.full_name?.trim()) {
      throw new Error(
        "Enter the new owner's full name.",
      );
    }

    const email =
      owner.email?.trim().toLowerCase();

    if (!email) {
      throw new Error(
        "Enter the new owner's email address.",
      );
    }

    if (
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(
        email,
      )
    ) {
      throw new Error(
        "Enter a valid owner email address.",
      );
    }
  }

  if (!pet.name?.trim()) {
    throw new Error(
      "Enter the pet's name.",
    );
  }

  if (!pet.species?.trim()) {
    throw new Error(
      "Enter the pet's species.",
    );
  }

  if (
    pet.sex &&
    ![
      "male",
      "female",
      "unknown",
    ].includes(pet.sex)
  ) {
    throw new Error(
      "The selected pet sex is invalid.",
    );
  }
}

function validateFeeding(feeding) {
  const issue = getFeedingValidationIssue(feeding);

  if (issue) {
    throw new Error(
      getSubmissionFeedingMessage(issue),
    );
  }
}

function getSubmissionFeedingMessage(issue) {
  const scheduleName = issue.schedule?.period
    ? formatPeriod(issue.schedule.period)
    : `Schedule ${(issue.index ?? 0) + 1}`;

  const messages = {
    "missing-feeding": "Feeding information is missing.",
    "invalid-method": "Select a valid feeding method.",
    "missing-schedules": "Add at least one feeding schedule.",
    "missing-time": `Select a time for ${scheduleName}.`,
    "invalid-time": `${scheduleName} has an invalid time.`,
    "invalid-instructions": `${scheduleName} has invalid feeding instructions.`,
    "invalid-compartment": `Select compartment 1, 2, or 3 for ${scheduleName}.`,
    "invalid-portion": `Automatic feeding uses fixed compartments for ${scheduleName}.`,
  };

  return messages[issue.code] || "Invalid feeding information.";
}

function buildBookingPayload(formData) {
  const feeding =
    formData.feeding ?? {};

  const newCustomer =
    formData.newCustomer
      ? {
          owner: {
            id:
              formData.newCustomer
                .owner?.id ?? null,

            fullName:
              formData.newCustomer
                .owner?.full_name
                ?.trim() || null,

            email:
              formData.newCustomer
                .owner?.email
                ?.trim()
                .toLowerCase() ||
              null,

            phone:
              formData.newCustomer
                .owner?.phone
                ?.trim() || null,
          },

          pet: {
            name:
              formData.newCustomer
                .pet?.name
                ?.trim() || "",

            species:
              formData.newCustomer
                .pet?.species
                ?.trim()
                .toLowerCase() || "",

            breed:
              formData.newCustomer
                .pet?.breed
                ?.trim() || null,

            sex:
              formData.newCustomer
                .pet?.sex || null,
          },

          isNewOwner:
            Boolean(
              formData.newCustomer
                .isNewOwner,
            ),
        }
      : null;

  return {
    checkInAt:
      formData.checkIn,

    expectedCheckOutAt:
      formData.checkOut,

    roomId:
      formData.roomId,

    existingPetId:
      formData.petId ?? null,

    existingOwnerId:
      formData.ownerId ?? null,

    newCustomer,

    feeding: {
      method:
        feeding.method,

      schedules:
        (
          feeding.schedules ?? []
        ).map((schedule) => ({
          period:
            schedule.period ?? null,

          time:
            schedule.time,

          instructions:
            schedule.instructions
              ?.trim() || null,

          compartmentNumber:
            feeding.method ===
            "automatic"
              ? compartmentForPeriod(schedule.period)
              : null,

          portionGrams: null,
        })),
    },

    // Boarding dates and feeding times follow CareFur's hotel timezone,
    // regardless of the workstation/browser timezone.
    timeZone: "Asia/Manila",
  };
}

function formatPeriod(period) {
  return (
    period.charAt(0).toUpperCase() +
    period.slice(1)
  );
}

async function getFunctionErrorMessage(
  functionError,
) {
  let message =
    functionError?.message ||
    "Unable to create the booking.";

  try {
    const response =
      functionError?.context;

    if (
      response &&
      typeof response.json ===
        "function"
    ) {
      const body =
        await response.json();

      if (body?.error) {
        message = body.error;
      }
    }
  } catch (responseError) {
    console.warn(
      "Unable to read booking function error:",
      responseError,
    );
  }

  return message;
}
