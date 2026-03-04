#!/usr/bin/env bash
# Andrew Studio — Deploy backend to Vercel
# Run this script from the backend/ directory after `vercel login`

set -e

DEPLOY_DIR="$(dirname "$0")/build"

echo "==> Rebuilding server..."
dart "$(dart pub global list 2>/dev/null | grep dart_frog_cli | head -1 | awk '{print $1}')" build || \
  dart "$(ls ~/.pub-cache/global_packages/dart_frog_cli/bin/*.snapshot 2>/dev/null | head -1)" build

echo "==> Adding Vercel env variables..."
cd "$DEPLOY_DIR"

# Add env vars to Vercel (run once; skip if already set)
vercel env add SUPABASE_URL production <<< "https://yusygjecjjecrerctven.supabase.co" 2>/dev/null || true
vercel env add SUPABASE_SERVICE_ROLE_KEY production <<< "$(grep SUPABASE_SERVICE_ROLE_KEY ../.env | cut -d= -f2-)" 2>/dev/null || true
vercel env add SUPABASE_JWT_SECRET production <<< "$(grep SUPABASE_JWT_SECRET ../.env | cut -d= -f2-)" 2>/dev/null || true
vercel env add CLOUDINARY_CLOUD_NAME production <<< "dyjfsieex" 2>/dev/null || true
vercel env add CLOUDINARY_API_KEY production <<< "872389178932126" 2>/dev/null || true
vercel env add CLOUDINARY_API_SECRET production <<< "$(grep CLOUDINARY_API_SECRET ../.env | cut -d= -f2-)" 2>/dev/null || true
vercel env add CLOUDINARY_UPLOAD_PRESET production <<< "ANDREW_STUDIO" 2>/dev/null || true
vercel env add GEMINI_API_KEY production <<< "$(grep GEMINI_API_KEY ../.env | cut -d= -f2-)" 2>/dev/null || true
vercel env add UNSPLASH_ACCESS_KEY production <<< "$(grep UNSPLASH_ACCESS_KEY ../.env | cut -d= -f2-)" 2>/dev/null || true
vercel env add UNSPLASH_SECRET_KEY production <<< "$(grep UNSPLASH_SECRET_KEY ../.env | cut -d= -f2-)" 2>/dev/null || true

echo "==> Deploying to Vercel..."
vercel --prod

echo "==> Done!"
