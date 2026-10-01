import { useEffect, useMemo, useRef, useState } from "react";
import {
  ArrowClockwise,
  ArrowSquareOut,
  Camera,
  CheckCircle,
  Image as ImageIcon,
  Play,
  Stop,
  WarningCircle,
  WifiHigh,
  WifiSlash,
} from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import "./CameraTest.css";

const DEFAULT_CAMERA_URL =
  import.meta.env.VITE_ESP32_CAM_URL || "http://192.168.1.87";

const TEST_TIMEOUT_MS = 6000;

function normalizeBaseUrl(value) {
  const trimmed = String(value || "").trim();
  if (!trimmed) return "";

  const withProtocol = /^https?:\/\//i.test(trimmed)
    ? trimmed
    : `http://${trimmed}`;

  return withProtocol.replace(/\/+$/, "");
}

function buildCameraUrls(baseUrl) {
  const normalized = normalizeBaseUrl(baseUrl);
  if (!normalized) {
    return {
      base: "",
      capture: "",
      stream: "",
    };
  }

  let stream = `${normalized}:81/stream`;

  try {
    const url = new URL(normalized);
    const host = url.hostname.includes(":") ? `[${url.hostname}]` : url.hostname;
    stream = `${url.protocol}//${host}:81/stream`;
  } catch {
    // Keep fallback URL if the value cannot be parsed by URL().
  }

  return {
    base: normalized,
    capture: `${normalized}/capture`,
    stream,
  };
}

function checkImage(url, timeoutMs = TEST_TIMEOUT_MS) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    const started = performance.now();
    let finished = false;

    const cleanup = () => {
      image.onload = null;
      image.onerror = null;
    };

    const timer = window.setTimeout(() => {
      if (finished) return;
      finished = true;
      cleanup();
      reject(new Error("Camera did not respond before the timeout."));
    }, timeoutMs);

    image.onload = () => {
      if (finished) return;
      finished = true;
      window.clearTimeout(timer);
      const elapsed = Math.round(performance.now() - started);
      cleanup();
      resolve({ elapsed, width: image.naturalWidth, height: image.naturalHeight });
    };

    image.onerror = () => {
      if (finished) return;
      finished = true;
      window.clearTimeout(timer);
      cleanup();
      reject(new Error("Could not load a frame from the ESP32-CAM."));
    };

    const separator = url.includes("?") ? "&" : "?";
    image.src = `${url}${separator}t=${Date.now()}`;
  });
}

