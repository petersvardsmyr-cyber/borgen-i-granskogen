-- Vandrare (spelkaraktärer) för inloggade spelare.
-- Varje rad tillhör en användare, och radnivåsäkerhet (RLS) gör att man bara kan läsa och ändra sina egna.
create table if not exists public.characters (
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id text not null,
  name text not null check (char_length(name) between 1 and 28),
  data jsonb,
  created bigint,
  updated bigint,
  primary key (user_id, id)
);

alter table public.characters enable row level security;

create policy "Läsa egna vandrare" on public.characters
  for select to authenticated using ((select auth.uid()) = user_id);
create policy "Skapa egna vandrare" on public.characters
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Ändra egna vandrare" on public.characters
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "Ta bort egna vandrare" on public.characters
  for delete to authenticated using ((select auth.uid()) = user_id);
