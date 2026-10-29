CareFur three-project bundle

ADMIN DASHBOARD:
  New separate sidebar pages: Boarding Extensions, Boarding Reviews, Reservation Requests.
  Removed extension and review panels from Boarding List.
  Reservation Requests shows submitted website requests from reservation_requests.
  Confirm/Decline uses staff-only SQL RPC and does not create a boarding record.

MOBILE:
  Preserves previously implemented review and extension functionality.
  Existing mobile code only shows extension on checked_in and review on checked_out.

PUBLIC WEBSITE:
  Preserves existing request submission and site design without altering schema or client logic.
  Incoming requests appear in the separate admin Reservations Requests page.

INSTALL:
  1. Apply existing 202610300001_boarding_extension_reviews.sql ONCE (if not already applied).
  2. Apply 202610300002_reservation_workflow.sql ONCE in Supabase SQL Editor.
  3. Deploy admin dashboard and keep mobile/site in sync with prior versions.

IMPORTANT:
  Boarding 'pending' is a staff workflow state. Do not auto-check-in based on the date.
  Staff should verify pet arrival and check-in manually through the operational process.
  Website request confirmation does NOT create pet, owner, room assignment or a boarding record.
  Camera expiry is NOT server-secure until camera endpoint authorization is implemented.

OPTIONAL_DATA_CLEANUP_REVIEW_FIRST.sql contains READ-ONLY inspection queries only.
  No user data has been deleted.