export default function CameraTest() {
  const [cameraUrl, setCameraUrl] = useState(DEFAULT_CAMERA_URL);
  const [status, setStatus] = useState("idle");
  const [message, setMessage] = useState("Camera has not been tested yet.");
  const [latency, setLatency] = useState(null);
  const [dimensions, setDimensions] = useState("");
  const [snapshotUrl, setSnapshotUrl] = useState("");
  const [streaming, setStreaming] = useState(false);
  const [streamError, setStreamError] = useState(false);
  const streamRef = useRef(null);

  const urls = useMemo(() => buildCameraUrls(cameraUrl), [cameraUrl]);

  const mixedContent =
    typeof window !== "undefined" &&
    window.location.protocol === "https:" &&
    urls.base.startsWith("http://");

  async function testCamera() {
    setStatus("testing");
    setMessage("Checking camera capture endpoint…");
    setLatency(null);
    setDimensions("");
    setStreamError(false);

    if (!urls.capture) {
      setStatus("offline");
      setMessage("Enter a valid ESP32-CAM address first.");
      return;
    }

    if (mixedContent) {
      setStatus("blocked");
      setMessage(
        "This HTTPS page cannot directly load the camera's HTTP address. Test from localhost/HTTP or use an HTTPS camera gateway.",
      );
      return;
    }

    try {
      const result = await checkImage(urls.capture);
      setStatus("online");
      setLatency(result.elapsed);
      setDimensions(`${result.width} × ${result.height}`);
      setMessage("ESP32-CAM responded successfully.");
      setSnapshotUrl(`${urls.capture}?t=${Date.now()}`);
    } catch (error) {
      setStatus("offline");
      setMessage(error?.message || "Camera test failed.");
    }
  }

  function refreshSnapshot() {
    if (!urls.capture || mixedContent) return;
    setSnapshotUrl(`${urls.capture}?t=${Date.now()}`);
  }

  function startStream() {
    if (!urls.stream || mixedContent) return;
    setStreamError(false);
    setStreaming(true);
  }

  function stopStream() {
    setStreaming(false);
    setStreamError(false);
    if (streamRef.current) streamRef.current.src = "";
  }

  useEffect(() => {
    setStreaming(false);
    setStreamError(false);
    setSnapshotUrl("");
    setStatus("idle");
    setMessage("Camera has not been tested yet.");
    setLatency(null);
    setDimensions("");
  }, [cameraUrl]);

  return (
    <section className="camera-test-page">
      <PageHeader
        eyebrow="Hardware"
        title="Camera Test"
        description="Check the ESP32-CAM on your local network, capture a still frame, and preview its MJPEG stream."
      />

      <div className="camera-test-layout">
        <div className="camera-test-card">
          <div className="camera-test-card__heading">
            <div className="camera-test-icon"><Camera size={30} weight="duotone" /></div>
            <div>
              <h2>ESP32-CAM connection</h2>
              <p>The browser running CareFur must be on the same network as the camera.</p>
            </div>
          </div>

          <label htmlFor="camera-url">Camera address</label>
          <div className="camera-url-row">
            <input
              id="camera-url"
              value={cameraUrl}
              onChange={(event) => setCameraUrl(event.target.value)}
              placeholder="http://192.168.1.87"
              spellCheck="false"
            />
            <button
              className="camera-test-secondary"
              type="button"
              onClick={() => window.open(urls.base, "_blank", "noopener,noreferrer")}
              disabled={!urls.base}
            >
              <ArrowSquareOut size={18} /> Open
            </button>
          </div>

          <div className={`camera-test-status camera-test-status--${status}`} role="status">
            <StatusIcon status={status} />
            <div>
              <strong>{statusLabel(status)}</strong>
              <span>{message}</span>
            </div>
          </div>

          {mixedContent && (
            <div className="camera-test-warning">
              <WarningCircle size={20} />
              <p>
                Your CareFur page is using HTTPS while the ESP32-CAM uses HTTP. Browsers block that as mixed content. Direct camera testing works from your local HTTP development site; production needs an HTTPS proxy/gateway.
              </p>
            </div>
          )}

          <div className="camera-test-actions">
            <button
              className="camera-test-primary"
              type="button"
              onClick={testCamera}
              disabled={status === "testing" || !urls.capture}
            >
              <ArrowClockwise size={19} />
              {status === "testing" ? "Testing…" : "Test Camera"}
            </button>

            <button
              className="camera-test-secondary"
              type="button"
              onClick={refreshSnapshot}
              disabled={!urls.capture || mixedContent}
            >
              <ImageIcon size={18} /> Snapshot
            </button>
          </div>

          <dl className="camera-test-details">
            <div><dt>Capture</dt><dd>{urls.capture || "—"}</dd></div>
            <div><dt>Stream</dt><dd>{urls.stream || "—"}</dd></div>
            <div><dt>Response</dt><dd>{latency !== null ? `${latency} ms` : "—"}</dd></div>
            <div><dt>Frame</dt><dd>{dimensions || "—"}</dd></div>
          </dl>
        </div>

        <div className="camera-preview-card">
          <div className="camera-preview-card__heading">
            <div>
              <span>Live preview</span>
              <h2>CareFur Camera</h2>
            </div>
            <div className="camera-preview-actions">
              {!streaming ? (
                <button type="button" onClick={startStream} disabled={mixedContent || !urls.stream}>
                  <Play size={17} weight="fill" /> Start Stream
                </button>
              ) : (
                <button type="button" onClick={stopStream}>
                  <Stop size={17} weight="fill" /> Stop Stream
                </button>
              )}
            </div>
          </div>

          <div className="camera-live-frame">
            {streaming ? (
              <img
                ref={streamRef}
                src={`${urls.stream}?t=${Date.now()}`}
                alt="ESP32-CAM live stream"
                onLoad={() => setStreamError(false)}
                onError={() => setStreamError(true)}
              />
            ) : snapshotUrl ? (
              <img src={snapshotUrl} alt="Latest ESP32-CAM snapshot" />
            ) : (
              <div className="camera-live-placeholder">
                <Camera size={52} weight="duotone" />
                <strong>No camera preview yet</strong>
                <span>Run Test Camera or start the stream.</span>
              </div>
            )}

            {streaming && streamError && (
              <div className="camera-stream-error">
                <WifiSlash size={28} />
                <strong>Stream unavailable</strong>
                <span>Make sure the ESP32-CAM stream endpoint is available on port 81.</span>
              </div>
            )}
          </div>

          <p className="camera-preview-help">
            The standard ESP32 CameraWebServer uses <code>/capture</code> for still images and port <code>81/stream</code> for MJPEG video.
          </p>
        </div>
      </div>
    </section>
  );
}

function StatusIcon({ status }) {
  if (status === "online") return <CheckCircle size={24} weight="fill" />;
  if (status === "testing") return <ArrowClockwise size={24} className="camera-test-spin" />;
  if (status === "offline") return <WifiSlash size={24} weight="fill" />;
  if (status === "blocked") return <WarningCircle size={24} weight="fill" />;
  return <WifiHigh size={24} />;
}

function statusLabel(status) {
  switch (status) {
    case "testing": return "Testing camera";
    case "online": return "Camera online";
    case "offline": return "Camera unavailable";
    case "blocked": return "Browser blocked camera";
    default: return "Ready to test";
  }
}
