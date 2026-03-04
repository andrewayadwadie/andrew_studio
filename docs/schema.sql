-- Andrew Studio — Supabase PostgreSQL Schema
-- Run this in your Supabase SQL editor

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Apps table
create table if not exists apps (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  slug text not null unique,
  description text,
  icon_url text,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- Categories table
create table if not exists categories (
  id uuid primary key default uuid_generate_v4(),
  app_id uuid not null references apps(id) on delete cascade,
  name text not null,
  description text,
  cover_image_url text,
  created_at timestamptz default now()
);

-- Wallpapers table
create table if not exists wallpapers (
  id uuid primary key default uuid_generate_v4(),
  app_id uuid not null references apps(id) on delete cascade,
  category_id uuid references categories(id) on delete set null,
  image_url text not null,
  thumbnail_url text,
  title text,
  description text,
  attached_link text,
  source text default 'upload' check (source in ('ai', 'upload', 'unsplash')),
  tags text[] default '{}',
  download_count integer default 0,
  pinterest_pin_id text,
  pinterest_board_id text,
  created_at timestamptz default now()
);

-- Pinterest accounts table
create table if not exists pinterest_accounts (
  id uuid primary key default uuid_generate_v4(),
  username text not null,
  access_token text not null,
  refresh_token text,
  token_expires_at timestamptz,
  is_active boolean default true,
  created_at timestamptz default now()
);

-- Notifications table
create table if not exists notifications (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  message text not null,
  app_slug text,
  data jsonb default '{}',
  sent_at timestamptz default now()
);

-- Indexes for performance
create index if not exists idx_wallpapers_app_id on wallpapers(app_id);
create index if not exists idx_wallpapers_category_id on wallpapers(category_id);
create index if not exists idx_categories_app_id on categories(app_id);

-- Row Level Security
alter table apps enable row level security;
alter table categories enable row level security;
alter table wallpapers enable row level security;
alter table pinterest_accounts enable row level security;
alter table notifications enable row level security;

-- Public read for wallpapers and categories (mobile app uses anon key)
create policy "Public read wallpapers" on wallpapers for select using (true);
create policy "Public read categories" on categories for select using (true);
create policy "Public read apps" on apps for select using (true);

-- Service role full access (backend API uses service role key)
create policy "Service role all on wallpapers" on wallpapers
  using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

create policy "Service role all on categories" on categories
  using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

create policy "Service role all on apps" on apps
  using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

create policy "Service role all on pinterest_accounts" on pinterest_accounts
  using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

create policy "Service role all on notifications" on notifications
  using (auth.role() = 'service_role') with check (auth.role() = 'service_role');

-- Seed first app: Walluxe
insert into apps (name, slug, description) values
  ('Walluxe', 'walluxe', 'Premium wallpaper app')
on conflict (slug) do nothing;
