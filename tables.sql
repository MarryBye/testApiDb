create table if not exists private.users (
    id serial primary key,

    login varchar(32) not null unique,
    password_hash varchar(512) not null,
    username varchar(32) not null unique,

    first_name varchar(32) not null,
    last_name varchar(32) not null,
    date_of_birth timestamp not null,
    gender public.genders not null,

    phone varchar(16) not null,

    created_at timestamp not null default now(),
    changed_at timestamp not null default now()
)