-- Apply once to a Supabase project, after reviewing the setup instructions.
-- This migration does not import or alter the existing Markdown files.
begin;

create schema if not exists blog_private;
revoke all on schema blog_private from public, anon, authenticated;
grant usage on schema blog_private to anon, authenticated;

-- Only a project owner using the SQL editor can populate or change this row.
create table blog_private.administrator (
  singleton boolean primary key default true check (singleton),
  user_id uuid not null unique references auth.users(id) on delete restrict
);
alter table blog_private.administrator enable row level security;
revoke all on blog_private.administrator from public, anon, authenticated;

create function blog_private.is_administrator()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from blog_private.administrator
    where user_id = auth.uid()
  );
$$;
revoke all on function blog_private.is_administrator() from public;
grant execute on function blog_private.is_administrator() to anon, authenticated;

create table public.blog_readings (
  id uuid primary key default gen_random_uuid(),
  title text not null check (length(btrim(title)) between 1 and 300),
  book_author text not null check (length(btrim(book_author)) between 1 and 300),
  cover_url text check (cover_url is null or
    (length(cover_url) <= 2048 and cover_url ~* '^https?://[^[:space:]]+$')),
  started_on date,
  finished_on date,
  status text not null default 'reading' check (status in ('reading', 'finished')),
  created_at timestamptz not null default now(),
  check ((status = 'reading' and finished_on is null) or
         (status = 'finished' and finished_on is not null)),
  check (started_on is null or finished_on is null or started_on <= finished_on)
);

create table public.blog_reviews (
  id uuid primary key default gen_random_uuid(),
  reading_id uuid unique references public.blog_readings(id) on delete restrict,
  -- The path is /posts/<slug>; existing post-N paths can be represented unchanged.
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' and length(slug) <= 120),
  title text not null check (length(btrim(title)) between 1 and 300),
  book_author text not null check (length(btrim(book_author)) between 1 and 300),
  author text not null default 'Amerik' check (length(btrim(author)) between 1 and 300),
  description text not null default '' check (length(description) <= 5000),
  genre text not null default '' check (length(genre) <= 300),
  tags text[] not null default '{}' check (cardinality(tags) <= 100),
  rating smallint check (rating between 0 and 5),
  tears smallint check (tears between 0 and 5),
  spice smallint check (spice between 0 and 5),
  published_on date not null default current_date,
  read_start date,
  read_end date,
  cover_url text check (cover_url is null or
    (length(cover_url) <= 2048 and cover_url ~* '^https?://[^[:space:]]+$')),
  cover_alt text not null default '' check (length(cover_alt) <= 500),
  -- Preserve the source rather than converting or stripping existing HTML.
  body_markdown text not null default '',
  extra_frontmatter jsonb not null default '{}'::jsonb
    check (jsonb_typeof(extra_frontmatter) = 'object'),
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (read_start is null or read_end is null or read_start <= read_end)
);

create function blog_private.touch_review()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;
revoke all on function blog_private.touch_review() from public;
create trigger blog_reviews_touch
before update on public.blog_reviews
for each row execute function blog_private.touch_review();

alter table public.blog_readings enable row level security;
alter table public.blog_reviews enable row level security;
revoke all on public.blog_readings, public.blog_reviews from public, anon, authenticated;

-- Direct updates cannot set the finish state; the RPC performs both writes.
grant select, delete on public.blog_readings to authenticated;
grant insert (title, book_author, cover_url, started_on) on public.blog_readings to authenticated;
grant update (title, book_author, cover_url, started_on) on public.blog_readings to authenticated;
grant select on public.blog_reviews to anon, authenticated;
grant insert, update, delete on public.blog_reviews to authenticated;

create policy readings_admin_select on public.blog_readings for select to authenticated
  using (blog_private.is_administrator());
create policy readings_admin_insert on public.blog_readings for insert to authenticated
  with check (blog_private.is_administrator());
create policy readings_admin_update on public.blog_readings for update to authenticated
  using (blog_private.is_administrator()) with check (blog_private.is_administrator());
create policy readings_admin_delete on public.blog_readings for delete to authenticated
  using (blog_private.is_administrator());

create policy reviews_public_select on public.blog_reviews for select to anon, authenticated
  using (published or blog_private.is_administrator());
create policy reviews_admin_insert on public.blog_reviews for insert to authenticated
  with check (blog_private.is_administrator());
create policy reviews_admin_update on public.blog_reviews for update to authenticated
  using (blog_private.is_administrator()) with check (blog_private.is_administrator());
create policy reviews_admin_delete on public.blog_reviews for delete to authenticated
  using (blog_private.is_administrator());

-- A single PostgreSQL transaction and row lock prevent duplicate finalizations.
create function public.blog_finish_reading(
  reading_uuid uuid,
  review_slug text,
  finished_date date
)
returns uuid
language plpgsql
security definer
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

  select * into reading from public.blog_readings
    where id = reading_uuid for update;
  if not found then
    raise exception 'Reading not found' using errcode = 'P0002';
  end if;
  if reading.status <> 'reading' then
    raise exception 'Reading already finished' using errcode = '23514';
  end if;

  insert into public.blog_reviews
    (reading_id, slug, title, book_author, cover_url, read_start, read_end, published)
  values
    (reading.id, review_slug, reading.title, reading.book_author, reading.cover_url,
     reading.started_on, finished_date, false)
  returning id into review_uuid;

  update public.blog_readings
    set status = 'finished', finished_on = finished_date
    where id = reading.id;
  return review_uuid;
end;
$$;
revoke all on function public.blog_finish_reading(uuid, text, date) from public, anon;
grant execute on function public.blog_finish_reading(uuid, text, date) to authenticated;

commit;
