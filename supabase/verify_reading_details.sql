-- Ejecutar después de 20261125140000_reading_details.sql. No conserva datos.
begin;

select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
select set_config('request.jwt.claims', '{}', true);
select set_config('blog.test_slug', 'verificacion-' || replace(gen_random_uuid()::text, '-', ''), true);
set local role authenticated;

with new_reading as (
  insert into public.blog_readings
    (title, book_author, cover_url, started_on, genre, page_count, description)
  values
    ('Lectura de prueba temporal', 'Autor de prueba', 'https://example.com/portada.jpg',
     '2025-01-01', 'Fantasía', 320, 'Descripción de prueba')
  returning id
)
select set_config('blog.test_reading_id', id::text, true) from new_reading;

update public.blog_readings
  set genre = 'Aventura', page_count = 321, description = 'Descripción editada'
  where id = current_setting('blog.test_reading_id')::uuid;

do $$
begin
  begin
    update public.blog_readings set page_count = 0
      where id = current_setting('blog.test_reading_id')::uuid;
    raise exception 'Se aceptó un número de páginas inválido';
  exception when check_violation then
    null;
  end;
end $$;

select public.blog_finish_reading(
  current_setting('blog.test_reading_id')::uuid,
  current_setting('blog.test_slug'), '2025-01-02'
);

do $$
begin
  if not exists (
    select 1 from public.blog_reviews
    where slug = current_setting('blog.test_slug') and not published
      and genre = 'Aventura' and page_count = 321 and description = 'Descripción editada'
      and cover_url = 'https://example.com/portada.jpg'
      and read_start = '2025-01-01' and read_end = '2025-01-02'
  ) then
    raise exception 'El borrador no conservó los datos de la lectura';
  end if;
end $$;

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if exists (select 1 from public.blog_reviews where slug = current_setting('blog.test_slug')) then
    raise exception 'Un visitante anónimo pudo ver el borrador';
  end if;
end $$;
reset role;
select 'Verificación de detalles de lectura superada' as resultado;
rollback;
