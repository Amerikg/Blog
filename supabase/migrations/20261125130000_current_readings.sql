-- Ejecutar después de las migraciones iniciales y de las políticas de Storage.
begin;

alter table public.blog_readings add column cover_path text
  check (cover_path is null or cover_path ~ '^covers/[0-9a-f-]{36}\.(jpg|png|webp)$');
alter table public.blog_reviews add column cover_path text
  check (cover_path is null or cover_path ~ '^covers/[0-9a-f-]{36}\.(jpg|png|webp)$');
alter table public.blog_readings add constraint reading_one_cover
  check (cover_url is null or cover_path is null);
alter table public.blog_reviews add constraint review_one_cover
  check (cover_url is null or cover_path is null);
grant insert (cover_path), update (cover_path) on public.blog_readings to authenticated;

create function public.blog_current_readings()
returns table (title text, book_author text, cover_url text, cover_path text, started_on date)
language sql stable security definer
set search_path = ''
as $$
  select r.title, r.book_author, r.cover_url, r.cover_path, r.started_on
  from public.blog_readings r
  where r.status = 'reading'
  order by r.created_at desc, r.id;
$$;
revoke all on function public.blog_current_readings() from public;
grant execute on function public.blog_current_readings() to anon, authenticated;

create function blog_private.is_current_reading_cover(object_name text)
returns boolean
language sql stable security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.blog_readings r
    where r.status = 'reading' and r.cover_path = object_name
  );
$$;
revoke all on function blog_private.is_current_reading_cover(text) from public;
grant execute on function blog_private.is_current_reading_cover(text) to anon, authenticated;

create policy blog_covers_current_reading_download on storage.objects
  for select to anon, authenticated
  using (
    bucket_id = 'blog-covers'
    and storage.allow_only_operation('object.get_authenticated')
    and blog_private.is_current_reading_cover(name)
  );

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
    (reading_id, slug, title, book_author, cover_url, cover_path, read_start, read_end, published)
  values
    (reading.id, review_slug, reading.title, reading.book_author, reading.cover_url,
     reading.cover_path, reading.started_on, finished_date, false)
  returning id into review_uuid;
  update public.blog_readings set status = 'finished', finished_on = finished_date
    where id = reading.id;
  return review_uuid;
end;
$$;

commit;
