create view public.users_view as
    select
        id,
        username,
        first_name,
        last_name,
        date_of_birth,
        gender,
        phone,
        created_at,
        changed_at
    from private.users;

