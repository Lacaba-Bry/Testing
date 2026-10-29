-- ADDITIVE workflow for public website reservations; apply AFTER website schema migrations.
-- This is deliberately separate from bookings: confirming a request DOES NOT check in a pet.
create or replace function public.carefur_review_reservation_request(p_request_id uuid,p_status text)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if not public.carefur_boarding_staff() then
    raise exception 'Staff access required';
  end if;
  if p_status not in ('confirmed','declined') then
    raise exception 'Invalid decision';
  end if;
  update public.reservation_requests
  set status=p_status,updated_at=now()
  where id=p_request_id and status='pending_payment';
  if not found then raise exception 'This reservation request has already been processed or was not found'; end if;
end;
$$;
revoke all on function public.carefur_review_reservation_request(uuid,text) from public;
grant execute on function public.carefur_review_reservation_request(uuid,text) to authenticated;
