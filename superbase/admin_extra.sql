create table if not exists public.pledge_options (
  id bigserial primary key,
  label text not null,
  active boolean default true
);

alter table public.tips add column if not exists approved boolean default true;
alter table public.tips add column if not exists submitted_by text;
alter table public.challenges add column if not exists points int default 50;

alter table public.pledge_options enable row level security;
drop policy if exists "pledges public read" on public.pledge_options;
create policy "pledges public read" on public.pledge_options for select using (active = true);
drop policy if exists "pledges admin write" on public.pledge_options;
create policy "pledges admin write" on public.pledge_options for all using (public.is_admin(auth.uid())) with check (public.is_admin(auth.uid()));

alter table public.tips enable row level security;
drop policy if exists "tips public read" on public.tips;
create policy "tips public read" on public.tips for select using (approved = true or public.is_admin(auth.uid()));
drop policy if exists "tips user insert" on public.tips;
create policy "tips user insert" on public.tips for insert with check (true);
drop policy if exists "tips admin write" on public.tips;
create policy "tips admin write" on public.tips for all using (public.is_admin(auth.uid())) with check (public.is_admin(auth.uid()));
