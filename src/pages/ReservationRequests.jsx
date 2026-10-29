import { useCallback, useEffect, useMemo, useState } from "react";
import { supabase } from "../services/supabaseClient";
import PageHeader from "../components/common/PageHeader";
import Button from "../components/common/Button";
import "./CareFurFeaturePages.css";
import "./ReservationRequests.css";

const FILTERS = [
  ["pending_payment", "Pending Payment"],
  ["confirmed", "Confirmed"],
  ["declined", "Declined"],
  ["cancelled", "Cancelled"],
  ["all", "All Requests"],
];
const statusLabel = (status) => ({ pending_payment: "Pending Payment", confirmed: "Confirmed", declined: "Declined", cancelled: "Cancelled" }[status] || String(status || "Unknown").replaceAll("_", " "));
const dateTime = (value) => {
  if (!value) return "Not specified";
  const date = new Date(value);
  if (Number.isNaN(date.valueOf())) return String(value);
  return new Intl.DateTimeFormat("en-PH", { timeZone: "Asia/Manila", dateStyle: "medium", timeStyle: "short" }).format(date);
};
const money = (value) => value === null || value === undefined || value === "" || !Number.isFinite(Number(value))
  ? "—"
  : new Intl.NumberFormat("en-PH", { style: "currency", currency: "PHP" }).format(Number(value));

