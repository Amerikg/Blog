-- Ejecutar después de importar las cinco reseñas; no modifica datos.
begin;

select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
select set_config('request.jwt.claims', '{}', true);
set local role authenticated;

do $$
begin
  if (
    select count(*) from public.blog_reviews
    where slug in ('post-1', 'post-2', 'post-3', 'post-4', 'post-5')
      and not published
      and length(body_markdown) > 0
      and length(extra_frontmatter->>'original_source') > 0
      and jsonb_typeof(extra_frontmatter->'original_frontmatter') = 'object'
  ) <> 5 then
    raise exception 'Faltan borradores o contenido original; revisa la importación';
  end if;
end $$;

reset role;
select set_config('request.jwt.claim.sub', '', true);
set local role anon;
do $$
begin
  if exists (
    select 1 from public.blog_reviews
    where slug in ('post-1', 'post-2', 'post-3', 'post-4', 'post-5')
  ) then
    raise exception 'Un visitante anónimo pudo consultar un borrador';
  end if;
end $$;
reset role;
select 'Verificación de importación superada' as resultado;
rollback;
