-- CareFur Admin Rev 3: run once in Supabase SQL Editor.
-- Adds fields needed by the room-status UI. Safe to rerun.
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS status_reason text;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS status_changed_at timestamptz;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS status_changed_by uuid;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS maintenance_until date;

-- Add missing rooms up to 13. Existing room data is preserved.
-- Adjust numbers/names if your facility uses a different room numbering convention.
INSERT INTO public.rooms (room_number, room_name, capacity, status)
SELECT 'R-' || lpad(n::text, 3, '0'), 'Pet Suite ' || n, 1, 'active'
FROM generate_series(1, 13) AS n
WHERE NOT EXISTS (
  SELECT 1 FROM public.rooms r
  WHERE r.room_number IN ('R-' || lpad(n::text, 3, '0'), lpad(n::text, 3, '0'))
)
ON CONFLICT (room_number) DO NOTHING;

-- Inspect actual room records before assuming there are exactly 13.
SELECT room_number, room_name, status, status_reason FROM public.rooms ORDER BY room_number;
