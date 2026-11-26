-- Ejecutar después de la migración de lecturas actuales. Sin cambios permanentes.
begin;

select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
select set_config('request.jwt.claims', '{}', true);
select set_config('blog.test_slug', 'verificacion-' || replace(gen_random_uuid()::text, '-', ''), true);
set local role authenticated;
with new_reading as (
  insert into public.blog_readings (title, book_author, cover_path, started_on)
  values ('Lectura de prueba temporal', 'Autor de prueba',
          'covers/11111111-1111-4111-8111-111111111111.jpg', '2025-01-01')
  returning id
)
select set_config('blog.test_reading_id', id::text, true) from new_reading;

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if not exists (select 1 from public.blog_current_readings()
    where title = 'Lectura de prueba temporal'
      and cover_path = 'covers/11111111-1111-4111-8111-111111111111.jpg') then
    raise exception 'La lectura actual no es visible públicamente';
  end if;
  if not blog_private.is_current_reading_cover('covers/11111111-1111-4111-8111-111111111111.jpg') then
    raise exception 'La portada de lectura actual no se reconoce como pública';
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
do $$
begin
  if not exists (select 1 from public.blog_reviews
    where slug = current_setting('blog.test_slug') and not published
      and cover_path = 'covers/11111111-1111-4111-8111-111111111111.jpg') then
    raise exception 'El borrador no conservó la portada';
  end if;
end $$;

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if exists (select 1 from public.blog_current_readings() where title = 'Lectura de prueba temporal') then
    raise exception 'La lectura terminada sigue siendo pública como lectura actual';
  end if;
  if blog_private.is_current_reading_cover('covers/11111111-1111-4111-8111-111111111111.jpg') then
    raise exception 'La portada del borrador sigue visible como lectura actual';
  end if;
  if exists (select 1 from public.blog_reviews where slug = current_setting('blog.test_slug')) then
    raise exception 'Un visitante anónimo pudo ver el borrador';
  end if;
end $$;
reset role;
select 'Verificación de lecturas actuales superada' as resultado;
rollback;
