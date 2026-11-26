-- Prueba temporal: termina con ROLLBACK y no conserva los datos de prueba.
-- Ejecutar como propietario en el SQL Editor, después de asignar administrador.
begin;

do $$
begin
  if (select count(*) from blog_private.administrator) <> 1 then
    raise exception 'Debe existir exactamente una cuenta administradora';
  end if;
  if exists (
    select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace
    where (n.nspname, c.relname) in (
      ('blog_private', 'administrator'),
      ('public', 'blog_readings'),
      ('public', 'blog_reviews')
    ) and not c.relrowsecurity
  ) then
    raise exception 'Falta activar RLS en una tabla';
  end if;
end $$;

select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
select set_config('blog.test_slug', 'verificacion-' || replace(gen_random_uuid()::text, '-', ''), true);

set local role authenticated;
with new_reading as (
  insert into public.blog_readings (title, book_author, started_on)
  values ('Lectura de prueba temporal', 'Autor de prueba', '2025-01-01')
  returning id
)
select set_config('blog.test_reading_id', id::text, true) from new_reading;

select public.blog_finish_reading(
  current_setting('blog.test_reading_id')::uuid,
  current_setting('blog.test_slug'),
  '2025-01-02'
);

do $$
begin
  if not exists (
    select 1 from public.blog_reviews
    where slug = current_setting('blog.test_slug') and not published
  ) then
    raise exception 'El administrador no puede ver el borrador';
  end if;
  if not exists (
    select 1 from public.blog_readings
    where id = current_setting('blog.test_reading_id')::uuid and status = 'finished'
  ) then
    raise exception 'La lectura no quedó marcada como terminada';
  end if;
  begin
    perform public.blog_finish_reading(
      current_setting('blog.test_reading_id')::uuid,
      current_setting('blog.test_slug') || '-otro', '2025-01-02'
    );
    raise exception 'Se permitió terminar la lectura dos veces';
  exception when check_violation then
    null;
  end;
end $$;

reset role;
select set_config('request.jwt.claim.sub', gen_random_uuid()::text, true);
set local role authenticated;
do $$
begin
  if exists (select 1 from public.blog_reviews where slug = current_setting('blog.test_slug'))
     or exists (select 1 from public.blog_readings where id = current_setting('blog.test_reading_id')::uuid) then
    raise exception 'Un usuario distinto al administrador pudo ver datos privados';
  end if;
  begin
    insert into public.blog_reviews (slug, title, book_author)
    values (current_setting('blog.test_slug') || '-denegada', 'Prueba', 'Autor');
    raise exception 'Un usuario distinto al administrador pudo crear una reseña';
  exception when insufficient_privilege then
    null;
  end;
end $$;

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if exists (select 1 from public.blog_reviews where slug = current_setting('blog.test_slug')) then
    raise exception 'Un visitante anónimo pudo ver el borrador';
  end if;
  begin
    perform 1 from public.blog_readings limit 1;
    raise exception 'Un visitante anónimo pudo acceder a las lecturas privadas';
  exception when insufficient_privilege then
    null;
  end;
end $$;

reset role;
select 'Verificación superada; los datos de prueba serán revertidos' as resultado;
rollback;
