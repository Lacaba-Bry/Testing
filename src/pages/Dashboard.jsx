import { BellSimple, ArrowRight } from "@phosphor-icons/react";
import { Link } from "react-router-dom";
import useAuth from "../hooks/useAuth";
import useDashboard from "../hooks/useDashboard";
import SummaryStrip from "../components/common/SummaryStrip";
import StatusDot from "../components/common/StatusDot";
import "./Dashboard.css";

const time = (value) => value ? new Intl.DateTimeFormat("en-PH", {hour:"numeric", minute:"2-digit"}).format(new Date(value)) : "—";
const roomLabel = (room) => room?.room_number ? `Room ${room.room_number}` : "Unassigned";
const dateLabel = new Intl.DateTimeFormat("en-PH",{weekday:"short",month:"short",day:"numeric"}).format(new Date());
export default function Dashboard() {
  const { profile } = useAuth();
  const data = useDashboard();
  const { arrivals,departures,occupiedRooms,rooms,feedingsDue,manualFeedings,activeAlerts,cameras,recentActivity,upcomingFeedings,loading,error,refresh } = data;
  const occupied = new Map(occupiedRooms.filter(b=>b.room_id).map(b=>[b.room_id,b]));
  const now = Date.now();
  const due = [...feedingsDue,...manualFeedings].filter(f=>new Date(f.scheduled_at).getTime() <= now + 5*60000);
  const offline = cameras.filter(c=>c.status!=="active" || !c.last_seen_at || now-new Date(c.last_seen_at).getTime()>5*60000)
    .filter(c=>!activeAlerts.some(a=>a.device?.id===c.id && (a.alert_type==="camera_offline" || a.alert_type==="device_offline")));
  const lateByPet = new Map();
  for (const feeding of due) {
    const petName = feeding.booking?.pet?.name || "pet";
    const key = `${petName}-${feeding.booking?.room?.id || feeding.booking?.room?.room_number || "room"}`;
    if (!lateByPet.has(key)) lateByPet.set(key, []);
    lateByPet.get(key).push(feeding);
  }
  const attention = [
    ...activeAlerts.map(a=>({id:`a-${a.id}`,level:a.severity==="critical"?0:1,title:a.title,detail:roomLabel(a.booking?.room),at:a.created_at,action:"Acknowledge",to:"/alerts"})),
    ...[...lateByPet.entries()].map(([key, feedings])=>{const oldest=feedings.reduce((a,b)=>new Date(a.scheduled_at)<new Date(b.scheduled_at)?a:b);const late=feedings.some(f=>new Date(f.scheduled_at)<new Date());return {id:`f-${key}`,level:late?0:1,title:`${oldest.booking?.pet?.name||"Pet"}: ${feedings.length} ${late?"late":"due"} feeding${feedings.length===1?"":"s"}`,detail:`${roomLabel(oldest.booking?.room)} · oldest ${time(oldest.scheduled_at)}`,at:oldest.scheduled_at,action:"Mark fed",to:"/feeding-schedules"};}),
    ...offline.map(c=>({id:`c-${c.id}`,level:1,title:`${c.device_name||c.device_code||"Camera"} is offline`,detail:"Check camera connection",at:c.last_seen_at,action:"Open camera",to:"/cameras"}))
  ].sort((a,b)=>a.level-b.level || new Date(a.at||0)-new Date(b.at||0));
  const upcoming = upcomingFeedings.filter(f=>{const diff=new Date(f.scheduled_at).getTime()-now;return diff>5*60000 && diff<=3*60*60000;}).slice(0,8);
  return <div className="cf-today">
    <header className="cf-today-head"><h1>Good {new Date().getHours()<12?"morning":new Date().getHours()<18?"afternoon":"evening"}, {profile?.full_name?.split(" ")[0]||"team"} <span>· {dateLabel}</span></h1><Link className="cf-bell" to="/alerts" aria-label={`${activeAlerts.length} active alerts`}><BellSimple size={22}/>{activeAlerts.length>0 && <b>{activeAlerts.length}</b>}</Link></header>
    {error && <div className="page-alert page-alert--error" role="alert">{error} <button onClick={refresh}>Retry</button></div>}
    {loading ? <div className="cf-loading" aria-label="Loading dashboard">Loading today's stays and care tasks…</div> : <>
      <SummaryStrip items={[{label:"Arriving today",value:arrivals.length},{label:"Leaving today",value:departures.length},{label:"Pets in hotel",value:occupiedRooms.length},{label:"Rooms available",value:rooms.filter(r=>r.status==="active"&&!occupied.has(r.id)).length}]} />
      <section className="cf-panel cf-attention"><div className="cf-section-title"><h2>Needs attention</h2><Link to="/alerts">All alerts <ArrowRight size={15}/></Link></div>{attention.length===0?<p className="cf-all-clear"><StatusDot status="success"/> All clear. Nothing needs attention right now.</p>:<div className="cf-action-list">{attention.slice(0,6).map(i=><div className={`cf-action-row cf-level-${i.level}`} key={i.id}><div><strong>{i.title}</strong><small>{i.detail} · {time(i.at)}</small></div><Link to={i.to}>{i.action}</Link></div>)}</div>}</section>
      <div className="cf-columns"><section className="cf-panel"><div className="cf-section-title"><h2>Arrivals & departures</h2><Link to="/boardings">All stays <ArrowRight size={15}/></Link></div><div className="cf-stays">{[...arrivals.map(b=>({...b,kind:"Arriving",at:b.check_in_at})),...departures.map(b=>({...b,kind:"Leaving",at:b.expected_check_out_at}))].sort((a,b)=>new Date(a.at)-new Date(b.at)).slice(0,8).map(b=><div className="cf-stay-row" key={`${b.kind}-${b.id}`}><time>{time(b.at)}</time><div><strong>{b.pet?.name||"Pet"}</strong><small>{roomLabel(b.room)} · {b.status?.replaceAll("_"," ")}</small></div><span>{b.kind}</span></div>)}{!arrivals.length&&!departures.length&&<p className="cf-quiet">No arrivals or departures scheduled today.</p>}</div></section>
      <section className="cf-panel"><div className="cf-section-title"><h2>Rooms</h2><Link to="/rooms">Manage rooms <ArrowRight size={15}/></Link></div><div className="cf-room-grid">{rooms.map(room=>{const stay=occupied.get(room.id);return <Link key={room.id} to="/rooms" className={`cf-room-chip cf-room-chip--${room.status}${stay ? " is-occupied" : ""}`} title={`${room.room_name||room.room_number} · ${stay?stay.pet?.name||"Occupied":"Available"}${stay?.expected_check_out_at ? ` · checkout ${new Date(stay.expected_check_out_at).toLocaleDateString("en-PH",{month:"short",day:"numeric"})}` : ""}`}><StatusDot status={room.status!=="active"?"warning":stay?"danger":"success"}/><strong>{room.room_number}</strong><small>{stay?.pet?.name || (room.status!=="active"?room.status:stay?"Occupied":"Free")}</small></Link>})}</div>{rooms.length===0&&<p className="cf-quiet">No rooms listed.</p>}</section></div>
      <section className="cf-panel"><div className="cf-section-title"><h2>Upcoming feedings <span>Next 3 hours</span></h2><Link to="/feeding-schedules">Schedule <ArrowRight size={15}/></Link></div><div className="cf-feed-grid">{upcoming.map(f=><div className="cf-feed-item" key={f.id}><time>{time(f.scheduled_at)}</time><strong>{f.booking?.pet?.name||"Pet"}</strong><span>{roomLabel(f.booking?.room)}</span><small>{f.feeding_method}</small></div>)}{upcoming.length===0&&<p className="cf-quiet">No more feedings in the next three hours.</p>}</div></section>
      <details className="cf-panel cf-activity"><summary>Recent activity <span>({recentActivity.length})</span></summary><Link to="/activity">View all activity <ArrowRight size={15}/></Link>{recentActivity.map(a=><div className="cf-activity-row" key={a.id}><span>{a.description}</span><time>{time(a.created_at)}</time></div>)}{recentActivity.length===0&&<p className="cf-quiet">No recent activity.</p>}</details>
    </>}
  </div>;
}
