# Supabase · TDE MASTER

1. Crear un proyecto nuevo en Supabase (New project).
2. Abrir SQL Editor → New query, pegar `schema.sql` y ejecutar (Run).
3. Settings → API: copiar **Project URL** y la clave **anon public**.
   No copiar nunca la clave **service_role** en la app.
4. (Opcional, para logos, fotos y archivos) Storage → New bucket → nombre `tde-archivos`, dejarlo **privado**.

## Antes de publicar la app en Netlify

- Las reglas actuales dejan leer y escribir a quien tenga la clave pública.
  Antes de publicar con datos reales hay que reemplazarlas por autenticación (Supabase Auth)
  y reglas que limiten a MR TECH y al partner.
- Los datos guardados incluyen teléfonos y e-mails de clientes: tratarlos como información sensible.
