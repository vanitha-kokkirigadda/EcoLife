alter table public.users enable row level security;
alter table public.logs enable row level security;
alter table public.participants enable row level security;
alter table public.tips enable row level security;
alter table public.challenges enable row level security;
alter table public.stores enable row level security;

create policy if not exists "users self select" on public.users for select using (auth.uid() = id);
create policy if not exists "users self update" on public.users for update using (auth.uid() = id);
create policy if not exists "users insert self" on public.users for insert with check (auth.uid() = id);

create policy if not exists "logs owner select" on public.logs for select using (auth.uid() = uid);
create policy if not exists "logs owner insert" on public.logs for insert with check (auth.uid() = uid);
create policy if not exists "logs owner update" on public.logs for update using (auth.uid() = uid);
create policy if not exists "logs owner delete" on public.logs for delete using (auth.uid() = uid);

create policy if not exists "participants owner select" on public.participants for select using (auth.uid() = uid);
create policy if not exists "participants owner insert" on public.participants for insert with check (auth.uid() = uid);

create policy if not exists "tips public read" on public.tips for select using (true);
create policy if not exists "challenges public read" on public.challenges for select using (true);
create policy if not exists "stores public read" on public.stores for select using (true);

create or replace function public.add_points(p_uid uuid, p_points int)
returns void language sql security definer as $$
  update public.users set eco_points = coalesce(eco_points,0) + p_points where id = p_uid;
$$;

create or replace function public.add_badge(p_uid uuid, p_badge text)
returns void language sql security definer as $$
  update public.users set badges = array_append(coalesce(badges,'{}'::text[]), p_badge) where id = p_uid;
$$;

grant execute on function add_points(uuid,int) to anon, authenticated;
grant execute on function add_badge(uuid,text) to anon, authenticated;
