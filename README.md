# AmeriK's Reading Corner

Bienvenido a *AmeriK's Reading Corner*, un blog donde comparto reseñas, recomendaciones y reflexiones sobre los libros que leo. Este proyecto está desarrollado usando [Astro](https://astro.build/), una herramienta moderna para crear sitios web rápidos y optimizados.

## Descripción

Este blog está enfocado en compartir las experiencias de lectura de los libros que más me han impactado. Cada entrada del blog ofrece una reseña detallada con información sobre el autor, sinopsis del libro, lo que más me gustó, lo que menos me gustó y si lo recomiendo o no.

Los posts están escritos en formato Markdown (`.md`), y cada entrada tiene un diseño limpio, con imágenes centradas y texto justificado para una mejor lectura.

Los libros están organizados por género, y cada entrada está etiquetada adecuadamente para facilitar la búsqueda y navegación.

## Añadir contenido

- Copia `src/templates/resena.md` a `src/pages/posts/` con un nombre nuevo y completa sus metadatos y secciones. `genre` indica un único género principal para las estadísticas; `tags` contiene todas las etiquetas de navegación. Las fechas se escriben como `AAAA-MM-DD`.
- Los datos preparados en `src/data/currently-reading.json` se conservan para una futura sección de lecturas actuales.
- El archivo por años utiliza la fecha de publicación de cada reseña. Las estadísticas reflejan únicamente las reseñas publicadas, no todas las lecturas registradas en Notion.
- El objetivo de Goodreads, las estadísticas de páginas y el envío de recomendaciones están pendientes de conectar a sus fuentes de datos.
- La página «Nosotros» muestra las recomendaciones registradas en `src/data/recommendations.json`. Cada elemento usa `title`, `author`, `description` y `recommendedBy`; la lista está vacía hasta disponer de recomendaciones reales.
- Los campos opcionales `tears` y `spice` de una reseña usan una escala de 0 a 5 para el mapa emocional. Si no se indican, se muestran como «Sin registrar».

Para desarrollar localmente, ejecuta `npm install` y después `npm run dev`. Para comprobar la compilación, ejecuta `npm run build`.

## Panel privado (pendiente)

Hay una base SQL **parcial y no aplicada** para Supabase en [`supabase/README.md`](supabase/README.md). Todavía no existen el panel, la subida de portadas ni la integración con las páginas públicas; las reseñas y lecturas locales siguen siendo la fuente actual.

## Identidad visual

La paleta Retro Bookstore y las fuentes Fraunces y DM Sans se configuran en `src/styles/global.css`. Los colores base de ambos temas se mantienen como variables CSS; los colores de texto secundarios y de acento tienen variantes derivadas para mejorar su contraste. El selector existente guarda la preferencia en el navegador.

## Desplegado

El blog está desplegado en [Netlify](https://www.netlify.com/), lo que permite una carga rápida y eficiente de las páginas. Puedes acceder al blog a través del siguiente enlace:

**[Visita el blog aquí](https://amerikg-blog.netlify.app/)**
