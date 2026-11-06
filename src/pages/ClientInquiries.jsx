import { ArrowClockwise, ChatCircleDots, PaperPlaneTilt, MagnifyingGlass } from "@phosphor-icons/react";
import { useCallback, useEffect, useMemo, useState } from "react";
import useAuth from "../hooks/useAuth";
import { supabase } from "../services/supabaseClient";
import PageHeader from "../components/common/PageHeader";
import Button from "../components/common/Button";
import "./ClientInquiries.css";

export default function ClientInquiries() {
  const { profile, authUser } = useAuth();
  const [items, setItems] = useState([]);
  const [selectedId, setSelectedId] = useState(null);
  const [messages, setMessages] = useState([]);
  const [query, setQuery] = useState("");
  const [draft, setDraft] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);

  const refresh = useCallback(async () => {
    const { data, error: fetchError } = await supabase.from("public_inquiries")
      .select("id,client_name,client_email,subject,status,created_at,updated_at")
      .order("updated_at", { ascending: false }).limit(250);
    if (fetchError) { setError(fetchError.message); setLoading(false); return; }
    setItems(data || []);
    setSelectedId((current) => current && data?.some((item) => item.id === current) ? current : data?.[0]?.id || null);
    setError(""); setLoading(false);
  }, []);

  const refreshMessages = useCallback(async () => {
    if (!selectedId) { setMessages([]); return; }
    const { data, error: fetchError } = await supabase.from("public_inquiry_messages")
      .select("id,inquiry_id,sender_user_id,staff_user_id,sender_type,sender_name,message,created_at")
      .eq("inquiry_id", selectedId).order("created_at", { ascending: true }).limit(500);
    if (fetchError) { setError(fetchError.message); return; }
    setMessages(data || []);
  }, [selectedId]);

  useEffect(() => { void refresh(); }, [refresh]);
  useEffect(() => { void refreshMessages(); }, [refreshMessages]);
  useEffect(() => {
    const channel = supabase.channel("carefur-public-inquiries-admin")
      .on("postgres_changes", { event: "*", schema: "public", table: "public_inquiries" }, () => void refresh())
      .on("postgres_changes", { event: "INSERT", schema: "public", table: "public_inquiry_messages" }, () => { void refreshMessages(); void refresh(); })
      .subscribe();
    return () => { void supabase.removeChannel(channel); };
  }, [refresh, refreshMessages]);

  const current = items.find((item) => item.id === selectedId);
  const filtered = useMemo(() => items.filter((item) => `${item.client_name} ${item.client_email} ${item.subject}`.toLowerCase().includes(query.toLowerCase())), [items, query]);

  async function send(event) {
    event.preventDefault();
    if (!selectedId || !draft.trim() || sending || current?.status === "closed") return;
    setSending(true); setError("");
    const { error: sendError } = await supabase.from("public_inquiry_messages").insert({
      inquiry_id: selectedId,
      sender_type: "staff",
      sender_user_id: authUser?.id || profile?.id,
      staff_user_id: authUser?.id || profile?.id,
      sender_name: profile?.full_name || "CareFur Staff",
      message: draft.trim(),
    });
    if (sendError) setError(sendError.message);
    else { setDraft(""); await refreshMessages(); }
    setSending(false);
  }

  async function changeStatus(status) {
    if (!selectedId) return;
    const { error: updateError } = await supabase.from("public_inquiries").update({ status }).eq("id", selectedId);
    if (updateError) setError(updateError.message); else await refresh();
  }

  return <section className="inquiries-page">
    <PageHeader title="Client Inquiries" description="Messages submitted through the public CareFur website, separate from boarding chats." actions={<Button variant="secondary" onClick={refresh}><ArrowClockwise size={18}/> Refresh</Button>} />
    {error && <div role="alert" className="page-alert page-alert--error">{error}</div>}
    <div className="inquiry-layout">
      <aside className="inquiry-list-panel">
        <label className="inquiry-search"><MagnifyingGlass size={18}/><input aria-label="Search inquiries" placeholder="Search clients or subject..." value={query} onChange={(event)=>setQuery(event.target.value)}/></label>
        <div className="inquiry-list" aria-label="Client inquiries">
          {loading ? <p className="inquiry-hint">Loading inquiries…</p> : filtered.length === 0 ? <p className="inquiry-hint">No inquiries found.</p> : filtered.map((item) =>
            <button key={item.id} type="button" className={`inquiry-list-item ${item.id === selectedId ? "selected" : ""}`} onClick={()=>setSelectedId(item.id)}>
              <span className="inquiry-list-top"><strong>{item.client_name}</strong><small>{item.status}</small></span>
              <span className="inquiry-subject">{item.subject}</span><small>{item.client_email}</small>
            </button>)}
        </div>
      </aside>
      <div className="inquiry-thread-panel">
        {!current ? <div className="inquiry-empty"><ChatCircleDots size={36}/><p>Select a client inquiry.</p></div> : <>
          <div className="inquiry-thread-header"><div><h2>{current.subject}</h2><p>{current.client_name} · <a href={`mailto:${current.client_email}`}>{current.client_email}</a></p></div><button type="button" className="inquiry-state-button" onClick={()=>changeStatus(current.status === "open" ? "closed" : "open")}>{current.status === "open" ? "Close inquiry" : "Reopen inquiry"}</button></div>
          <div className="inquiry-messages">{messages.length ? messages.map((message)=><article key={message.id} className={`inquiry-bubble ${message.sender_type === "staff" ? "staff" : "client"}`}><strong>{message.sender_name || (message.sender_type === "staff" ? "CareFur Staff" : current.client_name)}</strong><p>{message.message}</p><time>{new Date(message.created_at).toLocaleString("en-PH")}</time></article>) : <p className="inquiry-hint">No messages on this inquiry yet.</p>}</div>
          <form className="inquiry-compose" onSubmit={send}><textarea aria-label="Reply to client" value={draft} onChange={(event)=>setDraft(event.target.value)} placeholder={current.status === "closed" ? "Reopen inquiry to reply" : "Write a reply to the client..."} disabled={current.status === "closed"}/><button type="submit" disabled={sending || !draft.trim() || current.status === "closed"}><PaperPlaneTilt size={19}/> Send reply</button></form>
        </>}
      </div>
    </div>
  </section>;
}
