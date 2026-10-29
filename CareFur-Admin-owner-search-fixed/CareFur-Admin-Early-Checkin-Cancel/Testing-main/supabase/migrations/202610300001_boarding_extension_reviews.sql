-- Additive CareFur boarding features: does not alter existing columns or policies.
-- Apply this once in Supabase SQL Editor BEFORE deploying the updated clients.
create table if not exists public.boarding_extension_requests (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings(id) on delete cascade,
  owner_id uuid not null references public.owners(id),
  requested_checkout_at timestamptz not null,
  reason text check (char_length(reason) <= 500),
  status text not null default 'pending' check (status in ('pending','approved','declined')),
  reviewed_by uuid references public.users(id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);
create unique index if not exists carefur_one_pending_extension_per_booking
  on public.boarding_extension_requests(booking_id) where status = 'pending';
create index if not exists carefur_extension_booking_idx on public.boarding_extension_requests(booking_id);

create table if not exists public.boarding_reviews (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null unique references public.bookings(id) on delete cascade,
  owner_id uuid not null references public.owners(id),
  rating integer not null check (rating between 1 and 5),
  comment text not null check (char_length(trim(comment)) between 1 and 1500),
  created_at timestamptz not null default now()
);

-- Associate requests and reviews with the signed-in owner through pet_owner_links.
create or replace function public.carefur_owns_booking(p_booking_id uuid)
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (
    select 1 from public.bookings b
    join public.pet_owner_links pol on pol.pet_id = b.pet_id
    where b.id = p_booking_id and pol.owner_id = (select auth.uid())
  );
$$;
revoke all on function public.carefur_owns_booking(uuid) from public;
grant execute on function public.carefur_owns_booking(uuid) to authenticated;

-- Separate name to avoid overriding existing carefur_is_staff function.
create or replace function public.carefur_boarding_staff()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.users u where u.id = (select auth.uid()) and u.role::text in ('admin','staff'));
$$;
revoke all on function public.carefur_boarding_staff() from public;
grant execute on function public.carefur_boarding_staff() to authenticated;

alter table public.boarding_extension_requests enable row level security;
alter table public.boarding_reviews enable row level security;

create policy "carefur_extension_read" on public.boarding_extension_requests
for select to authenticated using (public.carefur_boarding_staff() or (owner_id = (select auth.uid()) and public.carefur_owns_booking(booking_id)));
create policy "carefur_extension_request" on public.boarding_extension_requests
for insert to authenticated with check (
  owner_id = (select auth.uid()) and public.carefur_owns_booking(booking_id)
  and status = 'pending' and reviewed_by is null and reviewed_at is null
  and exists (select 1 from public.bookings b where b.id=booking_id and b.status::text='checked_in'
    and b.expected_check_out_at > now() and requested_checkout_at > b.expected_check_out_at
    and requested_checkout_at <= b.expected_check_out_at + interval '30 days')
);
create policy "carefur_review_read" on public.boarding_reviews
for select to authenticated using (public.carefur_boarding_staff() or (owner_id = (select auth.uid()) and public.carefur_owns_booking(booking_id)));
create policy "carefur_review_insert" on public.boarding_reviews
for insert to authenticated with check (
  owner_id = (select auth.uid()) and public.carefur_owns_booking(booking_id)
  and exists (select 1 from public.bookings b where b.id=booking_id and b.status::text='checked_out' and b.actual_check_out_at is not null)
);

grant select, insert on public.boarding_extension_requests to authenticated;
grant select, insert on public.boarding_reviews to authenticated;

-- Approval changes the booking date in the same transaction.
-- Staff identity checked server-side; no direct update permission granted to the client.
create or replace function public.carefur_review_extension(p_request_id uuid, p_approve boolean)
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_request public.boarding_extension_requests%rowtype;
  v_booking public.bookings%rowtype;
begin
  if not public.carefur_boarding_staff() then raise exception 'Staff authorization required'; end if;
  select * into v_request from public.boarding_extension_requests where id=p_request_id for update;
  if not found or v_request.status <> 'pending' then raise exception 'Request is not pending'; end if;
  select * into v_booking from public.bookings where id=v_request.booking_id for update;
  if not found or v_booking.status::text <> 'checked_in' or v_booking.actual_check_out_at is not null then
    raise exception 'Booking is no longer active';
  end if;
  if p_approve then
    if v_booking.expected_check_out_at >= v_request.requested_checkout_at then
      raise exception 'Requested date is no longer later than current checkout';
    end if;
    -- Room conflict detection: a pending/checked-in overlapping booking cannot share a room.
    if exists (
      select 1 from public.bookings b
      where b.room_id=v_booking.room_id and b.id<>v_booking.id
        and b.status::text in ('pending','checked_in')
        and b.check_in_at < v_request.requested_checkout_at
        and coalesce(b.actual_check_out_at,b.expected_check_out_at) > v_booking.expected_check_out_at
    ) then raise exception 'Room is booked during the requested extension'; end if;
    update public.bookings set expected_check_out_at=v_request.requested_checkout_at where id=v_booking.id;
  end if;
  update public.boarding_extension_requests
    set status=case when p_approve then 'approved' else 'declined' end,
      reviewed_by=auth.uid(), reviewed_at=now()
    where id=v_request.id;
end;
$$;
revoke all on function public.carefur_review_extension(uuid,boolean) from public;
grant execute on function public.carefur_review_extension(uuid,boolean) to authenticated;
