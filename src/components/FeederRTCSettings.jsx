import {useCallback,useEffect,useState} from "react";
import {supabase} from "../services/supabaseClient";
import "./FeederScheduleTester.css";
const initial={enabled:false,morning_time:"08:00",afternoon_time:"13:00",evening_time:"19:00",version:0};
const time=s=>String(s||"").slice(0,5);
export default function FeederRTCSettings({deviceId}){
  const [form,setForm]=useState(initial),[busy,setBusy]=useState(false),[loading,setLoading]=useState(true),[error,setError]=useState(""),[notice,setNotice]=useState("");
  const load=useCallback(async()=>{
    if(!deviceId)return;
    try{const {data,error}=await supabase.functions.invoke("feeder-rtc-config",{body:{action:"read",device_id:deviceId}});
      if(error)throw error;if(!data?.ok)throw Error(data?.error||"Could not load RTC configuration");
      setForm({...initial,...data.config,morning_time:time(data.config.morning_time),afternoon_time:time(data.config.afternoon_time),evening_time:time(data.config.evening_time)});setError("");
    }catch(e){setError(e.message||"Could not load RTC configuration");}finally{setLoading(false);}
  },[deviceId]);
  useEffect(()=>{setLoading(true);setNotice("");load();},[load]);
  async function save(e){e.preventDefault();if(busy||!deviceId)return;
    if(form.enabled&&!window.confirm("Enable RTC mode? Cloud test schedules will be disabled. Also DISABLE any database cloud feeding cron before using the RTC motor."))return;
    setBusy(true);setError("");setNotice("");
    try{const {data,error}=await supabase.functions.invoke("feeder-rtc-config",{body:{action:"save",device_id:deviceId,enabled:form.enabled,morning_time:form.morning_time,afternoon_time:form.afternoon_time,evening_time:form.evening_time}});
      if(error){let detail="";try{detail=(await error.context?.json())?.error||"";}catch{/* ignore */}throw Error(detail||error.message);}
      if(!data?.ok)throw Error(data?.error||"Save failed");
      setNotice(data.message||"Saved");await load();
    }catch(e){setError(e.message||"Save failed");}finally{setBusy(false);}
  }
  return <section className="feeder-schedule-card" aria-label="DS3231 offline RTC feeding settings">
    <div className="feeder-schedule-header"><div><h2>DS3231 Offline Feeding</h2><p>Assign morning, afternoon and evening compartments. The device stores its last synced schedule locally.</p></div><button className="feeder-schedule-refresh" disabled={loading||busy} onClick={load}>Refresh</button></div>
    <p className="feeder-schedule-info"><strong>Safety:</strong> Firmware ships in dry-run mode. Calibrate all three compartment positions and motor driver before enabling physical dispensing. This device-wide tester is NOT linked to a checked-in booking; do not use it for unattended feeding until booking access controls and compartment calibration are verified. Keep only one schedule engine: DS3231 offline OR Supabase cloud dispatcher.</p>
    <form className="feeder-schedule-form" onSubmit={save}>
      <label><input type="checkbox" checked={!!form.enabled} onChange={e=>setForm(f=>({...f,enabled:e.target.checked}))} disabled={busy}/> Enable RTC schedule (requires feeder firmware update)</label>
      {[["morning_time","Morning","1"],["afternoon_time","Afternoon","2"],["evening_time","Evening","3"]].map(([key,label,slot])=><label key={key}>{label} · Compartment {slot}
        <input style={{display:"block",marginTop:5,width:"100%"}} type="time" required value={form[key]||""} disabled={busy} onChange={e=>setForm(f=>({...f,[key]:e.target.value}))}/>
      </label>)}
      <small>All times use Philippine time (UTC+8). Saving updates the cloud version; changes reach the ESP32 only after it reconnects.</small>
      <button className="feeder-schedule-save" type="submit" disabled={!deviceId||loading||busy}>{busy?"Saving...":"Save RTC Configuration"}</button>
    </form>
    <p className="feeder-schedule-meta">Cloud configuration version: {form.version||0}. This number does not confirm that the physical device has synchronized.</p>
    {notice&&<p className="feeder-schedule-success" role="status">{notice}</p>}
    {error&&<p className="feeder-schedule-error" role="alert">{error}</p>}
  </section>;
}
