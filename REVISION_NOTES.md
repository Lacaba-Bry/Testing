# CareFur Admin revised package

- Pets: default All pets, improved species filter, owner and phone columns, message action, centered modal profile (no checkout / feeding column).
- Boarding List: removed Details column; updated table styling.
- Dashboard: removed duplicate occupancy progress section, improved panels.
- Admin: Connection Manual for ESP32 feeder and ESP32-CAM; see Admin > Hardware > Connection Manual.
- Supabase: `SUPABASE_RUN_THIS.sql` adds missing room columns and missing numbered rooms through 13. Check actual room numbering and existing room records before applying.
- For room status actions, the pre-existing `supabase/migrations/202610130001_room_status_management.sql` provides an admin RPC and audit logging. Review and apply separately.
- No source connection credentials are changed. Never commit real `.env` secrets.

## Install
`npm install` then `npm run dev`. Run SQL in Supabase SQL Editor against the intended project first.
