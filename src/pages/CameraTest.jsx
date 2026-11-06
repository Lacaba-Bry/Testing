import { useCallback, useEffect, useRef, useState } from "react";
import { ArrowClockwise, ArrowSquareOut, Camera, CheckCircle, Image as ImageIcon, Play, Stop, WarningCircle, WifiSlash } from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import { CAMERA_GATEWAY_URL, cameraEndpoint, checkCameraGateway, authenticatedSnapshot, consumeAuthenticatedMJPEG } from "../services/cameraGateway";
import "./CameraTest.css";

const TEST_TIMEOUT_MS = 15000;
function normalizeAddress(value) {
  const cleaned = String(value || "").trim().replace(/\/+$/, "");
  try {
    const url = new URL(cleaned);
    return ["https:", "http:"].includes(url.protocol) && !url.username && !url.password
      ? url.origin + (url.pathname === "/" ? "" : url.pathname.replace(/\/+$/, "")) : "";
  } catch { return ""; }
}
function imageDimensions(src) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(`${image.naturalWidth} × ${image.naturalHeight}`);
    image.onerror = () => reject(new Error("The gateway returned an unreadable camera image."));
    image.src = src;
  });
}
export default function CameraTest() {
  const [inputUrl, setInputUrl] = useState(CAMERA_GATEWAY_URL);
  const base = normalizeAddress(inputUrl);
  const mixed = Boolean(base && window.location.protocol === "https:" && base.startsWith("http:"));
  const [status, setStatus] = useState("idle");
  const [message, setMessage] = useState("Sign in as an admin, then test your internet camera gateway.");
  const [latency, setLatency] = useState(null);
  const [dimensions, setDimensions] = useState("");
  const [snapshot, setSnapshot] = useState("");
  const [streamFrame, setStreamFrame] = useState("");
  const [streaming, setStreaming] = useState(false);
  const [streamLoaded, setStreamLoaded] = useState(false);
  const [streamError, setStreamError] = useState("");
  const [streamFrames, setStreamFrames] = useState(0);
  const snapshotUrlRef = useRef("");
  const frameUrlRef = useRef("");
  const streamControllerRef = useRef(null);
  const testControllerRef = useRef(null);
  const mountedRef = useRef(true);
  const streamStartRef = useRef(0);

  const stopStream = useCallback(() => {
    streamControllerRef.current?.abort();
    streamControllerRef.current = null;
    if (frameUrlRef.current) URL.revokeObjectURL(frameUrlRef.current);
    frameUrlRef.current = "";
    setStreamFrame(""); setStreaming(false); setStreamLoaded(false);
  }, []);
  const clearSnapshot = useCallback(() => {
    if (snapshotUrlRef.current) URL.revokeObjectURL(snapshotUrlRef.current);
    snapshotUrlRef.current = ""; setSnapshot("");
  }, []);
  useEffect(() => {
    mountedRef.current = true;
    return () => {
      mountedRef.current = false;
      testControllerRef.current?.abort();
      streamControllerRef.current?.abort();
      if (snapshotUrlRef.current) URL.revokeObjectURL(snapshotUrlRef.current);
      if (frameUrlRef.current) URL.revokeObjectURL(frameUrlRef.current);
    };
  }, []);
  useEffect(() => {
    testControllerRef.current?.abort(); stopStream(); clearSnapshot();
    setStatus("idle"); setMessage("Sign in as an admin, then test your internet camera gateway.");
    setLatency(null); setDimensions(""); setStreamError(""); setStreamFrames(0);
  }, [inputUrl, stopStream, clearSnapshot]);

  async function takeSnapshot() {
    if (!base || mixed) return;
    const controller = new AbortController();
    testControllerRef.current?.abort(); testControllerRef.current = controller;
    try {
      const url = await authenticatedSnapshot(base, controller.signal);
      if (controller.signal.aborted || !mountedRef.current) { URL.revokeObjectURL(url); return; }
      clearSnapshot(); snapshotUrlRef.current = url; setSnapshot(url);
      setDimensions(await imageDimensions(url));
      stopStream(); setMessage("Authenticated snapshot loaded."); setStatus("online");
    } catch (error) {
      if (!controller.signal.aborted && mountedRef.current) { setStatus("offline"); setMessage(error.message || "Snapshot failed."); }
    }
  }
  async function testCamera() {
    testControllerRef.current?.abort();
    if (!base || mixed) { setStatus("blocked"); setMessage("Use a valid HTTPS gateway URL."); return; }
    const controller = new AbortController(); testControllerRef.current = controller;
    const timeout = setTimeout(() => controller.abort(), TEST_TIMEOUT_MS);
    setStatus("testing"); setMessage("Authenticating and checking recent uploaded frames…"); setLatency(null);
    const started = performance.now();
    try {
      const health = await checkCameraGateway(base, controller.signal);
      const url = await authenticatedSnapshot(base, controller.signal);
      if (controller.signal.aborted || !mountedRef.current) { URL.revokeObjectURL(url); return; }
      const size = await imageDimensions(url);
      clearSnapshot(); snapshotUrlRef.current = url; setSnapshot(url);
      stopStream(); setDimensions(size); setLatency(Math.round(performance.now() - started));
      setStatus("online");
      setMessage(`Camera frames arriving securely${health.age_ms != null ? ` (${Math.round(health.age_ms)} ms since latest frame)` : ""}.`);
    } catch (error) {
      if (!mountedRef.current) return;
      setStatus("offline");
      setMessage(controller.signal.aborted ? "Gateway test timed out." : error.message || "Camera test failed.");
    } finally { clearTimeout(timeout); }
  }
  async function startStream() {
    if (!base || mixed || streaming) return;
    stopStream(); setStreamError(""); setStreamFrames(0); setStreaming(true); setStreamLoaded(false);
    const controller = new AbortController(); streamControllerRef.current = controller;
    streamStartRef.current = Date.now();
    try {
      await consumeAuthenticatedMJPEG(base, controller.signal, (url) => {
        if (controller.signal.aborted || !mountedRef.current) { URL.revokeObjectURL(url); return; }
        if (frameUrlRef.current) URL.revokeObjectURL(frameUrlRef.current);
        frameUrlRef.current = url;
        setStreamFrame(url); setStreamLoaded(true); setStreamFrames((count) => count + 1);
        if (Date.now() - streamStartRef.current > 1000) streamStartRef.current = Date.now();
      });
    } catch (error) {
      if (!controller.signal.aborted && mountedRef.current) setStreamError(error.message || "Camera stream interrupted.");
    } finally {
      if (streamControllerRef.current === controller && mountedRef.current) setStreaming(false);
      if (streamControllerRef.current === controller) streamControllerRef.current = null;
    }
  }

  return (
    <section className="camera-test-page">
      <PageHeader eyebrow="Hardware Monitoring" title="Camera Test" description="Watch frames uploaded through Cloudflare, even when your ESP32-CAM is on another Wi-Fi network." />
      <div className="camera-test-layout">
        <div className="camera-test-card">
          <div className="camera-test-card__heading"><div className="camera-test-icon"><Camera size={30} weight="duotone" /></div><div><h2>CareFur internet camera gateway</h2><p>Camera pushes JPEG frames to your laptop. Only signed-in administrators may view them.</p></div></div>
          <label htmlFor="camera-url">HTTPS gateway URL</label>
          <div className="camera-url-row"><input id="camera-url" value={inputUrl} onChange={(e) => setInputUrl(e.target.value)} placeholder="https://camera.apicarefur.me" spellCheck={false}/><button className="camera-test-secondary" type="button" onClick={() => window.open(base, "_blank", "noopener,noreferrer")} disabled={!base}><ArrowSquareOut size={18}/> Open</button></div>
          <div className={`camera-test-status camera-test-status--${status}`} role="status">
            {status === "online" ? <CheckCircle size={24} weight="fill"/> : status === "testing" ? <ArrowClockwise size={24} className="camera-test-spin"/> : status === "offline" ? <WifiSlash size={24}/> : <WarningCircle size={24}/>}
            <div><strong>{({online:"Camera online",testing:"Testing camera",offline:"Camera unavailable",blocked:"Invalid gateway URL"})[status] || "Ready to test"}</strong><span>{message}</span></div>
          </div>
          {mixed && <div className="camera-test-warning"><WarningCircle size={20}/><p>Use HTTPS for your public CareFur gateway.</p></div>}
          <div className="camera-test-actions"><button className="camera-test-primary" type="button" onClick={testCamera} disabled={status === "testing" || !base || mixed}><ArrowClockwise size={19}/> {status === "testing" ? "Testing…" : "Test Camera"}</button><button className="camera-test-secondary" type="button" disabled={!base || mixed} onClick={takeSnapshot}><ImageIcon size={18}/> Snapshot</button></div>
          <dl className="camera-test-details"><div><dt>Health</dt><dd>{base ? cameraEndpoint("health", base) : "—"}</dd></div><div><dt>Capture</dt><dd>{base ? cameraEndpoint("capture", base) : "—"}</dd></div><div><dt>Stream</dt><dd>{base ? cameraEndpoint("stream", base) : "—"}</dd></div><div><dt>Test time</dt><dd>{latency !== null ? `${latency} ms` : "—"}</dd></div><div><dt>Image</dt><dd>{dimensions || "—"}</dd></div></dl>
        </div>
        <div className="camera-preview-card">
          <div className="camera-preview-card__heading"><div><span>Authenticated live preview</span><h2>CareFur ESP32-CAM</h2></div><div className="camera-preview-actions">{streaming ? <button type="button" onClick={stopStream}><Stop size={17} weight="fill"/> Stop Stream</button> : <button type="button" disabled={!base || mixed} onClick={startStream}><Play size={17} weight="fill"/> Start Stream</button>}</div></div>
          <div className="camera-live-frame">
            {streaming && streamFrame ? <img src={streamFrame} alt="Live ESP32-CAM stream"/> : !streaming && snapshot ? <img src={snapshot} alt="Authenticated camera snapshot"/> : <div className="camera-live-placeholder"><Camera size={52} weight="duotone"/><strong>No camera preview yet</strong><span>Run Camera Test or Start Stream.</span></div>}
            {streaming && !streamLoaded && !streamError && <div className="camera-stream-hint">Authenticating and receiving frames…</div>}
            {streamError && <div className="camera-stream-error"><WifiSlash size={28}/><strong>Stream interrupted</strong><span>{streamError}</span></div>}
            {streaming && streamLoaded && <div className="camera-stream-hint">LIVE · {streamFrames} frames received</div>}
          </div>
          <p className="camera-preview-help">Authenticated requests use your current Supabase login. Camera frames travel via your push gateway; they do not require a direct LAN connection.</p>
        </div>
      </div>
    </section>
  );
}
