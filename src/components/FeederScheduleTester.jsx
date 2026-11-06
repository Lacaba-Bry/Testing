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
    <p className="feeder-schedule-info">This is a separate CLOUD schedule tester, NOT the RTC schedule. Disable cloud test schedules and cloud dispatch cron before using RTC mode. This tester uses Supabase scheduling and requires internet access. It does not use the DS3231. The separate offline firmware tester uses the DS3231 instead; do not enable both schedulers on the same physical motor.</p>
    <details className="feeder-schedule-info">
      <summary><strong>Offline DS3231 bench test (separate ESP32 sketch)</strong></summary>
      <p>Wire VCC→3V3, GND→GND, SDA→GPIO21, SCL→GPIO22. Upload the included offline RTC test sketch, then open Arduino Serial Monitor at 115200 baud.</p>
      <pre>{`SHOW\nCLOCK 2026 11 06 20 30 00\nSET 1 08:00\nSET 2 13:00\nSET 3 19:00\nTEST 1`}</pre>
      <p>Morning = slot 1; afternoon = slot 2; evening = slot 3. The sketch starts in dry-run mode with motor output disabled. Change the example date/time to your current Philippine local time before testing. This page cannot write schedules to an offline board.</p>
    </details>
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
