-- Ejecutar en SQL Editor después de crear blog_is_administrator.
-- Cambia roles y JWT solo dentro de la transacción y no conserva cambios.
begin;

select set_config('request.jwt.claim.sub',
  (select user_id::text from blog_private.administrator), true);
set local role authenticated;
do $$
begin
  if public.blog_is_administrator() is distinct from true then
    raise exception 'La cuenta administradora no pasó la verificación';
  end if;
end $$;

reset role;
select set_config('request.jwt.claim.sub', gen_random_uuid()::text, true);
set local role authenticated;
do $$
begin
  if public.blog_is_administrator() is distinct from false then
    raise exception 'Una cuenta distinta obtuvo acceso de administradora';
  end if;
end $$;

reset role;
set local role anon;
do $$
begin
  begin
    perform public.blog_is_administrator();
    raise exception 'Una persona anónima pudo ejecutar la verificación';
  exception when insufficient_privilege then
    null;
  end;
end $$;

reset role;
select 'Verificación de acceso superada' as resultado;
rollback;
