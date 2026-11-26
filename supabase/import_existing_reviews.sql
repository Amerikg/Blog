-- Importa las cinco reseñas como borradores. No sobrescribe reseñas existentes.
-- Ejecutar como propietario en SQL Editor después de las migraciones anteriores.
begin;

do $import$
declare
  payload jsonb := $import_data$[
  {
    "slug": "post-1",
    "title": "Carry On - Rainbow Rowell",
    "book_author": "Rainbow Rowell",
    "author": "Amerik",
    "description": "Reseña de Carry On, una historia de magia, romance y aventura",
    "genre": "Fantasía",
    "tags": [
      "Fantasía",
      "LGBTQ+",
      "Romance",
      "Magia"
    ],
    "rating": 4,
    "published_on": "2025-01-18",
    "read_start": "2025-01-01",
    "read_end": "2025-01-17",
    "cover_url": "https://m.media-amazon.com/images/I/91Myz5AWueL._SL1500_.jpg",
    "cover_alt": "Portada del libro Carry On de Rainbow Rowell",
    "body_markdown": "<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n\"Carry On\" es una novela de fantasía escrita por Rainbow Rowell y publicada en 2015. Es un spin-off de \"Fangirl\" y cuenta la historia de Simon Snow, un mago destinado a ser el elegido, aunque no está muy seguro de cómo lograrlo. Con una ambientación similar a la de los libros de magia más icónicos, Rowell nos sumerge en un mundo lleno de hechizos, criaturas mágicas y una historia de amor inesperada.\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\nSimon Snow es el mago más poderoso que el Mundo de los Magos ha conocido, pero también el peor en controlar su propia magia. Está en su último año en la Escuela de Magia Watford y, como de costumbre, las cosas no van bien. Su mentor, el Hechicero, está distante, su novia lo ha dejado y su compañero de cuarto y archienemigo, Baz, no ha aparecido en la escuela. Pero cuando Baz finalmente regresa, Simon empieza a darse cuenta de que su relación es mucho más complicada de lo que pensaba.\r\n\r\n\r\n\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Opinion Personal\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/db/4e/80/db4e807074ef1f941e804cc27055ec0e.jpg\" alt=\"Portada\" width=\"200\" style=\"float: left; margin-right: 25px;\">\r\n<br>\r\nUno de los aspectos más destacados de \"Carry On\" es cómo Rainbow Rowell juega con los clichés del género de fantasía y los transforma en algo fresco y entretenido. Aunque la historia comienza como una sátira del clásico \"elegido\", poco a poco desarrolla su propia identidad.\r\n</div>\r\n\r\n<div style=\"display: flex; gap:20px; margin-top: 60px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- La química entre Simon y Baz. Su relación es el corazón de la historia y se desarrolla de una manera natural y adictiva.\r\n- El sistema de magia basado en frases populares y expresiones comunes. Es un concepto creativo y diferente a lo habitual en las historias de magos.\r\n- Los personajes secundarios, como Penelope y Agatha, que agregan dinamismo a la trama.\r\n\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- La primera parte del libro puede sentirse un poco lenta, especialmente porque la historia tarda en arrancar.\r\n- Algunos aspectos del mundo mágico podrían haber sido más desarrollados.\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div>\r\n\r\nSí, especialmente si te gustan las historias de magia con un toque de romance y humor. \"Carry On\" es una lectura ligera pero con personajes entrañables y una historia emocionante. Si disfrutaste \"Fangirl\" o eres fan del género fantasy, definitivamente vale la pena darle una oportunidad.\r\n\r\n</div>",
    "extra_frontmatter": {
      "original_frontmatter": {
        "layout": "../../layouts/MarkdownPostLayout.astro",
        "title": "Carry On - Rainbow Rowell",
        "pubDate": "2025-01-18",
        "description": "Reseña de Carry On, una historia de magia, romance y aventura",
        "author": "Amerik",
        "bookAuthor": "Rainbow Rowell",
        "genre": "Fantasía",
        "rating": 4,
        "readStart": "2025-01-01",
        "readEnd": "2025-01-17",
        "image": {
          "url": "https://m.media-amazon.com/images/I/91Myz5AWueL._SL1500_.jpg",
          "alt": "Portada del libro Carry On de Rainbow Rowell"
        },
        "tags": [
          "Fantasía",
          "LGBTQ+",
          "Romance",
          "Magia"
        ]
      },
      "original_source": "---\r\nlayout: ../../layouts/MarkdownPostLayout.astro\r\ntitle: 'Carry On - Rainbow Rowell'\r\npubDate: 2025-01-18\r\ndescription: 'Reseña de Carry On, una historia de magia, romance y aventura'\r\nauthor: 'Amerik'\r\nbookAuthor: 'Rainbow Rowell'\r\ngenre: 'Fantasía'\r\nrating: 4\r\nreadStart: 2025-01-01\r\nreadEnd: 2025-01-17\r\nimage:\r\n    url: 'https://m.media-amazon.com/images/I/91Myz5AWueL._SL1500_.jpg'\r\n    alt: 'Portada del libro Carry On de Rainbow Rowell'\r\ntags: [\"Fantasía\", \"LGBTQ+\", \"Romance\", \"Magia\"]\r\n---\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n\"Carry On\" es una novela de fantasía escrita por Rainbow Rowell y publicada en 2015. Es un spin-off de \"Fangirl\" y cuenta la historia de Simon Snow, un mago destinado a ser el elegido, aunque no está muy seguro de cómo lograrlo. Con una ambientación similar a la de los libros de magia más icónicos, Rowell nos sumerge en un mundo lleno de hechizos, criaturas mágicas y una historia de amor inesperada.\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\nSimon Snow es el mago más poderoso que el Mundo de los Magos ha conocido, pero también el peor en controlar su propia magia. Está en su último año en la Escuela de Magia Watford y, como de costumbre, las cosas no van bien. Su mentor, el Hechicero, está distante, su novia lo ha dejado y su compañero de cuarto y archienemigo, Baz, no ha aparecido en la escuela. Pero cuando Baz finalmente regresa, Simon empieza a darse cuenta de que su relación es mucho más complicada de lo que pensaba.\r\n\r\n\r\n\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Opinion Personal\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/db/4e/80/db4e807074ef1f941e804cc27055ec0e.jpg\" alt=\"Portada\" width=\"200\" style=\"float: left; margin-right: 25px;\">\r\n<br>\r\nUno de los aspectos más destacados de \"Carry On\" es cómo Rainbow Rowell juega con los clichés del género de fantasía y los transforma en algo fresco y entretenido. Aunque la historia comienza como una sátira del clásico \"elegido\", poco a poco desarrolla su propia identidad.\r\n</div>\r\n\r\n<div style=\"display: flex; gap:20px; margin-top: 60px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- La química entre Simon y Baz. Su relación es el corazón de la historia y se desarrolla de una manera natural y adictiva.\r\n- El sistema de magia basado en frases populares y expresiones comunes. Es un concepto creativo y diferente a lo habitual en las historias de magos.\r\n- Los personajes secundarios, como Penelope y Agatha, que agregan dinamismo a la trama.\r\n\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- La primera parte del libro puede sentirse un poco lenta, especialmente porque la historia tarda en arrancar.\r\n- Algunos aspectos del mundo mágico podrían haber sido más desarrollados.\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div>\r\n\r\nSí, especialmente si te gustan las historias de magia con un toque de romance y humor. \"Carry On\" es una lectura ligera pero con personajes entrañables y una historia emocionante. Si disfrutaste \"Fangirl\" o eres fan del género fantasy, definitivamente vale la pena darle una oportunidad.\r\n\r\n</div>"
    }
  },
  {
    "slug": "post-2",
    "title": "Wayward Son - Rainbow Rowell",
    "book_author": "Rainbow Rowell",
    "author": "Amerik",
    "description": "Reseña de Wayward Son, la secuela de Carry On que nos lleva a una aventura inesperada",
    "genre": "Fantasía",
    "tags": [
      "Fantasía",
      "LGBTQ+",
      "Romance",
      "Aventura"
    ],
    "rating": 5,
    "published_on": "2025-02-26",
    "read_start": "2025-02-18",
    "read_end": "2025-02-25",
    "cover_url": "https://m.media-amazon.com/images/I/91yfdNcfFNL._SL1500_.jpg",
    "cover_alt": "Portada del libro Wayward Son de Rainbow Rowell",
    "body_markdown": "\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*\"Wayward Son\"* es la segunda parte de la trilogía de Simon Snow, escrita por Rainbow Rowell. Publicada en 2019, esta secuela nos muestra qué ocurre después del final de *Carry On*. Ya no hay batallas épicas ni profecías que cumplir, pero los protagonistas aún tienen mucho que enfrentar, especialmente en su lucha interna por encontrar su lugar en el mundo.\r\n\r\nCon una historia que se aleja de los pasillos de Watford, Rowell nos lleva a un inesperado road trip por Estados Unidos, donde Simon, Baz y Penelope tendrán que lidiar con peligros desconocidos y con sus propios sentimientos.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nSimon Snow ya cumplió su destino. Derrotó al malvado Humdrum, salvó el mundo mágico… y ahora, ¿qué sigue? Con la magia ya no formando parte esencial de su vida, Simon se encuentra en una crisis existencial. Penelope y Baz, preocupados por él, deciden emprender un viaje por carretera en Estados Unidos. Lo que debería haber sido unas simples vacaciones termina convirtiéndose en una aventura peligrosa, donde descubrirán que la magia en América es más caótica de lo que jamás imaginaron.\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/7d/04/2d/7d042d2691d449958c69617310c60d20.jpg\" alt=\"Portada\" width=\"250\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\n*\"Wayward Son\"* es un cambio de ritmo en la saga de Simon Snow. A diferencia del primer libro, donde la historia giraba en torno a profecías y una gran amenaza, esta secuela se centra más en el crecimiento de los personajes y en los efectos de lo vivido en *Carry On*. Me gustó cómo la autora exploró el estado emocional de Simon después de perder su propósito y la forma en que esto afecta sus relaciones, especialmente con Baz.\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- El cambio de escenario de Inglaterra a un road trip en Estados Unidos le da un aire fresco a la historia.\r\n- La evolución de Simon como personaje, mostrando un lado más vulnerable y humano.\r\n- La dinámica entre Simon y Baz sigue siendo el corazón del libro, con momentos cargados de emociones.\r\n- Se introducen nuevos personajes interesantes que aportan dinamismo a la trama.\r\n\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- El ritmo es irregular, con algunas partes que pueden sentirse un poco lentas.\r\n- Se introducen elementos de la trama que no terminan de desarrollarse completamente.\r\n- El final deja muchas preguntas sin responder, lo que puede ser frustrante si no tienes el siguiente libro a la mano.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nSí, pero con una advertencia: *Wayward Son* es muy diferente a *Carry On*. No esperes una historia con un gran clímax o revelaciones sorprendentes, sino un libro más introspectivo que profundiza en los personajes y en sus emociones. Si disfrutaste el primer libro y te interesa ver cómo Simon y sus amigos enfrentan una nueva etapa en sus vidas, definitivamente vale la pena leerlo.\r\n</div>\r\n</div>\r\n",
    "extra_frontmatter": {
      "original_frontmatter": {
        "layout": "../../layouts/MarkdownPostLayout.astro",
        "title": "Wayward Son - Rainbow Rowell",
        "pubDate": "2025-02-26",
        "description": "Reseña de Wayward Son, la secuela de Carry On que nos lleva a una aventura inesperada",
        "author": "Amerik",
        "bookAuthor": "Rainbow Rowell",
        "genre": "Fantasía",
        "rating": 5,
        "readStart": "2025-02-18",
        "readEnd": "2025-02-25",
        "image": {
          "url": "https://m.media-amazon.com/images/I/91yfdNcfFNL._SL1500_.jpg",
          "alt": "Portada del libro Wayward Son de Rainbow Rowell"
        },
        "tags": [
          "Fantasía",
          "LGBTQ+",
          "Romance",
          "Aventura"
        ]
      },
      "original_source": "---\r\nlayout: ../../layouts/MarkdownPostLayout.astro\r\ntitle: 'Wayward Son - Rainbow Rowell'\r\npubDate: 2025-02-26\r\ndescription: 'Reseña de Wayward Son, la secuela de Carry On que nos lleva a una aventura inesperada'\r\nauthor: 'Amerik'\r\nbookAuthor: 'Rainbow Rowell'\r\ngenre: 'Fantasía'\r\nrating: 5\r\nreadStart: 2025-02-18\r\nreadEnd: 2025-02-25\r\nimage:\r\n    url: 'https://m.media-amazon.com/images/I/91yfdNcfFNL._SL1500_.jpg'\r\n    alt: 'Portada del libro Wayward Son de Rainbow Rowell'\r\ntags: [\"Fantasía\", \"LGBTQ+\", \"Romance\", \"Aventura\"]\r\n---\r\n\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*\"Wayward Son\"* es la segunda parte de la trilogía de Simon Snow, escrita por Rainbow Rowell. Publicada en 2019, esta secuela nos muestra qué ocurre después del final de *Carry On*. Ya no hay batallas épicas ni profecías que cumplir, pero los protagonistas aún tienen mucho que enfrentar, especialmente en su lucha interna por encontrar su lugar en el mundo.\r\n\r\nCon una historia que se aleja de los pasillos de Watford, Rowell nos lleva a un inesperado road trip por Estados Unidos, donde Simon, Baz y Penelope tendrán que lidiar con peligros desconocidos y con sus propios sentimientos.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nSimon Snow ya cumplió su destino. Derrotó al malvado Humdrum, salvó el mundo mágico… y ahora, ¿qué sigue? Con la magia ya no formando parte esencial de su vida, Simon se encuentra en una crisis existencial. Penelope y Baz, preocupados por él, deciden emprender un viaje por carretera en Estados Unidos. Lo que debería haber sido unas simples vacaciones termina convirtiéndose en una aventura peligrosa, donde descubrirán que la magia en América es más caótica de lo que jamás imaginaron.\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/7d/04/2d/7d042d2691d449958c69617310c60d20.jpg\" alt=\"Portada\" width=\"250\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\n*\"Wayward Son\"* es un cambio de ritmo en la saga de Simon Snow. A diferencia del primer libro, donde la historia giraba en torno a profecías y una gran amenaza, esta secuela se centra más en el crecimiento de los personajes y en los efectos de lo vivido en *Carry On*. Me gustó cómo la autora exploró el estado emocional de Simon después de perder su propósito y la forma en que esto afecta sus relaciones, especialmente con Baz.\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- El cambio de escenario de Inglaterra a un road trip en Estados Unidos le da un aire fresco a la historia.\r\n- La evolución de Simon como personaje, mostrando un lado más vulnerable y humano.\r\n- La dinámica entre Simon y Baz sigue siendo el corazón del libro, con momentos cargados de emociones.\r\n- Se introducen nuevos personajes interesantes que aportan dinamismo a la trama.\r\n\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- El ritmo es irregular, con algunas partes que pueden sentirse un poco lentas.\r\n- Se introducen elementos de la trama que no terminan de desarrollarse completamente.\r\n- El final deja muchas preguntas sin responder, lo que puede ser frustrante si no tienes el siguiente libro a la mano.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nSí, pero con una advertencia: *Wayward Son* es muy diferente a *Carry On*. No esperes una historia con un gran clímax o revelaciones sorprendentes, sino un libro más introspectivo que profundiza en los personajes y en sus emociones. Si disfrutaste el primer libro y te interesa ver cómo Simon y sus amigos enfrentan una nueva etapa en sus vidas, definitivamente vale la pena leerlo.\r\n</div>\r\n</div>\r\n"
    }
  },
  {
    "slug": "post-3",
    "title": "Anyway the Wind Blows - Rainbow Rowell",
    "book_author": "Rainbow Rowell",
    "author": "Amerik",
    "description": "Reseña de Anyway the Wind Blows, el desenlace de la trilogía de Simon Snow",
    "genre": "Fantasía",
    "tags": [
      "Fantasía",
      "LGBTQ+",
      "Romance",
      "Aventura"
    ],
    "rating": 4,
    "published_on": "2025-03-10",
    "read_start": "2025-02-26",
    "read_end": "2025-03-09",
    "cover_url": "https://m.media-amazon.com/images/I/81q-qNwhu6L._SL1500_.jpg",
    "cover_alt": "Portada del libro Anyway the Wind Blows de Rainbow Rowell",
    "body_markdown": "\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*\"Anyway the Wind Blows\"* es la conclusión de la trilogía de *Simon Snow*, una historia que ha conquistado a muchos con sus personajes entrañables y su mezcla de magia, romance y aventura. La novela de Rainbow Rowell nos ofrece un desenlace lleno de emoción, pero también de reflexión sobre la identidad, la pertenencia y lo que significa ser elegido en un mundo que no siempre sigue las reglas que esperamos. Después de los sucesos de *Wayward Son*, Simon, Baz y sus amigos regresan a casa, pero enfrentan nuevos desafíos personales que pondrán a prueba sus relaciones y su futuro.\r\n\r\nEn este tercer libro, Rowell hace un giro importante al centrarse en los temas del autodescubrimiento y la curación. El mundo de la magia ya no es tan central como en los primeros dos libros, lo que permite a los personajes, especialmente a Simon, enfrentarse a las consecuencias de sus acciones y de sus decisiones. La trama se torna más emocional y profunda, manteniendo la esencia de la saga pero mostrando un lado más maduro de los protagonistas.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nSimon Snow ha derrotado al mal, ha cumplido su destino… y ahora, ¿qué sigue? Después de la lucha final contra el Humdrum y la disolución de las viejas profecías, Simon se enfrenta a un vacío existencial. Sin su magia, sin su propósito, y sin el mundo que conocía para darle sentido a su vida, comienza a preguntarse qué hacer con el resto de su tiempo.  \r\n\r\nBaz, que ha estado a su lado en todas las aventuras, sigue siendo su apoyo constante, pero también enfrenta sus propios conflictos internos. Juntos, deciden regresar a Watford para cerrar algunos capítulos sin resolver, pero lo que encuentran allí no es lo que esperaban. Mientras Simon lucha con la pérdida de su identidad mágica, Baz enfrenta viejos demonios, y ambos deben encontrar la manera de reconciliarse con su pasado y su futuro.  \r\n\r\nEn esta entrega, también vemos el regreso de personajes como Penelope y Agatha, quienes tienen sus propios conflictos y enfrentan cambios que los llevarán a replantear su lugar en este nuevo mundo. La magia ya no parece ser el centro de todo, pero hay mucho más en juego de lo que imaginan.\r\n\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/06/b4/a5/06b4a55fd01c171cd0e6c836f7e4451c.jpg\" alt=\"Portada\" width=\"250\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\nLa trilogía de *Simon Snow* ha sido un viaje fascinante, y *Anyway the Wind Blows* no decepciona como conclusión. Lo que más me impresionó de este libro fue cómo Rainbow Rowell decidió no ofrecer un final típicamente \"feliz\" o lleno de grandes batallas mágicas, sino uno más introspectivo y humano. Aquí, lo que importa no es tanto la magia en sí, sino cómo los personajes se enfrentan a la vida después de haberla vivido al límite. \r\n\r\nMe encantó cómo Rowell profundiza en la psique de Simon, mostrándonos su vulnerabilidad y su lucha interna. Al final del segundo libro, Simon estaba en un lugar muy oscuro, y esta historia realmente muestra cómo, aunque todo parece estar bien en la superficie, los efectos de las experiencias pasadas siguen siendo una carga emocional muy real. \r\n\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- El enfoque más introspectivo de los personajes y sus conflictos internos.\r\n- El desarrollo de la relación entre Simon y Baz, que se convierte en una historia de curación y crecimiento.\r\n- El tema de la identidad mágica y la importancia de encontrar un propósito más allá de la magia.\r\n- Los personajes secundarios tienen un gran impacto en la trama y sus propias historias son igualmente cautivadoras.\r\n\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- A pesar de la profundidad emocional, algunas tramas secundarias se sienten algo subdesarrolladas.\r\n- El ritmo puede ser algo lento en ciertas partes, ya que el libro se enfoca mucho en los momentos de reflexión.\r\n- El final es algo abierto, lo que puede dejar a los lectores con la sensación de que quedan preguntas por responder.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nSí, especialmente si eres fan de los dos libros anteriores. *Anyway the Wind Blows* no es un libro para quienes buscan una gran batalla final o un cierre fácil; es una reflexión sobre la vida, el amor y el autodescubrimiento. Si te atraparon los personajes y las emociones de *Carry On* y *Wayward Son*, este libro es la conclusión perfecta, aunque de un modo más maduro y emocionalmente cargado. Si estás buscando una historia que se aleje del típico final feliz de fantasía y se adentre en temas más profundos, definitivamente deberías leerlo.\r\n</div>\r\n</div>\r\n",
    "extra_frontmatter": {
      "original_frontmatter": {
        "layout": "../../layouts/MarkdownPostLayout.astro",
        "title": "Anyway the Wind Blows - Rainbow Rowell",
        "pubDate": "2025-03-10",
        "description": "Reseña de Anyway the Wind Blows, el desenlace de la trilogía de Simon Snow",
        "author": "Amerik",
        "bookAuthor": "Rainbow Rowell",
        "genre": "Fantasía",
        "rating": 4,
        "readStart": "2025-02-26",
        "readEnd": "2025-03-09",
        "image": {
          "url": "https://m.media-amazon.com/images/I/81q-qNwhu6L._SL1500_.jpg",
          "alt": "Portada del libro Anyway the Wind Blows de Rainbow Rowell"
        },
        "tags": [
          "Fantasía",
          "LGBTQ+",
          "Romance",
          "Aventura"
        ]
      },
      "original_source": "---\r\nlayout: ../../layouts/MarkdownPostLayout.astro\r\ntitle: 'Anyway the Wind Blows - Rainbow Rowell'\r\npubDate: 2025-03-10\r\ndescription: 'Reseña de Anyway the Wind Blows, el desenlace de la trilogía de Simon Snow'\r\nauthor: 'Amerik'\r\nbookAuthor: 'Rainbow Rowell'\r\ngenre: 'Fantasía'\r\nrating: 4\r\nreadStart: 2025-02-26\r\nreadEnd: 2025-03-09\r\nimage:\r\n    url: 'https://m.media-amazon.com/images/I/81q-qNwhu6L._SL1500_.jpg'\r\n    alt: 'Portada del libro Anyway the Wind Blows de Rainbow Rowell'\r\ntags: [\"Fantasía\", \"LGBTQ+\", \"Romance\", \"Aventura\"]\r\n---\r\n\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*\"Anyway the Wind Blows\"* es la conclusión de la trilogía de *Simon Snow*, una historia que ha conquistado a muchos con sus personajes entrañables y su mezcla de magia, romance y aventura. La novela de Rainbow Rowell nos ofrece un desenlace lleno de emoción, pero también de reflexión sobre la identidad, la pertenencia y lo que significa ser elegido en un mundo que no siempre sigue las reglas que esperamos. Después de los sucesos de *Wayward Son*, Simon, Baz y sus amigos regresan a casa, pero enfrentan nuevos desafíos personales que pondrán a prueba sus relaciones y su futuro.\r\n\r\nEn este tercer libro, Rowell hace un giro importante al centrarse en los temas del autodescubrimiento y la curación. El mundo de la magia ya no es tan central como en los primeros dos libros, lo que permite a los personajes, especialmente a Simon, enfrentarse a las consecuencias de sus acciones y de sus decisiones. La trama se torna más emocional y profunda, manteniendo la esencia de la saga pero mostrando un lado más maduro de los protagonistas.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nSimon Snow ha derrotado al mal, ha cumplido su destino… y ahora, ¿qué sigue? Después de la lucha final contra el Humdrum y la disolución de las viejas profecías, Simon se enfrenta a un vacío existencial. Sin su magia, sin su propósito, y sin el mundo que conocía para darle sentido a su vida, comienza a preguntarse qué hacer con el resto de su tiempo.  \r\n\r\nBaz, que ha estado a su lado en todas las aventuras, sigue siendo su apoyo constante, pero también enfrenta sus propios conflictos internos. Juntos, deciden regresar a Watford para cerrar algunos capítulos sin resolver, pero lo que encuentran allí no es lo que esperaban. Mientras Simon lucha con la pérdida de su identidad mágica, Baz enfrenta viejos demonios, y ambos deben encontrar la manera de reconciliarse con su pasado y su futuro.  \r\n\r\nEn esta entrega, también vemos el regreso de personajes como Penelope y Agatha, quienes tienen sus propios conflictos y enfrentan cambios que los llevarán a replantear su lugar en este nuevo mundo. La magia ya no parece ser el centro de todo, pero hay mucho más en juego de lo que imaginan.\r\n\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/06/b4/a5/06b4a55fd01c171cd0e6c836f7e4451c.jpg\" alt=\"Portada\" width=\"250\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\nLa trilogía de *Simon Snow* ha sido un viaje fascinante, y *Anyway the Wind Blows* no decepciona como conclusión. Lo que más me impresionó de este libro fue cómo Rainbow Rowell decidió no ofrecer un final típicamente \"feliz\" o lleno de grandes batallas mágicas, sino uno más introspectivo y humano. Aquí, lo que importa no es tanto la magia en sí, sino cómo los personajes se enfrentan a la vida después de haberla vivido al límite. \r\n\r\nMe encantó cómo Rowell profundiza en la psique de Simon, mostrándonos su vulnerabilidad y su lucha interna. Al final del segundo libro, Simon estaba en un lugar muy oscuro, y esta historia realmente muestra cómo, aunque todo parece estar bien en la superficie, los efectos de las experiencias pasadas siguen siendo una carga emocional muy real. \r\n\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- El enfoque más introspectivo de los personajes y sus conflictos internos.\r\n- El desarrollo de la relación entre Simon y Baz, que se convierte en una historia de curación y crecimiento.\r\n- El tema de la identidad mágica y la importancia de encontrar un propósito más allá de la magia.\r\n- Los personajes secundarios tienen un gran impacto en la trama y sus propias historias son igualmente cautivadoras.\r\n\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- A pesar de la profundidad emocional, algunas tramas secundarias se sienten algo subdesarrolladas.\r\n- El ritmo puede ser algo lento en ciertas partes, ya que el libro se enfoca mucho en los momentos de reflexión.\r\n- El final es algo abierto, lo que puede dejar a los lectores con la sensación de que quedan preguntas por responder.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nSí, especialmente si eres fan de los dos libros anteriores. *Anyway the Wind Blows* no es un libro para quienes buscan una gran batalla final o un cierre fácil; es una reflexión sobre la vida, el amor y el autodescubrimiento. Si te atraparon los personajes y las emociones de *Carry On* y *Wayward Son*, este libro es la conclusión perfecta, aunque de un modo más maduro y emocionalmente cargado. Si estás buscando una historia que se aleje del típico final feliz de fantasía y se adentre en temas más profundos, definitivamente deberías leerlo.\r\n</div>\r\n</div>\r\n"
    }
  },
  {
    "slug": "post-4",
    "title": "El diablo tiene nombre - Francisco Asensi",
    "book_author": "Francisco Asensi",
    "author": "Amerik",
    "description": "Reseña de El diablo tiene nombre, una novela histórica sobre la inquisición y la libertad de pensamiento",
    "genre": "Histórica",
    "tags": [
      "Histórica",
      "Inquisición",
      "Filosofía",
      "Drama",
      "Thriller"
    ],
    "rating": 3,
    "published_on": "2025-04-04",
    "read_start": "2025-03-10",
    "read_end": "2025-04-04",
    "cover_url": "https://m.media-amazon.com/images/I/81chd71cZiL._SL1200_.jpg",
    "cover_alt": "Portada del libro El diablo tiene nombre de Francisco Asensi",
    "body_markdown": "\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*El diablo tiene nombre* es una novela histórica escrita por Francisco Asensi que se adentra en uno de los periodos más oscuros de la historia: la Inquisición Española. Con una mezcla de investigación histórica, reflexión filosófica y dramatismo narrativo, Asensi nos cuenta la historia de fray Tomás, un inquisidor enfrentado a sus propias dudas y a las contradicciones de su fe en un sistema opresor.\r\n\r\nEl libro plantea preguntas profundas sobre el fanatismo, la libertad de pensamiento y el precio que muchas veces se paga por tener el coraje de pensar diferente.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nFray Tomás es un dominico que ejerce como inquisidor en plena España del siglo XVI. Tras una vida dedicada al dogma y la ortodoxia, se ve sacudido por una serie de acontecimientos que lo obligan a mirar con nuevos ojos la realidad de su tiempo. En su camino se cruza con pensadores, herejes y víctimas del sistema inquisitorial, y poco a poco empieza a cuestionar los fundamentos de la institución que representa.\r\n\r\nLo que comienza como una búsqueda de herejes termina siendo una búsqueda de sentido. A través de una prosa sobria y cuidada, Asensi nos lleva por un viaje interior cargado de conflictos éticos, revelaciones personales y enfrentamientos con el poder.\r\n\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/db/32/0a/db320a8bdfdf4599b8e08b604f7c62ca.jpg\" alt=\"Portada\" width=\"240\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\nEl diablo tiene nombre me pareció una lectura interesante pero no del todo satisfactoria. La novela tiene un enfoque profundo y reflexivo, y el conflicto interno de fray Tomás está bien logrado. Sin embargo, hubo momentos en que la narrativa se volvía demasiado densa y el ritmo lento me desconectaba de la historia. Sentí que le faltó dinamismo, y aunque las ideas que plantea son valiosas, la forma en que se desarrollan no siempre logra mantener el interés.\r\n\r\nAun así, se nota el trabajo de documentación y la intención del autor de generar un diálogo sobre el poder y la conciencia, lo cual valoro mucho.. \r\n\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- La profundidad del personaje principal y su evolución interna.\r\n- El contexto histórico bien documentado, que se siente auténtico sin ser tedioso.\r\n- Las reflexiones filosóficas y religiosas que enriquecen la narrativa.\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- Algunas partes pueden sentirse densas y repetitivas.\r\n- El ritmo pausado hace que cueste engancharse en ciertos tramos.\r\n- Los personajes secundarios son algo planos y no se desarrollan demasiado.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nCon reservas. *El diablo tiene nombre* puede ser una buena lectura para quienes disfrutan de novelas históricas con fuerte carga filosófica. No es una lectura ligera ni muy entretenida, pero tiene momentos que invitan a la reflexión. Personalmente, esperaba algo más fluido y emocionalmente envolvente, así que no fue exactamente lo que buscaba, pero reconozco su valor intelectual y temático.\r\n</div>\r\n</div>\r\n",
    "extra_frontmatter": {
      "original_frontmatter": {
        "layout": "../../layouts/MarkdownPostLayout.astro",
        "title": "El diablo tiene nombre - Francisco Asensi",
        "pubDate": "2025-04-04",
        "description": "Reseña de El diablo tiene nombre, una novela histórica sobre la inquisición y la libertad de pensamiento",
        "author": "Amerik",
        "bookAuthor": "Francisco Asensi",
        "genre": "Histórica",
        "rating": 3,
        "readStart": "2025-03-10",
        "readEnd": "2025-04-04",
        "image": {
          "url": "https://m.media-amazon.com/images/I/81chd71cZiL._SL1200_.jpg",
          "alt": "Portada del libro El diablo tiene nombre de Francisco Asensi"
        },
        "tags": [
          "Histórica",
          "Inquisición",
          "Filosofía",
          "Drama",
          "Thriller"
        ]
      },
      "original_source": "---\r\nlayout: ../../layouts/MarkdownPostLayout.astro\r\ntitle: 'El diablo tiene nombre - Francisco Asensi'\r\npubDate: 2025-04-04\r\ndescription: 'Reseña de El diablo tiene nombre, una novela histórica sobre la inquisición y la libertad de pensamiento'\r\nauthor: 'Amerik'\r\nbookAuthor: 'Francisco Asensi'\r\ngenre: 'Histórica'\r\nrating: 3\r\nreadStart: 2025-03-10\r\nreadEnd: 2025-04-04\r\nimage:\r\n    url: 'https://m.media-amazon.com/images/I/81chd71cZiL._SL1200_.jpg'\r\n    alt: 'Portada del libro El diablo tiene nombre de Francisco Asensi'\r\ntags: [\"Histórica\", \"Inquisición\", \"Filosofía\", \"Drama\", \"Thriller\"]\r\n---\r\n\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*El diablo tiene nombre* es una novela histórica escrita por Francisco Asensi que se adentra en uno de los periodos más oscuros de la historia: la Inquisición Española. Con una mezcla de investigación histórica, reflexión filosófica y dramatismo narrativo, Asensi nos cuenta la historia de fray Tomás, un inquisidor enfrentado a sus propias dudas y a las contradicciones de su fe en un sistema opresor.\r\n\r\nEl libro plantea preguntas profundas sobre el fanatismo, la libertad de pensamiento y el precio que muchas veces se paga por tener el coraje de pensar diferente.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nFray Tomás es un dominico que ejerce como inquisidor en plena España del siglo XVI. Tras una vida dedicada al dogma y la ortodoxia, se ve sacudido por una serie de acontecimientos que lo obligan a mirar con nuevos ojos la realidad de su tiempo. En su camino se cruza con pensadores, herejes y víctimas del sistema inquisitorial, y poco a poco empieza a cuestionar los fundamentos de la institución que representa.\r\n\r\nLo que comienza como una búsqueda de herejes termina siendo una búsqueda de sentido. A través de una prosa sobria y cuidada, Asensi nos lleva por un viaje interior cargado de conflictos éticos, revelaciones personales y enfrentamientos con el poder.\r\n\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/db/32/0a/db320a8bdfdf4599b8e08b604f7c62ca.jpg\" alt=\"Portada\" width=\"240\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\nEl diablo tiene nombre me pareció una lectura interesante pero no del todo satisfactoria. La novela tiene un enfoque profundo y reflexivo, y el conflicto interno de fray Tomás está bien logrado. Sin embargo, hubo momentos en que la narrativa se volvía demasiado densa y el ritmo lento me desconectaba de la historia. Sentí que le faltó dinamismo, y aunque las ideas que plantea son valiosas, la forma en que se desarrollan no siempre logra mantener el interés.\r\n\r\nAun así, se nota el trabajo de documentación y la intención del autor de generar un diálogo sobre el poder y la conciencia, lo cual valoro mucho.. \r\n\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- La profundidad del personaje principal y su evolución interna.\r\n- El contexto histórico bien documentado, que se siente auténtico sin ser tedioso.\r\n- Las reflexiones filosóficas y religiosas que enriquecen la narrativa.\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- Algunas partes pueden sentirse densas y repetitivas.\r\n- El ritmo pausado hace que cueste engancharse en ciertos tramos.\r\n- Los personajes secundarios son algo planos y no se desarrollan demasiado.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nCon reservas. *El diablo tiene nombre* puede ser una buena lectura para quienes disfrutan de novelas históricas con fuerte carga filosófica. No es una lectura ligera ni muy entretenida, pero tiene momentos que invitan a la reflexión. Personalmente, esperaba algo más fluido y emocionalmente envolvente, así que no fue exactamente lo que buscaba, pero reconozco su valor intelectual y temático.\r\n</div>\r\n</div>\r\n"
    }
  },
  {
    "slug": "post-5",
    "title": "Mis días en la librería Morisaki - Satoshi Yagisawa",
    "book_author": "Satoshi Yagisawa",
    "author": "Amerik",
    "description": "Reseña de Mis días en la librería Morisaki, Una historia tranquila y reconfortante sobre libros, sanación y nuevos comienzos",
    "genre": "Ficción",
    "tags": [
      "Ficción",
      "Japonesa",
      "Sanación",
      "Contemporáneo"
    ],
    "rating": 5,
    "published_on": "2025-02-20",
    "read_start": "2025-02-18",
    "read_end": "2025-02-19",
    "cover_url": "https://m.media-amazon.com/images/I/91G3TjHdCTL._SL1500_.jpg",
    "cover_alt": "Portada del libro Mis días en la librería Morisaki",
    "body_markdown": "\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*\"Mis días en la librería Morisaki\"* es una novela breve y encantadora que nos transporta al barrio de Jimbocho, el distrito de las librerías en Tokio. Escrita por Satoshi Yagisawa, esta historia es un soplo de aire fresco para los amantes de los libros y para quienes buscan lecturas que reconforten el alma.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nTras una ruptura amorosa que la deja devastada, Takako, una joven oficinista, se ve obligada a dejar su empleo. Su tío Satoru le ofrece refugio en su librería de segunda mano, Morisaki. Aunque al principio se siente fuera de lugar en ese ambiente polvoriento y silencioso, poco a poco Takako va encontrando consuelo entre las páginas de los libros y el cálido caos de la tienda. Este nuevo entorno le permite sanar, reflexionar y redescubrir el valor de las pequeñas cosas.\r\n\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/71/bb/32/71bb328963afc612ab78884c15792a32.jpg\" alt=\"Portada\" width=\"250\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\n*\"Mis días en la librería Morisaki\"* es una historia que no necesita grandes giros argumentales para conmover. Me encantó la forma en que Yagisawa retrata el poder de los libros como refugio emocional. La evolución de Takako se siente natural y real, y el entorno en el que se mueve —una librería antigua llena de historia— resulta casi terapéutico.\r\n\r\nAunque la historia es sencilla, hay una belleza en su cotidianidad. El autor logra transmitir esa calma que sólo se experimenta cuando uno se sienta a leer con una taza de té caliente, rodeado de estanterías llenas de libros usados.\r\n\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- La ambientación en Jimbocho, un verdadero paraíso literario.\r\n- La conexión emocional que se genera con los libros y con el espacio físico de la librería.\r\n- La evolución personal de la protagonista sin necesidad de dramatismos.\r\n- El tono cálido y sereno que acompaña toda la narración.\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- Algunas partes pueden sentirse demasiado simples o predecibles.\r\n- Me habría gustado conocer un poco más del pasado de Takako y del propio tío Satoru.\r\n- Es un libro corto; te deja con ganas de seguir viviendo en ese mundo un poco más.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nDefinitivamente. Es una lectura ideal para desconectar, reconectar contigo mismo y recordar por qué amamos los libros. *Mis días en la librería Morisaki* no solo habla de lecturas, sino también de resiliencia, nuevos comienzos y del valor de los espacios compartidos. Perfecto para una tarde tranquila o como un bálsamo literario cuando más lo necesitas.\r\n</div>\r\n</div>\r\n",
    "extra_frontmatter": {
      "original_frontmatter": {
        "layout": "../../layouts/MarkdownPostLayout.astro",
        "title": "Mis días en la librería Morisaki - Satoshi Yagisawa",
        "pubDate": "2025-02-20",
        "description": "Reseña de Mis días en la librería Morisaki, Una historia tranquila y reconfortante sobre libros, sanación y nuevos comienzos",
        "author": "Amerik",
        "bookAuthor": "Satoshi Yagisawa",
        "genre": "Ficción",
        "rating": 5,
        "readStart": "2025-02-18",
        "readEnd": "2025-02-19",
        "image": {
          "url": "https://m.media-amazon.com/images/I/91G3TjHdCTL._SL1500_.jpg",
          "alt": "Portada del libro Mis días en la librería Morisaki"
        },
        "tags": [
          "Ficción",
          "Japonesa",
          "Sanación",
          "Contemporáneo"
        ]
      },
      "original_source": "---\r\nlayout: ../../layouts/MarkdownPostLayout.astro\r\ntitle: 'Mis días en la librería Morisaki - Satoshi Yagisawa'\r\npubDate: 2025-02-20\r\ndescription: 'Reseña de Mis días en la librería Morisaki, Una historia tranquila y reconfortante sobre libros, sanación y nuevos comienzos'\r\nauthor: 'Amerik'\r\nbookAuthor: 'Satoshi Yagisawa'\r\ngenre: 'Ficción'\r\nrating: 5\r\nreadStart: 2025-02-18\r\nreadEnd: 2025-02-19\r\nimage:\r\n    url: 'https://m.media-amazon.com/images/I/91G3TjHdCTL._SL1500_.jpg'\r\n    alt: 'Portada del libro Mis días en la librería Morisaki'\r\ntags: [\"Ficción\", \"Japonesa\", \"Sanación\", \"Contemporáneo\"]\r\n---\r\n\r\n<div style=\"text-align: justify;\">\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Introducción\r\n</div>\r\n\r\n*\"Mis días en la librería Morisaki\"* es una novela breve y encantadora que nos transporta al barrio de Jimbocho, el distrito de las librerías en Tokio. Escrita por Satoshi Yagisawa, esta historia es un soplo de aire fresco para los amantes de los libros y para quienes buscan lecturas que reconforten el alma.\r\n\r\n</div>\r\n\r\n<div style=\"text-align: justify;\">\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## Sinopsis\r\n</div>\r\n\r\nTras una ruptura amorosa que la deja devastada, Takako, una joven oficinista, se ve obligada a dejar su empleo. Su tío Satoru le ofrece refugio en su librería de segunda mano, Morisaki. Aunque al principio se siente fuera de lugar en ese ambiente polvoriento y silencioso, poco a poco Takako va encontrando consuelo entre las páginas de los libros y el cálido caos de la tienda. Este nuevo entorno le permite sanar, reflexionar y redescubrir el valor de las pequeñas cosas.\r\n\r\n\r\n</div>\r\n\r\n<div style=\"color: #ff2d54; text-align: justify;\">\r\n\r\n## Opinión Personal\r\n</div>\r\n\r\n<div style= \"text-align: justify;\">\r\n<img src=\"https://i.pinimg.com/736x/71/bb/32/71bb328963afc612ab78884c15792a32.jpg\" alt=\"Portada\" width=\"250\" style=\"float: left; margin-right: 25px;\">\r\n\r\n\r\n*\"Mis días en la librería Morisaki\"* es una historia que no necesita grandes giros argumentales para conmover. Me encantó la forma en que Yagisawa retrata el poder de los libros como refugio emocional. La evolución de Takako se siente natural y real, y el entorno en el que se mueve —una librería antigua llena de historia— resulta casi terapéutico.\r\n\r\nAunque la historia es sencilla, hay una belleza en su cotidianidad. El autor logra transmitir esa calma que sólo se experimenta cuando uno se sienta a leer con una taza de té caliente, rodeado de estanterías llenas de libros usados.\r\n\r\n</div>\r\n\r\n<div style=\"display: flex; gap: 20px; margin-top: 10px; text-align: justify;\">\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que más me gustó:\r\n\r\n- La ambientación en Jimbocho, un verdadero paraíso literario.\r\n- La conexión emocional que se genera con los libros y con el espacio físico de la librería.\r\n- La evolución personal de la protagonista sin necesidad de dramatismos.\r\n- El tono cálido y sereno que acompaña toda la narración.\r\n</div>\r\n<div style=\"flex: 1;\">\r\n\r\n### Lo que menos me gustó:\r\n\r\n- Algunas partes pueden sentirse demasiado simples o predecibles.\r\n- Me habría gustado conocer un poco más del pasado de Takako y del propio tío Satoru.\r\n- Es un libro corto; te deja con ganas de seguir viviendo en ese mundo un poco más.\r\n\r\n</div>\r\n</div>\r\n\r\n<div style=\"color: #ff2d54;\">\r\n\r\n## ¿Lo recomiendo?\r\n</div >\r\n<div style=\"text-align: justify;\">\r\n\r\nDefinitivamente. Es una lectura ideal para desconectar, reconectar contigo mismo y recordar por qué amamos los libros. *Mis días en la librería Morisaki* no solo habla de lecturas, sino también de resiliencia, nuevos comienzos y del valor de los espacios compartidos. Perfecto para una tarde tranquila o como un bálsamo literario cuando más lo necesitas.\r\n</div>\r\n</div>\r\n"
    }
  }
]$import_data$::jsonb;
  inserted_count integer;
