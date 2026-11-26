-- Ejecutar una sola vez después de 20261125130000_current_readings.sql.
-- Los nuevos campos admiten NULL para conservar las lecturas existentes.
begin;

alter table public.blog_readings
  add column genre text check (genre is null or length(btrim(genre)) between 1 and 300),
  add column page_count integer check (page_count is null or page_count > 0),
  add column description text check (description is null or length(btrim(description)) between 1 and 5000);

alter table public.blog_reviews
  add column page_count integer check (page_count is null or page_count > 0);

grant insert (genre, page_count, description), update (genre, page_count, description)
  on public.blog_readings to authenticated;

create or replace function public.blog_finish_reading(
  reading_uuid uuid, review_slug text, finished_date date
)
returns uuid
language plpgsql security definer
set search_path = ''
as $$
declare
  reading public.blog_readings%rowtype;
  review_uuid uuid;
begin
  if not blog_private.is_administrator() then
    raise exception 'Not authorized' using errcode = '42501';
  end if;
  if finished_date is null then
    raise exception 'A finish date is required' using errcode = '22004';
  end if;
  select * into reading from public.blog_readings where id = reading_uuid for update;
  if not found then
    raise exception 'Reading not found' using errcode = 'P0002';
  end if;
  if reading.status <> 'reading' then
    raise exception 'Reading already finished' using errcode = '23514';
  end if;
  insert into public.blog_reviews
    (reading_id, slug, title, book_author, cover_url, cover_path, read_start, read_end,
     genre, page_count, description, published)
  values
    (reading.id, review_slug, reading.title, reading.book_author, reading.cover_url,
     reading.cover_path, reading.started_on, finished_date,
     coalesce(reading.genre, ''), reading.page_count, coalesce(reading.description, ''), false)
  returning id into review_uuid;
  update public.blog_readings set status = 'finished', finished_on = finished_date
    where id = reading.id;
  return review_uuid;
end;
$$;

commit;
