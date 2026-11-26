-- Comprobación de configuración; no modifica el bucket ni sus archivos.
do $$
declare
  bucket storage.buckets%rowtype;
  policy_count integer;
begin
  select * into bucket from storage.buckets where id = 'blog-covers';
  if not found or bucket.public then
    raise exception 'Falta el bucket privado blog-covers';
  end if;
  if bucket.file_size_limit is null or bucket.file_size_limit > 5242880 then
    raise exception 'El límite del bucket debe ser de hasta 5 MiB';
  end if;
  if bucket.allowed_mime_types is null or cardinality(bucket.allowed_mime_types) = 0
    or not bucket.allowed_mime_types <@ array['image/jpeg', 'image/png', 'image/webp']::text[]
  then
    raise exception 'Revisa los tipos MIME permitidos';
  end if;
  select count(*) into policy_count from pg_policies
  where schemaname = 'storage' and tablename = 'objects'
    and (policyname, cmd) in (
      ('blog_covers_admin_select', 'SELECT'),
      ('blog_covers_admin_insert', 'INSERT'),
      ('blog_covers_admin_update', 'UPDATE'),
      ('blog_covers_admin_delete', 'DELETE')
    );
  if policy_count <> 4 then
    raise exception 'Faltan políticas de acceso para las portadas';
  end if;
end $$;

select 'Configuración de portadas verificada' as resultado;
