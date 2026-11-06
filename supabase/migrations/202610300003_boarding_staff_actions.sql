-- CareFur: additive staff-only boarding lifecycle actions.
-- Requires 202610300001_boarding_extension_reviews.sql (carefur_boarding_staff).
-- Keep original bookings and customer records; do not drop tables.
CREATE OR REPLACE FUNCTION public.carefur_staff_boarding_action(
  p_booking_id uuid,
  p_action text
) RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_booking public.bookings%ROWTYPE;
  v_now timestamptz := clock_timestamp();
  v_duration interval;
  v_new_checkout timestamptz;
BEGIN
  IF auth.uid() IS NULL OR NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required';
  END IF;
  IF p_action NOT IN ('check_in', 'cancel') OR p_action IS NULL THEN
    RAISE EXCEPTION 'Unsupported boarding action';
  END IF;

  SELECT * INTO v_booking FROM public.bookings
  WHERE id = p_booking_id FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Booking not found'; END IF;
  IF v_booking.status::text <> 'pending' THEN
    RAISE EXCEPTION 'Only pending bookings may be checked in or cancelled';
  END IF;

  IF p_action = 'check_in' THEN
    v_duration := v_booking.expected_check_out_at - v_booking.check_in_at;
    IF v_duration IS NULL OR v_duration <= interval '0 seconds' THEN
      RAISE EXCEPTION 'Booking has an invalid stay duration';
    END IF;
    v_new_checkout := v_now + v_duration;

    -- Prevent overlapping pending/active bookings for the same assigned room.
    -- Serializes decisions for this room to avoid concurrent check-ins racing.
    PERFORM 1 FROM public.rooms WHERE id = v_booking.room_id FOR UPDATE;
    IF EXISTS (
      SELECT 1 FROM public.bookings b
      WHERE b.id <> v_booking.id AND b.room_id = v_booking.room_id
        AND b.status::text IN ('pending', 'checked_in')
        AND b.check_in_at < v_new_checkout
        AND b.expected_check_out_at > v_now
    ) THEN RAISE EXCEPTION 'Room is occupied or reserved for the adjusted stay'; END IF;

    UPDATE public.bookings SET
      status = 'checked_in',
      check_in_at = v_now,
      expected_check_out_at = v_new_checkout
    WHERE id = p_booking_id;

    -- Existing owner code expiry must not undercut the adjusted stay.
    -- This is NOT camera-gateway authorization.
    UPDATE public.booking_access
    SET expires_at = GREATEST(COALESCE(expires_at, v_new_checkout), v_new_checkout)
    WHERE booking_id = p_booking_id;

  ELSE
    UPDATE public.bookings SET status = 'cancelled'
    WHERE id = p_booking_id;

    -- Expire the existing hashed owner access codes; keep audit history.
    UPDATE public.booking_access SET expires_at = v_now
    WHERE booking_id = p_booking_id;
  END IF;
END;
$$;
REVOKE ALL ON FUNCTION public.carefur_staff_boarding_action(uuid,text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.carefur_staff_boarding_action(uuid,text) TO authenticated;
