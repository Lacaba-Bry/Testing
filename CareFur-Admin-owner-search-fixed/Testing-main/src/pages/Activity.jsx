import { useCallback, useEffect, useState } from "react";
import { ArrowClockwise } from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import Button from "../components/common/Button";
import { supabase } from "../services/supabaseClient";
import "./Activity.css";
const PAGE_SIZE = 50;
export default function Activity() {
  const [items,setItems] = useState([]); const [loading,setLoading] = useState(true); const [error,setError] = useState(""); const [page,setPage] = useState(0); const [hasMore,setHasMore] = useState(false);
  const load = useCallback(async () => { setLoading(true); setError(""); const from=page*PAGE_SIZE; const {data,error:queryError}=await supabase.from("activity_logs").select("id,action,entity_type,description,created_at,actor:users!activity_logs_actor_user_id_fkey(full_name)").order("created_at",{ascending:false}).range(from,from+PAGE_SIZE); if(queryError){setError(queryError.message);setItems([]);}else{setItems(data||[]);setHasMore((data||[]).length>PAGE_SIZE);setItems((data||[]).slice(0,PAGE_SIZE));}setLoading(false); }, [page]);
  useEffect(()=>{load();},[load]);
  return <section className="cf-activity-page"><PageHeader title="Activity" description="Recent changes and care events." actions={<Button variant="secondary" onClick={load}><ArrowClockwise size={17}/> Refresh</Button>}/>{error&&<div className="page-alert page-alert--error">{error}</div>}{loading?<p>Loading activity…</p>:items.length===0?<p>No activity recorded on this page.</p>:<div className="cf-activity-list">{items.map((item)=><article key={item.id} className="cf-activity-entry"><span className="cf-activity-entry__dot"/><div><strong>{item.description||item.action||"Activity recorded"}</strong><p>{item.actor?.full_name||"System"} · {new Date(item.created_at).toLocaleString("en-PH")}</p></div><span>{item.entity_type||"event"}</span></article>)}</div>}<nav className="cf-pagination" aria-label="Activity pages"><span>Page {page+1}</span><button disabled={page===0||loading} onClick={()=>setPage(page-1)}>Previous</button><button disabled={!hasMore||loading} onClick={()=>setPage(page+1)}>Next</button></nav></section>;
}
