-- On databases using a CHECK constraint instead of an enum, replace only the
-- booking status constraint while retaining the previously supported values.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT con.conname, pg_get_constraintdef(con.oid) AS definition
      FROM pg_constraint con
      JOIN pg_class rel ON rel.oid = con.conrelid
      JOIN pg_namespace ns ON ns.oid = rel.relnamespace
     WHERE ns.nspname='public' AND rel.relname='bookings'
       AND con.contype='c' AND pg_get_constraintdef(con.oid) ILIKE '%status%'
  LOOP
    -- Only replace the known status-only constraint. Do not drop other checks.
    IF r.conname IN ('bookings_status_check', 'bookings_status_check1') THEN
      EXECUTE format('ALTER TABLE public.bookings DROP CONSTRAINT %I', r.conname);
      EXECUTE format('ALTER TABLE public.bookings ADD CONSTRAINT %I CHECK (status::text IN (''pending'', ''checked_in'', ''checked_out'', ''cancelled'', ''no_show''))', r.conname);
    ELSE
      RAISE NOTICE 'Review check constraint %: %', r.conname, r.definition;
    END IF;
  END LOOP;
END $$;

-- Privileged worker. Do not grant this directly to browser users.
CREATE OR REPLACE FUNCTION public.carefur_mark_no_shows()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE affected integer;
BEGIN
  WITH overdue AS (
    UPDATE public.bookings
       SET status = 'no_show'
     WHERE status::text = 'pending'
       AND check_in_at IS NOT NULL
       AND check_in_at + interval '24 hours' <= clock_timestamp()
     RETURNING id
  ), expired AS (
    UPDATE public.booking_access ba
       SET expires_at = clock_timestamp()
      FROM overdue o
     WHERE ba.booking_id = o.id
     RETURNING ba.booking_id
  )
  SELECT count(*) INTO affected FROM overdue;
  RETURN affected;
END;
$$;
REVOKE ALL ON FUNCTION public.carefur_mark_no_shows() FROM PUBLIC;
REVOKE ALL ON FUNCTION public.carefur_mark_no_shows() FROM anon, authenticated;

-- Admin/staff-safe wrapper for refreshing the list manually.
CREATE OR REPLACE FUNCTION public.carefur_refresh_no_shows()
RETURNS integer
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF auth.uid() IS NULL OR NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required';
  END IF;
  RETURN public.carefur_mark_no_shows();
END;
$$;
REVOKE ALL ON FUNCTION public.carefur_refresh_no_shows() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.carefur_refresh_no_shows() TO authenticated;

-- To make the rule run even when Admin is closed, enable pg_cron in
-- Supabase Dashboard > Database > Extensions, then run ONCE:
-- SELECT cron.schedule('carefur-no-show-every-5-min', '*/5 * * * *',
--   $$SELECT public.carefur_mark_no_shows();$$);
-- Scheduled status changes run using the database server clock (timestamptz).
-- A separate staff action confirms actual arrival; time alone never checks in a pet.
