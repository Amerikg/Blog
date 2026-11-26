# Base para el panel de lecturas

**Estado: implementación parcial; el panel permite administrar lecturas y reseñas,
pero las reseñas aún no están conectadas a las vistas públicas.**
La migración inicial se aplicó al proyecto de este blog y la usuaria
ejecutó `verify_foundation.sql` correctamente. No cambia, importa ni elimina
los Markdown o las lecturas locales existentes. Los nuevos scripts de Storage
requieren configuración y verificación por separado.

## Qué prepara la migración

`migrations/20261125100000_blog_foundation.sql` crea:

* `blog_private.administrator`, con una sola fila que identifica al administrador
  por su UUID de Auth; no concede acceso a todos los usuarios autenticados.
* `public.blog_readings`, privada para ese administrador, y
  `public.blog_reviews`, cuya política de lectura pública solo permite reseñas
  con `published = true`. El administrador también puede leer y editar borradores.
* `public.blog_finish_reading(reading_uuid, review_slug, finished_date)`, que
  bloquea la lectura y, en una misma transacción, crea una reseña en borrador y
  la marca terminada. Un slug duplicado, fecha inválida o segunda finalización
  revierte la operación. Publicar es una operación independiente.

Para configurar el administrador después de aplicar y verificar la migración,
un propietario del proyecto debe crear o identificar manualmente la cuenta en
Supabase Auth y ejecutar en el SQL Editor, reemplazando el marcador por su UUID:

```sql
insert into blog_private.administrator (user_id)
values ('UUID-DEL-USUARIO-ADMINISTRADOR'::uuid);
```

La tabla no se expone a los clientes. Para cambiar el administrador, un
propietario debe actualizar esa fila desde el SQL Editor. Sin ella nadie tiene
acceso administrativo. Deshabilitar el registro público en Auth es recomendable,
pero no sustituye a las políticas. La clave pública de Supabase puede usarse en
el navegador; **nunca** se debe incorporar la clave `service_role`, contraseñas
ni el token del deploy hook al código cliente o al repositorio.

## Portadas privadas

En Storage crea un bucket llamado `blog-covers` **privado**, con límite de 5 MiB
(5242880 bytes) y tipos MIME `image/jpeg`, `image/png` e `image/webp`. Crea y
configura el bucket mediante el panel o la API de Storage, no modificando sus
registros con SQL. Después ejecuta `migrations/20261125110000_cover_storage_policies.sql`
en SQL Editor y comprueba la configuración con `verify_cover_storage.sql`.
Revisa también que no existan otras políticas de Storage que concedan acceso
al bucket: las políticas permisivas se combinan.

Las políticas permiten únicamente a la administradora subir, consultar,
actualizar y borrar archivos de este bucket. El límite y el tipo declarado no
demuestran que el contenido sea realmente una imagen: la integración de subida
debe validar el contenido y gestionar archivos que ya no se utilicen. Verificar
la configuración SQL no sustituye las pruebas reales de subida y descarga con
sesiones anónimas, administradora y otra cuenta.

Las portadas subidas permanecerán privadas. Todavía no existe el mecanismo para
exponer las de reseñas publicadas; debe implementarse al conectar el sitio público.
Las portadas de lecturas actuales se pueden consultar públicamente mientras
estén asociadas a una lectura activa, mediante la política de la migración de
lecturas actuales. Una imagen ya descargada o almacenada en caché puede persistir
después de terminar la lectura. Las URL externas HTTP(S) siguen siendo una opción,
pero su privacidad depende del servidor externo y pueden desaparecer o rastrear
visitantes.

## Lecturas actuales

Ejecuta `migrations/20261125130000_current_readings.sql` y después
`verify_current_readings.sql` en SQL Editor. Después de iniciar sesión en `/admin`,
el panel redirige a `/admin/lecturas-actuales`. Allí puedes crear o editar lecturas,
vincular una portada o subir una imagen de hasta 5 MiB. Para terminar una lectura,
elige «Terminado», selecciona la fecha y confirma «Crear borrador»: la lectura se
marca terminada y el borrador se crea en una sola transacción. El borrador se
editará en una etapa posterior.

Para guardar los datos adicionales, ejecuta una sola vez
`migrations/20261125140000_reading_details.sql` y después
`verify_reading_details.sql` en SQL Editor. El formulario requiere título, autor,
portada, fecha de inicio, género, número de páginas y descripción, tanto al crear
como al editar. Las lecturas existentes no se borran ni se modifican; si les faltan
datos, tendrás que completarlos al editarlas. El género, las páginas y la descripción
se copian al borrador al terminar la lectura.

Para el carrusel del inicio, ejecuta una sola vez
`migrations/20261125150000_current_readings_hero.sql` y después
`verify_current_readings_hero.sql`. El inicio consulta las lecturas activas al
abrirse y permite recorrerlas con botones, de la más reciente a la más antigua.
Sus títulos, autores, descripciones y portadas son públicos; los borradores no lo son.
La función anterior se conserva para no romper consumidores existentes. Hasta
aplicar la nueva migración el carrusel mostrará un error de carga.
Las lecturas de `src/data/currently-reading.json` no se importan automáticamente:
añádelas desde el panel si todavía están en curso. Las portadas reemplazadas
pueden quedar sin uso en Storage y requieren limpieza manual tras comprobar
que no están asociadas a otras lecturas o reseñas.

## Acceso al panel

