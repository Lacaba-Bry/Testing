import { useCallback, useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient";
import "./FeederScheduleTester.css";

const DEFAULTS = {
  enabled: false,
  mode: "test",
  morning_time: "08:00",
  afternoon_time: "13:00",
  evening_time: "19:00",
  version: 0,
};
const shortTime = (v) => String(v || "").slice(0, 5);

export default function FeederRTCSettings({ deviceId }) {
  const [form, setForm] = useState(DEFAULTS);
  const [busy, setBusy] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");

  const load = useCallback(async () => {
    if (!deviceId) { setLoading(false); return; }
    setLoading(true);
    try {
      const { data, error: invokeError } = await supabase.functions.invoke("feeder-rtc-config", {
        body: { action: "read", device_id: deviceId },
      });
      if (invokeError) throw invokeError;
      if (!data?.ok) throw new Error(data?.error || "Could not read RTC configuration");
      const saved = data.config || {};
      setForm({
        ...DEFAULTS, ...saved,
        mode: saved.lease_mode || "test",
        morning_time: shortTime(saved.morning_time || DEFAULTS.morning_time),
        afternoon_time: shortTime(saved.afternoon_time || DEFAULTS.afternoon_time),
        evening_time: shortTime(saved.evening_time || DEFAULTS.evening_time),
      });
      setError("");
    } catch (e) {
      setError(e?.message || "RTC settings could not be loaded");
    } finally {
      setLoading(false);
    }
  }, [deviceId]);

  useEffect(() => { setNotice(""); load(); }, [load]);

  async function save(event) {
    event.preventDefault();
    if (busy || loading || !deviceId) return;
    if (form.enabled) {
      const modeText = form.mode === "test"
        ? "a 30-minute test lease in a room without checked-in pets"
        : "booking-linked RTC feeding for the checked-in pet (renewed while online)";
      if (!window.confirm(`Enable ${modeText}? The motor WILL rotate at scheduled times, including while Wi-Fi is offline. Clear the feeder area and verify compartment alignment first.`)) return;
    }
    setBusy(true); setNotice(""); setError("");
    try {
      const { data, error: invokeError } = await supabase.functions.invoke("feeder-rtc-config", {
        body: {
          action: "save", device_id: deviceId, enabled: !!form.enabled,
          mode: form.mode,
          morning_time: form.morning_time,
          afternoon_time: form.afternoon_time,
          evening_time: form.evening_time,
        },
      });
      if (invokeError) {
        let msg = invokeError.message;
        try { msg = (await invokeError.context?.json())?.error || msg; } catch { /* ignore */ }
        throw new Error(msg);
      }
      if (!data?.ok) throw new Error(data?.error || "Unable to save RTC config");
      setNotice(data.message || "RTC settings saved");
      await load();
    } catch (e) {
      setError(e?.message || "Unable to save RTC configuration");
    } finally {
      setBusy(false);
    }
  }

  const acknowledged = form.version > 0 && form.cached_version === form.version;
  const lease = form.lease_expires_at ? new Date(form.lease_expires_at).toLocaleString() : "None";

  return (
    <section className="feeder-schedule-card" aria-label="DS3231 automatic offline feeding">
      <div className="feeder-schedule-header">
        <div>
          <h2>DS3231 Automatic / Offline Feeding</h2>
          <p>The ESP32 caches a time-limited schedule so it can dispense during internet outages.</p>
        </div>
        <button type="button" className="feeder-schedule-refresh" disabled={busy || loading} onClick={load}>Refresh</button>
      </div>
      <form className="feeder-schedule-form" onSubmit={save}>
        <label>
          <input type="checkbox" checked={!!form.enabled} disabled={busy || loading}
            onChange={(e) => setForm((s) => ({ ...s, enabled: e.target.checked }))} />
          Enable automatic RTC motor feeding
        </label>
        <label>
          Operation mode
          <select value={form.mode} disabled={busy || loading}
            onChange={(e) => setForm((s) => ({ ...s, mode: e.target.value }))}>
            <option value="test">Hardware test (30 minutes, no checked-in pet)</option>
            <option value="boarding">Checked-in boarding (up to 24 hours offline; renews online)</option>
          </select>
        </label>
        {[["morning_time", "Morning / Compartment 1"], ["afternoon_time", "Afternoon / Compartment 2"], ["evening_time", "Evening / Compartment 3"]].map(([field, title]) => (
          <label key={field}>{title}
            <input type="time" required value={form[field] || ""} disabled={busy || loading}
              onChange={(e) => setForm((s) => ({ ...s, [field]: e.target.value }))} />
          </label>
        ))}
        <small>Philippine time (UTC+8). All three meals rotate the motor toward their configured compartment. Only one automatic scheduling engine should control this feeder.</small>
        <button className="feeder-schedule-save" type="submit" disabled={busy || loading || !deviceId}>
          {busy ? "Saving..." : "Save RTC Configuration"}
        </button>
      </form>
      <p className="feeder-schedule-meta">
        Cloud version: <strong>{form.version || 0}</strong>. ESP32 cache version: <strong>{form.cached_version ?? "Not acknowledged"}</strong>.
        {acknowledged ? " Device confirmed latest configuration." : " Wait for ESP32 connection and acknowledgment."}
      </p>
      <p className="feeder-schedule-meta">Lease expires: <strong>{lease}</strong>. RTC is <strong>{form.enabled ? "enabled" : "disabled"}</strong>.</p>
      <p className="feeder-schedule-info">
        When enabling, confirm physical position/homing and supervise the first rotation.
        Offline cancellation cannot reach a disconnected ESP32 immediately: it stops at lease expiry.
        Disable RTC and confirm the ESP32 acknowledgment before moving the Smart Unit.
      </p>
      {notice && <p className="feeder-schedule-success" role="status">{notice}</p>}
      {error && <p className="feeder-schedule-error" role="alert">{error}</p>}
    </section>
  );
}
