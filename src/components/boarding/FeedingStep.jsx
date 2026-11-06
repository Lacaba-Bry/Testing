import { compartmentForPeriod } from "../../utils/feederCompartments";
export default function FeedingStep({
  formData,
  updateForm,
}) {
  const feeding = formData.feeding ?? {
    method: "manual",
    schedules: [],
  };

  const schedules = feeding.schedules ?? [];

  function updateFeeding(field, value) {
    updateForm("feeding", {
      ...feeding,
      [field]: value,
    });
  }

  function changeMethod(method) {
    const updatedSchedules = schedules.map(
      (schedule) => ({
        ...schedule,

        compartment:
          method === "automatic"
            ? compartmentForPeriod(schedule.period)
            : null,

        portion: null,
      }),
    );

    updateForm("feeding", {
      ...feeding,
      method,
      schedules: updatedSchedules,
    });
  }

  function updateSchedule(index, field, value) {
    const updatedSchedules = schedules.map(
      (schedule, scheduleIndex) =>
        scheduleIndex === index
          ? {
              ...schedule,
              [field]: value,
            }
          : schedule,
    );

    updateFeeding(
      "schedules",
      updatedSchedules,
    );
  }

  function addSchedule(period) {
    const scheduleExists = schedules.some(
      (schedule) =>
        schedule.period === period,
    );

    if (scheduleExists) {
      return;
    }

    const newSchedule = {
      clientId:
        typeof crypto !== "undefined" &&
        typeof crypto.randomUUID ===
          "function"
          ? crypto.randomUUID()
          : `${period}-${Date.now()}`,

      period,
      time: "",
      instructions: "",

      compartment: feeding.method === "automatic" ? compartmentForPeriod(period) : null,

      portion: null,
    };

    updateFeeding("schedules", [
      ...schedules,
      newSchedule,
    ]);
  }

  function removeSchedule(index) {
    updateFeeding(
      "schedules",
      schedules.filter(
        (_, scheduleIndex) =>
          scheduleIndex !== index,
      ),
    );
  }

  function hasPeriod(period) {
    return schedules.some(
      (schedule) =>
        schedule.period === period,
    );
  }

  return (
    <>
      <h2>Setup Feeding</h2>

      <p className="boarding-description">
        Configure each feeding time and its
        specific instructions.
      </p>

      <label>
        Feeding Method

        <select
          value={feeding.method}
          onChange={(event) =>
            changeMethod(
              event.target.value,
            )
          }
        >
          <option value="manual">
            Manual Feeding
          </option>

          <option value="automatic">
            Automatic Feeder
          </option>
        </select>
      </label>

      <h3>Feeding Schedule</h3>

      <p className="boarding-description">
        Add a feeding period, select its time,
        and enter instructions for that meal.
      </p>

      <div className="boarding-actions">
        <button
          type="button"
          className="boarding-new-button"
          onClick={() =>
            addSchedule("morning")
          }
          disabled={hasPeriod("morning")}
        >
          + Morning
        </button>

        <button
          type="button"
          className="boarding-new-button"
          onClick={() =>
            addSchedule("afternoon")
          }
          disabled={hasPeriod("afternoon")}
        >
          + Afternoon
        </button>

        <button
          type="button"
          className="boarding-new-button"
          onClick={() =>
            addSchedule("evening")
          }
          disabled={hasPeriod("evening")}
        >
          + Evening
        </button>
      </div>

      {schedules.length === 0 && (
        <p className="boarding-description">
          Add at least one feeding schedule.
        </p>
      )}

      {schedules.map(
        (schedule, index) => (
          <div
            key={
              schedule.clientId ??
              `${schedule.period}-${index}`
            }
            className="pet-card"
          >
            <h3>
              {formatPeriod(
                schedule.period,
              )}
            </h3>

            <label>
              Feeding Time

              <input
                type="time"
                value={schedule.time}
                onChange={(event) =>
                  updateSchedule(
                    index,
                    "time",
                    event.target.value,
                  )
                }
              />
            </label>

            <label>
              Feeding Instructions

              <textarea
                value={
                  schedule.instructions ?? ""
                }
                placeholder="Enter instructions for this feeding."
                rows={3}
                onChange={(event) =>
                  updateSchedule(
                    index,
                    "instructions",
                    event.target.value,
                  )
                }
              />
            </label>

            {feeding.method === "automatic" && (
              <p className="boarding-description">
                Automatically assigned: Compartment {compartmentForPeriod(schedule.period)}
                ({formatPeriod(schedule.period)}). The feeder dispenses one configured slot per meal; no grams input is required.
              </p>
            )}

            <button
              type="button"
              className="boarding-back"
              onClick={() =>
                removeSchedule(index)
              }
            >
              Remove
            </button>
          </div>
        ),
      )}
    </>
  );
}

function formatPeriod(period) {
  if (!period) {
    return "Feeding";
  }

  return (
    period.charAt(0).toUpperCase() +
    period.slice(1)
  );
}