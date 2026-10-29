import { ArrowClockwise, House, Wrench, Camera, Robot } from "@phosphor-icons/react";
import { useMemo, useState } from "react";
import Badge from "../components/common/Badge";
import Button from "../components/common/Button";
import EmptyState from "../components/common/EmptyState";
import PageHeader from "../components/common/PageHeader";
import StatusDot from "../components/common/StatusDot";
import useAuth from "../hooks/useAuth";
import useRooms from "../hooks/useRooms";
import "./Rooms.css";

const filters = [
  { key: "all", label: "All" },
  { key: "occupied", label: "Occupied" },
  { key: "active", label: "Available" },
  { key: "maintenance", label: "Maintenance" },
  { key: "inactive", label: "Inactive" },
];

const reasons = ["Cleaning", "Repair", "Equipment issue", "Closed"];

export default function Rooms() {
  const { rooms, loading, error, refetchRooms, setRoomStatus } = useRooms();
  const { isAdmin } = useAuth();
  const [filterStatus, setFilterStatus] = useState("all");
  const [message, setMessage] = useState("");
  const [manageOpen, setManageOpen] = useState(false);
  const [selectedRoomId, setSelectedRoomId] = useState("");
  const [targetStatus, setTargetStatus] = useState("maintenance");
  const [reason, setReason] = useState("Cleaning");
  const [customReason, setCustomReason] = useState("");
  const [until, setUntil] = useState("");
  const [saving, setSaving] = useState(false);
  const [upcoming, setUpcoming] = useState([]);
  const [understood, setUnderstood] = useState(false);

  const counts = useMemo(
    () => ({
      all: rooms.length,
      occupied: rooms.filter((room) => Boolean(room.currentPet)).length,
      active: rooms.filter((room) => room.status === "active" && !room.currentPet).length,
      maintenance: rooms.filter((room) => room.status === "maintenance").length,
      inactive: rooms.filter((room) => room.status === "inactive").length,
    }),
    [rooms],
  );

  const filteredRooms = useMemo(
    () =>
      rooms.filter((room) => {
        if (filterStatus === "occupied") return Boolean(room.currentPet);
        return filterStatus === "all" || room.status === filterStatus;
      }),
    [rooms, filterStatus],
  );

  function openManageModal(room = null) {
    setSelectedRoomId(room?.id || rooms[0]?.id || "");
    setTargetStatus(room?.status === "maintenance" ? "active" : "maintenance");
    setReason("Cleaning");
    setCustomReason("");
    setUntil("");
    setUpcoming([]);
    setUnderstood(false);
    setMessage("");
    setManageOpen(true);
  }

  async function handleSave(force = false) {
    if (!selectedRoomId) {
      setMessage("Please choose a room first.");
      return;
    }

    const room = rooms.find((item) => item.id === selectedRoomId);
    if (!room) {
      setMessage("Room not found.");
      return;
    }

    if (room.currentPet && targetStatus !== "active") {
      setMessage(`Room ${room.room_number} cannot be changed while ${room.currentPet.name} is staying.`);
      return;
    }

    const statusReason =
      targetStatus === "active" ? null : reason === "custom" ? customReason.trim() : customReason.trim() || reason;

    if (targetStatus !== "active" && !statusReason) {
      setMessage("Please provide a reason for this status change.");
      return;
    }

    setSaving(true);
    setMessage("");

    try {
      const result = await setRoomStatus({
        roomId: room.id,
        status: targetStatus,
        reason: statusReason,
        until: targetStatus === "maintenance" ? until || null : null,
        force,
      });

      if (result?.requires_confirmation) {
        setUpcoming(result.bookings || []);
        return;
      }

      setManageOpen(false);
      setUpcoming([]);
      setMessage(`Room ${room.room_number} updated successfully.`);
    } catch (saveError) {
      setMessage(saveError.message || "Unable to change room status.");
      refetchRooms();
    } finally {
      setSaving(false);
    }
  }

  return (
    <section className="rooms-page">
      <PageHeader
        title="Rooms"
        description="Room availability and assigned hardware."
        actions={
          <>
            <Button variant="secondary" onClick={refetchRooms}>
              <ArrowClockwise size={17} /> Refresh
            </Button>
            {isAdmin && (
              <Button onClick={() => openManageModal()}>
                <Wrench size={17} /> Change room status
              </Button>
            )}
          </>
        }
      />

      <div className="segmented-control rooms-filter-bar" aria-label="Room status filter">
        {filters.map((status) => (
          <button
            key={status.key}
            type="button"
            className={filterStatus === status.key ? "active" : ""}
            onClick={() => setFilterStatus(status.key)}
          >
            {status.label} <span>({counts[status.key]})</span>
          </button>
        ))}
      </div>

      {message && <div className="page-alert">{message}</div>}
      {error && <div className="page-alert page-alert--error">{error}</div>}

      {loading ? (
        <div className="page-loading">Loading rooms…</div>
      ) : filteredRooms.length === 0 ? (
        <EmptyState icon={House} title="No rooms in this view" message="Choose another status or refresh the room list." />
      ) : (
        <div className="rooms-grid">
          {filteredRooms.map((room) => {
            const feeder = room.devices?.find((device) => device.device_type === "feeder");
            const camera = room.devices?.find((device) => device.device_type === "camera");
            const isOccupied = Boolean(room.currentPet);
            return (
              <article key={room.id} className={`room-panel room-panel--${room.status}`}>
                <div className="room-panel__header">
                  <div className="room-number">
                    <House size={18} />
                  </div>
                  <div className="room-panel__name">
                    <h2>Room {room.room_number}</h2>
                    <p>{room.room_name || "Pet suite"}</p>
                  </div>
                  <div className="room-panel__badges">
                    <StatusDot status={isOccupied ? "warning" : room.status === "active" ? "success" : "neutral"} />
                    {isOccupied ? (
                      <span className="room-badge room-badge--occupied">Occupied</span>
                    ) : (
                      <Badge tone={getRoomTone(room.status)}>{room.status === "active" ? "Available" : titleCase(room.status)}</Badge>
                    )}
                  </div>
                </div>

                <div className="room-capacity">
                  Capacity <strong>{room.capacity || 1} pet{room.capacity === 1 ? "" : "s"}</strong>
                </div>

                <p className="cf-room-pet">
                  {isOccupied ? (
                    <>
                      <strong>{room.currentPet.name}</strong>
                      <span>{room.currentPet.species ? `${room.currentPet.species} · ` : ""}staying until {formatDate(room.currentPet.checkout)}</span>
                    </>
                  ) : (
                    "No pet checked in"
                  )}
                </p>

                {room.status === "maintenance" && (
                  <p className="cf-room-reason">
                    <Wrench size={14} /> {room.status_reason || "Maintenance"}
                    {room.maintenance_until ? ` · Ready by ${formatDate(room.maintenance_until)}` : ""}
                  </p>
                )}

                <div className="cf-room-health">
                  <span title={`Feeder: ${feeder?.device_code || "Not assigned"} (${feeder?.status || "unassigned"})`}>
                    <Robot size={16} aria-hidden="true" /> <span className={`cf-device-dot ${feeder?.status === "active" ? "is-active" : ""}`} /> Feeder
                  </span>
                  <span title={`Camera: ${camera?.device_code || "Not assigned"} (${camera?.status || "unassigned"})`}>
                    <Camera size={16} aria-hidden="true" /> <span className={`cf-device-dot ${camera?.status === "active" ? "is-active" : ""}`} /> Camera
                  </span>
                </div>


              </article>
            );
          })}
        </div>
      )}

      {manageOpen && (
        <div className="cf-modal-backdrop" role="presentation">
          <section className="cf-modal room-manage-modal" role="dialog" aria-modal="true" aria-labelledby="room-status-title">
            <div className="room-manage-modal__header">
              <div>
                <h2 id="room-status-title">Change room status</h2>
                <p>Choose a room and set its next status.</p>
              </div>
            </div>

            <div className="room-manage-modal__body">
              <label>
                Room
                <select value={selectedRoomId} onChange={(event) => setSelectedRoomId(event.target.value)}>
                  <option value="">Select a room</option>
                  {rooms.map((room) => (
                    <option key={room.id} value={room.id}>
                      Room {room.room_number} — {room.room_name || "Pet suite"}
                    </option>
                  ))}
                </select>
              </label>

              <label>
                New status
                <select
                  value={targetStatus}
                  onChange={(event) => {
                    setTargetStatus(event.target.value);
                    setUpcoming([]);
                    setUnderstood(false);
                  }}
                >
                  <option value="maintenance">Maintenance</option>
                  <option value="inactive">Inactive</option>
                  <option value="active">Available</option>
                </select>
              </label>

              {targetStatus !== "active" && (
                <>
                  <label>
                    Reason
                    <select
                      value={reason}
                      onChange={(event) => {
                        setReason(event.target.value);
                        if (event.target.value !== "custom") setCustomReason("");
                      }}
                    >
                      {reasons.map((item) => (
                        <option key={item} value={item}>
                          {item}
                        </option>
                      ))}
                      <option value="custom">Other reason...</option>
                    </select>
                  </label>

                  {reason === "custom" && (
                    <label>
                      Other reason
                      <input value={customReason} onChange={(event) => setCustomReason(event.target.value)} placeholder="Enter reason" />
                    </label>
                  )}

                  {targetStatus === "maintenance" && (
                    <label>
                      Expected ready date (optional)
                      <input type="date" value={until} onChange={(event) => setUntil(event.target.value)} />
                    </label>
                  )}
                </>
              )}

              {upcoming.length > 0 && (
                <div className="cf-upcoming-confirm">
                  <strong>Upcoming reservations in this room</strong>
                  <ul>
                    {upcoming.map((booking) => (
                      <li key={booking.booking_code || `${booking.pet_name}-${booking.check_in_at}`}>
                        <strong>{booking.booking_code || "Booking"}</strong> · {booking.pet_name || "Pet"} · {booking.owner_name || "Owner not listed"} · {formatDate(booking.check_in_at)} – {formatDate(booking.expected_check_out_at)}
                      </li>
                    ))}
                  </ul>
                  <label className="cf-confirm-check">
                    <input type="checkbox" checked={understood} onChange={(event) => setUnderstood(event.target.checked)} />
                    I understand these reservations may need to be moved.
                  </label>
                </div>
              )}
            </div>

            <div className="cf-modal-actions">
              <Button variant="secondary" onClick={() => setManageOpen(false)} disabled={saving}>
                Cancel
              </Button>
              <Button onClick={() => handleSave(upcoming.length > 0)} disabled={saving || (upcoming.length > 0 && !understood)}>
                {saving ? "Saving..." : upcoming.length ? "Proceed anyway" : "Save changes"}
              </Button>
            </div>
          </section>
        </div>
      )}
    </section>
  );
}

function titleCase(value) {
  return String(value || "").replaceAll("_", " ").replace(/\b\w/g, (char) => char.toUpperCase());
}

function getRoomTone(status) {
  if (status === "active") return "success";
  if (status === "maintenance") return "warning";
  if (status === "inactive") return "neutral";
  return "neutral";
}

function formatDate(value) {
  return value ? new Date(value).toLocaleDateString("en-PH", { month: "short", day: "numeric" }) : "—";
}
