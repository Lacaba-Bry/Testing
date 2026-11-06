-- Cloud dispatcher must NOT queue meal commands when RTC offline mode is enabled.
create or replace function public.carefur_dispatch_confirmed_feeding()
returns integer language plpgsql security definer set search_path = public, pg_temp as $$
declare
  meal record;
  v_command uuid;
  v_count integer := 0;
begin
  if not pg_try_advisory_xact_lock(85100935) then return 0; end if;
  for meal in
    select fs.id schedule_id, d.device_code, fs.compartment_number, fs.scheduled_at, b.id booking_id
    from public.feeding_schedules fs
    join public.bookings b on b.id=fs.booking_id
    join public.room_devices rd on rd.room_id=b.room_id and rd.unassigned_at is null
    join public.devices d on d.id=rd.device_id and d.device_type='feeder' and d.status='active'
    where fs.feeding_method='automatic' and fs.status='pending'
      and fs.scheduled_at between now()-interval '2 minutes' and now()
      and b.status='checked_in'
      and fs.compartment_number in (1,2,3)
      and not exists (select 1 from public.feeder_rtc_configs rtc where rtc.device_code=d.device_code and rtc.enabled)
      and not exists(select 1 from public.carefur_feeding_dispatches x where x.schedule_id=fs.id)
    order by fs.scheduled_at for update of fs skip locked
  loop
    -- Never send if any other motor action is still pending/running.
    if exists(select 1 from public.feeder_test_commands c where c.device_code=meal.device_code and c.status in ('pending','claimed')) then
      continue;
    end if;
    -- The existing motor firmware rotates 533 steps (nominal 120 degrees) per command.
    -- It does NOT provide positioning confirmation, so do not confuse this with a guarantee
    -- that compartment 1/2/3 was physically selected.
    insert into public.feeder_test_commands(device_code,steps,direction,command_type,status,requested_by)
    select meal.device_code,533,'clockwise','rotate','pending',coalesce(b.created_by, null)
    from public.bookings b where b.id=meal.booking_id
    returning id into v_command;
    insert into public.carefur_feeding_dispatches(schedule_id,command_id,device_code)
    values(meal.schedule_id,v_command,meal.device_code);
    v_count := v_count+1;
  end loop;
  return v_count;
end;
$$;
revoke all on function public.carefur_dispatch_confirmed_feeding() from public,anon,authenticated;
