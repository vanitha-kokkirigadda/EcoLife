create extension if not exists pgcrypto;

create table if not exists public.users (
  id uuid primary key references auth.users not null,
  email text,
  name text,
  city text,
  country text,
  eco_points int default 0,
  badges text[] default '{}',
  pledges text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.logs (
  id bigserial primary key,
  uid uuid references public.users(id) on delete cascade,
  date timestamptz not null,
  bottles int default 0,
  bags int default 0,
  cutlery int default 0,
  total_items int default 0,
  notes text,
  created_at timestamptz default now()
);
create index if not exists logs_uid_date_idx on public.logs(uid, date);

create table if not exists public.tips (
  id bigserial primary key,
  title text not null,
  body text not null,
  priority int default 0
);

create table if not exists public.challenges (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  start timestamptz not null,
  "end" timestamptz not null
);

create table if not exists public.participants (
  id bigserial primary key,
  challenge_id uuid references public.challenges(id) on delete cascade,
  uid uuid references public.users(id) on delete cascade,
  progress int default 0,
  joined_at timestamptz default now(),
  unique (challenge_id, uid)
);

create table if not exists public.stores (
  id bigserial primary key,
  name text not null,
  description text,
  lat double precision not null,
  lng double precision not null
);

-- Leaderboard base (optional seeds)
create table if not exists public.leaderboard (
  id bigserial primary key,
  name text not null,
  points int not null
);
