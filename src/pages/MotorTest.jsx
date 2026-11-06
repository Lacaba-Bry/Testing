import { useEffect, useState } from "react";
import { ArrowClockwise, GearSix } from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import { supabase } from "../services/supabaseClient";
import "./MotorTest.css";

async function invoke(body) {
  const { data, error } = await supabase.functions.invoke("motor-test", { body });
  if (error) {
    let detail;
    try { detail = (await error.context?.json())?.error; } catch { /* network error */ }
    throw new Error(detail || error.message);
  }
  return data;
}

export default function MotorTest() {
  const [feeders, setFeeders] = useState([]);
  const [deviceId, setDeviceId] = useState("");
  const [command, setCommand] = useState(null);
  const [error, setError] = useState("");
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let active = true;
    supabase.from("devices").select("id,device_code,device_name,status")
      .eq("device_type", "feeder").eq("status", "active")
      .order("device_code")
      .then(({ data, error: fetchError }) => {
        if (!active) return;
        if (fetchError) setError(fetchError.message);
        else { setFeeders(data || []); setDeviceId(data?.[0]?.id || ""); }
      });
    return () => { active = false; };
  }, []);

  useEffect(() => {
    if (!command?.id || !["queued", "running"].includes(command.status)) return;
    let active = true;
    const timer = setInterval(async () => {
      try {
        const result = await invoke({ action: "status", device_id: deviceId, command_id: command.id });
        if (active) setCommand(result.command);
      } catch (pollError) { if (active) setError(pollError.message); }
    }, 2000);
    return () => { active = false; clearInterval(timer); };
  }, [command?.id, command?.status, deviceId]);

  async function rotate() {
    setError(""); setBusy(true); setCommand(null);
    try {
      const result = await invoke({ action: "queue", device_id: deviceId });
      setCommand(result.command);
    } catch (requestError) { setError(requestError.message); }
    finally { setBusy(false); }
  }

  const pending = busy || ["queued", "running"].includes(command?.status);
  return <section className="motor-test-page">
    <PageHeader eyebrow="Hardware" title="Feeder ESP32" description="Send one 120° rotation to your configured feeder and wait for its confirmation." />
    <div className="motor-test-card">
      <div className="motor-test-icon"><GearSix size={32} /></div>
      <label htmlFor="motor-device">Feeder device</label>
      <select id="motor-device" value={deviceId} disabled={pending} onChange={(event) => { setDeviceId(event.target.value); setCommand(null); setError(""); }}>
        {feeders.length === 0 && <option value="">No active feeders registered</option>}
        {feeders.map((feeder) => <option value={feeder.id} key={feeder.id}>{feeder.device_name || feeder.device_code} ({feeder.device_code})</option>)}
      </select>
      <p className="motor-test-note">Ensure the tray is clear before starting. This test advances one compartment (533 steps).</p>
      <button type="button" className="motor-test-button" disabled={!deviceId || pending} onClick={rotate}>
        <ArrowClockwise size={20} /> {pending ? "Waiting for feeder…" : "Rotate 120°"}
      </button>
      {command && <p className={`motor-test-status motor-test-status--${command.status}`} role="status">
        {command.status === "queued" && "Queued. Waiting for the ESP32 to poll."}
        {command.status === "running" && "ESP32 received the command. Rotation in progress."}
        {command.status === "completed" && "ESP32 confirmed rotation completed."}
        {command.status === "failed" && (command.error_message || "The feeder reported a failure.")}
        {command.status === "expired" && "The ESP32 did not pick up the command before it expired."}
      </p>}
      {error && <p className="motor-test-error" role="alert">{error}</p>}
    </div>
  </section>;
}
