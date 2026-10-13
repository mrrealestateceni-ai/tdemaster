-- TDE MASTER · estructura completa en Supabase (tablas, permisos y bucket de archivos)
-- Se puede ejecutar más de una vez. SQL Editor → New query → Run

-- ===== 1) Tabla de proyectos =====
create table if not exists public.proyectos (
  id            text primary key,
  negocio       text,
  plan          text,
  fecha         timestamptz,
  cerrado       boolean not null default false,
  fecha_cierre  timestamptz,
  valores       jsonb not null default '{}'::jsonb,
  archivos      jsonb not null default '{}'::jsonb,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

create or replace function public.tde_set_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists proyectos_updated_at on public.proyectos;
create trigger proyectos_updated_at
  before update on public.proyectos
  for each row execute function public.tde_set_updated_at();

alter table public.proyectos enable row level security;

drop policy if exists "proyectos_select_anon" on public.proyectos;
drop policy if exists "proyectos_insert_anon" on public.proyectos;
drop policy if exists "proyectos_update_anon" on public.proyectos;
drop policy if exists "proyectos_delete_anon" on public.proyectos;

create policy "proyectos_select_anon" on public.proyectos
  for select to anon using (true);
create policy "proyectos_insert_anon" on public.proyectos
  for insert to anon with check (true);
create policy "proyectos_update_anon" on public.proyectos
  for update to anon using (not cerrado) with check (true);
create policy "proyectos_delete_anon" on public.proyectos
  for delete to anon using (not cerrado);

-- ===== 2) Tabla de archivos del proyecto =====
create table if not exists public.proyecto_archivos (
  id            bigint generated always as identity primary key,
  proyecto_id   text not null references public.proyectos(id) on delete cascade,
  campo         text not null,
  nombre        text not null,
  tipo          text,
  tamano        bigint,
  storage_path  text not null unique,
  created_at    timestamptz not null default now()
);

alter table public.proyecto_archivos enable row level security;

drop policy if exists "archivos_select_anon" on public.proyecto_archivos;
drop policy if exists "archivos_insert_anon" on public.proyecto_archivos;
drop policy if exists "archivos_update_anon" on public.proyecto_archivos;
drop policy if exists "archivos_delete_anon" on public.proyecto_archivos;

create policy "archivos_select_anon" on public.proyecto_archivos
  for select to anon using (true);
create policy "archivos_insert_anon" on public.proyecto_archivos
  for insert to anon with check (true);
create policy "archivos_update_anon" on public.proyecto_archivos
  for update to anon using (true) with check (true);
create policy "archivos_delete_anon" on public.proyecto_archivos
  for delete to anon
  using (exists (select 1 from public.proyectos p where p.id = proyecto_id and not p.cerrado));

-- ===== 3) Bucket privado para logos, fotos y archivos =====
insert into storage.buckets (id, name, public)
values ('tde-archivos', 'tde-archivos', false)
on conflict (id) do nothing;

drop policy if exists "tde_objetos_select" on storage.objects;
drop policy if exists "tde_objetos_insert" on storage.objects;
drop policy if exists "tde_objetos_update" on storage.objects;
drop policy if exists "tde_objetos_delete" on storage.objects;

create policy "tde_objetos_select" on storage.objects
  for select to anon using (bucket_id = 'tde-archivos');
create policy "tde_objetos_insert" on storage.objects
  for insert to anon with check (bucket_id = 'tde-archivos');
create policy "tde_objetos_update" on storage.objects
  for update to anon using (bucket_id = 'tde-archivos') with check (bucket_id = 'tde-archivos');
create policy "tde_objetos_delete" on storage.objects
  for delete to anon using (bucket_id = 'tde-archivos');

-- ===== 4) Verificación (el resultado tiene que mostrar las dos tablas y el bucket) =====
select 'tabla' as tipo, table_name as nombre from information_schema.tables
  where table_schema = 'public' and table_name in ('proyectos','proyecto_archivos')
union all
select 'bucket', id from storage.buckets where id = 'tde-archivos';
