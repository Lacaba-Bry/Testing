import { useCallback, useEffect, useMemo, useState } from "react";
import { supabase } from "../services/supabaseClient";
import useBoardings from "../hooks/useBoardings";
import PageHeader from "../components/common/PageHeader";
import Button from "../components/common/Button";
import "./CareFurFeaturePages.css";
import "./Extensions.css";

const MANILA = "Asia/Manila";
const formatDate = (value) => value
  ? new Date(value).toLocaleString("en-PH", { timeZone: MANILA, dateStyle: "medium", timeStyle: "short" })
  : "—";
const money = (value) => value == null ? "Not set" : new Intl.NumberFormat("en-PH", {
  style: "currency", currency: "PHP", maximumFractionDigits: 2,
}).format(Number(value));
const nightsBetween = (from, to) => {
  if (!from || !to) return null;
  return Math.max(0, Math.ceil((new Date(to).getTime() - new Date(from).getTime()) / 86400000));
};
const messageOf = (error) => error?.message || "Unexpected error. Please try again.";

export default function Extensions() {
  const { boardings, refresh: refreshBoardings } = useBoardings();
  const [requests, setRequests] = useState([]);
  const [accessByBooking, setAccessByBooking] = useState({});
  const [conflictsByRequest, setConflictsByRequest] = useState({});
  const [filter, setFilter] = useState("pending");
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState("");
  const [error, setError] = useState("");
  const [notice, setNotice] = useState("");
  const [preview, setPreview] = useState(null);
  const [amountDraft, setAmountDraft] = useState({});

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      const { data, error: requestError } = await supabase
        .from("boarding_extension_requests")
        .select("id,booking_id,requested_checkout_at,original_checkout_at,reason,status,created_at,reviewed_at,reviewed_by,additional_amount_due,payment_status,payment_reference")
        .order("created_at", { ascending: false })
        .limit(500);
      if (requestError) throw requestError;
      const rows = data || [];
      setRequests(rows);

      const bookingIds = [...new Set(rows.map((row) => row.booking_id).filter(Boolean))];
      if (bookingIds.length) {
        const { data: accessRows, error: accessError } = await supabase
          .from("booking_access")
          .select("booking_id,expires_at,revoked_at")
          .in("booking_id", bookingIds);
        if (accessError) throw accessError;
        const grouped = {};
        for (const row of accessRows || []) {
          if (!grouped[row.booking_id]) grouped[row.booking_id] = [];
          grouped[row.booking_id].push(row);
        }
        setAccessByBooking(grouped);
      } else {
        setAccessByBooking({});
      }

      const bookingMap = new Map(boardings.map((booking) => [booking.id, booking]));
      const conflictEntries = await Promise.all(rows.map(async (row) => {
        const booking = bookingMap.get(row.booking_id);
        if (!booking?.room_id || row.status !== "pending") return [row.id, []];
        const { data: overlaps, error: overlapError } = await supabase
          .from("bookings")
          .select("id,booking_code,check_in_at,expected_check_out_at,status")
          .eq("room_id", booking.room_id)
          .neq("id", booking.id)
          .in("status", ["pending", "checked_in"])
          .lt("check_in_at", row.requested_checkout_at)
          .gt("expected_check_out_at", booking.expected_check_out_at);
        if (overlapError) throw overlapError;
        return [row.id, overlaps || []];
      }));
      setConflictsByRequest(Object.fromEntries(conflictEntries));
    } catch (loadError) {
      setError(messageOf(loadError));
    } finally {
      setLoading(false);
    }
  }, [boardings]);

  useEffect(() => { void load(); }, [load]);

  useEffect(() => {
    const channel = supabase.channel("carefur-extension-operations")
      .on("postgres_changes", { event: "*", schema: "public", table: "boarding_extension_requests" }, () => { void load(); })
      .subscribe();
    const timer = window.setInterval(() => { void load(); }, 30000);
    return () => { window.clearInterval(timer); void supabase.removeChannel(channel); };
  }, [load]);

  const bookingMap = useMemo(() => new Map(boardings.map((booking) => [booking.id, booking])), [boardings]);
  const visible = requests.filter((row) => filter === "all" || row.status === filter);
  const pendingCount = requests.filter((row) => row.status === "pending").length;

  async function updatePayment(row, nextPaymentStatus = row.payment_status || "unverified") {
    const rawAmount = amountDraft[row.id] ?? row.additional_amount_due ?? "";
    const amount = rawAmount === "" ? null : Number(rawAmount);
    if (amount !== null && (!Number.isFinite(amount) || amount < 0)) {
      setError("Enter a valid non-negative amount.");
      return;
    }
    const paymentStatus = nextPaymentStatus;
    setBusy(row.id);
    setError("");
    setNotice("");
    try {
      const { error: rpcError } = await supabase.rpc("carefur_set_extension_payment", {
        p_request_id: row.id,
        p_amount_due: amount,
        p_payment_status: paymentStatus,
        p_payment_reference: null,
      });
      if (rpcError) throw rpcError;
      await load();
      setNotice("Extension amount and payment verification saved.");
    } catch (saveError) {
      setError(messageOf(saveError));
    } finally {
      setBusy("");
    }
  }

  async function decide(row, approve) {
    const booking = bookingMap.get(row.booking_id);
    const conflicts = conflictsByRequest[row.id] || [];
    if (approve && conflicts.length) {
      setError("This room has an overlapping booking. Resolve the room conflict before approval.");
      return;
    }
    if (approve && !["paid", "waived", "not_required"].includes(row.payment_status)) {
      setError("Verify extension payment as Paid, Waived, or Not required before approval.");
      return;
    }
    if (approve && row.additional_amount_due == null && row.payment_status !== "not_required") {
      setError("Set the extension amount before approval, or explicitly mark payment as Not required.");
      return;
    }
    setPreview({ row, approve, booking });
  }

  async function confirmDecision() {
    if (!preview) return;
    const { row, approve } = preview;
    setBusy(row.id);
    setError("");
    setNotice("");
    try {
      const { error: rpcError } = await supabase.rpc("carefur_review_extension", {
        p_request_id: row.id,
        p_approve: approve,
      });
      if (rpcError) throw rpcError;
      setPreview(null);
      await Promise.all([load(), refreshBoardings()]);
      setNotice(approve
        ? "Extension approved. The booking checkout and eligible active booking-access expiry were updated."
        : "Extension declined. The booking checkout was not changed.");
    } catch (decisionError) {
      setError(messageOf(decisionError));
    } finally {
      setBusy("");
    }
  }

  return (
    <section className="cf-feature-page cf-extensions-page">
      <PageHeader
        title="Boarding Extension Requests"
        description={`${pendingCount} request${pendingCount === 1 ? "" : "s"} awaiting review. Verify dates, room availability, and payment before approval.`}
        actions={<Button variant="secondary" onClick={() => { void Promise.all([load(), refreshBoardings()]); }} disabled={!!busy}>Refresh</Button>}
      />
      {error && <p role="alert" className="cf-feature-error">{error}</p>}
      {notice && <p role="status" className="cf-extension-notice">{notice}</p>}

      <div className="cf-extension-summary">
        <div><span>Pending requests</span><strong>{pendingCount}</strong></div>
        <div><span>Approved</span><strong>{requests.filter((row) => row.status === "approved").length}</strong></div>
        <div><span>Declined</span><strong>{requests.filter((row) => row.status === "declined").length}</strong></div>
      </div>

      <div className="cf-feature-filters" aria-label="Filter extension requests">
        {["pending", "approved", "declined", "all"].map((status) => (
          <button key={status} type="button" className={filter === status ? "active" : ""}
            onClick={() => setFilter(status)} aria-pressed={filter === status}>
            {status === "pending" ? `Pending (${pendingCount})` : status[0].toUpperCase() + status.slice(1)}
          </button>
        ))}
      </div>

      <div className="cf-feature-card">
        {loading && !requests.length ? <p>Loading extension requests…</p> :
          visible.length === 0 ? <p>No {filter} extension requests.</p> :
          visible.map((row) => {
            const booking = bookingMap.get(row.booking_id);
            const originalCheckout = row.original_checkout_at || booking?.expected_check_out_at;
            const extraNights = nightsBetween(originalCheckout, row.requested_checkout_at);
            const conflicts = conflictsByRequest[row.id] || [];
            const accessRows = accessByBooking[row.booking_id] || [];
            const activeAccess = accessRows.filter((access) => !access.revoked_at);
            const accessExpiry = activeAccess.reduce((latest, access) =>
              !latest || new Date(access.expires_at) > new Date(latest) ? access.expires_at : latest, null);
            const applied = row.status === "approved" && booking &&
              new Date(booking.expected_check_out_at) >= new Date(row.requested_checkout_at);
            const paymentStatus = row.payment_status || "unverified";
            return (
              <article key={row.id} className="cf-extension-card">
                <div className="cf-extension-card-head">
                  <div>
                    <strong>{booking?.pet?.name || "Pet"} · {booking?.booking_code || row.booking_id}</strong>
                    <p>{booking?.owner?.full_name || "Owner unavailable"} · {booking?.owner?.phone || booking?.owner?.email || "No contact"} · Room {booking?.room?.room_number || "unassigned"}</p>
                  </div>
                  <span className={`cf-extension-status cf-extension-status--${row.status}`}>{row.status}</span>
                </div>

                <div className="cf-extension-grid">
                  <div><span>Original checkout</span><strong>{formatDate(originalCheckout)}</strong></div>
                  <div><span>Requested checkout</span><strong>{formatDate(row.requested_checkout_at)}</strong></div>
                  <div><span>Additional stay</span><strong>{extraNights == null ? "—" : `${extraNights} night${extraNights === 1 ? "" : "s"}`}</strong></div>
                  <div><span>Additional amount due</span><strong>{money(row.additional_amount_due)}</strong></div>
                  <div><span>Payment status</span><strong>{paymentStatus.replaceAll("_", " ")}</strong></div>
                  <div><span>Room availability</span><strong className={conflicts.length ? "is-danger" : "is-good"}>{conflicts.length ? `${conflicts.length} conflict(s)` : row.status === "pending" ? "No overlap found" : "Not rechecked"}</strong></div>
                  <div><span>Active booking access-code expiry</span><strong>{formatDate(accessExpiry)}</strong></div>
                  <div><span>Extension applied</span><strong className={applied ? "is-good" : "is-muted"}>{applied ? "Yes" : row.status === "approved" ? "Needs review" : "Not yet"}</strong></div>
                </div>

                {conflicts.length > 0 && (
                  <div className="cf-extension-warning" role="alert">
                    Room conflict: {conflicts.map((item) => item.booking_code || item.id).join(", ")}. Approval is blocked until resolved.
                  </div>
                )}
                <div className="cf-extension-reason">
                  <strong>Customer reason</strong>
                  <p>{row.reason || "No reason provided."}</p>
                  <small>Requested {formatDate(row.created_at)}{row.reviewed_at ? ` · Reviewed ${formatDate(row.reviewed_at)}` : ""}</small>
                </div>

                {row.status === "pending" && (
                  <>
                    <div className="cf-extension-payment">
                      <div>
                        <label htmlFor={`amount-${row.id}`}>Additional amount (PHP)</label>
                        <input id={`amount-${row.id}`} type="number" min="0" step="0.01"
                          value={amountDraft[row.id] ?? row.additional_amount_due ?? ""}
                          onChange={(event) => setAmountDraft((old) => ({ ...old, [row.id]: event.target.value }))} />
                      </div>
                      <div>
                        <label htmlFor={`payment-${row.id}`}>Payment decision</label>
                        <select id={`payment-${row.id}`} value={paymentStatus}
                          onChange={(event) => setRequests((old) => old.map((item) => item.id === row.id ? { ...item, payment_status: event.target.value } : item))}>
                          <option value="unverified">Not yet verified</option>
                          <option value="waived">Waived by admin</option>
                          <option value="not_required">Not required</option>
                        </select>
                      </div>
                      <div className="cf-extension-payment-buttons">
                        <Button size="sm" onClick={() => void updatePayment(row, "paid")} disabled={!!busy}>
                          {busy === row.id ? "Saving…" : "Mark as Paid"}
                        </Button>
                        <Button size="sm" variant="secondary" onClick={() => void updatePayment(row, paymentStatus)} disabled={!!busy}>
                          Save amount / decision
                        </Button>
                      </div>
                    </div>
                    <div className="cf-extension-actions">
                      <Button onClick={() => void decide(row, true)} disabled={!!busy || conflicts.length > 0 || !["paid", "waived", "not_required"].includes(paymentStatus)}>
                        Review & approve
                      </Button>
                      <Button variant="secondary" onClick={() => void decide(row, false)} disabled={!!busy}>Decline request</Button>
                    </div>
                  </>
                )}
              </article>
            );
          })}
      </div>

      {preview && (
        <div className="cf-extension-modal-backdrop" role="presentation">
          <section className="cf-extension-modal" role="dialog" aria-modal="true" aria-labelledby="extension-preview-title">
            <h2 id="extension-preview-title">{preview.approve ? "Confirm extension approval" : "Confirm extension decline"}</h2>
            <p>Booking {preview.booking?.booking_code || preview.row.booking_id}</p>
            {preview.approve ? (
              <>
                <div className="cf-extension-preview-grid">
                  <span>Current checkout</span><strong>{formatDate(preview.booking?.expected_check_out_at)}</strong>
                  <span>Requested checkout</span><strong>{formatDate(preview.row.requested_checkout_at)}</strong>
                  <span>Additional stay</span><strong>{nightsBetween(preview.booking?.expected_check_out_at, preview.row.requested_checkout_at)} nights</strong>
                  <span>Additional amount</span><strong>{money(preview.row.additional_amount_due)}</strong>
                  <span>Payment verification</span><strong>{(preview.row.payment_status || "unverified").replaceAll("_", " ")}</strong>
                  <span>Room</span><strong>{preview.booking?.room?.room_number || "Unassigned"}</strong>
                </div>
                <p className="cf-extension-warning-text">Approval updates the booking checkout and eligible active booking access-code expiration. Camera streaming must independently enforce the updated booking end time.</p>
              </>
            ) : <p>The booking dates and access expiration will remain unchanged.</p>}
            <div className="cf-extension-actions">
              <Button onClick={() => void confirmDecision()} disabled={!!busy}>{busy ? "Processing…" : preview.approve ? "Confirm approval" : "Confirm decline"}</Button>
              <Button variant="secondary" onClick={() => setPreview(null)} disabled={!!busy}>Go back</Button>
            </div>
          </section>
        </div>
      )}
    </section>
  );
}
