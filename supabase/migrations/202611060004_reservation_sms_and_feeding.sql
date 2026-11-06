-- Reservation notification ledger. Only the server-side Edge Function can access this table.
create table if not exists public.reservation_sms_notifications (
  request_id uuid primary key references public.reservation_requests(id) on delete cascade,
  status text not null check (status in ('sending','queued','failed')),
  error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.reservation_sms_notifications enable row level security;
revoke all on public.reservation_sms_notifications from public, anon, authenticated;

-- Physical feeder uses one preloaded slot, not a weight-controlled portion.
alter table public.feeding_schedules alter column portion_grams drop not null;
-- Inspect any existing portion_grams CHECK constraints before migration; some schemas
-- may enforce > 0 even when null is allowed. Null is valid for compartment-only feeding.
