import { useCallback, useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient";
import "./FeederScheduleTester.css";

async function scheduleApi(body) {
  const { data, error } = await supabase.functions.invoke("feeder-schedule-admin", { body });
  if (error) {
    let detail="";
    try { detail = (await error.context?.json())?.error || ""; } catch { /* unavailable */ }
    throw new Error(detail || error.message);
  }
  if (!data?.ok) throw new Error(data?.error || "Schedule request failed");
  return data;
}

function formatSchedule(item) {
  if (item.schedule_type === "daily") return `Daily at ${String(item.local_time || "").slice(0, 5)} (Philippine time)`;
  if (!item.run_at) return "One-time";
  return `Once · ${new Intl.DateTimeFormat("en-PH", {
    timeZone:"Asia/Manila", year:"numeric", month:"short", day:"numeric", hour:"numeric", minute:"2-digit",
  }).format(new Date(item.run_at))}`;
}

export default function FeederScheduleTester({ deviceId }) {
  const [kind, setKind] = useState("once");
  const [dateTime, setDateTime] = useState("");
  const [dailyTime, setDailyTime] = useState("08:00");
  const [schedules, setSchedules] = useState([]);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const load = useCallback(async () => {
    if (!deviceId) { setSchedules([]); return; }
    try {
      const result = await scheduleApi({ action:"list", device_id:deviceId });
      setSchedules(result.schedules || []);
    } catch (e) { setError(e.message); }
  }, [deviceId]);

  useEffect(() => {
    setError(""); setMessage(""); load();
    if (!deviceId) return;
    const interval = setInterval(load, 15000);
    return () => clearInterval(interval);
  }, [deviceId, load]);

  async function submit(event) {
    event.preventDefault();
    if (!deviceId || busy) return;
    setError(""); setMessage(""); setBusy(true);
    try {
      const payload = { action:"create", device_id:deviceId, schedule_type:kind };
      if (kind === "once") {
        if (!/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(dateTime)) throw new Error("Select a date and time.");
        payload.run_at = `${dateTime}:00+08:00`;
      } else {
        payload.local_time = dailyTime;
      }
      await scheduleApi(payload);
      setMessage("Schedule saved. Supabase checks due schedules once per minute.");
      await load();
    } catch (e) { setError(e.message); }
    finally { setBusy(false); }
  }

  async function disable(id) {
    if (busy) return;
    setError(""); setMessage(""); setBusy(true);
    try {
      await scheduleApi({ action:"disable", device_id:deviceId, schedule_id:id });
      setMessage("Schedule disabled. A command already queued cannot be cancelled here.");
      await load();
    } catch(e) { setError(e.message); }
    finally { setBusy(false); }
  }

  return <section className="feeder-schedule-card" aria-label="Scheduled feeding tester">
    <div className="feeder-schedule-header">
      <div><h2>Scheduled Feeding Tester</h2><p>Automatically queue a 120° rotation at your chosen time.</p></div>
      <button className="feeder-schedule-refresh" onClick={load} disabled={!deviceId || busy}>Refresh</button>
    </div>
    <form className="feeder-schedule-form" onSubmit={submit}>
      <label htmlFor="feeder-schedule-kind">Schedule type</label>
      <select id="feeder-schedule-kind" value={kind} onChange={e=>setKind(e.target.value)} disabled={busy}>
        <option value="once">One-time test</option><option value="daily">Every day</option>
      </select>
      {kind === "once" ? <>
        <label htmlFor="feeder-schedule-datetime">Date and time (Philippine time, UTC+8)</label>
        <input id="feeder-schedule-datetime" type="datetime-local" value={dateTime} onChange={e=>setDateTime(e.target.value)} required disabled={busy}/>
        <small>For a quick test, choose a time 3–5 minutes ahead. Enter Manila time even if your computer uses another timezone.</small>
      </> : <>
        <label htmlFor="feeder-schedule-daily">Daily feeding time (Philippine time, UTC+8)</label>
        <input id="feeder-schedule-daily" type="time" value={dailyTime} onChange={e=>setDailyTime(e.target.value)} required disabled={busy}/>
      </>}
      <button className="feeder-schedule-save" type="submit" disabled={!deviceId || busy}>{busy ? "Saving..." : "Save feeding schedule"}</button>
    </form>
    <p className="feeder-schedule-info">This tester uses Supabase scheduling and requires internet access. It does not use the DS3231 yet. A scheduled command is skipped if another feeder command is pending or running.</p>
    {message && <p className="feeder-schedule-success" role="status">{message}</p>}
    {error && <p className="feeder-schedule-error" role="alert">{error}</p>}
    <div className="feeder-schedule-header"><h3>Saved schedules</h3></div>
    {!schedules.length && <p className="feeder-schedule-info">No schedules saved for this feeder.</p>}
    <div className="feeder-schedule-list">{schedules.map(item=><article className="feeder-schedule-item" key={item.id}>
      <div><strong>{formatSchedule(item)}</strong><div className="feeder-schedule-meta">{item.enabled ? "Active" : "Disabled"}{item.last_result ? ` · Last run: ${item.last_result}` : " · Not triggered yet"}</div></div>
      {item.enabled && <button type="button" onClick={()=>disable(item.id)} disabled={busy}>Disable</button>}
    </article>)}</div>
  </section>;
}
