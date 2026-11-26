-- Ejecutar una sola vez después de 20261125140000_reading_details.sql.
-- Los datos devueltos por esta función serán visibles públicamente.
begin;

create function public.blog_current_readings_hero()
returns table (title text, book_author text, description text, cover_url text, cover_path text)
language sql stable security definer
set search_path = ''
as $$
  select r.title, r.book_author, r.description, r.cover_url, r.cover_path
  from public.blog_readings r
  where r.status = 'reading'
  order by r.created_at desc, r.id;
$$;
revoke all on function public.blog_current_readings_hero() from public;
grant execute on function public.blog_current_readings_hero() to anon, authenticated;

commit;
