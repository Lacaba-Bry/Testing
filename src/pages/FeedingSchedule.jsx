import { ArrowClockwise, CalendarBlank, CheckCircle, Clock, ForkKnife, WarningCircle } from "@phosphor-icons/react";
import { useMemo, useState } from "react";
import Badge from "../components/common/Badge";
import Button from "../components/common/Button";
import EmptyState from "../components/common/EmptyState";
import PageHeader from "../components/common/PageHeader";
import useFeedingSchedules from "../hooks/useFeedingSchedules";
import "./FeedingSchedule.css";

const views = ["today", "overdue", "next7", "completed", "all"];

export default function FeedingSchedule() {
  const [view, setView] = useState("today");
  const [filterStatus, setFilterStatus] = useState("all");
  const [groupByPet, setGroupByPet] = useState(false);
  const [page, setPage] = useState(1);
  const [method, setMethod] = useState("all");
  const { schedules, loading, updatingId, error, toggleFeedingStatus, refetchSchedules } = useFeedingSchedules();

  const todayKey = toDayKey(new Date());
  const summary = useMemo(() => ({
    pending: schedules.filter((item) => item.status === "pending" && new Date(item.scheduled_at) >= new Date()).length,
    overdue: schedules.filter((item) => item.status === "pending" && new Date(item.scheduled_at) < new Date()).length,
    completedToday: schedules.filter((item) => item.status === "completed" && toDayKey(new Date(item.scheduled_at)) === todayKey).length,
    missed: schedules.filter((item) => item.status === "missed").length,
    today: schedules.filter((item) => toDayKey(new Date(item.scheduled_at)) === todayKey).length,
  }), [schedules, todayKey]);

  const filteredSchedules = useMemo(() => {
    const now = new Date();
    const endToday = new Date(now); endToday.setHours(23, 59, 59, 999);
    const end7 = new Date(now); end7.setDate(end7.getDate() + 7); end7.setHours(23,59,59,999);
    return schedules.filter((item) => {
      const date = new Date(item.scheduled_at);
      if (view === "today" && !(date >= new Date(now.getFullYear(), now.getMonth(), now.getDate()) && date <= endToday && ["pending", "missed"].includes(item.status))) return false;
      if (view === "overdue" && !(item.status === "pending" && date < now)) return false;
      if (view === "next7" && !(date >= new Date(now.getFullYear(), now.getMonth(), now.getDate()) && date <= end7 && item.status === "pending")) return false;
      if (view === "completed" && item.status !== "completed") return false;
      if (filterStatus !== "all" && item.status !== filterStatus) return false;
      if (method !== "all" && item.feeding_method !== method) return false;
      return true;
    }).sort((a,b) => new Date(a.scheduled_at) - new Date(b.scheduled_at));
  }, [schedules, view, filterStatus, method]);
  const pagedSchedules = filteredSchedules.slice((page - 1) * 50, page * 50);

  const grouped = useMemo(() => {
    const groups = new Map();
    for (const item of pagedSchedules) {
      const petName = item.booking?.pet?.name || "Unknown pet";
      const key = groupByPet ? `pet:${petName}` : toDayKey(new Date(item.scheduled_at));
      if (!groups.has(key)) groups.set(key, []);
      groups.get(key).push(item);
    }
    return [...groups.entries()];
  }, [pagedSchedules, groupByPet]);

  return (
    <section className="feeding-page">
      <PageHeader
        eyebrow="Care & Feeding"
        title="Feeding Schedule"
        description="A focused timeline of upcoming and completed feedings for boarded pets."
        actions={<Button variant="secondary" onClick={refetchSchedules}><ArrowClockwise size={18} /> Refresh</Button>}
      />

      <div className="feeding-summary-grid cf-feeding-chips">
        <button type="button" className={view === "today" ? "active" : ""} onClick={() => {setView("today");setPage(1)}}><CalendarBlank size={17}/> Due today <strong>{summary.today}</strong></button>
        <button type="button" className={view === "overdue" ? "active" : ""} onClick={() => {setView("overdue");setPage(1)}}><Clock size={17}/> Overdue <strong>{summary.overdue}</strong></button>
        <button type="button" className={view === "completed" ? "active" : ""} onClick={() => {setView("completed");setPage(1)}}><CheckCircle size={17}/> Done today <strong>{summary.completedToday}</strong></button>
        <button type="button" className={filterStatus === "missed" ? "active" : ""} onClick={() => {setFilterStatus(filterStatus === "missed" ? "all" : "missed");setPage(1)}}><WarningCircle size={17}/> Missed <strong>{summary.missed}</strong></button>
      </div>

      <div className="feeding-toolbar">
        <div className="segmented-control feeding-filters">
          {views.map((item) => <button key={item} type="button" className={view === item ? "active" : ""} onClick={() => {setView(item);setPage(1);}}>{({today:"Today",overdue:"Overdue",next7:"Next 7 days",completed:"Completed",all:"All"})[item]}</button>)}
        </div>
        <label className="cf-group-pet"><input type="checkbox" checked={groupByPet} onChange={(e) => {setGroupByPet(e.target.checked);setPage(1);}}/> Group by pet</label>
        <select className="feeding-method-filter" value={method} onChange={(event) => setMethod(event.target.value)} aria-label="Filter by feeding method">
          <option value="all">All methods</option>
          <option value="automatic">Automatic</option>
          <option value="manual">Manual</option>
        </select>
      </div>

      {error && <div className="page-alert page-alert--error">{error}</div>}

      {loading ? (
        <div className="page-loading">Loading feeding schedules…</div>
      ) : grouped.length === 0 ? (
        <EmptyState icon={ForkKnife} title="No feeding tasks" message="No schedules match the selected filters." />
      ) : (
        <div className="feeding-timeline">
          {grouped.map(([day, items]) => (
            <section className="feeding-day" key={day}>
              <header className="feeding-day__header">
                <div><span>{groupByPet ? day.slice(4) : day === todayKey ? "Today" : formatDayLabel(day)}</span><strong>{items.length} feeding{items.length === 1 ? "" : "s"}</strong></div>
              </header>
              <div className="feeding-day__list">
                {items.map((item) => {
                  const pet = item.booking?.pet;
                  const room = item.booking?.room;
                  return (
                    <article key={item.id} className={`feeding-row ${item.status === "pending" && new Date(item.scheduled_at) < new Date() ? "feeding-row--overdue" : ""}`}>
                      <div className="feeding-row__time"><strong>{formatTime(item.scheduled_at)}</strong><span>{item.feeding_method === "automatic" ? "Auto" : "Manual"}</span>{item.status === "pending" && new Date(item.scheduled_at) < new Date() && <small>Late by {Math.max(1,Math.floor((Date.now()-new Date(item.scheduled_at).getTime())/60000))} min</small>}</div>
                      <div className="feeding-row__main">
                        <div className="feeding-row__title"><h2>{pet?.name || "Unknown pet"}</h2><Badge tone={getStatusTone(item.status)}>{item.status}</Badge></div>
                        <p>{room?.room_number ? `Room ${room.room_number}` : "Room not assigned"}{item.portion_grams ? ` • ${item.portion_grams} g` : ""}{item.compartment_number ? ` • Compartment ${item.compartment_number}` : ""}</p>
                        {item.instructions && <small>{item.instructions}</small>}
                      </div>
                      {(item.status === "pending" || item.status === "completed") && (
                        <Button variant={item.status === "completed" ? "secondary" : "primary"} size="sm" disabled={updatingId === item.id} onClick={() => toggleFeedingStatus(item.id, item.status)}>
                          <CheckCircle size={16} />{updatingId === item.id ? "Saving…" : item.status === "completed" ? "Reopen" : "Complete"}
                        </Button>
                      )}
                    </article>
                  );
                })}
              </div>
            </section>
          ))}
        </div>
      )}
      {filteredSchedules.length > 50 && <nav className="cf-pagination" aria-label="Feeding pages"><span>{filteredSchedules.length} feedings · Page {page} of {Math.ceil(filteredSchedules.length/50)}</span><button disabled={page===1} onClick={() => setPage(page-1)}>Previous</button><button disabled={page>=Math.ceil(filteredSchedules.length/50)} onClick={() => setPage(page+1)}>Next</button></nav>}
    </section>
  );
}

function formatTime(value) { return new Intl.DateTimeFormat([], { hour: "numeric", minute: "2-digit" }).format(new Date(value)); }
function formatDayLabel(day) { return new Intl.DateTimeFormat([], { weekday: "long", month: "short", day: "numeric" }).format(new Date(`${day}T12:00:00`)); }
function toDayKey(date) { const y=date.getFullYear(); const m=String(date.getMonth()+1).padStart(2,"0"); const d=String(date.getDate()).padStart(2,"0"); return `${y}-${m}-${d}`; }
function getStatusTone(status) { if (status === "completed") return "success"; if (status === "pending") return "warning"; if (status === "missed" || status === "cancelled") return "danger"; return "neutral"; }
