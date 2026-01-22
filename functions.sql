create or replace function public.authenticate(
    p_login varchar(32),
    p_password varchar(512)
) returns setof public.users_view security definer as $$
declare
    account_id integer;
begin
    select users.id into account_id from private.users as users
    where
        users.login = p_login
    and
        crypto.crypt(p_password, users.password_hash) = users.password_hash;

    if account_id is null then
        raise exception 'Incorrect account credentials!';
    end if;

    return query
        select *
        from public.users_view as users_view
        where users_view.id = account_id;
end;
$$ language plpgsql;