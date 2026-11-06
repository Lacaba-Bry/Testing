-- CareFur: online schedule tester. Runs in Supabase, NOT the ESP32 RTC.
-- Requirements: pg_cron extension available in Supabase Database > Extensions.
-- Run in SQL Editor as project database owner, once.
CREATE EXTENSION IF NOT EXISTS pg_cron;

CREATE TABLE IF NOT EXISTS public.feeder_test_schedules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_code text NOT NULL,
  created_by uuid NOT NULL,
  schedule_type text NOT NULL CHECK (schedule_type IN ('once','daily')),
  run_at timestamptz,
  local_time time without time zone,
  enabled boolean NOT NULL DEFAULT true,
  last_fired_key text,
  last_command_id uuid,
  last_result text,
  last_attempt_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT feeder_schedule_fields CHECK (
    (schedule_type = 'once' AND run_at IS NOT NULL AND local_time IS NULL)
    OR (schedule_type = 'daily' AND run_at IS NULL AND local_time IS NOT NULL)
  )
);
CREATE INDEX IF NOT EXISTS feeder_test_schedules_device_idx ON public.feeder_test_schedules(device_code,created_at DESC);
ALTER TABLE public.feeder_test_schedules ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.feeder_test_schedules FROM PUBLIC, anon, authenticated;
-- The admin Edge Function uses the service-role key. Ordinary browser clients cannot alter schedules directly.

CREATE OR REPLACE FUNCTION public.carefur_dispatch_feeder_test_schedules()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, pg_temp
AS $$
DECLARE
  item public.feeder_test_schedules%ROWTYPE;
  local_now timestamp;
  slot_key text;
  inserted_id uuid;
BEGIN
  -- Safe if a manual call overlaps a cron invocation.
  IF NOT pg_try_advisory_xact_lock(85100932) THEN RETURN; END IF;
  local_now := date_trunc('minute', now() AT TIME ZONE 'Asia/Manila');

  FOR item IN
    SELECT * FROM public.feeder_test_schedules WHERE enabled = true ORDER BY created_at FOR UPDATE SKIP LOCKED
  LOOP
    IF item.schedule_type = 'once' THEN
      -- Only execute schedules due within the last 5 minutes; older missed jobs are marked missed.
      IF item.run_at > now() THEN CONTINUE; END IF;
      IF item.run_at < now() - interval '5 minutes' THEN
        UPDATE public.feeder_test_schedules SET enabled=false, last_result='missed (offline scheduler or job delayed)', last_attempt_at=now() WHERE id=item.id;
        CONTINUE;
      END IF;
      slot_key := 'once:' || item.id::text;
    ELSE
      -- Daily schedules are checked against local Philippine wall-clock time.
      IF extract(hour FROM item.local_time)::int <> extract(hour FROM local_now)::int
         OR extract(minute FROM item.local_time)::int <> extract(minute FROM local_now)::int THEN
        CONTINUE;
      END IF;
      slot_key := to_char(local_now,'YYYY-MM-DD HH24:MI');
    END IF;

    IF item.last_fired_key IS NOT DISTINCT FROM slot_key THEN CONTINUE; END IF;

    -- Device must still be active; otherwise don't move hardware.
    IF NOT EXISTS (SELECT 1 FROM public.devices d WHERE d.device_code=item.device_code AND d.device_type='feeder' AND d.status='active') THEN
      UPDATE public.feeder_test_schedules SET last_result='skipped: device inactive',last_fired_key=slot_key,last_attempt_at=now(),enabled=CASE WHEN item.schedule_type='once' THEN false ELSE enabled END WHERE id=item.id;
      CONTINUE;
    END IF;

    -- Never overlap with a manual command, home command, or another schedule.
    IF EXISTS (SELECT 1 FROM public.feeder_test_commands c WHERE c.device_code=item.device_code AND c.status IN ('pending','claimed')) THEN
      UPDATE public.feeder_test_schedules SET last_result='skipped: feeder busy',last_fired_key=slot_key,last_attempt_at=now(),enabled=CASE WHEN item.schedule_type='once' THEN false ELSE enabled END WHERE id=item.id;
      CONTINUE;
    END IF;

    -- Use the SAME normal command queue as the working Rotate 120 button.
    INSERT INTO public.feeder_test_commands(device_code,steps,direction,command_type,status,requested_by)
    VALUES(item.device_code,533,'clockwise','rotate','pending',item.created_by)
    RETURNING id INTO inserted_id;

    UPDATE public.feeder_test_schedules
       SET last_fired_key=slot_key,last_command_id=inserted_id,last_result='queued',last_attempt_at=now(),
           enabled=CASE WHEN item.schedule_type='once' THEN false ELSE enabled END
     WHERE id=item.id;
  END LOOP;
END;
$$;
REVOKE ALL ON FUNCTION public.carefur_dispatch_feeder_test_schedules() FROM PUBLIC, anon, authenticated;

-- Remove an older job of the same name if this migration is rerun.
DO $$ BEGIN
  IF EXISTS (SELECT 1 FROM cron.job WHERE jobname = 'carefur-feeder-test-scheduler') THEN
    PERFORM cron.unschedule('carefur-feeder-test-scheduler');
  END IF;
END $$;
SELECT cron.schedule('carefur-feeder-test-scheduler','* * * * *', $$SELECT public.carefur_dispatch_feeder_test_schedules();$$);
