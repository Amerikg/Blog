# AmeriK's Reading Corner

Bienvenido a *AmeriK's Reading Corner*, un blog donde comparto reseñas, recomendaciones y reflexiones sobre los libros que leo. Este proyecto está desarrollado usando [Astro](https://astro.build/), una herramienta moderna para crear sitios web rápidos y optimizados.

## Descripción

Este blog está enfocado en compartir experiencias de lectura de los libros que más me han impactado.

El panel privado permite administrar lecturas actuales y guardar borradores de reseñas. La publicación de reseñas en el sitio público todavía está pendiente de integración.

## Añadir contenido

- Usa `/admin` para iniciar sesión y gestionar lecturas y borradores. La portada puede ser una URL o una imagen subida; las reseñas también permiten imágenes de contexto.
- Los originales de las cinco reseñas importadas se conservan en `src/data/legacy-reviews/`. No están publicados desde esos archivos.
- El inicio consulta las lecturas actuales en Supabase. Los datos anteriores de `src/data/currently-reading.json` se conservan como referencia y no se importan automáticamente.
- La integración de las reseñas publicadas con el archivo, las estadísticas y el RSS está pendiente.
- El objetivo de Goodreads, las estadísticas de páginas y el envío de recomendaciones están pendientes de conectar a sus fuentes de datos.
- La página «Nosotros» muestra las recomendaciones registradas en `src/data/recommendations.json`. Cada elemento usa `title`, `author`, `description` y `recommendedBy`; la lista está vacía hasta disponer de recomendaciones reales.
- Las puntuaciones opcionales de estrellas, lágrimas y picante usan una escala de 0 a 5.

Para desarrollar localmente, ejecuta `npm install` y después `npm run dev`. Para comprobar la compilación, ejecuta `npm run build`.

## Panel privado

El panel usa Supabase para el acceso, las lecturas actuales y los borradores. Consulta [`supabase/README.md`](supabase/README.md) para conocer la configuración, los scripts y las limitaciones pendientes. Publicar una reseña desde el panel todavía no está disponible.

## Identidad visual

La paleta Retro Bookstore y las fuentes Fraunces y DM Sans se configuran en `src/styles/global.css`. Los colores base de ambos temas se mantienen como variables CSS; los colores de texto secundarios y de acento tienen variantes derivadas para mejorar su contraste. El selector existente guarda la preferencia en el navegador.

## Desplegado

El blog está desplegado en [Netlify](https://www.netlify.com/), lo que permite una carga rápida y eficiente de las páginas. Puedes acceder al blog a través del siguiente enlace:

**[Visita el blog aquí](https://amerikg-blog.netlify.app/)**
