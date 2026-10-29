alter table public.rooms
  add column if not exists status_reason text,
  add column if not exists status_changed_at timestamptz,
  add column if not exists status_changed_by uuid,
  add column if not exists maintenance_until date;

create or replace function public.set_room_status(
  p_room_id uuid,
  p_status text,
  p_reason text default null,
  p_until date default null,
  p_force boolean default false
) returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_actor uuid := auth.uid();
  v_role text;
  v_room public.rooms%rowtype;
  v_actor_name text;
  v_upcoming jsonb;
  v_count integer;
  v_description text;
begin
  select role, full_name into v_role, v_actor_name from public.users where id = v_actor;
  if v_actor is null or coalesce(v_role, '') <> 'admin' then
    raise exception 'Only admins can change room status.' using errcode = '42501';
  end if;
  if p_status not in ('active', 'maintenance', 'inactive') then
    raise exception 'Invalid room status.' using errcode = '22023';
  end if;
  if p_status in ('maintenance', 'inactive') and nullif(trim(p_reason), '') is null then
    raise exception 'A reason is required for maintenance or inactive rooms.' using errcode = '22023';
  end if;
  select * into v_room from public.rooms where id = p_room_id for update;
  if not found then raise exception 'Room not found.' using errcode = 'P0002'; end if;
  if exists (select 1 from public.bookings b where b.room_id = p_room_id and b.status = 'checked_in') then
    raise exception 'A pet is currently staying in Room %. Check the pet out first.', v_room.room_number using errcode = '23514';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'booking_code', b.booking_code, 'pet_name', p.name,
    'owner_name', o.full_name, 'check_in_at', b.check_in_at,
    'expected_check_out_at', b.expected_check_out_at
  ) order by b.check_in_at), '[]'::jsonb), count(*)
  into v_upcoming, v_count
  from public.bookings b
  left join public.pets p on p.id = b.pet_id
  left join lateral (
    select ow.full_name from public.pet_owner_links pol
    join public.owners ow on ow.id = pol.owner_id
    where pol.pet_id = p.id order by pol.is_primary desc limit 1
  ) o on true
  where b.room_id = p_room_id and b.status in ('pending', 'confirmed')
    and coalesce(b.expected_check_out_at, b.check_in_at) >= now();
  if v_count > 0 and p_status <> 'active' and not p_force then
    return jsonb_build_object('requires_confirmation', true, 'bookings', v_upcoming);
  end if;
  update public.rooms set status = p_status,
    status_reason = case when p_status = 'active' then null else trim(p_reason) end,
    maintenance_until = case when p_status = 'maintenance' then p_until else null end,
    status_changed_at = now(), status_changed_by = v_actor
  where id = p_room_id;
  v_description := format('Room %s set to %s%s by %s', v_room.room_number, p_status,
    case when p_status in ('maintenance','inactive') then format(' (%s)', trim(p_reason)) else '' end,
    coalesce(v_actor_name, 'an administrator'));
  insert into public.activity_logs(actor_user_id, entity_type, entity_id, action, description, created_at)
  values (v_actor, 'room', p_room_id, 'status_changed', v_description, now());
  return jsonb_build_object('success', true, 'bookings', v_upcoming);
end;
$$;
revoke all on function public.set_room_status(uuid, text, text, date, boolean) from public;
grant execute on function public.set_room_status(uuid, text, text, date, boolean) to authenticated;

-- A trigger is an additional guard against direct status writes. The RPC runs as its owner.
create or replace function public.guard_room_status_update()
returns trigger language plpgsql set search_path = public as $$
begin
  if new.status is distinct from old.status and current_user not in ('postgres', 'service_role', 'supabase_admin') then
    raise exception 'Use set_room_status to change room status.' using errcode = '42501';
  end if;
  return new;
end;
$$;
drop trigger if exists guard_room_status_update on public.rooms;
create trigger guard_room_status_update before update of status on public.rooms
for each row execute function public.guard_room_status_update();
