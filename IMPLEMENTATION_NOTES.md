# CareFur integrated changes — deployment notes

## Included and verified in source

- New booking SMS using `create-booking` is retained. It was already in the uploaded archive. The booking access code goes **only** in the message after actual booking creation, never in the request-received SMS.
- Automatic-feeder form assigns Morning=1, Afternoon=2, Evening=3 and removes the grams control. Both frontend and `create-booking` Edge Function validate that mapping server-side.
- New reservation-request SMS Edge Function: only accepts authenticated database webhooks, uses a separate one-time ledger, requests payment **without a boarding code**.
- Room status repair: new SQL RPC migration compatible with existing Rooms page.
- Additive production feeding dispatcher provided, **not enabled**. If enabled after field testing, it enqueues only for `checked_in` bookings, using the existing ESP32 feeder motor queue. It does not prove motor movement, camera playback, or food delivery.
- Main ESP32 firmware integrates DS3231 on GPIO21/22, offline scheduled dry run, and cached schedules. No separate offline tester sketch is required.

## Mandatory setup — reservation SMS

1. Run `supabase/migrations/202611060004_reservation_sms_and_feeding.sql` in your Supabase SQL Editor (after reviewing database constraints).
2. Configure these **Edge Function secrets**: `TEXTBEE_API_KEY`, `CAREFUR_PAYMENT_INSTRUCTIONS`, `RESERVATION_WEBHOOK_SECRET`. The payment instruction must explicitly say where/how the customer pays, using your actual approved payment policy; do not invent payment details.
3. Deploy `npx supabase functions deploy reservation-request-sms --project-ref iswstisiecdtadtwnpkj --no-verify-jwt`.
4. Create a Supabase **Database Webhook** on `public.reservation_requests` for `INSERT` only. Target:
   `https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/reservation-request-sms`
   Set header `x-carefur-webhook-secret` to the same strong secret (not the TextBee key). Enable the `pg_net` extension if required by the dashboard.
5. Test with a phone number you control. Check `reservation_sms_notifications` and TextBee device status. Do not resend an already claimed notification automatically without human review. The webhook's `queued` result is not delivery confirmation.

The website project is **not included** in the archive; this uses a database INSERT webhook to avoid requiring site frontend changes. If your website sends requests through a different table or schema, this webhook must be adjusted.

## Mandatory setup — booking and feeder

- Deploy the modified `create-booking` Edge Function to activate fixed automatic compartment mapping. Without redeployment the deployed function still requires a positive grams field.
- If your live `feeding_schedules` table has CHECK constraints requiring grams, inspect them before applying the nullable-grams migration. Do not remove other safety constraints without review.
- Run `202611060005_room_status_admin_fix.sql` to update the existing Rooms modal RPC, after inspecting current role schema and confirming you have an admin role in `public.users`.
- For cloud feeding, run `202611060006_feeder_dispatch.sql`. **Do not enable its optional cron schedule** until hardware mapping, motor calibration, device identity and duplicate-feed protection have been tested on the bench.
- Existing `feeder_test_schedules` auto-tester is independent from production feeding. Disable test cron and schedules before enabling production cron to avoid duplicate rotations.

## DS3231 offline testing

- Use `firmware/CareFur_Feeder_RTC_Integrated/CareFur_Feeder_RTC_Integrated.ino` for both real device operation and safe offline tests. `J` shows RTC status; `K` runs a no-motor diagnostic. The scheduled offline check prints dry-run events by default. Sync once online before testing without Wi-Fi. Verify motor mechanics before activating physical dispensing.
- Camera hardware streaming remains unchanged; the existing camera manager is retained. This update does **not** add ESP32 camera firmware or claim that the camera records dispensing events. For synchronized capture, firmware / camera gateway event API and device identifiers are required.

## Room status diagnostics

If status changes still fail, run in SQL Editor:

```sql
select room_number,status,status_reason from public.rooms order by room_number;
select id,role from public.users order by role;
select conname,pg_get_constraintdef(oid) from pg_constraint where conrelid='public.rooms'::regclass;
```

Error messages from `set_room_status` and server logs are necessary to diagnose a remaining permissions/schema mismatch. Room status is independent of occupancy (`checked_in` bookings).

## Safety notes

- Never expose TextBee, service-role, or webhook keys with a `VITE_` prefix.
- Cloud and RTC offline feeding **cannot both autonomously actuate the same feeder**. Choose one controller per device, and synchronize RTC schedules over a protected device protocol before calling a setup production-ready.
- The ESP32 step-count mapping assumes sequential 120-degree indexing; without homing/feedback, the software cannot guarantee a specific compartment is lined up.
