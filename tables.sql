create table if not exists private.countries (
    id serial primary key,
    full_name varchar(64) not null unique,
    code varchar(8) not null unique,
    phone_code varchar(4) not null unique
);

create table if not exists private.cities (
    id serial primary key,
    full_name varchar(64) not null unique,
    country_id integer not null references private.countries(id)
);

create table if not exists private.users (
    id serial primary key,

    login varchar(32) not null unique,
    password_hash varchar(512) not null,
    username varchar(32) not null unique,

    first_name varchar(32) not null,
    last_name varchar(32) not null,
    date_of_birth timestamp not null,
    gender public.genders not null,
    city_id integer not null references private.cities(id),

    phone_code varchar(4) not null references private.countries(phone_code),
    phone public.phone not null,
    email public.email not null,

    created_at timestamp not null default now(),
    changed_at timestamp not null default now()
);

create table if not exists private.groups (
    id serial primary key,

    owner_id integer not null references private.users(id),

    name varchar(64) not null,
    description varchar(2048),

    created_at timestamp not null default now(),
    changed_at timestamp not null default now()
);

create table if not exists private.roles_accesses(
    id serial primary key,

    view_channel boolean not null default true,

    create_roles boolean not null default false,
    edit_roles boolean not null default false,
    give_roles boolean not null default false,

    send_messages boolean not null default true,
    edit_messages boolean not null default true,
    delete_messages boolean not null default true,
    pin_messages boolean not null default true,

    read_history boolean not null default true,

    is_admin boolean not null default false
);

create table if not exists private.guilds (
    id serial primary key,

    owner_id integer not null references private.users(id),

    title varchar(64) not null,
    description varchar(2048),
    members_limit integer not null check (members_limit > 0),
    privacy public.privacy not null default 'private',

    created_at timestamp not null default now(),
    changed_at timestamp not null default now()
);

create table if not exists private.guild_roles (
    id serial primary key,

    guild_id integer not null references private.guilds(id),
    accesses_id integer not null references private.roles_accesses(id),
    name varchar(64) not null,
    color varchar(7) not null,

    created_at timestamp not null default now()
);

create table if not exists private.guilds_members_roles (
    id serial primary key,

    guild_id integer not null references private.guilds(id),
    user_id integer not null references private.users(id),
    user_role integer references private.guild_roles(id),

    created_at timestamp not null default now()
);

create table if not exists private.channels_categories (
    id serial primary key,

    guild_id integer not null references private.guilds(id),
    accesses_id integer not null references private.roles_accesses(id),
    name varchar(64) not null,

    created_at timestamp not null default now()
);

create table if not exists private.channels (
    id serial primary key,

    guild_id integer references private.guilds(id) default null,
    accesses_id integer references private.roles_accesses(id),
    channel_type public.channel_types not null default 'direct',

    created_at timestamp not null default now(),
    changed_at timestamp not null default now()
);

create table if not exists private.channels_members (
    id serial primary key,

    channel_id integer not null references private.channels(id),
    user_id integer not null references private.users(id),

    unique(channel_id, user_id)
);

create table if not exists private.messages (
    id serial primary key,

    author_id integer not null references private.users(id),
    text_content varchar(2048) not null,
    channel_id integer not null references private.channels(id),

    created_at timestamp not null default now(),
    changed_at timestamp not null default now()
);

create table if not exists private.media_content (
    id serial primary key,

    message_id integer not null references private.messages(id),
    file_url varchar(256) not null
);