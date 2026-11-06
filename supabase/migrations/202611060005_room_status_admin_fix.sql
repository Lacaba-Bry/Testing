-- Room status RPC: supports the existing Rooms.jsx modal, including upcoming-booking warning.
-- Runs as the migration owner so the guard_room_status_update trigger allows the change.
-- Staff role checks remain enforced; no direct client updates are permitted.
create or replace function public.set_room_status(
  p_room_id uuid,p_status text,p_reason text default null,
  p_until date default null,p_force boolean default false
) returns jsonb language plpgsql security definer set search_path = public, pg_temp as $$
declare
  actor_id uuid:=auth.uid();
  actor_role text;
  room_row public.rooms%rowtype;
  future_bookings jsonb;
begin
  select role into actor_role from public.users where id=actor_id;
  if actor_id is null or actor_role is distinct from 'admin' then
    raise exception 'Only admins may change room status.' using errcode='42501';
  end if;
  if p_status not in ('active','maintenance','inactive') then
    raise exception 'Invalid room status' using errcode='22023';
  end if;
  if p_status <> 'active' and nullif(trim(coalesce(p_reason,'')),'') is null then
    raise exception 'Provide a reason for maintenance/inactive room' using errcode='22023';
  end if;
  select * into room_row from public.rooms where id=p_room_id for update;
  if not found then raise exception 'Room not found' using errcode='P0002'; end if;
  if p_status <> 'active' and exists(
    select 1 from public.bookings where room_id=p_room_id and status='checked_in'
  ) then
    raise exception 'Cannot close a room with a checked-in pet' using errcode='23514';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'booking_code',b.booking_code,'check_in_at',b.check_in_at,
    'expected_check_out_at',b.expected_check_out_at
  ) order by b.check_in_at),'[]'::jsonb)
  into future_bookings from public.bookings b
  where b.room_id=p_room_id and b.status='pending'
    and b.expected_check_out_at>now();
  if p_status <> 'active' and jsonb_array_length(future_bookings)>0 and not p_force then
    return jsonb_build_object('requires_confirmation',true,'bookings',future_bookings);
  end if;
  update public.rooms set status=p_status,
    status_reason=case when p_status='active' then null else trim(p_reason) end,
    status_changed_by=actor_id,status_changed_at=now(),
    maintenance_until=case when p_status='maintenance' then p_until else null end
  where id=p_room_id;
  return jsonb_build_object('success',true,'bookings',future_bookings);
end;
$$;
revoke all on function public.set_room_status(uuid,text,text,date,boolean) from public,anon;
grant execute on function public.set_room_status(uuid,text,text,date,boolean) to authenticated;