export default function ReservationRequests() {
  const [items, setItems] = useState([]);
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");
  const [filter, setFilter] = useState("pending_payment");
  const [query, setQuery] = useState("");
  const [busy, setBusy] = useState(null);
  const [loading, setLoading] = useState(false);

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const { data, error: requestError } = await supabase
        .from("reservation_requests")
        .select(`id,request_code,owner_name,owner_email:email,owner_phone:phone,pet_name,species:pet_species,breed:pet_breed,room_id,requested_room_number,check_in:check_in_at,check_out:expected_check_out_at,notes:special_instructions,status,created_at,room_rate_per_night,nights,estimated_total`)
        .order("created_at", { ascending: false })
        .limit(300);
      if (requestError) throw requestError;
      setItems(data || []);
    } catch (err) {
      console.error("Reservation request load failed:", err);
      setError(err?.message || "Could not load reservation requests.");
      setItems([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { void load(); }, [load]);

  const counts = useMemo(() => {
    const value = { all: items.length };
    for (const item of items) value[item.status] = (value[item.status] || 0) + 1;
    return value;
  }, [items]);

  const filtered = useMemo(() => {
    const search = query.trim().toLowerCase();
    return items.filter((item) => {
      if (filter !== "all" && item.status !== filter) return false;
      if (!search) return true;
      return [item.owner_name, item.owner_email, item.owner_phone, item.pet_name, item.request_code, item.requested_room_number]
        .some((part) => String(part || "").toLowerCase().includes(search));
    });
  }, [items, filter, query]);

  const decide = async (item, nextStatus) => {
    if (busy) return;
    const confirmText = nextStatus === "confirmed"
      ? `Confirm reservation ${item.request_code || ""} for ${item.pet_name || "this pet"}?\n\nVerify room availability and payment first. This does not create a boarding record automatically.`
      : `Decline reservation ${item.request_code || ""}?`;
    if (!window.confirm(confirmText)) return;
    setBusy(item.id);
    setError("");
    setNotice("");
    try {
      const { error: updateError } = await supabase.rpc("carefur_review_reservation_request", {
        p_request_id: item.id,
        p_status: nextStatus,
      });
      if (updateError) throw updateError;
      setNotice(`Request ${item.request_code || ""} ${nextStatus} successfully.`);
      await load();
    } catch (err) {
      console.error("Reservation decision failed:", err);
      setError(err?.message || "Could not update the reservation request.");
    } finally {
      setBusy(null);
    }
  };

  return (
    <section className="cf-feature-page cf-rr-page">
      <PageHeader title="Reservation Requests" description="Review website reservations, confirm availability, and manage customer requests." actions={
        <Button variant="secondary" onClick={() => void load()} disabled={loading || busy !== null}>{loading ? "Refreshing..." : "Refresh"}</Button>
      } />
      {error && <div className="cf-rr-message cf-rr-error" role="alert">{error}</div>}
      {notice && !error && <div className="cf-rr-message cf-rr-success" role="status">{notice}</div>}
      <div className="cf-rr-toolbar">
        <div className="cf-rr-search-wrap">
          <label htmlFor="cf-rr-search">Search requests</label>
          <input id="cf-rr-search" type="search" value={query} onChange={(event) => setQuery(event.target.value)} placeholder="Owner, pet, email, or booking reference" />
        </div>
        <div className="cf-rr-summary">{filtered.length} matching / {items.length} total</div>
      </div>
      <div className="cf-feature-filters cf-rr-filters" role="group" aria-label="Filter reservation status">
        {FILTERS.map(([value, label]) => <button key={value} type="button" className={filter === value ? "active" : ""} aria-pressed={filter === value} onClick={() => setFilter(value)}>
          {label} <span className="cf-rr-filter-count">{counts[value] || 0}</span>
        </button>)}
      </div>
      <div className="cf-rr-results" aria-busy={loading}>
        {loading ? <div className="cf-rr-empty">Loading reservation requests...</div>
          : filtered.length === 0 ? <div className="cf-rr-empty">{error ? "Could not load requests. Check the error above." : "No requests match this filter."}</div>
          : filtered.map((r) => <article className="cf-rr-card" key={r.id}>
              <div className="cf-rr-card-top">
                <div className="cf-rr-identity"><div className="cf-rr-overline">RESERVATION REQUEST</div><h3>{r.pet_name || "Unnamed pet"}</h3><span className="cf-rr-reference">{r.request_code || String(r.id).slice(0, 8)}</span></div>
                <span className={`cf-rr-status cf-rr-status-${r.status || "unknown"}`}>{statusLabel(r.status)}</span>
              </div>
              <div className="cf-rr-details">
                <div className="cf-rr-detail"><span>Owner</span><strong>{r.owner_name || "Not provided"}</strong></div>
                <div className="cf-rr-detail"><span>Email</span><strong>{r.owner_email || "Not provided"}</strong></div>
                <div className="cf-rr-detail"><span>Phone</span><strong>{r.owner_phone || "Not provided"}</strong></div>
                <div className="cf-rr-detail"><span>Pet details</span><strong>{r.species || "Not specified"}{r.breed ? ` · ${r.breed}` : ""}</strong></div>
                <div className="cf-rr-detail"><span>Room</span><strong>{r.requested_room_number || r.room_id || "Not specified"}</strong></div>
                <div className="cf-rr-detail"><span>Duration</span><strong>{r.nights ?? "—"} nights</strong></div>
                <div className="cf-rr-detail"><span>Check-in</span><strong>{dateTime(r.check_in)}</strong></div>
                <div className="cf-rr-detail"><span>Check-out</span><strong>{dateTime(r.check_out)}</strong></div>
                <div className="cf-rr-detail"><span>Nightly rate</span><strong>{money(r.room_rate_per_night)}</strong></div>
                <div className="cf-rr-detail cf-rr-total"><span>Estimated total</span><strong>{money(r.estimated_total)}</strong></div>
              </div>
              {r.notes && <div className="cf-rr-notes"><span>Care instructions</span><p>{r.notes}</p></div>}
              <div className="cf-rr-card-footer"><small>Submitted {dateTime(r.created_at)}</small>
                {r.status === "pending_payment" && <div className="cf-feature-actions cf-rr-actions">
                  <Button disabled={busy !== null} onClick={() => void decide(r, "confirmed")}>{busy === r.id ? "Processing..." : "Confirm Request"}</Button>
                  <Button variant="secondary" disabled={busy !== null} onClick={() => void decide(r, "declined")}>Decline</Button>
                </div>}
              </div>
            </article>)}
      </div>
    </section>
  );
}
