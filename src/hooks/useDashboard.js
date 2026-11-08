import { useCallback, useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient";

const INITIAL_STATE = {
  boardedPets: 0,
  feedingsDue: [],
  manualFeedings: [],
  activeAlerts: [],
  camerasOnline: 0,
  camerasOffline: 0,
  recentActivity: [],
  arrivals: [],
  departures: [],
  occupiedRooms: [],
  rooms: [],
  cameras: [],
  feeders: [],
  feederTelemetry: [],
  feederTelemetryAvailable: false,
  upcomingFeedings: [],
  pendingPayments: 0,
  pendingExtensions: 0,
  overdueCheckouts: 0,
  overdueFeedings: 0,
};

const DEVICE_STALE_MS = 5 * 60 * 1000;

function resultData(result) {
  return result.status === "fulfilled" && !result.value?.error ? result.value : null;
}

function failedSources(results, names) {
  return results.flatMap((result, index) => resultData(result) ? [] : [names[index]]);
}

export default function useDashboard() {
  const [dashboardData, setDashboardData] = useState(INITIAL_STATE);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const fetchDashboardData = useCallback(async () => {
    try {
      setLoading(true);
      setError("");

      const now = new Date();
      const nowISO = now.toISOString();
      const dayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate()).toISOString();
      const dayEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1).toISOString();
      const feedWindowStart = new Date(now.getTime() - 24 * 60 * 60 * 1000).toISOString();
      const feedWindowEnd = new Date(now.getTime() + 3 * 60 * 60 * 1000).toISOString();

      const results = await Promise.allSettled([
        supabase.from("bookings").select("id", { count: "exact", head: true }).eq("status", "checked_in"),
        supabase.from("feeding_schedules").select(`id,scheduled_at,feeding_method,status,instructions,compartment_number,booking:bookings!feeding_schedules_booking_id_fkey(id,pet:pets!bookings_pet_id_fkey(id,name),room:rooms!bookings_room_id_fkey(id,room_number,room_name))`).eq("feeding_method", "automatic").eq("status", "pending").gte("scheduled_at", feedWindowStart).lte("scheduled_at", feedWindowEnd).order("scheduled_at").limit(100),
        supabase.from("feeding_schedules").select(`id,scheduled_at,feeding_method,status,instructions,compartment_number,booking:bookings!feeding_schedules_booking_id_fkey(id,pet:pets!bookings_pet_id_fkey(id,name),room:rooms!bookings_room_id_fkey(id,room_number,room_name))`).eq("feeding_method", "manual").eq("status", "pending").gte("scheduled_at", feedWindowStart).lte("scheduled_at", feedWindowEnd).order("scheduled_at").limit(100),
        supabase.from("alerts").select(`id,alert_type,severity,title,message,status,created_at,booking:bookings!alerts_booking_id_fkey(id,room:rooms!bookings_room_id_fkey(id,room_number,room_name)),device:devices!alerts_device_id_fkey(id,device_code,device_name,device_type)`).eq("status", "active").order("created_at", { ascending: false }).limit(50),
        supabase.from("devices").select("id,device_code,device_name,device_type,status,last_seen_at").in("device_type", ["camera", "feeder"]).neq("status", "retired"),
        supabase.from("bookings").select("id,booking_code,status,check_in_at,expected_check_out_at,pet:pets!bookings_pet_id_fkey(id,name),room:rooms!bookings_room_id_fkey(id,room_number,room_name)").gte("check_in_at", dayStart).lt("check_in_at", dayEnd).in("status", ["pending", "confirmed"]).order("check_in_at").limit(100),
        supabase.from("bookings").select("id,booking_code,status,check_in_at,expected_check_out_at,pet:pets!bookings_pet_id_fkey(id,name),room:rooms!bookings_room_id_fkey(id,room_number,room_name)").gte("expected_check_out_at", dayStart).lt("expected_check_out_at", dayEnd).eq("status", "checked_in").order("expected_check_out_at").limit(100),
        supabase.from("bookings").select("id,room_id,status,pet:pets!bookings_pet_id_fkey(id,name)").eq("status", "checked_in").limit(1000),
        supabase.from("rooms").select("id,room_number,room_name,status,capacity,maintenance_until,status_reason").order("room_number").limit(1000),
        supabase.from("activity_logs").select("id,action,entity_type,entity_id,description,created_at,actor:users!activity_logs_actor_user_id_fkey(id,full_name)").order("created_at", { ascending: false }).limit(8),
        supabase.from("reservation_requests").select("id", { count: "exact", head: true }).eq("status", "pending_payment"),
        supabase.from("boarding_extension_requests").select("id", { count: "exact", head: true }).eq("status", "pending"),
        supabase.from("bookings").select("id", { count: "exact", head: true }).eq("status", "checked_in").lt("expected_check_out_at", nowISO),
        supabase.from("feeding_schedules").select("id,booking:bookings!inner(id,status)", { count: "exact", head: true }).eq("status", "pending").lt("scheduled_at", nowISO).eq("booking.status", "checked_in"),
        supabase.from("feeder_food_state").select("device_code,updated_at,state,weight_estimate_g"),
      ]);

      const names = ["active boardings", "automatic feedings", "manual feedings", "alerts", "devices", "arrivals", "departures", "occupancy", "rooms", "recent activity", "pending payments", "extension requests", "overdue checkouts", "overdue feedings", "feeder telemetry"];
      const values = results.map(resultData);
      const failures = failedSources(results, names);
      const [boardings, automatic, manual, alerts, devices, arrivals, departures, occupied, rooms, activity, payments, extensions, overdueOut, overdueMeals, telemetry] = values;

      const deviceRows = devices?.data ?? [];
      const currentMs = Date.now();
      const cameras = deviceRows.filter((device) => device.device_type === "camera");
      const feeders = deviceRows.filter((device) => device.device_type === "feeder");
      const online = cameras.filter((device) => device.status === "active" && device.last_seen_at && currentMs - new Date(device.last_seen_at).getTime() <= DEVICE_STALE_MS);
      const staleTelemetry = telemetry?.data ?? [];

      setDashboardData((old) => {
        const autoRows = automatic?.data ?? old.feedingsDue;
        const manualRows = manual?.data ?? old.manualFeedings;
        return {
          ...old,
          boardedPets: boardings ? boardings.count ?? 0 : old.boardedPets,
          feedingsDue: automatic ? automatic.data ?? [] : old.feedingsDue,
          manualFeedings: manual ? manual.data ?? [] : old.manualFeedings,
          activeAlerts: alerts ? alerts.data ?? [] : old.activeAlerts,
          cameras: devices ? cameras : old.cameras,
          feeders: devices ? feeders : old.feeders,
          camerasOnline: devices ? online.length : old.camerasOnline,
          camerasOffline: devices ? Math.max(cameras.length - online.length, 0) : old.camerasOffline,
          feederTelemetry: telemetry ? staleTelemetry : old.feederTelemetry,
          feederTelemetryAvailable: telemetry ? true : old.feederTelemetryAvailable,
          arrivals: arrivals ? arrivals.data ?? [] : old.arrivals,
          departures: departures ? departures.data ?? [] : old.departures,
          occupiedRooms: occupied ? occupied.data ?? [] : old.occupiedRooms,
          rooms: rooms ? rooms.data ?? [] : old.rooms,
          recentActivity: activity ? activity.data ?? [] : old.recentActivity,
          upcomingFeedings: [...autoRows, ...manualRows].sort((a, b) => new Date(a.scheduled_at) - new Date(b.scheduled_at)),
          pendingPayments: payments ? payments.count ?? 0 : old.pendingPayments,
          pendingExtensions: extensions ? extensions.count ?? 0 : old.pendingExtensions,
          overdueCheckouts: overdueOut ? overdueOut.count ?? 0 : old.overdueCheckouts,
          overdueFeedings: overdueMeals ? overdueMeals.count ?? 0 : old.overdueFeedings,
        };
      });

      setError(failures.length ? `Some dashboard data could not be loaded: ${failures.join(", ")}. Other sections remain available; retry to refresh.` : "");
    } catch (fetchError) {
      console.error("Failed to load CareFur dashboard:", fetchError);
      setError(fetchError?.message || "Unable to load the dashboard.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void fetchDashboardData();
    const channel = supabase.channel("carefur-dashboard")
      .on("postgres_changes", { event: "*", schema: "public", table: "bookings" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "feeding_schedules" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "alerts" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "devices" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "rooms" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "reservation_requests" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "boarding_extension_requests" }, fetchDashboardData)
      .on("postgres_changes", { event: "*", schema: "public", table: "feeder_food_state" }, fetchDashboardData)
      .on("postgres_changes", { event: "INSERT", schema: "public", table: "activity_logs" }, fetchDashboardData)
      .subscribe();
    const timer = window.setInterval(() => void fetchDashboardData(), 60000);
    return () => { window.clearInterval(timer); void supabase.removeChannel(channel); };
  }, [fetchDashboardData]);

  return { ...dashboardData, loading, error, refresh: fetchDashboardData };
}
