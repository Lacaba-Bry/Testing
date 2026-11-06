import { createClient } from "jsr:@supabase/supabase-js@2";
const ORIGINS = new Set(["https://admin.carefur.me", "http://localhost:5173", "http://127.0.0.1:5173"]);
function cors(req:Request) { const o=req.headers.get("origin")||""; return {
  ...(ORIGINS.has(o) ? {"Access-Control-Allow-Origin":o}:{}),
  "Access-Control-Allow-Headers":"authorization, apikey, content-type, x-client-info, x-device-secret",
  "Access-Control-Allow-Methods":"POST, OPTIONS", "Vary":"Origin", "Cache-Control":"no-store",
  "Content-Type":"application/json"}; }
function reply(req:Request,data:unknown,status=200){return new Response(JSON.stringify(data),{status,headers:cors(req)});}
const validTime=(s:unknown):s is string=>typeof s==="string" && /^([01]\d|2[0-3]):[0-5]\d$/.test(s);
Deno.serve(async(req)=>{
  if(req.method==="OPTIONS")return ORIGINS.has(req.headers.get("origin")||"")?new Response(null,{status:204,headers:cors(req)}):reply(req,{error:"Origin not allowed"},403);
  if(req.method!=="POST")return reply(req,{error:"Method not allowed"},405);
  try{
    const url=Deno.env.get("SUPABASE_URL"),service=Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"),anon=Deno.env.get("SUPABASE_ANON_KEY");
    if(!url||!service||!anon)return reply(req,{error:"Server credentials not configured"},500);
    const db=createClient(url,service,{auth:{persistSession:false,autoRefreshToken:false}});
    const body=await req.json();
    if(!body||typeof body!=="object"||Array.isArray(body))return reply(req,{error:"Invalid JSON"},400);
    if(body.action==="device_sync"){
      const configured=Deno.env.get("DEVICE_SECRET")||"";
      const provided=req.headers.get("x-device-secret")||"";
      // Reject missing/incorrect secret. Always use HTTPS with CA verification on the device.
      if(!configured || !provided || provided!==configured)return reply(req,{error:"Unauthorized device"},401);
      if(body.device_code!=="carefur-feeder-01")return reply(req,{error:"Unknown feeder"},403);
      const {data,error}=await db.from("feeder_rtc_configs").select("device_code,enabled,morning_time,afternoon_time,evening_time,version,updated_at").eq("device_code",body.device_code).maybeSingle();
      if(error)return reply(req,{error:"Configuration read failed"},500);
      return reply(req,{ok:true,config:data||{device_code:body.device_code,enabled:false,version:0,morning_time:"08:00",afternoon_time:"13:00",evening_time:"19:00"}});
    }
    const token=(req.headers.get("authorization")||"").replace(/^Bearer\s+/i,"");
    if(!token)return reply(req,{error:"Sign in required"},401);
    const client=createClient(url,anon,{auth:{persistSession:false,autoRefreshToken:false}});
    const {data:user,error:authError}=await client.auth.getUser(token);
    if(authError||!user.user)return reply(req,{error:"Invalid session"},401);
    const {data:profile,error:roleError}=await db.from("users").select("role").eq("id",user.user.id).maybeSingle();
    if(roleError||profile?.role!=="admin")return reply(req,{error:"Admin required"},403);
    if(typeof body.device_id!=="string")return reply(req,{error:"Feeder device ID required"},400);
    const {data:device,error:devErr}=await db.from("devices").select("device_code").eq("id",body.device_id).eq("device_type","feeder").eq("status","active").maybeSingle();
    if(devErr||!device?.device_code)return reply(req,{error:"Feeder not found"},404);
    if(body.action==="read"){
      const {data,error}=await db.from("feeder_rtc_configs").select("*").eq("device_code",device.device_code).maybeSingle();
      if(error)return reply(req,{error:error.message},500);
      return reply(req,{ok:true,config:data||{enabled:false,morning_time:"08:00",afternoon_time:"13:00",evening_time:"19:00",version:0}});
    }
    if(body.action==="save"){
      for(const k of ["morning_time","afternoon_time","evening_time"])if(!validTime(body[k]))return reply(req,{error:`Invalid ${k}; use HH:MM`},400);
      if(typeof body.enabled!=="boolean")return reply(req,{error:"Enabled must be boolean"},400);
      // One feeder cannot safely run cloud tester schedules alongside the offline RTC mode.
      if(body.enabled){
        const {error:offError}=await db.from("feeder_test_schedules").update({enabled:false}).eq("device_code",device.device_code).eq("enabled",true);
        if(offError)return reply(req,{error:"Could not disable cloud test schedules: "+offError.message},500);
        const {data:queued,error:queueError}=await db.from("feeder_test_commands").select("id").eq("device_code",device.device_code).in("status",["pending","claimed"]).limit(1);
        if(queueError)return reply(req,{error:"Could not inspect motor queue"},500);
        if(queued?.length)return reply(req,{error:"Resolve pending motor commands before enabling RTC mode"},409);
      }
      const {data:old,error:oldErr}=await db.from("feeder_rtc_configs").select("version").eq("device_code",device.device_code).maybeSingle();
      if(oldErr)return reply(req,{error:"Could not inspect config version"},500);
      const {data,error}=await db.from("feeder_rtc_configs").upsert({device_code:device.device_code,enabled:body.enabled,
        morning_time:body.morning_time+":00", afternoon_time:body.afternoon_time+":00", evening_time:body.evening_time+":00",
        version:(old?.version||0)+1,updated_at:new Date().toISOString(),updated_by:user.user.id},{onConflict:"device_code"}).select("*").single();
      if(error)return reply(req,{error:error.message},500);
      return reply(req,{ok:true,config:data,message:"Saved in cloud; the ESP32 must connect once to cache this configuration."});
    }
    return reply(req,{error:"Unknown action"},400);
  }catch(e){console.error("RTC config endpoint error",e);return reply(req,{error:"RTC service error"},500);}
});