Ejecuta `migrations/20261125120000_admin_access.sql` una sola vez en el SQL Editor.
Después ejecuta `verify_admin_access.sql` para comprobar los roles sin conservar
cambios.
Después inicia el sitio con `npm run dev` y abre `/admin`. Usa la cuenta creada en
Supabase Auth; el formulario no permite crear cuentas. El panel verifica la sesión
contra `blog_is_administrator`, pero la seguridad de los datos sigue dependiendo
de las políticas RLS de Supabase, no de ocultar controles en el navegador.

Configura `PUBLIC_SUPABASE_URL` y `PUBLIC_SUPABASE_ANON_KEY` en `.env` local y,
cuando corresponda, en Netlify antes de compilar. Solo usa la clave publicable
o `anon`, nunca `service_role` ni contraseñas. La usuaria confirmó el acceso con su cuenta real;
los casos de otra cuenta y visitante anónimo se verificaron con el script SQL,
y la interfaz se probó también con respuestas simuladas.

## Gestión de reseñas

En `/admin/resenas` se pueden crear borradores independientes, editar los
borradores generados al terminar una lectura y eliminar borradores tras confirmar.
Los formularios para crear y editar lecturas y reseñas se abren en páginas
independientes; al guardar o cancelar se vuelve al listado correspondiente.
Eliminar un borrador no elimina la lectura terminada ni sus imágenes. El editor
usa un campo de opinión para todos los borradores. Al abrir una reseña con el
formato anterior se extrae su opinión y, al guardarla, las demás secciones dejan
de formar parte del contenido. Las imágenes HTML reconocidas dentro de la opinión
se pasan a imágenes de contexto. Si el formato no se reconoce, se conserva todo
el contenido en el campo para que pueda revisarse manualmente. El respaldo
`original_source` de las cinco reseñas importadas no se modifica.

Las imágenes de contexto se guardan en `extra_frontmatter.context_images`; los
archivos se suben al bucket privado `blog-covers`. Su publicación y acceso público
deben implementarse al conectar el sitio público; no basta con guardar la reseña.
La vista previa privada muestra texto sin interpretar Markdown ni HTML. La
edición comprueba la última actualización para evitar sobrescribir cambios de
otra sesión. Las imágenes sustituidas o eliminadas pueden quedar sin uso en
Storage y requieren revisión y limpieza manual.

Esta etapa no permite publicar. Las cinco reseñas Markdown existentes se
importaron como borradores mediante `import_existing_reviews.sql` y se verificaron
con `verify_import_existing_reviews.sql`; sus originales se conservan en
`src/data/legacy-reviews/`, fuera de las rutas públicas de Astro.
No ejecutes la importación nuevamente: se detiene si encuentra una colisión.
Si ya hay reseñas publicadas en la base, sus cambios pueden consultarse mediante
la API pública. Las páginas, el RSS y los índices todavía no están conectados a
Supabase y no muestran esos borradores. En la compilación actual, sus antiguas
rutas dejan de generarse; para restablecerlas al publicar habrá que conectar la
integración pública. Las versiones ya desplegadas, los despliegues anteriores y
las cachés pueden seguir mostrando las reseñas hasta su actualización.

## Trabajo pendiente antes de usarlo

1. Verificar la gestión de reseñas con la cuenta real y los permisos con usuarios
   anónimos y otro usuario autenticado, incluyendo llamadas directas a la API,
   concurrencia y fallos.
2. Completar la integración de Storage: validar el contenido real de imágenes,
   usar nombres seguros, gestionar archivos no utilizados y habilitar acceso
   público únicamente cuando corresponda. No confiar solo en la extensión o MIME.
3. Al conectar la publicación, restablecer las rutas originales
   `/posts/post-1` a `/posts/post-5` de las reseñas importadas, sin exponer
   borradores y sin perder metadatos ni contenido.
4. Conectar **todas** las vistas públicas, filtros, tags, años, autores,
   estadísticas y RSS a la misma fuente de reseñas publicadas, y generar rutas
   para nuevas reseñas. En el estado actual todo sigue usando los Markdown
   locales: publicar en la tabla no actualizará el sitio.
5. El Markdown actual contiene HTML. Conservar el original para edición, pero
   sanitizar el HTML *después* de renderizarlo con una lista permitida y validar
   URL y atributos antes de mostrarlo; bloquear scripts, eventos, estilos y
   protocolos peligrosos. La salida sanitizada podría no verse idéntica al
   HTML original. No insertar Markdown/HTML sin sanitizar en el DOM.

## Limitación de Astro estático

Netlify sirve archivos generados, no consulta automáticamente Supabase en cada
visita. Una opción compatible es consultar únicamente publicaciones durante
cada build y disparar un nuevo deploy tras publicar, editar o retirar una
reseña. El disparador debe protegerse en un componente de confianza, no en el
navegador. Un build fallido o en curso deja publicada la versión anterior:
retirar una publicación **no la oculta inmediatamente**, y también pueden
persistir copias en cachés o deploys antiguos. Para retirada inmediata se
requiere otra arquitectura de entrega dinámica y tratamiento de cachés. Nunca
se deben incluir borradores en los archivos generados, RSS ni índices públicos.

La usuaria confirmó que aplicó las políticas de Storage y ejecutó la
verificación de configuración correctamente. Siguen pendientes las pruebas
de subida y descarga con archivos y sesiones reales, la revisión de otras
políticas aplicables y la configuración de publicación en Netlify.
