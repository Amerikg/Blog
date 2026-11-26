import rss, { pagesGlobToRssItems } from '@astrojs/rss';

export async function GET(context) {
  return rss({
    title: "Amerik's Reading Corner",
    description: 'Reseñas, recomendaciones y reflexiones sobre libros.',
    site: context.site,
    items: await pagesGlobToRssItems(import.meta.glob('./**/*.md')),
    customData: `<language>es-MX</language>`,
  });
}