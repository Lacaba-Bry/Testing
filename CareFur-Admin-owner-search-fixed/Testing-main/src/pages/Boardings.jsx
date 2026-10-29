import { ArrowClockwise, CalendarBlank, DownloadSimple, MagnifyingGlass, Plus } from "@phosphor-icons/react";
import { useEffect, useMemo, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import useAuth from "../hooks/useAuth";
import { supabase } from "../services/supabaseClient";
import Badge from "../components/common/Badge";
import Button from "../components/common/Button";
import EmptyState from "../components/common/EmptyState";
import PageHeader from "../components/common/PageHeader";
import useBoardings from "../hooks/useBoardings";
import "./Boardings.css";

const filters = ["all", "pending", "checked_in", "checked_out", "cancelled"];
const EXPORT_COLUMNS = [
  "Booking code",
  "Pet",
  "Species",
  "Breed",
  "Owner",
  "Owner phone",
  "Owner email",
  "Room",
  "Check-in",
  "Expected checkout",
  "Actual checkout",
  "Status",
  "Special instructions",
  "Created at",
];

export default function Boardings() {
  const { boardings, loading, error, refresh } = useBoardings();
  const { isAdmin, profile } = useAuth();
  const [params] = useSearchParams();
  const [search, setSearch] = useState(() => params.get("q") || "");
  const [status, setStatus] = useState("all");
  const [page, setPage] = useState(1);
  const [exportOpen, setExportOpen] = useState(false);
  const [exportScope, setExportScope] = useState("filtered");
  const [exportFormat, setExportFormat] = useState("xlsx");
  const [fromDate, setFromDate] = useState("");
  const [toDate, setToDate] = useState("");
  const [exportColumns, setExportColumns] = useState(EXPORT_COLUMNS);
  const [exporting, setExporting] = useState(false);
  const [exportError, setExportError] = useState("");

  const filtered = useMemo(() => {
    const needle = search.trim().toLowerCase();
    return boardings.filter((item) => {
      if (status !== "all" && item.status !== status) return false;
      if (!needle) return true;
      return [
        item.booking_code,
        item.pet?.name,
        item.owner?.full_name,
        item.owner?.email,
        item.room?.room_number,
        item.room?.room_name,
      ].some((value) => String(value || "").toLowerCase().includes(needle));
    });
  }, [boardings, search, status]);

  const pageCount = Math.max(1, Math.ceil(filtered.length / 25));
  const currentPage = Math.min(page, pageCount);
  const paged = filtered.slice((currentPage - 1) * 25, currentPage * 25);

  async function runExport() {
    setExporting(true);
    setExportError("");
    try {
      let rows = exportScope === "filtered" ? filtered : boardings;
      rows = rows.filter(
        (item) =>
          (!fromDate || new Date(item.check_in_at) >= new Date(`${fromDate}T00:00:00`)) &&
          (!toDate || new Date(item.check_in_at) < new Date(`${toDate}T23:59:59.999`)),
      );

      const values = rows.map((item) => ({
        "Booking code": item.booking_code,
        Pet: item.pet?.name,
        Species: item.pet?.species,
        Breed: item.pet?.breed,
        Owner: item.owner?.full_name,
        "Owner phone": item.owner?.phone,
        "Owner email": item.owner?.email,
        Room: item.room?.room_number ? `Room ${item.room.room_number}` : "",
        "Check-in": item.check_in_at,
        "Expected checkout": item.expected_check_out_at,
        "Actual checkout": item.actual_check_out_at,
        Status: item.status,
        "Special instructions": item.special_instructions,
        "Created at": item.created_at,
      }));

      const safe = (value) => {
        if (value === null || value === undefined) return "";
        if (typeof value === "string" && /^[=+@-]/.test(value)) return `'${value}`;
        return value;
      };

      const date = new Date().toISOString().slice(0, 10);
      if (exportFormat === "csv") {
        const csvCell = (value) => `"${String(safe(value)).replaceAll('"', '""')}"`;
        const csv = [
          exportColumns.map(csvCell).join(","),
          ...values.map((row) => exportColumns.map((column) => csvCell(row[column])).join(",")),
        ].join("\r\n");
        downloadBlob(new Blob(["\ufeff", csv], { type: "text/csv;charset=utf-8;" }), `carefur-boardings-${date}.csv`);
      } else {
        const ExcelJS = await import("exceljs");
        const workbook = new ExcelJS.default.Workbook();
        const sheet = workbook.addWorksheet("Boardings");
        sheet.addRow(exportColumns);
        for (const row of values) sheet.addRow(exportColumns.map((column) => safe(row[column])));
        sheet.getRow(1).font = { bold: true, color: { argb: "FFFFFFFF" } };
        sheet.getRow(1).fill = { type: "pattern", pattern: "solid", fgColor: { argb: "FF104B47" } };
        sheet.views = [{ state: "frozen", ySplit: 1 }];
        sheet.autoFilter = {
          from: { row: 1, column: 1 },
          to: { row: Math.max(1, values.length + 1), column: exportColumns.length },
        };
        sheet.columns = exportColumns.map((key) => ({
          key,
          width: Math.min(38, Math.max(key.length + 2, ...values.slice(0, 100).map((row) => String(row[key] ?? "").length + 2))),
        }));
        for (const key of ["Check-in", "Expected checkout", "Actual checkout", "Created at"]) {
          const index = exportColumns.indexOf(key) + 1;
          if (index > 0) {
            for (let row = 2; row <= values.length + 1; row += 1) {
              const raw = values[row - 2][key];
              if (raw) {
                const cell = sheet.getCell(row, index);
                cell.value = new Date(raw);
                cell.numFmt = "dd mmm yyyy hh:mm AM/PM";
              }
            }
          }
        }
        const info = workbook.addWorksheet("Export info");
        info.addRows([
          ["Generated", new Date().toLocaleString("en-PH")],
          ["Exported by", profile?.full_name || profile?.email || "Admin"],
          ["Scope", exportScope === "filtered" ? "Current filters" : "All records"],
          ["Status filter", status],
          ["Search", search || "None"],
          ["Check-in from", fromDate || "Any"],
          ["Check-in to", toDate || "Any"],
          ["Record count", values.length],
        ]);
        info.getColumn(1).width = 22;
        info.getColumn(2).width = 42;
        info.getColumn(1).font = { bold: true };
        const buffer = await workbook.xlsx.writeBuffer();
        downloadBlob(
          new Blob([buffer], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }),
          `carefur-boardings-${date}.xlsx`,
        );
      }

      await supabase.from("activity_logs").insert({
        actor_user_id: profile?.id,
        entity_type: "boarding_export",
        action: "exported",
        description: `${profile?.full_name || "Admin"} exported ${values.length} boarding records`,
      });
      setExportOpen(false);
    } catch (exportFail) {
      setExportError(exportFail.message || "Export failed. Please try again.");
    } finally {
      setExporting(false);
    }
  }

  return (
    <section className="boardings-page">
      <PageHeader
        title="Boarding List"
        description="View current stays, upcoming check-ins, owner details, room assignments, and checkout dates."
        actions={
          <>
            {isAdmin && (
              <Button variant="secondary" onClick={() => { setExportError(""); setExportOpen(true); }}>
                <DownloadSimple size={18} /> Export
              </Button>
            )}
            <Button variant="secondary" onClick={refresh}>
              <ArrowClockwise size={18} /> Refresh
            </Button>
            <Link className="boardings-new-link" to="/boarding/new">
              <Plus size={18} /> New boarding
            </Link>
          </>
        }
      />

      <div className="boardings-toolbar">
        <label className="boardings-search">
          <MagnifyingGlass size={19} />
          <input
            value={search}
            onChange={(event) => {
              setSearch(event.target.value);
              setPage(1);
            }}
            placeholder="Search pet, owner, room, booking code..."
          />
        </label>
        <div className="segmented-control boardings-filters">
          {filters.map((item) => (
            <button
              key={item}
              type="button"
              className={status === item ? "active" : ""}
              onClick={() => {
                setStatus(item);
                setPage(1);
              }}
            >
              {formatStatus(item)}
            </button>
          ))}
        </div>
      </div>

      {error && <div className="page-alert page-alert--error">{error}</div>}
      {loading ? (
        <div className="page-loading">Loading boardings…</div>
      ) : filtered.length === 0 ? (
        <EmptyState icon={CalendarBlank} title="No boarding records" message="No stays match the selected filters." />
      ) : (
        <>
          <div className="boardings-table-wrap">
            <table className="boardings-table">
              <thead>
                <tr>
                  <th>Booking code</th>
                  <th>Pet</th>
                  <th>Owner</th>
                  <th>Room</th>
                  <th>Check-in</th>
                  <th>Check-out</th>
                  <th>Status</th>
                </tr>
              </thead>
              <tbody>
                {paged.map((item) => (
                  <tr key={item.id}>
                    <td>{item.booking_code || "—"}</td>
                    <td>
                      <strong>{item.pet?.name || "Pet"}</strong>
                      <small>{[item.pet?.species, item.pet?.breed].filter(Boolean).join(" · ")}</small>
                    </td>
                    <td>
                      <strong>{item.owner?.full_name || "—"}</strong>
                      <small>{item.owner?.phone || item.owner?.email || ""}</small>
                    </td>
                    <td>{item.room?.room_number ? `R-${item.room.room_number}` : "—"}</td>
                    <td>{formatDateTime(item.check_in_at)}</td>
                    <td>{formatDateTime(item.expected_check_out_at)}</td>
                    <td>
                      <Badge tone={toneForStatus(item.status)}>{formatStatus(item.status)}</Badge>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="boardings-mobile">
            {paged.map((item) => (
              <article className="cf-mobile-stay" key={item.id}>
                <strong>{item.pet?.name || "Pet"}</strong>
                <span>
                  {item.booking_code} · {formatStatus(item.status)}
                </span>
                <p>
                  {item.owner?.full_name || "No owner"} · {item.room?.room_number ? `R-${item.room.room_number}` : "No room"}
                </p>
                <p>
                  {formatDateTime(item.check_in_at)} – {formatDateTime(item.expected_check_out_at)}
                </p>
              </article>
            ))}
          </div>

          <Pagination page={currentPage} pageCount={pageCount} total={filtered.length} setPage={setPage} />
        </>
      )}

      {exportOpen && (
        <div className="cf-modal-backdrop" role="presentation">
          <section className="cf-modal cf-export-modal" role="dialog" aria-modal="true" aria-labelledby="export-title">
            <h2 id="export-title">Export boarding records</h2>

            <label>
              Records
              <select value={exportScope} onChange={(event) => setExportScope(event.target.value)}>
                <option value="filtered">Current filters ({filtered.length} records)</option>
                <option value="all">All records ({boardings.length} records)</option>
              </select>
            </label>

            <div className="cf-export-dates">
              <label>
                Check-in from
                <input type="date" value={fromDate} onChange={(event) => setFromDate(event.target.value)} />
              </label>
              <label>
                Check-in to
                <input type="date" value={toDate} onChange={(event) => setToDate(event.target.value)} />
              </label>
            </div>

            <fieldset>
              <legend>Columns</legend>
              {EXPORT_COLUMNS.map((column) => (
                <label key={column} className="cf-export-column">
                  <input
                    type="checkbox"
                    checked={exportColumns.includes(column)}
                    onChange={(event) =>
                      setExportColumns((old) =>
                        event.target.checked ? [...old, column] : old.filter((current) => current !== column),
                      )
                    }
                  />
                  {column}
                </label>
              ))}
            </fieldset>

            <label>
              Format
              <select value={exportFormat} onChange={(event) => setExportFormat(event.target.value)}>
                <option value="xlsx">Excel workbook (.xlsx)</option>
                <option value="csv">CSV (.csv)</option>
              </select>
            </label>

            {exportError && <div className="page-alert page-alert--error">{exportError}</div>}

            <div className="cf-modal-actions">
              <Button variant="secondary" disabled={exporting} onClick={() => setExportOpen(false)}>
                Cancel
              </Button>
              <Button disabled={exporting || !exportColumns.length} onClick={runExport}>
                {exporting ? "Preparing export..." : "Export file"}
              </Button>
            </div>
          </section>
        </div>
      )}
    </section>
  );
}

function Pagination({ page, pageCount, total, setPage }) {
  return (
    <nav className="cf-pagination" aria-label="Table pages">
      <span>
        {total} records · Page {page} of {pageCount}
      </span>
      <button disabled={page === 1} onClick={() => setPage(page - 1)}>
        Previous
      </button>
      <button disabled={page === pageCount} onClick={() => setPage(page + 1)}>
        Next
      </button>
    </nav>
  );
}

function formatStatus(value) {
  return value === "all" ? "All" : String(value || "").replaceAll("_", " ").replace(/\b\w/g, (char) => char.toUpperCase());
}

function toneForStatus(status) {
  if (status === "checked_in") return "success";
  if (status === "pending") return "warning";
  if (status === "cancelled") return "danger";
  return "neutral";
}

function formatDateTime(value) {
  if (!value) return "—";
  return new Intl.DateTimeFormat([], {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  }).format(new Date(value));
}

function downloadBlob(blob, filename) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}
