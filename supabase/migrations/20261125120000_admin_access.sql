-- Ejecutar una vez en SQL Editor después de la migración inicial.
begin;

create function public.blog_is_administrator()
returns boolean
language sql
stable
security invoker
set search_path = ''
as $$
  select blog_private.is_administrator();
$$;

revoke all on function public.blog_is_administrator() from public, anon;
grant execute on function public.blog_is_administrator() to authenticated;

commit;
