import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { ArrowClockwise, ArrowSquareOut, CheckCircle, Info, Plug, WifiHigh, WifiSlash, WarningCircle, FloppyDisk, MagnifyingGlass, ListBullets, ArrowRight } from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import { supabase } from "../services/supabaseClient";
import "./HardwareSetup.css";
import "./FeederWiFiManager.css";

const PORTAL = "http://192.168.4.1";
function PortalLink({path="/",children}) {
  return <a href={`${PORTAL}${path}`} target="_blank" rel="noopener noreferrer" className="hardware-secondary hardware-link">{children}<ArrowSquareOut size={17}/></a>;
}
function relativeTime(iso) {
  if (!iso) return "Never";
  const secs = Math.max(0, Math.floor((Date.now() - Date.parse(iso)) / 1000));
  if (!Number.isFinite(secs)) return "Unknown";
  if (secs < 60) return `${secs} seconds ago`;
  if (secs < 3600) return `${Math.floor(secs / 60)} minutes ago`;
  return new Date(iso).toLocaleString();
}
export default function FeederWiFiManager() {
  const [state, setState] = useState({ status: null, online: false });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [now, setNow] = useState(0);
  const [switchInfo, setSwitchInfo] = useState(null);
  const [switchBusy, setSwitchBusy] = useState("");
  const [switchMessage, setSwitchMessage] = useState("");
  useEffect(() => {
    let active = true;
    async function load() {
      try {
        const { data, error: requestError } = await supabase.functions.invoke("feeder-wifi-status", {body: {action: "read"}});
        if (requestError) throw requestError;
        if (!data?.ok) throw Error(data?.error || "Could not retrieve feeder status");
        if (active) { setState({ status: data.status, online: data.online }); setSwitchInfo(data.switch_request); setError(""); }
      } catch (e) { if (active) setError(e.message || "Could not load Wi-Fi status"); }
      finally { if (active) setLoading(false); }
    }
    load();
    const poll = window.setInterval(load, 2000);
    const clock = window.setInterval(() => setNow(Date.now()), 1000);
    return () => { active = false; window.clearInterval(poll); window.clearInterval(clock); };
  }, []);
  async function requestSwitch(ssid) {
    if (!window.confirm(`Connect the feeder to saved Wi-Fi “${ssid}”? If that network is unavailable, the feeder will attempt to restore its previous connection.`)) return;
    setSwitchBusy(ssid); setSwitchMessage("");
    try {
      const {data, error: requestError} = await supabase.functions.invoke("feeder-wifi-status", {body: {action: "queue_switch", ssid}});
      if (requestError) throw requestError;
      if (!data?.ok) throw Error(data?.error || "Could not request network change");
      setSwitchMessage(`Switch requested: ${ssid}. Watch the connection status to confirm it succeeded.`);
    } catch(e) {setSwitchMessage(`Unable to switch: ${e.message || "unknown error"}`);}
    finally {setSwitchBusy("");}
  }
  const status = state.status;
  // Independently calculate staleness so a browser that loses cloud connectivity
  // still displays Offline even if its last successful response said Online.
  const fresh = status?.last_seen && (now || Date.now()) - Date.parse(status.last_seen) < 10000;
  const online = Boolean(state.online && fresh && status?.connected && !error);
  return <section className="hardware-setup feeder-wifi-page">
    <PageHeader eyebrow="Hardware Monitoring" title="Feeder Wi-Fi Manager" description="Automatic connection status reported by your feeder through Supabase." />
    <div className="hardware-note"><Info size={24}/><div><strong>Automatic monitoring</strong><p>The feeder reports its saved SSID, current network, IP address and signal about every 3 seconds. This page checks Supabase every 2 seconds; a missing heartbeat for 10 seconds means Offline. Passwords are never uploaded.</p></div></div>
    <div className="hardware-panel">
      <div className="hardware-section-heading"><WifiHigh size={24}/><h2>Feeder connection</h2></div>
      <div className="hardware-info-grid">
        <div><span>Connection</span><strong className={online ? "fw-online" : "fw-offline"}>{loading ? "Checking…" : online ? <><CheckCircle size={19}/> Online</> : <><WifiSlash size={19}/> Offline</>}</strong></div>
        <div><span>Currently connected Wi-Fi</span><strong>{online ? status.connected_ssid || "Unknown" : "Not currently reporting"}</strong></div>
        <div><span>Saved Wi-Fi (SSID)</span><strong>{status?.saved_ssid || "Not yet reported"}</strong></div>
        <div><span>Last reported IP</span><strong>{status?.ip_address || "Not yet reported"}</strong></div>
        <div><span>Last reported signal</span><strong>{typeof status?.rssi === "number" ? `${status.rssi} dBm` : "Unavailable"}</strong></div>
        <div><span>Last seen</span><strong>{relativeTime(status?.last_seen)}</strong></div>
      </div>
      <p className="hardware-subtle">Device: carefur-feeder-01. {status ? `Last report: ${new Date(status.last_seen).toLocaleString()}.` : "Waiting for its first report."} {error && <span role="alert" className="fw-error">{error}. Displayed data may be outdated.</span>}</p>
      <div className="hardware-actions"><button type="button" className="hardware-secondary" onClick={() => window.location.reload()}><ArrowClockwise size={17}/> Refresh</button></div>
    </div>
    <div className="hardware-panel"><div className="hardware-section-heading"><WifiHigh size={24}/><h2>One Wi-Fi setup for feeder + camera</h2></div>
      <p>With shared-setup firmware on BOTH ESP32 devices, enter a new router network once on the feeder's local portal. When the camera loses access to its saved router, it joins the feeder setup hotspot with its private pairing credentials, retrieves the feeder's preferred router network, saves it on the camera, then connects directly to the router.</p>
      <p>The devices keep independent Wi-Fi connections afterward. Both must be powered on and physically near each other during initial pairing; cloud status and video streaming require actual internet and the camera gateway.</p>
      <div className="hardware-actions"><PortalLink>Open shared local Wi-Fi setup</PortalLink><Link className="hardware-secondary hardware-link" to="/hardware-setup">View camera setup</Link></div>
      <p className="hardware-subtle">Only use the portal on a phone joined to CareFur-Feeder-Setup. The public dashboard never handles router passwords.</p>
    </div>
    <div className="hardware-panel fw-saved-panel">
      <div className="hardware-section-heading"><ListBullets size={24}/><h2>Saved feeder Wi-Fi networks</h2></div>
      <p>These are networks whose passwords are already saved inside your feeder. You can select one here while the ESP32 is online, without opening its local portal or entering its password again.</p>
      <div className="fw-saved-list">
        {(Array.isArray(status?.saved_networks) ? status.saved_networks : []).length ? status.saved_networks.map(ssid => <div className="fw-saved-item" key={ssid}>
          <div className="fw-saved-icon"><WifiHigh size={23}/></div>
          <div className="fw-saved-name"><strong>{ssid}</strong><small>{online && status.connected_ssid === ssid ? "Currently connected" : status.saved_ssid === ssid ? "Preferred saved network" : "Saved on feeder"}</small></div>
          <button type="button" disabled={!online || Boolean(switchBusy) || (online && status.connected_ssid === ssid)} onClick={() => requestSwitch(ssid)} className="fw-switch-button">
            {switchBusy === ssid ? "Sending…" : online && status.connected_ssid === ssid ? "Connected" : "Connect"}
          </button>
        </div>) : <div className="fw-saved-empty">{loading ? "Loading saved networks…" : "No saved networks reported yet. Install the included updated feeder firmware, then connect or add a network."}</div>}
      </div>
      {switchMessage && <p role="status" className="fw-switch-message">{switchMessage}</p>}
      {switchInfo?.state === "pending" && <p className="hardware-subtle">Pending switch: {switchInfo.target_ssid}</p>}
      <div className="hardware-inline-warning"><Info size={19}/><span>A new Wi-Fi password must still be added locally through CareFur-Feeder-Setup. Remote switching works only for previously saved networks while the feeder is online. If its new Wi-Fi is unreachable, it attempts to reconnect to its previous network.</span></div>
    </div>
    <div className="hardware-panel"><h2>Add or manage Wi-Fi locally</h2>
      <p>Network passwords remain inside the feeder. To scan, change Wi-Fi or disconnect, connect your phone to <b>CareFur-Feeder-Setup</b> nearby and use the local management page. An offline feeder cannot receive remote commands.</p>
      <div className="hardware-local-actions">
        <div className="hardware-local-action"><FloppyDisk size={23}/><div><strong>Saved Wi-Fi / change network</strong><p>Add a new router and store its password locally. Its name will appear in the saved list above after the next heartbeat.</p><PortalLink>Open local Wi-Fi manager</PortalLink></div></div>
        <div className="hardware-local-action"><MagnifyingGlass size={23}/><div><strong>Scan nearby Wi-Fi</strong><p>Scanning happens on the ESP32 itself.</p><PortalLink path="/scan">Scan networks</PortalLink></div></div>
        <div className="hardware-local-action"><Plug size={23}/><div><strong>Disconnect / reconnect</strong><p>Disconnect stops internet-based motor commands until reconnected.</p><PortalLink>Manage Wi-Fi connection</PortalLink></div></div>
      </div>
      <div className="hardware-inline-warning"><WarningCircle size={19}/><span>Local links only work when your phone or laptop can reach {PORTAL}. Your public HTTPS dashboard cannot change an offline device's Wi-Fi.</span></div>
    </div>
    <div className="hardware-panel"><h2>Feeder motor controls</h2><p>Automatic motor tests remain on the separate Feeder ESP32 page.</p><div className="hardware-actions"><Link className="hardware-primary hardware-link" to="/motor-test">Open Feeder ESP32 <ArrowSquareOut size={17}/></Link></div></div>
  </section>;
}
