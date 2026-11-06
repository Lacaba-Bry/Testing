import { ArrowClockwise, House, Wrench, ClockCounterClockwise } from "@phosphor-icons/react";
import { useMemo, useState } from "react";
import StatusDot from "../components/common/StatusDot";
import Badge from "../components/common/Badge";
import Button from "../components/common/Button";
import EmptyState from "../components/common/EmptyState";
import PageHeader from "../components/common/PageHeader";
import useRooms from "../hooks/useRooms";
import useAuth from "../hooks/useAuth";
import { supabase } from "../services/supabaseClient";
import "./Rooms.css";

const filters = ["all", "occupied", "active", "maintenance", "inactive"];
const reasons = ["Cleaning", "Repair", "Equipment issue", "Closed"];

export default function Rooms() {
  const { rooms, loading, error, refetchRooms, setRoomStatus } = useRooms();
  const { isAdmin } = useAuth();
  const [filterStatus, setFilterStatus] = useState("all");
  const [dialog, setDialog] = useState(null);
  const [reason, setReason] = useState("Cleaning");
  const [customReason, setCustomReason] = useState("");
  const [until, setUntil] = useState("");
  const [understood, setUnderstood] = useState(false);
  const [upcoming, setUpcoming] = useState([]);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");
  const [history, setHistory] = useState(null);

  const counts = useMemo(() => ({
    all: rooms.length,
    occupied: rooms.filter((r) => Boolean(r.currentPet)).length,
    active: rooms.filter((r) => r.status === "active" && !r.currentPet).length,
    maintenance: rooms.filter((r) => r.status === "maintenance").length,
    inactive: rooms.filter((r) => r.status === "inactive").length,
  }), [rooms]);
  const filteredRooms = useMemo(() => rooms.filter((room) => {
    if (filterStatus === "occupied") return Boolean(room.currentPet);
    return filterStatus === "all" || room.status === filterStatus;
  }), [rooms, filterStatus]);

  async function beginChange(room, status) {
    setMessage(""); setReason("Cleaning"); setCustomReason(""); setUntil(""); setUnderstood(false); setUpcoming([]);
    if (room.currentPet) { setMessage(`Room ${room.room_number} cannot change status while ${room.currentPet.name} is staying.`); return; }
    setDialog({ room, status });
  }

  async function saveStatus(force = false) {
    if (!dialog) return;
    const statusReason = dialog.status === "active" ? null : (reason === "custom" ? customReason.trim() : (customReason.trim() || reason));
    if (dialog.status !== "active" && !statusReason) { setMessage("Enter a reason for this status change."); return; }
    setSaving(true); setMessage("");
    try {
      const result = await setRoomStatus({ roomId: dialog.room.id, status: dialog.status, reason: statusReason, until: dialog.status === "maintenance" ? (until || null) : null, force });
      if (result?.requires_confirmation) { setUpcoming(result.bookings || []); return; }
      setDialog(null); setMessage(`Room ${dialog.room.room_number} updated.`);
    } catch (e) { setMessage(e.message || "Unable to change room status. The room list has been refreshed."); refetchRooms(); }
    finally { setSaving(false); }
  }

  async function openHistory(room) {
    setHistory({ room, loading: true, items: [] });
    const { data, error: historyError } = await supabase.from("activity_logs").select("id,description,created_at,actor:users!activity_logs_actor_user_id_fkey(full_name)").eq("entity_type", "room").eq("entity_id", room.id).order("created_at", { ascending: false }).limit(20);
    setHistory({ room, loading: false, items: data || [], error: historyError?.message });
  }

  return (
    <section className="rooms-page">
      <PageHeader title="Rooms" description="Room availability and assigned hardware." actions={<Button variant="secondary" onClick={refetchRooms}><ArrowClockwise size={17} /> Refresh</Button>} />
      <div className="segmented-control" aria-label="Room status filter">
        {filters.map((status) => <button key={status} type="button" className={filterStatus === status ? "active" : ""} onClick={() => setFilterStatus(status)}>{status === "all" ? "All" : titleCase(status)} <span>({counts[status]})</span></button>)}
      </div>
      {message && <div className="page-alert" role="status">{message}</div>}
      {error && <div className="page-alert page-alert--error">{error}</div>}
      {loading ? <div className="page-loading">Loading rooms…</div> : filteredRooms.length === 0 ? <EmptyState icon={House} title="No rooms in this view" message="Choose another status or refresh the room list." /> : (
        <div className="rooms-grid">
          {filteredRooms.map((room) => {
            const feeder = room.devices?.find((d) => d.device_type === "feeder");
            const camera = room.devices?.find((d) => d.device_type === "camera");
            return <article key={room.id} className={`room-panel room-panel--${room.status}`}>
              <div className="room-panel__header"><div className="room-number"><House size={20} /></div><div className="room-panel__name"><h2>Room {room.room_number}</h2><p>{room.room_name || "Pet suite"}</p></div><StatusDot status={room.currentPet ? "warning" : room.status === "active" ? "success" : "neutral"} /><Badge tone={getRoomTone(room.status)}>{room.currentPet ? "Occupied" : titleCase(room.status)}</Badge></div>
              <div className="room-capacity">Capacity <strong>{room.capacity || 1} pet{room.capacity === 1 ? "" : "s"}</strong></div>
              <p className="cf-room-pet">{room.currentPet ? <><strong>{room.currentPet.name}</strong> · staying until {formatDate(room.currentPet.checkout)}{room.currentPet.species ? ` · ${room.currentPet.species}` : ""}</> : "No pet checked in"}</p>
              {room.status === "maintenance" && <p className="cf-room-reason"><Wrench size={15} /> {room.status_reason || "Maintenance"}{room.maintenance_until ? ` · Ready by ${formatDate(room.maintenance_until)}` : ""}</p>}
              <div className="cf-room-health"><span title={`Feeder: ${feeder?.device_code || "Not assigned"} (${feeder?.status || "unassigned"})`}><StatusDot status={feeder?.status === "active" ? "success" : "neutral"} /> Feeder</span><span title={`Camera: ${camera?.device_code || "Not assigned"} (${camera?.status || "unassigned"})`}><StatusDot status={camera?.status === "active" ? "success" : "neutral"} /> Camera</span></div>
              <div className="cf-room-actions"><Button variant="secondary" size="sm" onClick={() => openHistory(room)}><ClockCounterClockwise size={15} /> Status history</Button>{isAdmin && <label className="cf-room-status-menu"><span className="sr-only">Change status for room {room.room_number}</span><select aria-label={`Change status for room ${room.room_number}`} value="" onChange={(e) => e.target.value && beginChange(room, e.target.value)} disabled={Boolean(room.currentPet)} title={room.currentPet ? `${room.currentPet.name} is staying here until ${formatDate(room.currentPet.checkout)}. Check them out first.` : "Change room status"}><option value="">Change status…</option><option value="maintenance">Mark as maintenance</option><option value="inactive">Mark as inactive</option><option value="active">Mark as available</option></select></label>}</div>
            </article>;
          })}
        </div>
      )}
      {dialog && <div className="cf-modal-backdrop" role="presentation"><section className="cf-modal" role="dialog" aria-modal="true" aria-labelledby="room-status-title"><h2 id="room-status-title">Change Room {dialog.room.room_number} to {titleCase(dialog.status)}?</h2><p>Changing room status affects future reservations.</p>{dialog.status !== "active" && <><label>Reason<select value={reason} onChange={(e) => { setReason(e.target.value); setCustomReason(""); }}><option value="">Choose a reason</option>{reasons.map((r) => <option key={r} value={r}>{r}</option>)}<option value="custom">Other reason…</option></select></label>{(reason === "custom" || customReason) && <label>Other reason<input value={customReason} maxLength={120} onChange={(e) => setCustomReason(e.target.value)} placeholder="Enter reason" /></label>}{dialog.status === "maintenance" && <label>Expected ready date (optional)<input type="date" value={until} onChange={(e) => setUntil(e.target.value)} /></label>}</>}
        {upcoming.length > 0 && <div className="cf-upcoming-confirm"><strong>Upcoming reservations in this room</strong><ul>{upcoming.map((b) => <li key={b.booking_code || `${b.pet_name}-${b.check_in_at}`}><strong>{b.booking_code || "Booking"}</strong> · {b.pet_name || "Pet"} · {b.owner_name || "Owner not listed"} · {formatDate(b.check_in_at)} – {formatDate(b.expected_check_out_at)}</li>)}</ul><label className="cf-confirm-check"><input type="checkbox" checked={understood} onChange={(e) => setUnderstood(e.target.checked)} /> I understand these reservations may need to be moved</label></div>}
        <div className="cf-modal-actions"><Button variant="secondary" onClick={() => setDialog(null)} disabled={saving}>Cancel</Button><Button onClick={() => saveStatus(upcoming.length > 0)} disabled={saving || (upcoming.length > 0 && !understood)}>{saving ? "Saving…" : upcoming.length ? "Proceed anyway" : "Confirm status"}</Button></div></section></div>}
      {history && <div className="cf-drawer-backdrop" role="presentation" onMouseDown={(e) => e.target === e.currentTarget && setHistory(null)}><aside className="cf-room-drawer" role="dialog" aria-modal="true" aria-label={`Room ${history.room.room_number} status history`}><div className="cf-drawer-head"><h2>Room {history.room.room_number} history</h2><Button variant="secondary" onClick={() => setHistory(null)}>Close</Button></div>{history.loading ? <p>Loading history…</p> : history.error ? <p>{history.error}</p> : history.items.length ? history.items.map((item) => <article className="cf-history-item" key={item.id}><strong>{item.description}</strong><p>{item.actor?.full_name || "Admin"} · {new Date(item.created_at).toLocaleString()}</p></article>) : <p>No status changes recorded.</p>}</aside></div>}
    </section>
  );
}
function titleCase(value) { return String(value || "").replaceAll("_", " ").replace(/\b\w/g, (c) => c.toUpperCase()); }
function formatDate(value) { if (!value) return "—"; return new Date(value).toLocaleDateString("en-PH", { month: "short", day: "numeric" }); }
function getRoomTone(status) { if (status === "active") return "success"; if (status === "maintenance") return "warning"; return "neutral"; }
