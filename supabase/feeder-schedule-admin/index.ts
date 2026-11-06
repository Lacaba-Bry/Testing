import { createClient } from "jsr:@supabase/supabase-js@2";

const ALLOWED_ORIGINS = [
  "https://admin.carefur.me", "http://localhost:5173", "http://127.0.0.1:5173",
  "https://carefur.me", "https://www.carefur.me",
];

function headers(req: Request): HeadersInit {
  const origin = req.headers.get("origin") || "";
  return {
    ...(ALLOWED_ORIGINS.includes(origin) ? { "Access-Control-Allow-Origin": origin } : {}),
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
    "Vary": "Origin", "Content-Type": "application/json", "Cache-Control": "no-store",
  };
}
function reply(req: Request, data: Record<string, unknown>, status=200) {
  return new Response(JSON.stringify(data), { status, headers: headers(req) });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    if (!ALLOWED_ORIGINS.includes(req.headers.get("origin") || "")) return reply(req, {error:"Origin not allowed"},403);
    return new Response(null,{status:204,headers:headers(req)});
  }
  if (req.method !== "POST") return reply(req,{error:"Method not allowed"},405);
  try {
    const url=Deno.env.get("SUPABASE_URL");
    const anon=Deno.env.get("SUPABASE_ANON_KEY");
    const service=Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!url || !anon || !service) return reply(req,{error:"Server not configured"},500);
    const auth=req.headers.get("authorization") || "";
    if (!auth.startsWith("Bearer ")) return reply(req,{error:"Please sign in"},401);
    const authClient=createClient(url,anon,{auth:{persistSession:false,autoRefreshToken:false}});
    const {data: userData,error:userError}=await authClient.auth.getUser(auth.slice(7));
    if (userError || !userData.user) return reply(req,{error:"Invalid session"},401);
    const db=createClient(url,service,{auth:{persistSession:false,autoRefreshToken:false}});
    const {data:profile,error:profileError}=await db.from("users").select("role").eq("id",userData.user.id).maybeSingle();
    if (profileError || profile?.role!=="admin") return reply(req,{error:"Admin access required"},403);
    const body:unknown=await req.json();
    if (!body || typeof body!=="object" || Array.isArray(body)) return reply(req,{error:"Invalid body"},400);
    const data=body as Record<string,unknown>;
    const action=data.action;
    const deviceId=data.device_id;
    if (typeof deviceId!=="string" || !/^[0-9a-f-]{36}$/i.test(deviceId)) return reply(req,{error:"Invalid feeder ID"},400);
    const {data:device,error:deviceError}=await db.from("devices")
      .select("id,device_code,device_name,device_type,status")
      .eq("id",deviceId).eq("device_type","feeder").eq("status","active").maybeSingle();
    if (deviceError || !device?.device_code) return reply(req,{error:"Active feeder not found"},404);
    if (action==="list") {
      const {data:items,error}=await db.from("feeder_test_schedules")
        .select("id,device_code,schedule_type,run_at,local_time,enabled,last_fired_key,last_result,last_attempt_at,last_command_id,created_at")
        .eq("device_code",device.device_code).order("created_at",{ascending:false}).limit(30);
      if(error) return reply(req,{error:error.message},500);
      return reply(req,{ok:true,schedules:items || []});
    }
    if (action==="create") {
      const kind=data.schedule_type;
      if(kind!=="once" && kind!=="daily") return reply(req,{error:"Invalid schedule type"},400);
      let runAt:string|null=null;
      let localTime:string|null=null;
      if(kind==="once") {
        // Require an explicit Philippine UTC+08 timestamp, independent of browser timezone.
        if(typeof data.run_at!=="string" || !/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:00\+08:00$/.test(data.run_at)) return reply(req,{error:"Select a valid Philippine date and time"},400);
        const parsed=new Date(data.run_at);
        if(Number.isNaN(parsed.getTime())) return reply(req,{error:"Invalid date/time"},400);
        const offset=parsed.getTime()-Date.now();
        if(offset<60000 || offset>30*86400000) return reply(req,{error:"One-time feeding must be 1 minute to 30 days ahead"},400);
        runAt=parsed.toISOString();
      } else {
        if(typeof data.local_time!=="string" || !/^([01]\d|2[0-3]):[0-5]\d$/.test(data.local_time)) return reply(req,{error:"Use HH:MM time"},400);
        localTime=data.local_time+":00";
      }
      const {data:record,error}=await db.from("feeder_test_schedules").insert({
        device_code:device.device_code,created_by:userData.user.id,schedule_type:kind,
        run_at:runAt,local_time:localTime,enabled:true,
      }).select("id,device_code,schedule_type,run_at,local_time,enabled,created_at").single();
      if(error) return reply(req,{error:error.message},500);
      return reply(req,{ok:true,schedule:record},201);
    }
    if(action==="disable") {
      if(typeof data.schedule_id!=="string" || !/^[0-9a-f-]{36}$/i.test(data.schedule_id)) return reply(req,{error:"Invalid schedule ID"},400);
      const {data:updated,error}=await db.from("feeder_test_schedules").update({enabled:false})
        .eq("id",data.schedule_id).eq("device_code",device.device_code).select("id,enabled").maybeSingle();
      if(error) return reply(req,{error:error.message},500);
      if(!updated) return reply(req,{error:"Schedule not found"},404);
      return reply(req,{ok:true,schedule:updated});
    }
    return reply(req,{error:"Unknown action"},400);
  } catch(error) {
    console.error("Schedule function error",error);
    return reply(req,{error:"Unexpected schedule error"},500);
  }
});
