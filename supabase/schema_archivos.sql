-- TDE MASTER · archivos (logo, foto, PDF, imágenes) en Supabase Storage
-- Ejecutar DESPUÉS de schema.sql: SQL Editor → New query → Run

-- 1) Bucket privado para los archivos
insert into storage.buckets (id, name, public)
values ('tde-archivos', 'tde-archivos', false)
on conflict (id) do nothing;

-- 2) Registro de cada archivo, asociado a su proyecto
create table if not exists public.proyecto_archivos (
  id            bigint generated always as identity primary key,
  proyecto_id   text not null references public.proyectos(id) on delete cascade,
  campo         text not null,          -- f_logo, f_foto, f_pres_pdf, f_pres_img, f_cat_pdf, f_cat_img
  nombre        text not null,          -- nombre original del archivo
  tipo          text,                   -- tipo MIME
  tamano        bigint,                 -- bytes
  storage_path  text not null unique,   -- ruta dentro del bucket
  created_at    timestamptz not null default now()
);

alter table public.proyecto_archivos enable row level security;

-- Reglas TEMPORALES (clave pública). Ver README: reemplazar por Supabase Auth antes de publicar.
create policy "archivos_select_anon" on public.proyecto_archivos
  for select to anon using (true);
create policy "archivos_insert_anon" on public.proyecto_archivos
  for insert to anon with check (true);
create policy "archivos_update_anon" on public.proyecto_archivos
  for update to anon using (true) with check (true);
create policy "archivos_delete_anon" on public.proyecto_archivos
  for delete to anon
  using (exists (select 1 from public.proyectos p where p.id = proyecto_id and not p.cerrado));

-- 3) Permisos sobre los objetos del bucket tde-archivos
create policy "tde_objetos_select" on storage.objects
  for select to anon using (bucket_id = 'tde-archivos');
create policy "tde_objetos_insert" on storage.objects
  for insert to anon with check (bucket_id = 'tde-archivos');
create policy "tde_objetos_update" on storage.objects
  for update to anon using (bucket_id = 'tde-archivos') with check (bucket_id = 'tde-archivos');
create policy "tde_objetos_delete" on storage.objects
  for delete to anon using (bucket_id = 'tde-archivos');
