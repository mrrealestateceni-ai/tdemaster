# TDE MASTER · Formulario en Netlify

Sitio estático de una sola página (`index.html`). No requiere build.

## Contenido

- `index.html`: Formulario TDE, pantalla DATA TDE MASTER y envíos por WhatsApp / E-Mail. Todo va en un solo archivo, con los logos incrustados.
- `netlify.toml`: configuración de publicación y cabeceras de seguridad básicas.

## Publicar en Netlify (sin GitHub)

1. Entrar a https://app.netlify.com y elegir **Add new project → Deploy manually**.
2. Arrastrar la carpeta `netlify-tde` (o el ZIP descomprimido) a la zona de carga.
3. Netlify asigna una URL pública (por ejemplo `tu-sitio.netlify.app`). Para usar un dominio propio, ir a **Domain management**.

## Publicar con GitHub (opcional)

1. Crear un repositorio y subir el contenido de esta carpeta.
2. En Netlify, **Add new project → Import an existing project** y elegir el repositorio.
3. Dejar el comando de build vacío y la carpeta de publicación en `.` (ya está en `netlify.toml`).

## Acceso

- La primera pantalla es **ACCESO CIFRADO TDE MASTER** (usuario y clave, distinguen mayúsculas y minúsculas). Tres intentos fallidos bloquean el ingreso por 120 s, 240 s, 360 s, y así sucesivamente.
- Las claves se guardan como hash SHA-256 con sal dentro de `index.html`. No aparecen en texto plano.
- **Limitación:** el control es del lado del navegador. Para que la página sea privada de verdad, activar protección en Netlify (plan de pago) o usar Netlify Identity.

## Antes de publicar: puntos a definir

- **Datos en la nube**: hoy los proyectos se guardan en el navegador (IndexedDB), por lo que quedan solo en ese equipo. Para que estén disponibles desde cualquier lugar hace falta una base de datos en la nube (por ejemplo, Firebase Firestore, según lo planificado para el panel TDE MASTER).
- **Logos**: están incrustados en el HTML. Si cambian, reemplazar las imágenes dentro de `index.html`.

## Verificación rápida tras publicar

1. Abrir la URL y completar el formulario de prueba.
2. Tocar **GENERAR** y confirmar que se abre DATA TDE MASTER.
3. Descargar **DESCARGA TDE FULL** y revisar que el ZIP tenga ficha, formulario, logo, foto y archivos.
