import { useCallback, useEffect, useState } from "react";
import { supabase } from "../services/supabaseClient";
import {fetchAllPages} from "../services/fetchAllPages";

export default function useBoardings() {
  const [boardings, setBoardings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const loadBoardings = useCallback(async () => {
    setLoading(true);
    setError("");

    try {
      const list = await fetchAllPages(()=>supabase
        .from("bookings")
        .select(`
          id,
          booking_code,
          pet_id,
          room_id,
          check_in_at,
          expected_check_out_at,
          actual_check_out_at,
          status,
          special_instructions,
          created_at,
          pet:pets!bookings_pet_id_fkey (
            id,
            name,
            species,
            breed,
            photo_url
          ),
          room:rooms!bookings_room_id_fkey (
            id,
            room_number,
            room_name
          )
        `)
        .order("check_in_at", { ascending: false }));
      const petIds = [...new Set(list.map((item) => item.pet_id).filter(Boolean))];
      const ownersByPet = new Map();

      if (petIds.length > 0) {
        const links=[];
        for (let offset=0;offset<petIds.length;offset+=200){
          const petBatch=petIds.slice(offset,offset+200);
          const batch=await fetchAllPages(()=>supabase.from("pet_owner_links").select(`pet_id,is_primary,relationship,owner:owners!pet_owner_links_owner_id_fkey(id,full_name,email,phone)`).in("pet_id",petBatch).order("is_primary",{ascending:false}));
          links.push(...batch);
        }
        for (const link of links ?? []) {
          if (!ownersByPet.has(link.pet_id) || link.is_primary) {
            ownersByPet.set(link.pet_id, {
              ...link.owner,
              relationship: link.relationship,
              is_primary: link.is_primary,
            });
          }
        }
      }

      setBoardings(list.map((item) => ({
        ...item,
        owner: ownersByPet.get(item.pet_id) ?? null,
      })));
    } catch (fetchError) {
      console.error("Failed to load boardings:", fetchError);
      setBoardings([]);
      setError(fetchError?.message || "Unable to load boarding records.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadBoardings();

    const channel = supabase
      .channel("carefur-boardings")
      .on("postgres_changes", { event: "*", schema: "public", table: "bookings" }, loadBoardings)
      .subscribe();

    return () => supabase.removeChannel(channel);
  }, [loadBoardings]);

  return { boardings, loading, error, refresh: loadBoardings };
}
