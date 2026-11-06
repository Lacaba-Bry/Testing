-- CareFur DS3231 offline feeding configuration (local time is Asia/Manila, UTC+8).
-- Apply in Supabase SQL Editor. This does not activate offline motor movement by itself.
create table if not exists public.feeder_rtc_configs (
  device_code text primary key,
  enabled boolean not null default false,
  morning_time time without time zone not null default '08:00',
  afternoon_time time without time zone not null default '13:00',
  evening_time time without time zone not null default '19:00',
  version integer not null default 1,
  updated_at timestamptz not null default now(),
  updated_by uuid references auth.users(id)
);
alter table public.feeder_rtc_configs enable row level security;
revoke all on public.feeder_rtc_configs from anon,authenticated;
comment on table public.feeder_rtc_configs is 'Device caches this config in NVS; no cloud motor dispatch may run for the same device.';
