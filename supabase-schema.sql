-- ============================================================
-- Weekly Tracker — Supabase schema
-- Run this once in your Supabase project's SQL Editor
-- (Dashboard -> SQL Editor -> New query -> paste -> Run).
-- ============================================================

-- One row per user, holding their entire tracker state as JSON.
create table if not exists public.tracker_state (
  user_id     uuid primary key references auth.users(id) on delete cascade,
  state       jsonb not null,
  updated_at  timestamptz not null default now()
);

-- Turn on Row Level Security so users can only ever touch their own row.
alter table public.tracker_state enable row level security;

-- Allow a signed-in user to read their own row.
create policy "Users can read their own tracker state"
  on public.tracker_state
  for select
  using (auth.uid() = user_id);

-- Allow a signed-in user to insert their own row.
create policy "Users can insert their own tracker state"
  on public.tracker_state
  for insert
  with check (auth.uid() = user_id);

-- Allow a signed-in user to update their own row.
create policy "Users can update their own tracker state"
  on public.tracker_state
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- (Optional) allow a user to delete their own row, e.g. for a future
-- "delete my data" button. Safe to leave in even if unused.
create policy "Users can delete their own tracker state"
  on public.tracker_state
  for delete
  using (auth.uid() = user_id);
