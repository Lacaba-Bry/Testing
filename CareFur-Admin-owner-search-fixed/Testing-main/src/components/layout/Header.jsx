import { List, MagnifyingGlass } from "@phosphor-icons/react";
import { useLocation, useNavigate } from "react-router-dom";
import { useEffect, useMemo, useRef, useState } from "react";
import { supabase } from "../../services/supabaseClient";
import useAuth from "../../hooks/useAuth";
import "./Header.css";

const titles = {
  "/dashboard": "Dashboard",
  "/boarding/new": "New Boarding",
  "/boardings": "Boarding List",
  "/extensions": "Boarding Extensions",
  "/boarding-reviews": "Boarding Reviews",
  "/reservation-requests": "Reservation Requests",
  "/pets": "Pets",
  "/rooms": "Rooms",
  "/feeding-schedules": "Feeding Schedule",
  "/cameras": "Cameras",
  "/alerts": "Alerts",
  "/messages": "Messages",
  "/inquiries": "Client Inquiries",
  "/connection-manual": "Connection Manual",
  "/staff": "Staff",
  "/motor-test": "Feeder ESP32",
  "/feeder-wifi-manager": "Feeder Wi-Fi",
  "/camera-test": "Camera Test",
  "/hardware-setup": "Camera Wi-Fi Connection",
};

export default function Header({ onMenuClick }) {
  const { pathname } = useLocation();
  const navigate = useNavigate();
  const { profile } = useAuth();
  const [search, setSearch] = useState("");
  const [results, setResults] = useState([]);
  const [open, setOpen] = useState(false);
  const inputRef = useRef(null);
  const panelRef = useRef(null);

  useEffect(() => {
    const handler = (event) => {
      if (event.key === "/" && !["INPUT", "TEXTAREA"].includes(document.activeElement?.tagName)) {
        event.preventDefault();
        inputRef.current?.focus();
      }
      if (event.key === "Escape") setOpen(false);
    };
    const closeOnOutside = (event) => {
      if (!panelRef.current?.contains(event.target)) setOpen(false);
    };
    window.addEventListener("keydown", handler);
    window.addEventListener("mousedown", closeOnOutside);
    return () => {
      window.removeEventListener("keydown", handler);
      window.removeEventListener("mousedown", closeOnOutside);
    };
  }, []);

  useEffect(() => {
    if (search.trim().length < 2) {
      setResults([]);
      return;
    }

    let cancelled = false;
    const timer = setTimeout(async () => {
      const term = search.trim().replace(/[%,()]/g, "");
      const queries = await Promise.allSettled([
        supabase.from("pets").select("id,name").ilike("name", `%${term}%`).limit(5),
        supabase.from("owners").select("id,full_name").ilike("full_name", `%${term}%`).limit(5),
        supabase.from("bookings").select("id,booking_code").ilike("booking_code", `%${term}%`).limit(5),
      ]);
      if (cancelled) return;
      const mapped = queries.flatMap((result, index) => {
        if (result.status !== "fulfilled" || result.value.error) return [];
        return (result.value.data || []).map((item) => ({
          id: item.id,
          title: item.name || item.full_name || item.booking_code,
          kind: ["Pet", "Owner", "Booking"][index],
          to: index === 0 ? "/pets" : "/boardings",
        }));
      });
      setResults(mapped);
      setOpen(true);
    }, 250);

    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [search]);

  const pageTitle = titles[pathname] || "CareFur";
  const greetingName = useMemo(() => {
    const full = profile?.full_name?.trim();
    if (!full) return "Admin";
    return full.split(/\s+/)[0];
  }, [profile?.full_name]);

  return (
    <header className="dashboard-header">
      <div className="dashboard-header__left">
        <button type="button" className="menu-button" aria-label="Open navigation" onClick={onMenuClick}>
          <List size={22} />
        </button>
        <div className="dashboard-header__title-block">
          <strong>{pageTitle}</strong>
          <span>Welcome back, {greetingName}</span>
        </div>
      </div>

      <div className="dashboard-header__right" ref={panelRef}>
        <div className="cf-global-search">
          <MagnifyingGlass size={18} />
          <input
            ref={inputRef}
            type="search"
            placeholder="Search pets, owners, bookings"
            aria-label="Global search"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            onFocus={() => setOpen(true)}
          />
          {open && search.length >= 2 && (
            <div className="cf-search-results">
              {results.length === 0 ? (
                <p>No results found.</p>
              ) : (
                results.map((result) => (
                  <button
                    type="button"
                    key={`${result.kind}-${result.id}`}
                    onClick={() => {
                      navigate(`${result.to}?q=${encodeURIComponent(result.title)}`);
                      setOpen(false);
                      setSearch("");
                    }}
                  >
                    <span>{result.title}</span>
                    <small>{result.kind}</small>
                  </button>
                ))
              )}
            </div>
          )}
        </div>

        <div className="header-user-chip" title={profile?.role || "staff"}>
          <span className="header-user-chip__name">{profile?.full_name || "CareFur Staff"}</span>
          <small>{profile?.role === "admin" ? "Administrator" : "Staff member"}</small>
        </div>
      </div>
    </header>
  );
}
