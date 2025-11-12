alter table public.users add column if not exists is_admin boolean default false;

create or replace function public.is_admin(u uuid)
returns boolean language sql stable as $$
  select coalesce((select is_admin from public.users where id = u), false);
$$;

drop policy if exists "users self select" on public.users;
create policy "users self select" on public.users for select using (auth.uid() = id or public.is_admin(auth.uid()));
drop policy if exists "users self update" on public.users;
create policy "users self update" on public.users for update using (auth.uid() = id or public.is_admin(auth.uid()));
drop policy if exists "users insert self" on public.users;
create policy "users insert self" on public.users for insert with check (auth.uid() = id or public.is_admin(auth.uid()));

drop policy if exists "logs owner select" on public.logs;
create policy "logs owner select" on public.logs for select using (uid = auth.uid() or public.is_admin(auth.uid()));
drop policy if exists "logs owner insert" on public.logs;
create policy "logs owner insert" on public.logs for insert with check (uid = auth.uid() or public.is_admin(auth.uid()));
drop policy if exists "logs owner update" on public.logs;
create policy "logs owner update" on public.logs for update using (uid = auth.uid() or public.is_admin(auth.uid()));
drop policy if exists "logs owner delete" on public.logs;
create policy "logs owner delete" on public.logs for delete using (uid = auth.uid() or public.is_admin(auth.uid()));

drop policy if exists "participants owner select" on public.participants;
create policy "participants owner select" on public.participants for select using (uid = auth.uid() or public.is_admin(auth.uid()));
drop policy if exists "participants owner insert" on public.participants;
create policy "participants owner insert" on public.participants for insert with check (uid = auth.uid() or public.is_admin(auth.uid()));

create or replace view public.leaderboard_full as
select u.id, coalesce(u.name, u.email) as name, coalesce(u.eco_points,0) as points
from public.users u
order by points desc, name asc;

create or replace function public.complete_challenge(p_uid uuid, p_challenge uuid, p_points int default 50)
returns void language plpgsql security definer as $$
begin
  update public.participants set progress = 100 where uid = p_uid and challenge_id = p_challenge;
  perform public.add_points(p_uid, p_points);
  perform public.add_badge(p_uid, 'Completed challenge '||p_challenge);
end;
$$;
grant execute on function public.complete_challenge(uuid,uuid,int) to anon, authenticated;