begin
  if (select count(*) from blog_private.administrator) <> 1 then
    raise exception 'Configura primero una cuenta administradora';
  end if;
  if exists (
    select 1 from public.blog_reviews r
    join jsonb_array_elements(payload) item on r.slug = item->>'slug'
  ) then
    raise exception 'Ya existe una reseña con alguno de los slugs post-1 a post-5. No se importó nada; revisa las colisiones antes de continuar.';
  end if;
  insert into public.blog_reviews
    (slug, title, book_author, author, description, genre, tags, rating, published_on,
     read_start, read_end, cover_url, cover_alt, body_markdown, extra_frontmatter, published)
  select x.slug, x.title, x.book_author, x.author, x.description, x.genre, x.tags,
         x.rating, x.published_on, x.read_start, x.read_end, x.cover_url, x.cover_alt,
         x.body_markdown, x.extra_frontmatter, false
  from jsonb_to_recordset(payload) as x(
    slug text, title text, book_author text, author text, description text, genre text,
    tags text[], rating smallint, published_on date, read_start date, read_end date,
    cover_url text, cover_alt text, body_markdown text, extra_frontmatter jsonb
  );
  get diagnostics inserted_count = row_count;
  if inserted_count <> 5 then
    raise exception 'Se esperaban cinco reseñas; no se importó nada';
  end if;
end
$import$;

commit;
select 'Cinco reseñas importadas como borradores' as resultado;
