import {
  ArrowClockwise,
  ChatCircleText,
  EnvelopeSimple,
  MagnifyingGlass,
  PawPrint,
  Phone,
  X,
} from "@phosphor-icons/react";
import { useEffect, useMemo, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import Badge from "../components/common/Badge";
import Button from "../components/common/Button";
import EmptyState from "../components/common/EmptyState";
import PageHeader from "../components/common/PageHeader";
import usePets from "../hooks/usePets";
import { supabase } from "../services/supabaseClient";
import "./Pets.css";

const tabs = [
  { key: "staying", label: "Staying Now" },
  { key: "upcoming", label: "Upcoming" },
  { key: "all", label: "All Pets" },
];

export default function Pets() {
  const [params] = useSearchParams();
  const navigate = useNavigate();
  const [search, setSearch] = useState(() => params.get("q") || "");
  const [page, setPage] = useState(1);
  const [tab, setTab] = useState("staying");
  const [species, setSpecies] = useState("all");
  const [stays, setStays] = useState([]);
  const [selectedPet, setSelectedPet] = useState(null);
  const [feedings, setFeedings] = useState([]);
  const { pets, loading, error, refetchPets } = usePets(search);

  useEffect(() => {
    let live = true;
    (async () => {
      const { data } = await supabase
        .from("bookings")
        .select(`
          id,
          pet_id,
          room_id,
          status,
          check_in_at,
          expected_check_out_at,
          room:rooms!bookings_room_id_fkey(id,room_number,room_name)
        `)
        .in("status", ["checked_in", "confirmed", "pending"])
        .order("check_in_at", { ascending: false })
        .limit(2000);
      if (live) setStays(data || []);
    })();
    return () => {
      live = false;
    };
  }, []);

  const petBooking = useMemo(() => {
    const map = new Map();
    for (const booking of stays) {
      if (!booking.pet_id) continue;
      if (!map.has(booking.pet_id) || booking.status === "checked_in") map.set(booking.pet_id, booking);
    }
    return map;
  }, [stays]);

  const stayingPets = useMemo(
    () => pets.filter((pet) => petBooking.get(pet.id)?.status === "checked_in"),
    [pets, petBooking],
  );
  const upcomingPets = useMemo(
    () => pets.filter((pet) => ["pending", "confirmed"].includes(petBooking.get(pet.id)?.status)),
    [pets, petBooking],
  );

  const source = tab === "staying" ? stayingPets : tab === "upcoming" ? upcomingPets : pets;
  const filtered = source.filter((pet) => species === "all" || pet.species === species);
  const pageCount = Math.max(1, Math.ceil(filtered.length / 25));
  const currentPage = Math.min(page, pageCount);
  const visiblePets = filtered.slice((currentPage - 1) * 25, currentPage * 25);
  const speciesOptions = [...new Set(pets.map((pet) => pet.species).filter(Boolean))];

  async function openProfile(pet) {
    setSelectedPet(pet);
    setFeedings([]);
    const booking = petBooking.get(pet.id);
    if (!booking) return;
    const { data } = await supabase
      .from("feeding_schedules")
      .select("id,scheduled_at,status,feeding_method,portion_grams,instructions")
      .eq("booking_id", booking.id)
      .order("scheduled_at", { ascending: false })
      .limit(6);
    setFeedings(data || []);
  }

  return (
    <section className="pets-page">
      <PageHeader
        title="Pets"
        description="Pet profiles and current stays."
        actions={
          <Button variant="secondary" onClick={refetchPets}>
            <ArrowClockwise size={17} /> Refresh
          </Button>
        }
      />

      <div className="pets-toolbar-shell">
        <label className="pets-search-box">
          <MagnifyingGlass size={18} />
          <input
            value={search}
            onChange={(event) => {
              setSearch(event.target.value);
              setPage(1);
            }}
            placeholder="Search pet name..."
            aria-label="Search pets"
          />
        </label>

        <label className="pets-filter-box">
          <span className="sr-only">Filter by species</span>
          <select
            value={species}
            onChange={(event) => {
              setSpecies(event.target.value);
              setPage(1);
            }}
            aria-label="Filter by species"
          >
            <option value="all">All species</option>
            {speciesOptions.map((item) => (
              <option key={item} value={item}>
                {item}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div className="segmented-control cf-pet-tabs" aria-label="Pet list view">
        {tabs.map((item) => {
          const count =
            item.key === "staying" ? stayingPets.length : item.key === "upcoming" ? upcomingPets.length : pets.length;
          return (
            <button
              key={item.key}
              className={tab === item.key ? "active" : ""}
              onClick={() => {
                setTab(item.key);
                setPage(1);
              }}
            >
              {item.label} ({count})
            </button>
          );
        })}
      </div>

      {error && <div className="page-alert page-alert--error">{error}</div>}

      {loading ? (
        <div className="page-loading">Loading pets…</div>
      ) : visiblePets.length === 0 ? (
        <EmptyState
          icon={PawPrint}
          title="No pets in this view"
          message={search ? "Try another search." : "Pet profiles will appear here once they are added."}
        />
      ) : (
        <div className="cf-pets-table-wrap">
          <table className="cf-pets-table">
            <thead>
              <tr>
                <th>Pet</th>
                <th>Room</th>
                <th>Check-in</th>
                <th>Owner</th>
                <th>Phone Number</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {visiblePets.map((pet) => {
                const booking = petBooking.get(pet.id);
                const owner = pet.owner;
                return (
                  <tr
                    key={pet.id}
                    tabIndex={0}
                    onClick={() => openProfile(pet)}
                    onKeyDown={(event) => event.key === "Enter" && openProfile(pet)}
                  >
                    <td>
                      <div className="cf-pet-cell">
                        <span className="cf-pet-icon">
                          {pet.photo_url ? <img src={pet.photo_url} alt="" /> : <PawPrint size={20} />}
                        </span>
                        <span>
                          <strong>{pet.name || "Unnamed pet"}</strong>
                          <small>{[pet.species, pet.breed].filter(Boolean).join(" · ") || "No species details"}</small>
                          {pet.weight_kg && <small>{pet.weight_kg} kg</small>}
                        </span>
                      </div>
                    </td>
                    <td>
                      {booking?.room?.room_number ? (
                        <Badge tone="neutral">R-{booking.room.room_number}</Badge>
                      ) : (
                        "—"
                      )}
                    </td>
                    <td>{booking?.check_in_at ? formatDate(booking.check_in_at) : "—"}</td>
                    <td>{owner?.full_name || "Not assigned"}</td>
                    <td>
                      {owner?.phone ? (
                        <a href={`tel:${owner.phone}`} onClick={(event) => event.stopPropagation()}>
                          <Phone size={16} /> {owner.phone}
                        </a>
                      ) : (
                        "—"
                      )}
                    </td>
                    <td>
                      <button
                        type="button"
                        className="cf-table-action"
                        onClick={(event) => {
                          event.stopPropagation();
                          if (booking?.id) {
                            navigate(`/messages?booking=${booking.id}`);
                          } else {
                            openProfile(pet);
                          }
                        }}
                        title={booking?.id ? "Open messages" : "View pet details"}
                      >
                        <ChatCircleText size={18} /> Message
                      </button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}

      {filtered.length > 25 && (
        <nav className="cf-pagination" aria-label="Pet pages">
          <span>
            {filtered.length} pets · Page {currentPage} of {pageCount}
          </span>
          <button disabled={currentPage === 1} onClick={() => setPage(currentPage - 1)}>
            Previous
          </button>
          <button disabled={currentPage === pageCount} onClick={() => setPage(currentPage + 1)}>
            Next
          </button>
        </nav>
      )}

      {selectedPet && (
        <div className="cf-modal-backdrop pets-modal-backdrop" onMouseDown={(event) => event.target === event.currentTarget && setSelectedPet(null)}>
          <section className="cf-pet-modal" role="dialog" aria-modal="true" aria-label={`${selectedPet.name} profile`}>
            <div className="cf-pet-modal__header">
              <div className="cf-pet-modal__identity">
                <span className="cf-pet-modal__avatar">
                  {selectedPet.photo_url ? <img src={selectedPet.photo_url} alt="" /> : <PawPrint size={22} />}
                </span>
                <div>
                  <h2>{selectedPet.name}</h2>
                  <p>{[selectedPet.species, selectedPet.breed].filter(Boolean).join(" · ") || "Pet profile"}</p>
                </div>
              </div>
              <button type="button" className="cf-pet-modal__close" onClick={() => setSelectedPet(null)} aria-label="Close pet profile">
                <X size={18} />
              </button>
            </div>

            <div className="cf-pet-modal__meta">
              <div>
                <span>Room</span>
                <strong>{petBooking.get(selectedPet.id)?.room?.room_number ? `R-${petBooking.get(selectedPet.id).room.room_number}` : "Not assigned"}</strong>
              </div>
              <div>
                <span>Check-in</span>
                <strong>{petBooking.get(selectedPet.id)?.check_in_at ? formatDate(petBooking.get(selectedPet.id).check_in_at) : "—"}</strong>
              </div>
              <div>
                <span>Weight</span>
                <strong>{selectedPet.weight_kg ? `${selectedPet.weight_kg} kg` : "—"}</strong>
              </div>
            </div>

            <div className="cf-pet-modal__grid">
              <section className="cf-pet-detail-card">
                <h3>Owners</h3>
                {selectedPet.owners?.length ? (
                  selectedPet.owners.map((owner) => (
                    <article key={owner.id} className="cf-pet-owner-detail">
                      <strong>
                        {owner.full_name} {owner.is_primary ? <span>(Primary)</span> : null}
                      </strong>
                      {owner.phone && (
                        <p>
                          <Phone size={15} /> <a href={`tel:${owner.phone}`}>{owner.phone}</a>
                        </p>
                      )}
                      {owner.email && (
                        <p>
                          <EnvelopeSimple size={15} /> <a href={`mailto:${owner.email}`}>{owner.email}</a>
                        </p>
                      )}
                    </article>
                  ))
                ) : (
                  <p className="cf-empty-copy">No owner details available.</p>
                )}
              </section>

              <section className="cf-pet-detail-card">
                <h3>Recent feeding history</h3>
                {feedings.length ? (
                  <div className="cf-feeding-history">
                    {feedings.map((feeding) => (
                      <p key={feeding.id}>
                        <strong>{formatDate(feeding.scheduled_at)}</strong>
                        <span>
                          {new Date(feeding.scheduled_at).toLocaleTimeString([], {
                            hour: "numeric",
                            minute: "2-digit",
                          })}
                          {` · ${feeding.status}`}
                        </span>
                      </p>
                    ))}
                  </div>
                ) : (
                  <p className="cf-empty-copy">No recent feeding records.</p>
                )}
              </section>

              {(selectedPet.feeding_notes || selectedPet.allergies || selectedPet.medical_notes) && (
                <section className="cf-pet-detail-card cf-pet-detail-card--wide">
                  <h3>Care notes</h3>
                  <div className="cf-note-list">
                    {selectedPet.feeding_notes && (
                      <div>
                        <span>Feeding notes</span>
                        <p>{selectedPet.feeding_notes}</p>
                      </div>
                    )}
                    {selectedPet.allergies && (
                      <div>
                        <span>Allergies</span>
                        <p>{selectedPet.allergies}</p>
                      </div>
                    )}
                    {selectedPet.medical_notes && (
                      <div>
                        <span>Medical notes</span>
                        <p>{selectedPet.medical_notes}</p>
                      </div>
                    )}
                  </div>
                </section>
              )}
            </div>
          </section>
        </div>
      )}
    </section>
  );
}

function formatDate(value) {
  return value ? new Date(value).toLocaleDateString("en-PH", { month: "short", day: "numeric" }) : "—";
}
