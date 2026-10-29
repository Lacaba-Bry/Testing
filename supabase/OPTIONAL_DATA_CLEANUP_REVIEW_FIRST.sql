-- CareFur OPTIONAL data cleanup (NOT RUN AUTOMATICALLY)
-- IMPORTANT: Back up your database first. This script intentionally only gives a preview.
-- Pet, booking and feeding data are interconnected with owners, links, records, alerts, chat and reviews.
-- This script does not blindly CASCADE and does not delete ANYTHING.
-- Check that the names exist on your actual database and review each FK relationship.
SELECT table_name FROM information_schema.tables
WHERE table_schema='public' AND (
 table_name ILIKE '%book%' OR table_name ILIKE '%pet%' OR
 table_name ILIKE '%feed%' OR table_name ILIKE '%extension%' OR table_name ILIKE '%review%')
ORDER BY table_name;

-- List foreign keys pointing to bookings/pets and feeding-related tables.
SELECT con.conrelid::regclass AS dependent_table,
       con.confrelid::regclass AS referenced_table,
       con.conname AS fk_name,
       pg_get_constraintdef(con.oid) AS definition
FROM pg_constraint AS con
WHERE con.contype = 'f'
  AND (con.confrelid IN ('public.bookings'::regclass,'public.pets'::regclass)
       OR con.conrelid::regclass::text ILIKE '%feed%')
ORDER BY 2,1;

-- To reset test data safely, identify the exact rows and dependent tables first.
-- Do not run TRUNCATE ... CASCADE on a live Supabase project.
-- Contact me with the output of these SELECTs for a verified ordered DELETE script.
