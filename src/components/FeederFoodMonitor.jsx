import { ArrowsClockwise, BellRinging, Scales } from "@phosphor-icons/react";
import useFeederFood from "../hooks/useFeederFood";
import "./FeederFoodMonitor.css";

const names = { empty: "Empty plate", food_stable: "Food stable", possible_eating: "Possible eating" };
const eventNames = { food_detected: "Food detected", possible_eating: "Possible eating detected", plate_empty: "Plate empty" };
export function foodEventTime(date) { return date ? new Date(date).toLocaleString() : "—"; }
export function FoodEventList({ events }) {
  return <div className="food-events">{events.length === 0 ? <p className="food-muted">No food activity notifications yet.</p> : events.map(event =>
    <article className={`food-event food-event--${event.event_type}`} key={event.id}>
      <BellRinging size={21} aria-hidden="true" />
      <div><strong>{eventNames[event.event_type] || event.event_type.replaceAll("_", " ")}</strong>
        <p>{event.message || "Feeder food activity recorded"}</p>
        <small>Feeder: {event.device_code} · {foodEventTime(event.created_at)}
          {event.weight_change_g != null ? ` · Approx. ${Number(event.weight_change_g).toFixed(1)} g decrease` : ""}
        </small>
      </div>
    </article>
  )}</div>;
}
export default function FeederFoodMonitor({ deviceCode }) {
  const { state, events, loading, error, refresh } = useFeederFood(deviceCode);
  const stale = state?.updated_at && Date.now() - new Date(state.updated_at).getTime() > 15000;
  return <section className="food-monitor" aria-label="Live HX711 food activity monitoring">
    <div className="food-monitor-heading"><div><h2><Scales size={24} /> HX711 Load Cell Test</h2>
      <p>Live feeder measurements and possible-eating events from Supabase</p></div>
      <button type="button" onClick={refresh} aria-label="Refresh load cell readings"><ArrowsClockwise size={18} /> Refresh</button>
    </div>
    {error && <p className="food-monitor-error" role="alert">{error}</p>}
    {loading && !state ? <p className="food-muted">Loading load cell readings…</p> :
      <div className="food-monitor-stats">
        <div><span>Approximate food load</span><strong>{state ? `${Number(state.weight_estimate_g).toFixed(1)} g` : "No readings"}</strong></div>
        <div><span>Food status</span><strong>{state ? (names[state.state] || state.state) : "Unknown"}</strong></div>
        <div><span>Last reading</span><strong>{state ? foodEventTime(state.updated_at) : "—"}</strong></div>
      </div>}
    {stale && <p className="food-monitor-warning">No new reading for over 15 seconds. Check ESP32 Wi-Fi and HX711 telemetry.</p>}
    <h3>Recent food notifications</h3>
    <FoodEventList events={events.slice(0, 8)} />
    <p className="food-muted">Possible eating means a sustained decrease in load. It cannot confirm whether a pet actually consumed the food.</p>
  </section>;
}
