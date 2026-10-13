-- TDE MASTER · esquema de base de datos en Supabase
-- Ejecutar completo en: Supabase → SQL Editor → New query → Run

create table if not exists public.proyectos (
  id            text primary key,
  negocio       text,
  plan          text,
  fecha         timestamptz,
  cerrado       boolean not null default false,
  fecha_cierre  timestamptz,
  valores       jsonb not null default '{}'::jsonb,   -- datos del formulario (texto, sin archivos)
  archivos      jsonb not null default '{}'::jsonb,   -- nombres y ubicación de logo, foto, archivos
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

-- Seguridad: activar RLS. Sin estas reglas, la clave pública no puede leer ni escribir.
alter table public.proyectos enable row level security;

-- Reglas TEMPORALES para que la app funcione con la clave pública (anon).
-- Cualquiera que tenga la URL y la clave puede leer y escribir: ver README antes de publicar.
create policy "proyectos_select_anon" on public.proyectos
  for select to anon using (true);

create policy "proyectos_insert_anon" on public.proyectos
  for insert to anon with check (true);

-- Un proyecto cerrado por MR TECH no se puede modificar ni borrar desde la app.
create policy "proyectos_update_anon" on public.proyectos
  for update to anon using (not cerrado) with check (true);

create policy "proyectos_delete_anon" on public.proyectos
  for delete to anon using (not cerrado);
