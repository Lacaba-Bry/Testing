-- CareFur public website inquiry inbox for authenticated admin and staff.
-- Run in Supabase SQL Editor. Does not change public website submission code.
-- Review current policies before applying to production.

create or replace function public.carefur_is_staff()
returns boolean
language sql stable security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.users u
    where u.id = (select auth.uid()) and u.role::text in ('admin','staff')
  );
$$;

revoke all on function public.carefur_is_staff() from public;
grant execute on function public.carefur_is_staff() to authenticated;

alter table public.public_inquiries enable row level security;
alter table public.public_inquiry_messages enable row level security;

-- Names are unique, safe to apply more than once.
drop policy if exists "carefur_staff_read_inquiries" on public.public_inquiries;
create policy "carefur_staff_read_inquiries"
on public.public_inquiries for select to authenticated
using ((select public.carefur_is_staff()));

drop policy if exists "carefur_staff_update_inquiries" on public.public_inquiries;
create policy "carefur_staff_update_inquiries"
on public.public_inquiries for update to authenticated
using ((select public.carefur_is_staff()))
with check ((select public.carefur_is_staff()));

drop policy if exists "carefur_staff_read_inquiry_messages" on public.public_inquiry_messages;
create policy "carefur_staff_read_inquiry_messages"
on public.public_inquiry_messages for select to authenticated
using ((select public.carefur_is_staff()));

drop policy if exists "carefur_staff_reply_inquiries" on public.public_inquiry_messages;
create policy "carefur_staff_reply_inquiries"
on public.public_inquiry_messages for insert to authenticated
with check (
  (select public.carefur_is_staff())
  and sender_type = 'staff'
  and sender_user_id = (select auth.uid())
  and staff_user_id = (select auth.uid())
  and exists (
    select 1 from public.public_inquiries pi
    where pi.id = inquiry_id and pi.status = 'open'
  )
);

grant select, update on public.public_inquiries to authenticated;
grant select, insert on public.public_inquiry_messages to authenticated;

-- Existing RLS policies are permissive unless configured restrictive.
-- Audit any pre-existing anon/authenticated permissions before deployment.
