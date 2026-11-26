-- Ejecutar después de crear el bucket privado blog-covers desde Storage.
-- No modifica archivos ni crea el bucket.
begin;

do $$
declare
  bucket storage.buckets%rowtype;
begin
  select * into bucket from storage.buckets where id = 'blog-covers';
  if not found then
    raise exception 'Crea primero el bucket privado blog-covers en Storage';
  end if;
  if bucket.public then
    raise exception 'El bucket blog-covers debe ser privado';
  end if;
  if bucket.file_size_limit is null or bucket.file_size_limit > 5242880 then
    raise exception 'Configura un límite de tamaño de hasta 5 MiB';
  end if;
  if bucket.allowed_mime_types is null
    or cardinality(bucket.allowed_mime_types) = 0
    or not bucket.allowed_mime_types <@ array['image/jpeg', 'image/png', 'image/webp']::text[]
  then
    raise exception 'Restringe los tipos permitidos a image/jpeg, image/png e image/webp';
  end if;
  if (select count(*) from blog_private.administrator) <> 1 then
    raise exception 'Configura primero la cuenta administradora del blog';
  end if;
end $$;

create policy blog_covers_admin_select on storage.objects
  for select to authenticated
  using (bucket_id = 'blog-covers' and blog_private.is_administrator());

create policy blog_covers_admin_insert on storage.objects
  for insert to authenticated
  with check (bucket_id = 'blog-covers' and blog_private.is_administrator());

create policy blog_covers_admin_update on storage.objects
  for update to authenticated
  using (bucket_id = 'blog-covers' and blog_private.is_administrator())
  with check (bucket_id = 'blog-covers' and blog_private.is_administrator());

create policy blog_covers_admin_delete on storage.objects
  for delete to authenticated
  using (bucket_id = 'blog-covers' and blog_private.is_administrator());

commit;
