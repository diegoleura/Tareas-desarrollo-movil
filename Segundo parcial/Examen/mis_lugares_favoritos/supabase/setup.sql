-- Mis Lugares Favoritos

create extension if not exists pgcrypto;

create table if not exists public.places (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  category text not null default 'Otro',
  description text not null default '',
  latitude double precision not null,
  longitude double precision not null,
  photo_url text,
  photo_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.places enable row level security;

drop policy if exists "users can view their places" on public.places;
create policy "users can view their places"
on public.places for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "users can insert their places" on public.places;
create policy "users can insert their places"
on public.places for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "users can update their places" on public.places;
create policy "users can update their places"
on public.places for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "users can delete their places" on public.places;
create policy "users can delete their places"
on public.places for delete
to authenticated
using (auth.uid() = user_id);

-- Bucket para fotografías.
insert into storage.buckets (id, name, public)
values ('place_photos', 'place_photos', true)
on conflict (id) do update set public = true;

drop policy if exists "public can view place photos" on storage.objects;
create policy "public can view place photos"
on storage.objects for select
using (bucket_id = 'place_photos');

drop policy if exists "users can upload own place photos" on storage.objects;
create policy "users can upload own place photos"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'place_photos'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "users can update own place photos" on storage.objects;
create policy "users can update own place photos"
on storage.objects for update
to authenticated
using (
  bucket_id = 'place_photos'
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'place_photos'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "users can delete own place photos" on storage.objects;
create policy "users can delete own place photos"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'place_photos'
  and (storage.foldername(name))[1] = auth.uid()::text
);

create index if not exists places_user_id_idx on public.places(user_id);
create index if not exists places_category_idx on public.places(category);
