-- Apply after 20261125100000_blog_foundation.sql.
begin;

alter table public.blog_readings add column cover_path text
  check (cover_path is null or cover_path ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.(jpg|png|webp)$');
alter table public.blog_reviews add column cover_path text
  check (cover_path is null or cover_path ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.(jpg|png|webp)$');
alter table public.blog_readings add constraint reading_one_cover
  check (cover_url is null or cover_path is null);
alter table public.blog_reviews add constraint review_one_cover
  check (cover_url is null or cover_path is null);
grant insert (cover_path) on public.blog_readings to authenticated;
grant update (cover_path) on public.blog_readings to authenticated;

create function public.blog_is_administrator()
returns boolean language sql stable security definer set search_path = ''
as $$ select blog_private.is_administrator(); $$;
revoke all on function public.blog_is_administrator() from public, anon;
grant execute on function public.blog_is_administrator() to authenticated;

-- Only these four columns and only currently active rows are public.
-- Uploaded covers use an opaque storage: URI, resolved with a short-lived signed URL.
create view public.blog_active_readings with (security_barrier = true) as
select title, book_author,
  coalesce(cover_url, case when cover_path is not null then 'storage:blog-covers/' || cover_path end) as cover_url,
  started_on
from public.blog_readings where status = 'reading';
revoke all on public.blog_active_readings from public;
grant select on public.blog_active_readings to anon, authenticated;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('blog-covers', 'blog-covers', false, 5242880, array['image/jpeg', 'image/png', 'image/webp']);

create function blog_private.cover_is_public(object_name text)
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (select 1 from public.blog_readings where status = 'reading' and cover_path = object_name)
      or exists (select 1 from public.blog_reviews where published and cover_path = object_name);
$$;
revoke all on function blog_private.cover_is_public(text) from public;
grant execute on function blog_private.cover_is_public(text) to anon, authenticated;

create policy blog_covers_read on storage.objects for select to anon, authenticated
  using (bucket_id = 'blog-covers' and
    (blog_private.is_administrator() or blog_private.cover_is_public(name)));
create policy blog_covers_insert on storage.objects for insert to authenticated
  with check (bucket_id = 'blog-covers' and blog_private.is_administrator()
    and name ~ '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.(jpg|png|webp)$');
-- Do not allow overwrites or deletions: objects can be shared by reviews/readings.

create or replace function public.blog_finish_reading(
  reading_uuid uuid, review_slug text, finished_date date
)
returns uuid language plpgsql security definer set search_path = ''
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
  update public.blog_readings set status = 'finished', finished_on = finished_date where id = reading.id;
  return review_uuid;
end;
$$;

commit;
