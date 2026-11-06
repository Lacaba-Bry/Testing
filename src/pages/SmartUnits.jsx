import { useCallback, useEffect, useState } from "react";
import {
  ArrowClockwise, Camera, Circuitry, WarningCircle,
  ArrowsLeftRight, MapPin, CheckCircle, SignOut,
} from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import { supabase } from "../services/supabaseClient";
import "./SmartUnits.css";

function roomDisplay(unit) {
  if (!unit.assignment_consistent) return "Assignments disagree";
  if (!unit.feeder_room && !unit.camera_room) return "Unassigned";
  return unit.feeder_room || unit.camera_room;
}

function readableError(error) {
  const message = error?.message || "Smart Unit operation failed.";
  if (message.includes("Destination room not found")) {
    return "The installed database movement function does not recognize this destination. Apply the included SQL migration and refresh.";
  }
  return message;
}

export default function SmartUnits() {
  const [units, setUnits] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [selections, setSelections] = useState({});
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState("");
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  const refresh = useCallback(async () => {
    try {
      const [unitResult, roomResult] = await Promise.all([
        supabase.rpc("carefur_smart_unit_status"),
        supabase.from("rooms").select("id,room_number,status").order("room_number"),
      ]);
      if (unitResult.error) throw unitResult.error;
      if (roomResult.error) throw roomResult.error;
      setUnits(unitResult.data ?? []);
      setRooms(roomResult.data ?? []);
    } catch (e) {
      setError(readableError(e));
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { refresh(); }, [refresh]);

  async function submit(unit, roomId) {
    const unassigning = roomId === null;
    const destination = rooms.find((room) => room.id === roomId);
    if (!unassigning && !destination) {
      setError("Select a destination room first.");
      return;
    }
    const description = unassigning
      ? `unassign both devices in ${unit.unit_code}`
      : `move ${unit.unit_code} to ${destination.room_number}`;
    if (!window.confirm(`Confirm: ${description}?\n\nBoth feeder and camera will be updated together. Make sure the motor is idle and offline RTC feeding has stopped.`)) return;

    setBusy(unit.unit_code);
    setError("");
    setNotice("");
    try {
      const { data, error: rpcError } = await supabase.rpc("carefur_move_smart_unit", {
        p_unit_code: unit.unit_code,
        p_room_id: roomId,
      });
      if (rpcError) throw rpcError;
      if (!data?.success) throw new Error(data?.message || "Smart Unit operation was rejected");
      setNotice(`${unit.unit_code}: ${data.message || "Assignment updated"}`);
      if (!unassigning) setSelections((previous) => ({ ...previous, [unit.unit_code]: "" }));
      await refresh();
    } catch (e) {
      setError(readableError(e));
    } finally {
      setBusy("");
    }
  }

  const activeRooms = rooms.filter((r) => String(r.status).toLowerCase() === "active");

  return (
    <section className="smart-units-page">
      <PageHeader
        title="Smart Units"
        description="Assign, move or unassign the paired ESP32 feeder and camera together."
        actions={<button type="button" className="smart-units-refresh" onClick={() => { setLoading(true); setError(""); refresh(); }} disabled={!!busy || loading}>
          <ArrowClockwise size={18} /> Refresh
        </button>}
      />
      {error && <div className="smart-units-error" role="alert"><WarningCircle size={18} />{error}<button type="button" onClick={() => setError("")}>Dismiss</button></div>}
      {notice && <div className="smart-units-success" role="status"><CheckCircle size={18} /> {notice}</div>}
      <div className="smart-units-toolbar">{loading ? "Loading Smart Units..." : `${units.length} registered Smart Unit${units.length === 1 ? "" : "s"}`}</div>
      <div className="smart-units-grid">
        {units.map((unit) => {
          const consistent = unit.assignment_consistent === true;
          const pending = Number(unit.active_commands) > 0;
          const blocked = !consistent || pending || Boolean(unit.rtc_enabled) || Boolean(busy);
          const existingRoom = roomDisplay(unit);
          const isAssigned = consistent && existingRoom !== "Unassigned";
          const selected = selections[unit.unit_code] || "";
          const target = activeRooms.find((r) => r.id === selected);
          const sameRoom = target?.room_number === existingRoom;
          return (
            <article className="smart-unit-card" key={unit.unit_code}>
              <div className="smart-unit-card-top">
                <div className="smart-unit-title"><Circuitry size={26} /><div><span className="smart-unit-code">{unit.unit_code}</span><h2>{unit.unit_name || unit.unit_code}</h2></div></div>
                <span className={`smart-unit-pill ${blocked ? "smart-unit-pill-warn" : ""}`}>
                  {unit.movement_status?.replaceAll("_", " ") || "Registered"}
                </span>
              </div>
              <div className="smart-unit-devices">
                <div><Circuitry size={22}/><span><small>Feeder</small><strong>{unit.feeder_code}</strong></span></div>
                <div><Camera size={22}/><span><small>Camera</small><strong>{unit.camera_code}</strong></span></div>
              </div>
              <div className="smart-unit-facts">
                <div><span>Current room</span><strong>{existingRoom}</strong></div>
                <div><span>Active motor commands</span><strong>{unit.active_commands}</strong></div>
                <div><span>RTC mode</span><strong>{unit.rtc_enabled ? "Enabled" : "Disabled"}</strong></div>
                <div><span>Assignments</span><strong>{consistent ? "Consistent" : "Inconsistent"}</strong></div>
              </div>
              <div className="smart-unit-action-panel">
                <label htmlFor={`smart-unit-room-${unit.unit_code}`}><MapPin size={16} />Destination room</label>
                <select id={`smart-unit-room-${unit.unit_code}`} value={selected}
                  onChange={(e) => setSelections((old) => ({ ...old, [unit.unit_code]: e.target.value }))}
                  disabled={Boolean(busy)}>
                  <option value="">Choose a room</option>
                  {activeRooms.map((room) => <option key={room.id} value={room.id}>{room.room_number}</option>)}
                </select>
                {!activeRooms.length && <p className="smart-unit-help">No rooms with status “active” were returned. Check the Rooms page.</p>}
                <button type="button" className="smart-unit-move" disabled={blocked || !selected || sameRoom}
                  onClick={() => submit(unit, selected)}>
                  <ArrowsLeftRight size={17} />{busy === unit.unit_code ? "Updating..." : isAssigned ? "Move Unit" : "Assign Unit"}
                </button>
                {isAssigned && (
                  <button type="button" className="smart-unit-unassign" disabled={blocked}
                    onClick={() => submit(unit, null)}>
                    <SignOut size={17} />Unassign Unit
                  </button>
                )}
                <p className="smart-unit-help">Both paired devices change rooms in one database transaction. Moves are rejected for checked-in boarding, active motor commands or enabled RTC. Physical relocation and existing camera sessions must still be managed safely.</p>
              </div>
            </article>
          );
        })}
      </div>
      {!loading && units.length === 0 && !error && <div className="smart-units-empty">No Smart Units registered.</div>}
    </section>
  );
}
