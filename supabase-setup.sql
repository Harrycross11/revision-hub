-- Revision Hub cloud saving: paste all of this into Supabase > SQL Editor > New query, then press Run.
-- One row per account holding its progress. Row Level Security means each signed-in user
-- can only ever read and write their own row, so the public key in the website is safe.
create table if not exists public.revision_hub (
  user_id uuid primary key references auth.users (id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.revision_hub enable row level security;
drop policy if exists "Own progress only" on public.revision_hub;
create policy "Own progress only" on public.revision_hub
  for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
grant select, insert, update, delete on public.revision_hub to authenticated;
revoke all on public.revision_hub from anon;
