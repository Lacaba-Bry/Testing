import { BellSimple, ArrowRight } from "@phosphor-icons/react";
import { Link } from "react-router-dom";
import useAuth from "../hooks/useAuth";
import useDashboard from "../hooks/useDashboard";
import SummaryStrip from "../components/common/SummaryStrip";
import StatusDot from "../components/common/StatusDot";
import "./Dashboard.css";

const time = (value) =>
  value ? new Intl.DateTimeFormat("en-PH", { hour: "numeric", minute: "2-digit" }).format(new Date(value)) : "—";
const roomLabel = (room) => (room?.room_number ? `Room ${room.room_number}` : "Unassigned");
const dateLabel = new Intl.DateTimeFormat("en-PH", { weekday: "short", month: "short", day: "numeric" }).format(new Date());

export default function Dashboard() {
  const { profile } = useAuth();
  const data = useDashboard();
  const {
    arrivals,
    departures,
    occupiedRooms,
    rooms,
    feedingsDue,
    manualFeedings,
    activeAlerts,
    cameras,
    recentActivity,
    upcomingFeedings,
    loading,
    error,
    refresh,
  } = data;

  const occupied = new Map(occupiedRooms.filter((booking) => booking.room_id).map((booking) => [booking.room_id, booking]));
  const now = Date.now();
  const due = [...feedingsDue, ...manualFeedings].filter(
    (feeding) => new Date(feeding.scheduled_at).getTime() <= now + 5 * 60000,
  );
  const offline = cameras
    .filter((camera) => camera.status !== "active" || !camera.last_seen_at || now - new Date(camera.last_seen_at).getTime() > 5 * 60000)
    .filter(
      (camera) =>
        !activeAlerts.some(
          (alert) => alert.device?.id === camera.id && (alert.alert_type === "camera_offline" || alert.alert_type === "device_offline"),
        ),
    );

  const lateByPet = new Map();
  for (const feeding of due) {
    const petName = feeding.booking?.pet?.name || "pet";
    const key = `${petName}-${feeding.booking?.room?.id || feeding.booking?.room?.room_number || "room"}`;
    if (!lateByPet.has(key)) lateByPet.set(key, []);
    lateByPet.get(key).push(feeding);
  }

  const attention = [
    ...activeAlerts.map((alert) => ({
      id: `a-${alert.id}`,
      level: alert.severity === "critical" ? 0 : 1,
      title: alert.title,
      detail: roomLabel(alert.booking?.room),
      at: alert.created_at,
      action: "Acknowledge",
      to: "/alerts",
    })),
    ...[...lateByPet.entries()].map(([key, feedings]) => {
      const oldest = feedings.reduce((a, b) => (new Date(a.scheduled_at) < new Date(b.scheduled_at) ? a : b));
      const late = feedings.some((feeding) => new Date(feeding.scheduled_at) < new Date());
      return {
        id: `f-${key}`,
        level: late ? 0 : 1,
        title: `${oldest.booking?.pet?.name || "Pet"}: ${feedings.length} ${late ? "late" : "due"} feeding${feedings.length === 1 ? "" : "s"}`,
        detail: `${roomLabel(oldest.booking?.room)} · oldest ${time(oldest.scheduled_at)}`,
        at: oldest.scheduled_at,
        action: "Mark fed",
        to: "/feeding-schedules",
      };
    }),
    ...offline.map((camera) => ({
      id: `c-${camera.id}`,
      level: 1,
      title: `${camera.device_name || camera.device_code || "Camera"} is offline`,
      detail: "Check camera connection",
      at: camera.last_seen_at,
      action: "Open camera",
      to: "/cameras",
    })),
  ].sort((a, b) => a.level - b.level || new Date(a.at || 0) - new Date(b.at || 0));

  const upcoming = upcomingFeedings
    .filter((feeding) => {
      const diff = new Date(feeding.scheduled_at).getTime() - now;
      return diff > 5 * 60000 && diff <= 3 * 60 * 60000;
    })
    .slice(0, 8);

  const roomsAvailable = Math.max(rooms.length - occupied.size, 0);

  return (
    <div className="cf-today">
      <header className="cf-today-head">
        <h1>
          Good {new Date().getHours() < 12 ? "morning" : new Date().getHours() < 18 ? "afternoon" : "evening"},{" "}
          {profile?.full_name?.split(" ")[0] || "Admin"}
          <span> · {dateLabel}</span>
        </h1>
        <Link className="cf-bell" to="/alerts" aria-label={`${activeAlerts.length} active alerts`}>
          <BellSimple size={22} />
          {activeAlerts.length > 0 && <b>{activeAlerts.length}</b>}
        </Link>
      </header>

      {error && (
        <div className="page-alert page-alert--error" role="alert">
          {error} <button onClick={refresh}>Retry</button>
        </div>
      )}

      {loading ? (
        <div className="cf-loading" aria-label="Loading dashboard">
          Loading today's stays and care tasks…
        </div>
      ) : (
        <>
          <SummaryStrip
            items={[
              { label: "Arriving today", value: arrivals.length },
              { label: "Leaving today", value: departures.length },
              { label: "Pets in hotel", value: occupiedRooms.length },
              { label: "Rooms available", value: roomsAvailable },
            ]}
          />

          <section className="cf-panel cf-attention">
            <div className="cf-section-title">
              <h2>Needs attention</h2>
              <Link to="/alerts">
                All alerts <ArrowRight size={15} />
              </Link>
            </div>
            {attention.length === 0 ? (
              <p className="cf-all-clear">
                <StatusDot status="success" /> All clear. Nothing needs attention right now.
              </p>
            ) : (
              <div className="cf-action-list">
                {attention.slice(0, 6).map((item) => (
                  <div className={`cf-action-row cf-level-${item.level}`} key={item.id}>
                    <div>
                      <strong>{item.title}</strong>
                      <small>
                        {item.detail} · {time(item.at)}
                      </small>
                    </div>
                    <Link to={item.to}>{item.action}</Link>
                  </div>
                ))}
              </div>
            )}
          </section>

          <div className="cf-columns">
            <section className="cf-panel">
              <div className="cf-section-title">
                <h2>Arrivals & departures</h2>
                <Link to="/boardings">
                  All stays <ArrowRight size={15} />
                </Link>
              </div>
              <div className="cf-stays">
                {[
                  ...arrivals.map((booking) => ({ ...booking, kind: "Arriving", at: booking.check_in_at })),
                  ...departures.map((booking) => ({ ...booking, kind: "Leaving", at: booking.expected_check_out_at })),
                ]
                  .sort((a, b) => new Date(a.at) - new Date(b.at))
                  .slice(0, 8)
                  .map((booking) => (
                    <div className="cf-stay-row" key={`${booking.kind}-${booking.id}`}>
                      <time>{time(booking.at)}</time>
                      <div>
                        <strong>{booking.pet?.name || "Pet"}</strong>
                        <small>
                          {roomLabel(booking.room)} · {booking.status?.replaceAll("_", " ")}
                        </small>
                      </div>
                      <span>{booking.kind}</span>
                    </div>
                  ))}
                {!arrivals.length && !departures.length && <p className="cf-quiet">No arrivals or departures scheduled today.</p>}
              </div>
            </section>

            <section className="cf-panel">
              <div className="cf-section-title">
                <h2>Rooms</h2>
                <Link to="/rooms">
                  Manage rooms <ArrowRight size={15} />
                </Link>
              </div>
              <div className="cf-room-grid">
                {rooms.map((room) => {
                  const stay = occupied.get(room.id);
                  return (
                    <Link
                      key={room.id}
                      to="/rooms"
                      className={`cf-room-chip ${stay ? "is-occupied" : ""} ${room.status !== "active" ? `is-${room.status}` : ""}`}
                    >
                      <StatusDot status={room.status !== "active" ? "warning" : stay ? "danger" : "success"} />
                      <strong>{room.room_number}</strong>
                      <small>{stay?.pet?.name || (room.status !== "active" ? room.status : "Free")}</small>
                    </Link>
                  );
                })}
              </div>
            </section>
          </div>

          <section className="cf-panel">
            <div className="cf-section-title">
              <h2>
                Upcoming feedings <span>Next 3 hours</span>
              </h2>
              <Link to="/feeding-schedules">
                Schedule <ArrowRight size={15} />
              </Link>
            </div>
            <div className="cf-feed-grid">
              {upcoming.map((feeding) => (
                <div className="cf-feed-item" key={feeding.id}>
                  <time>{time(feeding.scheduled_at)}</time>
                  <strong>{feeding.booking?.pet?.name || "Pet"}</strong>
                  <span>{roomLabel(feeding.booking?.room)}</span>
                  <small>{feeding.feeding_method}</small>
                </div>
              ))}
              {upcoming.length === 0 && <p className="cf-quiet">No more feedings in the next three hours.</p>}
            </div>
          </section>

          <details className="cf-panel cf-activity">
            <summary>
              Recent activity <span>({recentActivity.length})</span>
            </summary>
            <Link to="/alerts">
              View all activity <ArrowRight size={15} />
            </Link>
            {recentActivity.map((activity) => (
              <div className="cf-activity-row" key={activity.id}>
                <span>{activity.description}</span>
                <time>{time(activity.created_at)}</time>
              </div>
            ))}
            {recentActivity.length === 0 && <p className="cf-quiet">No recent activity.</p>}
          </details>
        </>
      )}
    </div>
  );
}
