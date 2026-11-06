CareFur Staff Boarding Actions — October 30, 2026

Changes:
- src/pages/Boardings.jsx: staff-admin controls for pending bookings (Early Check-In, Cancel Booking), confirmation prompts, error feedback and refresh.
- src/pages/Boardings.css: action layout for desktop/mobile.
- supabase/migrations/202610300003_boarding_staff_actions.sql: staff-only RPC; checks current booking status, updates dates atomically, blocks overlapping room stays, expires booking_access on cancellation.

INSTALL:
1. Back up database and existing project first.
2. Apply 202610300001_boarding_extension_reviews.sql if not applied (creates carefur_boarding_staff), then apply 202610300003_boarding_staff_actions.sql in the Supabase SQL Editor.
3. Replace admin source code and reinstall dependencies with npm ci, then npm run build.
4. Test on pending booking, including early check-in and cancellation, before deploying.

POLICY:
- Early Check-In retains original duration exactly: new_checkout = server_current_time + (old_checkout - old_checkin).
- Only pending bookings can be checked in or cancelled; only admin accounts see buttons; SQL independently checks authorized staff/admin.
- Cancelling sets bookings.status='cancelled' and expires booking_access.expires_at.
- Existing login accounts are unchanged.

IMPORTANT CAMERA SECURITY LIMITATION:
The existing hardcoded/public ngrok camera stream URL CANNOT be revoked by this database change. Camera access is only secure after the camera gateway checks live booking authorization on every stream request, and disconnects existing viewers upon cancellation or expiry. Do not expose the direct camera URL to clients.

KNOWN LIMITATIONS:
- This update modifies the admin dashboard only. It does not modify the mobile app or its camera gateway.
- The owner's already-redeemed/local boarding code may remain cached, but future code verification rejects cancelled bookings and expired access codes; other endpoints must enforce booking status.
- Project dependency build and live Supabase RPC integration were not run in this environment.
