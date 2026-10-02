// CareFur push-camera gateway. All protected requests carry the signed-in
// administrator's Supabase access token; never put access tokens in URLs.
import { supabase } from "./supabaseClient";

export const CAMERA_GATEWAY_URL = (import.meta.env.VITE_ESP32_CAM_URL || "https://camera.apicarefur.me").trim().replace(/\/+$/, "");

export function cameraEndpoint(path, base = CAMERA_GATEWAY_URL) {
  return `${base.replace(/\/+$/, "")}/${path.replace(/^\/+/, "")}`;
}

async function authHeaders() {
  const { data, error } = await supabase.auth.getSession();
  if (error || !data?.session?.access_token) {
    throw new Error("Sign in to your CareFur administrator account first.");
  }
  return { Authorization: `Bearer ${data.session.access_token}` };
}

export async function authenticatedCameraRequest(path, base = CAMERA_GATEWAY_URL, signal) {
  const response = await fetch(cameraEndpoint(path, base), {
    headers: await authHeaders(), method: "GET", cache: "no-store",
    credentials: "omit", signal,
  });
  if (!response.ok) {
    let detail = "";
    try { detail = (await response.json())?.error || ""; } catch { /* Non-JSON error response */ }
    if (response.status === 401) throw new Error("Camera access denied (401). Sign in again, then retry.");
    if (response.status === 403) throw new Error("Camera access denied (403). Your CareFur account must have the admin role.");
    throw new Error(detail || `Camera gateway returned HTTP ${response.status}.`);
  }
  return response;
}

export async function checkCameraGateway(base = CAMERA_GATEWAY_URL, signal) {
  const response = await authenticatedCameraRequest("health", base, signal);
  const result = await response.json();
  if (!result?.ok) throw new Error("The camera gateway returned an invalid health response.");
  if (!result.camera_online) throw new Error("The gateway is online, but it has not received a recent camera frame.");
  return result;
}

export async function authenticatedSnapshot(base = CAMERA_GATEWAY_URL, signal) {
  const response = await authenticatedCameraRequest("capture", base, signal);
  const blob = await response.blob();
  if (!blob.type.startsWith("image/") || !blob.size) throw new Error("The gateway did not return an image.");
  return URL.createObjectURL(blob);
}

// Read the authenticated multipart MJPEG response directly. Regular <img src>
// cannot attach Authorization headers. Each frame becomes a short-lived blob
// URL; the caller revokes previous URLs to avoid memory growth.
export async function consumeAuthenticatedMJPEG(base, signal, onFrame) {
  const response = await authenticatedCameraRequest("stream", base, signal);
  if (!response.body) throw new Error("This browser does not support streaming video responses.");
  const reader = response.body.getReader();
  let pending = new Uint8Array(0);
  const MAX_PENDING = 1024 * 1024;
  const START_A = 0xff, START_B = 0xd8, END_A = 0xff, END_B = 0xd9;
  try {
    while (!signal.aborted) {
      const { value, done } = await reader.read();
      if (done) {
        if (!signal.aborted) throw new Error("Camera stream closed. Check your camera's internet connection.");
        return;
      }
      if (!value?.length) continue;
      const merged = new Uint8Array(pending.length + value.length);
      merged.set(pending); merged.set(value, pending.length);
      pending = merged;
      while (pending.length >= 4) {
        let start = -1;
        for (let i = 0; i < pending.length - 1; i++) {
          if (pending[i] === START_A && pending[i + 1] === START_B) { start = i; break; }
        }
        if (start < 0) { pending = pending.slice(-1); break; }
        if (start > 0) pending = pending.slice(start);
        let end = -1;
        for (let i = 2; i < pending.length - 1; i++) {
          if (pending[i] === END_A && pending[i + 1] === END_B) { end = i + 2; break; }
        }
        if (end < 0) break;
        const frame = pending.slice(0, end);
        pending = pending.slice(end);
        onFrame(URL.createObjectURL(new Blob([frame], { type: "image/jpeg" })));
      }
      if (pending.length > MAX_PENDING) {
        throw new Error("Camera frame exceeded the stream safety limit.");
      }
    }
  } finally {
    try { await reader.cancel(); } catch { /* stream already closed */ }
    reader.releaseLock();
  }
}
