import { ArrowClockwise, EnvelopeSimple, MagnifyingGlass, PawPrint, Phone, ChatCircleText } from "@phosphor-icons/react";
import { useEffect, useMemo, useState } from "react";
import { Link, useSearchParams } from "react-router-dom";
import Badge from "../components/common/Badge";
import Button from "../components/common/Button";
import EmptyState from "../components/common/EmptyState";
import PageHeader from "../components/common/PageHeader";
import usePets from "../hooks/usePets";
import { supabase } from "../services/supabaseClient";
import "./Pets.css";

const tabs = ["staying", "upcoming", "all"];
export default function Pets() {
  const [params] = useSearchParams();
  const [search, setSearch] = useState(() => params.get("q") || "");
  const [page, setPage] = useState(1);
  const [tab, setTab] = useState("all");
  const [species, setSpecies] = useState("all");
  const [stays, setStays] = useState([]);
  const [selectedPet, setSelectedPet] = useState(null);
  const [feedings, setFeedings] = useState([]);
  const { pets, loading, error, refetchPets } = usePets(search);

  useEffect(() => {
    let live = true;
    (async () => {
      const { data } = await supabase.from("bookings").select("id,pet_id,room_id,status,check_in_at,expected_check_out_at,booking_code,room:rooms!bookings_room_id_fkey(room_number),pet:pets!bookings_pet_id_fkey(id,name)").in("status", ["checked_in", "confirmed", "pending"]).order("check_in_at").limit(2000);
      if (live) setStays(data || []);
    })();
    return () => { live = false; };
  }, []);

  const petBooking = useMemo(() => {
    const map = new Map();
    for (const booking of stays) if (booking.pet_id && (!map.has(booking.pet_id) || booking.status === "checked_in")) map.set(booking.pet_id, booking);
    return map;
  }, [stays]);
  const stayingPets = useMemo(() => pets.filter((pet) => petBooking.get(pet.id)?.status === "checked_in"), [pets, petBooking]);
  const upcomingPets = useMemo(() => pets.filter((pet) => ["pending", "confirmed"].includes(petBooking.get(pet.id)?.status)), [pets, petBooking]);
  const source = tab === "staying" ? stayingPets : tab === "upcoming" ? upcomingPets : pets;
  const filtered = source.filter((pet) => species === "all" || pet.species === species);
  const pageCount = Math.max(1, Math.ceil(filtered.length / 25));
  const currentPage = Math.min(page, pageCount);
  const visiblePets = filtered.slice((currentPage - 1) * 25, currentPage * 25);
  const speciesOptions = [...new Set(pets.map((p) => p.species).filter(Boolean))];

  async function openProfile(pet) {
    setSelectedPet(pet); setFeedings([]);
    const booking = petBooking.get(pet.id);
    if (booking) {
      const { data } = await supabase.from("feeding_schedules").select("id,scheduled_at,status,feeding_method,portion_grams,instructions").eq("booking_id", booking.id).order("scheduled_at", { ascending: false }).limit(5);
      setFeedings(data || []);
    }
  }

  return <section className="pets-page">
    <PageHeader title="Pets" description="Pet profiles and current stays." actions={<Button variant="secondary" onClick={refetchPets}><ArrowClockwise size={17} /> Refresh</Button>} />
    <div className="pets-toolbar"><MagnifyingGlass size={18} /><input value={search} onChange={(e) => { setSearch(e.target.value); setPage(1); }} placeholder="Search pet name…" aria-label="Search pets" /><select className="cf-species-select" value={species} onChange={(e) => { setSpecies(e.target.value); setPage(1); }} aria-label="Filter by species"><option value="all">All species</option>{speciesOptions.map((s) => <option key={s}>{s}</option>)}</select></div>
    <div className="segmented-control cf-pet-tabs" aria-label="Pet list view">{tabs.map((item) => <button key={item} className={tab === item ? "active" : ""} onClick={() => { setTab(item); setPage(1); }}>{item === "staying" ? "Staying now" : item === "upcoming" ? "Upcoming" : "All pets"} ({item === "staying" ? stayingPets.length : item === "upcoming" ? upcomingPets.length : pets.length})</button>)}</div>
    {error && <div className="page-alert page-alert--error">{error}</div>}
    {loading ? <div className="page-loading">Loading pets…</div> : visiblePets.length === 0 ? <EmptyState icon={PawPrint} title="No pets in this view" message={search ? "Try another search." : tab === "staying" ? "No pets are checked in right now." : "Pet profiles will appear here once they are added."} /> : <div className="cf-pets-table-wrap"><table className="cf-pets-table"><thead><tr><th>Pet</th><th>Room</th><th>Check-in</th><th>Owner</th><th>Phone number</th><th>Actions</th></tr></thead><tbody>{visiblePets.map((pet) => { const booking = petBooking.get(pet.id);  return <tr key={pet.id} tabIndex={0} onClick={() => openProfile(pet)} onKeyDown={(e) => e.key === "Enter" && openProfile(pet)}><td><div className="cf-pet-cell"><span className="cf-pet-icon">{pet.photo_url ? <img src={pet.photo_url} alt="" /> : <PawPrint size={20} />}</span><span><strong>{pet.name || "Unnamed pet"}</strong><small>{[pet.species, pet.breed].filter(Boolean).join(" · ")}</small>{pet.weight_kg && <small>{pet.weight_kg} kg</small>}</span></div></td><td>{booking?.room?.room_number ? <Badge tone="neutral">R-{booking.room.room_number}</Badge> : "—"}</td><td>{booking?.check_in_at ? formatDate(booking.check_in_at) : "—"}</td><td>{pet.owner?.full_name || "Not assigned"}</td><td>{pet.owner?.phone ? <a href={`tel:${pet.owner.phone}`} onClick={(e) => e.stopPropagation()}><Phone size={16} /> {pet.owner.phone}</a> : "—"}</td><td><Link className="cf-message-action" to={booking ? `/messages?booking=${booking.id}` : "/messages"} onClick={e => e.stopPropagation()}><ChatCircleText size={18}/> Message</Link></td></tr>; })}</tbody></table></div>}
    {filtered.length > 25 && <nav className="cf-pagination" aria-label="Pet pages"><span>{filtered.length} pets · Page {currentPage} of {pageCount}</span><button disabled={currentPage === 1} onClick={() => setPage(currentPage - 1)}>Previous</button><button disabled={currentPage === pageCount} onClick={() => setPage(currentPage + 1)}>Next</button></nav>}
    {selectedPet && <div className="cf-drawer-backdrop cf-pet-modal-backdrop" onMouseDown={(e) => e.target === e.currentTarget && setSelectedPet(null)}><section className="cf-pet-modal" role="dialog" aria-modal="true" aria-label={`${selectedPet.name} profile`}><div className="cf-drawer-head"><h2>{selectedPet.name}</h2><Button variant="secondary" onClick={() => setSelectedPet(null)}>Close</Button></div><p>{[selectedPet.species, selectedPet.breed].filter(Boolean).join(" · ")}</p>{selectedPet.weight_kg && <p>Weight: {selectedPet.weight_kg} kg</p>}{selectedPet.owners?.length > 0 && <section><h3>Owners</h3>{selectedPet.owners.map((owner) => <div key={owner.id} className="cf-pet-owner-detail"><strong>{owner.full_name} {owner.is_primary ? "(Primary)" : ""}</strong>{owner.phone && <p><Phone size={15} /> <a href={`tel:${owner.phone}`}>{owner.phone}</a></p>}{owner.email && <p><EnvelopeSimple size={15} /> <a href={`mailto:${owner.email}`}>{owner.email}</a></p>}</div>)}</section>}{selectedPet.feeding_notes && <section><h3>Feeding notes</h3><p>{selectedPet.feeding_notes}</p></section>}{selectedPet.allergies && <section><h3>Allergies</h3><p>{selectedPet.allergies}</p></section>}{selectedPet.medical_notes && <section><h3>Medical notes</h3><p>{selectedPet.medical_notes}</p></section>}<section><h3>Recent feeding history</h3>{feedings.length ? feedings.map((f) => <p key={f.id}>{formatDate(f.scheduled_at)} · {new Date(f.scheduled_at).toLocaleTimeString([], {hour:"numeric",minute:"2-digit"})} · {f.status}</p>) : <p>No recent feeding records.</p>}</section><Link className="cf-message-action" to={petBooking.get(selectedPet.id) ? `/messages?booking=${petBooking.get(selectedPet.id).id}` : "/messages"}>Message owner</Link></section></div>}
  </section>;
}
function formatDate(value) { return value ? new Date(value).toLocaleDateString("en-PH", { month: "short", day: "numeric" }) : "—"; }
