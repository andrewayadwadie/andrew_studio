# Andrew Studio — Architecture

## Overview
Monorepo with three projects:
1. **dashboard** (`apps/dashboard`) — Jaspr web admin
2. **backend** (`backend/`) — Dart Frog REST API deployed on Vercel
3. **mobile_app** (`apps/mobile_app`) — Flutter Android + iOS (multi-flavor)

## API Routing
Single domain: `api.andrewstudio.com`
Path-based per app: `/apps/{slug}/wallpapers`, `/apps/{slug}/categories`

## Image Pipeline
```
Dashboard/Mobile → POST /generate (prompt)
                 → Gemini 2.0 Flash generates image
                 → Upload to Cloudinary
                 → Store URL in Supabase `wallpapers` table
```

## Auth Flow
- Dashboard: Supabase Auth (email/password)
- API: JWT bearer token (Supabase JWT)
- Mobile: Supabase anon key + RLS

## Database Schema
See `docs/schema.sql`

## Deployment
- Backend: Vercel (via `vercel.json` in `/backend`)
- Dashboard: Jaspr static build → any static host
- Mobile: Play Store + App Store (per flavor)
