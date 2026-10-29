import { createClient } from "jsr:@supabase/supabase-js@2";

const DEVICE_CODE = "carefur-camera-01";
const ORIGINS = ["http://localhost:5173", "http://127.0.0.1:5173", "https://carefur.me", "https://www.carefur.me"];
function headers(req: Request): Record<string, string> {
  const origin = req.headers.get("origin") || "";
  return {
    ...(ORIGINS.includes(origin) ? {"Access-Control-Allow-Origin": origin} : {}),
    "Access-Control-Allow-Headers": "authorization,apikey,content-type,x-client-info,x-device-secret",
    "Access-Control-Allow-Methods": "POST,OPTIONS", "Vary": "Origin",
    "Content-Type": "application/json", "Cache-Control": "no-store",
  };
}
function reply(req: Request, data: Record<string, unknown>, status = 200): Response {
  return new Response(JSON.stringify(data), {status, headers: headers(req)});
}
const ssid = (v: unknown) => typeof v === "string" && v.length <= 32 ? v : "";
Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    if (!ORIGINS.includes(req.headers.get("origin") || "")) return reply(req,{error:"Origin not allowed"},403);
    return new Response(null,{status:204,headers:headers(req)});
  }
  if (req.method !== "POST") return reply(req,{error:"Method not allowed"},405);
  const url = Deno.env.get("SUPABASE_URL");
  const anon = Deno.env.get("SUPABASE_ANON_KEY");
  const service = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  const secret = Deno.env.get("CAMERA_DEVICE_SECRET");
  if (!url || !anon || !service || !secret) return reply(req,{error:"Function not configured"},500);
  let body: Record<string, unknown>;
  try {
    const parsed = await req.json();
    if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) throw Error();
    body = parsed;
  } catch {return reply(req,{error:"Invalid JSON"},400);}
  const db = createClient(url, service, {auth:{persistSession:false}});
  const deviceOK = req.headers.get("x-device-secret") === secret && body.device_code === DEVICE_CODE;
  async function adminOK(): Promise<boolean> {
    const token = req.headers.get("authorization") || "";
    if (!token.startsWith("Bearer ")) return false;
    const auth = createClient(url!, anon!, {auth:{persistSession:false}});
    const {data,error} = await auth.auth.getUser(token.slice(7));
    if (error || !data.user) return false;
    const {data:profile} = await db.from("users").select("role").eq("id",data.user.id).maybeSingle();
    return profile?.role === "admin";
  }
  if (body.action === "report") {
    if (!deviceOK) return reply(req,{error:"Unauthorized camera"},401);
    if (typeof body.connected !== "boolean") return reply(req,{error:"Invalid connected flag"},400);
    const connected = body.connected;
    const networks = Array.isArray(body.saved_networks)
      ? [...new Set(body.saved_networks.filter((v):v is string => typeof v === "string" && v.length > 0 && v.length <= 32))].slice(0,5) : [];
    const record = {
      device_code: DEVICE_CODE, connected,
      saved_ssid:ssid(body.saved_ssid),saved_networks:networks,
      connected_ssid:connected?ssid(body.connected_ssid):"",
      ip_address:connected && typeof body.ip_address === "string" ? body.ip_address.slice(0,45):"",
      rssi:connected && Number.isInteger(body.rssi) && Number(body.rssi) >= -120 && Number(body.rssi) <= 0 ? body.rssi:null,
      paused:body.paused===true,last_seen:new Date().toISOString(),
    };
    const {error} = await db.from("device_wifi_status").upsert(record,{onConflict:"device_code"});
    if(error) {console.error("camera status upsert",error.message);return reply(req,{error:"Status database write failed"},500);}
    return reply(req,{ok:true});
  }
  if (body.action === "claim_switch") {
    if (!deviceOK) return reply(req,{error:"Unauthorized camera"},401);
    const {data:cmd,error} = await db.from("camera_wifi_switch_requests")
      .select("request_id,target_ssid,requested_at").eq("device_code",DEVICE_CODE).eq("state","pending").maybeSingle();
    if(error) return reply(req,{error:"Switch lookup failed"},500);
    if(!cmd) return reply(req,{ok:true,switch:false});
    if(Date.now()-Date.parse(cmd.requested_at)>120000) {
      await db.from("camera_wifi_switch_requests").update({state:"delivered"}).eq("request_id",cmd.request_id);
      return reply(req,{ok:true,switch:false});
    }
    const {data:claimed,error:claimError}=await db.from("camera_wifi_switch_requests")
      .update({state:"delivered",delivered_at:new Date().toISOString()})
      .eq("device_code",DEVICE_CODE).eq("request_id",cmd.request_id).eq("state","pending")
      .select("request_id").maybeSingle();
    if(claimError) return reply(req,{error:"Could not claim Wi-Fi switch"},500);
    return reply(req,{ok:true,switch:!!claimed,ssid:claimed?cmd.target_ssid:""});
  }
  if(body.action === "read" || body.action === "queue_switch") {
    if(!(await adminOK())) return reply(req,{error:"Admin access required"},403);
    const {data,error}=await db.from("device_wifi_status")
      .select("device_code,connected,saved_ssid,saved_networks,connected_ssid,ip_address,rssi,paused,last_seen")
      .eq("device_code",DEVICE_CODE).maybeSingle();
    if(error) return reply(req,{error:"Status lookup failed"},500);
    const age = data?.last_seen ? Date.now()-Date.parse(data.last_seen):Infinity;
    // Camera can be busy with MJPEG; use 20s offline threshold (heartbeat 5s).
    const online=!!(data?.connected && age>=0 && age<20000);
    if(body.action === "read") {
      const {data:request} = await db.from("camera_wifi_switch_requests")
        .select("target_ssid,state,requested_at").eq("device_code",DEVICE_CODE).maybeSingle();
      return reply(req,{ok:true,status:data,online,switch_request:request});
    }
    const target=ssid(body.ssid);
    if(!online) return reply(req,{error:"Camera offline. Use its local setup hotspot."},409);
    if(!target || !Array.isArray(data?.saved_networks) || !data.saved_networks.includes(target))
      return reply(req,{error:"Camera has not saved that network"},400);
    if(target===data.connected_ssid) return reply(req,{error:"Camera already connected to that network"},409);
    const {error:queueError}=await db.from("camera_wifi_switch_requests").upsert({
      device_code:DEVICE_CODE,request_id:crypto.randomUUID(),target_ssid:target,
      state:"pending",requested_at:new Date().toISOString(),delivered_at:null,
    },{onConflict:"device_code"});
    if(queueError) return reply(req,{error:"Could not queue camera Wi-Fi switch"},500);
    return reply(req,{ok:true,queued:true});
  }
  return reply(req,{error:"Unknown action"},400);
});
