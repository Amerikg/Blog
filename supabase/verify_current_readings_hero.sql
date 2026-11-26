-- Ejecutar después de 20261125150000_current_readings_hero.sql. No conserva datos.
begin;

select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
select set_config('request.jwt.claims', '{}', true);
select set_config('blog.test_slug', 'verificacion-' || replace(gen_random_uuid()::text, '-', ''), true);
set local role authenticated;
with new_reading as (
  insert into public.blog_readings
    (title, book_author, cover_url, started_on, genre, page_count, description)
  values ('Lectura de prueba temporal', 'Autor de prueba', 'https://example.com/portada.jpg',
    '2025-01-01', 'Fantasía', 320, 'Descripción de prueba')
  returning id
)
select set_config('blog.test_reading_id', id::text, true) from new_reading;

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if not exists (
    select 1 from public.blog_current_readings_hero()
    where title = 'Lectura de prueba temporal' and book_author = 'Autor de prueba'
      and description = 'Descripción de prueba'
      and cover_url = 'https://example.com/portada.jpg'
  ) then
    raise exception 'La lectura activa no muestra sus datos públicamente';
  end if;
end $$;

reset role;
select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
set local role authenticated;
select public.blog_finish_reading(
  current_setting('blog.test_reading_id')::uuid,
  current_setting('blog.test_slug'), '2025-01-02'
);

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if exists (select 1 from public.blog_current_readings_hero()
    where title = 'Lectura de prueba temporal' and description = 'Descripción de prueba') then
    raise exception 'La lectura terminada sigue apareciendo públicamente';
  end if;
  if exists (select 1 from public.blog_reviews where slug = current_setting('blog.test_slug')) then
    raise exception 'Un visitante anónimo pudo ver el borrador';
  end if;
end $$;
reset role;
select 'Verificación del carrusel de lecturas superada' as resultado;
rollback;
