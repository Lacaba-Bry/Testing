# CareFur Admin

Staff dashboard for CareFur pet-hotel operations, built with React 19, Vite, React Router, Supabase and Phosphor icons.

## Run locally

```bash
npm ci
cp .env.example .env.local
npm run dev
```

Populate `.env.local` with your project's public Supabase URL and anon/publishable key. Never commit the service-role key or device secrets.

## Environment

- `VITE_SUPABASE_URL`: Supabase project URL
- `VITE_SUPABASE_ANON_KEY`: Supabase publishable/anon key
- `VITE_ESP32_CAM_URL`: optional ESP32-CAM gateway endpoint used by camera monitoring.

## Checks

```bash
npm run lint
npm run build
```

All protected routes, existing Edge Function calls, and the existing database schema are retained.
