import { useCallback, useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient";

// Read-only monitoring: all writes are performed by authenticated ESP32 Edge Function.
export default function useFeederFood(deviceCode = null) {
  const [state, setState] = useState(null);
  const [events, setEvents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const refresh = useCallback(async () => {
    try {
      let stateQuery = supabase.from("feeder_food_state")
        .select("device_code,weight_estimate_g,state,updated_at")
        .order("updated_at", { ascending: false }).limit(1);
      let eventQuery = supabase.from("feeder_food_events")
        .select("id,device_code,event_type,weight_estimate_g,weight_change_g,message,created_at")
        .order("created_at", { ascending: false }).limit(30);
      if (deviceCode) {
        stateQuery = stateQuery.eq("device_code", deviceCode);
        eventQuery = eventQuery.eq("device_code", deviceCode);
      }
      const [stateResult, eventResult] = await Promise.all([stateQuery, eventQuery]);
      if (stateResult.error) throw stateResult.error;
      if (eventResult.error) throw eventResult.error;
      setState(stateResult.data?.[0] ?? null);
      setEvents(eventResult.data ?? []);
      setError("");
    } catch (err) {
      setError(err.message || "Cannot load feeder telemetry. Verify staff SELECT policies.");
    } finally { setLoading(false); }
  }, [deviceCode]);
  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 5000);
    const filter = deviceCode ? `device_code=eq.${deviceCode}` : undefined;
    const channel = supabase.channel(`food-monitor-${deviceCode || "all"}`)
      .on("postgres_changes", { event: "*", schema: "public", table: "feeder_food_state", ...(filter ? { filter } : {}) }, refresh)
      .on("postgres_changes", { event: "INSERT", schema: "public", table: "feeder_food_events", ...(filter ? { filter } : {}) }, refresh)
      .subscribe();
    return () => { clearInterval(timer); supabase.removeChannel(channel); };
  }, [refresh, deviceCode]);
  return { state, events, loading, error, refresh };
}
