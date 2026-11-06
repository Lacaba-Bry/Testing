# CareFur ESP32 + DS3231 / Admin update

## What's updated

- Based on the uploaded ESP32 firmware: preserved NEMA17 STEP 33 / DIR 26, limit switch 27, button 32, HX711 DT16/SCK13, Wi-Fi portal, Supabase command polling, camera pairing, food telemetry.
- DS3231 uses I2C SDA 21 / SCL 22, VCC 3V3, GND GND.
- Added `FeederRTCSettings.jsx` in Motor Test dashboard, configured via an admin-authenticated Edge Function.
- ESP32 loads three daily times (morning/afternoon/evening, slots 1/2/3) and enable flag from cloud when online; NVS retains the last synced config during outages. DS3231 holds Philippine local time.
- Local RTC checks the three daily times. One trigger per meal per calendar day is recorded in NVS before any motor movement (at-most-once attempt, NOT exactly-once dispensing).
- Cloud dispatcher migration adds an RTC-mode exclusion, so its queued booking meals are skipped for an RTC-enabled feeder.

## CRITICAL setup sequence

1. **Do not upload secrets to GitHub.** Firmware has placeholders for `DEVICE_SECRET`, setup AP password, and camera pairing key. Replace them locally with securely generated values matching the currently deployed Supabase secrets and camera firmware. Rotate the previously exposed device credentials.
2. Apply SQL in order: `202611060007_feeder_rtc_config.sql`, `202611060008_feeder_rtc_dispatch_guard.sql` in Supabase SQL Editor.
3. Deploy the new function: `npx supabase functions deploy feeder-rtc-config --project-ref iswstisiecdtadtwnpkj --no-verify-jwt`. Function manually authenticates dashboard JWT/admin role and the device secret. The `--no-verify-jwt` flag is required for the ESP32 device request without user JWT. Do not remove the in-function authentication.
4. In Supabase Edge Function secrets verify `DEVICE_SECRET` matches ESP32; `SUPABASE_URL`, `SUPABASE_ANON_KEY` and `SUPABASE_SERVICE_ROLE_KEY` must be available to the function.
5. Install Arduino libraries `ArduinoJson` 7.x, `HX711`, `RTClib` (Adafruit) and its dependencies, plus the **existing** `CareFurWiFiPortal.h/.cpp` files from your working feeder project (not supplied in this upload).
6. Upload `firmware/CareFur_Feeder_RTC_Integrated/CareFur_Feeder_RTC_Integrated.ino` and inspect Serial Monitor at 115200 baud. `J` prints RTC date, status, version. `K` runs the built-in safe offline schedule test, with no motor movement or persistent writes. A lost-power DS3231 can initialize once via NTP when Wi-Fi becomes available; this requires a working connection. An offline board without valid RTC time must not dispense.
7. In Admin → Feeder ESP32 → DS3231 Offline Feeding set times, enable, save. The ESP32 must connect once and print `[RTC SYNC] Saved...` to cache the configuration. The dashboard version does not prove a physical sync.
8. **Safe dry run by default**: `RTC_ALLOW_MOTOR_DISPENSING = false`. Set a meal 1–2 minutes ahead and inspect `[RTC DRY RUN]` on serial. No step pulses are commanded by offline RTC at this setting.
9. BEFORE any physical feeding: disable the cloud feeding cron, ensure all cloud test schedules are disabled, verify RTC time, verify home switch, manually calibrate 533 step moves and actual compartment-to-drop alignment; add independent interlocks and physical supervision. Only then consider changing the compile-time motor flag.

## Important limitations

- This is a **device-level offline schedule test**, NOT a fully deployed booking-aware production schedule. It will not automatically stop when a pet checks out while the feeder is offline. Leave physical RTC dispensing disabled until boarding dates, status, occupancy, override/reconciliation and telemetry are implemented and tested.
- The exact motor movement needed to release a specific compartment is **NOT established** by this code; the motor logic uses the original estimated 533 steps/120° and cannot sense a verified dispensing event.
- This inherited firmware still uses `client.setInsecure()` for HTTPS and needs CA certificate verification/pinning before production.
- If Wi-Fi is disconnected, Admin cannot change the ESP32 schedule until it reconnects. Local RTC continues with previously cached settings. A cloud toggle is not an emergency stop for an offline board.
- Avoid running both cloud and RTC scheduling concurrently. The DB guard protects `carefur_dispatch_confirmed_feeding`, but other integrations and pre-existing queued commands must be disabled separately.
- Existing camera pairing is preserved but no new camera snapshot-at-feeding logic was added: coordinating camera recording requires the actual camera firmware/gateway API.

## Single firmware: offline test built into the main sketch

Upload only `firmware/CareFur_Feeder_RTC_Integrated/CareFur_Feeder_RTC_Integrated.ino`. There is no separate test sketch.
Open Serial Monitor (115200 baud): `J` shows RTC status and `K` prints all three cached feeding times, compartments, and whether a schedule is due. `K` never rotates the motor, marks a meal as fed, or writes to flash. The normal RTC loop independently runs scheduled dry-run messages while `RTC_ALLOW_MOTOR_DISPENSING` remains `false`. To test without Wi-Fi, first synchronize the schedule and clock while online, then disconnect Wi-Fi and observe the normal RTC schedule trigger.
