-- Jalankan di Supabase Dashboard > SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  role text not null check (role in ('supplier','utilizer')),
  created_at timestamptz not null default now()
);
create table if not exists public.waste_listings (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid not null references public.profiles(id) on delete cascade,
  waste_type text not null,
  quantity_kg numeric(10,2) not null check (quantity_kg > 0),
  condition text not null,
  location text not null,
  description text not null default '',
  photo_url text,
  status text not null default 'available' check (status in ('available','reserved','completed')),
  created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
alter table public.waste_listings enable row level security;
drop policy if exists "read own profile" on public.profiles;
create policy "read own profile" on public.profiles for select to authenticated using (id = auth.uid());
drop policy if exists "insert own profile" on public.profiles;
create policy "insert own profile" on public.profiles for insert to authenticated with check (id = auth.uid());
drop policy if exists "update own profile" on public.profiles;
create policy "update own profile" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
drop policy if exists "read listings" on public.waste_listings;
create policy "read listings" on public.waste_listings for select to authenticated using (status = 'available' or supplier_id = auth.uid());
drop policy if exists "supplier creates listing" on public.waste_listings;
create policy "supplier creates listing" on public.waste_listings for insert to authenticated with check (supplier_id = auth.uid() and exists(select 1 from public.profiles p where p.id = auth.uid() and p.role = 'supplier'));
drop policy if exists "supplier updates own listing" on public.waste_listings;
create policy "supplier updates own listing" on public.waste_listings for update to authenticated using (supplier_id = auth.uid()) with check (supplier_id = auth.uid());
drop policy if exists "supplier deletes own listing" on public.waste_listings;
create policy "supplier deletes own listing" on public.waste_listings for delete to authenticated using (supplier_id = auth.uid());
-- Buat bucket publik untuk foto. Batasi upload ke folder bernama user ID.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('waste-photos','waste-photos',true,5242880,array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
drop policy if exists "public reads waste photos" on storage.objects;
create policy "public reads waste photos" on storage.objects for select using (bucket_id = 'waste-photos');
drop policy if exists "users upload own waste photos" on storage.objects;
create policy "users upload own waste photos" on storage.objects for insert to authenticated with check (bucket_id = 'waste-photos' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "users delete own waste photos" on storage.objects;
create policy "users delete own waste photos" on storage.objects for delete to authenticated using (bucket_id = 'waste-photos' and (storage.foldername(name))[1] = auth.uid()::text);
-- Profil otomatis dibuat saat pendaftaran. Role dan nama diambil dari metadata pendaftaran.
create or replace function public.handle_new_user() returns trigger language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, full_name, role)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name',''),
    case when new.raw_user_meta_data->>'role' = 'utilizer' then 'utilizer' else 'supplier' end);
  return new;
end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
