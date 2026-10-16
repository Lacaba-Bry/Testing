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
  arrivals: [], departures: [], occupiedRooms: [], rooms: [], cameras: [], upcomingFeedings: [],
};

const CAMERA_OFFLINE_THRESHOLD_MS = 5 * 60 * 1000;

function getQueryResult(result) {
  if (
    result.status !== "fulfilled" ||
    result.value?.error
  ) {
    return null;
  }

  return result.value;
}

function getFailedSources(results, sourceNames) {
  return results.flatMap((result, index) =>
    getQueryResult(result) ? [] : [sourceNames[index]],
  );
}

export default function useDashboard() {
  const [dashboardData, setDashboardData] =
    useState(INITIAL_STATE);

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const fetchDashboardData = useCallback(async () => {
    try {
      setLoading(true);
      setError("");

      const now = new Date();

      /*
       * Show pending feedings from two hours ago
       * until one hour from now.
       */
      const feedingWindowStart = new Date(
        now.getTime() - 24 * 60 * 60 * 1000
      ).toISOString();

      const feedingWindowEnd = new Date(
        now.getTime() + 3 * 60 * 60 * 1000
      ).toISOString();

      const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate()).toISOString();
      const todayEnd = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1).toISOString();
      const results = await Promise.allSettled([
        supabase
          .from("bookings")
          .select("id", {
            count: "exact",
            head: true,
          })
          .eq("status", "checked_in"),

        supabase
          .from("feeding_schedules")
          .select(`
            id,
            scheduled_at,
            feeding_method,
            status,
            instructions,
            compartment_number,
            booking:bookings!feeding_schedules_booking_id_fkey (
              id,
              pet:pets!bookings_pet_id_fkey (
                id,
                name
              ),
              room:rooms!bookings_room_id_fkey (
                id,
                room_number,
                room_name
              )
            )
          `)
          .eq("feeding_method", "automatic")
          .eq("status", "pending")
          .gte("scheduled_at", feedingWindowStart)
          .lte("scheduled_at", feedingWindowEnd)
          .order("scheduled_at", { ascending: true })
          .limit(30),

        supabase
          .from("feeding_schedules")
          .select(`
            id,
            scheduled_at,
            feeding_method,
            status,
            instructions,
            compartment_number,
            booking:bookings!feeding_schedules_booking_id_fkey (
              id,
              pet:pets!bookings_pet_id_fkey (
                id,
                name
              ),
              room:rooms!bookings_room_id_fkey (
                id,
                room_number,
                room_name
              )
            )
          `)
          .eq("feeding_method", "manual")
          .eq("status", "pending")
          .gte("scheduled_at", feedingWindowStart)
          .lte("scheduled_at", feedingWindowEnd)
          .order("scheduled_at", { ascending: true })
          .limit(30),

        supabase
          .from("alerts")
          .select(`
            id,
            alert_type,
            severity,
            title,
            message,
            status,
            created_at,
            booking:bookings!alerts_booking_id_fkey (
              id,
              room:rooms!bookings_room_id_fkey (
                id,
                room_number,
                room_name
              )
            ),
            device:devices!alerts_device_id_fkey (
              id,
              device_code,
              device_name,
              device_type
            )
          `)
          .eq("status", "active")
          .order("created_at", { ascending: false })
          .limit(30),

        supabase
          .from("devices")
          .select(`
            id,
            device_code,
            device_name,
            device_type,
            status,
            last_seen_at
          `)
          .eq("device_type", "camera")
          .neq("status", "retired"),

        supabase.from("bookings").select(`id,booking_code,status,check_in_at,expected_check_out_at,pet:pets!bookings_pet_id_fkey(id,name),room:rooms!bookings_room_id_fkey(id,room_number,room_name)`).gte("check_in_at", todayStart).lt("check_in_at", todayEnd).order("check_in_at").limit(100),
        supabase.from("bookings").select(`id,booking_code,status,check_in_at,expected_check_out_at,pet:pets!bookings_pet_id_fkey(id,name),room:rooms!bookings_room_id_fkey(id,room_number,room_name)`).gte("expected_check_out_at", todayStart).lt("expected_check_out_at", todayEnd).order("expected_check_out_at").limit(100),
        supabase.from("bookings").select(`id,room_id,status,pet:pets!bookings_pet_id_fkey(id,name)`).eq("status","checked_in").limit(1000),
        supabase.from("rooms").select("id,room_number,room_name,status,capacity").order("room_number").limit(1000),
        supabase
          .from("activity_logs")
          .select(`
            id,
            action,
            entity_type,
            entity_id,
            description,
            created_at,
            actor:users!activity_logs_actor_user_id_fkey (
              id,
              full_name
            )
          `)
          .order("created_at", { ascending: false })
          .limit(5),
      ]);

      const [
        bookingsResult,
        automaticFeedingsResult,
        manualFeedingsResult,
        alertsResult,
        camerasResult,
        arrivalsResult, departuresResult, occupiedResult, roomsResult,
        activityResult,
      ] = results.map(getQueryResult);

      const failedSources = getFailedSources(results, [
        "boarded pets",
        "automatic feedings",
        "manual feedings",
        "alerts",
        "cameras",
        "arrivals", "departures", "occupancy", "rooms",
        "recent activity",
      ]);

      const cameras = camerasResult?.data ?? [];
      const currentTime = Date.now();

      const camerasOnline = cameras.filter((camera) => {
        if (
          camera.status !== "active" ||
          !camera.last_seen_at
        ) {
          return false;
        }

        const lastSeenTime = new Date(
          camera.last_seen_at
        ).getTime();

        return (
          currentTime - lastSeenTime <=
          CAMERA_OFFLINE_THRESHOLD_MS
        );
      }).length;

      setDashboardData((currentData) => ({
        boardedPets: bookingsResult
          ? bookingsResult.count ?? 0
          : currentData.boardedPets,
        feedingsDue: automaticFeedingsResult
          ? automaticFeedingsResult.data ?? []
          : currentData.feedingsDue,
        manualFeedings: manualFeedingsResult
          ? manualFeedingsResult.data ?? []
          : currentData.manualFeedings,
        activeAlerts: alertsResult
          ? alertsResult.data ?? []
          : currentData.activeAlerts,
        camerasOnline: camerasResult
          ? camerasOnline
          : currentData.camerasOnline,
        camerasOffline: camerasResult
          ? Math.max(cameras.length - camerasOnline, 0)
          : currentData.camerasOffline,
        arrivals: arrivalsResult ? arrivalsResult.data ?? [] : currentData.arrivals,
        departures: departuresResult ? departuresResult.data ?? [] : currentData.departures,
        occupiedRooms: occupiedResult ? occupiedResult.data ?? [] : currentData.occupiedRooms,
        rooms: roomsResult ? roomsResult.data ?? [] : currentData.rooms,
        cameras: camerasResult ? cameras : currentData.cameras,
        upcomingFeedings: [...(automaticFeedingsResult?.data ?? currentData.feedingsDue), ...(manualFeedingsResult?.data ?? currentData.manualFeedings)].sort((a,b)=>new Date(a.scheduled_at)-new Date(b.scheduled_at)),
        recentActivity: activityResult
          ? activityResult.data ?? []
          : currentData.recentActivity,
      }));

      setError(
        failedSources.length > 0
          ? `Some dashboard data could not be loaded: ${failedSources.join(", ")}.`
          : "",
      );
    } catch (fetchError) {
      console.error(
        "Failed to load CareFur dashboard:",
        fetchError
      );

      setError(
        fetchError.message ||
          "Unable to load the dashboard."
      );
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchDashboardData();

    const realtimeChannel = supabase
      .channel("carefur-dashboard")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "bookings",
        },
        fetchDashboardData
      )
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "feeding_schedules",
        },
        fetchDashboardData
      )
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "alerts",
        },
        fetchDashboardData
      )
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "devices",
        },
        fetchDashboardData
      )
      .on(
        "postgres_changes",
        {
          event: "INSERT",
          schema: "public",
          table: "activity_logs",
        },
        fetchDashboardData
      )
      .subscribe();

    return () => {
      supabase.removeChannel(realtimeChannel);
    };
  }, [fetchDashboardData]);

  return {
    ...dashboardData,
    loading,
    error,
    refresh: fetchDashboardData,
  };
}
