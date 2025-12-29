--
-- PostgreSQL database dump
--

\restrict qXr3sUdnp4TuBo5Jc2qr2gUSmi4Fmb6MIZY3xym0YOOAaPTW20ZJM7mTW8ZlgfK

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO supabase_storage_admin;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO supabase_storage_admin;

--
-- Name: lock_top_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket text;
    v_top text;
BEGIN
    FOR v_bucket, v_top IN
        SELECT DISTINCT t.bucket_id,
            split_part(t.name, '/', 1) AS top
        FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        WHERE t.name <> ''
        ORDER BY 1, 2
        LOOP
            PERFORM pg_advisory_xact_lock(hashtextextended(v_bucket || '/' || v_top, 0));
        END LOOP;
END;
$$;


ALTER FUNCTION storage.lock_top_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

--
-- Name: objects_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    -- NEW - OLD (destinations to create prefixes for)
    v_add_bucket_ids text[];
    v_add_names      text[];

    -- OLD - NEW (sources to prune)
    v_src_bucket_ids text[];
    v_src_names      text[];
BEGIN
    IF TG_OP <> 'UPDATE' THEN
        RETURN NULL;
    END IF;

    -- 1) Compute NEW−OLD (added paths) and OLD−NEW (moved-away paths)
    WITH added AS (
        SELECT n.bucket_id, n.name
        FROM new_rows n
        WHERE n.name <> '' AND position('/' in n.name) > 0
        EXCEPT
        SELECT o.bucket_id, o.name FROM old_rows o WHERE o.name <> ''
    ),
    moved AS (
         SELECT o.bucket_id, o.name
         FROM old_rows o
         WHERE o.name <> ''
         EXCEPT
         SELECT n.bucket_id, n.name FROM new_rows n WHERE n.name <> ''
    )
    SELECT
        -- arrays for ADDED (dest) in stable order
        COALESCE( (SELECT array_agg(a.bucket_id ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        COALESCE( (SELECT array_agg(a.name      ORDER BY a.bucket_id, a.name) FROM added a), '{}' ),
        -- arrays for MOVED (src) in stable order
        COALESCE( (SELECT array_agg(m.bucket_id ORDER BY m.bucket_id, m.name) FROM moved m), '{}' ),
        COALESCE( (SELECT array_agg(m.name      ORDER BY m.bucket_id, m.name) FROM moved m), '{}' )
    INTO v_add_bucket_ids, v_add_names, v_src_bucket_ids, v_src_names;

    -- Nothing to do?
    IF (array_length(v_add_bucket_ids, 1) IS NULL) AND (array_length(v_src_bucket_ids, 1) IS NULL) THEN
        RETURN NULL;
    END IF;

    -- 2) Take per-(bucket, top) locks: ALL prefixes in consistent global order to prevent deadlocks
    DECLARE
        v_all_bucket_ids text[];
        v_all_names text[];
    BEGIN
        -- Combine source and destination arrays for consistent lock ordering
        v_all_bucket_ids := COALESCE(v_src_bucket_ids, '{}') || COALESCE(v_add_bucket_ids, '{}');
        v_all_names := COALESCE(v_src_names, '{}') || COALESCE(v_add_names, '{}');

        -- Single lock call ensures consistent global ordering across all transactions
        IF array_length(v_all_bucket_ids, 1) IS NOT NULL THEN
            PERFORM storage.lock_top_prefixes(v_all_bucket_ids, v_all_names);
        END IF;
    END;

    -- 3) Create destination prefixes (NEW−OLD) BEFORE pruning sources
    IF array_length(v_add_bucket_ids, 1) IS NOT NULL THEN
        WITH candidates AS (
            SELECT DISTINCT t.bucket_id, unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(v_add_bucket_ids, v_add_names) AS t(bucket_id, name)
            WHERE name <> ''
        )
        INSERT INTO storage.prefixes (bucket_id, name)
        SELECT c.bucket_id, c.name
        FROM candidates c
        ON CONFLICT DO NOTHING;
    END IF;

    -- 4) Prune source prefixes bottom-up for OLD−NEW
    IF array_length(v_src_bucket_ids, 1) IS NOT NULL THEN
        -- re-entrancy guard so DELETE on prefixes won't recurse
        IF current_setting('storage.gc.prefixes', true) <> '1' THEN
            PERFORM set_config('storage.gc.prefixes', '1', true);
        END IF;

        PERFORM storage.delete_leaf_prefixes(v_src_bucket_ids, v_src_names);
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.objects_update_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_level_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_level_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Set the new level
        NEW."level" := "storage"."get_level"(NEW."name");
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_level_trigger() OWNER TO supabase_storage_admin;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_delete_cleanup(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_delete_cleanup() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_bucket_ids text[];
    v_names      text[];
BEGIN
    IF current_setting('storage.gc.prefixes', true) = '1' THEN
        RETURN NULL;
    END IF;

    PERFORM set_config('storage.gc.prefixes', '1', true);

    SELECT COALESCE(array_agg(d.bucket_id), '{}'),
           COALESCE(array_agg(d.name), '{}')
    INTO v_bucket_ids, v_names
    FROM deleted AS d
    WHERE d.name <> '';

    PERFORM storage.lock_top_prefixes(v_bucket_ids, v_names);
    PERFORM storage.delete_leaf_prefixes(v_bucket_ids, v_names);

    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.prefixes_delete_cleanup() OWNER TO supabase_storage_admin;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
declare
    can_bypass_rls BOOLEAN;
begin
    SELECT rolbypassrls
    INTO can_bypass_rls
    FROM pg_roles
    WHERE rolname = coalesce(nullif(current_setting('role', true), 'none'), current_user);

    IF can_bypass_rls THEN
        RETURN QUERY SELECT * FROM storage.search_v1_optimised(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    ELSE
        RETURN QUERY SELECT * FROM storage.search_legacy_v1(prefix, bucketname, limits, levels, offsets, search, sortcolumn, sortorder);
    END IF;
end;
$$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    sort_col text;
    sort_ord text;
    cursor_op text;
    cursor_expr text;
    sort_expr text;
BEGIN
    -- Validate sort_order
    sort_ord := lower(sort_order);
    IF sort_ord NOT IN ('asc', 'desc') THEN
        sort_ord := 'asc';
    END IF;

    -- Determine cursor comparison operator
    IF sort_ord = 'asc' THEN
        cursor_op := '>';
    ELSE
        cursor_op := '<';
    END IF;
    
    sort_col := lower(sort_column);
    -- Validate sort column  
    IF sort_col IN ('updated_at', 'created_at') THEN
        cursor_expr := format(
            '($5 = '''' OR ROW(date_trunc(''milliseconds'', %I), name COLLATE "C") %s ROW(COALESCE(NULLIF($6, '''')::timestamptz, ''epoch''::timestamptz), $5))',
            sort_col, cursor_op
        );
        sort_expr := format(
            'COALESCE(date_trunc(''milliseconds'', %I), ''epoch''::timestamptz) %s, name COLLATE "C" %s',
            sort_col, sort_ord, sort_ord
        );
    ELSE
        cursor_expr := format('($5 = '''' OR name COLLATE "C" %s $5)', cursor_op);
        sort_expr := format('name COLLATE "C" %s', sort_ord);
    END IF;

    RETURN QUERY EXECUTE format(
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    NULL::uuid AS id,
                    updated_at,
                    created_at,
                    NULL::timestamptz AS last_accessed_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
            UNION ALL
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name,
                    id,
                    updated_at,
                    created_at,
                    last_accessed_at,
                    metadata
                FROM storage.objects
                WHERE name COLLATE "C" LIKE $1 || '%%'
                    AND bucket_id = $2
                    AND level = $4
                    AND %s
                ORDER BY %s
                LIMIT $3
            )
        ) obj
        ORDER BY %s
        LIMIT $3
        $sql$,
        cursor_expr,    -- prefixes WHERE
        sort_expr,      -- prefixes ORDER BY
        cursor_expr,    -- objects WHERE
        sort_expr,      -- objects ORDER BY
        sort_expr       -- final ORDER BY
    )
    USING prefix, bucket_name, limits, levels, start_after, sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    descripcion text,
    color_hex character varying(7) DEFAULT '#667eea'::character varying,
    orden_menu integer DEFAULT 0,
    activo boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    parent_id integer,
    nivel integer DEFAULT 0,
    ruta_completa text DEFAULT ''::text
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorias_id_seq OWNER TO postgres;

--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_id_seq OWNED BY public.categorias.id;


--
-- Name: centro_medico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.centro_medico (
    id integer NOT NULL,
    nombre text NOT NULL,
    direccion text,
    telefono text,
    correo text,
    ruc text
);


ALTER TABLE public.centro_medico OWNER TO postgres;

--
-- Name: centro_medico_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.centro_medico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.centro_medico_id_seq OWNER TO postgres;

--
-- Name: centro_medico_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.centro_medico_id_seq OWNED BY public.centro_medico.id;


--
-- Name: citas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citas (
    id integer NOT NULL,
    paciente_id integer,
    medico_id integer,
    fecha timestamp without time zone NOT NULL,
    motivo text,
    estado text DEFAULT 'agendada'::text,
    observaciones text,
    duracion integer DEFAULT 30,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT citas_estado_check CHECK ((estado = ANY (ARRAY['agendada'::text, 'reprogramada'::text, 'cancelada'::text, 'asistida'::text, 'no asistió'::text])))
);


ALTER TABLE public.citas OWNER TO postgres;

--
-- Name: citas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.citas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.citas_id_seq OWNER TO postgres;

--
-- Name: citas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.citas_id_seq OWNED BY public.citas.id;


--
-- Name: entrada_categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entrada_categorias (
    id integer NOT NULL,
    entrada_id integer NOT NULL,
    categoria_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.entrada_categorias OWNER TO postgres;

--
-- Name: entrada_categorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entrada_categorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entrada_categorias_id_seq OWNER TO postgres;

--
-- Name: entrada_categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entrada_categorias_id_seq OWNED BY public.entrada_categorias.id;


--
-- Name: entradas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entradas (
    id integer NOT NULL,
    titulo character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    contenido text NOT NULL,
    resumen text,
    imagen_principal character varying(500),
    autor_id integer,
    estado character varying(20) DEFAULT 'borrador'::character varying,
    fecha_publicacion timestamp without time zone,
    meta_title character varying(255),
    meta_description text,
    tags jsonb DEFAULT '[]'::jsonb,
    vistas integer DEFAULT 0,
    destacado boolean DEFAULT false,
    orden integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo_entrada character varying(20) DEFAULT 'entrada'::character varying,
    categoria_id_backup integer,
    categoria_id integer,
    CONSTRAINT entradas_estado_check CHECK (((estado)::text = ANY (ARRAY[('borrador'::character varying)::text, ('publicado'::character varying)::text, ('archivado'::character varying)::text]))),
    CONSTRAINT entradas_tipo_entrada_check CHECK (((tipo_entrada)::text = ANY (ARRAY[('pagina'::character varying)::text, ('entrada'::character varying)::text])))
);


ALTER TABLE public.entradas OWNER TO postgres;

--
-- Name: entradas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entradas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entradas_id_seq OWNER TO postgres;

--
-- Name: entradas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entradas_id_seq OWNED BY public.entradas.id;


--
-- Name: especialidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidades (
    id integer NOT NULL,
    nombre text NOT NULL,
    descripcion character varying,
    icon character varying
);


ALTER TABLE public.especialidades OWNER TO postgres;

--
-- Name: especialidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.especialidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.especialidades_id_seq OWNER TO postgres;

--
-- Name: especialidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.especialidades_id_seq OWNED BY public.especialidades.id;


--
-- Name: historial_citas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historial_citas (
    id integer NOT NULL,
    cita_id integer,
    fecha_cambio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado_anterior text,
    estado_nuevo text,
    comentario text
);


ALTER TABLE public.historial_citas OWNER TO postgres;

--
-- Name: historial_citas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_citas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historial_citas_id_seq OWNER TO postgres;

--
-- Name: historial_citas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_citas_id_seq OWNED BY public.historial_citas.id;


--
-- Name: horarios_medicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horarios_medicos (
    id integer NOT NULL,
    medico_id integer,
    dia_semana text,
    hora_inicio time without time zone,
    hora_fin time without time zone,
    CONSTRAINT horarios_medicos_dia_semana_check CHECK ((dia_semana = ANY (ARRAY['Lunes'::text, 'Martes'::text, 'Miércoles'::text, 'Jueves'::text, 'Viernes'::text, 'Sábado'::text, 'Domingo'::text])))
);


ALTER TABLE public.horarios_medicos OWNER TO postgres;

--
-- Name: horarios_medicos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.horarios_medicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.horarios_medicos_id_seq OWNER TO postgres;

--
-- Name: horarios_medicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.horarios_medicos_id_seq OWNED BY public.horarios_medicos.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.media (
    id integer NOT NULL,
    nombre_archivo character varying(255) NOT NULL,
    nombre_original character varying(255) NOT NULL,
    tipo_mime character varying(100) NOT NULL,
    "tamaño_bytes" bigint NOT NULL,
    url character varying(500) NOT NULL,
    alt_text character varying(255),
    uploaded_by integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.media OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.media_id_seq OWNER TO postgres;

--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: medicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicos (
    id integer NOT NULL,
    nombre text NOT NULL,
    dni text NOT NULL,
    correo text,
    telefono text,
    estado text DEFAULT 'activo'::text,
    especialidad_id integer,
    centro_id integer
);


ALTER TABLE public.medicos OWNER TO postgres;

--
-- Name: medicos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medicos_id_seq OWNER TO postgres;

--
-- Name: medicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medicos_id_seq OWNED BY public.medicos.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_items (
    id integer NOT NULL,
    titulo character varying(100) NOT NULL,
    tipo character varying(20) NOT NULL,
    url character varying(500),
    orden integer DEFAULT 0,
    parent_id integer,
    activo boolean DEFAULT true,
    icono character varying(50),
    target character varying(10) DEFAULT '_self'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT menu_items_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('pagina'::character varying)::text, ('categoria'::character varying)::text, ('entrada'::character varying)::text, ('enlace_externo'::character varying)::text])))
);


ALTER TABLE public.menu_items OWNER TO postgres;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_items_id_seq OWNER TO postgres;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: pacientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pacientes (
    id integer NOT NULL,
    nombre text NOT NULL,
    dni text,
    telefono text,
    correo text,
    fecha_nacimiento date,
    estado_vital text DEFAULT 'vivo'::text,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado text DEFAULT 'activo'::text,
    tipo_documento character varying(20) DEFAULT 'DNI'::character varying,
    numero_documento character varying(20),
    CONSTRAINT pacientes_estado_vital_check CHECK ((estado_vital = ANY (ARRAY['vivo'::text, 'fallecido'::text])))
);


ALTER TABLE public.pacientes OWNER TO postgres;

--
-- Name: pacientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pacientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pacientes_id_seq OWNER TO postgres;

--
-- Name: pacientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pacientes_id_seq OWNED BY public.pacientes.id;


--
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permisos (
    id integer NOT NULL,
    nombre text NOT NULL,
    descripcion text
);


ALTER TABLE public.permisos OWNER TO postgres;

--
-- Name: permisos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permisos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permisos_id_seq OWNER TO postgres;

--
-- Name: permisos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permisos_id_seq OWNED BY public.permisos.id;


--
-- Name: rol_permiso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol_permiso (
    id integer NOT NULL,
    rol_id integer,
    permiso_id integer
);


ALTER TABLE public.rol_permiso OWNER TO postgres;

--
-- Name: rol_permiso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rol_permiso_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_permiso_id_seq OWNER TO postgres;

--
-- Name: rol_permiso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rol_permiso_id_seq OWNED BY public.rol_permiso.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    nombre text NOT NULL,
    descripcion text
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: usuario_rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_rol (
    id integer NOT NULL,
    usuario_id integer,
    rol_id integer
);


ALTER TABLE public.usuario_rol OWNER TO postgres;

--
-- Name: usuario_rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_rol_id_seq OWNER TO postgres;

--
-- Name: usuario_rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_rol_id_seq OWNED BY public.usuario_rol.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre text NOT NULL,
    correo text NOT NULL,
    "contraseña" text NOT NULL,
    estado text DEFAULT 'activo'::text,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT usuarios_estado_check CHECK ((estado = ANY (ARRAY['activo'::text, 'suspendido'::text])))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb,
    level integer
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categorias_id_seq'::regclass);


--
-- Name: centro_medico id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centro_medico ALTER COLUMN id SET DEFAULT nextval('public.centro_medico_id_seq'::regclass);


--
-- Name: citas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas ALTER COLUMN id SET DEFAULT nextval('public.citas_id_seq'::regclass);


--
-- Name: entrada_categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entrada_categorias ALTER COLUMN id SET DEFAULT nextval('public.entrada_categorias_id_seq'::regclass);


--
-- Name: entradas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entradas ALTER COLUMN id SET DEFAULT nextval('public.entradas_id_seq'::regclass);


--
-- Name: especialidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades ALTER COLUMN id SET DEFAULT nextval('public.especialidades_id_seq'::regclass);


--
-- Name: historial_citas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_citas ALTER COLUMN id SET DEFAULT nextval('public.historial_citas_id_seq'::regclass);


--
-- Name: horarios_medicos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios_medicos ALTER COLUMN id SET DEFAULT nextval('public.horarios_medicos_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: medicos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicos ALTER COLUMN id SET DEFAULT nextval('public.medicos_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: pacientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes ALTER COLUMN id SET DEFAULT nextval('public.pacientes_id_seq'::regclass);


--
-- Name: permisos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos ALTER COLUMN id SET DEFAULT nextval('public.permisos_id_seq'::regclass);


--
-- Name: rol_permiso id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso ALTER COLUMN id SET DEFAULT nextval('public.rol_permiso_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: usuario_rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol ALTER COLUMN id SET DEFAULT nextval('public.usuario_rol_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id, nombre, slug, descripcion, color_hex, orden_menu, activo, created_at, updated_at, parent_id, nivel, ruta_completa) FROM stdin;
32	Via Biliar	via-biliar	Cáncer de vía biliar	#667eea	2	t	2025-09-09 22:09:35.767	2025-09-09 22:09:35.767	28	2	
33	Linfoma	linfoma	Linfomas y enfermedades linfoproliferativas	#667eea	3	t	2025-09-09 22:09:35.767	2025-09-09 22:09:35.767	28	2	
34	Mama	mama	Cáncer de mama	#667eea	4	t	2025-09-09 22:09:35.767	2025-09-09 22:09:35.767	28	2	
35	Carcinomatosis	carcinomatosis	Carcinomatosis peritoneal	#f093fb	1	t	2025-09-09 22:09:35.769	2025-09-09 22:09:35.769	29	2	
36	Derrame Pleural	derrame-pleural	Derrame pleural maligno	#f093fb	2	t	2025-09-09 22:09:35.769	2025-09-09 22:09:35.769	29	2	
37	Metastasis Osea	metastasis-osea	Metástasis óseas	#f093fb	3	t	2025-09-09 22:09:35.769	2025-09-09 22:09:35.769	29	2	
38	Oxalaplatino	oxalaplatino	Oxaliplatino en tratamiento oncológico	#43e97b	1	t	2025-09-09 22:09:35.772	2025-09-09 22:09:35.772	30	2	
39	Ciplatino	ciplatino	Cisplatino en quimioterapia	#43e97b	2	t	2025-09-09 22:09:35.772	2025-09-09 22:09:35.772	30	2	
40	Casos	casos	Casos clínicos y experiencias	#fa709a	1	t	2025-09-09 22:09:35.773	2025-09-09 22:09:35.773	27	1	
27	Bitácora	bitacora	Casos clínicos y experiencias	#fa709a	999	t	2025-09-09 22:09:35.763	2025-09-09 22:09:35.763	\N	0	Bitácora
28	Cáncer	cancer	Tipos de cáncer y sus características	#667eea	1	t	2025-09-09 22:09:35.765	2025-09-09 22:09:35.765	26	1	
29	Condición	condicion	Condiciones médicas relacionadas	#f093fb	2	t	2025-09-09 22:09:35.765	2025-09-09 22:09:35.765	26	1	
30	Molécula	molecula	Moléculas y fármacos en investigación	#43e97b	3	t	2025-09-09 22:09:35.765	2025-09-09 22:09:35.765	26	1	
31	Cuello Uterino	cuello-uterino	Cáncer de cuello uterino	#667eea	1	t	2025-09-09 22:09:35.767	2025-09-09 22:09:35.767	28	2	
26	Investigación	investigacion	Avances en investigación oncológica	#009e2f	1	t	2025-09-09 22:09:35.763	2025-09-12 20:42:46.23	\N	0	Investigación
\.


--
-- Data for Name: centro_medico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.centro_medico (id, nombre, direccion, telefono, correo, ruc) FROM stdin;
\.


--
-- Data for Name: citas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citas (id, paciente_id, medico_id, fecha, motivo, estado, observaciones, duracion, fecha_creacion) FROM stdin;
13	7	3	2025-08-20 13:00:00	preoperatorios	agendada	\N	30	2025-08-08 21:30:33.648
14	8	1	2025-08-28 13:00:00	Revision Mensual	agendada	\N	30	2025-08-08 22:24:15.527
15	9	1	2025-08-26 14:30:00	Control	agendada	\N	30	2025-08-12 17:58:51.711
16	10	4	2025-08-20 14:30:00	Terapia emocional	agendada	\N	30	2025-08-12 18:53:24.521
17	11	4	2025-08-19 14:00:00	terapia	agendada	\N	30	2025-08-14 15:17:40.089
18	13	1	2025-01-25 19:00:00	Consulta de seguimiento	agendada	\N	30	2025-09-09 22:20:34.689
19	24	1	2025-10-09 15:00:00	Consulta de seguimiento	agendada	\N	30	2025-09-09 22:24:09.473
20	33	1	2025-10-09 16:00:00	Consulta de seguimiento	agendada	\N	30	2025-09-09 22:25:19.349
21	36	4	2025-09-15 14:00:00	Apoyo	agendada	\N	30	2025-09-11 21:56:23.056
22	37	6	2025-09-23 08:00:00	Revision	agendada	\N	20	2025-09-19 19:02:59.236854
23	38	6	2025-09-23 03:20:00	servicio	agendada	\N	20	2025-09-19 19:05:18.205498
24	39	10	2025-09-25 08:00:00	Terapia	agendada	\N	20	2025-09-19 21:43:29.822448
25	40	6	2025-10-05 08:00:00	Segunda Opinion	agendada	\N	20	2025-09-25 20:42:07.776577
26	40	3	2025-09-26 08:00:00	sls	agendada	\N	20	2025-09-25 21:06:16.272442
1	1	1	2025-08-09 16:21:23.88	Consulta oncológica inicial	agendada	\N	30	2025-08-08 16:21:23.88
2	2	2	2025-08-10 16:21:23.88	Sesión de radioterapia	agendada	\N	45	2025-08-08 16:21:23.88
3	3	3	2025-08-11 16:21:23.88	Evaluación pre-cirugía	agendada	\N	60	2025-08-08 16:21:23.88
4	2	2	2025-08-10 15:00:00	Control mensual	agendada	\N	30	2025-08-08 16:46:39.076
5	2	2	2025-08-10 19:30:00	Revisión de exámenes	agendada	\N	30	2025-08-08 16:46:39.112
6	2	2	2025-08-10 16:30:00	Seguimiento tratamiento	agendada	\N	30	2025-08-08 16:49:24.91
7	2	2	2025-08-10 17:30:00	Revisión de estudios	agendada	\N	30	2025-08-08 16:49:24.942
8	2	2	2025-08-10 20:30:00	Control post-tratamiento	agendada	\N	30	2025-08-08 16:49:24.945
9	2	2	2025-08-10 21:30:00	Consulta de rutina	agendada	\N	30	2025-08-08 16:49:24.947
10	4	4	2025-08-14 14:30:00	Acompañamiento Emocional Post Traumatico	agendada	\N	30	2025-08-08 17:10:05.892
11	5	4	2025-08-22 14:30:00	Terapia	agendada	\N	30	2025-08-08 17:24:17.204
12	6	4	2025-08-23 14:00:00	Soprte	agendada	\N	30	2025-08-08 19:55:35.502
27	41	1	2025-12-08 09:00:00	Consulta de Emergencia	agendada	\N	25	2025-12-06 20:23:23.778195
28	42	1	2025-12-11 09:00:00	Segunda Opinión	agendada	\N	25	2025-12-10 00:13:09.663656
\.


--
-- Data for Name: entrada_categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entrada_categorias (id, entrada_id, categoria_id, created_at) FROM stdin;
1	31	31	2025-09-12 10:51:52.46
2	32	32	2025-09-12 10:51:52.46
3	33	33	2025-09-12 10:51:52.46
4	34	34	2025-09-12 10:51:52.46
5	35	35	2025-09-12 10:51:52.46
6	36	36	2025-09-12 10:51:52.46
7	38	38	2025-09-12 10:51:52.46
8	39	39	2025-09-12 10:51:52.46
10	51	30	2025-09-12 11:18:56.534
13	53	28	2025-09-12 12:31:51.048
14	54	40	2025-09-12 13:51:36.832
15	55	28	2025-09-12 14:09:08.783
16	55	40	2025-09-12 14:09:08.783
17	52	40	2025-09-12 14:13:55.597
20	43	36	2025-09-12 14:17:26.359
21	43	26	2025-09-12 14:17:26.359
22	37	37	2025-09-12 14:34:01.624
54	42	6	2025-09-19 20:44:31.740337
59	44	39	2025-09-19 21:40:01.342657
60	44	31	2025-09-19 21:40:01.342657
61	44	26	2025-09-19 21:40:01.342657
62	44	30	2025-09-19 21:40:01.342657
63	40	40	2025-09-19 21:47:19.672399
64	50	28	2025-10-03 19:43:04.330004
65	50	26	2025-10-03 19:43:04.330004
\.


--
-- Data for Name: entradas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entradas (id, titulo, slug, contenido, resumen, imagen_principal, autor_id, estado, fecha_publicacion, meta_title, meta_description, tags, vistas, destacado, orden, created_at, updated_at, tipo_entrada, categoria_id_backup, categoria_id) FROM stdin;
27	Convencionales	convencionales	El manejo y control del dolor provocado por el cáncer se constituye en un arte en sí mismo, el tratamiento adecuado de una de las manifestaciones que más inciden en degradar la calidad de vida de un paciente oncológico es crucial para aliviar o anular una sintomatología que de no ser bloqueada eﬁcazmente, degrada sustancialmente el estado general y la calidad de vida del afectado.<div><br></div><div>El manejo de diversos fármacos, con mecanismos de acción diferentes, entre los que destacan los AINEs, Opiáceos, Anticonvulsivantes, Corticoides, Cannabinoides, etc., es práctica corriente en ONKOS, pero en donde incidimos más en el manejo del dolor es en atacar a la causa fundamental de este: La enfermedad en sí, esto quiere decir, que para tratar eﬁcazmente el dolor oncológico, el primer objetivo es atacar y tratar el tumor maligno causante de este.</div><div><br><br></div><div style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367053/onkos-blog/onkos-blog/1757367053367-904200077.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></div>		https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367035/onkos-blog/onkos-blog/1757367034891-420227062.jpg	\N	publicado	2025-08-12 20:52:46.062	\N	\N	{}	12	f	0	2025-08-12 20:52:46.062	2025-09-09 02:30:57.69	pagina	\N	\N
49	Prueba de Enlaces	prueba-enlaces	<p>Esta es una entrada de prueba para probar el flujo de enlaces.</p><p>Aquí puedes seleccionar texto y convertirlo en un enlace.</p>	Entrada de prueba para enlaces	\N	\N	borrador	\N	\N	\N	{}	0	\N	0	2025-08-29 21:32:03.132	2025-08-29 21:32:03.132	entrada	\N	\N
37	Servicio Onkos	metastasis-osea				\N	publicado	2025-08-12 20:52:46.083			{}	2	f	0	2025-08-12 20:52:46.083	2025-08-27 20:25:47.08	pagina	\N	\N
36	Servicio Onkos	derrame-pleural				\N	publicado	2025-08-12 20:52:46.082			{}	4	f	0	2025-08-12 20:52:46.082	2025-08-27 20:25:47.082	pagina	\N	\N
43	Servicio Onkos	contacto-onkos				\N	publicado	2025-08-27 18:43:57.312	\N	\N	{}	1	f	0	2025-08-27 18:43:57.312	2025-08-27 20:25:47.086	pagina	\N	\N
23	Terapias Intra Peritoneales – (TIPs)	terapias-intra-peritoneales-tips	<p style="text-align: justify;"><font size="6"><b>¿Qué es la Carcinomatosis Peritoneal?</b></font></p><p style="text-align: justify;"><span style="font-size: 1rem;">La Carcinomatosis Peritoneal se define a toda diseminación tumoral que afecta de forma localizadao masiva, a la serosa del peritoneo visceral y/o parietal abdominal. D</span><span style="font-size: 1rem;">e forma mayoritaria puedetener dos orígenes, por un lado, el mismo peritoneo (Carcinoma Seroso Peritoneal,Mesotelioma) ypor otro, un origen en tumores del tracto digestivo o el aparato ginecológico.</span></p><p style="text-align: justify;">El peritoneo es la membrana serosa que reviste el interior de la cavidad abdominal.&nbsp;<span style="font-size: 1rem;">Se estructura endos capas: la capa exterior, llamada peritoneo parietal, está adherida a la pared de la cavidadabdominal, y la capa interna o peritoneo visceral envuelve los intestinos y otros órganos del abdomen.</span><span style="font-size: 1rem;">&nbsp;El espacio entre ambas capas se denomina cavidad peritoneal y contiene una pequeña cantidad defluido lubricante (alrededor de 50 ml) que permite a ambas capas deslizarse entre sí.</span></p><p style="text-align: justify;"><br><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366176/onkos-blog/onkos-blog/1757366176601-15140127.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="600" height="601"><span style="font-size: 1rem;"></span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><p style="text-align: justify;">La aparición de tumores de diversos tamaños sobre esta superficie, fenómeno conocido comocarcinomatosis, es un hecho muy frecuente en cánceres de origen ginecológico, como el cáncer deovario principalmente y otras neoplasias de origen digestivo, como cáncer de estómago, páncreas,colon y vías biliares.</p><p style="text-align: justify;">Estos tumores que se implantan en la superficie peritoneal, tienden a ser múltiples por lo general yafectan notablemente la motilidad intestinal al comprimir los intestinos, infiltrarlos o comprometerlos plexos nerviosos responsables de coordinar la movilidad de estos, además provocan unfenómeno frecuentemente conocido como ascitis, el cual consiste en la acumulación de moderadas a grandes cantidades de líquido en la cavidad abdominal, induciendo la distensión de esta y alterando notablemente la capacidad respiratoria y nutricional del o la paciente.</p><p style="text-align: justify;">Si la carcinomatosis no se controla, como sucede frecuentemente, la persona afectada disminuyenotablemente su capacidad para alimentarse y absorber nutrientes, pues al ser el peritoneo que cubre los intestinos el blanco de este tipo de diseminación metastásica, se afectan significativamente los movimientos peristálticos intestinales, produciéndose cuadros sub-oclusivos o en casos avanzados oclusiones completas al tránsito intestinal, lo que conlleva a una desnutrición acelerada y grave del paciente, ya que este es incapaz de ingerir alimentos en adecuada cantidad, e incluso estos no son tolerados, instaurándose vómitos refractarios a todo tratamiento y translocación de la microbiota colónica a segmentos intestinales más altos o proximales, como ileon y yeyuno principalmente.</p><p style="text-align: justify;">La expectativa de vida de un paciente con carcinomatosis es bastante limitada en comparación acuadros metastásicos a otros lugares distintos al peritoneo, pues la extensión de la membranaperitoneal afectada vuelve muy difícil por ejemplo extirpar la enfermedad en su totalidadquirúrgicamente y este tipo de cirugías está reservada para pocos expertos en la materia.</p><p style="text-align: justify;">La membrana peritoneal también muchas veces aísla los tumores distribuidos en su superficie, convirtiendo la cavidad abdominal en un verdadero santuario de difícil acceso a fármacos utilizados frecuentemente en el tratamiento contra el cáncer cuando estos se administran por vía sistémica (oral o endovenosa)2.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><font size="6"><b>&nbsp;Sobre los Tratamientos de la Carcinomatosis Peritoneal.</b></font></p><p style="text-align: justify;"><br></p><p style="text-align: justify;">La manera de abordar el tratamiento de la carcinomatosis peritoneal por lo general no tieneconsenso actualmente y evoluciona constantemente, eso sí se puede afirmar que las terapiassistémicas con fármacos, son la norma en la mayor parte de los casos , a pesar de que se conoce que el efecto de estas es bastante limitado en controlar las metástasis peritoneales, salvo quizás encáncer de ovario, aunque sobre este tipo de cáncer aún falta mucho por aclarar e investigar.</p><p style="text-align: justify;">Desde fines de la década de 1980, se ha ido imponiendo en el mundo la cirugía citorreductiva para la carcinomatosis como tratamiento de primera elección , la que es complementada con quimioterapia intraperitoneal hipertérmica (HIPEC) , siendo este tratamiento realizado en centros altamente especializados, con personal muy capacitado y con la tecnología adecuada, siendo factible en muchos casos incrementar la tasa global de sobrevida e incluso aumentar las probabilidades de curación de carcinomatosis bastante localizadas.</p><p style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366232/onkos-blog/onkos-blog/1757366231689-413855411.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></p><p style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366248/onkos-blog/onkos-blog/1757366247762-343511845.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></p><p style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366265/onkos-blog/onkos-blog/1757366265083-667106618.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></p><p style="text-align: justify;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366287/onkos-blog/onkos-blog/1757366287228-147855819.jpg" alt="" style="text-align: center; max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="544" height="454"></p><p style="text-align: center;"><br></p><p style="text-align: justify;">El problema principal de la cirugía citorreductora en carcinomatosis acompañada de quimioterapiahipertérmica intraperitoneal (HIPEC), es su complejidad, los escasos recursos médicos adiestradosen la técnica quirúrgica y las tasas elevadas de morbilidad (complicaciones derivadas delprocedimiento), pues la extensa y cruenta cirugía acompañada de la exposición de la membranaperitoneal y las superficies intestinales, así como de las vísceras intra-abdominales a laquimioterapia en altas dosis y elevada temperatura, tienen su lado negativo por lo traumático ytóxico del procedimiento en sí.</p><p style="text-align: justify;">La evolución de los tratamientos contra el cáncer y sus diversas manifestaciones es muy dinámica, yEl tratamiento de la carcinomatosis peritoneal es un campo que también está en continuo desarrollo.&nbsp;<span style="font-size: 1rem;">Desde principios de la década pasada, en vista a la cantidad creciente de casos de carcinomatosisevaluados en nuestra institución, es que iniciamos estudios de redescubrimiento y también pionerosen el tratamiento de esta manifestación oncológica, esto dio inicio al desarrollo y establecimiento denumerosos protocolos de tratamientos intraperitoneales basados principalmente no en técnicassofisticadas , poco accesibles y cruentas, sino más bien en procedimientos simples, sencillos,ambulatorios, con escasas complicaciones y toxicidad, y elevada tasa de control de lacarcinomatosis, a estas nuevas técnicas las denominamos TIPs (Terapias Intra Peritoneales ) TIPs.</span></p><p style="text-align: justify;"><b style=""><font size="6"><br></font></b></p><p style="text-align: justify;"><b style=""><font size="6">TIPs</font></b></p><p style="text-align: justify;"><b style=""><font size="3">¿Qué son TIPs?</font></b></p><p style="text-align: justify;"><span style="font-size: 1rem;">Son las siglas acuñadas en nuestra institución que significan sencillamente: <b>Terapias IntraPeritoneales.</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>¿En qué consiste una TIP?</b></span></p><p style="text-align: justify;">&nbsp;Una Terapia Intra-Peritoneal, como se describe en su propio nombre , consiste en la administraciónde tratamientos farmacológicos directamente a la cavidad peritoneal con la finalidad de controlar yerradicar la carcinomatosis peritoneal.</p><p style="text-align: justify;"><b>¿Cuáles son los fundamentos de las TIPs?</b></p><p style="text-align: justify;">&nbsp;El fundamento de una TIP, es básicamente el hecho de que estos tratamientos se basan en principiosfísicos y químicos bastante sencillos como la difusión y concentración de fármacos en una regiónespecífica , en esta caso en la cavidad abdominal, el peritoneo y los tumores en la superficie de esteúltimo.</p><p style="text-align: justify;"><span style="font-size: 1rem;">Para entender mejor los principios de una TIP, es importante mencionar que la mayor parte de lostratamientos farmacológicos para el control de un cáncer, tienen sus respectivas vías deadministración, siendo las más utilizadas la vía Parenteral (Endovenosa) y la vía Oral ,constituyéndose ambas en lo que denominamos en oncología como Terapias Sistémicas.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">&nbsp;El objetivo de administrar fármacos por estas vías, es alcanzar una concentración letal adecuada deestos en el interior de células neoplásicas agrupadas en clústeres tumorales en cualquier región delorganismo, partiendo de la suposición de que esto es posible de lograr utilizando la máxima dosistolerada de un fármaco o combinación de ellos cuando se administran por vía sistémica, y losfármacos supuestamente se distribuyen de manera homogénea en todos los tejidos y órganos delpaciente (Volumen de Distribución Aparente), lo cual obviamente no es así, estando supeditadorealmente el efecto farmacológico a múltiples variables, como la carga eléctrica, el peso molecular,la lipofilidad o hidrofilidad del fármaco, la perfusión del tejido tumoral dependiente de su irrigaciónsanguínea, la presencia de barreras fisicoquímicas a la difusión como la presencia de células notumorales, cemento intercelular alterado, presencia de diversos tipos de colágeno, etc.</span><span style="font-size: 1rem;">, esto sincontar con el metabolismo de los medicamentos que son muy variables de un paciente a otro debido a factores genéticos y/o patologías subyacentes (enfermedad hepática o renal ); es decir, el efecto de un fármaco administrado por vía sistémica, depende de muchas variables y frecuentemente no se logra el control adecuado de la enfermedad, no porque el o los medicamentos sean ineficaces, sino mas bien, porque no se logran concentraciones adecuadas de estos en el interior de los tumores ya sea porque las dosis no son suficientes o los fármacos son metabolizados rápidamente o los tumores se encuentran en santuarios que son muy difíciles de alcanzar por vía sistémica.</span></p><p style="text-align: justify;">Un problema limitante aparte de la incertidumbre de lograr concentraciones antineoplásicasadecuadas en el interior de las células tumorales por parte de las terapias sistémicas, es que las dosis utilizadas se encuentran en el limbo entre el efecto tóxico y el antitumoral, por lo que es muycomún en estas, tener complicaciones derivadas de efectos nocivos en células sanas de diversostejidos y órganos, es lo que llamamos comúnmente : Toxicidad inducida por Quimioterapia, yesta es muy dependiente de la dosis de los fármacos administrados; tal es así, que por lo general, eltratamiento de un cáncer con una terapia sistémica, se transforma en un verdadero ejercicio delograr un fino equilibrio entre el efecto citotóxico tumoral y tóxico para el organismo.&nbsp;<span style="font-size: 1rem;">Tomando en cuenta lo expuesto anteriormente, es en donde toman su lugar las TIPs&nbsp;</span></p><p style="text-align: center;"><br><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366349/onkos-blog/onkos-blog/1757366348905-579451839.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="600"><b></b></p><p style="text-align: center;"><b>La Carcinomatosis Peritoneal como un santuario.</b></p><p style="text-align: center;"><br></p><p style="text-align: justify;">Es conocido el hecho, ya sea por observaciones empíricas o por evidencia clínica bien asentada, queel tratamiento farmacológico de la carcinomatosis peritoneal por vía sistémica, muchas veces esdecepcionante y poco efectivo, por ejemplo, la expectativa de sobrevida en pacientes con cánceresde origen digestivo como cáncer de estómago, colon, páncreas y vías biliares que presentandiseminación peritoneal (carcinomatosis), es aproximadamente un 50% de la expectativa de vidafrente a la presentación metastásica fuera del peritoneo (Hígado o Pulmón por ejemplo), esto a pesar de instaurar las mismas terapias sistémicas, lo que nos dice que la enfermedad que afecta elperitoneo, posee características biológicas particulares , pero también que la barrera establecidaentre la superficie peritoneal y el espacio intravascular (barrera plasmático-peritoneal) es unaestructura compleja, difícil de traspasar por los medicamentos que fluyen por el torrente sanguíneo,no lográndose muchas veces, las concentraciones adecuadas de medicamentos en los focostumorales que yacen en la superficie peritoneal cuando se administran por vía sistémica, esto en síes un problema serio, ya que los focos de carcinomatosis están protegidos frecuentemente por estabarrera y encuentran un nicho óptimo para su progresión, constituyéndose la membrana peritoneal yla cavidad , en verdaderos nidos de proliferación, es lo que denominamos en oncología : SantuarioTumoral&nbsp;</p><p style="text-align: center;"><br></p><p style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366389/onkos-blog/onkos-blog/1757366388956-429386240.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b><font size="6">TIPs: La Evolución del Tratamiento de la Carcinomatosis</font></b></p><p style="text-align: justify;">Como anteriormente se expuso, el problema fundamental para lograr el éxito en el tratamiento de lacarcinomatosis peritoneal, es que existe una barrera que no permite lograr concentracionesadecuadas de fármacos en los tumores (la Barrera Plasmático-Peritoneal) cuando se administran por vía sistémica, por lo tanto es la vía de administración endovenosa u oral del o los fármaco(s), lalimitante principal para lograr un efecto antitumoral altamente efectivo, y aquí es donde la vía deadministración farmacológica intraperitoneal (TIP) cobra relevancia y se impone a las terapiassistémicas convencionales como el método de elección para tratar con medicamentos un cáncerlocalizado sobre el peritoneo.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">Las ventajas de las TIPs frente a las terapias convencionales son múltiples, sólo para mencionarlas y describirlas :&nbsp;</p><p></p><ol><li style="text-align: justify;"><span style="font-size: 1rem;">Las concentraciones de fármacos logradas en la cavidad peritoneal mediante una TIP, sobrepasanen un factor de 10 hasta 1000 de la AUC (Concentración Media Bajo la Curva) alcanzada por unaterapia sistémica, esta es la gran ventaja de una TIP, pues con ellas se logra evitar transitar por labarrera plasmático-peritoneal y la neoplasia es expuesta directamente en su superficie altratamiento, el cual, básicamente por difusión penetra al interior de los múltiples tumores enconcentraciones muy elevadas, logrando con este el primer objetivo : Que el o los fármacos,alcancenen cantidades suficientes y letales las células blanco.</span></li><li style="text-align: justify;">&nbsp;La cantidad de fármacos utilizadas en una TIP , es mucho menor a la utilizada sistémicamente, administrándose por lo general entre un 5% hasta un 50% de las dosis convencionales, no afectando por esto su eficacia, pero eso sí, disminuyendo notablemente los efectos adversos y tóxicos inducidos por un tratamiento sistémico.</li><li style="text-align: justify;">El control de la carcinomatosis es mucho más rápido que por la vía convencional, siendo que, lossíntomas relacionados con esta, disminuyen su intensidad a las pocas horas o días de iniciado eltratamiento (dolor, distensión abdominal, acumulación de líquido ascítico, tolerancia oral limitada, vómitos, estados pre-oclusivos, etcétera.<span style="font-size: 1rem;">) en la mayor parte de los casos, si las TIPs se instauran periódicamente, frecuentemente es posible un control a mediano y largo plazo del problema oncológico.</span></li><li style="text-align: justify;"><span style="font-size: 1rem;">Es posible instaurar un tratamiento de mantenimiento en casos especiales durante meses a años,en casos especiales y con una elevada probabilidad de recurrencia peritoneal, no siendo unalimitante la toxicidad farmacológica por la utilización de bajas dosis de fármacos.</span></li><li style="text-align: justify;">Las TIPs son flexibles y altamente adaptables.</li><li style="text-align: justify;">Efecto sobre metástasis y micrometástasis hepáticas y ganglionares concomitantemente,básicamente por la absorción portal y linfática intra-abdominal de los fármacos.</li><li style="text-align: justify;">Permite terapias adyuvantes bi-direccionales (sistémicas-intraperitoneales), en casos con elevada probabilidad de siembra peritoneal a parte de la visceral (cáncer de ovario post-citorreducción, carcinoma difuso gástrico, cáncer colorrectal ECIII, etc.)</li></ol><div style="text-align: justify;"><br></div><b style=""><div style="text-align: justify;"><b style="font-size: 1rem;"><font size="6">MODALIDADES Y APLICACIONES CLINICAS DE LAS TIPs</font></b></div></b><p></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>TIPs Multifarmacológicos: La Vanguardia del tratamiento de la Carcinomatosis</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Uno de los avances más notables en el tratamiento farmacológico de la carcinomatosis peritonealdesarrollados en ONKOS, es el de la conceptualización y aplicación de TIPs con varios fármacossimultáneamente, así como en los tratamientos sistémicos frecuentemente se practica lapolifarmacia en diversos esquemas terapéuticos, lo mismo es para las TIPs, así es posible efectossinérgicos de varios medicamentos, los cuales administrados secuencialmente al interior de lacavidad peritoneal ejercen efectos antineoplásicos muy potentes a dosis contenidas.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Una de las contribuciones más importantes ha sido el desarrollo de protocolos que incluyen no sóloquimioterapia, sino también terapias moleculares e inmunológicas intraperitoneales .</span></p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b>TIPs Moleculares&nbsp;</b></p><p style="text-align: justify;">La utilización de fármacos de última generación dirigidos a blancos específicos (terapiasmoleculares) solos, combinados entre ellos o junto a quimioterapia por la vía intraperitoneal, es lapráctica disruptiva, innovadora y única desarrollada a lo largo de la última década en nuestrainstitución, la cual lidera el conocimiento e investigación más avanzada sobre la aplicación defármacos de este tipo a nivel mundial.</p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>TIPs Inmunológicos</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Las terapias inmunológicas se han asentado de manera muy amplia en el tratamiento de diversoscánceres, siendo que, la carcinomatosis peritoneal tiene un microambiente inmunológico especial, lautilización de TIPs con fármacos de este tipo son un campo de desarrollo prometedor en casosespeciales.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>TIPs en Obstrucciones Intestinales</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">En su evolución, la carcinomatosis en fases avanzadas, es capaz de inducir complicaciones extremadamente graves y muy difíciles de tratar y revertir, siendo la más temida un cuadro conocido como cuadro obstructivo intestinal, el cual se caracteriza principalmente por la imposibilidad de lograr un tránsito adecuado de secreciones intestinales, el paso de alimentos, la eliminación de gases de la fermentación intestinal y la capacidad de defecar, pues la carcinomatosis es capaz de inducir una obstrucción total al pase del contenido digestivo – intestinal.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Las alternativas de tratamiento para esta complicación son muy limitadas, en algunos casos lacirugía puede ayudar a superar el problema, pero estos son pocos, lo cierto es que el pronóstico deun paciente con una obstrucción intestinal secundaria a carcinomatosis es ominoso, siendo muchasveces el preludio a un desenlace fatal en pocas semanas.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Las TIPs desarrolladas en ONKOS, son tratamientos con una elevada eficacia para tratar estacomplicación oncológica muy frecuente en estadíos avanzados de una carcinomatosis, lograndofrecuentemente lograr permeabilizar los segmentos intestinales afectados con TIPs intensivos.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>TIPs Adyuvantes</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Muchos cánceres digestivos y ginecológicos poseen un elevado potencial de desarrollarcarcinomatosis, por ejemplo las neoplasias epiteliales de ovario, el cáncer gástrico tipo difuso,cáncer de vías biliares y páncreas, así como el cáncer de colon.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">&nbsp;Al ser la cavidad peritoneal con su barrera plasmático-peritoneal muchas veces un nido deproliferación neoplásica frecuente y un potencial santuario, es conveniente tener en cuenta que lasterapias sistémicas administradas post-cirugía del foco primario, frecuentemente fracasan en suintención de erradicar micrometástasis peritoneales, debido precisamente a la incapacidad de estasde llegar en concentraciones adecuadas a estos puntos por las barreras descritas antes, por lo tanto,utilizar terapias intraperitoneales en pacientes de alto riesgo de desarrollo de carcinomatosis , es uncampo en continuo desarrollo y aplicación en nuestros pacientes.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>TIPs mas Terapia Sistémica : Terapia Bi-direccional</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">&nbsp;La implementación de TIPs junto a terapias sistémicas , es un campo en continuo desarrollo enONKOS, pues con ambos tipos de modalidades de tratamiento se busca incrementar la tasa decontrol de la enfermedad, ya sea en escenarios Adyuvantes (Post-Cirugía), Neo-Adyuvantes (PreCirugía) y como tratamiento de la enfermedad metastásica visceral y peritoneal.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">La mayor cobertura sistémica y locorregional de las terapias Bi-direccionales, hace de estamodalidad terapéutica la herramienta terapéutica más efectiva para el control de enfermedad en unacantidad notable de neoplasias malignas.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><p style="text-align: justify;"><b style=""><font size="6">&nbsp;SOBRE LA TÉCNICA</font></b></p><p style="text-align: justify;"><span style="font-size: 1rem;">La fortaleza más grande de las TIPs, es su simplicidad frente a otras alternativas de manejo decarcinomatosis como HIPEC o PIPAC por ejemplo, pues las TIPs no requieren infraestructuracompleja, ni fármacos especiales, las TIPs son sencillas de administrar, pues sólo se necesita lograruna vía de acceso a la cavidad peritoneal con un abocath de existir líquido ascítico o cuando el o lapaciente lo requiera implantar un catéter Port (de los usados para terapias parenterales oendovenosas ).</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Las TIPs son completamente ambulatorias y rápidas, los fármacos que se administran se diluyen enpequeños volúmenes de líquido diluyente .</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Las dosis de fármacos son mucho menores a las utilizadas por vía endovenosa o sistémica, por lotanto la toxicidad es muy baja y los efectos adversos mínimosExisten 2 escenarios que manejamos en ONKOS al administrar una TIP.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>CARINOMATOSIS CON ASCITIS</b></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Estos son los casos más frecuentes, cuando él o la paciente, desarrollan a consecuencia de lacarcinomatosis una complicación conocida como ascitis, que es la acumulación de un líquido ricoen proteínas dentro de la cavidad abdominal, en estos casos lo primero que se hace una evaluaciónecográfica del paciente para ver la posibilidad de administración del tratamiento, una vez evaluadoel paciente se escoge la zona abdominal para la punción, se procede a realizar la asepsia yantisepsia de la región donde se introducirá el Abocat, con guía ecográfica se procede a realizar laadministración de la anestesia local (lidocaína) , luego se procede a punzar con un abocat N* 14x51mm el cual se deja en cavidad peritoneal y se conecta a un equipo de venoclisis , a través del cualen primer lugar se evacua toda la cantidad de líquido ascítico que sea posible y luego se procede ala administración de los fármacos por la misma vía (quimioterapia, terapia molecular, y/oinmunoterapia) indicada por el médico oncólogo tratante.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">&nbsp;Luego de administrar la terapia seprocede a retirar el Abocat (trocar) y se procede a compresión del sitio de punción por 5minutos ,luego se limpia y se coloca una gasa limpia previa limpieza.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Posterior al tratamiento, el paciente queda en reposo y es movilizado en diferentes posiciones parauna distribución adecuada y amplia de los medicamentos administrados en la cavidad peritoneal.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Por lo general todo el procedimiento hasta que el paciente sale de sala de procedimeintos dura entre una a 4 horas, siendo eso sí completamente ambulatorio.</span></p><p style="text-align: justify;"><br><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366413/onkos-blog/onkos-blog/1757366413586-986541545.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="436" height="292"><span style="font-size: 1rem;"></span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Existen casos, en los cuales la acumulación de líquido en la cavidad abdominal no se produce o es muy escasa (Carcinomatosis Seca), siendo menester en estos casos para administrar la TIP colocar previamente un catéter port , habiendo desarrollado en ONKOS una técnica muy sencilla y accesible para estos casos, hay que tener en cuenta que el catéter port peritoneal se encuentra en el tejido celular subcutáneo por debajo de la piel y no se visualiza pero se puede palpar.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">En este caso se evalúa ecográficamente al paciente para verificar que no tenga líquido ascítico o sea muy escaso , si cumple este criterio se da una cita para la colocación de un catéter port peritoneal , este procedimiento se realiza en una sala especial de radiología intervencionista y realizado por un médico radiólogo oncólogo intervencionista y el procedimiento consiste primero en escoger la región de colocación del catéter Port que por lo general es en el Flanco Derecho.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Para el procedimiento se utiliza analgesia, la cual es dada por un médico anestesiólogo y no se necesita riesgo quirúrgico en pacientes menores de 60 años.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Primero se procede a anestesiar la zona de punción y a introducir el catéter con guía ecográfica y se corrobora que esté en cavidad peritoneal administrando contraste y verificando con fluoroscopia dado por equipo Arco en C, luego se procede a colocar el domo del catéter Port en el tejido celular subcutáneo de flanco derecho realizando un pequeño corte superficial en esa región, luego de colocar el domo en el tejido subcutáneo y de unirlo con el catéter se procede al cierre de la herida con 5 puntos pequeños con seda negra 3.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Se cubre la herida y una vez que el paciente despierta se puede retirar a su domicilio.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Luego de 3 días ya es factible iniciar la administración de la terapia peritoneal (TIP), en casos muy urgentes se puede aplicar al día siguiente por indicación del médico oncólogo tratante, el uso del catéter peritoneal para la administración de la TIP está a cargo del personal de enfermería especializado y bajo la supervisión del médico radiólogo oncólogo intervencionista y oncólogo, para llegar al catéter es necesario utilizar una aguja especial para punzar el catéter a través de la piel, una vez terminada la administración de la TIP, se procede a retirar la aguja y limpiar la zona y colocarle una pequeña gasa.</span></p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><br></p>\n	Terapias Intra Peritoneales – (TIPs)	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366124/onkos-blog/onkos-blog/1757366123552-583448864.jpg	\N	publicado	2025-08-12 20:52:46.054	\N	\N	{}	61	f	0	2025-08-12 20:52:46.054	2025-09-09 02:21:47.363	pagina	\N	\N
40	Servicio Onkos	casos	test			\N	publicado	2025-08-12 20:52:46.089	\N	\N	{}	12	f	0	2025-08-12 20:52:46.089	2025-09-19 21:47:19.672399	entrada	\N	\N
31	Servicio Onkos	cuello-uterino				\N	publicado	2025-08-12 20:52:46.071	\N	\N	{}	5	f	0	2025-08-12 20:52:46.071	2025-08-27 20:25:47.073	pagina	\N	\N
35	Servicio Onkos	carcinomatosis				\N	publicado	2025-08-12 20:52:46.079	\N	\N	{}	0	f	0	2025-08-12 20:52:46.079	2025-08-27 20:25:47.054	pagina	\N	\N
47	nosotros1	nosotros1	<p>Contenido final swerwee</p>	\N	\N	\N	publicado	\N	\N	\N	{}	13	f	0	2025-08-29 16:35:39.913	2025-08-29 18:41:15.233	pagina	\N	\N
7	Oncología Médica	oncologia-medica	El cáncer es una de las enfermedades más desafiantes y devastadoras de nuestro tiempo. Afecta a millones de personas en todo el mundo y ha dejado una huella profunda en la sociedad. Sin embargo, en medio de esta oscuridad, la Oncología Médica emerge como un rayo de esperanza y promete transformar la forma en que enfrentamos y tratamos esta enfermedad.<div><br><div>La Oncología Médica es una especialidad médica dedicada al estudio y tratamiento del cáncer. Su enfoque se basa en la comprensión de los mecanismos biológicos, moleculares y genéticos que impulsan el desarrollo y la propagación de las células cancerosas. Esta rama de la medicina se centra en el diagnóstico temprano, el tratamiento multidisciplinario y la atención integral del paciente durante todas las etapas de la enfermedad.</div><div><br></div><div>Una de las características más destacadas de la Oncología Médica es su enfoque integral. Los oncólogos médicos trabajan en estrecha colaboración con otros profesionales de la salud, como cirujanos, radioterapeutas, patólogos y especialistas en imagenología, para proporcionar un tratamiento coordinado y personalizado a cada paciente. Este enfoque multidisciplinario garantiza que se aborden todas las dimensiones del cáncer, desde la detección y el diagnóstico precisos hasta la planificación del tratamiento y el seguimiento a largo plazo.</div><div><br></div><div></div><div><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847181170-780953048.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="437"></div><div><br></div><div>El campo de la Oncología Médica ha experimentado avances significativos en los últimos años. La investigación científica y los avances tecnológicos han llevado al descubrimiento de terapias más efectivas y menos invasivas. La inmunoterapia, por ejemplo, ha revolucionado el tratamiento del cáncer al aprovechar el sistema inmunológico del paciente para combatir las células cancerosas. Además, la medicina de precisión ha permitido un enfoque más individualizado, basado en las características genéticas y moleculares del tumor de cada paciente.<span style="font-size: 1rem;">&nbsp;</span></div><div><br></div><div>La Oncología Médica no sólo se centra en el tratamiento del cáncer, sino también en la atención integral del paciente. Los oncólogos médicos comprenden la importancia de abordar los aspectos emocionales, sociales y psicológicos del cáncer, y trabajan en estrecha colaboración con psicólogos y trabajadores sociales para brindar apoyo integral a los pacientes y sus familias. Además, la investigación en oncología médica se enfoca en la prevención y detección temprana del cáncer, así como en el estudio de los factores de riesgo y la promoción de estilos de vida saludables.</div><div><br></div><div>En resumen, la Oncología Médica es una disciplina médica crucial en la lucha contra el cáncer. Con un enfoque integral y multidisciplinario, los oncólogos médicos se dedican a proporcionar el mejor cuidado posible a los pacientes con cáncer. Gracias a los avances científicos y tecnológicos, se están logrando avances significativos en el diagnóstico, tratamiento y supervivencia del cáncer. La Oncología Médica no solo ofrece tratamientos efectivos, sino que también brinda esperanza y apoyo a aquellos que se enfrentan a esta enfermedad desafiante.</div></div>		https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756846827646-921272917.jpg	\N	publicado	2025-08-13 01:52:46.017			{}	77	f	0	2025-08-12 20:52:46.017	2025-09-08 23:54:41.639	pagina	\N	\N
33	Linfoma de Hodgkin: Un Enfoque Integral – Onkos	linfoma	<p>Linfoma de Hodgkin: Un Enfoque Integral\n        \n            27 de September de 2024\n             | No Comments\n             | Artículos, Hablemos de cáncer, temas de interés</p>\n<p>¿Qué es el linfoma de Hodgkin?El linfoma de Hodgkin es un tipo de cáncer que afecta el sistema linfático, una parte fundamental del sistema inmunológico encargado de proteger al cuerpo contra infecciones y enfermedades. Se caracteriza por el crecimiento anormal de los linfocitos, un tipo de glóbulo blanco, que puede formar tumores en los ganglios linfáticos u otros tejidos.</p>\n<p>Tipos de linfoma de HodgkinExisten dos tipos principales de linfoma de Hodgkin:</p>\n<p>Linfoma de Hodgkin clásico: Es el tipo más común y representa aproximadamente el 95% de los casos. Dentro de este grupo hay varios subtipos, incluyendo:</p>\n<p>Esclerosis nodularCelularidad mixtaDepleción linfocíticaRico en linfocitos</p>\n<p>Linfoma de Hodgkin con predominio linfocítico nodular: Este tipo es menos común y afecta principalmente a los ganglios linfáticos en el cuello y la axila.</p>\n<p>Causas y factores de riesgoAunque las causas exactas del linfoma de Hodgkin no se conocen completamente, se han identificado ciertos factores de riesgo que pueden aumentar la probabilidad de desarrollar la enfermedad:</p>\n<p>Infección por el virus de Epstein-Barr (EBV): Este virus, que también causa la mononucleosis, se ha relacionado con algunos casos de linfoma de Hodgkin.Edad: El linfoma de Hodgkin afecta principalmente a personas entre los 15 y 35 años y a mayores de 55.Antecedentes familiares: Tener un familiar cercano con linfoma de Hodgkin puede aumentar el riesgo.Sistema inmunológico debilitado: Las personas con sistemas inmunológicos debilitados, como aquellas con VIH/SIDA o que han recibido un trasplante de órganos, están en mayor riesgo.SíntomasLos síntomas del linfoma de Hodgkin pueden variar según la ubicación del cáncer, pero los más comunes incluyen:</p>\n<p>Ganglios linfáticos inflamados en el cuello, axilas o ingles que no son dolorosos.Fatiga persistente.Pérdida de peso inexplicada.Sudores nocturnos.Fiebre sin una causa aparente.Picazón generalizada (prurito).Dolor en los ganglios linfáticos después de consumir alcohol (un síntoma raro pero característico).DiagnósticoPara diagnosticar el linfoma de Hodgkin, el oncólogo puede utilizar varias pruebas, entre las que se incluyen:</p>\n<p>Examen físico: Se revisarán los ganglios linfáticos inflamados y otros signos de la enfermedad.Biopsia: La prueba más definitiva es la extracción de una muestra de tejido de un ganglio linfático inflamado para buscar células anormales.Pruebas de imagen: Las tomografías computarizadas (TC), las resonancias magnéticas (RM) o las tomografías por emisión de positrones (PET) pueden ayudar a determinar la extensión del cáncer.Análisis de sangre: Pueden ayudar a evaluar el estado general de salud y la función de los órganos.TratamientoEl tratamiento del linfoma de Hodgkin ha avanzado significativamente, y las tasas de curación son altas. Las opciones de tratamiento incluyen:</p>\n<p>Quimioterapia: Es el tratamiento más común y consiste en el uso de medicamentos para destruir las células cancerosas en todo el cuerpo.</p>\n<p>Radioterapia: Utiliza rayos de alta energía para eliminar las células cancerosas en áreas específicas del cuerpo. Se suele usar en combinación con la quimioterapia.</p>\n<p>Inmunoterapia: Los avances recientes han permitido el desarrollo de tratamientos que utilizan el propio sistema inmunológico del paciente para combatir el cáncer.</p>\n<p>Trasplante de células madre: En casos avanzados o recurrentes, puede ser necesario un trasplante autólogo de células madre para restablecer el sistema inmunológico después de una quimioterapia de alta dosis.</p>\n<p>PronósticoEl linfoma de Hodgkin tiene uno de los pronósticos más favorables entre los cánceres. Las tasas de supervivencia a 5 años son muy altas, especialmente cuando se diagnostica en sus etapas iniciales. El tratamiento adecuado y a tiempo permite que la mayoría de los pacientes logren una remisión completa.</p>\n<p>Vigilancia y seguimientoDespués del tratamiento, es esencial realizar un seguimiento a largo plazo con el oncólogo. Esto incluye exámenes periódicos y pruebas de imagen para asegurarse de que el cáncer no haya regresado. La vida después del linfoma de Hodgkin puede ser saludable, pero se deben tener en cuenta los posibles efectos secundarios a largo plazo del tratamiento.</p>\n<p>ConclusiónEl linfoma de Hodgkin es un tipo de cáncer altamente tratable, con tasas de curación elevadas gracias a los avances en quimioterapia, radioterapia e inmunoterapia. La detección temprana y el tratamiento adecuado son clave para un pronóstico positivo. Si tienes algún síntoma o sospechas que podrías estar en riesgo, es importante consultar a un especialista en oncología lo antes posible.</p>\n<p>¿Qué es el linfoma de Hodgkin?El linfoma de Hodgkin es un tipo de cáncer que afecta el sistema linfático, una parte fundamental del sistema inmunológico encargado de proteger al cuerpo contra infecciones y enfermedades. Se caracteriza por el crecimiento anormal de los linfocitos, un tipo de glóbulo blanco, que puede formar tumores en los ganglios linfáticos u otros tejidos.</p>\n<p>Tipos de linfoma de HodgkinExisten dos tipos principales de linfoma de Hodgkin:</p>\n<p>Linfoma de Hodgkin clásico: Es el tipo más común y representa aproximadamente el 95% de los casos. Dentro de este grupo hay varios subtipos, incluyendo:</p>\n<p>Esclerosis nodularCelularidad mixtaDepleción linfocíticaRico en linfocitos</p>\n<p>Linfoma de Hodgkin con predominio linfocítico nodular: Este tipo es menos común y afecta principalmente a los ganglios linfáticos en el cuello y la axila.</p>\n<p>Causas y factores de riesgoAunque las causas exactas del linfoma de Hodgkin no se conocen completamente, se han identificado ciertos factores de riesgo que pueden aumentar la probabilidad de desarrollar la enfermedad:</p>\n<p>Infección por el virus de Epstein-Barr (EBV): Este virus, que también causa la mononucleosis, se ha relacionado con algunos casos de linfoma de Hodgkin.Edad: El linfoma de Hodgkin afecta principalmente a personas entre los 15 y 35 años y a mayores de 55.Antecedentes familiares: Tener un familiar cercano con linfoma de Hodgkin puede aumentar el riesgo.Sistema inmunológico debilitado: Las personas con sistemas inmunológicos debilitados, como aquellas con VIH/SIDA o que han recibido un trasplante de órganos, están en mayor riesgo.SíntomasLos síntomas del linfoma de Hodgkin pueden variar según la ubicación del cáncer, pero los más comunes incluyen:</p>\n<p>Ganglios linfáticos inflamados en el cuello, axilas o ingles que no son dolorosos.Fatiga persistente.Pérdida de peso inexplicada.Sudores nocturnos.Fiebre sin una causa aparente.Picazón generalizada (prurito).Dolor en los ganglios linfáticos después de consumir alcohol (un síntoma raro pero característico).DiagnósticoPara diagnosticar el linfoma de Hodgkin, el oncólogo puede utilizar varias pruebas, entre las que se incluyen:</p>\n<p>Examen físico: Se revisarán los ganglios linfáticos inflamados y otros signos de la enfermedad.Biopsia: La prueba más definitiva es la extracción de una muestra de tejido de un ganglio linfático inflamado para buscar células anormales.Pruebas de imagen: Las tomografías computarizadas (TC), las resonancias magnéticas (RM) o las tomografías por emisión de positrones (PET) pueden ayudar a determinar la extensión del cáncer.Análisis de sangre: Pueden ayudar a evaluar el estado general de salud y la función de los órganos.TratamientoEl tratamiento del linfoma de Hodgkin ha avanzado significativamente, y las tasas de curación son altas. Las opciones de tratamiento incluyen:</p>\n<p>Quimioterapia: Es el tratamiento más común y consiste en el uso de medicamentos para destruir las células cancerosas en todo el cuerpo.</p>\n<p>Radioterapia: Utiliza rayos de alta energía para eliminar las células cancerosas en áreas específicas del cuerpo. Se suele usar en combinación con la quimioterapia.</p>\n<p>Inmunoterapia: Los avances recientes han permitido el desarrollo de tratamientos que utilizan el propio sistema inmunológico del paciente para combatir el cáncer.</p>\n<p>Trasplante de células madre: En casos avanzados o recurrentes, puede ser necesario un trasplante autólogo de células madre para restablecer el sistema inmunológico después de una quimioterapia de alta dosis.</p>\n<p>PronósticoEl linfoma de Hodgkin tiene uno de los pronósticos más favorables entre los cánceres. Las tasas de supervivencia a 5 años son muy altas, especialmente cuando se diagnostica en sus etapas iniciales. El tratamiento adecuado y a tiempo permite que la mayoría de los pacientes logren una remisión completa.</p>\n<p>Vigilancia y seguimientoDespués del tratamiento, es esencial realizar un seguimiento a largo plazo con el oncólogo. Esto incluye exámenes periódicos y pruebas de imagen para asegurarse de que el cáncer no haya regresado. La vida después del linfoma de Hodgkin puede ser saludable, pero se deben tener en cuenta los posibles efectos secundarios a largo plazo del tratamiento.</p>\n<p>ConclusiónEl linfoma de Hodgkin es un tipo de cáncer altamente tratable, con tasas de curación elevadas gracias a los avances en quimioterapia, radioterapia e inmunoterapia. La detección temprana y el tratamiento adecuado son clave para un pronóstico positivo. Si tienes algún síntoma o sospechas que podrías estar en riesgo, es importante consultar a un especialista en oncología lo antes posible.</p>\n	Linfoma de Hodgkin: Un Enfoque Integral\n        \n            27 de September de 2024\n             | No Comments\n             | Artículos, Hablemos de cáncer, temas de interés	https://onkos.pe/wp-content/themes/mediclinic-pro/images/header-contact-1.png	\N	publicado	2025-08-12 20:52:46.075	\N	\N	{}	6	f	0	2025-08-12 20:52:46.075	2025-08-27 20:25:47.116	pagina	\N	\N
34	Servicio Onkos	mama				\N	publicado	2025-08-12 20:52:46.077	\N	\N	{}	0	f	0	2025-08-12 20:52:46.077	2025-08-27 20:25:47.099	pagina	\N	\N
41	Servicio Onkos	articulos				\N	publicado	2025-08-12 20:52:46.092	\N	\N	{}	5	f	0	2025-08-12 20:52:46.092	2025-08-27 18:54:26.398	pagina	\N	\N
38	Servicio Onkos	oxalaplatino				\N	publicado	2025-08-12 20:52:46.085	\N	\N	{}	0	f	0	2025-08-12 20:52:46.085	2025-08-27 20:25:47.11	pagina	\N	\N
39	Servicio Onkos	ciplatino				\N	publicado	2025-08-12 20:52:46.087	\N	\N	{}	3	f	0	2025-08-12 20:52:46.087	2025-08-27 20:25:47.112	pagina	\N	\N
32	Servicio Onkos	via-biliar				\N	publicado	2025-08-12 20:52:46.073	\N	\N	{}	5	f	0	2025-08-12 20:52:46.073	2025-08-27 20:25:47.106	pagina	\N	\N
18	Teleoncologia	teleoncologia				\N	publicado	2025-08-13 01:52:46.043	\N	\N	{}	10	f	0	2025-08-12 20:52:46.043	2025-09-02 23:10:22.498	pagina	\N	\N
25	Inmunoterapia Amplificada (ITA)	inmunoterapia-amplificada-ita	<p style="text-align: justify;">Despertar una respuesta inmunológica potente, que haga que las células defensivas de un paciente con cáncer, se conviertan en aliados eficaces para combatir las células cancerosas, es un anhelo ancestral en la terapia oncológica. A raíz de la aparición de nuevos fármacos como los Inhibidores del Punto de Control, las inmunoterapias cultivadas (T-CARTs) y otras, los tratamientos contra el cáncer han experimentado un notable salto en su evolución, tal es así, que actualmente se cuentan ya con muchos fármacos y protocolos de tratamiento inmunológico asentados y otros en investigación: la inmunoterapia vino para quedarse y convertirse en muchos casos el tratamiento de elección de primera línea.</p><p style="text-align: justify;">El problema radica en la accesibilidad de dichos tratamientos para muchos pacientes con escasos recursos económicos y por lo generosos que resultan en sus costos incluso para programas en salud que dependen del estado o seguros, sólo accediendo a ellos una pequeña porción de pacientes candidatos a estos tratamientos, siendo que, la mayor parte de personas que podrían ser beneficiados por estos fármacos, no acceden a ellos por lo elevado de su costo.</p><p style="text-align: justify;">¿Será posible utilizar estos medicamentos en pacientes con escasos recursos? ONKOS desarrolla investigación con aplicación clínica continua, utilizando dosis más bajas de Inhibidores de Puntos de Control por ejemplo, administrados localmente o sistémicamente, potenciando sus efectos con fármacos de otro tipo como quimioterapias, reposicionamientos o moduladores inmunológicos (muérdago, interferón, etc.).</p><p style="text-align: justify;">La ITA busca no sólo control local, sino también  sistémico, utilizando un tumor o zona , como un cebador para que el mismo organismo produzca células inmunológicas con capacidad específica de controlar la enfermedad, habiendo logrado en muchos casos respuestas impresionantes con controles duraderos de la enfermedad con esta técnica.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366736/onkos-blog/onkos-blog/1757366735756-691050773.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="1024" height="576"></p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366782/onkos-blog/onkos-blog/1757366782382-298896252.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="746" height="419"><br><p style="text-align: center;"><br></p>\n	Inmunoterapia Amplificada (ITA)\n\t\n\n\t\n\t\t\t\t\n\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t/*! elementor - v3.18.0 - 20-12-2023 */\n.elementor-widget-text-editor.elementor-drop-cap-view-stacked .elementor-drop-cap{backgroun...	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366850/onkos-blog/onkos-blog/1757366850007-400696760.jpg	\N	publicado	2025-08-12 20:52:46.059	\N	\N	{}	13	f	0	2025-08-12 20:52:46.059	2025-09-09 02:27:32.561	pagina	\N	\N
20	Terapia molecular Antálgica-  (TMA)	terapia-molecular-antalgica-tma	Uno de los avances más notables logrados en nuestra institución, gracias a investigaciones pioneras iniciadas a principios de la década pasada, es el descubrimiento y aplicación clinica de la Terapia Molecular Antálgica (TMA).<div><br></div><div>La TMA consiste en inﬁltrar en zonas gatillo (tumores) que disparan el dolor oncológico, un fármaco, un producto biológico (anticuerpo monoclonal), el cual ejerce potentes efectos analgésicos, y lo más importante de este sistema de tratamiento del dolor es su alta efectividad en el control de dolor severo, muchas veces con pobre respuesta a opiáceos potentes como la morﬁna o sus derivados.</div><div><br></div><div>Las tasas de control del dolor en casos refractarios o de muy difícil control, alcanzan el 80% en nuestra casuística, y lo que es más notable aún, es que en aquellos casos en donde la calidad de vida se ve deteriorada por dolor intratable o los efectos adversos de medicamentos administrados en dosis elevadas para poder controlarlo (opiáceos por ejemplo), la TMA viene a ser un bálsamo de alivio duradero y en algunos casos permanente, cuando es posible aplicarla.</div><div><br></div><div>La TMA, junto a otros sistemas de tratamiento, nos ha permitido en muchos casos prescindir o usar dosis muy pequeñas de medicamentos para tratar el dolor, los cuales muchas veces por sus efectos adversos o su capacidad de causar dependencia física, no son recomendables.</div><div><br></div><div>La Terapia Molecular Antálgica, es un desarrollo neto de ONKOS, un tratamiento de avanzada que sólo es aplicada en nuestra institución.</div><div><br><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366936/onkos-blog/onkos-blog/1757366935854-111273916.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="633"></div><div><br></div><div>La inmunoterapia intratumoral permite utilizar en casos especíﬁcos menos dosis de fármacos siendo en muchos casos más eﬁcaz, menos tóxica y mucho más coste/efectivo.</div><div><br></div><div>El origen del dolor oncológico implica la producción de citoquinas, mediadores moleculares, neuropéptidos; producidos tanto por las células neoplásicas como las células del estroma tumoral.</div><div><br></div><div>Nuestras investigaciones pioneras nos han llevado a una comprensión más avanzada del dolor oncológico, habiendo desarrollado nuevas terapias para el manejo y control de este, principalmente utilizando terapias moleculares avanzadas que permiten un control extraordinario del dolor inducido por tumores.</div><div><br></div><div>Esto es lo que nosotros llamamos TMA (Terapia Molecular Antálgica).</div>		https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366974/onkos-blog/onkos-blog/1757366973718-899971017.jpg	\N	publicado	2025-08-12 20:52:46.047	\N	\N	{}	27	f	0	2025-08-12 20:52:46.047	2025-09-09 02:29:36.427	pagina	\N	\N
12	Urología Oncológica	urologia-oncologica	<p style="text-align: justify;"><b><font size="6">Cuidando la Salud del Sistema Urinario en la Lucha contra el Cáncer</font></b></p><p style="text-align: justify;">El cáncer urológico es una preocupación importante en la salud de hombres y mujeres. En este contexto, la Urología Oncológica emerge como una rama especializada de la medicina que se dedica al estudio, diagnóstico y tratamiento de los cánceres que afectan el sistema urinario, incluyendo los riñones, la vejiga, la próstata, los testículos y otros órganos relacionados. La Urología Oncológica se enfoca en brindar atención integral y especializada a aquellos que enfrentan estos desafíos de salud.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">El sistema urinario juega un papel vital en nuestro cuerpo al eliminar los desechos y mantener un equilibrio adecuado. Sin embargo, cuando se presentan cánceres urológicos, es fundamental contar con especialistas altamente capacitados en Urología Oncológica. Estos profesionales están especialmente entrenados para comprender la anatomía, las funciones y las complejidades de los órganos urológicos, lo que les permite ofrecer una atención precisa y centrada en el paciente.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">Una de las características destacadas de la Urología Oncológica es su enfoque multidisciplinario. Los urólogos oncológicos trabajan en estrecha colaboración con otros especialistas, como oncólogos médicos, radioterapeutas y patólogos, para proporcionar una atención integral y coordinada a los pacientes. Este enfoque colaborativo permite una evaluación completa del caso y la formulación de un plan de tratamiento personalizado que se ajuste a las necesidades y características únicas de cada individuo.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">La detección temprana es clave en la lucha contra el cáncer urológico, y la Urología Oncológica se dedica a ello. Los urólogos oncológicos realizan exámenes y pruebas de detección periódicas para identificar cualquier signo de cáncer en sus etapas iniciales. Estos exámenes pueden incluir análisis de sangre, imágenes radiológicas y biopsias, entre otros. La detección temprana permite un tratamiento más efectivo y aumenta las posibilidades de curación.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">En términos de tratamiento, la Urología Oncológica ofrece diversas opciones terapéuticas. Esto puede incluir cirugía oncológica, que puede implicar la extirpación parcial o total del órgano afectado, así como técnicas de preservación de órganos cuando sea posible. Además, se utilizan técnicas de radioterapia y quimioterapia específicas para tratar el cáncer urológico y prevenir la propagación de las células cancerosas.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">La investigación y la innovación desempeñan un papel fundamental en la Urología Oncológica. Los avances científicos y tecnológicos continúan mejorando las opciones de diagnóstico y tratamiento en este campo. Desde técnicas quirúrgicas mínimamente invasivas hasta terapias dirigidas y tratamientos personalizados, los urólogos oncológicos están a la vanguardia de la investigación para brindar a los pacientes las mejores opciones de atención y mejorar los resultados en la lucha contra el cáncer urológico.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">En conclusión, la Urología Oncológica es una especialidad médica de vital importancia en la lucha contra el cáncer urológico. Los urólogos oncológicos desempeñan un papel crucial en el diagnóstico temprano, el tratamiento adecuado y el seguimiento de los pacientes con cáncer en el sistema urinario. Su enfoque multidisciplinario, combinado con su profundo conocimiento de la anatomía y las funciones urológicas, los convierte en expertos altamente capacitados en brindar una atención integral y personalizada.</p>\n	Urología Oncológica: Cuidando la Salud del Sistema Urinario en la Lucha contra el Cáncer\n\t\n\n\t\n\t\t\nEl cáncer urológico es una preocupación importante en la salud de hombres y mujeres. En este contexto,	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756850028153-857296133.jpg	\N	publicado	2025-08-13 11:52:46.031	\N	\N	{}	10	f	0	2025-08-12 20:52:46.031	2025-09-08 23:54:15.752	pagina	\N	\N
11	Gastro Oncología	gastro-oncologia	<p style="text-align: justify;"><font size="6"><b>Cuidando la Salud Digestiva en la Batalla contra el Cáncer</b></font></p>\n<p style="text-align: justify;">El cáncer gastrointestinal es una realidad que afecta a millones de personas en todo el mundo. Ante este desafío, la Gastro Oncología surge como una disciplina médica especializada en el estudio, diagnóstico y tratamiento de los cánceres que afectan el sistema digestivo. Desde el esófago hasta el intestino delgado y el colon, la Gastro Oncología se centra en brindar una atención integral y personalizada a aquellos que luchan contra estas enfermedades devastadoras.</p>\n<p style="text-align: justify;">El sistema digestivo es un componente vital de nuestro cuerpo y cualquier alteración en él puede tener un impacto significativo en nuestra salud. La Gastro Oncología se dedica a comprender y tratar los cánceres gastrointestinales en todas sus formas, incluyendo el cáncer de esófago, estómago, hígado, páncreas, intestino delgado y colon. Los gastroenterólogos oncológicos, expertos en esta área, tienen un profundo conocimiento de la anatomía y las funciones digestivas, así como de las últimas investigaciones y avances en el campo de la oncología.</p>\n<p style="text-align: justify;">Una de las fortalezas de la Gastro Oncología es su enfoque multidisciplinario. Los gastroenterólogos oncológicos trabajan en estrecha colaboración con otros especialistas médicos, como cirujanos, radiólogos, oncólogos médicos y patólogos, para proporcionar una atención integral y coordinada a los pacientes. Esta colaboración permite una evaluación completa del caso, lo que lleva a un diagnóstico preciso y a la formulación de un plan de tratamiento personalizado y eficaz.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756849887667-613782803.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="437"></p><p style="text-align: justify;"><br></p>\n<p style="text-align: justify;">La detección temprana es un pilar fundamental en la lucha contra el cáncer gastrointestinal, y la Gastro Oncología se enfoca en ello. Los gastroenterólogos oncológicos realizan exámenes de detección y pruebas diagnósticas para identificar cualquier anomalía o signo de cáncer en las etapas iniciales. Esto es crucial, ya que un diagnóstico temprano puede permitir un tratamiento más efectivo y mejores resultados para los pacientes.</p>\n<p style="text-align: justify;">En términos de tratamiento, la Gastro Oncología utiliza una amplia gama de enfoques, desde la cirugía y la radioterapia hasta la quimioterapia y la terapia dirigida. Los gastroenterólogos oncológicos evalúan cuidadosamente cada caso y diseñan un plan de tratamiento individualizado que tenga en cuenta las características específicas del paciente y el tipo de cáncer gastrointestinal presente. Además, también se centran en el manejo de los efectos secundarios del tratamiento y en la calidad de vida del paciente durante todo el proceso.</p>\n<p style="text-align: justify;">La investigación y la innovación son elementos clave en el campo de la Gastro Oncología. Los avances científicos y tecnológicos continuos están transformando la forma en que se diagnostica y trata el cáncer gastrointestinal. Desde nuevas técnicas de imagen hasta terapias más precisas y personalizadas, los gastroenterólogos oncológicos se mantienen al tanto de los últimos avances para brindar a sus pacientes las mejores opciones de tratamiento disponibles.</p>\n<p style="text-align: justify;">En resumen, la Gastro Oncología es una especialidad médica esencial en la batalla contra el cáncer gastrointestinal. Los gastroenterólogos oncológicos son expertos en el diagnóstico, tratamiento y seguimiento de los cánceres que afectan el sistema digestivo. Su enfoque multidisciplinario, combinado con su profundo conocimiento de la anatomía y la función digestiva, los convierte en profesionales altamente capacitados para brindar una atención integral y personalizada a los pacientes con cáncer gastrointestinal.</p>\n	Gastro Oncología\n\t\n\n\t\n\t\t\nGastro Oncología: Cuidando la Salud Digestiva en la Batalla contra el Cáncer\n\n\n\nEl cáncer gastrointestinal es una realidad que afecta a millones de personas en todo el mundo.	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756848286971-453295638.jpg	\N	publicado	2025-08-13 01:52:46.028	\N	\N	{}	13	f	0	2025-08-12 20:52:46.028	2025-09-08 23:54:40.667	pagina	\N	\N
9	Radiología Oncológica	radiologia-oncologica	<p style="text-align: justify;">La Imagen que Revela el Camino hacia la Cura</p><p style="text-align: justify;">En la lucha contra el cáncer, la precisión y el conocimiento son esenciales. Para descubrir los secretos ocultos en el interior del cuerpo humano y guiar el tratamiento adecuado, la Radiología Oncológica se ha convertido en una herramienta indispensable. Esta especialidad médica se centra en el uso de imágenes y técnicas avanzadas de diagnóstico por imagen para detectar, diagnosticar y tratar el cáncer de manera precisa y eficiente.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">La Radiología Oncológica utiliza diversas modalidades de imagen, como la radiografía, la tomografía computarizada (TC), la resonancia magnética (RM), la ecografía y la medicina nuclear, para capturar imágenes detalladas del cuerpo humano. Estas imágenes revelan información crucial sobre la presencia de tumores, su tamaño, ubicación y su relación con los órganos circundantes.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">Una de las características más destacadas de la Radiología Oncológica es su capacidad para proporcionar un diagnóstico temprano y preciso. Las técnicas de imagen avanzadas permiten detectar tumores en sus etapas iniciales, cuando aún no son visibles a simple vista ni causan síntomas evidentes. Esto es fundamental, ya que un diagnóstico temprano puede marcar la diferencia en la efectividad del tratamiento y en el pronóstico del paciente.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847770431-283768737.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="560"></p><p style="text-align: justify;"><br></p><p style="text-align: justify;">Además del diagnóstico, la Radiología Oncológica desempeña un papel fundamental en la planificación y el seguimiento del tratamiento. Las imágenes radiológicas ayudan a determinar la extensión del cáncer, evaluar la respuesta al tratamiento y ajustar las estrategias terapéuticas en función de los cambios observados. Esto permite a los médicos personalizar el tratamiento para cada paciente, maximizando la efectividad y minimizando los efectos secundarios.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">La Radiología Oncológica también es esencial en la guía de los procedimientos de intervención mínimamente invasivos. Los radiólogos intervencionistas utilizan técnicas de imagen en tiempo real, como la tomografía computarizada guiada por imágenes (TCGI) y la ecografía, para dirigir y realizar biopsias de tumores, ablaciones y otras intervenciones terapéuticas. Estos procedimientos minimizan el trauma para el paciente y aceleran la recuperación.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">Con los avances tecnológicos y científicos en constante evolución, la Radiología Oncológica ha experimentado una revolución en los últimos años. El desarrollo de la imagenología molecular ha permitido una mayor precisión en la detección y caracterización de tumores. Además, la fusión de imágenes multimodales y la inteligencia artificial han mejorado la capacidad de los radiólogos para interpretar las imágenes, identificar patrones sutiles y brindar diagnósticos más precisos.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">Es importante destacar que la Radiología Oncológica no solo se trata de imágenes y tecnología, sino también de la colaboración multidisciplinaria. Los radiólogos oncológicos trabajan en estrecha colaboración con oncólogos médicos, cirujanos, patólogos y otros especialistas para proporcionar una atención integral al paciente. Juntos, combinan su experiencia y conocimientos para establecer un enfoque integral en el diagnóstico, tratamiento y seguimiento del cáncer.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;">En conclusión, la Radiología Oncológica es una disciplina médica crucial en la lucha contra el cáncer. A través de las imágenes radiológicas, los radiólogos oncológicos desvelan los misterios ocultos dentro del cuerpo humano y guían el camino hacia la cura. Su capacidad para el diagnóstico temprano, la planificación del tratamiento y el seguimiento preciso es fundamental en la batalla contra el cáncer.</p>\n	Radiología Oncológica\n\t\n\n\t\n\t\tRadiología Oncológica: La Imagen que Revela el Camino hacia la Cura\nEn la lucha contra el cáncer, la precisión y el conocimiento son esenciales. Para descubrir los secreto...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847701942-8563384.jpg	\N	publicado	2025-08-13 01:52:46.023	\N	\N	{}	17	f	0	2025-08-12 20:52:46.023	2025-09-08 23:54:42.268	pagina	\N	\N
46	Test Update	test-update	<p>Test content</p>	\N	\N	\N	publicado	\N	\N	\N	{}	17	\N	0	2025-08-29 16:03:35.632	2025-08-29 16:32:27.042	entrada	\N	\N
45	Prueba de Contenido	prueba-de-contenido	<p>Este es un contenido de prueba</p>	\N	\N	\N	publicado	\N	\N	\N	{}	3	\N	0	2025-08-29 16:02:06.021	2025-08-29 16:02:06.021	entrada	\N	\N
48	Test	test	<p>Test</p>	\N	\N	\N	publicado	\N	\N	\N	{}	9	\N	0	2025-08-29 16:38:36.012	2025-08-29 16:40:19.049	entrada	\N	\N
6	Nosotros	nosotros	<h2><font size="7" style="">¿QUÉ ES ONKOS?</font></h2>\n<p style="text-align: justify;"><font size="3">Onkos Instituto del Cáncer, es una institución médica dedicada exclusivamente al tratamiento e investigación del cáncer. Desde el año 2003 ha atendido miles de casos oncológicos hasta la actualidad, con una tasa de éxito aún en enfermedades avanzadas, muy superior al de otras instituciones.Onkos ha construido su reputación gracias a su filosofía fundamental : "El Cáncer es una enfermedad individual y su tratamiento como tal debe de ser siempre personalizado", y ese ha sido el estandarte de Onkos: "Terapias altamente personalizadas."&nbsp;</font></p><p style="text-align: justify;"><font size="3">La experiencia ganada enfrentando los casos más difíciles, y gracias a la elevada calidad de nuestros profesionales con su altos estándares de preparación oncológica, han hecho de nuestra institución un centro de referencia, atendiendo muchos casos provenientes de diversas regiones de nuestro país y el extranjero.</font></p><p style="text-align: justify;"><font size="3">Sabemos muy bien que el cáncer es una enfermedad cada vez más frecuente, conforme la población envejece y la expectativa de vida de las personas se incrementa, el cáncer es un problema de salud que se acrecienta en números y exige rapidez, calidad y accesibilidad en cuanto a diagnóstico y atención oportuna se refiere, es por esto, debido a las necesidades de la población más necesitada de contar con servicios oncológicos de alta calidad, que Onkos ha desarrollado diversos programas y modalidades terapéuticas, para volver accesibles sus tratamientos a toda la población.</font></p><p style="text-align: justify;"><font size="3">Onkos, es una institución comprometida con las personas de toda condición social y económica, pues sabemos que el cáncer no discrimina y exige muchos recursos en su tratamiento, pero para nosotros no solo basta tratar la enfermedad, sino significa volver accesibles los tratamientos altamente sofisticados y de altísima calidad incluso a las personas de menos recursos</font></p><p style="text-align: justify;"><b style="font-size: 1rem;"><font size="6">Misión</font></b></p>\n<p style="text-align: justify;">Brindar a los pacientes, programas de Tratamiento Oncológico Personalizados, manteniendo como esencia el trato humano. Para ello, dirigimos un equipo de profesionales con altos estándares en preparación oncológica los cuales desarrollan diversos sistemas, terapias y procedimientos prolijamente personalizados, logrando así revalorizar el rol terapéutico del contacto humano.</p>\n<p style="text-align: justify;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756500364592-647737067.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="602"></p><p style="text-align: justify;"><b style="font-size: 1rem;"><font size="6"><br></font></b></p><p style="text-align: justify;"><b style="font-size: 1rem;"><font size="6">Visión</font></b></p>\n<p style="text-align: justify;">Ser líderes en el Tratamiento Oncológico Altamente Personalizado.</p>\n<p style="text-align: justify;"><b><font size="6">Valores</font></b></p>\n<p></p><ul><li style="text-align: justify;">Humanidad y sensibilidad\nfrente a \npacientes oncológicos.&nbsp;</li><li style="text-align: justify;">Liderar el Tratamiento\nPersonalizado Oncológico.</li><li style="text-align: justify;">Honestidad y Transparencia en nuestros servicios.</li><li style="text-align: justify;">Innovación permanente\nen búsqueda de nuevos</li><li style="text-align: justify;">Tratamientos Oncológicos\n\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tCompromiso en brindar\nservicios de alta calidad.</li><li style="text-align: justify;">Liderar el Tratamiento\nPersonalizado Oncológico.&nbsp;</li></ul><p></p><p style="text-align: justify;"><b style=""><font size="6" face="Arial">Infraestructura y equipamiento&nbsp;</font></b></p><p style="text-align: justify;">En su esfuerzo por hacer llegar nuestros sistemas de tratamiento y diagnóstico rápido, Onkos ha crecido en sus instalaciones y equipamiento, para esto hemos invertido en salas de tratamiento implementadas con monitores multiparamétricos para cada paciente, farmacia oncológica especializada, Unidad de Mezclas Oncológicas con cabinas de flujo laminar de clase IIB2 y IIA, sala de procedimientos, sala de radiología implementada con ecógrafos de última generación, consultorios amplios y equipados, laboratorio clínico – molecular, etc., para que los pacientes se sientan cómodos y seguros, sin que esto signifique costos de clínica del primer mundo.</p><p style="text-align: justify;"><br></p><table class="editor-table" style="border-collapse: collapse; width: 100%; border: 1px none rgb(209, 213, 219); position: relative;" data-events-configured="true"><tbody><tr><td style="padding: 8px; border: 1px none rgb(209, 213, 219);">&nbsp;<img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501052856-139548566.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);">&nbsp;&nbsp;<img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501059964-973797745.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);">&nbsp;&nbsp;<img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501068468-484202460.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td></tr></tbody></table><p style="text-align: justify;"><font size="6"><b>Sala de procedimientos&nbsp;</b></font></p><p style="text-align: justify;">Nuestra sala de procedimientos está altamente equipada, cuenta con un ecógrafo, camillas, balones y los utensilios necesarios para realizar procedimientos guiados, biopsias, tratamientos intraperitoneales e intratumorales entre otros. Por mencionar un ejemplo, este espacio nos permite tratar a pacientes con carcinomatosis, a los cuales podemos aplicarles una o varias sesiones de paracentesis para aliviar su dolor</p><table class="editor-table" style="border-collapse: collapse; width: 100%; border: 1px none rgb(209, 213, 219); position: relative;" data-events-configured="true"><tbody><tr><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502465873-966010864.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502498634-621057934.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502477148-902505090.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td></tr></tbody></table><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b style="font-size: 1rem;"><font size="6">Sala de infusiones y Quimioterapia&nbsp;</font></b></p><p style="text-align: justify;"><span style="font-size: 1rem;">Contamos con un equipo médico especializado para una atención personalizada con monitores multiparámetro, que permiten evaluar minuto a minuto la frecuencia cardiaca y otros signos vitales y una atención constante por parte de nuestro staff de enfermeros. Como parte de nuestro tratamiento personalizado a cada paciente, nuestras quimioterapias administradas son preparadas en nuestra Unidad de Mezclas Oncológicas (UMO)\t</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><table class="editor-table" style="border-collapse: collapse; width: 100%; border: 1px none rgb(209, 213, 219); position: relative;" data-events-configured="true"><tbody><tr><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502578106-328874609.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502590054-368025015.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; float: left; margin: 0px 10px 10px 0px;" class="editor-image" data-editable="true" width="300" height="300"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502639391-881407490.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td></tr></tbody></table><p style="text-align: justify;"><b style="font-size: xx-large;">UMO – Unidad de Mezclas Oncológicas</b></p><p style="text-align: justify;"><span style="font-size: 1rem;">&nbsp;Formulamos, preparamos y controlamos las mezclas de medicamentos citotóxicos, nutricional parenteral y otros para las quimioterapias de nuestros pacientes oncológicos, garantizando un tratamiento altamente personalizado que nos ayudará a luchar contra el cáncer.\t</span></p><table class="editor-table" style="border-collapse: collapse; width: 100%; border: 1px none rgb(209, 213, 219); position: relative;" data-events-configured="true"><tbody><tr><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502801706-365909920.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502834039-156620452.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502849051-375859867.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td></tr></tbody></table><p style="text-align: justify;"><b style="font-size: xx-large;">Onkos Pharma&nbsp;</b></p><p style="text-align: justify;"><span style="font-size: 1rem;"><a href="https://onkospharma.pe/" target="_blank" style="cursor: pointer;">OnkosPharma</a>&nbsp;es el soporte adecuado para proveer todos los medicamentos que serán utilizados a lo largo del tratamiento oncológico del paciente.</span></p>\n<p></p><ul><ul><ul><ul><ul><ul><ul><ul><ul><ul><ul><ul><ul><ul><ul><li style="text-align: justify;">Medicamentos altamente calificados para el tratamiento oncológico.</li><li style="text-align: justify;"><span style="font-size: 1rem;">Nutracéuticos a base de fibra – Caral Biotec.&nbsp;</span></li><li style="text-align: justify;"><span style="font-size: 1rem;">Entrega inmediata de medicamentos.&nbsp;</span></li><li style="text-align: justify;">Servicio delivery de medicamentos.<b style="color: rgb(71, 85, 105); font-size: xx-large;">&nbsp;</b></li></ul></ul></ul></ul></ul></ul></ul></ul></ul></ul></ul></ul></ul></ul></ul><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><table class="editor-table" style="border-collapse: collapse; width: 100%; border: 1px none rgb(209, 213, 219); position: relative;" data-events-configured="true"><tbody><tr><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756503629080-876113186.jpg" alt="" class="editor-image" data-editable="true" style="max-width: 100%; height: auto; cursor: pointer;"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756503615703-585096701.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td><td style="padding: 8px; border: 1px none rgb(209, 213, 219);"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756503641412-486339692.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></td></tr></tbody></table><p style="text-align: justify;"><font size="6"><b>Consultorios</b></font></p><p style="text-align: justify;"><span style="font-size: 1rem;">Ambientes cómodos y privados que cuentan con el equipamiento adecuado para cada consulta especializada según sea el caso.</span></p><p style="text-align: justify;"><b style="font-size: 1rem;"><font size="6">Staff Médico</font></b></p><p style="text-align: justify;"><b style="font-size: 1rem;"><font size="6">Xecuenxia</font></b><span style="font-size: 1rem;">&nbsp;</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Laboratorio de Genómica y Biología Molecular especializado en el diagnóstico e investigación Oncológica, Microbiológica y Genética.En la actualidad, la ciencia ha evolucionado en las diferentes técnicas de Biología Molecular, que estudia el comportamiento biológico de las macromoléculas dentro de la célula y las funciones biológicas del ser vivo a nivel molecular.Por ello, contamos con la tecnología adecuada en nuestro laboratorio. El cual está especialmente diseñado para la realización de una amplia gama de pruebas moleculares para la detección de patógenos que afectan al ser humano obteniendo resultados de calidad y confianza.</span></p>\n	¿QUÉ ES ONKOS?	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756846604008-485730174.jpg	\N	publicado	2025-08-18 06:52:46.012			{}	171	f	0	2025-08-12 20:52:46.012	2025-09-08 23:54:42.604	pagina	\N	\N
8	ONCOLOGÍA QUIRÚRGICA	oncologia-quirurgica	<h2 style="text-align: justify;">La Precisión y el Arte de Combatir el Cáncer</h2><div style="text-align: justify;">El cáncer es una enfermedad compleja que requiere una variedad de enfoques médicos para su tratamiento efectivo. Entre estas disciplinas se encuentra la Oncología Quirúrgica, una especialidad médica que se centra en el diagnóstico, la extirpación y el tratamiento quirúrgico de los tumores cancerosos. Con su enfoque preciso y habilidades quirúrgicas expertas, los oncólogos quirúrgicos desempeñan un papel vital en la lucha contra el cáncer.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">La Oncología Quirúrgica se basa en la premisa fundamental de que el cáncer puede ser eliminado a través de la intervención quirúrgica. Los oncólogos quirúrgicos están altamente capacitados en técnicas quirúrgicas avanzadas y utilizan instrumentos especializados para realizar procedimientos precisos en áreas afectadas por tumores malignos. Estos profesionales no solo se centran en la extirpación del tumor, sino también en preservar la función y la calidad de vida del paciente.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">Una de las principales fortalezas de la Oncología Quirúrgica es su capacidad para proporcionar un diagnóstico preciso y temprano del cáncer. Mediante la realización de biopsias y otros procedimientos diagnósticos, los oncólogos quirúrgicos pueden obtener muestras de tejido y evaluar su naturaleza maligna. Esto es crucial para determinar el alcance del cáncer y planificar el tratamiento adecuado.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">Además de la extirpación del tumor, los oncólogos quirúrgicos también desempeñan un papel crucial en la estadificación del cáncer. Esto implica determinar la etapa en la que se encuentra el cáncer y si se ha propagado a otras áreas del cuerpo. Esta información es fundamental para diseñar un plan de tratamiento integral que puede incluir cirugía adicional, quimioterapia, radioterapia u otras modalidades de tratamiento.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">La Oncología Quirúrgica también se enfoca en la cirugía reconstructiva posterior a la extirpación del tumor. Después de la cirugía oncológica, los oncólogos quirúrgicos trabajan en colaboración con otros especialistas, como cirujanos plásticos y reconstructivos, para restaurar la apariencia y la función de las áreas afectadas. Esto puede incluir la reconstrucción mamaria después de una mastectomía o la reconstrucción facial después de la extirpación de un tumor en la cabeza y el cuello.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">Es importante destacar que la Oncología Quirúrgica no se trata solo de habilidades técnicas y precisión quirúrgica, sino también de un enfoque integral hacia el paciente. Los oncólogos quirúrgicos trabajan en estrecha colaboración con otros profesionales de la salud, como oncólogos médicos, radioterapeutas y especialistas en cuidados paliativos, para brindar un cuidado integral y multidisciplinario. Su objetivo es mejorar la calidad de vida de los pacientes, no solo durante la cirugía, sino también en el proceso de recuperación y seguimiento a largo plazo.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">En conclusión, la Oncología Quirúrgica desempeña un papel crucial en la lucha contra el cáncer. Los oncólogos quirúrgicos son verdaderos héroes en la batalla contra el cáncer, combinando su destreza quirúrgica con un enfoque compasivo hacia los pacientes. Su trabajo va más allá de la extirpación del tumor, ya que también se dedican a la investigación y el desarrollo de nuevas técnicas quirúrgicas y tratamientos innovadores.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;"><br></div><div><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847540014-974625123.jpg" alt="" style="text-align: justify; max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="560"></div><div style="text-align: justify;"><br></div><div style="text-align: justify;"><br></div><div style="text-align: justify;">En los últimos años, la Oncología Quirúrgica ha experimentado avances significativos gracias a los avances tecnológicos. La cirugía mínimamente invasiva, por ejemplo, ha revolucionado el campo al permitir procedimientos menos invasivos, con incisiones más pequeñas y tiempos de recuperación más rápidos. La cirugía robótica también ha ganado popularidad en la Oncología Quirúrgica, ya que proporciona a los cirujanos una mayor precisión y control durante los procedimientos.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">Además, la colaboración entre los oncólogos quirúrgicos y otros especialistas ha llevado a enfoques más integrados en el tratamiento del cáncer. La terapia neoadyuvante, por ejemplo, implica la administración de tratamientos como quimioterapia o radioterapia antes de la cirugía para reducir el tamaño del tumor y facilitar su extirpación. Esto ha demostrado ser efectivo en numerosos casos y ha mejorado los resultados quirúrgicos.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">La Oncología Quirúrgica también se está expandiendo hacia la prevención y detección temprana del cáncer. Los oncólogos quirúrgicos desempeñan un papel importante en la identificación de personas con alto riesgo de desarrollar cáncer y en la realización de procedimientos preventivos, como la extirpación de pólipos en el colon o la extirpación profiláctica de tejido mamario en casos de alto riesgo de cáncer de mama.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">Es fundamental destacar que cada paciente es único y requiere un enfoque personalizado. Los oncólogos quirúrgicos consideran cuidadosamente las características individuales del paciente, como su estado de salud general, la ubicación y el tamaño del tumor, así como sus preferencias personales, para desarrollar un plan de tratamiento óptimo. Además, el apoyo emocional y psicológico durante todo el proceso es fundamental, y los oncólogos quirúrgicos trabajan en colaboración con otros profesionales de la salud para brindar el apoyo necesario tanto al paciente como a sus seres queridos.</div><div style="text-align: justify;"><br></div><div style="text-align: justify;">En resumen, la Oncología Quirúrgica representa la fusión de la precisión quirúrgica y el cuidado integral en la lucha contra el cáncer. Los oncólogos quirúrgicos desempeñan un papel vital en el diagnóstico, la extirpación del tumor y la reconstrucción posterior a la cirugía, al tiempo que brindan apoyo emocional a los pacientes y sus familias. A medida que la ciencia y la tecnología avanzan, esta especialidad continúa evolucionando y mejorando, prometiendo un futuro más esperanzador en la batalla contra el cáncer.</div>\n	ONCOLOGÍA QUIRÚRGICA\n\t\n\n\t\n\t\tLa Oncología Quirúrgica: La Precisión y el Arte de Combatir el Cáncer\nEl cáncer es una enfermedad compleja que requiere una variedad de enfoques médicos para su tratamiento...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847304681-143541002.jpg	\N	publicado	2025-08-13 06:52:46.02	\N	\N	{}	29	f	0	2025-08-12 20:52:46.02	2025-09-08 23:54:42.434	pagina	\N	\N
28	Vitamina C	vitamina-c	<p style="text-align: justify;"><font size="6"><b>Megadosis Vitamina C</b></font></p><p style="text-align: justify;"><br><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367134/onkos-blog/onkos-blog/1757367134463-916392719.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="300" height="525"></p><p style="text-align: justify;">Askor Life, es una corporación dedicada a la utilización, investigación y aplicación clínica de la administración de altas dosis de Vitamina C por vía endovenosa (Megadosis).</p><p style="text-align: justify;">Askor Life viene trabajando desde al año 2016 en el Perú, habiendo aplicado hasta la fecha en su infusorio principal, ubicado en la ciudad de Lima, más de 30 mil dosis de Vitamina C en pacientes afectados de dive<span style="font-size: 1rem;">rs</span><span style="font-size: 1rem;">as patolog</span><span style="font-size: 1rem;">ías y en personas que desean preservar un óptimo estado de salud.</span></p><p style="text-align: justify;">Askor Life, utiliza exclusivamente en sus infusiones Ascor L500, una vitamina C ultrapurificada , elaborada en EEUU por Mc Guff Pharmaceutical, siendo la única vitamina C en el mundo que posee aprobación y soporte por la FDA norteamericana, lo que habla de la calidad de nuestro producto.</p><p style="text-align: justify;">Askor Life, por el momento cuenta con 2 Infusorios de Vitamina C ( Ascor L500), uno ubicado en Lima y otro recientemente implementado en la ciudad de Huancayo, estando dentro de sus planes implementar otros infusorios en otras provincias del Perú.</p><p style="text-align: justify;">Es importante acotar , que la filosofía de AskorLife, es brindar el servicio completo de administración de Megadosis de vitamina C, pues para infundir soluciones con elevadas concentraciones de ácido ascórbico, se requiere una infraestructura adecuada y personal capacitado, a parte claro está de un producto de alto grado de pureza y calidad como lo es nuestro Ascor L500.</p><p style="text-align: justify;">Los infusorios de ASKORLIFE, son la garantía de que las personas que requieran tratamiento con megadosis de vitamina C, obtendrán la garantía, calidad de servicio y personalización al máximo de su tratamiento respectivo.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b>ASCOR L500</b></p><p style="text-align: justify;">Ascor L500 , es la vitamina C que utilizamos de manera exclusiva en ASKOR LIFE, ya que nuestra vitamina C es producida con los estándares de calidad más altos en el mundo por la compañía McGuff, la cual está situada en la localidad de Santa Ana-California (Estados Unidos)</p><p style="text-align: justify;">Ascor L500, es la única vitamina C libre de preservantes en su presentación, lo que habla de su pureza , es por esto que Ascor L500 es transportada desde la planta original a otros lugares del mundo bajo estrictas medidas de cuidado del producto, manteniendo una adecuada cadena de frío, pues la termolabilidad de la vitamina C pura es conocida.</p><p style="text-align: justify;">Otras vitaminas C en el mercado, poseen preservantes y aditivos, y se encuentran en la forma de Ascorbatos que no requieren cadena de frío, por lo que es importante hacer resaltar esta diferencia, a mayor cantidad de preservativos, menos pureza y potencia del producto.</p><p style="text-align: justify;">Ascor L500 , viene en presentaciones únicas de frascos de 25 gramos ( concentración de 500mg/mL Fcos. 50ML )</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b>MEGADOSIS</b></p><p style="text-align: justify;">La megadosis de vitamina C, se refiere al usos de cantidades suprafisiológicas para lograr efectos que de ninguna manera pueden lograrse a las dosis convencionales como suplemento común, normalmente al hablar de MEGADOSIS, nos referimos a la administración por vía endovenosa de varios gramos de Vitamina C en dosis única o aplicada frecuente y periódicamente, esto con el objetivo de lograr efectos en el organismo que de ninguna manera se pueden lograr mediante la administración por vía oral, la cual solo es capaz de aportar al organismo unos cuantos miligramos insuficientes para obtener todos los beneficios de esta sustancia.</p><p style="text-align: justify;">La vitamina C es un cofactor esencial para el funcionamiento de varias enzimas del organismo, debiendo conocerse que los seres humanos no son capaces de sintetizarla en sus células, a diferencia de muchos mamíferos que si tienen esta capacidad, por la tanto su suplementación frecuente y a dosis adecuadas, es vital para asegurar el funcionamiento celular óptimo en las personas.</p><p style="text-align: justify;">La dosis mínima recomendada oscila entre unos 60 a 100 mg., de vitamina C diariamente, siendo que dicha cantidad se alcanza fácilmente con el consumo ciertos vegetales y frutas frescas, algunas de las cuales son muy ricas en ácido ascórbico, no siendo necesario suplemento alguno para las personas que consumen regular y frecuentemente estos alimentos, tal es así, que en la actualidad, es difícil observar personas con deficiencias severas de aporte de vitamina c, salvo en lugares en donde la desnutrición crónica y la pobreza abundan y se desarrollan cuadros clínicos o subclínicos del déficit de esta sustancia vital.</p><p style="text-align: justify;"><span style="font-size: 1rem;">Las dosis antes mencionadas, de aproximadamente 1mg/kg de peso, se aplican en el caso de querer evitar desarrollar escorbuto, una enfermedad grave a consecuencia de déficits marcados del consumo de mínimas o nulas cantidades de vitamina C, pero hay que hacer notar que para que un organismo funciones de manera óptima, se requieren aportes mucho mayores de vitamina C, ya que esta es vital para el funcionamiento del sistema inmunológico, en la reparación de tejidos, como barredor de radicales libres, como agente quelante, para una producción adecuada de interferón, cortisol y glutatión, en fin , la vitamina C, posee efectos pleiotrópicos que la convierten en una de las sustancias más importantes para la salud humana.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">Es conocido el hecho de que bajo condiciones de stress intenso , mamíferos , como las cabras, son capaces de sintetizar hasta 100 gramos de ácido ascórbico en un día y animales como las ratas pueden producir hasta 15 gramos , los seres humanos, al no ser capaces de sintetizar vitamina C en su organismo, requieren una suplementación adicional significativamente mayor que las recomendadas para enfrentar situaciones estresantes diversas que comprometan su integridad física y psicológica (enfermedades, traumatismos, problemas psicológicos, etc.), y es aquí en donde toma su rol el concepto de MEGADOSIS de Vitamina C.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">El año 1753, fecha en la cual el Dr. James Lind, médico de la naval de Escocia realizó un famoso experimento con 12 pacientes severamente enfermos de escorbuto, notando que en aquellos a los cuales les hizo consumir naranjas y limones, lograron recuperarse rápidamente en el lapso de unos días, este experimento marcó un antes y un después en el tratamiento de una enfermedad grave y muchas veces mortal llamada ESCORBUTO , la cual afectaba a los marineros en sus largas travesías, debido al aporte nulo de vitamina C en sus alimentos (la fuente principal de ácido ascórbico son ciertas frutas y vegetales frescos)</span></p><p style="text-align: justify;"><span style="font-size: 1rem;">En 1928, el Dr. Albert Szent-Gyorgy descubrió la vitamina C, lo cual le valió el premio Nobel en 1937. Ilustres hombres de ciencia, como Reichstein y Haworth, quienes sintetizaron y utilizaron por vez primera la vitamina C, el Dr. Junglebut , quien experimentó con dosis altas de vitamina C en el tratamiento de la poliomielitis en monos de laboratorio logrando reducir la severidad de la enfermedad, el Dr.Frederick Klenner, que en 1948, publicó sus estudios sobre el uso de megadosis de vitamina C en el  tratamiento de enfermedades virales, el cual es considerado del pionero de las dosis altas de vitamina C como tratamiento, y muchos nombres de científicos y médicos, son los responsables de que actualmente la Vitamina C en altas dosis (Megadosis), sea una herramienta terapeútica muy tomada en cuenta en la actualidad para tratar diversas dolencias.</span></p><p style="text-align: justify;">Hay un nombre que resalta sobre muchos otros, principalmente por la magnitud de su obra que fué reconocida por 2 premios Nobel a los que se hizo acreedor : Linus Pauling, premio Nobel de Química en 1954 y Premio Nobel de la Paz en 1962, fue Pauling, quien erigió a la Vitamina C administrada en altas dosis , como una terapia prometedora en el tratamiento de enfermedades tan letales como el Cáncer, y debido a su influencia de talla mundial, su trabajo ayudó a que las investigaciones sobre la Vitamina C en altas dosis fuera tomada muy en cuenta por la comunidad científica y médica.</p><p style="text-align: justify;">Se podría seguir nombrando a otros científicos y médicos, lo cierto es que en la actualidad las MEGADOSIS de vitamina C, vienen siendo investigadas y aplicadas en diferentes partes del mundo y hay un interés renovado por posicionarla como una herramienta fundamental en el tratamiento de diversas enfermedades y un suplemento excepcional para preservar un óptimo estado de salud.</p><p style="text-align: justify;"><span style="font-size: 1rem;">Las dosis que se consideran como MEGADOSIS, como se mencionó anteriormente, deben superar las dosis recomendadas ampliamente a las dosis como agente anti- escorbuto, (60-100mg/día), estamos hablando de dosis que van desde 0.5gr a 2 – 4gr por Kg., de peso corporal/día, siendo que por vía oral hay una limitante para la absorción de estas dosis masivas , el uso de las infusiones de Vitamina C al no tener la barrera intestinal como limitante, es la forma que se recomienda para la administración de MEGADOSIS, ya que la vía endovenosa permite escalar dosis sin los problemas de intolerancia y absorbilidad cuando se intenta administrarla por vía oral.</span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><br></span></p><p style="text-align: justify;"><span style="font-size: 1rem;"><b>INFUSORIO</b></span></p><p style="text-align: justify;">Para la adecuada administración de MEGADOSIS de Vitamina C, ASKORLIFE, ha instalado una infraestructura adecuada y tiene personal altamente capacitado en el área médica como enfermería para guiar y administrar los tratamientos de acuerdo a las necesidades particulares de cada persona o paciente, es lo que nosotros denominamos INFUSORIO.</p><p style="text-align: justify;">Las preparaciones de MEGADOSIS de Vitamina C, se preparan bajo estrictas medidas de calidad , en un ambiente adecuado (Unidad de Mezclas ), la cual posee 2 cabinas de flujo laminar de clase IIB2, para garantizar la pureza, dosis y asepsia de nuestras infusiones.</p><p style="text-align: justify;">ASKORLIFE tiene muy en claro que la administración de MEGADOSIS de Vitamina C, es un ejercicio médico muy serio y profesional, por lo tanto garantizamos el cuidado médico adecuado de las personas que toman nuestro servicio de infusión y monitorizamos su tratamiento a lo largo del tiempo cuando esto es necesario.</p><p style="text-align: justify;">En ASKORLIFE,tiempo de infusión , la dosis necesaria, los períodos de tratamiento son individualizados, y nuestras instalaciones cómodas y amplias nos permiten atender la demanda de quines buscan tratamiento o soporte con MEGADOSIS de Vitamina C.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b>INDICACIONES</b></p><p style="text-align: justify;">Las indicaciones de MEGADOSIS de Vitamina C, son muy vastas, estando actualmente la aplicación clínica de esta en pleno proceso de investigación y desarrollo.</p><p style="text-align: justify;">Patologías como el Cáncer, Diabetes, Osteoporosis, Osteoartrosis, Fibrosis Pulmonar, Cirrosis, Infecciones Virales, Intoxicación por metales pesados, problemas neurodegenerativos, patologías del sistema nervioso, enfermedades cardiovasculares, quemaduras, cirugías, patología deportiva etc., son campos en donde la administración de altas dosis de vitamina C, ofrece beneficios importantes.</p><p style="text-align: justify;">También las indicaciones de MEGADOSIS se aplican en campos como el antienvejecimiento, medicina estética, y en toda persona que valora su salud en general como un agente de soporte excepcional para no caer en la enfermedad y preservar un estado de homeostasis adecuado frente a tanto evento estresante que afecta a las personas en su día a día , mas aún en estos tiempos.</p><p style="text-align: justify;"><br></p><p style="text-align: justify;"><b>LOCALES</b></p><p style="text-align: justify;">En este momento , ASKORLIFE cuenta con 2 Infusorios, uno ubicadoe en la ciudad de Lima Av. Brasil 3621 Magdalena del Mar y otro en la Ciudad de Huancayo, estando dentro de sus planes el desarrollar otros infusorios en diversas provincias de nuestro país.</p>\n	Vitamina C 	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367113/onkos-blog/onkos-blog/1757367113036-79390507.jpg	\N	publicado	2025-08-12 20:52:46.064	\N	\N	{}	49	f	0	2025-08-12 20:52:46.064	2025-09-09 02:32:37.638	pagina	\N	\N
10	Ginecología Oncológica	ginecologia-oncologica	<p><font size="6"><b>Cuidando la Salud Femenina en la Lucha contra el Cáncer</b></font></p><p>La salud femenina es un aspecto fundamental en la sociedad actual, y cuando se trata de la lucha contra el cáncer, la Ginecología Oncológica desempeña un papel crucial. Esta rama de la medicina se dedica al estudio, diagnóstico y tratamiento de los cánceres ginecológicos, que afectan los órganos reproductores femeninos, como el útero, los ovarios, el cuello uterino, la vulva y la vagina. La Ginecología Oncológica se centra en brindar atención integral y especializada a las mujeres que enfrentan estos desafíos.</p><p><br></p><p>El cáncer ginecológico es una preocupación importante en la salud de las mujeres, y la Ginecología Oncológica se dedica a abordar estas enfermedades de manera precisa y efectiva. Los ginecólogos oncológicos están altamente capacitados y especializados en el diagnóstico temprano, la estadificación precisa y el tratamiento adecuado de los cánceres ginecológicos. Su experiencia y conocimientos les permiten brindar una atención integral y centrada en la mujer.</p><p><br></p><p>Una de las fortalezas de la Ginecología Oncológica es su enfoque preventivo y de detección temprana. Los ginecólogos oncológicos realizan exámenes y pruebas de detección periódicas para identificar cualquier anomalía o signo de cáncer ginecológico en sus etapas iniciales. Esto permite un diagnóstico temprano y brinda mayores oportunidades de tratamiento exitoso y mejores resultados para las pacientes.<span style="font-size: 1rem;">&nbsp;</span></p><p><br></p><p>Además del diagnóstico, los ginecólogos oncológicos están capacitados en una variedad de tratamientos para el cáncer ginecológico. Estos pueden incluir cirugía oncológica, que puede implicar la extirpación parcial o total de los órganos afectados, así como la eliminación de ganglios linfáticos cercanos. También pueden utilizar técnicas de radioterapia y quimioterapia para combatir las células cancerosas y prevenir la propagación del cáncer.<span style="font-size: 1rem;">&nbsp;</span></p><p><br></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756848136687-740545194.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="560"></p><p><br></p><p>La Ginecología Oncológica se preocupa no solo por el tratamiento médico, sino también por el bienestar general de las pacientes. Los ginecólogos oncológicos se esfuerzan por brindar apoyo emocional y psicológico a las mujeres que enfrentan un diagnóstico de cáncer ginecológico. Comprenden los desafíos únicos que las pacientes pueden enfrentar y trabajan en colaboración con otros profesionales de la salud para proporcionar una atención integral y centrada en la mujer.</p><p><br></p><p>Es importante destacar que la Ginecología Oncológica no solo se trata de la enfermedad en sí, sino también de la calidad de vida de las pacientes. Los ginecólogos oncológicos se enfocan en la preservación de la fertilidad, cuando es posible, y en abordar los aspectos sexuales y reproductivos que pueden verse afectados por el tratamiento del cáncer. Su objetivo es brindar una atención integral que tenga en cuenta las necesidades y deseos únicos de cada paciente.<span style="font-size: 1rem;">&nbsp;</span></p><p><br></p><p>En resumen, la Ginecología Oncológica es una disciplina médica especializada en la prevención, detección temprana, diagnóstico y tratamiento de los cánceres ginecológicos. Los ginecólogos oncológicos son expertos en brindar atención integral a las mujeres que enfrentan estos desafíos, ofreciendo tratamientos personalizados y centrados en la paciente.</p>\n	Ginecología Oncológica\n\t\n\n\t\n\t\t\t\t\n\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t/*! elementor - v3.18.0 - 20-12-2023 */\n.elementor-widget-text-editor.elementor-drop-cap-view-stacked .elementor-drop-cap{background-color:#...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847910193-638936747.jpg	\N	publicado	2025-08-13 01:52:46.026	\N	\N	{}	13	f	0	2025-08-12 20:52:46.026	2025-09-08 23:54:41.48	pagina	\N	\N
42	Servicio Onkos	fotovideoteca	Test			\N	publicado	2025-08-12 20:52:46.094			{}	43	f	0	2025-08-12 20:52:46.094	2025-09-19 20:44:31.740337	entrada	\N	\N
44	Servicio Onkos	estadisticas-onkos	qr			\N	publicado	2025-08-27 18:43:57.315	\N	\N	{}	11	f	0	2025-08-27 18:43:57.315	2025-09-19 21:40:01.342657	entrada	\N	\N
21	Inmunoterapia	inmunoterapia	<p>El tratamiento de algunos tipos de cáncer con medicamentos o técnicas en donde el sistema inmunológico es activado, potenciado o modiﬁcado, está permitiendo lograr el control de neoplasias malignas durante períodos de tiempo mucho más prolongados, así la sobrevida de pacientes que se proyectaba a algunos meses y/o incluso semanas, se ha extendido por años en muchos de ellos. Los inhibidores de puntos de control, por ejemplo, son fármacos que permiten que el sistema inmunológico ataque el cáncer, permitiendo así de esta manera lograr respuestas muchas veces dramáticas.La revolución del tratamiento del cáncer se da día a día, continuamente, el hecho de conocer y manejar estos fármacos es mandatorio para todo oncólogo con conocimientos avanzados y en ONKOS, contamos con los profesionales que guiarán a sus pacientes en la elección del tratamiento más correcto.</p><p>Contamos con sistemas de inmunoterapia localizada, a bajas dosis, para optimizar costos y disminuir toxicidades. Por ejemplo, en tumores como los melanomas, aplicamos terapias inmunológicas localizadas y las ampliﬁcamos (ITA) para poder lograr el control más eﬁcaz de la enfermedad, a la vez que optimizamos los recursos económicos del paciente.</p><p>La investigación de cómo volver accesibles estos tratamientos a los pacientes que buscan un tratamiento eﬁcaz para su cáncer, se ha convertido en un campo de desarrollo nuevo para nuestra institución, pues en ONKOS tenemos el compromiso para que aún los pacientes con menos recursos, accedan a tratamientos de última generación, siempre y cuando así lo amerite.</p><p><br></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362269/onkos-blog/onkos-blog/1757362268865-263749187.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="600" height="380"></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362297/onkos-blog/onkos-blog/1757362297107-638806033.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="600" height="290"></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362322/onkos-blog/onkos-blog/1757362321888-524479282.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="600" height="332"></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362361/onkos-blog/onkos-blog/1757362361482-824173100.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="600" height="330"></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362402/onkos-blog/onkos-blog/1757362402024-393378860.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="450"></p><p><br></p>\n	Inmunoterapia\n\t\n\n\t\n\t\t\t\t\n\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t/*! elementor - v3.18.0 - 20-12-2023 */\n.elementor-widget-text-editor.elementor-drop-cap-view-stacked .elementor-drop-cap{background-color:#69727d;co...	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362696/onkos-blog/onkos-blog/1757362695370-220402254.jpg	\N	publicado	2025-08-12 20:52:46.049	\N	\N	{}	32	f	0	2025-08-12 20:52:46.049	2025-09-09 01:18:18.366	pagina	\N	\N
50	Terapia dinamica adaptativa	terapia-dinamica-adaptativa	<div><b style="font-size: xx-large;"></b></div><b style="font-size: xx-large;">Un enfoque evolutivo para el control del cáncer</b><div><font size="6"><b><br></b></font><div style="text-align: justify;"><span style="font-size: medium;">La oncología moderna enfrenta un desafío recurrente: aunque los tratamientos convencionales como la quimioterapia, la radioterapia y las terapias dirigidas logran respuestas iniciales favorables, con frecuencia los tumores desarrollan resistencia y provocan recaídas. Este fenómeno ocurre porque el tumor no es estático, sino que evoluciona bajo la presión de los tratamientos. La estrategia clásica de aplicar la dosis máxima tolerada puede, en algunos casos, favorecer la supervivencia de clones celulares resistentes que terminan dominando la población tumoral.</span></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">En este contexto surge la Terapia Dinámica Adaptativa (TDA), también conocida como adaptive therapy, un enfoque innovador que busca controlar al tumor a largo plazo en lugar de eliminarlo completamente desde el inicio. El principio central de la TDA es utilizar la competencia ecológica entre células tumorales sensibles y resistentes. En lugar de eliminar todas las células sensibles, se procura mantener una población suficiente de estas que limite el crecimiento de las resistentes, modulando las dosis de tratamiento o incorporando pausas estratégicas conocidas como “treatment holidays”.</font></div><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520358/onkos-blog/onkos-blog/1759520357256-306589453.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="400" height="218"><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">El fundamento biológico detrás de esta estrategia es que las células resistentes suelen pagar un “costo de resistencia”: en ausencia del fármaco, suelen ser menos competitivas que las células sensibles. Mantener vivas a las células sensibles permite que compitan con las resistentes y eviten que estas últimas dominen rápidamente el tumor. La TDA se apoya en modelos matemáticos, teoría de juegos evolutivos y biomarcadores dinámicos que permiten ajustar las decisiones clínicas según la evolución individual de cada paciente.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">La evidencia científica está en crecimiento. Estudios preclínicos han demostrado que al adaptar las dosis de agentes como el carboplatino en modelos de cáncer de ovario, se logra prolongar el control tumoral y retrasar la aparición de resistencia. A nivel clínico, investigaciones en cáncer de páncreas han mostrado que la quimioterapia perioperatoria adaptada según biomarcadores (como el antígeno CA19-9) y la respuesta histopatológica se asocia con una mejor supervivencia global. Además, centros de investigación como el Moffitt Cancer Center están utilizando modelos matemáticos y biomarcadores dinámicos para caracterizar la enfermedad metastásica durante TDA, lo que abre camino hacia una implementación más precisa y personalizada.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520515/onkos-blog/onkos-blog/1759520514749-100616038.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="437"><font size="3"></font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Entre las principales ventajas de la Terapia Dinámica Adaptativa se destacan la posibilidad de prolongar el tiempo de control tumoral, reducir la toxicidad acumulada al evitar dosis máximas constantes y retrasar la aparición de resistencia. Sin embargo, también existen limitaciones importantes. La TDA requiere monitoreo frecuente, decisiones clínicas precisas y no todos los tumores responden igual a este enfoque, especialmente si la resistencia tiene un bajo costo evolutivo o la heterogeneidad celular es muy amplia. Asimismo, aún hacen falta ensayos clínicos comparativos a gran escala que definan los protocolos ideales para implementar esta estrategia en la práctica oncológica rutinaria.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">El futuro de la Terapia Dinámica Adaptativa se vislumbra prometedor. La integración de inteligencia artificial, modelado predictivo y medicina de precisión permitirá individualizar aún más las decisiones. También se estudia la posibilidad de combinar la TDA con inmunoterapia y terapias dirigidas, buscando sinergias que potencien el control tumoral. Otro aspecto clave será definir algoritmos claros que indiquen cuándo reducir, detener o reiniciar la terapia, así como establecer protocolos de monitoreo basados en biomarcadores dinámicos confiables.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Desde un punto de vista clínico y ético, la Terapia Dinámica Adaptativa plantea un cambio de paradigma que debe comunicarse claramente a los pacientes. No se busca necesariamente erradicar por completo el tumor desde el inicio, sino convivir con él bajo un control prolongado que permita mantener la calidad de vida y retrasar la progresión. Esto supone un reto en la relación médico-paciente, pero también abre la posibilidad de repensar el objetivo del tratamiento oncológico hacia una estrategia más sostenible en el tiempo.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">En conclusión, la Terapia Dinámica Adaptativa representa una evolución en la forma de pensar y tratar el cáncer. Al aplicar principios de la biología evolutiva y la ecología tumoral, propone que a veces “menos es más” en oncología. Aunque aún enfrenta desafíos para consolidarse en la práctica clínica, sus fundamentos científicos y resultados iniciales justifican la investigación continua y la colaboración entre oncólogos, biólogos, matemáticos y especialistas en modelado. Este enfoque invita a reconsiderar los límites del paradigma tradicional de máxima intensidad terapéutica, con el objetivo de alcanzar un control más duradero y personalizado de la enfermedad.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Referencias recomendadas:</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Gatenby RA et al. “Adaptive Therapy”. PMC.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">West J, Adler F, Gallaher J, Strobl M, et al. “A survey of open questions in adaptive therapy”. eLife.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">AlMasri S, et al. “Adaptive Dynamic Therapy and Survivorship for Operable Pancreatic Cancer”. JAMA Network Open.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Zhang L, et al. “A tumor therapy strategy based on Darwinian evolution”. ScienceDirect.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Hockings H, et al. “Adaptive Therapy Exploits Fitness Deficits in Chemotherapy”. Cancer Research.</font></div><div style="text-align: justify;"><font size="3"><br></font></div><div style="text-align: justify;"><font size="3">Gallagher K, Strobl MA, Anderson A, et al. “Deriving Optimal Treatment Timing for Adaptive Therapy”. Bulletin of Mathematical Biology.</font></div></div>		https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520432/onkos-blog/onkos-blog/1759520431390-130686868.jpg	\N	publicado	\N			[]	15	f	0	2025-10-03 19:42:11.486451	2025-10-03 19:43:04.330004	pagina	\N	\N
24	Terapias Intratumorales (TITS)	terapias-intratumorales-tits	<p>Las terapias intratumorales, son utilizadas en casos específicos, especialmente cuando se trata de controlar localmente una lesión o inducir una respuesta inmunológica potente partiendo desde una infiltración tumoral local. La utilización de diferentes fármacos como Quimioterapias, Terapias Moleculares e Inmunoterapias localizadas, es un campo de aplicación clínica e investigación en ONKOS, y son utilizadas frecuentemente en casos de muy difícil manejo, en donde incluso tratamientos de última generación han fracasado, eso sí, la aplicación de dichas técnicas debe cumplir con requisitos específicos.</p><p>El control locorregional sin inducir toxicidad o a mínima toxicidad, es muchas veces preferible, especialmente cuando se trata de casos en los cuales el paciente está sumamente debilitado por la enfermedad y/o  tratamientos previos, grandes tumores con una masa e inercia muy grande, son extremadamente difíciles de controlar con terapias sistémicas o radioterapia, por lo que la aplicación de tratamientos localmente, infiltrando diferentes fármacos a tumores de gran tamaño, permiten concentraciones locales de fármacos, los cuales por difusión ejercen potentes efectos antitumorales. La utilización de terapias moleculares intratumorales, permiten respuestas más rápidas localmente, siendo posible combinar e infiltrar tratamientos multi-farmacológicos para tratar un tumor.</p><p><br><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366646/onkos-blog/onkos-blog/1757366646269-124675792.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="500" height="514"></p>\n	Terapias Intratumorales (TITS)\n\t\n\n\t\n\t\t\t\t\n\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t/*! elementor - v3.18.0 - 20-12-2023 */\n.elementor-widget-text-editor.elementor-drop-cap-view-stacked .elementor-drop-cap{background...	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366572/onkos-blog/onkos-blog/1757366572120-626301270.jpg	\N	publicado	2025-08-12 20:52:46.057	\N	\N	{}	15	f	0	2025-08-12 20:52:46.057	2025-09-09 02:24:19.347	pagina	\N	\N
26	Moleculares	moleculares	<p style="text-align: justify;">El crecimiento explosivo de terapias moleculares, está causando una revolución en el tratamiento del cáncer, así, fármacos como los inhibidores de Tirosin Kinasas, que ejercen potentes efectos inhibitorios sobre proteínas con funciones que exacerban los procesos de proliferación, son utilizados actualmente para el tratamiento de diversas neoplasias malignas, siendo que, para un manejo inteligente y racional de estos medicamentos, el oncólogo debe de estar muy capacitado y ser conocedor de los detalles del funcionamiento e indicaciones de muchos de estos fármacos, la ONCOLOGÍA MOLECULAR, es el campo en donde se estudian y entienden los procesos fundamentales de la proliferación, diseminación y crecimiento tumoral, este conocimiento viene siendo explotado y aplicado a través del desarrollo de diversos fármacos que apuntan a blancos específicos como los mencionados.</p><p style="text-align: justify;">El desarrollo de anticuerpos monoclonales, producidos mediante ingeniería genética y luego validados como terapias efectivas para bloquear el crecimiento de un cáncer, es un vasto y enorme campo de investigación y aplicación clínica continua, la verdadera revolución se viene escribiendo día tras día con la validación de grandes estudios multicéntricos en la utilización de estas novedosas terapias dirigidas.</p><p style="text-align: justify;">Conocer los detalles del funcionamiento, de cómo utilizar estos fármacos, solos, junto a otros  tratamientos como la quimioterapia o inmunoterapia, actualmente se constituye en un reto enorme para un profesional de la oncología, lo que exige experiencia, actualización continua y habilidades innatas para poder entramar, elaborar muchas veces terapias sumamente complejas para poder enfrentar un cáncer cuando las posibilidades estén al alcance y se tenga al paciente que así lo requiera.</p><p style="text-align: justify;">El estudio de la genética del tumor es muchas veces imprescindible para poder indicar una terapia dirigida y para esto ONKOS cuenta con el apoyo de XECUENXIA, el laboratorio molecular para estudiar genomas y mutaciones específicas en los tumores malignos.</p><p><br><div style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757361004/onkos-blog/onkos-blog/1757361003615-350288388.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></div></p>\n	Terapia Molecular Antálgica (TMA)\n\t\n\n\t\n\t\t\t\t\n\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t/*! elementor - v3.18.0 - 20-12-2023 */\n.elementor-widget-text-editor.elementor-drop-cap-view-stacked .elementor-drop-cap{backgro...	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360914/onkos-blog/onkos-blog/1757360913963-143067473.jpg	\N	publicado	2025-08-12 20:52:46.06	\N	\N	{}	24	f	0	2025-08-12 20:52:46.06	2025-09-09 00:50:30.71	pagina	\N	\N
13	Onkos humano	onkos-humano	<div style="text-align: justify;"><span style="font-size: 1rem;">El programa Humano de ONKOS, pone a aquellos pacientes de escasos recursos la mayor parte de los servicios, el conocimiento y los tratamientos contra el cáncer que ONKOS ha desarrollado con sus expertos a través de los años.</span></div><div style="text-align: justify;">El cáncer no discrimina, es más, los sectores socioeconómicos de escasos recursos son los más afectados por esta peste, tal es así que padecer cáncer con carencias económicas , resta posibilidades a muchos pacientes a que accedan a tratamientos de calidad y guía oncológica de alto nivel, ONKOS a estructurado un programa en el cual aquellos pacientes de escasos recursos, puedan ser elegibles a recibir los mejores tratamientos y guía oncológica experta, nuestro programa ONKOS HUMANO</div><div style="text-align: justify;"><br></div><div><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756850644743-796928351.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="800"></div><div><br></div><div><br></div><div><br></div><div>Pregunta por nuestros programas de atención:</div><div><br></div><div><ul><li>Carcinomatosis y TMA</li><li>Red Onkos</li><li>Prevent Check</li><li>Radiología Intervencionista</li></ul></div>		https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756850797112-516851494.jpg	\N	publicado	2025-08-13 11:52:46.033			{}	21	f	0	2025-08-12 20:52:46.033	2025-09-08 23:54:42.111	pagina	\N	\N
15	Centros Asociados	centros-asociados	<p>Dentro de la visión de ONKOS en su lucha contra el cáncer, por supuesto que está la de hacer partícipes de esta a cuanta institución médica pueda sumarse a su cruzada, es así que para esto, en su programa de centros asociados , ONKOS viene firmando convenios con diversas instituciones de salud, como centros médicos, laboratorios, clínicas, centros radiológicos, para poder desarrollar sus atenciones a la brevedad posible, pero también utilizando los servicios e infraestructura de otras instituciones para hacer llegar todo tipo de servicios en el campo oncológico, sean para detección precoz, estudios radiológicos, internamiento , cirugías complejas, etc. a toda persona que requiera atención rápida y de alta calidad.</p><p><br></p><p>Lista de centros Asociados</p><p><ul><li>Clínica Universitaria</li><li>ECOVISION</li><li>ONCOIMAGEN</li><li>TOMOMEDIC</li></ul></p>\n	Centros Asociados\n\t\n\n\t\n\t\t\nDentro de la visión de ONKOS en su lucha contra el cáncer, por supuesto que está la de hacer partícipes de esta a cuanta institución médica pueda sumarse a su cruzada, es así...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756851456071-417106081.jpg	\N	publicado	2025-08-13 01:52:46.037			{}	24	f	0	2025-08-12 20:52:46.037	2025-09-08 23:54:15.267	pagina	\N	\N
17	OPINIÓN EXPERTA	opinion-experta	<h2></h2>\n<p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756852753688-375881364.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="800" height="437"></p><p>Este programa pone a disposición de todo paciente la posibilidad de acceder a consultas de experticia de alta calidad, en la cual el personal áltamente capacitado y calificado de ONKOS (Oncólogos Expertos) le podrán brindar todo tipo de información, analizar su caso desde un punto de vista muy técnico y profesional, para que el paciente pueda tomar la mejor decisión en cuanto a la estrategia terapeútica correcta. El Cáncer es una enfermedad extremadamente compleja, y para tener posibilidades de éxito en su erradicación si esta es factible, es imprescindible acceder al mejor tratamiento posible, no olvide que una opinión de experticia, puede radicalmente cambiar el enfoque terapeútico de la enfermedad e incrementar las chances de control y/o curación de la enfermedad, Nuestros expertos se asegurarán de que el paciente acceda a lo mejor del entendimiento de su enfermedad , así de cómo enfrentarla con elevadas probabilidades de éxito.</p>\n<p>Si desea una opinión de experticia, llame o escriba a este número telefónico: 942 610 346</p>\n	OPINIÓN EXPERTA\n\t\n\n\t\n\t\t\n\n\n\nEste programa pone a disposición de todo paciente la posibilidad de acceder a consultas de experticia de alta calidad, en la cual el personal áltamente capacitado y califica...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756852587058-276736356.jpg	\N	publicado	2025-08-13 06:52:46.041	\N	\N	{}	12	f	0	2025-08-12 20:52:46.041	2025-09-08 23:54:43.239	pagina	\N	\N
16	Diagnóstico Rápido	diagnostico-rapido	<p style="text-align: justify;"><span style="font-size: 1rem;">El sistema público de salud para atenciones oncológicas está colapsado, en una enfermedad en donde el tiempo es la variable más importante para tener chance de control adecuado de la enfermedad e incluso curarla, el diagnóstico rápido es vital, en ONKOS contamos tanto con la guía experta, así como la infraestructura nuestra y de nuestros centros asociados para llegar rápidamente al diagnóstico, en donde realizar una biopsia, analizarla por patólogos expertos, realizar estudios radiológicos y de laboratorio ala brevedad, son la esencia de este programa.ONKOS garantiza un diagnóstico rápido, si usted , algún familiar o conocido requieren una atención urgente para descartar o confirmar un diagnóstico de cáncer, puede contar con nosotros</span></p>\n<p style="text-align: justify;">Lista de Procedimientos para Diagnóstico Rápido:</p>\n<p><ul><li style="text-align: justify;">Biopsias por aspiración con aguja fina bajo guía ecográfica o Tomográfica(Tiroides, Mama, Ganglios, Masas).</li><li style="text-align: justify;">Biopsias con Aguja Trucut bajo guía ecográfica o Tomográfica (Mama, Masas o Tumores).</li><li style="text-align: justify;">Biopsias Endoscópicas/Colonoscópicas.</li><li style="text-align: justify;">Biopsias Ecoendoscópicas.</li><li style="text-align: justify;">Biopsias Incisionales/Excisionales.</li></ul></p>\n	Diagnóstico Rápido\n\t\n\n\t\n\t\t\nEl sistema público de salud para atenciones oncológicas está colapsado, en una enfermedad en donde el tiempo es la variable más importante para tener chance de control adecu...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756851589649-984765180.jpg	\N	publicado	2025-08-13 01:52:46.039	\N	\N	{}	12	f	0	2025-08-12 20:52:46.039	2025-09-08 23:54:18.541	pagina	\N	\N
30	Nutraceutica	nutraceutica	<div><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367701/onkos-blog/onkos-blog/1757367701239-685761342.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; float: left; margin: 0px 10px 10px 0px;" class="editor-image" data-editable="true" width="300" height="307"></div><div></div><div></div><div><span style="font-size: 1rem;">¡ENFIBREMOS EL MUNDO!</span></div><div>Te damos la bienvenida a un universo único, que mejorará la calidad de vida de muchas personas, pero sobre todo, para que sientas un cambio exponencial en la tuya.</div><div><br></div><div><br></div><div><br></div><div>Somos Caral Biotec, y en cada fibra de nuestro ser, recorre la visión de mejorar la salud de todo el mundo. El poder de la fibra es impresionante y los beneficios que brinda, contribuyen a mejorar en gran medida nuestra salud. Se parte del cambio, se parte de ésta revolución.</div><div><br></div><div></div><a href="https://caralbiotec.com/" target="_blank" title="Unéte!" style="cursor: pointer;"><font size="6"><b>¡UN UNIVERSO DE POSIBILIDADES!</b></font></a><div><br></div><div><br></div>		https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367941/onkos-blog/onkos-blog/1757367941384-733827106.jpg	\N	publicado	2025-08-12 20:52:46.069	\N	\N	{}	21	f	0	2025-08-12 20:52:46.069	2025-09-09 02:45:44.931	pagina	\N	\N
22	Reposicionamiento	reposicionamiento	<p>Utilizar medicamentos para tratar un cáncer que normalmente no se han desarrollado como antineoplásicos, sino que se indican y han desarrollado para tratar patologías tan diversas como la hipertensión arterial, enfermedades infecciosas y parasitarias, inﬂamaciones, etc., es un campo de investigación y aplicación clínica continua en ONKOS.</p><p>La gran ventaja del posicionamiento farmacológico, está asentada en que muchos fármacos de uso corriente para diversas patologías, se encuentran al alcance de la gran mayoría, son económicos y utilizados con base y conocimiento, pueden lograr respuestas impensadas en casos muy difíciles de manejar.</p><p>Por ejemplo, el uso de antifúngicos como el Itraconazol, antiparasitarios como el Mebendazol, antiinﬂamatorios como inhibidores COX-2, hipouricemiantes como la colchicina, beta-bloqueadores como el propranolol, y muchos otros fármacos, vienen siendo investigados cuidadosamente en nuestra institución como tratamientos o coadyuvantes en el tratamiento de diversas neoplasias malignas.</p><p>Buscar, investigar, elaborar propuestas de tratamiento en el día a día, continuamente, nos hacen una institución a la vanguardia en diversos campos de la oncología.</p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757365891/onkos-blog/onkos-blog/1757365891223-324306493.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="600" height="541"></p><p><br></p><p></p>\n	Reposicionamiento\n\t\n\n\t\n\t\t\t\t\n\t\t\t\t\t\t\t\n\t\t\t\t\t\n\t\t\t\t\n\t\t\t\t\n\t\t\t/*! elementor - v3.18.0 - 20-12-2023 */\n.elementor-widget-text-editor.elementor-drop-cap-view-stacked .elementor-drop-cap{background-color:#69727...	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366040/onkos-blog/onkos-blog/1757366040123-994513280.jpg	\N	publicado	2025-08-12 20:52:46.052	\N	\N	{}	24	f	0	2025-08-12 20:52:46.052	2025-09-09 02:14:04.958	pagina	\N	\N
29	Muérdago	muerdago	<p style="text-align: justify;">Las preparaciones con muérdago se encuentran entre los fármacos más prescritos a los pacientes con cáncer. Sus partidarios sostienen que los extractos de muérdago estimulan el sistema inmunitario, mejoran la supervivencia, mejoran la calidad de vida y reducen los efectos adversos de la quimioterapia y la radioterapia en los pacientes con cáncer. La revisión encontró que no hubo evidencia suficiente para establecer conclusiones claras acerca de los efectos sobre cualquiera de estos resultados y, por lo tanto, no está claro en que medida la aplicación de extractos de muérdago se traduce en un mejor control de los síntomas, una mejor respuesta tumoral o una prolongación de la supervivencia. Se informaron efectos adversos de los extractos de muérdago, pero al parecer dependen de la dosis y principalmente se limitan a reacciones en el sitio de inyección y a síntomas leves, transitorios, similares a la gripe. Ante la falta de ensayos independientes, de buena calidad, la decisión acerca de si los extractos de muérdago pueden resultar beneficiosos para un problema particular dependerá del criterio del especialista y de las consideraciones prácticas.</p><p style="text-align: justify;"><br></p><p><br></p>\n	Muérdago\n\t\n\n\t\n\t\t\nLas preparaciones con muérdago  se encuentran entre los fármacos más prescritos a los pacientes con cáncer. Sus partidarios sostienen que los extractos de muérdago estimulan el sistem...	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367604/onkos-blog/onkos-blog/1757367604004-569830046.jpg	\N	publicado	2025-08-12 20:52:46.066	\N	\N	{}	43	f	0	2025-08-12 20:52:46.066	2025-09-09 02:40:27.722	pagina	\N	\N
19	Quimioterapia	quimioterapia	<p>A pesar de la explosiva aparición de nuevos fármacos contra el cáncer como terapias moleculares e inmunoterapia principalmente, la utilización de agentes químicos conocidos desde hace décadas para el tratamiento de la enfermedad, sigue siendo la piedra angular, el cimiento básico para enfrentar adecuadamente un problema tan serio como el cáncer.</p><p><br></p><p><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360344/onkos-blog/onkos-blog/1757360344653-434744340.jpg" alt="" style="max-width: 100%; height: auto; cursor: pointer; display: block; margin: 10px auto;" class="editor-image" data-editable="true" width="700" height="444"></p><p><br></p><p></p><p></p><p>En ONKOS, tenemos basta experiencia en el manejo de estos agentes químicos, los cuales manejados racionalmente,individualizando las dosis adecuadamente, vigilando cuidadosamente su eﬁcacia para erradicar o controlar tumores malignos, monitorizando algún efecto adverso y/o toxicidad, podemos lograr en muchos casos el éxito en el tratamiento del cáncer.</p><p>Nuestros TBRs y TerAds, nos permiten cuidadosa y minuciosamente ir avanzando tratamiento a tratamiento, esto aunado a nuestras terapias de soporte adecuado, hacen que las quimioterapias administradas y recomendadas en ONKOS, sean excepcionalmente bien toleradas y efectivas contra la enfermedad.<br></p><p style="text-align: center;"><img src="https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360417/onkos-blog/onkos-blog/1757360416604-587856366.png" alt="" style="max-width: 100%; height: auto; cursor: pointer;" class="editor-image" data-editable="true"></p><p style="text-align: justify;"></p>\n	Quimioterapia sistémica	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360307/onkos-blog/onkos-blog/1757360306591-941291518.jpg	\N	publicado	2025-08-12 20:52:46.045	\N	\N	{}	41	f	0	2025-08-12 20:52:46.045	2025-09-09 00:44:26.088	pagina	\N	\N
14	Médicos Asociados	medicos-asociados	<p style="text-align: justify;"><span style="font-size: 1rem;">ONKOS abre sus instalaciones para que Oncólogos y médicos afines al campo Oncológico, se conviertan en médicos asociados y gocen de toda la infraestructura ubicado en el corazón de Lima, ONKOS proporciona a todo Oncólogo y profesional médico afín, que desee iniciar o complementar su consulta oncológica, una base con todas las comodidades necesarias para que ejerza su práctica profesional plena.Para esto , ONKOS cuenta con salas de quimioterapia implementadas con monitores multiparaméttricos, sala para infusiones largas, personal técnico, farmacia y de enfermería ampliamente capacitado, recepcionistas para coordinar las consultas y tratamientos oncológicos, laboratorio clínico (ONKOS LAB), amplio estacionamiento para aparcamiento de vehículos particulares, y por sobre todo el soportte de ONKOS PHARMA, la farmacia oncológica y del dolor que cuenta con todos los fármacos, insumos y terapias del dolor, junto a la UMO ( Unidad de mezclas Oncológicas) para asegurar a sus pacientes lamáxima calidad de tratamientos y monitorización de estos.Ser médico asociado de ONKOS, permite a todo galeno la libertad y el soporte necesariopara que atienda su consulta y trate a sus pacientes con la máxima calidad posible. Si deseas ser un médico asociado, escríbenos a esta dirección de correo electrónico: info@grupoonkos.peO contáctanos a este número telefónico : (+51) 942 610 346</span></p>\n	Médicos Asociados\n\t\n\n\t\n\t\t\nONKOS abre sus instalaciones para que Oncólogos y médicos afines al campo Oncológico, se conviertan en médicos asociados y gocen de toda la infraestructura ubicado en el cora...	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756851016115-529559113.jpg	\N	publicado	2025-08-13 01:52:46.035	\N	\N	{}	26	f	0	2025-08-12 20:52:46.035	2025-09-08 23:54:14.786	pagina	\N	\N
\.


--
-- Data for Name: especialidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidades (id, nombre, descripcion, icon) FROM stdin;
1	Oncología Médica	\N	\N
8	Farmacia Oncológica	\N	\N
6	Cirugía Oncológica	\N	\N
7	Psico-oncología	\N	\N
5	Patología Oncológica	\N	\N
2	Radiología Oncológica	\N	\N
3	Ginecología Oncológica	\N	\N
4	Medicina Intensiva Oncológica	\N	\N
\.


--
-- Data for Name: historial_citas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historial_citas (id, cita_id, fecha_cambio, estado_anterior, estado_nuevo, comentario) FROM stdin;
\.


--
-- Data for Name: horarios_medicos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.horarios_medicos (id, medico_id, dia_semana, hora_inicio, hora_fin) FROM stdin;
\.


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.media (id, nombre_archivo, nombre_original, tipo_mime, "tamaño_bytes", url, alt_text, uploaded_by, created_at) FROM stdin;
4	optimized-1755038293685-773796615.webp	oncologya-300x282.webp	image/webp	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755038293685-773796615.jpg	\N	\N	2025-08-12 22:38:13.712
5	optimized-1755038627046-704247188.webp	oncologya-300x282.webp	image/webp	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755038627046-704247188.jpg	\N	\N	2025-08-12 22:43:47.073
7	optimized-1755039040963-34090384.jpg	Image_fx.jpg	image/jpeg	223677	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039040963-34090384.jpg	\N	\N	2025-08-12 22:50:41.013
9	optimized-1755039586039-225411709.jpg	Image_fx.jpg	image/jpeg	223677	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039586039-225411709.jpg	\N	\N	2025-08-12 22:59:46.082
10	optimized-1755039617180-663108211.jpg	tbg.jpg	image/jpeg	1333807	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039617180-663108211.jpg	\N	\N	2025-08-12 23:00:17.246
11	optimized-1755039737811-426889180.jpg	1242x2208-px-colorful-digital-art-portrait-display-vertical-nature-trees-hd-art-wallpaper-preview.jpg	image/jpeg	253682	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039737811-426889180.jpg	\N	\N	2025-08-12 23:02:17.852
12	optimized-1755039755576-425852378.jpg	Image_fx.jpg	image/jpeg	223677	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039755576-425852378.jpg	\N	\N	2025-08-12 23:02:35.648
14	optimized-1755040071111-676513717.jpg	1242x2208-px-colorful-digital-art-portrait-display-vertical-nature-trees-hd-art-wallpaper-preview.jpg	image/jpeg	253682	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755040071111-676513717.jpg	\N	\N	2025-08-12 23:07:51.159
15	optimized-1755040127427-175609485.jpg	Image_fx.jpg	image/jpeg	223677	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755040127427-175609485.jpg	\N	\N	2025-08-12 23:08:47.482
17	optimized-1755183739107-211383716.png	oncologya-300x282.png	image/png	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755183739107-211383716.jpg	\N	\N	2025-08-14 15:02:19.137
18	optimized-1756136548195-505872740.png	oncologya-300x282.png	image/png	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756136548195-505872740.jpg	\N	\N	2025-08-25 15:42:28.264
20	optimized-1756138617835-96388264.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756138617835-96388264.jpg	\N	\N	2025-08-25 16:16:57.901
21	optimized-1756139887022-795113812.jpg	tbg.jpg	image/jpeg	1333807	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756139887022-795113812.jpg	\N	\N	2025-08-25 16:38:07.095
22	optimized-1756217867495-793245918.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756217867495-793245918.jpg	\N	\N	2025-08-26 14:17:47.553
24	optimized-1756218463103-773016553.jpg	orack.jpg	image/jpeg	13178	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756218463103-773016553.jpg	\N	\N	2025-08-26 14:27:43.119
25	optimized-1756218916862-762529555.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756218916862-762529555.jpg	\N	\N	2025-08-26 14:35:16.921
27	optimized-1756251602469-572466538.jpeg	IMG-20250817-WA0045.jpeg	image/jpeg	83172	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756251602469-572466538.jpg	\N	\N	2025-08-26 23:40:02.598
28	optimized-1756251610486-454323197.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756251610486-454323197.jpg	\N	\N	2025-08-26 23:40:10.561
30	optimized-1756307583750-412446828.jpeg	IMG-20250817-WA0045.jpeg	image/jpeg	83172	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756307583750-412446828.jpg	\N	\N	2025-08-27 15:13:04.01
31	optimized-1756308163983-715932608.png	oncologya-300x282.png	image/png	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756308163983-715932608.jpg	\N	\N	2025-08-27 15:22:44.062
33	optimized-1756496232272-323487057.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756496232272-323487057.jpg	\N	\N	2025-08-29 19:37:12.363
34	optimized-1756496594575-685057773.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756496594575-685057773.jpg	\N	\N	2025-08-29 19:43:14.675
36	optimized-1756497110092-613855424.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756497110092-613855424.jpg	\N	\N	2025-08-29 19:51:50.224
38	optimized-1756499104002-958220798.png	FACHADA-1-1024x770.png	image/png	704784	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756499104002-958220798.jpg	\N	\N	2025-08-29 20:25:04.064
39	optimized-1756499261143-483649880.png	FACHADA-1-1024x770.png	image/png	704784	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756499261143-483649880.jpg	\N	\N	2025-08-29 20:27:41.3
40	optimized-1756499298571-51415386.png	FACHADA-1-1024x770.png	image/png	704784	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756499298571-51415386.jpg	\N	\N	2025-08-29 20:28:18.611
42	optimized-1756500364592-647737067.png	FACHADA-1-1024x770.png	image/png	704784	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756500364592-647737067.jpg	\N	\N	2025-08-29 20:46:05.314
43	optimized-1756500568217-113625216.png	a80f9500.png	image/png	131511	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756500568217-113625216.jpg	\N	\N	2025-08-29 20:49:28.448
45	optimized-1756500946261-298043079.png	1a5b96b3.png	image/png	122390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756500946261-298043079.jpg	\N	\N	2025-08-29 20:55:46.651
3	optimized-1755038129580-917337256.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755038129580-917337256.jpg	\N	\N	2025-08-12 22:35:29.667
49	optimized-1756501068468-484202460.png	01b2f7a7.png	image/png	117287	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501068468-484202460.jpg	\N	\N	2025-08-29 20:57:48.846
51	optimized-1756502477148-902505090.png	54ef713b.png	image/png	142712	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502477148-902505090.jpg	\N	\N	2025-08-29 21:21:17.521
52	optimized-1756502498634-621057934.png	75d6dae1.png	image/png	117611	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502498634-621057934.jpg	\N	\N	2025-08-29 21:21:38.984
54	optimized-1756502590054-368025015.png	7014bfe1.png	image/png	1717413	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502590054-368025015.jpg	\N	\N	2025-08-29 21:23:11.173
55	optimized-1756502639391-881407490.png	b957bb56.png	image/png	132760	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502639391-881407490.jpg	\N	\N	2025-08-29 21:23:59.813
57	optimized-1756502834039-156620452.png	012e5069.png	image/png	153018	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502834039-156620452.jpg	\N	\N	2025-08-29 21:27:14.294
58	optimized-1756502849051-375859867.png	82f2e7b5.png	image/png	130423	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502849051-375859867.jpg	\N	\N	2025-08-29 21:27:29.37
60	optimized-1756503629080-876113186.png	800cc9c5.png	image/png	175436	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756503629080-876113186.jpg	\N	\N	2025-08-29 21:40:29.464
61	optimized-1756503641412-486339692.png	b823b80b.png	image/png	132564	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756503641412-486339692.jpg	\N	\N	2025-08-29 21:40:41.651
63	optimized-1756846827646-921272917.jpg	Image_fx (3).jpg	image/jpeg	1382930	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756846827646-921272917.jpg	\N	\N	2025-09-02 21:00:27.859
64	optimized-1756847125140-813970957.png	oncologya-300x282.png	image/png	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847125140-813970957.jpg	\N	\N	2025-09-02 21:05:25.439
66	optimized-1756847304681-143541002.jpg	Image_fx (4).jpg	image/jpeg	1633040	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847304681-143541002.jpg	\N	\N	2025-09-02 21:08:24.926
67	optimized-1756847540014-974625123.jpg	Image_fx (5).jpg	image/jpeg	1507049	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847540014-974625123.jpg	\N	\N	2025-09-02 21:12:20.279
68	optimized-1756847701942-8563384.jpg	Image_fx (6).jpg	image/jpeg	1140276	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847701942-8563384.jpg	\N	\N	2025-09-02 21:15:02.09
70	optimized-1756847910193-638936747.jpg	Image_fx (8).jpg	image/jpeg	1386539	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847910193-638936747.jpg	\N	\N	2025-09-02 21:18:30.406
71	optimized-1756848136687-740545194.jpg	Image_fx (9).jpg	image/jpeg	1520546	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756848136687-740545194.jpg	\N	\N	2025-09-02 21:22:16.931
73	optimized-1756849887667-613782803.jpg	Image_fx (11).jpg	image/jpeg	1431151	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756849887667-613782803.jpg	\N	\N	2025-09-02 21:51:27.89
74	optimized-1756850028153-857296133.jpg	Image_fx (12).jpg	image/jpeg	1135580	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756850028153-857296133.jpg	\N	\N	2025-09-02 21:53:48.358
76	optimized-1756850797112-516851494.jpg	Image_fx (13).jpg	image/jpeg	1647700	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756850797112-516851494.jpg	\N	\N	2025-09-02 22:06:37.348
77	optimized-1756851016115-529559113.jpg	Image_fx (14).jpg	image/jpeg	1639428	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756851016115-529559113.jpg	\N	\N	2025-09-02 22:10:16.341
79	optimized-1756851589649-984765180.jpg	1f72010f.jpg	image/jpeg	48871	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756851589649-984765180.jpg	\N	\N	2025-09-02 22:19:49.715
80	optimized-1756852587058-276736356.jpg	Image_fx (19).jpg	image/jpeg	1765014	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756852587058-276736356.jpg	\N	\N	2025-09-02 22:36:27.266
82	optimized-1756852753688-375881364.jpg	Image_fx (20).jpg	image/jpeg	1435679	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756852753688-375881364.jpg	\N	\N	2025-09-02 22:39:13.902
83	optimized-1757076251976-39921949.jpg	aeb23060.jpg	image/jpeg	33960	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757076251976-39921949.jpg	\N	\N	2025-09-05 17:44:12.457
85	optimized-1757081952056-300463197.jpg	Image_fx (22).jpg	image/jpeg	1413727	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757081952056-300463197.jpg	\N	\N	2025-09-05 19:19:13.435
86	optimized-1757090956781-592603895.jpg	Image_fx (21).jpg	image/jpeg	1522894	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757090956781-592603895.jpg	\N	\N	2025-09-05 21:49:17.822
87	optimized-1757091107799-596028221.png	Screenshot From 2025-09-05 11-51-29.png	image/png	117390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757091107799-596028221.jpg	\N	\N	2025-09-05 21:51:48.438
88	optimized-1757091318856-837542993.jpg	f6921c7f.jpg	image/jpeg	42467	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757091318856-837542993.jpg	\N	\N	2025-09-05 21:55:19.291
90	optimized-1757332176628-399086072.jpg	f6921c7f.jpg	image/jpeg	42467	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757332176628-399086072.jpg	\N	\N	2025-09-08 16:49:36.883
48	optimized-1756501059964-973797745.png	1a5b96b3.png	image/png	122390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501059964-973797745.jpg	\N	\N	2025-08-29 20:57:40.268
93	optimized-1757332431012-643464079.jpg	aeb23060.jpg	image/jpeg	33960	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757332431012-643464079.jpg	\N	\N	2025-09-08 16:53:51.294
94	optimized-1757333163478-788406365.jpg	UniversalUpscaler_90854297-7275-43e7-9ba5-fd81305731a3.jpg	image/jpeg	693177	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757333163478-788406365.jpg	\N	\N	2025-09-08 17:06:04.895
95	optimized-1757333419067-710602980.jpg	Image_fx.jpg	image/jpeg	1299410	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757333419067-710602980.jpg	\N	\N	2025-09-08 17:10:21.223
97	optimized-1757334507540-335902590.jpg	Whisk_db413d8bc9.jpg	image/jpeg	451963	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757334507540-335902590.jpg	\N	\N	2025-09-08 17:28:28.367
98	optimized-1757335950854-599874635.jpg	968b6619.jpg	image/jpeg	80817	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757335950854-599874635.jpg	\N	\N	2025-09-08 17:52:31.643
99	optimized-1757335950851-83114835.png	1a5b96b3.png	image/png	122390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757335950851-83114835.jpg	\N	\N	2025-09-08 17:52:32.617
100	optimized-1757335979046-23260061.jpg	968b6619.jpg	image/jpeg	80817	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757335979046-23260061.jpg	\N	\N	2025-09-08 17:52:59.49
101	optimized-1757336093311-579675678.jpg	63202812.jpg	image/jpeg	61439	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336093311-579675678.jpg	\N	\N	2025-09-08 17:54:53.738
102	optimized-1757336126623-401646848.jpeg	379bceb1.jpeg	image/jpeg	66909	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336126623-401646848.jpg	\N	\N	2025-09-08 17:55:27.046
104	optimized-1757336207219-319161002.jpg	eb8d277c.jpg	image/jpeg	51997	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336207219-319161002.jpg	\N	\N	2025-09-08 17:56:47.561
105	optimized-1757336313130-284600098.jpeg	f1c00c8e.jpeg	image/jpeg	102391	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336313130-284600098.jpg	\N	\N	2025-09-08 17:58:33.657
106	optimized-1757336452920-68855409.jpg	718cb6d8.jpg	image/jpeg	34141	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336452920-68855409.jpg	\N	\N	2025-09-08 18:00:53.139
107	optimized-1757336521078-678019280.jpg	796f5927.jpg	image/jpeg	16084	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336521078-678019280.jpg	\N	\N	2025-09-08 18:02:01.365
108	optimized-1757336864070-839341333.jpg	Whisk_c97522891a.jpg	image/jpeg	428931	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336864070-839341333.jpg	\N	\N	2025-09-08 18:07:44.584
110	optimized-1757337543810-839524794.jpg	Whisk_56f97596b2.jpg	image/jpeg	398421	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757337543810-839524794.jpg	\N	\N	2025-09-08 18:19:04.815
111	optimized-1757337666854-109567722.jpg	fefbd36c.jpg	image/jpeg	22564	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757337666854-109567722.jpg	\N	\N	2025-09-08 18:21:07.256
112	optimized-1757337744657-356456944.jpg	7f2ec402.jpg	image/jpeg	10911	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757337744657-356456944.jpg	\N	\N	2025-09-08 18:22:24.924
113	optimized-1757337841360-784980126.jpg	2b48d88e.jpg	image/jpeg	60943	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757337841360-784980126.jpg	\N	\N	2025-09-08 18:24:02.032
115	optimized-1757338136761-454638548.jpg	65573e62.jpg	image/jpeg	91144	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757338136761-454638548.jpg	\N	\N	2025-09-08 18:28:57.062
116	optimized-1757338230119-571294164.jpg	Whisk_2d56602a9a.jpg	image/jpeg	392260	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757338230119-571294164.jpg	\N	\N	2025-09-08 18:30:31.077
117	optimized-1757338369177-104690789.jpg	c179baf6.jpg	image/jpeg	51579	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757338369177-104690789.jpg	\N	\N	2025-09-08 18:32:49.638
118	optimized-1757338550416-852558771.jpg	Image_fx (23).jpg	image/jpeg	955887	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757338550416-852558771.jpg	\N	\N	2025-09-08 18:35:51.929
119	optimized-1757338757801-112591250.jpg	4571c65e.jpg	image/jpeg	17120	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757338757801-112591250.jpg	\N	\N	2025-09-08 18:39:18.173
121	optimized-1757339150801-506359873.png	caral_marca_positivo-300x61.png	image/png	11007	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757339150801-506359873.jpg	\N	\N	2025-09-08 18:45:51.108
122	optimized-1757339259466-821352805.png	Screenshot From 2025-09-08 08-47-25.png	image/png	30796	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757339259466-821352805.jpg	\N	\N	2025-09-08 18:47:39.719
123	optimized-1757339467477-917339292.png	Screenshot From 2025-09-08 08-50-54.png	image/png	962229	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757339467477-917339292.jpg	\N	\N	2025-09-08 18:51:14.129
124	optimized-1757352093442-753369136.jpg	inmunoterapia-cancer-1.jpg	image/jpeg	29496	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757352093442-753369136.jpg	\N	\N	2025-09-08 22:21:33.794
1	optimized-1755037260422-97624971.jpg	tbg.jpg	image/jpeg	1333807	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755037260422-97624971.jpg	\N	\N	2025-08-12 22:21:00.491
92	optimized-1757332416493-611117144.jpg	Image_fx234.jpg	image/jpeg	1136278	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757332416493-611117144.jpg	\N	\N	2025-09-08 16:53:37.79
8	optimized-1755039050658-279584429.jpg	1242x2208-px-colorful-digital-art-portrait-display-vertical-nature-trees-hd-art-wallpaper-preview.jpg	image/jpeg	253682	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039050658-279584429.jpg	\N	\N	2025-08-12 22:50:50.707
13	optimized-1755039793342-628438309.jpg	Image_fx.jpg	image/jpeg	223677	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755039793342-628438309.jpg	\N	\N	2025-08-12 23:03:13.445
16	optimized-1755182158871-59732278.png	oncologya-300x282.png	image/png	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755182158871-59732278.jpg	\N	\N	2025-08-14 14:35:58.928
19	optimized-1756137106417-770800013.jpeg	Screenshot_20250815_113136_Chrome.jpeg	image/jpeg	65329	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756137106417-770800013.jpg	\N	\N	2025-08-25 15:51:46.483
23	optimized-1756218255285-849669738.jpg	tbg.jpg	image/jpeg	1333807	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756218255285-849669738.jpg	\N	\N	2025-08-26 14:24:15.35
26	optimized-1756251004586-827839946.png	test-image.png	image/png	70	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756251004586-827839946.jpg	\N	\N	2025-08-26 23:30:04.603
29	optimized-1756251621656-970207467.png	image.png	image/png	16193	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756251621656-970207467.jpg	\N	\N	2025-08-26 23:40:21.68
32	optimized-1756326901114-600828841.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756326901114-600828841.jpg	\N	\N	2025-08-27 20:35:01.19
35	optimized-1756496939752-704592978.png	onkos.png	image/png	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756496939752-704592978.jpg	\N	\N	2025-08-29 19:48:59.808
37	optimized-1756499004984-811976302.webp	FACHADA-1-1024x770.webp	image/webp	37584	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756499004984-811976302.jpg	\N	\N	2025-08-29 20:23:25.222
41	optimized-1756500150460-866377104.png	FACHADA-1-1024x770.png	image/png	704784	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756500150460-866377104.jpg	\N	\N	2025-08-29 20:42:31.206
44	optimized-1756500596518-871235896.png	1a5b96b3.png	image/png	122390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756500596518-871235896.jpg	\N	\N	2025-08-29 20:49:56.906
46	optimized-1756501024670-342017504.png	1a5b96b3.png	image/png	122390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501024670-342017504.jpg	\N	\N	2025-08-29 20:57:05.154
47	optimized-1756501052856-139548566.png	a80f9500.png	image/png	131511	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756501052856-139548566.jpg	\N	\N	2025-08-29 20:57:33.225
50	optimized-1756502465873-966010864.png	f9f06470.png	image/png	123282	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502465873-966010864.jpg	\N	\N	2025-08-29 21:21:06.15
53	optimized-1756502578106-328874609.png	e385c870.png	image/png	104464	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502578106-328874609.jpg	\N	\N	2025-08-29 21:22:58.382
56	optimized-1756502801706-365909920.png	a254c5ca.png	image/png	157479	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756502801706-365909920.jpg	\N	\N	2025-08-29 21:26:41.936
59	optimized-1756503615703-585096701.png	1f421a56.png	image/png	139382	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756503615703-585096701.jpg	\N	\N	2025-08-29 21:40:16.118
62	optimized-1756846604008-485730174.jpg	Image_fx (2).jpg	image/jpeg	1527673	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756846604008-485730174.jpg	\N	\N	2025-09-02 20:56:44.276
65	optimized-1756847181170-780953048.jpg	Whisk_c290a4ec45.jpg	image/jpeg	255045	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847181170-780953048.jpg	\N	\N	2025-09-02 21:06:21.328
69	optimized-1756847770431-283768737.jpg	Image_fx (7).jpg	image/jpeg	1392638	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756847770431-283768737.jpg	\N	\N	2025-09-02 21:16:10.64
72	optimized-1756848286971-453295638.jpg	Image_fx (10).jpg	image/jpeg	1251783	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756848286971-453295638.jpg	\N	\N	2025-09-02 21:24:47.135
75	optimized-1756850644743-796928351.png	7014bfe1.png	image/png	1717413	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756850644743-796928351.jpg	\N	\N	2025-09-02 22:04:05.981
78	optimized-1756851456071-417106081.jpg	Image_fx (16).jpg	image/jpeg	1490467	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756851456071-417106081.jpg	\N	\N	2025-09-02 22:17:36.276
81	optimized-1756852609716-302576538.jpg	Image_fx (18).jpg	image/jpeg	1449656	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1756852609716-302576538.jpg	\N	\N	2025-09-02 22:36:49.914
84	optimized-1757076582372-915231901.jpg	Image_fx234.jpg	image/jpeg	1136278	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757076582372-915231901.jpg	\N	\N	2025-09-05 17:49:43.147
89	optimized-1757332148853-768178451.jpg	Image_fx (21).jpg	image/jpeg	1522894	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757332148853-768178451.jpg	\N	\N	2025-09-08 16:49:10.199
91	optimized-1757332244991-827268772.png	Screenshot From 2025-09-05 11-51-29.png	image/png	117390	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757332244991-827268772.jpg	\N	\N	2025-09-08 16:50:46.058
96	optimized-1757334499852-776429979.jpg	inmunoterapia-cancer-1.jpg	image/jpeg	29496	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757334499852-776429979.jpg	\N	\N	2025-09-08 17:28:20.154
103	optimized-1757336167374-745027101.jpg	4541f976.jpg	image/jpeg	88138	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336167374-745027101.jpg	\N	\N	2025-09-08 17:56:07.641
2	optimized-1755037492299-339492862.jpg	1242x2208-px-colorful-digital-art-portrait-display-vertical-nature-trees-hd-art-wallpaper-preview.jpg	image/jpeg	253682	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755037492299-339492862.jpg	\N	\N	2025-08-12 22:24:52.386
6	optimized-1755038655012-390109547.png	oncologya-300x282.png	image/png	6012	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1755038655012-390109547.jpg	\N	\N	2025-08-12 22:44:15.032
109	optimized-1757336978866-401556029.jpg	3179ab5d.jpg	image/jpeg	64293	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757336978866-401556029.jpg	\N	\N	2025-09-08 18:09:39.176
114	optimized-1757337953909-174429863.jpg	Whisk_d9086cfb20.jpg	image/jpeg	377316	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757337953909-174429863.jpg	\N	\N	2025-09-08 18:25:54.966
120	optimized-1757338952268-901128069.jpg	VITAMINA-C_-CON_5.jpg	image/jpeg	66971	https://res.cloudinary.com/dgajo3hhp/image/upload/onkos-blog/onkos-blog/optimized-1757338952268-901128069.jpg	\N	\N	2025-09-08 18:42:32.712
125	onkos-blog/onkos-blog/1757359545083-131923478	inmunoterapia-cancer-1.jpg	image/jpeg	32323	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757359545/onkos-blog/onkos-blog/1757359545083-131923478.jpg	\N	\N	2025-09-09 00:25:46.57
126	onkos-blog/onkos-blog/1757360306591-941291518	Image_fx (21).jpg	image/jpeg	102240	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360307/onkos-blog/onkos-blog/1757360306591-941291518.jpg	\N	\N	2025-09-09 00:38:28.211
127	onkos-blog/onkos-blog/1757360344653-434744340	f6921c7f.jpg	image/jpeg	42720	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360344/onkos-blog/onkos-blog/1757360344653-434744340.jpg	\N	\N	2025-09-09 00:39:06.536
128	onkos-blog/onkos-blog/1757360416604-587856366	Screenshot From 2025-09-05 11-51-29.png	image/png	25289	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360417/onkos-blog/onkos-blog/1757360416604-587856366.png	\N	\N	2025-09-09 00:40:18.15
129	onkos-blog/onkos-blog/1757360913963-143067473	Image_fx.jpg	image/jpeg	81754	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360914/onkos-blog/onkos-blog/1757360913963-143067473.jpg	\N	\N	2025-09-09 00:48:35.631
130	onkos-blog/onkos-blog/1757360966695-879996595	UniversalUpscaler_90854297-7275-43e7-9ba5-fd81305731a3.jpg	image/jpeg	81695	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757360967/onkos-blog/onkos-blog/1757360966695-879996595.jpg	\N	\N	2025-09-09 00:49:28.384
131	onkos-blog/onkos-blog/1757361003615-350288388	UniversalUpscaler_90854297-7275-43e7-9ba5-fd81305731a3.jpg	image/jpeg	81695	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757361004/onkos-blog/onkos-blog/1757361003615-350288388.jpg	\N	\N	2025-09-09 00:50:06.149
132	onkos-blog/onkos-blog/1757362202779-935272375	Whisk_c97522891a.jpg	image/jpeg	80034	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362203/onkos-blog/onkos-blog/1757362202779-935272375.jpg	\N	\N	2025-09-09 01:10:05.07
133	onkos-blog/onkos-blog/1757362233154-261391389	Whisk_56f97596b2.jpg	image/jpeg	78243	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362233/onkos-blog/onkos-blog/1757362233154-261391389.jpg	\N	\N	2025-09-09 01:10:34.734
134	onkos-blog/onkos-blog/1757362268865-263749187	2b63c165.jpg	image/jpeg	27930	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362269/onkos-blog/onkos-blog/1757362268865-263749187.jpg	\N	\N	2025-09-09 01:11:10.542
135	onkos-blog/onkos-blog/1757362297107-638806033	8b8592ce.jpg	image/jpeg	34979	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362297/onkos-blog/onkos-blog/1757362297107-638806033.jpg	\N	\N	2025-09-09 01:11:38.477
136	onkos-blog/onkos-blog/1757362321888-524479282	d32ea421.jpg	image/jpeg	26801	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362322/onkos-blog/onkos-blog/1757362321888-524479282.jpg	\N	\N	2025-09-09 01:12:03.363
137	onkos-blog/onkos-blog/1757362361482-824173100	d8158a6f.jpg	image/jpeg	36088	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362361/onkos-blog/onkos-blog/1757362361482-824173100.jpg	\N	\N	2025-09-09 01:12:42.93
138	onkos-blog/onkos-blog/1757362402024-393378860	9310fda5.jpg	image/jpeg	53912	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362402/onkos-blog/onkos-blog/1757362402024-393378860.jpg	\N	\N	2025-09-09 01:13:23.375
139	onkos-blog/onkos-blog/1757362695370-220402254	Whisk_db413d8bc9.jpg	image/jpeg	98716	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362696/onkos-blog/onkos-blog/1757362695370-220402254.jpg	\N	\N	2025-09-09 01:18:16.934
140	onkos-blog/onkos-blog/1757362797410-647434335	Whisk_56f97596b2.jpg	image/jpeg	78243	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757362797/onkos-blog/onkos-blog/1757362797410-647434335.jpg	\N	\N	2025-09-09 01:19:58.97
141	onkos-blog/onkos-blog/1757365864769-166049824	Whisk_c97522891a.jpg	image/jpeg	80034	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757365865/onkos-blog/onkos-blog/1757365864769-166049824.jpg	\N	\N	2025-09-09 02:11:06.312
142	onkos-blog/onkos-blog/1757365891223-324306493	aeb23060.jpg	image/jpeg	29412	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757365891/onkos-blog/onkos-blog/1757365891223-324306493.jpg	\N	\N	2025-09-09 02:11:32.417
143	onkos-blog/onkos-blog/1757366040123-994513280	Image_fx (22).jpg	image/jpeg	61150	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366040/onkos-blog/onkos-blog/1757366040123-994513280.jpg	\N	\N	2025-09-09 02:14:01.561
144	onkos-blog/onkos-blog/1757366123552-583448864	Whisk_c97522891a.jpg	image/jpeg	80034	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366124/onkos-blog/onkos-blog/1757366123552-583448864.jpg	\N	\N	2025-09-09 02:15:25.235
145	onkos-blog/onkos-blog/1757366176601-15140127	968b6619.jpg	image/jpeg	70213	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366176/onkos-blog/onkos-blog/1757366176601-15140127.jpg	\N	\N	2025-09-09 02:16:18.052
146	onkos-blog/onkos-blog/1757366231689-413855411	63202812.jpg	image/jpeg	52845	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366232/onkos-blog/onkos-blog/1757366231689-413855411.jpg	\N	\N	2025-09-09 02:17:13.061
147	onkos-blog/onkos-blog/1757366247762-343511845	379bceb1.jpeg	image/jpeg	54192	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366248/onkos-blog/onkos-blog/1757366247762-343511845.jpg	\N	\N	2025-09-09 02:17:29.114
148	onkos-blog/onkos-blog/1757366265083-667106618	4541f976.jpg	image/jpeg	77660	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366265/onkos-blog/onkos-blog/1757366265083-667106618.jpg	\N	\N	2025-09-09 02:17:46.264
149	onkos-blog/onkos-blog/1757366287228-147855819	eb8d277c.jpg	image/jpeg	45085	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366287/onkos-blog/onkos-blog/1757366287228-147855819.jpg	\N	\N	2025-09-09 02:18:08.511
150	onkos-blog/onkos-blog/1757366348905-579451839	f1c00c8e.jpeg	image/jpeg	76920	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366349/onkos-blog/onkos-blog/1757366348905-579451839.jpg	\N	\N	2025-09-09 02:19:10.372
151	onkos-blog/onkos-blog/1757366388956-429386240	718cb6d8.jpg	image/jpeg	29416	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366389/onkos-blog/onkos-blog/1757366388956-429386240.jpg	\N	\N	2025-09-09 02:19:50.098
152	onkos-blog/onkos-blog/1757366413586-986541545	796f5927.jpg	image/jpeg	13631	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366413/onkos-blog/onkos-blog/1757366413586-986541545.jpg	\N	\N	2025-09-09 02:20:14.819
153	onkos-blog/onkos-blog/1757366572120-626301270	Whisk_2d56602a9a.jpg	image/jpeg	75906	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366572/onkos-blog/onkos-blog/1757366572120-626301270.jpg	\N	\N	2025-09-09 02:22:53.424
154	onkos-blog/onkos-blog/1757366646269-124675792	3179ab5d.jpg	image/jpeg	57463	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366646/onkos-blog/onkos-blog/1757366646269-124675792.jpg	\N	\N	2025-09-09 02:24:07.734
155	onkos-blog/onkos-blog/1757366735756-691050773	9310fda5.jpg	image/jpeg	53912	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366736/onkos-blog/onkos-blog/1757366735756-691050773.jpg	\N	\N	2025-09-09 02:25:37.016
156	onkos-blog/onkos-blog/1757366782382-298896252	2b48d88e.jpg	image/jpeg	54238	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366782/onkos-blog/onkos-blog/1757366782382-298896252.jpg	\N	\N	2025-09-09 02:26:23.645
157	onkos-blog/onkos-blog/1757366850007-400696760	Whisk_d9086cfb20.jpg	image/jpeg	69246	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366850/onkos-blog/onkos-blog/1757366850007-400696760.jpg	\N	\N	2025-09-09 02:27:31.365
158	onkos-blog/onkos-blog/1757366935854-111273916	65573e62.jpg	image/jpeg	79721	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366936/onkos-blog/onkos-blog/1757366935854-111273916.jpg	\N	\N	2025-09-09 02:28:57.413
159	onkos-blog/onkos-blog/1757366973718-899971017	Whisk_56f97596b2.jpg	image/jpeg	78243	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757366974/onkos-blog/onkos-blog/1757366973718-899971017.jpg	\N	\N	2025-09-09 02:29:34.949
160	onkos-blog/onkos-blog/1757367034891-420227062	Image_fx (23).jpg	image/jpeg	80894	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367035/onkos-blog/onkos-blog/1757367034891-420227062.jpg	\N	\N	2025-09-09 02:30:36.741
161	onkos-blog/onkos-blog/1757367053367-904200077	c179baf6.jpg	image/jpeg	45901	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367053/onkos-blog/onkos-blog/1757367053367-904200077.jpg	\N	\N	2025-09-09 02:30:54.563
162	onkos-blog/onkos-blog/1757367113036-79390507	VITAMINA-C_-CON_5.jpg	image/jpeg	27742	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367113/onkos-blog/onkos-blog/1757367113036-79390507.jpg	\N	\N	2025-09-09 02:31:54.284
163	onkos-blog/onkos-blog/1757367134463-916392719	4571c65e.jpg	image/jpeg	15017	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367134/onkos-blog/onkos-blog/1757367134463-916392719.jpg	\N	\N	2025-09-09 02:32:15.734
164	onkos-blog/onkos-blog/1757367604004-569830046	Viscum-album-20173510-A-2000x1125.jpg	image/jpeg	68308	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367604/onkos-blog/onkos-blog/1757367604004-569830046.jpg	\N	\N	2025-09-09 02:40:05.286
165	onkos-blog/onkos-blog/1757367701239-685761342	Screenshot From 2025-09-08 08-47-25.png	image/png	17264	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367701/onkos-blog/onkos-blog/1757367701239-685761342.jpg	\N	\N	2025-09-09 02:41:42.521
166	onkos-blog/onkos-blog/1757367918261-544912962	wheat-bran-scaled-2048x1362.webp	image/webp	100756	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367918/onkos-blog/onkos-blog/1757367918261-544912962.jpg	\N	\N	2025-09-09 02:45:20.156
167	onkos-blog/onkos-blog/1757367941384-733827106	wheat-bran-scaled-2048x1362.webp	image/webp	100756	https://res.cloudinary.com/dgajo3hhp/image/upload/v1757367941/onkos-blog/onkos-blog/1757367941384-733827106.jpg	\N	\N	2025-09-09 02:45:42.834
168	onkos-blog/onkos-blog/1759520244551-480624498	Image_fx (2) tda.jpg	image/jpeg	97836	https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520245/onkos-blog/onkos-blog/1759520244551-480624498.jpg	\N	\N	2025-10-03 19:37:26.831142
169	onkos-blog/onkos-blog/1759520357256-306589453	Image_fx (2) tda.jpg	image/jpeg	97836	https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520358/onkos-blog/onkos-blog/1759520357256-306589453.jpg	\N	\N	2025-10-03 19:39:19.484647
170	onkos-blog/onkos-blog/1759520431390-130686868	Image_fx (4)cell.jpg	image/jpeg	73119	https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520432/onkos-blog/onkos-blog/1759520431390-130686868.jpg	\N	\N	2025-10-03 19:40:33.324771
171	onkos-blog/onkos-blog/1759520514749-100616038	Image_fxpill.jpg	image/jpeg	45987	https://res.cloudinary.com/dgajo3hhp/image/upload/v1759520515/onkos-blog/onkos-blog/1759520514749-100616038.jpg	\N	\N	2025-10-03 19:41:56.250022
\.


--
-- Data for Name: medicos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicos (id, nombre, dni, correo, telefono, estado, especialidad_id, centro_id) FROM stdin;
5	Dr. Daniel Solari Che	069546	\N	\N	activo	3	\N
6	Dr. Oscar Ibarra Lavado	026560	\N	\N	activo	3	\N
7	Dr. Gustavo Cueva Aguirre	029120	\N	\N	activo	4	\N
8	Dra. Guiselle Gutierrez Guerra	028927	\N	\N	activo	5	\N
9	Dr. German Villegas Vásquez	021126	\N	\N	activo	6	\N
10	Dra. Marylin Toledo Cárdenas	6629	\N	\N	activo	7	\N
11	Dra. Melina Ames Manrique	9557	\N	\N	activo	8	\N
1	Dr. Antonio Camargo Acosta	032867	\N	\N	activo	1	\N
2	Dr. Rómulo Cárdenas Agramonte	011650	\N	\N	activo	1	\N
3	Dr. Yinno Custodio Hernández	064281	\N	\N	activo	1	\N
4	Dr. Roberto Cavero Cueva	032826	\N	\N	activo	2	\N
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_items (id, titulo, tipo, url, orden, parent_id, activo, icono, target, created_at) FROM stdin;
1	Blog	pagina	/blog	1	\N	t	fas fa-blog	_self	2025-08-12 19:34:10.733
2	Oncología	categoria	/blog/categoria/oncologia	2	\N	t	fas fa-heartbeat	_self	2025-08-12 19:34:10.735
3	Tratamientos	categoria	/blog/categoria/tratamientos	3	\N	t	fas fa-pills	_self	2025-08-12 19:34:10.738
4	Investigación	categoria	/blog/categoria/investigacion	4	\N	t	fas fa-microscope	_self	2025-08-12 19:34:10.74
\.


--
-- Data for Name: pacientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pacientes (id, nombre, dni, telefono, correo, fecha_nacimiento, estado_vital, fecha_registro, estado, tipo_documento, numero_documento) FROM stdin;
34	Ana Martínez Actualizada	\N	+51987654325	ana.martinez.nuevo@email.com	1992-03-10	vivo	2025-09-09 22:25:19.924	activo	DNI	9988776679
35	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438720179@email.com	1988-12-05	vivo	2025-09-09 22:25:20.588	activo	DNI	5544332179
36	Gabi Perexz	\N	+51981255674	njgimenez@gmail.com	2012-08-20	vivo	2025-09-11 21:56:22.633	activo	DNI	\N
4	Nelson Aguilar	23232323	981288370	ngimenezia@gmail.com	1978-06-20	vivo	2025-08-08 17:10:05.804	activo	DNI	23232323
5	Carlos Groom	59595959	569856985	carlos@groom.com	1978-09-15	vivo	2025-08-08 17:24:17.14	activo	DNI	59595959
6	Luis Perez	12541254	4526357	luis@gmail.com	1978-06-20	vivo	2025-08-08 19:55:35.453	activo	DNI	12541254
7	Nelson Carmona	45612389	981258645	nkjgfii@jdjo.com	1978-08-20	vivo	2025-08-08 21:30:32.963	activo	DNI	45612389
8	Carmen Linarez	12365478	987654321	carmen@gmail.com	1979-12-13	vivo	2025-08-08 22:24:15.495	activo	DNI	12365478
9	Nelson Gimenez	25872589	78542584	njgimenea@mai.com	1990-06-20	vivo	2025-08-12 17:58:51.687	activo	DNI	25872589
10	Ramon Peres	\N	+51981288354	njgimenez@proton.com	1978-06-20	vivo	2025-08-12 18:53:24.491	activo	DNI	\N
11	Raul perex	\N	+51988873733	njgimenez@gmail.com	1978-06-20	vivo	2025-08-14 15:17:40.079	activo	DNI	\N
12	María García	\N	+51987654322	maria.garcia@email.com	1990-05-15	vivo	2025-09-09 22:20:33.82	activo	DNI	\N
20	Carlos López	\N	+51987654323	carlos.lopez.1757438616212@email.com	1985-08-20	vivo	2025-09-09 22:23:36.457	activo	DNI	1122334212
21	Ana Martínez	\N	+51987654324	ana.martinez.1757438617136@email.com	1992-03-10	vivo	2025-09-09 22:23:37.402	activo	DNI	9988776136
22	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438617680@email.com	1988-12-05	vivo	2025-09-09 22:23:39.018	activo	DNI	5544332680
23	María García	\N	+51987654322	maria.garcia.1757438648394@email.com	1990-05-15	vivo	2025-09-09 22:24:08.634	activo	DNI	8765432394
24	Carlos López	\N	+51987654323	carlos.lopez.1757438648718@email.com	1985-08-20	vivo	2025-09-09 22:24:08.966	activo	DNI	1122334718
25	Ana Martínez Actualizada	\N	+51987654325	ana.martinez.nuevo@email.com	1992-03-10	vivo	2025-09-09 22:24:10.048	activo	DNI	9988776805
26	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438650306@email.com	1988-12-05	vivo	2025-09-09 22:24:10.712	activo	DNI	5544332306
27	María García	\N	+51987654322	maria.garcia.1757438664112@email.com	1990-05-15	vivo	2025-09-09 22:24:24.371	activo	DNI	8765432112
28	Carlos López	\N	+51987654323	carlos.lopez.1757438664458@email.com	1985-08-20	vivo	2025-09-09 22:24:24.7	activo	DNI	1122334458
29	Ana Martínez Actualizada	\N	+51987654325	ana.martinez.nuevo@email.com	1992-03-10	vivo	2025-09-09 22:24:25.616	activo	DNI	9988776372
30	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez.1757438665872@email.com	1988-12-05	vivo	2025-09-09 22:24:26.283	activo	DNI	5544332872
31	Test Patient	\N	+51987654322	test.1757438685178@email.com	1990-05-15	vivo	2025-09-09 22:24:46.399	activo	DNI	test1757438685178
32	María García	\N	+51987654322	maria.garcia.1757438718249@email.com	1990-05-15	vivo	2025-09-09 22:25:18.506	activo	DNI	8765432249
33	Carlos López	\N	+51987654323	carlos.lopez.1757438718599@email.com	1985-08-20	vivo	2025-09-09 22:25:18.844	activo	DNI	1122334599
37	Nelson Giménez	DNI 987987987	+51987987987	njgimenez@gmail.com	\N	vivo	2025-09-19 19:02:58.567603	activo	DNI	\N
38	Carmen gil	DNI 987456321	+51987456321	nsnsn@haha.com	\N	vivo	2025-09-19 19:05:17.724295	activo	DNI	\N
39	Jorge Chavez	DNI 456789123	+51984525871	nshsh@gsgsgh.com	\N	vivo	2025-09-19 21:43:29.255902	activo	DNI	\N
40	Nelson J	DNI 12345678	+51984561237	njfimen@hdhd.com	\N	vivo	2025-09-25 20:42:07.350083	activo	DNI	\N
1	Juan Pérez	11223344	999888777	jperez@mail.com	\N	vivo	2025-08-08 16:19:23.857	activo	DNI	11223344
2	María López	44332211	777888999	mlopez@mail.com	\N	vivo	2025-08-08 16:19:23.857	activo	DNI	44332211
3	Roberto Silva	55667788	666777888	rsilva@mail.com	\N	vivo	2025-08-08 16:19:23.857	activo	DNI	55667788
13	Carlos López	\N	+51987654323	carlos.lopez@email.com	1985-08-20	vivo	2025-09-09 22:20:34.158	activo	DNI	\N
14	Ana Martínez	\N	+51987654324	ana.martinez@email.com	1992-03-10	vivo	2025-09-09 22:20:37.824	activo	DNI	\N
15	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez@email.com	1988-12-05	vivo	2025-09-09 22:20:39.443	activo	DNI	\N
16	María García	\N	+51987654322	maria.garcia@email.com	1990-05-15	vivo	2025-09-09 22:22:24.27	activo	DNI	87654321
17	Ana Martínez	\N	+51987654324	ana.martinez@email.com	1992-03-10	vivo	2025-09-09 22:22:25.028	activo	DNI	99887766
18	Pedro Rodríguez	\N	+51987654326	pedro.rodriguez@email.com	1988-12-05	vivo	2025-09-09 22:22:26.902	activo	DNI	55443322
19	María García	\N	+51987654322	maria.garcia.1757438615877@email.com	1990-05-15	vivo	2025-09-09 22:23:36.123	activo	DNI	8765432877
41	Carmen Yanina Ceccarelli Leon de Gutierrez 	cc 10004162	964642934	financialconsultingm@gmail.com	\N	vivo	2025-12-06 20:23:22.779966	activo	DNI	\N
42	claudia Bustios Alva	cc 09935765	+51993044108	mbustiosalva@gmail.com	\N	vivo	2025-12-10 00:13:08.532651	activo	DNI	\N
\.


--
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permisos (id, nombre, descripcion) FROM stdin;
\.


--
-- Data for Name: rol_permiso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol_permiso (id, rol_id, permiso_id) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, nombre, descripcion) FROM stdin;
1	admin	Administrador del sistema
\.


--
-- Data for Name: usuario_rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_rol (id, usuario_id, rol_id) FROM stdin;
1	1	1
2	2	1
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, correo, "contraseña", estado, fecha_creacion) FROM stdin;
1	admin	admin@onkos.com	$2b$10$45Na29q3OlCmgba1/vIFWuF6/EkmcAB1Pt8CKqblQG.IkCEGG8ndq	activo	2025-08-08 16:29:11.04
2	Nelson	ngimenez@onkos.pe	$2b$10$CE/BfBiKFBRSu9lNK0iJ2.Ial2E7O9NmTS6j7BnMVvQl6rfVIwFE2	activo	2025-09-19 21:41:43.597705
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-09-26 17:32:52
20211116045059	2025-09-26 17:32:54
20211116050929	2025-09-26 17:32:57
20211116051442	2025-09-26 17:32:59
20211116212300	2025-09-26 17:33:01
20211116213355	2025-09-26 17:33:03
20211116213934	2025-09-26 17:33:05
20211116214523	2025-09-26 17:33:08
20211122062447	2025-09-26 17:33:10
20211124070109	2025-09-26 17:33:12
20211202204204	2025-09-26 17:33:14
20211202204605	2025-09-26 17:33:16
20211210212804	2025-09-26 17:33:23
20211228014915	2025-09-26 17:33:25
20220107221237	2025-09-26 17:33:27
20220228202821	2025-09-26 17:33:29
20220312004840	2025-09-26 17:33:31
20220603231003	2025-09-26 17:33:34
20220603232444	2025-09-26 17:33:36
20220615214548	2025-09-26 17:33:39
20220712093339	2025-09-26 17:33:41
20220908172859	2025-09-26 17:33:43
20220916233421	2025-09-26 17:33:45
20230119133233	2025-09-26 17:33:47
20230128025114	2025-09-26 17:33:50
20230128025212	2025-09-26 17:33:52
20230227211149	2025-09-26 17:33:54
20230228184745	2025-09-26 17:33:56
20230308225145	2025-09-26 17:33:58
20230328144023	2025-09-26 17:34:00
20231018144023	2025-09-26 17:34:02
20231204144023	2025-09-26 17:34:06
20231204144024	2025-09-26 17:34:08
20231204144025	2025-09-26 17:34:10
20240108234812	2025-09-26 17:34:12
20240109165339	2025-09-26 17:34:14
20240227174441	2025-09-26 17:34:17
20240311171622	2025-09-26 17:34:20
20240321100241	2025-09-26 17:34:25
20240401105812	2025-09-26 17:34:30
20240418121054	2025-09-26 17:34:33
20240523004032	2025-09-26 17:34:41
20240618124746	2025-09-26 17:34:43
20240801235015	2025-09-26 17:34:45
20240805133720	2025-09-26 17:34:47
20240827160934	2025-09-26 17:34:49
20240919163303	2025-09-26 17:34:52
20240919163305	2025-09-26 17:34:54
20241019105805	2025-09-26 17:34:56
20241030150047	2025-09-26 17:35:04
20241108114728	2025-09-26 17:35:06
20241121104152	2025-09-26 17:35:08
20241130184212	2025-09-26 17:35:11
20241220035512	2025-09-26 17:35:13
20241220123912	2025-09-26 17:35:15
20241224161212	2025-09-26 17:35:17
20250107150512	2025-09-26 17:35:19
20250110162412	2025-09-26 17:35:21
20250123174212	2025-09-26 17:35:23
20250128220012	2025-09-26 17:35:25
20250506224012	2025-09-26 17:35:27
20250523164012	2025-09-26 17:35:29
20250714121412	2025-09-26 17:35:31
20250905041441	2025-09-26 17:35:33
20251103001201	2025-11-21 17:17:16
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-09-26 17:32:47.674366
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-09-26 17:32:47.725562
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-09-26 17:32:47.731613
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-09-26 17:32:47.835547
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-09-26 17:32:47.907201
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-09-26 17:32:47.910148
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-09-26 17:32:47.923009
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-09-26 17:32:47.92641
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-09-26 17:32:47.929184
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-09-26 17:32:47.932301
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-09-26 17:32:47.936126
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-09-26 17:32:47.940006
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-09-26 17:32:47.951879
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-09-26 17:32:47.954911
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-09-26 17:32:47.960267
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-09-26 17:32:48.029418
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-09-26 17:32:48.034732
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-09-26 17:32:48.037544
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-09-26 17:32:48.050267
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-09-26 17:32:48.063745
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-09-26 17:32:48.07127
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-09-26 17:32:48.078557
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-09-26 17:32:48.098434
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-09-26 17:32:48.127701
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-09-26 17:32:48.131355
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-09-26 17:32:48.138858
26	objects-prefixes	ef3f7871121cdc47a65308e6702519e853422ae2	2025-10-11 16:51:52.635733
27	search-v2	33b8f2a7ae53105f028e13e9fcda9dc4f356b4a2	2025-10-11 16:51:52.764773
28	object-bucket-name-sorting	ba85ec41b62c6a30a3f136788227ee47f311c436	2025-10-11 16:51:52.775946
29	create-prefixes	a7b1a22c0dc3ab630e3055bfec7ce7d2045c5b7b	2025-10-11 16:51:52.784022
30	update-object-levels	6c6f6cc9430d570f26284a24cf7b210599032db7	2025-10-11 16:51:52.787692
31	objects-level-index	33f1fef7ec7fea08bb892222f4f0f5d79bab5eb8	2025-10-11 16:51:52.793574
32	backward-compatible-index-on-objects	2d51eeb437a96868b36fcdfb1ddefdf13bef1647	2025-10-11 16:51:52.80037
33	backward-compatible-index-on-prefixes	fe473390e1b8c407434c0e470655945b110507bf	2025-10-11 16:51:52.808038
34	optimize-search-function-v1	82b0e469a00e8ebce495e29bfa70a0797f7ebd2c	2025-10-11 16:51:52.80971
35	add-insert-trigger-prefixes	63bb9fd05deb3dc5e9fa66c83e82b152f0caf589	2025-10-11 16:51:52.815684
36	optimise-existing-functions	81cf92eb0c36612865a18016a38496c530443899	2025-10-11 16:51:52.821182
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2025-10-11 16:51:52.837269
38	iceberg-catalog-flag-on-buckets	19a8bd89d5dfa69af7f222a46c726b7c41e462c5	2025-10-11 16:51:52.841718
39	add-search-v2-sort-support	39cf7d1e6bf515f4b02e41237aba845a7b492853	2025-10-11 16:51:52.878082
40	fix-prefix-race-conditions-optimized	fd02297e1c67df25a9fc110bf8c8a9af7fb06d1f	2025-10-11 16:51:52.882982
41	add-object-level-update-trigger	44c22478bf01744b2129efc480cd2edc9a7d60e9	2025-10-11 16:51:52.894464
42	rollback-prefix-triggers	f2ab4f526ab7f979541082992593938c05ee4b47	2025-10-11 16:51:52.901338
43	fix-object-level	ab837ad8f1c7d00cc0b7310e989a23388ff29fc6	2025-10-11 16:51:52.908715
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2025-11-21 17:17:20.447731
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2025-11-21 17:17:20.460323
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2025-11-21 17:17:20.506136
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2025-11-21 17:17:20.509463
48	iceberg-catalog-ids	2666dff93346e5d04e0a878416be1d5fec345d6f	2025-11-21 17:17:20.511685
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata, level) FROM stdin;
\.


--
-- Data for Name: prefixes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.prefixes (bucket_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_id_seq', 7, true);


--
-- Name: centro_medico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.centro_medico_id_seq', 1, false);


--
-- Name: citas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citas_id_seq', 28, true);


--
-- Name: entrada_categorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entrada_categorias_id_seq', 65, true);


--
-- Name: entradas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entradas_id_seq', 52, true);


--
-- Name: especialidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialidades_id_seq', 4, true);


--
-- Name: historial_citas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_citas_id_seq', 1, false);


--
-- Name: horarios_medicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.horarios_medicos_id_seq', 1, false);


--
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.media_id_seq', 171, true);


--
-- Name: medicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicos_id_seq', 4, true);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 4, true);


--
-- Name: pacientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pacientes_id_seq', 42, true);


--
-- Name: permisos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permisos_id_seq', 1, false);


--
-- Name: rol_permiso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_permiso_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 1, true);


--
-- Name: usuario_rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_rol_id_seq', 2, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 2, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_slug_key UNIQUE (slug);


--
-- Name: centro_medico centro_medico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centro_medico
    ADD CONSTRAINT centro_medico_pkey PRIMARY KEY (id);


--
-- Name: citas citas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_pkey PRIMARY KEY (id);


--
-- Name: entrada_categorias entrada_categorias_entrada_id_categoria_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entrada_categorias
    ADD CONSTRAINT entrada_categorias_entrada_id_categoria_id_key UNIQUE (entrada_id, categoria_id);


--
-- Name: entrada_categorias entrada_categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entrada_categorias
    ADD CONSTRAINT entrada_categorias_pkey PRIMARY KEY (id);


--
-- Name: entradas entradas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entradas
    ADD CONSTRAINT entradas_pkey PRIMARY KEY (id);


--
-- Name: entradas entradas_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entradas
    ADD CONSTRAINT entradas_slug_key UNIQUE (slug);


--
-- Name: especialidades especialidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades
    ADD CONSTRAINT especialidades_pkey PRIMARY KEY (id);


--
-- Name: historial_citas historial_citas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_citas
    ADD CONSTRAINT historial_citas_pkey PRIMARY KEY (id);


--
-- Name: horarios_medicos horarios_medicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios_medicos
    ADD CONSTRAINT horarios_medicos_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: medicos medicos_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicos
    ADD CONSTRAINT medicos_dni_key UNIQUE (dni);


--
-- Name: medicos medicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicos
    ADD CONSTRAINT medicos_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: pacientes pacientes_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_dni_key UNIQUE (dni);


--
-- Name: pacientes pacientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pacientes
    ADD CONSTRAINT pacientes_pkey PRIMARY KEY (id);


--
-- Name: permisos permisos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_nombre_key UNIQUE (nombre);


--
-- Name: permisos permisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pkey PRIMARY KEY (id);


--
-- Name: rol_permiso rol_permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_pkey PRIMARY KEY (id);


--
-- Name: rol_permiso rol_permiso_rol_id_permiso_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_rol_id_permiso_id_key UNIQUE (rol_id, permiso_id);


--
-- Name: roles roles_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_key UNIQUE (nombre);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: usuario_rol usuario_rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_pkey PRIMARY KEY (id);


--
-- Name: usuario_rol usuario_rol_usuario_id_rol_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_usuario_id_rol_id_key UNIQUE (usuario_id, rol_id);


--
-- Name: usuarios usuarios_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_correo_key UNIQUE (correo);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_categorias_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categorias_slug ON public.categorias USING btree (slug);


--
-- Name: idx_citas_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_citas_estado ON public.citas USING btree (estado);


--
-- Name: idx_citas_medico_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_citas_medico_fecha ON public.citas USING btree (medico_id, fecha);


--
-- Name: idx_citas_paciente_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_citas_paciente_fecha ON public.citas USING btree (paciente_id, fecha);


--
-- Name: idx_entradas_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entradas_estado ON public.entradas USING btree (estado);


--
-- Name: idx_entradas_fecha_publicacion; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entradas_fecha_publicacion ON public.entradas USING btree (fecha_publicacion);


--
-- Name: idx_entradas_slug; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_entradas_slug ON public.entradas USING btree (slug);


--
-- Name: idx_historial_por_cita; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_historial_por_cita ON public.historial_citas USING btree (cita_id);


--
-- Name: idx_horarios_medico_dia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_horarios_medico_dia ON public.horarios_medicos USING btree (medico_id, dia_semana);


--
-- Name: idx_medicos_especialidad_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medicos_especialidad_estado ON public.medicos USING btree (especialidad_id, estado);


--
-- Name: idx_medicos_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_medicos_nombre ON public.medicos USING btree (nombre);


--
-- Name: idx_menu_items_orden; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_menu_items_orden ON public.menu_items USING btree (orden);


--
-- Name: idx_menu_items_parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_menu_items_parent ON public.menu_items USING btree (parent_id);


--
-- Name: idx_pacientes_dni; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_pacientes_dni ON public.pacientes USING btree (dni);


--
-- Name: idx_usuario_correo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_correo ON public.usuarios USING btree (correo);


--
-- Name: idx_usuario_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_estado ON public.usuarios USING btree (estado);


--
-- Name: idx_usuario_rol_rol; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_rol_rol ON public.usuario_rol USING btree (rol_id);


--
-- Name: idx_usuario_rol_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_rol_usuario ON public.usuario_rol USING btree (usuario_id);


--
-- Name: idx_usuarios_correo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_correo ON public.usuarios USING btree (correo);


--
-- Name: idx_usuarios_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_estado ON public.usuarios USING btree (estado);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_name_bucket_level_unique; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_name_bucket_level_unique ON storage.objects USING btree (name COLLATE "C", bucket_id, level);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_lower_name ON storage.objects USING btree ((path_tokens[level]), lower(name) text_pattern_ops, bucket_id, level);


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_bucket_id_level_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_level_idx ON storage.objects USING btree (bucket_id, level, name COLLATE "C");


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: citas citas_medico_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_medico_id_fkey FOREIGN KEY (medico_id) REFERENCES public.medicos(id);


--
-- Name: citas citas_paciente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citas
    ADD CONSTRAINT citas_paciente_id_fkey FOREIGN KEY (paciente_id) REFERENCES public.pacientes(id);


--
-- Name: entradas entradas_autor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entradas
    ADD CONSTRAINT entradas_autor_id_fkey FOREIGN KEY (autor_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- Name: historial_citas historial_citas_cita_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_citas
    ADD CONSTRAINT historial_citas_cita_id_fkey FOREIGN KEY (cita_id) REFERENCES public.citas(id);


--
-- Name: horarios_medicos horarios_medicos_medico_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horarios_medicos
    ADD CONSTRAINT horarios_medicos_medico_id_fkey FOREIGN KEY (medico_id) REFERENCES public.medicos(id);


--
-- Name: media media_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- Name: medicos medicos_centro_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicos
    ADD CONSTRAINT medicos_centro_id_fkey FOREIGN KEY (centro_id) REFERENCES public.centro_medico(id);


--
-- Name: medicos medicos_especialidad_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicos
    ADD CONSTRAINT medicos_especialidad_id_fkey FOREIGN KEY (especialidad_id) REFERENCES public.especialidades(id);


--
-- Name: menu_items menu_items_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: rol_permiso rol_permiso_permiso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_permiso_id_fkey FOREIGN KEY (permiso_id) REFERENCES public.permisos(id) ON DELETE CASCADE;


--
-- Name: rol_permiso rol_permiso_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: usuario_rol usuario_rol_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: usuario_rol usuario_rol_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_rol
    ADD CONSTRAINT usuario_rol_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: categorias beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.categorias FOR DELETE TO authenticated USING (true);


--
-- Name: centro_medico beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.centro_medico FOR DELETE TO authenticated USING (true);


--
-- Name: citas beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.citas FOR DELETE TO authenticated USING (true);


--
-- Name: entrada_categorias beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.entrada_categorias FOR DELETE TO authenticated USING (true);


--
-- Name: entradas beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.entradas FOR DELETE TO authenticated USING (true);


--
-- Name: especialidades beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.especialidades FOR DELETE TO authenticated USING (true);


--
-- Name: historial_citas beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.historial_citas FOR DELETE TO authenticated USING (true);


--
-- Name: horarios_medicos beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.horarios_medicos FOR DELETE TO authenticated USING (true);


--
-- Name: media beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.media FOR DELETE TO authenticated USING (true);


--
-- Name: medicos beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.medicos FOR DELETE TO authenticated USING (true);


--
-- Name: menu_items beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.menu_items FOR DELETE TO authenticated USING (true);


--
-- Name: pacientes beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.pacientes FOR DELETE TO authenticated USING (true);


--
-- Name: permisos beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.permisos FOR DELETE TO authenticated USING (true);


--
-- Name: rol_permiso beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.rol_permiso FOR DELETE TO authenticated USING (true);


--
-- Name: roles beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.roles FOR DELETE TO authenticated USING (true);


--
-- Name: usuario_rol beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.usuario_rol FOR DELETE TO authenticated USING (true);


--
-- Name: usuarios beta_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_delete ON public.usuarios FOR DELETE TO authenticated USING (true);


--
-- Name: categorias beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.categorias FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: centro_medico beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.centro_medico FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: citas beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.citas FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: entrada_categorias beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.entrada_categorias FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: entradas beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.entradas FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: especialidades beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.especialidades FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: historial_citas beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.historial_citas FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: horarios_medicos beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.horarios_medicos FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: media beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.media FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: medicos beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.medicos FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: menu_items beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.menu_items FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: pacientes beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.pacientes FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: permisos beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.permisos FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: rol_permiso beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.rol_permiso FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: roles beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.roles FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: usuario_rol beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.usuario_rol FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: usuarios beta_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_insert ON public.usuarios FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: categorias beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.categorias FOR SELECT TO authenticated USING (true);


--
-- Name: centro_medico beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.centro_medico FOR SELECT TO authenticated USING (true);


--
-- Name: citas beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.citas FOR SELECT TO authenticated USING (true);


--
-- Name: entrada_categorias beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.entrada_categorias FOR SELECT TO authenticated USING (true);


--
-- Name: entradas beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.entradas FOR SELECT TO authenticated USING (true);


--
-- Name: especialidades beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.especialidades FOR SELECT TO authenticated USING (true);


--
-- Name: historial_citas beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.historial_citas FOR SELECT TO authenticated USING (true);


--
-- Name: horarios_medicos beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.horarios_medicos FOR SELECT TO authenticated USING (true);


--
-- Name: media beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.media FOR SELECT TO authenticated USING (true);


--
-- Name: medicos beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.medicos FOR SELECT TO authenticated USING (true);


--
-- Name: menu_items beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.menu_items FOR SELECT TO authenticated USING (true);


--
-- Name: pacientes beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.pacientes FOR SELECT TO authenticated USING (true);


--
-- Name: permisos beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.permisos FOR SELECT TO authenticated USING (true);


--
-- Name: rol_permiso beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.rol_permiso FOR SELECT TO authenticated USING (true);


--
-- Name: roles beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.roles FOR SELECT TO authenticated USING (true);


--
-- Name: usuario_rol beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.usuario_rol FOR SELECT TO authenticated USING (true);


--
-- Name: usuarios beta_select; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_select ON public.usuarios FOR SELECT TO authenticated USING (true);


--
-- Name: categorias beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.categorias FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: centro_medico beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.centro_medico FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: citas beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.citas FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: entrada_categorias beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.entrada_categorias FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: entradas beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.entradas FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: especialidades beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.especialidades FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: historial_citas beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.historial_citas FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: horarios_medicos beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.horarios_medicos FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: media beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.media FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: medicos beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.medicos FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: menu_items beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.menu_items FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: pacientes beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.pacientes FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: permisos beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.permisos FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: rol_permiso beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.rol_permiso FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: roles beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.roles FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: usuario_rol beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.usuario_rol FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: usuarios beta_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY beta_update ON public.usuarios FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: categorias; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.categorias ENABLE ROW LEVEL SECURITY;

--
-- Name: centro_medico; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.centro_medico ENABLE ROW LEVEL SECURITY;

--
-- Name: citas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.citas ENABLE ROW LEVEL SECURITY;

--
-- Name: entrada_categorias; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.entrada_categorias ENABLE ROW LEVEL SECURITY;

--
-- Name: entradas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.entradas ENABLE ROW LEVEL SECURITY;

--
-- Name: especialidades; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.especialidades ENABLE ROW LEVEL SECURITY;

--
-- Name: historial_citas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.historial_citas ENABLE ROW LEVEL SECURITY;

--
-- Name: horarios_medicos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.horarios_medicos ENABLE ROW LEVEL SECURITY;

--
-- Name: media; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.media ENABLE ROW LEVEL SECURITY;

--
-- Name: medicos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.medicos ENABLE ROW LEVEL SECURITY;

--
-- Name: menu_items; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;

--
-- Name: pacientes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.pacientes ENABLE ROW LEVEL SECURITY;

--
-- Name: permisos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.permisos ENABLE ROW LEVEL SECURITY;

--
-- Name: rol_permiso; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rol_permiso ENABLE ROW LEVEL SECURITY;

--
-- Name: roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ENABLE ROW LEVEL SECURITY;

--
-- Name: usuario_rol; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario_rol ENABLE ROW LEVEL SECURITY;

--
-- Name: usuarios; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;
GRANT USAGE ON SCHEMA public TO onkos_user;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE categorias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categorias TO anon;
GRANT ALL ON TABLE public.categorias TO authenticated;
GRANT ALL ON TABLE public.categorias TO service_role;
GRANT ALL ON TABLE public.categorias TO onkos_user;


--
-- Name: SEQUENCE categorias_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.categorias_id_seq TO anon;
GRANT ALL ON SEQUENCE public.categorias_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.categorias_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.categorias_id_seq TO onkos_user;


--
-- Name: TABLE centro_medico; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.centro_medico TO anon;
GRANT ALL ON TABLE public.centro_medico TO authenticated;
GRANT ALL ON TABLE public.centro_medico TO service_role;
GRANT ALL ON TABLE public.centro_medico TO onkos_user;


--
-- Name: SEQUENCE centro_medico_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.centro_medico_id_seq TO anon;
GRANT ALL ON SEQUENCE public.centro_medico_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.centro_medico_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.centro_medico_id_seq TO onkos_user;


--
-- Name: TABLE citas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.citas TO anon;
GRANT ALL ON TABLE public.citas TO authenticated;
GRANT ALL ON TABLE public.citas TO service_role;
GRANT ALL ON TABLE public.citas TO onkos_user;


--
-- Name: SEQUENCE citas_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.citas_id_seq TO anon;
GRANT ALL ON SEQUENCE public.citas_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.citas_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.citas_id_seq TO onkos_user;


--
-- Name: TABLE entrada_categorias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.entrada_categorias TO anon;
GRANT ALL ON TABLE public.entrada_categorias TO authenticated;
GRANT ALL ON TABLE public.entrada_categorias TO service_role;
GRANT ALL ON TABLE public.entrada_categorias TO onkos_user;


--
-- Name: SEQUENCE entrada_categorias_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.entrada_categorias_id_seq TO anon;
GRANT ALL ON SEQUENCE public.entrada_categorias_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.entrada_categorias_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.entrada_categorias_id_seq TO onkos_user;


--
-- Name: TABLE entradas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.entradas TO anon;
GRANT ALL ON TABLE public.entradas TO authenticated;
GRANT ALL ON TABLE public.entradas TO service_role;
GRANT ALL ON TABLE public.entradas TO onkos_user;


--
-- Name: SEQUENCE entradas_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.entradas_id_seq TO anon;
GRANT ALL ON SEQUENCE public.entradas_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.entradas_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.entradas_id_seq TO onkos_user;


--
-- Name: TABLE especialidades; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.especialidades TO anon;
GRANT ALL ON TABLE public.especialidades TO authenticated;
GRANT ALL ON TABLE public.especialidades TO service_role;
GRANT ALL ON TABLE public.especialidades TO onkos_user;


--
-- Name: SEQUENCE especialidades_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.especialidades_id_seq TO anon;
GRANT ALL ON SEQUENCE public.especialidades_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.especialidades_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.especialidades_id_seq TO onkos_user;


--
-- Name: TABLE historial_citas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.historial_citas TO anon;
GRANT ALL ON TABLE public.historial_citas TO authenticated;
GRANT ALL ON TABLE public.historial_citas TO service_role;
GRANT ALL ON TABLE public.historial_citas TO onkos_user;


--
-- Name: SEQUENCE historial_citas_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.historial_citas_id_seq TO anon;
GRANT ALL ON SEQUENCE public.historial_citas_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.historial_citas_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.historial_citas_id_seq TO onkos_user;


--
-- Name: TABLE horarios_medicos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.horarios_medicos TO anon;
GRANT ALL ON TABLE public.horarios_medicos TO authenticated;
GRANT ALL ON TABLE public.horarios_medicos TO service_role;
GRANT ALL ON TABLE public.horarios_medicos TO onkos_user;


--
-- Name: SEQUENCE horarios_medicos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.horarios_medicos_id_seq TO anon;
GRANT ALL ON SEQUENCE public.horarios_medicos_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.horarios_medicos_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.horarios_medicos_id_seq TO onkos_user;


--
-- Name: TABLE media; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.media TO anon;
GRANT ALL ON TABLE public.media TO authenticated;
GRANT ALL ON TABLE public.media TO service_role;
GRANT ALL ON TABLE public.media TO onkos_user;


--
-- Name: SEQUENCE media_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.media_id_seq TO anon;
GRANT ALL ON SEQUENCE public.media_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.media_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.media_id_seq TO onkos_user;


--
-- Name: TABLE medicos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.medicos TO anon;
GRANT ALL ON TABLE public.medicos TO authenticated;
GRANT ALL ON TABLE public.medicos TO service_role;
GRANT ALL ON TABLE public.medicos TO onkos_user;


--
-- Name: SEQUENCE medicos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.medicos_id_seq TO anon;
GRANT ALL ON SEQUENCE public.medicos_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.medicos_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.medicos_id_seq TO onkos_user;


--
-- Name: TABLE menu_items; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.menu_items TO anon;
GRANT ALL ON TABLE public.menu_items TO authenticated;
GRANT ALL ON TABLE public.menu_items TO service_role;
GRANT ALL ON TABLE public.menu_items TO onkos_user;


--
-- Name: SEQUENCE menu_items_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.menu_items_id_seq TO anon;
GRANT ALL ON SEQUENCE public.menu_items_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.menu_items_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.menu_items_id_seq TO onkos_user;


--
-- Name: TABLE pacientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pacientes TO anon;
GRANT ALL ON TABLE public.pacientes TO authenticated;
GRANT ALL ON TABLE public.pacientes TO service_role;
GRANT ALL ON TABLE public.pacientes TO onkos_user;


--
-- Name: SEQUENCE pacientes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.pacientes_id_seq TO anon;
GRANT ALL ON SEQUENCE public.pacientes_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.pacientes_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.pacientes_id_seq TO onkos_user;


--
-- Name: TABLE permisos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.permisos TO anon;
GRANT ALL ON TABLE public.permisos TO authenticated;
GRANT ALL ON TABLE public.permisos TO service_role;
GRANT ALL ON TABLE public.permisos TO onkos_user;


--
-- Name: SEQUENCE permisos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.permisos_id_seq TO anon;
GRANT ALL ON SEQUENCE public.permisos_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.permisos_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.permisos_id_seq TO onkos_user;


--
-- Name: TABLE rol_permiso; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rol_permiso TO anon;
GRANT ALL ON TABLE public.rol_permiso TO authenticated;
GRANT ALL ON TABLE public.rol_permiso TO service_role;
GRANT ALL ON TABLE public.rol_permiso TO onkos_user;


--
-- Name: SEQUENCE rol_permiso_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.rol_permiso_id_seq TO anon;
GRANT ALL ON SEQUENCE public.rol_permiso_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.rol_permiso_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.rol_permiso_id_seq TO onkos_user;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.roles TO anon;
GRANT ALL ON TABLE public.roles TO authenticated;
GRANT ALL ON TABLE public.roles TO service_role;
GRANT ALL ON TABLE public.roles TO onkos_user;


--
-- Name: SEQUENCE roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.roles_id_seq TO anon;
GRANT ALL ON SEQUENCE public.roles_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.roles_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.roles_id_seq TO onkos_user;


--
-- Name: TABLE usuario_rol; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuario_rol TO anon;
GRANT ALL ON TABLE public.usuario_rol TO authenticated;
GRANT ALL ON TABLE public.usuario_rol TO service_role;
GRANT ALL ON TABLE public.usuario_rol TO onkos_user;


--
-- Name: SEQUENCE usuario_rol_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuario_rol_id_seq TO anon;
GRANT ALL ON SEQUENCE public.usuario_rol_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.usuario_rol_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.usuario_rol_id_seq TO onkos_user;


--
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuarios TO anon;
GRANT ALL ON TABLE public.usuarios TO authenticated;
GRANT ALL ON TABLE public.usuarios TO service_role;
GRANT ALL ON TABLE public.usuarios TO onkos_user;


--
-- Name: SEQUENCE usuarios_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuarios_id_seq TO anon;
GRANT ALL ON SEQUENCE public.usuarios_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.usuarios_id_seq TO service_role;
GRANT ALL ON SEQUENCE public.usuarios_id_seq TO onkos_user;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE prefixes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.prefixes TO service_role;
GRANT ALL ON TABLE storage.prefixes TO authenticated;
GRANT ALL ON TABLE storage.prefixes TO anon;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO onkos_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO onkos_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO onkos_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO onkos_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO onkos_user;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict qXr3sUdnp4TuBo5Jc2qr2gUSmi4Fmb6MIZY3xym0YOOAaPTW20ZJM7mTW8ZlgfK

