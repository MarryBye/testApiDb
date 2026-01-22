create or replace function hash_user_password() returns trigger as $$
begin
    if tg_op = 'INSERT' then
        new.login := lower(new.login);
        new.password_hash := crypto.crypt(new.password_hash, crypto.gen_salt('bf', 12));
    end if;

    if tg_op = 'UPDATE' then
        if new.password_hash is distinct from old.password_hash then
            new.password_hash := crypto.crypt(new.password_hash, crypto.gen_salt('bf', 12));
        end if;
        if new.login is distinct from old.login then
            new.login := lower(new.login);
        end if;
    end if;

    return new;
end;
$$ language plpgsql;

create or replace trigger trg_hash_user_password
before insert or update on "private"."users"
for each row
execute function hash_user_password();