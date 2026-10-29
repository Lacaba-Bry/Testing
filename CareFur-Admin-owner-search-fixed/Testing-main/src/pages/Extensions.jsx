import {useEffect,useState} from "react";
import {supabase} from "../services/supabaseClient";
import useBoardings from "../hooks/useBoardings";
import PageHeader from "../components/common/PageHeader";
import Button from "../components/common/Button";
import "./CareFurFeaturePages.css";
const fmt = value => value ? new Date(value).toLocaleString("en-PH",{dateStyle:"medium",timeStyle:"short",timeZone:"Asia/Manila"}) : "—";
export default function Extensions(){
 const {boardings,refresh:refreshBoardings}=useBoardings();
 const [items,setItems]=useState([]),[error,setError]=useState(""),[busy,setBusy]=useState(null),[filter,setFilter]=useState("pending");
 async function load(){const {data,error:e}=await supabase.from("boarding_extension_requests").select("id,booking_id,requested_checkout_at,reason,status,created_at").order("created_at",{ascending:false});if(e)setError(e.message);else {setItems(data||[]);setError("");}}
 useEffect(()=>{void load();},[]);
 async function decide(id,approve){if(!window.confirm(approve?"Approve extension? The checkout date will change.":"Decline extension request?"))return;setBusy(id);const {error:e}=await supabase.rpc("carefur_review_extension",{p_request_id:id,p_approve:approve});if(e)setError(e.message);else await Promise.all([load(),refreshBoardings()]);setBusy(null);}
 const list=items.filter(i=>filter==="all"||i.status===filter);
 return <section className="cf-feature-page"><PageHeader title="Boarding Extensions" description="Review additional boarding-day requests separately from the boarding list." actions={<Button variant="secondary" onClick={load}>Refresh</Button>}/>{error&&<p role="alert" className="cf-feature-error">{error}</p>}<div className="cf-feature-filters">{["pending","approved","declined","all"].map(x=><button key={x} className={filter===x?"active":""} onClick={()=>setFilter(x)}>{x}</button>)}</div><div className="cf-feature-card">{list.length===0?<p>No {filter} extension requests.</p>:list.map(r=>{const b=boardings.find(b=>b.id===r.booking_id);return <article key={r.id} className="cf-feature-item"><div><strong>{b?.pet?.name||"Booking"} · {b?.booking_code||r.booking_id}</strong><p>Owner: {b?.owner?.full_name||"—"} · Status: {r.status}</p><p>Current checkout: {fmt(b?.expected_check_out_at)}<br/>Requested checkout: {fmt(r.requested_checkout_at)}</p>{r.reason&&<p>Reason: {r.reason}</p>}<small>Requested: {fmt(r.created_at)}</small></div>{r.status==="pending"&&<div className="cf-feature-actions"><Button disabled={!!busy} onClick={()=>decide(r.id,true)}>Approve</Button><Button variant="secondary" disabled={!!busy} onClick={()=>decide(r.id,false)}>Decline</Button></div>}</article>})}</div></section>;
}
