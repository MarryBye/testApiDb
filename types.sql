create domain public.email as text
check (
    value like '^[\w]{4,}\@[A-z]{4,}(\.[\w]{2,}){1,2}$'
);

create domain public.phone as text
check (
    value like '^[\d]{10}$'
);

create type public.genders as enum (
    'male',
    'female',
    'other'
);

create type public.privacy as enum (
    'private',
    'public',
    'friends_only'
);

create type public.channel_types as enum (
    'guild_text',
    'guild_voice',
    'direct',
    'group_direct'
);