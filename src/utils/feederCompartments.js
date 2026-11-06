// One fixed compartment for each meal, matching the 3-slot physical feeder.
export const FEEDER_COMPARTMENTS = Object.freeze({ morning: 1, afternoon: 2, evening: 3 });
export function compartmentForPeriod(period) {
  return FEEDER_COMPARTMENTS[String(period || "").toLowerCase()] ?? null;
}
