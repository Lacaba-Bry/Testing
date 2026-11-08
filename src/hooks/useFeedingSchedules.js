import { useCallback, useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient";

export default function useFeedingSchedules(selectedDate = null) {
  const [schedules, setSchedules] = useState([]);
  const [loading, setLoading] = useState(true);
  const [updatingId, setUpdatingId] = useState(null);
  const [error, setError] = useState("");
  const [refreshKey, setRefreshKey] = useState(0);

  const refetchSchedules = useCallback(() => setRefreshKey((value) => value + 1), []);

  // Show hardware-confirmed automatic feeding results without staff clicking Refresh.
  useEffect(() => {
    const id = setInterval(() => setRefreshKey((value) => value + 1), 15000);
    return () => clearInterval(id);
  }, []);

  useEffect(() => {
    let cancelled = false;

    async function fetchSchedules() {
      setLoading(true);
      setError("");

      try {
        let query = supabase
          .from("feeding_schedules")
          .select(`
            id,
            booking_id,
            scheduled_at,
            feeding_method,
            compartment_number,
            portion_grams,
            instructions,
            status,
            booking:bookings!feeding_schedules_booking_id_fkey (
              id,
              booking_code,
              pet:pets!bookings_pet_id_fkey (id, name, species, breed),
              room:rooms!bookings_room_id_fkey (id, room_number, room_name)
            )
          `)
          .order("scheduled_at", { ascending: true });

        if (selectedDate) {
          // selectedDate is a Philippine calendar date (YYYY-MM-DD).
          // Use explicit +08:00 offsets instead of the browser timezone.
          const [year, month, day] = selectedDate.split("-").map(Number);
          const nextDay = new Date(Date.UTC(year, month - 1, day + 1));
          const nextDateKey = [
            nextDay.getUTCFullYear(),
            String(nextDay.getUTCMonth() + 1).padStart(2, "0"),
            String(nextDay.getUTCDate()).padStart(2, "0"),
          ].join("-");

          const startUtc = new Date(`${selectedDate}T00:00:00+08:00`).toISOString();
          const endUtc = new Date(`${nextDateKey}T00:00:00+08:00`).toISOString();

          query = query.gte("scheduled_at", startUtc).lt("scheduled_at", endUtc);
        }

        const { data, error: fetchError } = await query;
        if (fetchError) throw fetchError;
        if (!cancelled) setSchedules(data ?? []);
      } catch (fetchError) {
        console.error("Failed to load feeding schedules:", fetchError);
        if (!cancelled) {
          setSchedules([]);
          setError(fetchError?.message || "Unable to load feeding schedules.");
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    fetchSchedules();
    return () => { cancelled = true; };
  }, [selectedDate, refreshKey]);

  const toggleFeedingStatus = useCallback(async (scheduleId, currentStatus) => {
    // UI and DB both reject manual completion of automatic schedules.
    const existing = schedules.find((item) => item.id === scheduleId);
    if (!existing || existing.feeding_method !== "manual") {
      const issue = new Error("Automatic feeding results are updated by the feeder, not by staff.");
      setError(issue.message);
      throw issue;
    }
    const nextStatus = currentStatus === "completed" ? "pending" : "completed";
    setUpdatingId(scheduleId);
    setError("");

    try {
      const { data, error: updateError } = await supabase
        .from("feeding_schedules")
        .update({ status: nextStatus })
        .eq("id", scheduleId)
        .select("id, status")
        .single();

      if (updateError) throw updateError;
      setSchedules((items) => items.map((item) => item.id === scheduleId ? { ...item, status: data.status } : item));
      return data;
    } catch (updateError) {
      console.error("Failed to update feeding status:", updateError);
      setError(updateError?.message || "Failed to update feeding status.");
      throw updateError;
    } finally {
      setUpdatingId(null);
    }
  }, [schedules]);

  return { schedules, loading, updatingId, error, toggleFeedingStatus, refetchSchedules };
}
