-- CAREFUR: Pending -> No Show after 24 hours with no staff check-in.
-- Run this once in Supabase SQL Editor. Review existing constraints before production.
-- Only pending bookings are changed; checked-in/checked-out/cancelled remain untouched.

DO $$
DECLARE
  type_kind "char";
  type_schema text;
  type_name text;
  constraint_record record;
BEGIN
  SELECT t.typtype, n.nspname, t.typname
    INTO type_kind, type_schema, type_name
    FROM pg_attribute a
    JOIN pg_class c ON c.oid = a.attrelid
    JOIN pg_namespace ns ON ns.oid = c.relnamespace
    JOIN pg_type t ON t.oid = a.atttypid
    JOIN pg_namespace n ON n.oid = t.typnamespace
   WHERE ns.nspname = 'public' AND c.relname = 'bookings'
     AND a.attname = 'status' AND NOT a.attisdropped;
  IF type_kind IS NULL THEN RAISE EXCEPTION 'public.bookings.status not found'; END IF;
  IF type_kind = 'e' THEN
    IF NOT EXISTS (SELECT 1 FROM pg_enum e JOIN pg_type t ON t.oid=e.enumtypid
                    JOIN pg_namespace n ON n.oid=t.typnamespace
                   WHERE n.nspname=type_schema AND t.typname=type_name AND e.enumlabel='no_show') THEN
      EXECUTE format('ALTER TYPE %I.%I ADD VALUE IF NOT EXISTS %L', type_schema, type_name, 'no_show');
    END IF;
  END IF;
END $$;

