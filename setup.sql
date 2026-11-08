create table if not exists public.items(
  id bigint generated always as identity primary key,
  section text not null,
  title text not null,
  date_text text,
  body text,
  link_url text,
  image_url text,
  file_url text,
  file_name text,
  sort int default 0,
  created_at timestamptz default now()
);
alter table public.items enable row level security;
create policy "public read" on public.items for select using (true);
create policy "admin write" on public.items for all to authenticated using (true) with check (true);
insert into storage.buckets (id,name,public) values ('uploads','uploads',true) on conflict (id) do nothing;
create policy "public read uploads" on storage.objects for select using (bucket_id='uploads');
create policy "admin upload" on storage.objects for insert to authenticated with check (bucket_id='uploads');
create policy "admin update uploads" on storage.objects for update to authenticated using (bucket_id='uploads');
create policy "admin delete uploads" on storage.objects for delete to authenticated using (bucket_id='uploads');
