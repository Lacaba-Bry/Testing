--
-- PostgreSQL database dump
--

\restrict wCzY7145MDN9nU3hIw8aI72WO2fnmwqMORzWRHICCdcqIEEhy3Nhxz0Z3XUyLjo

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.6

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
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


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
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


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
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO postgres;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

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
    'phone',
    'recovery_code'
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
-- Name: role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role AS ENUM (
    'owner',
    'staff',
    'admin'
);


ALTER TYPE public.role OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'owner',
    'staff',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_realtime_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in',
    'like',
    'ilike',
    'is',
    'match',
    'imatch',
    'isdistinct'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_realtime_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text,
	negate boolean
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_realtime_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_realtime_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_realtime_admin;

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
    SET search_path TO ''
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
    revoke trigger on cron.job_run_details from postgres;
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
    SET search_path TO ''
    AS $_$
begin
    if not exists (
        select 1
        from pg_catalog.pg_event_trigger_ddl_commands() ev
        join pg_catalog.pg_extension e on ev.objid = e.oid
        where e.extname = 'pg_graphql'
    ) then
        return;
    end if;

    drop function if exists graphql_public.graphql;
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

    -- Attach the wrapper to the extension so DROP EXTENSION cascades to it,
    -- which in turn triggers set_graphql_placeholder to reinstall the "not enabled" stub.
    alter extension pg_graphql add function graphql_public.graphql(text, text, jsonb, jsonb);

    grant usage on schema graphql to postgres, anon, authenticated, service_role;
    grant execute on function graphql.resolve to postgres, anon, authenticated, service_role;
    grant usage on schema graphql to postgres with grant option;
    grant usage on schema graphql_public to postgres with grant option;
end;
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
    SET search_path TO ''
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
    SET search_path TO ''
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
    SET search_path TO ''
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
            set search_path to ''
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
-- Name: graphql(text, text, jsonb, jsonb); Type: FUNCTION; Schema: graphql_public; Owner: supabase_admin
--

CREATE FUNCTION graphql_public.graphql("operationName" text DEFAULT NULL::text, query text DEFAULT NULL::text, variables jsonb DEFAULT NULL::jsonb, extensions jsonb DEFAULT NULL::jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) OWNER TO supabase_admin;

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
-- Name: carefur_block_cloud_when_rtc_active(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_block_cloud_when_rtc_active() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  -- Lock before reading RTC status; movement and RTC saves use the same lock.
  PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended('carefur:feeder:' || NEW.device_code, 0));
  IF NEW.status IN ('pending','claimed') AND EXISTS (
    SELECT 1 FROM public.feeder_rtc_configs rtc
    WHERE rtc.device_code=NEW.device_code AND rtc.enabled
      AND rtc.lease_expires_at > now()
  ) THEN RAISE EXCEPTION 'Cloud motor commands blocked while RTC feeding is enabled'; END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_block_cloud_when_rtc_active() OWNER TO postgres;

--
-- Name: carefur_boarding_staff(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_boarding_staff() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select exists (select 1 from public.users u where u.id = (select auth.uid()) and u.role::text in ('admin','staff'));
$$;


ALTER FUNCTION public.carefur_boarding_staff() OWNER TO postgres;

--
-- Name: carefur_can_view_boarding_camera(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_can_view_boarding_camera(p_booking_id uuid, p_camera_device_code text) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$

SELECT
    (SELECT auth.uid()) IS NOT NULL
    AND EXISTS (
        SELECT 1
        FROM public.bookings b

        JOIN public.booking_access ba
            ON ba.booking_id = b.id

        JOIN public.room_devices rd
            ON rd.room_id = b.room_id

        JOIN public.devices d
            ON d.id = rd.device_id

        WHERE b.id = p_booking_id

          -- Access belongs to the actual signed-in
          -- Supabase user who redeemed the boarding code.
          AND ba.redeemed_by_user_id = (SELECT auth.uid())
          AND ba.redeemed_at IS NOT NULL
          AND ba.revoked_at IS NULL

          -- The access code itself must remain valid.
          AND (
              ba.expires_at IS NULL
              OR ba.expires_at > now()
          )

          -- Boarding must currently be active.
          AND b.status = 'checked_in'
          AND b.check_in_at <= now()
          AND b.actual_check_out_at IS NULL
          AND b.expected_check_out_at > now()

          -- The assigned camera must still belong
          -- to the boarding room.
          AND rd.unassigned_at IS NULL
          AND rd.assigned_at <= now()

          -- Only an active camera with the requested
          -- device code can be viewed.
          AND d.device_type = 'camera'
          AND d.status = 'active'
          AND d.device_code = p_camera_device_code

          -- Defense in depth: the redeemed account's
          -- email must still match the invitation.
          AND lower(trim(ba.invited_email)) =
              lower(trim(
                  COALESCE(
                      (SELECT auth.jwt() ->> 'email'),
                      ''
                  )
              ))
    );

$$;


ALTER FUNCTION public.carefur_can_view_boarding_camera(p_booking_id uuid, p_camera_device_code text) OWNER TO postgres;

--
-- Name: carefur_capture_extension_original_checkout(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_capture_extension_original_checkout() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  IF NEW.original_checkout_at IS NULL THEN
    SELECT b.expected_check_out_at INTO NEW.original_checkout_at
    FROM public.bookings b WHERE b.id = NEW.booking_id;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_capture_extension_original_checkout() OWNER TO postgres;

--
-- Name: carefur_claim_paid_reservation_sms(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_claim_paid_reservation_sms(p_request_id uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE r public.reservation_requests%ROWTYPE;
BEGIN
  IF NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;
  SELECT * INTO r FROM public.reservation_requests WHERE id=p_request_id FOR UPDATE;
  IF NOT FOUND OR r.status <> 'confirmed' OR r.boarding_booking_id IS NULL THEN
    RAISE EXCEPTION 'Boarding must exist before sending confirmation SMS';
  END IF;
  IF r.paid_sms_status = 'queued' OR
     (r.paid_sms_status='sending' AND r.paid_sms_updated_at > now()-interval '2 minutes')
  THEN RETURN false; END IF;
  UPDATE public.reservation_requests SET paid_sms_status='sending',
    paid_sms_error=NULL,paid_sms_updated_at=now() WHERE id=p_request_id;
  RETURN true;
END;
$$;


ALTER FUNCTION public.carefur_claim_paid_reservation_sms(p_request_id uuid) OWNER TO postgres;

--
-- Name: carefur_convert_paid_reservation(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_convert_paid_reservation(p_request_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  r public.reservation_requests%ROWTYPE;
  v_staff uuid := auth.uid();
  v_owner uuid;
  v_pet uuid;
  v_booking uuid;
  v_booking_code text;
  v_access_code text;
  v_owner_user uuid;
  v_tries integer;
BEGIN
  IF v_staff IS NULL OR NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;
  SELECT * INTO r FROM public.reservation_requests WHERE id = p_request_id FOR UPDATE;
  IF NOT FOUND THEN RAISE EXCEPTION 'Reservation not found'; END IF;
  IF r.boarding_booking_id IS NOT NULL THEN
    RETURN jsonb_build_object('success', true, 'already_paid', true,
      'booking_id', r.boarding_booking_id, 'sms_status', r.paid_sms_status);
  END IF;
  IF r.status NOT IN ('pending_payment','confirmed') THEN
    RAISE EXCEPTION 'Only pending or previously confirmed requests can be marked Paid';
  END IF;
  IF r.room_id IS NULL OR NOT EXISTS (
      SELECT 1 FROM public.rooms WHERE id = r.room_id AND status = 'active'
    ) THEN RAISE EXCEPTION 'Reservation room is missing or inactive'; END IF;
  IF r.expected_check_out_at <= r.check_in_at OR r.expected_check_out_at <= now() THEN
    RAISE EXCEPTION 'Invalid or expired boarding dates';
  END IF;
  IF nullif(trim(r.email),'') IS NULL OR nullif(trim(r.pet_name),'') IS NULL
      OR nullif(trim(r.pet_species),'') IS NULL THEN
    RAISE EXCEPTION 'Reservation requires an email, pet name, and pet species';
  END IF;

  -- Serialize paid conversions for the room. Other booking writers should also
  -- use this lock for full protection against cross-workflow races.
  PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(r.room_id::text, 684231));
  IF EXISTS (
    SELECT 1 FROM public.bookings b
    WHERE b.room_id = r.room_id AND b.status IN ('pending','checked_in')
      AND b.check_in_at < r.expected_check_out_at
      AND b.expected_check_out_at > r.check_in_at
  ) THEN RAISE EXCEPTION 'Room already has an overlapping boarding'; END IF;

  SELECT o.id INTO v_owner FROM public.owners o
    WHERE lower(trim(o.email)) = lower(trim(r.email)) LIMIT 1 FOR UPDATE;
  IF v_owner IS NULL THEN
    INSERT INTO public.owners(full_name,email,phone)
    VALUES (trim(r.owner_name),lower(trim(r.email)),r.phone)
    RETURNING id INTO v_owner;
  END IF;

  SELECT p.id INTO v_pet
  FROM public.pets p JOIN public.pet_owner_links l ON l.pet_id = p.id
  WHERE l.owner_id = v_owner AND lower(trim(p.name)) = lower(trim(r.pet_name))
    AND lower(trim(p.species)) = lower(trim(r.pet_species))
    AND lower(trim(coalesce(p.breed,''))) = lower(trim(coalesce(r.pet_breed,'')))
  ORDER BY p.created_at DESC LIMIT 1 FOR UPDATE OF p;
  IF v_pet IS NULL THEN
    INSERT INTO public.pets(name,species,breed,created_by)
    VALUES (trim(r.pet_name), trim(r.pet_species), nullif(trim(coalesce(r.pet_breed,'')),''),v_staff)
    RETURNING id INTO v_pet;
    INSERT INTO public.pet_owner_links(pet_id,owner_id,relationship,is_primary)
    VALUES(v_pet,v_owner,'owner',true);
  END IF;

  -- Create a standard pending boarding. Check-in remains a separate staff action.
  FOR v_tries IN 1..8 LOOP
    v_booking_code := 'CF-' || upper(substr(replace(gen_random_uuid()::text,'-',''),1,10));
    BEGIN
      INSERT INTO public.bookings(booking_code,pet_id,room_id,check_in_at,
        expected_check_out_at,status,special_instructions,created_by)
      VALUES(v_booking_code,v_pet,r.room_id,r.check_in_at,r.expected_check_out_at,
        'pending',r.special_instructions,v_staff)
      RETURNING id INTO v_booking;
      EXIT;
    EXCEPTION WHEN unique_violation THEN
      IF v_tries = 8 THEN RAISE; END IF;
    END;
  END LOOP;

  -- Booking access code is 8 uppercase alphanumerics (compatible with
  -- carefur_redeem_booking_code); only the SHA-256 hash is stored.
  v_access_code := upper(substr(replace(gen_random_uuid()::text,'-',''),1,8));
  SELECT u.id INTO v_owner_user FROM public.users u
  WHERE u.role::text = 'owner' AND lower(trim(u.email)) = lower(trim(r.email))
  LIMIT 1;
  INSERT INTO public.booking_access(booking_id,owner_id,invited_email,
      access_code_hash,expires_at,created_by)
  VALUES (v_booking,v_owner_user,lower(trim(r.email)),
    pg_catalog.encode(pg_catalog.sha256(pg_catalog.convert_to(v_access_code,'UTF8')),'hex'),
    greatest(r.expected_check_out_at,now()) + interval '1 day',v_staff);

  -- Reservation becomes CONFIRMED only AFTER boarding/access creation succeeds.
  UPDATE public.reservation_requests SET status='confirmed',boarding_booking_id=v_booking,
    paid_at=now(),paid_by=v_staff,updated_at=now(),
    paid_sms_status='not_sent',paid_sms_error=NULL,paid_sms_updated_at=NULL
  WHERE id=r.id;

  RETURN jsonb_build_object('success',true,'already_paid',false,
     'booking_id',v_booking,'booking_code',v_booking_code,
     'access_code',v_access_code,'request_code',r.request_code,
     'owner_name',r.owner_name,'phone',r.phone,'pet_name',r.pet_name,
     'room_number',coalesce(r.requested_room_number,''),
     'check_in_at',r.check_in_at,'expected_check_out_at',r.expected_check_out_at);
END;
$$;


ALTER FUNCTION public.carefur_convert_paid_reservation(p_request_id uuid) OWNER TO postgres;

--
-- Name: carefur_dispatch_confirmed_feeding(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_dispatch_confirmed_feeding() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  meal record;
  v_command uuid;
  v_count integer := 0;
BEGIN
  IF NOT pg_catalog.pg_try_advisory_xact_lock(85100935) THEN RETURN 0; END IF;

  FOR meal IN
    SELECT fs.id AS schedule_id, fs.compartment_number, fs.scheduled_at,
           b.id AS booking_id, coalesce(b.created_by, fs.created_by) AS created_by, d.device_code
    FROM public.feeding_schedules fs
    JOIN public.bookings b ON b.id=fs.booking_id
    JOIN public.room_devices rd ON rd.room_id=b.room_id AND rd.unassigned_at IS NULL
    JOIN public.devices d ON d.id=rd.device_id AND d.device_type='feeder' AND d.status='active'
    WHERE fs.feeding_method='automatic' AND fs.status='pending'
      AND fs.scheduled_at BETWEEN now()-interval '5 minutes' AND now()
      AND b.status='checked_in' AND b.actual_check_out_at IS NULL
      AND now() >= b.check_in_at AND now() < b.expected_check_out_at
      AND fs.compartment_number BETWEEN 1 AND 3
      AND coalesce(b.created_by, fs.created_by) IS NOT NULL
      AND (SELECT count(*) FROM public.room_devices rd2
           JOIN public.devices d2 ON d2.id=rd2.device_id
           WHERE rd2.room_id=b.room_id AND rd2.unassigned_at IS NULL
             AND d2.device_type='feeder' AND d2.status='active') = 1
      AND NOT EXISTS (
          SELECT 1 FROM public.feeder_rtc_configs rtc
          WHERE rtc.device_code=d.device_code AND rtc.enabled
      )
      AND NOT EXISTS (
          SELECT 1 FROM public.carefur_feeding_dispatches x WHERE x.schedule_id=fs.id
      )
    ORDER BY fs.scheduled_at, fs.id
    FOR UPDATE OF fs SKIP LOCKED
  LOOP
    -- Competing command writers must use the device row lock to synchronize
    -- with smart-unit movement; queue unique index is a secondary safeguard.
    PERFORM 1 FROM public.devices d
      WHERE d.device_code=meal.device_code AND d.status='active'
      FOR UPDATE;
    IF NOT FOUND THEN CONTINUE; END IF;

    IF EXISTS (
      SELECT 1 FROM public.feeder_test_commands c
      WHERE c.device_code=meal.device_code AND c.status IN ('pending','claimed')
    ) THEN CONTINUE; END IF;

    -- Room may have changed while waiting on the feeder lock.
    IF NOT EXISTS (
      SELECT 1 FROM public.bookings b
      JOIN public.room_devices rd ON rd.room_id=b.room_id AND rd.unassigned_at IS NULL
      JOIN public.devices d ON d.id=rd.device_id
      WHERE b.id=meal.booking_id AND d.device_code=meal.device_code
    ) THEN CONTINUE; END IF;

    BEGIN
      INSERT INTO public.feeder_test_commands
        (device_code,steps,direction,command_type,status,requested_by,target_compartment)
      VALUES (meal.device_code,533,'clockwise','rotate','pending',meal.created_by,meal.compartment_number)
      RETURNING id INTO v_command;
    EXCEPTION WHEN unique_violation THEN
      CONTINUE; -- Another motor command won the one-active-command constraint.
    END;

    INSERT INTO public.carefur_feeding_dispatches (schedule_id,command_id,device_code)
    VALUES (meal.schedule_id,v_command,meal.device_code);
    v_count := v_count+1;
  END LOOP;
  RETURN v_count;
END $$;


ALTER FUNCTION public.carefur_dispatch_confirmed_feeding() OWNER TO postgres;

--
-- Name: carefur_dispatch_feeder_test_schedules(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_dispatch_feeder_test_schedules() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
  item public.feeder_test_schedules%ROWTYPE;
  local_now timestamp;
  slot_key text;
  inserted_id uuid;
BEGIN
  -- Safe if a manual call overlaps a cron invocation.
  IF NOT pg_try_advisory_xact_lock(85100932) THEN RETURN; END IF;
  local_now := date_trunc('minute', now() AT TIME ZONE 'Asia/Manila');

  FOR item IN
    SELECT * FROM public.feeder_test_schedules WHERE enabled = true ORDER BY created_at FOR UPDATE SKIP LOCKED
  LOOP
    IF item.schedule_type = 'once' THEN
      -- Only execute schedules due within the last 5 minutes; older missed jobs are marked missed.
      IF item.run_at > now() THEN CONTINUE; END IF;
      IF item.run_at < now() - interval '5 minutes' THEN
        UPDATE public.feeder_test_schedules SET enabled=false, last_result='missed (offline scheduler or job delayed)', last_attempt_at=now() WHERE id=item.id;
        CONTINUE;
      END IF;
      slot_key := 'once:' || item.id::text;
    ELSE
      -- Daily schedules are checked against local Philippine wall-clock time.
      IF extract(hour FROM item.local_time)::int <> extract(hour FROM local_now)::int
         OR extract(minute FROM item.local_time)::int <> extract(minute FROM local_now)::int THEN
        CONTINUE;
      END IF;
      slot_key := to_char(local_now,'YYYY-MM-DD HH24:MI');
    END IF;

    IF item.last_fired_key IS NOT DISTINCT FROM slot_key THEN CONTINUE; END IF;

    -- Device must still be active; otherwise don't move hardware.
    IF NOT EXISTS (SELECT 1 FROM public.devices d WHERE d.device_code=item.device_code AND d.device_type='feeder' AND d.status='active') THEN
      UPDATE public.feeder_test_schedules SET last_result='skipped: device inactive',last_fired_key=slot_key,last_attempt_at=now(),enabled=CASE WHEN item.schedule_type='once' THEN false ELSE enabled END WHERE id=item.id;
      CONTINUE;
    END IF;

    -- Never overlap with a manual command, home command, or another schedule.
    IF EXISTS (SELECT 1 FROM public.feeder_test_commands c WHERE c.device_code=item.device_code AND c.status IN ('pending','claimed')) THEN
      UPDATE public.feeder_test_schedules SET last_result='skipped: feeder busy',last_fired_key=slot_key,last_attempt_at=now(),enabled=CASE WHEN item.schedule_type='once' THEN false ELSE enabled END WHERE id=item.id;
      CONTINUE;
    END IF;

    -- Use the SAME normal command queue as the working Rotate 120 button.
    INSERT INTO public.feeder_test_commands(device_code,steps,direction,command_type,status,requested_by)
    VALUES(item.device_code,533,'clockwise','rotate','pending',item.created_by)
    RETURNING id INTO inserted_id;

    UPDATE public.feeder_test_schedules
       SET last_fired_key=slot_key,last_command_id=inserted_id,last_result='queued',last_attempt_at=now(),
           enabled=CASE WHEN item.schedule_type='once' THEN false ELSE enabled END
     WHERE id=item.id;
  END LOOP;
END;
$$;


ALTER FUNCTION public.carefur_dispatch_feeder_test_schedules() OWNER TO postgres;

--
-- Name: carefur_finish_paid_reservation_sms(uuid, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_finish_paid_reservation_sms(p_request_id uuid, p_status text, p_error text DEFAULT NULL::text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  IF NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;
  IF p_status NOT IN ('queued','failed') THEN RAISE EXCEPTION 'Invalid SMS status'; END IF;
  UPDATE public.reservation_requests SET paid_sms_status=p_status,
     paid_sms_error=left(p_error,300), paid_sms_updated_at=now()
  WHERE id=p_request_id AND status='confirmed' AND boarding_booking_id IS NOT NULL
    AND paid_sms_status='sending';
END;
$$;


ALTER FUNCTION public.carefur_finish_paid_reservation_sms(p_request_id uuid, p_status text, p_error text) OWNER TO postgres;

--
-- Name: carefur_guard_rtc_room_move(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_guard_rtc_room_move() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE v_id uuid; v_code text; v public.feeder_rtc_configs%ROWTYPE;
BEGIN
  v_id:=CASE WHEN TG_OP='DELETE' THEN OLD.device_id ELSE NEW.device_id END;
  SELECT d.device_code INTO v_code FROM public.smart_units su
    JOIN public.devices d ON d.id=su.feeder_device_id
    WHERE su.feeder_device_id=v_id OR su.camera_device_id=v_id LIMIT 1;
  IF v_code IS NULL THEN RETURN CASE WHEN TG_OP='DELETE' THEN OLD ELSE NEW END; END IF;
  SELECT * INTO v FROM public.feeder_rtc_configs WHERE device_code=v_code;
  IF FOUND AND (v.enabled OR v.cached_version IS DISTINCT FROM v.version OR v.cached_at IS NULL) THEN
    RAISE EXCEPTION 'Disable RTC and wait for device cache acknowledgment before moving Smart Unit';
  END IF;
  RETURN CASE WHEN TG_OP='DELETE' THEN OLD ELSE NEW END;
END;
$$;


ALTER FUNCTION public.carefur_guard_rtc_room_move() OWNER TO postgres;

--
-- Name: carefur_is_paired_device(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_is_paired_device(p_device_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.smart_units su
        WHERE su.feeder_device_id = p_device_id
           OR su.camera_device_id = p_device_id
    );
$$;


ALTER FUNCTION public.carefur_is_paired_device(p_device_id uuid) OWNER TO postgres;

--
-- Name: carefur_is_staff(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_is_staff() RETURNS boolean
    LANGUAGE sql STABLE
    SET search_path TO ''
    AS $$
  select coalesce(
    (auth.jwt() -> 'app_metadata' ->> 'role')
      in ('admin', 'staff', 'super_admin'),
    false
  );
$$;


ALTER FUNCTION public.carefur_is_staff() OWNER TO postgres;

--
-- Name: carefur_limit_shared_invitations(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_limit_shared_invitations() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  v_count integer;
BEGIN
  IF NEW.access_type <> 'shared'
     OR NEW.revoked_at IS NOT NULL THEN
    RETURN NEW;
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(NEW.booking_id::text, 0)
  );

  SELECT COUNT(*)
  INTO v_count
  FROM public.booking_access ba
  WHERE ba.booking_id = NEW.booking_id
    AND ba.access_type = 'shared'
    AND ba.revoked_at IS NULL
    AND ba.expires_at > now();

  IF v_count >= 5 THEN
    RAISE EXCEPTION
      'Maximum five active shared invitations per booking';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.booking_access ba
    WHERE ba.booking_id = NEW.booking_id
      AND ba.access_type = 'shared'
      AND ba.revoked_at IS NULL
      AND ba.expires_at > now()
      AND lower(btrim(ba.invited_email)) =
          lower(btrim(NEW.invited_email))
  ) THEN
    RAISE EXCEPTION
      'This email already has active access';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_limit_shared_invitations() OWNER TO postgres;

--
-- Name: carefur_lock_feeder_command_movement(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_lock_feeder_command_movement() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended('carefur:feeder:' || NEW.device_code, 0)
  );
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_lock_feeder_command_movement() OWNER TO postgres;

--
-- Name: carefur_mark_no_shows(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_mark_no_shows() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  affected integer;
BEGIN
  WITH overdue AS (
    UPDATE public.bookings
    SET status = 'no_show'
    WHERE status::text = 'pending'
      AND check_in_at IS NOT NULL
      AND check_in_at + interval '24 hours'
          <= clock_timestamp()
    RETURNING id
  ),
  expired AS (
    UPDATE public.booking_access ba
    SET expires_at = clock_timestamp()
    FROM overdue o
    WHERE ba.booking_id = o.id
    RETURNING ba.booking_id
  )
  SELECT count(*) INTO affected FROM overdue;

  RETURN affected;
END;
$$;


ALTER FUNCTION public.carefur_mark_no_shows() OWNER TO postgres;

--
-- Name: carefur_move_smart_unit(text, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_move_smart_unit(p_unit_code text, p_room_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  v_actor uuid := (SELECT auth.uid());
  v_unit public.smart_units%ROWTYPE;
  v_feeder_code text;
  v_old_feeder_room uuid;
  v_old_camera_room uuid;
  v_destination_status text;
  v_destination_number text;
  v_moved_at timestamptz;
BEGIN
  IF v_actor IS NULL OR NOT (SELECT public.is_staff_member()) THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;

  IF p_unit_code IS NULL OR btrim(p_unit_code) = '' THEN
    RAISE EXCEPTION 'Smart Unit code required' USING ERRCODE = '22023';
  END IF;

  -- First determine the feeder identity, then take a lock shared by motor-command writes.
  SELECT su.* INTO v_unit FROM public.smart_units su
  WHERE su.unit_code = p_unit_code;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Smart Unit not found' USING ERRCODE = 'P0002';
  END IF;

  SELECT d.device_code INTO v_feeder_code FROM public.devices d
  WHERE d.id = v_unit.feeder_device_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Smart Unit feeder is missing';
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended('carefur:feeder:' || v_feeder_code, 0)
  );

  -- Serialize concurrent moves of this unit, then lock its devices.
  PERFORM 1 FROM public.smart_units su WHERE su.id = v_unit.id FOR UPDATE;
  PERFORM 1 FROM public.devices d
  WHERE d.id IN (v_unit.feeder_device_id, v_unit.camera_device_id)
  ORDER BY d.id FOR UPDATE;

  IF NOT EXISTS (
    SELECT 1 FROM public.devices d
    WHERE d.id = v_unit.feeder_device_id
      AND d.device_type = 'feeder' AND d.status = 'active'
  ) OR NOT EXISTS (
    SELECT 1 FROM public.devices d
    WHERE d.id = v_unit.camera_device_id
      AND d.device_type = 'camera' AND d.status = 'active'
  ) THEN
    RAISE EXCEPTION 'Both paired devices must be active and correctly typed';
  END IF;

  SELECT rd.room_id INTO v_old_feeder_room FROM public.room_devices rd
  WHERE rd.device_id = v_unit.feeder_device_id AND rd.unassigned_at IS NULL
  FOR UPDATE;
  SELECT rd.room_id INTO v_old_camera_room FROM public.room_devices rd
  WHERE rd.device_id = v_unit.camera_device_id AND rd.unassigned_at IS NULL
  FOR UPDATE;

  IF v_old_feeder_room IS DISTINCT FROM v_old_camera_room THEN
    RAISE EXCEPTION 'Smart Unit assignments disagree; contact administrator';
  END IF;

  -- NULL IS A VALID DESTINATION: it means UNASSIGN BOTH paired devices.
  IF p_room_id IS NOT NULL THEN
    SELECT r.status::text, r.room_number::text
    INTO v_destination_status, v_destination_number
    FROM public.rooms r WHERE r.id = p_room_id FOR UPDATE;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Destination room not found' USING ERRCODE = 'P0002';
    END IF;
    IF v_destination_status <> 'active' THEN
      RAISE EXCEPTION 'Destination room must be active';
    END IF;
  END IF;

  IF v_old_feeder_room IS NOT DISTINCT FROM p_room_id THEN
    RETURN jsonb_build_object(
      'success', true, 'unit_code', p_unit_code,
      'room_id', p_room_id,
      'message', CASE WHEN p_room_id IS NULL
        THEN 'Smart Unit already unassigned'
        ELSE 'Smart Unit already assigned to this room' END
    );
  END IF;

  -- Never remove a unit from an occupied room or place it into an occupied room.
  IF EXISTS (
    SELECT 1 FROM public.bookings b
    WHERE b.status = 'checked_in' AND b.actual_check_out_at IS NULL
      AND (b.room_id = v_old_feeder_room OR b.room_id = p_room_id)
  ) THEN
    RAISE EXCEPTION 'Cannot move Smart Unit: checked-in boarding in source or destination room';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.feeder_test_commands c
    WHERE c.device_code = v_feeder_code AND c.status IN ('pending', 'claimed')
  ) THEN
    RAISE EXCEPTION 'Cannot move Smart Unit: feeder has active motor commands';
  END IF;

  IF EXISTS (
    SELECT 1 FROM public.feeder_rtc_configs rtc
    WHERE rtc.device_code = v_feeder_code AND rtc.enabled = true
  ) THEN
    RAISE EXCEPTION 'Disable and synchronize RTC feeding before moving Smart Unit';
  END IF;

  -- Keep one feeder and one camera per destination room.
  IF p_room_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM public.room_devices rd
    JOIN public.devices d ON d.id = rd.device_id
    WHERE rd.room_id = p_room_id AND rd.unassigned_at IS NULL
      AND d.device_type IN ('feeder', 'camera')
      AND rd.device_id NOT IN (v_unit.feeder_device_id, v_unit.camera_device_id)
  ) THEN
    RAISE EXCEPTION 'Destination already has a feeder or camera';
  END IF;

  v_moved_at := clock_timestamp();
  UPDATE public.room_devices rd
  SET unassigned_at = GREATEST(v_moved_at, rd.assigned_at)
  WHERE rd.device_id IN (v_unit.feeder_device_id, v_unit.camera_device_id)
    AND rd.unassigned_at IS NULL;

  IF p_room_id IS NOT NULL THEN
    INSERT INTO public.room_devices (room_id, device_id, assigned_at, assigned_by)
    VALUES
      (p_room_id, v_unit.feeder_device_id, v_moved_at, v_actor),
      (p_room_id, v_unit.camera_device_id, v_moved_at, v_actor);
  END IF;

  RETURN jsonb_build_object(
    'success', true,
    'unit_code', p_unit_code,
    'room_id', p_room_id,
    'room_number', v_destination_number,
    'message', CASE WHEN p_room_id IS NULL
      THEN 'Feeder and camera unassigned successfully'
      ELSE 'Feeder and camera assigned to ' || v_destination_number END
  );
END;
$$;


ALTER FUNCTION public.carefur_move_smart_unit(p_unit_code text, p_room_id uuid) OWNER TO postgres;

--
-- Name: carefur_owns_booking(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_owns_booking(p_booking_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select exists (
    select 1 from public.bookings b
    join public.pet_owner_links pol on pol.pet_id = b.pet_id
    where b.id = p_booking_id and pol.owner_id = (select auth.uid())
  );
$$;


ALTER FUNCTION public.carefur_owns_booking(p_booking_id uuid) OWNER TO postgres;

--
-- Name: carefur_prevent_unlinked_confirmation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_prevent_unlinked_confirmation() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF NEW.status='confirmed' AND NEW.boarding_booking_id IS NULL AND
     (TG_OP='INSERT' OR OLD.status IS DISTINCT FROM 'confirmed') THEN
    RAISE EXCEPTION 'Paid confirmation requires a boarding record';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_prevent_unlinked_confirmation() OWNER TO postgres;

--
-- Name: carefur_redeem_booking_code(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_redeem_booking_code(p_code text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
declare
  v_uid uuid := (select auth.uid());
  v_email text;
  v_code text := upper(trim(coalesce(p_code, '')));
  v_access public.booking_access%rowtype;
  v_booking public.bookings%rowtype;
  v_hash text;
  v_failed int;
begin
  if v_uid is null then
    raise exception 'Authentication required' using errcode = '28000';
  end if;

  -- Serialize attempts from a signed-in account to make rate limit reliable.
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(v_uid::text, 0));

  select count(*) into v_failed
  from public.booking_code_redemption_attempts
  where user_id = v_uid
    and attempted_at >= now() - interval '15 minutes'
    and successful = false;
  if v_failed >= 5 then
    return jsonb_build_object('success', false, 'error', 'Too many attempts. Try again later.');
  end if;

  -- Only a verified Supabase Auth address is accepted, not client input.
  select lower(trim(u.email)) into v_email
  from auth.users u
  join public.users profile on profile.id = u.id
  where u.id = v_uid
    and u.email_confirmed_at is not null
    and lower(trim(profile.email)) = lower(trim(u.email))
    and profile.role::text = 'owner';

  if v_email is null or v_code !~ '^[A-Z0-9]{8}$' then
    insert into public.booking_code_redemption_attempts(user_id) values (v_uid);
    return jsonb_build_object('success', false, 'error', 'Invalid code or account.');
  end if;

  v_hash := pg_catalog.encode(pg_catalog.sha256(pg_catalog.convert_to(v_code, 'UTF8')), 'hex');

  -- Row lock prevents simultaneous sessions from redeeming the same code.
  select * into v_access
  from public.booking_access
  where access_code_hash = v_hash
  for update;

  if not found or v_access.redeemed_at is not null
     or v_access.expires_at is null or v_access.expires_at <= now()
     or (v_access.owner_id is not null and v_access.owner_id <> v_uid)
     or v_access.invited_email is null
     or lower(trim(v_access.invited_email)) <> v_email then
    insert into public.booking_code_redemption_attempts(user_id) values (v_uid);
    return jsonb_build_object('success', false, 'error', 'Invalid or unavailable code.');
  end if;

  select * into v_booking
  from public.bookings
  where id = v_access.booking_id
  for update;

  if not found or v_booking.status::text not in ('pending', 'checked_in')
     or (v_booking.actual_check_out_at is not null)
     or v_booking.expected_check_out_at <= now() then
    insert into public.booking_code_redemption_attempts(user_id) values (v_uid);
    return jsonb_build_object('success', false, 'error', 'Invalid or unavailable code.');
  end if;

  update public.booking_access
  set redeemed_at = now(), owner_id = v_uid
  where id = v_access.id;

  insert into public.booking_code_redemption_attempts(user_id, successful)
  values (v_uid, true);

  return jsonb_build_object(
    'success', true,
    'access', jsonb_build_object('id', v_access.id, 'expiresAt', v_access.expires_at),
    'bookingId', v_booking.id
  );
end;
$_$;


ALTER FUNCTION public.carefur_redeem_booking_code(p_code text) OWNER TO postgres;

--
-- Name: carefur_refresh_no_shows(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_refresh_no_shows() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  IF auth.uid() IS NULL
     OR NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required';
  END IF;

  RETURN public.carefur_mark_no_shows();
END;
$$;


ALTER FUNCTION public.carefur_refresh_no_shows() OWNER TO postgres;

--
-- Name: carefur_refresh_paid_access_code(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_refresh_paid_access_code(p_request_id uuid) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE v_booking uuid; v_access_id uuid; v_code text;
BEGIN
  IF NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;
  SELECT boarding_booking_id INTO v_booking FROM public.reservation_requests
    WHERE id=p_request_id AND status='confirmed' FOR UPDATE;
  IF v_booking IS NULL THEN RAISE EXCEPTION 'Boarding not found for this paid request'; END IF;
  SELECT id INTO v_access_id FROM public.booking_access
    WHERE booking_id=v_booking AND redeemed_at IS NULL AND revoked_at IS NULL
      AND expires_at > now()
    ORDER BY created_at DESC LIMIT 1 FOR UPDATE;
  IF v_access_id IS NULL THEN
    RAISE EXCEPTION 'Access already redeemed or expired; SMS confirmation cannot reissue code';
  END IF;
  v_code := upper(substr(replace(gen_random_uuid()::text,'-',''),1,8));
  UPDATE public.booking_access SET access_code_hash =
    pg_catalog.encode(pg_catalog.sha256(pg_catalog.convert_to(v_code,'UTF8')),'hex')
    WHERE id=v_access_id;
  RETURN v_code;
END;
$$;


ALTER FUNCTION public.carefur_refresh_paid_access_code(p_request_id uuid) OWNER TO postgres;

--
-- Name: carefur_reject_manual_auto_completion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_reject_manual_auto_completion() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF OLD.feeding_method='automatic'
     AND NEW.status IS DISTINCT FROM OLD.status
     AND current_user IN ('authenticated','anon') THEN
    RAISE EXCEPTION 'Automatic feeds are completed by device acknowledgment, not manually'
      USING ERRCODE='42501';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.carefur_reject_manual_auto_completion() OWNER TO postgres;

--
-- Name: carefur_reject_overlapping_reservation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_reject_overlapping_reservation() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF NEW.room_id IS NULL THEN RAISE EXCEPTION 'A valid room must be selected'; END IF;
  IF NEW.check_in_at IS NULL OR NEW.expected_check_out_at IS NULL
    OR NEW.expected_check_out_at <= NEW.check_in_at THEN
    RAISE EXCEPTION 'Check-out must be after check-in';
  END IF;
  -- Serialize competing public reservation requests for the same room.
  PERFORM pg_advisory_xact_lock(hashtextextended(NEW.room_id::text, 0));
  IF NOT EXISTS (SELECT 1 FROM public.rooms r WHERE r.id = NEW.room_id
    AND lower(coalesce(r.status::text,'active')) NOT IN ('inactive','maintenance','unavailable','disabled')) THEN
    RAISE EXCEPTION 'Room is not available';
  END IF;
  IF EXISTS (
    SELECT 1 FROM public.bookings b WHERE b.room_id = NEW.room_id
      AND b.status::text IN ('pending','checked_in')
      AND b.check_in_at < NEW.expected_check_out_at
      AND b.expected_check_out_at > NEW.check_in_at
  ) OR EXISTS (
    SELECT 1 FROM public.reservation_requests rr
    WHERE rr.room_id = NEW.room_id AND rr.id IS DISTINCT FROM NEW.id
      AND (rr.status::text = 'confirmed' OR
          (rr.status::text = 'pending_payment' AND rr.created_at > now() - interval '24 hours'))
      AND rr.check_in_at < NEW.expected_check_out_at
      AND rr.expected_check_out_at > NEW.check_in_at
  ) THEN
    RAISE EXCEPTION 'Room already reserved for the selected dates';
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_reject_overlapping_reservation() OWNER TO postgres;

--
-- Name: carefur_review_extension(uuid, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_review_extension(p_request_id uuid, p_approve boolean) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  v_request public.boarding_extension_requests%ROWTYPE;
  v_booking public.bookings%ROWTYPE;
  v_staff uuid := auth.uid();
BEGIN
  IF v_staff IS NULL OR NOT EXISTS (
    SELECT 1 FROM public.users u WHERE u.id = v_staff AND u.role::text IN ('admin','staff')
  ) THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;
  IF p_request_id IS NULL OR p_approve IS NULL THEN
    RAISE EXCEPTION 'Request id and decision are required' USING ERRCODE = '22023';
  END IF;

  SELECT * INTO v_request
  FROM public.boarding_extension_requests
  WHERE id = p_request_id
  FOR UPDATE;

  IF NOT FOUND OR v_request.status <> 'pending' THEN
    RAISE EXCEPTION 'Extension request is not pending' USING ERRCODE = '22023';
  END IF;

  SELECT * INTO v_booking
  FROM public.bookings
  WHERE id = v_request.booking_id
  FOR UPDATE;

  IF NOT FOUND OR v_booking.status::text <> 'checked_in'
     OR v_booking.actual_check_out_at IS NOT NULL THEN
    RAISE EXCEPTION 'Boarding is no longer checked in' USING ERRCODE = '22023';
  END IF;

  IF p_approve THEN
    IF v_request.payment_status NOT IN ('paid','waived','not_required') THEN
      RAISE EXCEPTION 'Extension payment must be verified before approval' USING ERRCODE = '23514';
    END IF;
    IF v_request.payment_status <> 'not_required' AND v_request.additional_amount_due IS NULL THEN
      RAISE EXCEPTION 'Set the extension amount before approval' USING ERRCODE = '23514';
    END IF;
    IF v_booking.expected_check_out_at <= now()
       OR v_request.requested_checkout_at <= v_booking.expected_check_out_at
       OR v_request.requested_checkout_at > v_booking.expected_check_out_at + interval '30 days' THEN
      RAISE EXCEPTION 'Requested checkout is no longer a valid extension' USING ERRCODE = '22023';
    END IF;

    IF v_booking.room_id IS NULL THEN
      RAISE EXCEPTION 'Booking has no assigned room; assign a room before approving extension' USING ERRCODE = '23514';
    END IF;

    -- Serialize extension approval against other approvals for this room.
    PERFORM pg_advisory_xact_lock(hashtextextended(v_booking.room_id::text, 0));

    IF EXISTS (
      SELECT 1 FROM public.bookings b
      WHERE b.room_id = v_booking.room_id
        AND b.id <> v_booking.id
        AND b.status::text IN ('pending','checked_in')
        AND b.check_in_at < v_request.requested_checkout_at
        AND COALESCE(b.actual_check_out_at,b.expected_check_out_at) > v_booking.expected_check_out_at
    ) THEN
      RAISE EXCEPTION 'Room unavailable for requested extension; resolve overlapping booking first'
        USING ERRCODE = '23514';
    END IF;

    UPDATE public.bookings
    SET expected_check_out_at = v_request.requested_checkout_at
    WHERE id = v_booking.id;

    -- Extend only active, unrevoked booking access records; never revive revoked/expired codes.
    UPDATE public.booking_access
    SET expires_at = GREATEST(expires_at, v_request.requested_checkout_at)
    WHERE booking_id = v_booking.id
      AND revoked_at IS NULL
      AND expires_at > now()
      AND expires_at < v_request.requested_checkout_at;
  END IF;

  UPDATE public.boarding_extension_requests
  SET status = CASE WHEN p_approve THEN 'approved' ELSE 'declined' END,
      reviewed_by = v_staff,
      reviewed_at = now()
  WHERE id = v_request.id;
END;
$$;


ALTER FUNCTION public.carefur_review_extension(p_request_id uuid, p_approve boolean) OWNER TO postgres;

--
-- Name: carefur_review_reservation_request(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_review_reservation_request(p_request_id uuid, p_status text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  IF NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff access required' USING ERRCODE='42501';
  END IF;
  IF p_status <> 'declined' THEN
    RAISE EXCEPTION 'To confirm a reservation, use the Paid action which creates the boarding';
  END IF;
  UPDATE public.reservation_requests SET status='declined',updated_at=now()
  WHERE id=p_request_id AND status='pending_payment' AND boarding_booking_id IS NULL;
  IF NOT FOUND THEN RAISE EXCEPTION 'Reservation cannot be declined'; END IF;
END;
$$;


ALTER FUNCTION public.carefur_review_reservation_request(p_request_id uuid, p_status text) OWNER TO postgres;

--
-- Name: carefur_rtc_device_sync(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_rtc_device_sync(p_device_code text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  v public.feeder_rtc_configs%ROWTYPE;
  v_feeder uuid;
  v_cam uuid;
  v_room uuid;
  v_valid boolean;
  v_end timestamptz;
BEGIN
  PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended('carefur:feeder:' || p_device_code, 0));
  SELECT * INTO v FROM public.feeder_rtc_configs
    WHERE device_code=p_device_code FOR UPDATE;
  IF NOT FOUND THEN
    RETURN jsonb_build_object('device_code',p_device_code,'enabled',false,'version',0,
      'morning_time','08:00','afternoon_time','13:00','evening_time','19:00',
      'lease_until_epoch',0);
  END IF;
  IF v.enabled THEN
    v_valid := false;
    SELECT id INTO v_feeder FROM public.devices d
      WHERE d.device_code=p_device_code AND d.status='active' AND d.device_type='feeder';
    SELECT camera_device_id INTO v_cam FROM public.smart_units WHERE feeder_device_id=v_feeder;
    SELECT rf.room_id INTO v_room FROM public.room_devices rf
      JOIN public.room_devices rc ON rc.room_id=rf.room_id AND rc.device_id=v_cam
        AND rc.unassigned_at IS NULL
    WHERE rf.device_id=v_feeder AND rf.unassigned_at IS NULL;
    IF v_room=v.room_id AND v_room IS NOT NULL AND v.lease_expires_at>now() THEN
      IF v.lease_mode='test' THEN
        v_valid := NOT EXISTS (SELECT 1 FROM public.bookings b WHERE b.room_id=v_room
          AND b.status='checked_in' AND b.actual_check_out_at IS NULL);
      ELSIF v.lease_mode='boarding' THEN
        SELECT LEAST(b.expected_check_out_at,now()+interval '24 hours') INTO v_end
          FROM public.bookings b WHERE b.id=v.booking_id AND b.room_id=v_room
          AND b.status='checked_in' AND b.actual_check_out_at IS NULL
          AND b.expected_check_out_at>now();
        v_valid := v_end IS NOT NULL;
        -- Renew the online booking lease before it expires, up to checkout.
        IF v_valid AND v.lease_expires_at < now()+interval '12 hours' THEN
          UPDATE public.feeder_rtc_configs
            SET lease_expires_at=v_end,version=version+1,
                cached_version=NULL,cached_at=NULL,updated_at=now()
          WHERE device_code=p_device_code RETURNING * INTO v;
        END IF;
      END IF;
    END IF;
    IF NOT v_valid THEN
      UPDATE public.feeder_rtc_configs SET enabled=false,lease_expires_at=NULL,
        lease_mode=NULL,booking_id=NULL,room_id=NULL,
        version=version+1,cached_version=NULL,cached_at=NULL,updated_at=now()
      WHERE device_code=p_device_code RETURNING * INTO v;
    END IF;
  END IF;
  RETURN pg_catalog.to_jsonb(v) || jsonb_build_object('lease_until_epoch',
    COALESCE(EXTRACT(EPOCH FROM v.lease_expires_at)::bigint,0));
END;
$$;


ALTER FUNCTION public.carefur_rtc_device_sync(p_device_code text) OWNER TO postgres;

--
-- Name: carefur_rtc_save_lease(text, boolean, text, text, text, text, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_rtc_save_lease(p_device_code text, p_enabled boolean, p_morning text, p_afternoon text, p_evening text, p_mode text DEFAULT 'test'::text, p_actor uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
DECLARE
  v_feeder uuid;
  v_room uuid;
  v_cam uuid;
  v_booking uuid;
  v_until timestamptz;
  v_config public.feeder_rtc_configs%ROWTYPE;
  v_times text[] := ARRAY[p_morning,p_afternoon,p_evening];
  v_time text;
BEGIN
  -- Only Edge Function service-role calls are granted below.
  IF p_device_code IS NULL OR NOT EXISTS(
    SELECT 1 FROM public.devices d WHERE d.device_code = p_device_code
      AND d.device_type = 'feeder' AND d.status = 'active'
  ) THEN RAISE EXCEPTION 'Unknown active feeder'; END IF;
  FOREACH v_time IN ARRAY v_times LOOP
    IF v_time IS NULL OR v_time !~ '^([01][0-9]|2[0-3]):[0-5][0-9]$' THEN
      RAISE EXCEPTION 'Times must be HH:MM';
    END IF;
  END LOOP;
  IF p_morning=p_afternoon OR p_morning=p_evening OR p_afternoon=p_evening THEN
    RAISE EXCEPTION 'Meal times must be different';
  END IF;
  IF p_enabled AND p_mode NOT IN ('test','boarding') THEN
    RAISE EXCEPTION 'Invalid RTC mode';
  END IF;

  PERFORM pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended('carefur:feeder:' || p_device_code, 0));
  SELECT id INTO v_feeder FROM public.devices WHERE device_code=p_device_code FOR UPDATE;
  SELECT su.camera_device_id INTO v_cam FROM public.smart_units su WHERE su.feeder_device_id=v_feeder FOR UPDATE;
  IF p_enabled THEN
    IF v_cam IS NULL THEN RAISE EXCEPTION 'Feeder must belong to a Smart Unit'; END IF;
    SELECT rf.room_id INTO v_room FROM public.room_devices rf
      JOIN public.room_devices rc ON rc.room_id=rf.room_id
       AND rc.device_id=v_cam AND rc.unassigned_at IS NULL
    WHERE rf.device_id=v_feeder AND rf.unassigned_at IS NULL;
    IF v_room IS NULL THEN RAISE EXCEPTION 'Smart Unit must be assigned to one room'; END IF;
    IF EXISTS (SELECT 1 FROM public.feeder_test_commands c
      WHERE c.device_code=p_device_code AND c.status IN ('pending','claimed')) THEN
      RAISE EXCEPTION 'Resolve active motor commands first';
    END IF;
    IF p_mode='boarding' THEN
      SELECT b.id, LEAST(b.expected_check_out_at, now() + interval '24 hours')
        INTO v_booking, v_until FROM public.bookings b
      WHERE b.room_id=v_room AND b.status='checked_in'
        AND b.actual_check_out_at IS NULL AND b.expected_check_out_at>now()
      ORDER BY b.check_in_at DESC LIMIT 1;
      IF v_booking IS NULL THEN RAISE EXCEPTION 'No checked-in boarding in assigned room'; END IF;
    ELSE
      IF EXISTS (SELECT 1 FROM public.bookings b WHERE b.room_id=v_room
          AND b.status='checked_in' AND b.actual_check_out_at IS NULL) THEN
        RAISE EXCEPTION 'Test mode not allowed during checked-in boarding';
      END IF;
      v_until := now() + interval '30 minutes';
    END IF;
  ELSE
    p_mode := NULL;
    v_until := NULL;
    v_booking := NULL;
    v_room := NULL;
  END IF;

  -- Upsert, version increment serialized by shared feeder advisory lock.
  INSERT INTO public.feeder_rtc_configs(
    device_code,enabled,morning_time,afternoon_time,evening_time,
    version,updated_at,updated_by,lease_mode,lease_expires_at,booking_id,room_id,
    cached_version,cached_at
  ) VALUES (
    p_device_code,p_enabled,p_morning::time,p_afternoon::time,p_evening::time,
    1,now(),p_actor,p_mode,v_until,v_booking,v_room,NULL,NULL
  ) ON CONFLICT (device_code) DO UPDATE SET
    enabled=EXCLUDED.enabled, morning_time=EXCLUDED.morning_time,
    afternoon_time=EXCLUDED.afternoon_time, evening_time=EXCLUDED.evening_time,
    version=public.feeder_rtc_configs.version+1,updated_at=now(),updated_by=p_actor,
    lease_mode=EXCLUDED.lease_mode,lease_expires_at=EXCLUDED.lease_expires_at,
    booking_id=EXCLUDED.booking_id,room_id=EXCLUDED.room_id,
    cached_version=NULL,cached_at=NULL
  RETURNING * INTO v_config;
  -- Cancel legacy cloud test schedules (old cron already disabled).
  UPDATE public.feeder_test_schedules SET enabled=false
    WHERE device_code=p_device_code AND enabled=true;
  RETURN pg_catalog.to_jsonb(v_config);
END;
$_$;


ALTER FUNCTION public.carefur_rtc_save_lease(p_device_code text, p_enabled boolean, p_morning text, p_afternoon text, p_evening text, p_mode text, p_actor uuid) OWNER TO postgres;

--
-- Name: carefur_set_extension_payment(uuid, numeric, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_set_extension_payment(p_request_id uuid, p_amount_due numeric, p_payment_status text, p_payment_reference text DEFAULT NULL::text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  v_staff uuid := auth.uid();
BEGIN
  IF v_staff IS NULL OR NOT EXISTS (
    SELECT 1 FROM public.users u WHERE u.id = v_staff AND u.role::text IN ('admin','staff')
  ) THEN
    RAISE EXCEPTION 'Staff authorization required' USING ERRCODE = '42501';
  END IF;
  IF p_request_id IS NULL OR p_payment_status IS NULL OR p_payment_status NOT IN ('unverified','paid','waived','not_required') THEN
    RAISE EXCEPTION 'Invalid extension payment details' USING ERRCODE = '22023';
  END IF;
  IF p_amount_due IS NOT NULL AND p_amount_due < 0 THEN
    RAISE EXCEPTION 'Amount cannot be negative' USING ERRCODE = '22023';
  END IF;
  UPDATE public.boarding_extension_requests
  SET additional_amount_due = p_amount_due,
      payment_status = p_payment_status,
      payment_reference = NULL,
      payment_verified_by = CASE WHEN p_payment_status IN ('paid','waived','not_required') THEN v_staff ELSE NULL END,
      payment_verified_at = CASE WHEN p_payment_status IN ('paid','waived','not_required') THEN now() ELSE NULL END
  WHERE id = p_request_id AND status = 'pending';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Pending extension request not found' USING ERRCODE = '22023';
  END IF;
END;
$$;


ALTER FUNCTION public.carefur_set_extension_payment(p_request_id uuid, p_amount_due numeric, p_payment_status text, p_payment_reference text) OWNER TO postgres;

--
-- Name: carefur_smart_unit_status(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_smart_unit_status() RETURNS TABLE(unit_code text, unit_name text, feeder_code text, camera_code text, feeder_room text, camera_room text, active_commands bigint, rtc_enabled boolean, assignment_consistent boolean, movement_status text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
    IF (SELECT auth.uid()) IS NULL
       OR NOT (SELECT public.is_staff_member()) THEN
        RAISE EXCEPTION 'Staff authorization required'
            USING ERRCODE = '42501';
    END IF;

    RETURN QUERY
    SELECT
        su.unit_code,
        su.unit_name,
        feeder.device_code,
        camera.device_code,
        fr.room_number::text,
        cr.room_number::text,
        (
            SELECT COUNT(*)
            FROM public.feeder_test_commands cmd
            WHERE cmd.device_code = feeder.device_code
              AND cmd.status IN ('pending', 'claimed')
        ),
        COALESCE(rtc.enabled, false),
        (
            fr.id IS NOT DISTINCT FROM cr.id
        ),
        CASE
            WHEN fr.id IS DISTINCT FROM cr.id
                THEN 'INCONSISTENT_ASSIGNMENT'

            WHEN EXISTS (
                SELECT 1
                FROM public.feeder_test_commands cmd
                WHERE cmd.device_code = feeder.device_code
                  AND cmd.status IN ('pending', 'claimed')
            )
                THEN 'FEEDER_BUSY'

            WHEN COALESCE(rtc.enabled, false)
                THEN 'RTC_ENABLED'

            WHEN EXISTS (
                SELECT 1
                FROM public.bookings b
                WHERE b.status = 'checked_in'
                  AND b.actual_check_out_at IS NULL
                  AND b.room_id = fr.id
            )
                THEN 'ACTIVE_BOARDING'

            ELSE 'REQUIRES_HARDWARE_CONFIRMATION'
        END
    FROM public.smart_units su
    JOIN public.devices feeder
        ON feeder.id = su.feeder_device_id
    JOIN public.devices camera
        ON camera.id = su.camera_device_id
    LEFT JOIN public.room_devices frd
        ON frd.device_id = feeder.id
       AND frd.unassigned_at IS NULL
    LEFT JOIN public.rooms fr
        ON fr.id = frd.room_id
    LEFT JOIN public.room_devices crd
        ON crd.device_id = camera.id
       AND crd.unassigned_at IS NULL
    LEFT JOIN public.rooms cr
        ON cr.id = crd.room_id
    LEFT JOIN public.feeder_rtc_configs rtc
        ON rtc.device_code = feeder.device_code
    ORDER BY su.unit_code;
END;
$$;


ALTER FUNCTION public.carefur_smart_unit_status() OWNER TO postgres;

--
-- Name: carefur_staff_boarding_action(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_staff_boarding_action(p_booking_id uuid, p_action text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  v_booking public.bookings%ROWTYPE;
  v_now timestamptz := clock_timestamp();
  v_duration interval;
  v_new_checkout timestamptz;
BEGIN
  IF auth.uid() IS NULL OR NOT public.carefur_boarding_staff() THEN
    RAISE EXCEPTION 'Staff authorization required';
  END IF;

  IF p_action IS NULL OR p_action NOT IN ('check_in', 'check_out', 'cancel') THEN
    RAISE EXCEPTION 'Unsupported boarding action';
  END IF;

  SELECT * INTO v_booking
  FROM public.bookings
  WHERE id = p_booking_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Booking not found';
  END IF;

  IF p_action = 'check_in' THEN
    IF v_booking.status::text <> 'pending' THEN
      RAISE EXCEPTION 'Only pending bookings may be checked in';
    END IF;

    v_duration := v_booking.expected_check_out_at - v_booking.check_in_at;
    IF v_duration IS NULL OR v_duration <= interval '0 seconds' THEN
      RAISE EXCEPTION 'Booking has an invalid stay duration';
    END IF;
    v_new_checkout := v_now + v_duration;

    PERFORM 1 FROM public.rooms WHERE id = v_booking.room_id FOR UPDATE;
    IF EXISTS (
      SELECT 1 FROM public.bookings b
      WHERE b.id <> v_booking.id
        AND b.room_id = v_booking.room_id
        AND b.status::text IN ('pending', 'checked_in')
        AND b.check_in_at < v_new_checkout
        AND b.expected_check_out_at > v_now
    ) THEN
      RAISE EXCEPTION 'Room is occupied or reserved for the adjusted stay';
    END IF;

    UPDATE public.bookings
    SET status = 'checked_in',
        check_in_at = v_now,
        expected_check_out_at = v_new_checkout
    WHERE id = p_booking_id;

    UPDATE public.booking_access
    SET expires_at = GREATEST(COALESCE(expires_at, v_new_checkout), v_new_checkout)
    WHERE booking_id = p_booking_id;

  ELSIF p_action = 'check_out' THEN
    IF v_booking.status::text <> 'checked_in'
       OR v_booking.actual_check_out_at IS NOT NULL THEN
      RAISE EXCEPTION 'Only an active boarding can be checked out';
    END IF;

    UPDATE public.bookings
    SET status = 'checked_out',
        actual_check_out_at = v_now
    WHERE id = p_booking_id;

    -- Expire customer booking access at the actual checkout time.
    UPDATE public.booking_access
    SET expires_at = v_now
    WHERE booking_id = p_booking_id;

    -- Do not leave future uncompleted meals queued after checkout.
    UPDATE public.feeding_schedules
    SET status = 'cancelled',
        updated_at = v_now
    WHERE booking_id = p_booking_id
      AND status::text = 'pending'
      AND scheduled_at > v_now;

    -- Close any still-pending extension request; it can no longer be approved.
    UPDATE public.boarding_extension_requests
    SET status = 'declined',
        reviewed_by = auth.uid(),
        reviewed_at = v_now
    WHERE booking_id = p_booking_id
      AND status = 'pending';

    -- Revoke the server-side RTC lease for this booking.
    -- A disconnected ESP32 may retain its already-cached lease until it
    -- reconnects or the previously issued lease expires.
    UPDATE public.feeder_rtc_configs
    SET enabled = false,
        version = COALESCE(version, 0) + 1,
        lease_expires_at = v_now,
        updated_at = v_now
    WHERE booking_id = p_booking_id
      AND enabled = true;

  ELSE
    IF v_booking.status::text <> 'pending' THEN
      RAISE EXCEPTION 'Only pending bookings may be cancelled';
    END IF;

    UPDATE public.bookings
    SET status = 'cancelled'
    WHERE id = p_booking_id;

    UPDATE public.booking_access
    SET expires_at = v_now
    WHERE booking_id = p_booking_id;
  END IF;
END;
$$;


ALTER FUNCTION public.carefur_staff_boarding_action(p_booking_id uuid, p_action text) OWNER TO postgres;

--
-- Name: carefur_sync_auto_feeding_result(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_sync_auto_feeding_result() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status
     AND NEW.status IN ('completed','failed','cancelled') THEN
    UPDATE public.feeding_schedules fs
       SET status = CASE WHEN NEW.status='completed' THEN 'completed' ELSE 'missed' END
      FROM public.carefur_feeding_dispatches dispatch
     WHERE dispatch.schedule_id=fs.id
       AND dispatch.command_id=NEW.id
       AND fs.feeding_method='automatic'
       AND fs.status='pending';
  END IF;
  RETURN NEW;
END $$;


ALTER FUNCTION public.carefur_sync_auto_feeding_result() OWNER TO postgres;

--
-- Name: carefur_validate_smart_unit(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.carefur_validate_smart_unit() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM public.devices
        WHERE id = NEW.feeder_device_id
          AND device_type = 'feeder'
    ) THEN
        RAISE EXCEPTION
            'Smart Unit feeder must be a registered feeder device';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM public.devices
        WHERE id = NEW.camera_device_id
          AND device_type = 'camera'
    ) THEN
        RAISE EXCEPTION
            'Smart Unit camera must be a registered camera device';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.carefur_validate_smart_unit() OWNER TO postgres;

--
-- Name: create_public_inquiry(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text) RETURNS TABLE(inquiry_id uuid, access_token text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'extensions', 'public', 'pg_temp'
    AS $$
declare
  v_id uuid := gen_random_uuid();
  v_token text := encode(gen_random_bytes(16), 'hex');
  v_token_hash text := encode(digest(v_token, 'sha256'), 'hex');
begin
  if coalesce(trim(p_client_name), '') = '' then
    raise exception 'Client name is required';
  end if;

  if coalesce(trim(p_client_email), '') = '' or position('@' in p_client_email) = 0 then
    raise exception 'A valid email address is required';
  end if;

  if coalesce(trim(p_subject), '') = '' then
    raise exception 'Subject is required';
  end if;

  if coalesce(trim(p_first_message), '') = '' then
    raise exception 'Message is required';
  end if;

  insert into public.public_inquiries (
    id,
    client_name,
    client_email,
    subject,
    status,
    access_token_hash
  ) values (
    v_id,
    trim(p_client_name),
    lower(trim(p_client_email)),
    trim(p_subject),
    'open',
    v_token_hash
  );

  insert into public.public_inquiry_messages (
    inquiry_id,
    sender_type,
    sender_name,
    message
  ) values (
    v_id,
    'client',
    trim(p_client_name),
    trim(p_first_message)
  );

  return query select v_id, v_token;
end;
$$;


ALTER FUNCTION public.create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text) OWNER TO postgres;

--
-- Name: create_public_reservation_request(text, text, text, text, text, text, uuid, text, timestamp with time zone, timestamp with time zone, text, numeric, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
DECLARE
  v_id uuid;
  v_code text := 'CF-' || to_char(now(), 'YYYY') || '-'
            || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 8));
BEGIN
  IF nullif(trim(p_owner_name), '') IS NULL THEN
    RAISE EXCEPTION 'Owner name is required';
  END IF;
  IF nullif(trim(p_email), '') IS NULL OR position('@' IN p_email) = 0 THEN
    RAISE EXCEPTION 'A valid email is required';
  END IF;
  IF nullif(trim(p_phone), '') IS NULL THEN
    RAISE EXCEPTION 'Phone is required';
  END IF;
  IF nullif(trim(p_pet_name), '') IS NULL THEN
    RAISE EXCEPTION 'Pet name is required';
  END IF;
  IF nullif(trim(p_pet_species), '') IS NULL THEN
    RAISE EXCEPTION 'Pet species is required';
  END IF;
  IF p_room_id IS NULL THEN
    RAISE EXCEPTION 'Please select a room';
  END IF;
  IF p_check_in_at IS NULL OR p_expected_check_out_at IS NULL
     OR p_expected_check_out_at <= p_check_in_at THEN
    RAISE EXCEPTION 'Check-out must be after check-in';
  END IF;
  IF p_nights IS NULL OR p_nights <= 0 OR p_nights > 365
     OR p_room_rate_per_night IS NULL OR p_room_rate_per_night < 0
     OR p_estimated_total IS NULL OR p_estimated_total < 0 THEN
    RAISE EXCEPTION 'Invalid stay duration or estimated price';
  END IF;

  -- This insert matches the existing public.reservation_requests columns.
  -- The existing carefur_reservation_overlap_guard trigger, if installed,
  -- will reject overlapping room reservations at insert time.
  INSERT INTO public.reservation_requests (
    request_code, owner_name, email, phone, pet_name, pet_species,
    pet_breed, room_id, requested_room_number, check_in_at,
    expected_check_out_at, special_instructions, status,
    room_rate_per_night, nights, estimated_total
  ) VALUES (
    v_code, trim(p_owner_name), lower(trim(p_email)), trim(p_phone),
    trim(p_pet_name), trim(p_pet_species), nullif(trim(p_pet_breed), ''),
    p_room_id, nullif(trim(p_requested_room_number), ''), p_check_in_at,
    p_expected_check_out_at, nullif(trim(p_special_instructions), ''),
    'pending_payment', p_room_rate_per_night, p_nights, p_estimated_total
  ) RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


ALTER FUNCTION public.create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric) OWNER TO postgres;

--
-- Name: current_user_role(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.current_user_role() RETURNS text
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select role::text
  from public.users
  where id = auth.uid()
  limit 1;
$$;


ALTER FUNCTION public.current_user_role() OWNER TO postgres;

--
-- Name: get_customer_boarding_reviews(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_customer_boarding_reviews(p_limit integer DEFAULT 100) RETURNS TABLE(id uuid, reviewer_name text, rating integer, comment text, created_at timestamp with time zone)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  SELECT
    br.id,
    split_part(o.full_name, ' ', 1) AS reviewer_name,
    br.rating,
    br.comment,
    br.created_at
  FROM public.boarding_reviews br
  JOIN public.owners o
    ON o.id = br.owner_id
  JOIN public.bookings b
    ON b.id = br.booking_id
  WHERE br.status = 'approved'
    AND b.actual_check_out_at IS NOT NULL
    AND b.actual_check_out_at <= now()
  ORDER BY br.created_at DESC, br.id DESC
  LIMIT LEAST(GREATEST(coalesce(p_limit, 100), 1), 100);
$$;


ALTER FUNCTION public.get_customer_boarding_reviews(p_limit integer) OWNER TO postgres;

--
-- Name: get_public_inquiry_thread(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text) RETURNS TABLE(id uuid, sender_type text, sender_name text, message text, created_at timestamp with time zone, subject text, status text, client_name text, client_email text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'extensions', 'public', 'pg_temp'
    AS $$
declare
  v_expected text := encode(digest(coalesce(p_access_token, ''), 'sha256'), 'hex');
begin
  if not exists (
    select 1
    from public.public_inquiries i
    where i.id = p_inquiry_id
      and i.access_token_hash = v_expected
  ) then
    raise exception 'Inquiry access denied';
  end if;

  return query
  select
    m.id,
    m.sender_type,
    coalesce(m.sender_name, case when m.sender_type = 'staff' then 'CareFur Staff' else i.client_name end) as sender_name,
    m.message,
    m.created_at,
    i.subject,
    i.status,
    i.client_name,
    i.client_email
  from public.public_inquiry_messages m
  join public.public_inquiries i
    on i.id = m.inquiry_id
  where i.id = p_inquiry_id
  order by m.created_at asc;
end;
$$;


ALTER FUNCTION public.get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text) OWNER TO postgres;

--
-- Name: get_verified_boarding_reviews(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_verified_boarding_reviews(p_limit integer DEFAULT 60) RETURNS TABLE(id text, reviewer_name text, rating integer, comment text, created_at timestamp with time zone)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  select
    coalesce(j->>'id', '') as id,
    coalesce(
      nullif(left(trim(j->>'reviewer_name'), 80), ''),
      nullif(left(trim(j->>'owner_name'), 80), ''),
      'Verified pet parent'
    ) as reviewer_name,
    least(5, greatest(1,
      case when coalesce(j->>'rating',j->>'stars',j->>'review_rating','') ~ '^[1-5]$'
        then coalesce(j->>'rating',j->>'stars',j->>'review_rating')::integer else 5 end
    )) as rating,
    left(coalesce(nullif(trim(j->>'comment'), ''), nullif(trim(j->>'review_text'), ''), nullif(trim(j->>'review'), ''), nullif(trim(j->>'feedback'), '')), 2000) as comment,
    case when coalesce(j->>'created_at', '') ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
      then (j->>'created_at')::timestamptz else null::timestamptz end as created_at
  from public.boarding_reviews br
  cross join lateral (select to_jsonb(br) as j) src
  where
    -- Explicit staff moderation approval required.
    (
      lower(coalesce(j->>'status', j->>'review_status', '')) = 'approved'
      or (
        j->>'status' is null and j->>'review_status' is null
        and j->>'approved_at' is not null
      )
    )
    and coalesce(j->>'comment', j->>'review_text', j->>'review', j->>'feedback', '') <> ''
    and exists (
      select 1
      from public.bookings b
      where b.id::text = coalesce(j->>'booking_id',j->>'boarding_id','')
        and (
          lower(b.status::text) in ('checked_out', 'completed')
          or b.actual_check_out_at is not null
        )
    )
  order by (j->>'created_at') desc nulls last
  limit least(greatest(coalesce(p_limit, 60), 1), 60);
$_$;


ALTER FUNCTION public.get_verified_boarding_reviews(p_limit integer) OWNER TO postgres;

--
-- Name: is_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select coalesce(
    (
      select role::text = 'admin'
      from public.users
      where id = auth.uid()
      limit 1
    ),
    false
  );
$$;


ALTER FUNCTION public.is_admin() OWNER TO postgres;

--
-- Name: is_staff_member(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_staff_member() RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select coalesce(
    (
      select role::text in ('admin', 'staff')
      from public.users
      where id = auth.uid()
      limit 1
    ),
    false
  );
$$;


ALTER FUNCTION public.is_staff_member() OWNER TO postgres;

--
-- Name: owner_has_booking_access(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.owner_has_booking_access(target_booking_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select exists (
    select 1
    from public.booking_access ba
    where ba.booking_id = target_booking_id
      and ba.owner_id = auth.uid()
      and ba.redeemed_at is not null
      and ba.revoked_at is null
  );
$$;


ALTER FUNCTION public.owner_has_booking_access(target_booking_id uuid) OWNER TO postgres;

--
-- Name: owner_has_pet_access(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.owner_has_pet_access(target_pet_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO ''
    AS $$
  select exists (
    select 1
    from public.pet_owner_links pol
    where pol.pet_id = target_pet_id
      and pol.owner_id = auth.uid()
  );
$$;


ALTER FUNCTION public.owner_has_pet_access(target_pet_id uuid) OWNER TO postgres;

--
-- Name: public_room_availability(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.public_room_availability(target_date date) RETURNS TABLE(room_id uuid, room_number text, room_name text, capacity integer, room_status text, availability_status text)
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  select
    r.id as room_id,
    r.room_number,
    r.room_name,
    r.capacity,
    r.status::text as room_status,
    case
      when r.status::text <> 'active' then 'contact'
      when exists (
        select 1
        from public.bookings b
        where b.room_id = r.id
          and b.status::text <> 'cancelled'
          and b.check_in_at::date <= target_date
          and coalesce(b.actual_check_out_at, b.expected_check_out_at)::date >= target_date
          and not (
            b.status::text = 'checked_out'
            and coalesce(b.actual_check_out_at, b.expected_check_out_at)::date < target_date
          )
      ) then 'occupied'
      else 'available'
    end as availability_status
  from public.rooms r
  order by r.room_number;
$$;


ALTER FUNCTION public.public_room_availability(target_date date) OWNER TO postgres;

--
-- Name: public_room_availability_range(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.public_room_availability_range(p_check_in date, p_check_out date) RETURNS TABLE(room_id uuid, room_number text, room_name text, capacity integer, room_status text, availability_status text)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  IF p_check_in IS NULL OR p_check_out IS NULL OR p_check_out <= p_check_in THEN
    RAISE EXCEPTION 'Choose valid check-in and check-out dates';
  END IF;
  RETURN QUERY
  SELECT r.id, r.room_number::text, r.room_name::text, r.capacity::integer,
         r.status::text,
         CASE
           WHEN lower(coalesce(r.status::text, 'active')) IN ('inactive', 'maintenance', 'unavailable', 'disabled') THEN 'contact'
           WHEN EXISTS (
             SELECT 1 FROM public.bookings b
             WHERE b.room_id = r.id
               AND b.status::text IN ('pending', 'checked_in')
               AND (b.check_in_at AT TIME ZONE 'Asia/Manila')::date < p_check_out
               AND (b.expected_check_out_at AT TIME ZONE 'Asia/Manila')::date > p_check_in
           ) OR EXISTS (
             SELECT 1 FROM public.reservation_requests rr
             WHERE rr.room_id = r.id
               AND (rr.status::text = 'confirmed'
                 OR (rr.status::text = 'pending_payment' AND rr.created_at > now() - interval '24 hours'))
               AND (rr.check_in_at AT TIME ZONE 'Asia/Manila')::date < p_check_out
               AND (rr.expected_check_out_at AT TIME ZONE 'Asia/Manila')::date > p_check_in
           ) THEN 'occupied'
           ELSE 'available'
         END AS availability_status
  FROM public.rooms r
  ORDER BY r.room_number;
END;
$$;


ALTER FUNCTION public.public_room_availability_range(p_check_in date, p_check_out date) OWNER TO postgres;

--
-- Name: send_public_inquiry_message(uuid, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'extensions', 'public', 'pg_temp'
    AS $$
declare
  v_expected text := encode(digest(coalesce(p_access_token, ''), 'sha256'), 'hex');
  v_status text;
begin
  select i.status
    into v_status
  from public.public_inquiries i
  where i.id = p_inquiry_id
    and i.access_token_hash = v_expected;

  if v_status is null then
    raise exception 'Inquiry access denied';
  end if;

  if v_status = 'closed' then
    raise exception 'Inquiry is already closed';
  end if;

  if coalesce(trim(p_message), '') = '' then
    raise exception 'Message is required';
  end if;

  insert into public.public_inquiry_messages (
    inquiry_id,
    sender_type,
    sender_name,
    message
  ) values (
    p_inquiry_id,
    'client',
    coalesce(nullif(trim(p_sender_name), ''), 'Client'),
    trim(p_message)
  );

  update public.public_inquiries
  set updated_at = now()
  where id = p_inquiry_id;

  return true;
end;
$$;


ALTER FUNCTION public.send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text) OWNER TO postgres;

--
-- Name: set_room_status(uuid, text, text, date, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_room_status(p_room_id uuid, p_status text, p_reason text DEFAULT NULL::text, p_until date DEFAULT NULL::date, p_force boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
declare
  actor_id uuid:=auth.uid();
  actor_role text;
  room_row public.rooms%rowtype;
  future_bookings jsonb;
begin
  select role into actor_role from public.users where id=actor_id;
  if actor_id is null or actor_role is distinct from 'admin' then
    raise exception 'Only admins may change room status.' using errcode='42501';
  end if;
  if p_status not in ('active','maintenance','inactive') then
    raise exception 'Invalid room status' using errcode='22023';
  end if;
  if p_status <> 'active' and nullif(trim(coalesce(p_reason,'')),'') is null then
    raise exception 'Provide a reason for maintenance/inactive room' using errcode='22023';
  end if;
  select * into room_row from public.rooms where id=p_room_id for update;
  if not found then raise exception 'Room not found' using errcode='P0002'; end if;
  if p_status <> 'active' and exists(
    select 1 from public.bookings where room_id=p_room_id and status='checked_in'
  ) then
    raise exception 'Cannot close a room with a checked-in pet' using errcode='23514';
  end if;
  select coalesce(jsonb_agg(jsonb_build_object(
    'booking_code',b.booking_code,'check_in_at',b.check_in_at,
    'expected_check_out_at',b.expected_check_out_at
  ) order by b.check_in_at),'[]'::jsonb)
  into future_bookings from public.bookings b
  where b.room_id=p_room_id and b.status='pending'
    and b.expected_check_out_at>now();
  if p_status <> 'active' and jsonb_array_length(future_bookings)>0 and not p_force then
    return jsonb_build_object('requires_confirmation',true,'bookings',future_bookings);
  end if;
  update public.rooms set status=p_status,
    status_reason=case when p_status='active' then null else trim(p_reason) end,
    status_changed_by=actor_id,status_changed_at=now(),
    maintenance_until=case when p_status='maintenance' then p_until else null end
  where id=p_room_id;
  return jsonb_build_object('success',true,'bookings',future_bookings);
end;
$$;


ALTER FUNCTION public.set_room_status(p_room_id uuid, p_status text, p_reason text, p_until date, p_force boolean) OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

--
-- Name: submit_boarding_review_by_email(text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
DECLARE
  v_owner_id uuid;
  v_booking_id uuid;
  v_comment text := pg_catalog.btrim(coalesce(p_comment, ''));
  v_email text := pg_catalog.lower(pg_catalog.btrim(coalesce(p_email, '')));
BEGIN
  IF v_email !~ '^[^@[:space:]]+@gmail[.]com$' THEN
    RAISE EXCEPTION 'A valid Gmail address is required' USING ERRCODE='22023';
  END IF;
  IF p_rating IS NULL OR p_rating NOT BETWEEN 1 AND 5 OR
     pg_catalog.char_length(v_comment) NOT BETWEEN 10 AND 2000 THEN
    RAISE EXCEPTION 'Invalid rating or review length' USING ERRCODE='22023';
  END IF;

  SELECT o.id INTO v_owner_id
  FROM public.owners o
  WHERE pg_catalog.lower(pg_catalog.btrim(o.email)) = v_email
  LIMIT 1;
  IF v_owner_id IS NULL THEN
    RETURN 'not_customer';
  END IF;

  -- Associate with an actual boarding booking, not just an arbitrary email.
  -- Prefer a booking that has not received a review yet.
  SELECT b.id INTO v_booking_id
  FROM public.bookings b
  JOIN public.pet_owner_links pol ON pol.pet_id = b.pet_id
  WHERE pol.owner_id = v_owner_id
    AND NOT EXISTS (
      SELECT 1 FROM public.boarding_reviews br WHERE br.booking_id = b.id
    )
  ORDER BY b.created_at DESC
  LIMIT 1;

  IF v_booking_id IS NULL THEN
    IF EXISTS (
      SELECT 1 FROM public.bookings b
      JOIN public.pet_owner_links pol ON pol.pet_id = b.pet_id
      WHERE pol.owner_id = v_owner_id
    ) THEN
      RETURN 'already_reviewed';
    END IF;
    RETURN 'not_customer';
  END IF;

  INSERT INTO public.boarding_reviews
    (booking_id, owner_id, rating, comment, status)
  VALUES
    (v_booking_id, v_owner_id, p_rating, v_comment, 'pending');

  RETURN 'submitted';
END;
$_$;


ALTER FUNCTION public.submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text) OWNER TO postgres;

--
-- Name: submit_public_review(text, text, integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $$
DECLARE
  v_email text;
  v_owner_id uuid;
  v_booking_id uuid;
  v_review_id uuid;
BEGIN
  v_email := lower(btrim(p_reviewer_email));

  -- Validate input.
  IF length(btrim(coalesce(p_reviewer_name, '')))
     NOT BETWEEN 2 AND 100 THEN
    RAISE EXCEPTION 'Invalid reviewer name';
  END IF;

  IF v_email IS NULL
     OR v_email NOT LIKE '%@gmail.com'
     OR length(v_email) > 254 THEN
    RAISE EXCEPTION 'A valid Gmail address is required';
  END IF;

  IF p_rating IS NULL
     OR p_rating NOT BETWEEN 1 AND 5 THEN
    RAISE EXCEPTION 'Rating must be between 1 and 5';
  END IF;

  IF length(btrim(coalesce(p_comment, '')))
     NOT BETWEEN 10 AND 2000 THEN
    RAISE EXCEPTION
      'Review must contain 10 to 2000 characters';
  END IF;

  -- Find the registered owner.
  SELECT o.id
  INTO v_owner_id
  FROM public.owners o
  WHERE lower(btrim(o.email)) = v_email
  ORDER BY o.created_at
  LIMIT 1;

  IF v_owner_id IS NULL THEN
    RAISE EXCEPTION
      'This email is not eligible to submit a review';
  END IF;

  -- Find an eligible checked-out boarding.
  -- The pet must be linked to the registered owner.
  -- A booking can only have one review.
  SELECT b.id
  INTO v_booking_id
  FROM public.bookings b
  JOIN public.pet_owner_links pol
    ON pol.pet_id = b.pet_id
  WHERE pol.owner_id = v_owner_id
    AND b.actual_check_out_at IS NOT NULL
    AND b.actual_check_out_at <= now()
    AND NOT EXISTS (
      SELECT 1
      FROM public.boarding_reviews br
      WHERE br.booking_id = b.id
    )
  ORDER BY b.actual_check_out_at DESC
  LIMIT 1;

  IF v_booking_id IS NULL THEN
    RAISE EXCEPTION
      'No eligible boarding stay is available for review';
  END IF;

  -- Publish immediately without Admin approval.
  INSERT INTO public.boarding_reviews (
    booking_id,
    owner_id,
    rating,
    comment,
    status
  )
  VALUES (
    v_booking_id,
    v_owner_id,
    p_rating,
    btrim(p_comment),
    'approved'
  )
  RETURNING id INTO v_review_id;

  RETURN v_review_id;

EXCEPTION
  WHEN unique_violation THEN
    RAISE EXCEPTION
      'A review already exists for this boarding stay';
END;
$$;


ALTER FUNCTION public.submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text) OWNER TO postgres;

--
-- Name: update_conversation_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_conversation_updated_at() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
begin

  update public.conversations

  set updated_at = now()

  where id = new.conversation_id;

  return new;

end;
$$;


ALTER FUNCTION public.update_conversation_updated_at() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
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
            subs.entity = entity_
            -- Filter by action early - only get subscriptions interested in this action
            -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
            and (subs.action_filter = '*' or subs.action_filter = action::text);

    -- Subscription vars
    working_role regrole;
    working_selected_columns text[];
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

    -- Loop record for iterating unique roles (outer loop)
    role_record record;
    -- Loop record for iterating unique selected_columns within a role (inner loop)
    cols_record record;
    -- Subscription ids visible at the role level (before fanning out by selected_columns)
    visible_role_sub_ids uuid[] = '{}';

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

    for role_record in
        select claims_role
        from (select distinct claims_role from unnest(subscriptions)) t
        order by claims_role::text
    loop
        working_role := role_record.claims_role;

        -- Update `is_selectable` for columns and old_columns (once per role)
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
            -- Fan out 400 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 400: Bad Request, no primary key']
                )::realtime.wal_rls;
            end loop;

        -- The claims role does not have SELECT permission to the primary key of entity
        elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
            -- Fan out 401 error per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;
                return next (
                    jsonb_build_object(
                        'schema', wal ->> 'schema',
                        'table', wal ->> 'table',
                        'type', action
                    ),
                    is_rls_enabled,
                    (select array_agg(s.subscription_id) from unnest(subscriptions) as s where s.claims_role = working_role and (s.selected_columns is not distinct from working_selected_columns)),
                    array['Error 401: Unauthorized']
                )::realtime.wal_rls;
            end loop;

        else
            -- Create the prepared statement (once per role)
            if is_rls_enabled and action <> 'DELETE' then
                if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                    deallocate walrus_rls_stmt;
                end if;
                execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
            end if;

            -- Collect all visible subscription IDs for this role (filter check + RLS check)
            visible_role_sub_ids = '{}';

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
                    visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                else
                    -- Check if RLS allows the role to see the record
                    perform
                        -- Trim leading and trailing quotes from working_role because set_config
                        -- doesn't recognize the role as valid if they are included
                        set_config('role', trim(both '"' from working_role::text), true),
                        set_config('request.jwt.claims', claims::text, true);

                    execute 'execute walrus_rls_stmt' into subscription_has_access;

                    -- Reset the role on every FOR..LOOP batch execution.
                    -- The first batch of 10 rows is pre-fetched using the current connection role (PG internal behaviour)
                    -- then we have to reset it again otherwise it would use the role defined in the `set_config` above
                    -- to fetch the remaining rows when rows>10, which could be a user-defined role that lacks execution grants.
                    -- The flow is:
                    --   1. run batch with conn role
                    --   2. set_config working_role
                    --   3. execute walrus
                    --   4. reset role (revert)
                    --   5. repeat
                    perform set_config('role', null, true);

                    if subscription_has_access then
                        visible_role_sub_ids = visible_role_sub_ids || subscription_id;
                    end if;
                end if;
            end loop;

            perform set_config('role', null, true);

            -- Inner loop: per distinct selected_columns for this role
            for cols_record in
                select selected_columns
                from (select distinct selected_columns from unnest(subscriptions) s where s.claims_role = working_role) t
                order by coalesce(array_to_string(selected_columns, ','), '')
            loop
                working_selected_columns := cols_record.selected_columns;

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
                            left join (
                                select unnest(conkey) as pkey_attnum
                                from pg_constraint
                                where conrelid = entity_ and contype = 'p'
                            ) pk on pk.pkey_attnum = pa.attnum
                        where
                            attrelid = entity_
                            and attnum > 0
                            and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
                            and (working_selected_columns is null or pa.attname = any(working_selected_columns) or pk.pkey_attnum is not null)
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
                                    and (working_selected_columns is null or coalesce((c).name, (oc).name) = any(working_selected_columns) or coalesce((c).is_pkey, (oc).is_pkey))
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
                                        and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
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
                                    and (working_selected_columns is null or (c).name = any(working_selected_columns) or (c).is_pkey)
                                    and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                                    and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                            )
                        )
                    else '{}'::jsonb
                end;

                -- Filter visible_role_sub_ids to those matching the current selected_columns group
                visible_to_subscription_ids = coalesce(
                    (
                        select array_agg(s.subscription_id)
                        from unnest(subscriptions) s
                        where s.claims_role = working_role
                          and (s.selected_columns is not distinct from working_selected_columns)
                          and s.subscription_id = any(visible_role_sub_ids)
                    ),
                    '{}'::uuid[]
                );

                return next (
                    output,
                    is_rls_enabled,
                    visible_to_subscription_ids,
                    case
                        when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                        else '{}'
                    end
                )::realtime.wal_rls;
            end loop;

        end if;
    end loop;

    perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: authorize(text, text, text, text, text, text[], text[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]) RETURNS record
    LANGUAGE plpgsql
    AS $$
declare
  probe_ids uuid[];
  probe_inserted_at timestamp := now() at time zone 'utc';
  visible_ids uuid[];
  ext text;
  allowed boolean;
begin
  -- The probe inserts are rolled back, but they still give the transaction an xid, so it ends
  -- in a commit. Nothing durable was written, so skip waiting on the WAL flush and sync standbys.
  -- Set outside the block below, whose rollback would undo it.
  perform set_config('synchronous_commit', 'off', true);

  -- The RAISE at the end of this block rolls back everything in it.
  begin
    probe_ids := array(select gen_random_uuid() from unnest(read_extensions));

    insert into realtime.messages (id, topic, extension, inserted_at, updated_at)
    select p.id, topic_name, p.extension, probe_inserted_at, probe_inserted_at
    from unnest(probe_ids, read_extensions) as p(id, extension);

    perform set_config('role', role_name, true),
            set_config('realtime.topic', topic_name, true),
            set_config('request.jwt.claims', claims, true),
            set_config('request.jwt.claim.sub', sub, true),
            set_config('request.jwt.claim.role', role_name, true),
            set_config('request.headers', headers, true);

    -- One lookup for every probe, by the full primary key.
    visible_ids := array(
      select m.id
      from realtime.messages m
      where m.inserted_at = probe_inserted_at
        and m.id = any(probe_ids));

    read_allowed := array(
      select p.id = any(visible_ids)
      from unnest(probe_ids) with ordinality as p(id, n)
      order by p.n);

    write_allowed := '{}';

    foreach ext in array write_extensions loop
      begin
        insert into realtime.messages (topic, extension, inserted_at, updated_at)
        values (topic_name, ext, now() at time zone 'utc', now() at time zone 'utc');

        allowed := true;
      exception when insufficient_privilege then
        allowed := false;
      end;

      write_allowed := write_allowed || allowed;
    end loop;

    raise sqlstate 'RTA01';
  exception when sqlstate 'RTA01' then
    null;
  end;
end;
$$;


ALTER FUNCTION realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]) OWNER TO supabase_realtime_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
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


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_realtime_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
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


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_realtime_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
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


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_realtime_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
declare
    op_symbol text;
    res boolean;
begin
    -- IS DISTINCT FROM / IS NOT DISTINCT FROM: infix, both sides typed literals
    if op = 'isdistinct' then
        execute format(
            'select %L::%s %s %L::%s',
            val_1,
            type_::text,
            case when negate then 'IS NOT DISTINCT FROM' else 'IS DISTINCT FROM' end,
            val_2,
            type_::text
        ) into res;
        return res;
    end if;

    -- IS requires a keyword RHS (NULL, TRUE, FALSE, UNKNOWN), not a typed literal
    if op = 'is' then
        if val_2 not in ('null', 'true', 'false', 'unknown') then
            raise exception 'invalid value for is filter: must be null, true, false, or unknown';
        end if;
        execute format(
            'select %L::%s %s %s',
            val_1,
            type_::text,
            case when negate then 'IS NOT' else 'IS' end,
            upper(val_2)
        ) into res;
        return res;
    end if;

    op_symbol = case
        when op = 'eq'    then '='
        when op = 'neq'   then '!='
        when op = 'lt'    then '<'
        when op = 'lte'   then '<='
        when op = 'gt'    then '>'
        when op = 'gte'   then '>='
        when op = 'in'    then '= any'
        when op = 'like'   then 'LIKE'
        when op = 'ilike'  then 'ILIKE'
        when op = 'match'  then '~'
        when op = 'imatch' then '~*'
        else null
    end;

    if op_symbol is null then
        raise exception 'unsupported equality operator: %', op::text;
    end if;

    execute format(
        'select %L::%s %s (%L::%s)',
        val_1,
        type_::text,
        op_symbol,
        val_2,
        case when op = 'in' then type_::text || '[]' else type_::text end
    ) into res;

    return case when negate then not res else res end;
end;
$$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) OWNER TO supabase_realtime_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    select
        filters is null
        or array_length(filters, 1) is null
        or coalesce(
            count(col.name) = count(1)
            and sum(
                realtime.check_equality_op(
                    op:=f.op,
                    type_:=coalesce(col.type_oid::regtype, col.type_name::regtype),
                    val_1:=col.value #>> '{}',
                    val_2:=f.value,
                    negate:=coalesce(f.negate, false)
                )::int
            ) filter (where col.name is not null) = count(col.name),
            false
        )
    from
        unnest(filters) f
        left join unnest(columns) col
            on f.column_name = col.name;
$$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_realtime_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
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
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: list_changes_sync(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures the slot is read exactly once.
  consumed AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
         realtime.settled_changes(
           slot_name, max_changes,
           'include-pk', 'true',
           'include-transaction', 'false',
           'include-timestamp', 'true',
           'include-type-oids', 'true',
           'format-version', '2',
           'actions', pub.w2j_actions,
           'add-tables', pub.w2j_add_tables
         ) x
  ),
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM consumed
    WHERE consumed.w2j_add_tables <> ''
  ),
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM consumed,
         realtime.apply_rls(
           wal := consumed.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE consumed.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
$$;


ALTER FUNCTION realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_realtime_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  SELECT
    realtime.wal2json_escape_identifier(nsp.nspname::text)
    || '.'
    || realtime.wal2json_escape_identifier(pc.relname::text)
  FROM pg_class pc
  JOIN pg_namespace nsp ON pc.relnamespace = nsp.oid
  WHERE pc.oid = entity
$$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_realtime_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: send_binary(bytea, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
BEGIN
  BEGIN
    generated_id := gen_random_uuid();

    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    INSERT INTO realtime.messages (id, binary_payload, event, topic, private, extension)
    VALUES (generated_id, payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      RAISE WARNING 'WarnSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) OWNER TO supabase_realtime_admin;

--
-- Name: settled_changes(name, integer, text[]); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]) RETURNS TABLE(lsn pg_lsn, xid xid, data text)
    LANGUAGE plpgsql
    AS $$
declare
  upto pg_lsn;
  total bigint;
  xids xid[];
  starts bigint[];
  snapshot pg_snapshot;
  running_xids xid[];
  xmax_age int;
  cut bigint;
begin
  -- Each statement in a volatile function takes its own snapshot, which is what lets the
  -- check below see a writer that was still in flight when the peek ran. Under REPEATABLE
  -- READ the snapshot never advances, so a deferred change would never be released.
  if current_setting('transaction_isolation') <> 'read committed' then
    raise exception 'realtime.settled_changes requires READ COMMITTED';
  end if;

  -- The peek and the read below cover the same WAL, so the read cannot reach a commit the
  -- check never saw.
  upto := pg_current_wal_flush_lsn();

  -- One entry per transaction, in commit order: its xid and the position of its first
  -- change. The peek uses the caller's own options, so max_changes counts exactly what the
  -- read counts. A non-transactional logical message is emitted as soon as it is decoded,
  -- tagged with the xid of whatever transaction wrote it, so it does not mark where that
  -- transaction starts.
  select coalesce(sum(g.n), 0),
         array_agg(g.x order by g.first) filter (where g.first is not null),
         array_agg(g.first order by g.first) filter (where g.first is not null)
    into total, xids, starts
    from (
      select p.xid as x, count(*) as n,
             min(p.ord) filter (where not case
               when starts_with(p.data, '{"action":"M"') then (p.data::jsonb->>'transactional')::boolean is false
               else false
             end) as first
      from pg_logical_slot_peek_changes(slot_name, upto, max_changes, variadic opts)
           with ordinality as p(lsn, xid, data, ord)
      group by p.xid
    ) g;

  -- Nothing for the caller, but the slot still has to move past what the peek covered.
  if total = 0 then
    perform pg_replication_slot_advance(slot_name, upto);
    return;
  end if;

  if xids is not null then
    -- Taken after the peek is materialized, so a writer that was still in flight during
    -- decoding is guaranteed to show up here.
    snapshot := pg_current_snapshot();

    -- A commit record reaches the WAL before the writer leaves the proc array, so a change
    -- can be decoded while its row is invisible. apply_rls would resolve a policy against a
    -- row it cannot see and authorize it for nobody, while the read consumed it regardless.
    --
    -- xip lists transactions running when the snapshot was taken. It does not cover a writer
    -- whose xid sits at or beyond xmax, which never appears there, so the horizon is checked
    -- too. age() counts backwards from the current xid and so compares correctly across
    -- wraparound.
    select coalesce(array_agg(running.x::xid), array[]::xid[])
      into running_xids
      from pg_snapshot_xip(snapshot) running(x);
    xmax_age := age(pg_snapshot_xmax(snapshot)::xid);

    select min(u.s) into cut
      from unnest(xids, starts) as u(x, s)
      where u.x = any(running_xids) or age(u.x) <= xmax_age;
  end if;

  -- The read stops right after the commit that brings its count to upto_nchanges, so the
  -- count of changes in front of the first unsettled transaction stops it just before that
  -- transaction.
  if cut is null then
    return query
      select p.* from pg_logical_slot_get_changes(slot_name, upto, max_changes, variadic opts) p;
  elsif cut > 1 then
    return query
      select p.* from pg_logical_slot_get_changes(slot_name, upto, (cut - 1)::int, variadic opts) p;
  end if;
end;
$$;


ALTER FUNCTION realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]) OWNER TO supabase_realtime_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    col_names text[] = coalesce(
            array_agg(a.attname order by a.attnum),
            '{}'::text[]
        )
        from
            pg_catalog.pg_attribute a
        where
            a.attrelid = new.entity
            and a.attnum > 0
            and not a.attisdropped
            and pg_catalog.has_column_privilege(
                (new.claims ->> 'role'),
                a.attrelid,
                a.attnum,
                'SELECT'
            );
    filter realtime.user_defined_filter;
    col_type regtype;
    in_val jsonb;
    selected_col text;
begin
    for filter in select * from unnest(new.filters) loop
        if not filter.column_name = any(col_names) then
            raise exception 'invalid column for filter %', filter.column_name;
        end if;

        col_type = (
            select atttypid::regtype
            from pg_catalog.pg_attribute
            where attrelid = new.entity
                  and attname = filter.column_name
        );
        if col_type is null then
            raise exception 'failed to lookup type for column %', filter.column_name;
        end if;

        if filter.op = 'in'::realtime.equality_op then
            in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
            if coalesce(jsonb_array_length(in_val), 0) > 100 then
                raise exception 'too many values for `in` filter. Maximum 100';
            end if;
        elsif filter.op = 'is'::realtime.equality_op then
            -- `is` requires a keyword RHS rather than a typed literal
            if filter.value not in ('null', 'true', 'false', 'unknown') then
                raise exception 'invalid value for is filter: must be null, true, false, or unknown';
            end if;
            -- IS NULL works for any type, but IS TRUE/FALSE/UNKNOWN require a boolean
            -- operand. Reject the non-null keywords on non-boolean columns here so they
            -- don't abort apply_rls at WAL time.
            if filter.value <> 'null' and col_type <> 'boolean'::regtype then
                raise exception 'is % filter requires a boolean column, got %', filter.value, col_type::text;
            end if;
        elsif filter.op in ('like'::realtime.equality_op, 'ilike'::realtime.equality_op) then
            -- like/ilike apply the text pattern operator (~~); reject column types that
            -- have no such operator instead of failing at WAL time
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = '~~' and oprleft = col_type
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
        elsif filter.op in ('match'::realtime.equality_op, 'imatch'::realtime.equality_op) then
            -- match/imatch apply the regex operators ~ / ~*; reject column types that have
            -- no such operator (e.g. integer) instead of failing at WAL time, mirroring the
            -- like/ilike guard above.
            if not exists (
                select 1 from pg_catalog.pg_operator
                where oprname = case when filter.op = 'imatch'::realtime.equality_op then '~*' else '~' end
                  and oprleft = col_type
                  and oprright = col_type
                  and oprresult = 'boolean'::regtype
            ) then
                raise exception 'operator % requires a text-compatible column type, got %', filter.op::text, col_type::text;
            end if;
            -- validate the regex eagerly so a bad pattern is rejected here, not inside
            -- apply_rls where it would abort the WAL stream for the entity
            begin
                perform '' ~ filter.value;
            exception when others then
                raise exception 'invalid regular expression for % filter: %', filter.op::text, sqlerrm;
            end;
        else
            -- eq/neq/lt/lte/gt/gte: value must be coercable to the type
            perform realtime.cast(filter.value, col_type);
        end if;
    end loop;

    if new.selected_columns is not null then
        for selected_col in select * from unnest(new.selected_columns) loop
            if not selected_col = any(col_names) then
                raise exception 'invalid column for select %', selected_col;
            end if;
        end loop;
    end if;

    -- Apply consistent order to filters so the unique constraint can't be tricked by a
    -- different filter order. negate is part of the sort key.
    new.filters = coalesce(
        array_agg(f order by f.column_name, f.op, f.value, f.negate),
        '{}'
    ) from unnest(new.filters) f;

    -- Normalize selected_columns order so ARRAY['a','b'] and ARRAY['b','a'] are treated
    -- as the same subscription group in apply_rls. Preserve an empty array as '{}'
    -- ("primary keys only") so it stays distinct from NULL ("all columns"); array_agg
    -- over an empty set would otherwise collapse '{}' back to NULL.
    if new.selected_columns is not null then
        new.selected_columns = coalesce(
            (
                select array_agg(c order by c)
                from unnest(new.selected_columns) c
            ),
            '{}'::text[]
        );
    end if;

    return new;
end;
$$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_realtime_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_realtime_admin;

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
-- Name: wal2json_escape_identifier(text); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.wal2json_escape_identifier(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
  -- Prefix `\`, `,`, `.`, and any whitespace with `\`
  SELECT regexp_replace(name, '([\\,.[:space:]])', '\\\1', 'g')
$$;


ALTER FUNCTION realtime.wal2json_escape_identifier(name text) OWNER TO supabase_realtime_admin;

--
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

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
-- Name: delete_lifecycle_objects(uuid[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_lifecycle_objects(object_ids uuid[]) RETURNS TABLE(id uuid, is_delete_marker boolean, metadata jsonb)
    LANGUAGE plpgsql
    AS $$
DECLARE
    object_id uuid;
    deleted_row storage.objects%ROWTYPE;
    deleted_ids uuid[];
    deleted_markers boolean[];
    deleted_metadata jsonb[];
    bulk_deleted boolean := false;
BEGIN
    -- Surface pre-existing deferred violations instead of treating them as blocked rows.
    SET CONSTRAINTS ALL IMMEDIATE;
    PERFORM set_config('storage.allow_delete_query', 'true', true);

    -- One subxact keeps the subxid cache from overflowing; rows return only once it commits.
    BEGIN
        WITH deleted AS (
            DELETE FROM storage.objects AS object_row
              WHERE object_row.id = ANY(object_ids) AND object_row.archived_at IS NOT NULL
              RETURNING object_row.id, object_row.is_delete_marker, object_row.metadata
        )
        SELECT array_agg(deleted.id), array_agg(deleted.is_delete_marker), array_agg(deleted.metadata)
          INTO deleted_ids, deleted_markers, deleted_metadata
          FROM deleted;
        bulk_deleted := true;
    EXCEPTION
        WHEN OTHERS THEN
            -- User triggers may use insufficient_privilege to block a row.
            IF SQLSTATE <> '42501' AND left(SQLSTATE, 2) IN ('08', '40', '42', '53', '55', '57', '58', 'XX') THEN
                RAISE;
            END IF;
    END;
    IF bulk_deleted THEN
        RETURN QUERY SELECT * FROM unnest(deleted_ids, deleted_markers, deleted_metadata);
        RETURN;
    END IF;

    FOREACH object_id IN ARRAY object_ids LOOP
        BEGIN
            DELETE FROM storage.objects AS object_row
              WHERE object_row.id = object_id AND object_row.archived_at IS NOT NULL
              RETURNING object_row.* INTO deleted_row;
            IF FOUND THEN
                id := deleted_row.id;
                is_delete_marker := deleted_row.is_delete_marker;
                metadata := deleted_row.metadata;
                RETURN NEXT;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLSTATE <> '42501' AND left(SQLSTATE, 2) IN ('08', '40', '42', '53', '55', '57', '58', 'XX') THEN
                    RAISE;
                END IF;
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_lifecycle_objects(object_ids uuid[]) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_lifecycle_service_role(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_lifecycle_service_role() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
  IF current_user::text IS DISTINCT FROM TG_ARGV[0] THEN
    -- Keep this check AFTER caller RLS accepts the proposed row. The API
    -- recognizes this exact signal after rolling back its permission probe.
    RAISE EXCEPTION 'bucket control columns may only be changed by the configured storage service role'
      USING ERRCODE = 'PST01',
            SCHEMA = TG_TABLE_SCHEMA,
            TABLE = TG_TABLE_NAME,
            CONSTRAINT = TG_NAME;
  END IF;

  RETURN NULL;
END;
$$;


ALTER FUNCTION storage.enforce_bucket_lifecycle_service_role() OWNER TO supabase_storage_admin;

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
-- Name: enforce_versioning_status_transition(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_versioning_status_transition() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.versioning_status = OLD.versioning_status THEN
        RETURN NEW;
    END IF;

    IF NEW.versioning_status = 'DISABLED' OR
       (OLD.versioning_status = 'DISABLED' AND NEW.versioning_status = 'SUSPENDED') THEN
        RAISE EXCEPTION 'Cannot transition bucket versioning status from % to %',
            OLD.versioning_status, NEW.versioning_status;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.enforce_versioning_status_transition() OWNER TO supabase_storage_admin;

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
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Get the last path segment (the actual filename)
    SELECT _parts[array_length(_parts, 1)] INTO _filename;
    -- Extract extension: reverse, split on '.', then reverse again
    RETURN reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    RETURN _parts[array_length(_parts, 1)];
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
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN p_delimiter <> ''
         AND position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(
        p_key,
        length(p_prefix)
            + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1))
            + length(p_delimiter) - 1
    )
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket(noncurrent_versions text DEFAULT 'include'::text, delete_markers text DEFAULT 'include'::text) RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'include');
    delete_markers := COALESCE(delete_markers, 'include');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'include';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'include';
    END IF;

    return query
        select sum((metadata->>'size')::bigint)::bigint as size, obj.bucket_id
        from "storage".objects as obj
        where (noncurrent_versions != 'exclude' OR obj.archived_at IS NULL)
          and (noncurrent_versions != 'only' OR obj.archived_at IS NOT NULL)
          and (delete_markers != 'exclude' OR NOT obj.is_delete_marker)
          and (delete_markers != 'only' OR obj.is_delete_marker)
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket(noncurrent_versions text, delete_markers text) OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text, raw_prefix_param text DEFAULT NULL::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE sql STABLE
    AS $_$
WITH candidates AS (
    SELECT
        upload.key AS object_key,
        CASE
            WHEN position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0
            THEN left(
                upload.key,
                length(coalesce($7, $2))
                    + position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1))
                    + length($3) - 1
            )
            ELSE upload.key
        END AS result_key,
        upload.id,
        upload.created_at,
        position($3 IN substring(upload.key FROM length(coalesce($7, $2)) + 1)) > 0 AS is_common_prefix
    FROM storage.s3_multipart_uploads AS upload
    WHERE upload.bucket_id = $1
      AND upload.key COLLATE "C" LIKE $2 || '%'
), filtered AS (
    SELECT candidate.*
    FROM candidates AS candidate
    WHERE $5 = ''
       OR candidate.result_key COLLATE "C" > $5
       OR (
           candidate.result_key COLLATE "C" = $5
           AND NOT candidate.is_common_prefix
           AND $6 <> ''
           -- A completed or aborted marker repeats the remaining same-key uploads.
           AND COALESCE(
               (candidate.created_at, candidate.id COLLATE "C") > (
                   SELECT marker.created_at, marker.id COLLATE "C"
                   FROM storage.s3_multipart_uploads AS marker
                   WHERE marker.bucket_id = $1
                     AND marker.key COLLATE "C" = $5
                     AND marker.id = $6
               ),
               TRUE
           )
       )
), ranked AS (
    SELECT
        filtered.*,
        row_number() OVER (
            PARTITION BY filtered.result_key COLLATE "C"
            ORDER BY filtered.created_at, filtered.id COLLATE "C"
        ) AS prefix_rank
    FROM filtered
)
SELECT ranked.result_key, ranked.id, ranked.created_at
FROM ranked
WHERE NOT ranked.is_common_prefix OR ranked.prefix_rank = 1
ORDER BY ranked.result_key COLLATE "C", ranked.created_at, ranked.id COLLATE "C"
LIMIT $4;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text, raw_prefix_param text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text, text, text, timestamp with time zone, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, next_token_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, next_token_version text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_start_relative TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;

    -- true when noncurrent_versions can return >1 row per name; keeps them
    -- ordered most-recent-first and lets pagination resume mid-key
    v_multi_row BOOLEAN;
    v_name_order TEXT;
    v_exact_range_predicate TEXT;
    v_strict_range_predicate TEXT;
    v_inclusive_range_predicate TEXT;

    -- Seek state for the current name. archived_at is normalized to JavaScript's
    -- millisecond precision and version breaks ties within the same millisecond.
    -- Current rows use 'infinity'; NULL means no tiebreak has been established.
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_cursor_is_folder BOOLEAN;
    v_count INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_batch_query_strict TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');
    v_name_order := CASE WHEN v_is_asc THEN 'ASC' ELSE 'DESC' END;

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Keep caller-provided cursors inside the requested prefix range.
    IF v_start <> '' AND v_upper_bound IS NOT NULL THEN
        IF v_is_asc THEN
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                v_start := '';
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                RETURN;
            END IF;
        ELSE
            IF v_start COLLATE "C" < v_prefix COLLATE "C" THEN
                RETURN;
            ELSIF v_start COLLATE "C" >= v_upper_bound COLLATE "C" THEN
                v_start := '';
            END IF;
        END IF;
    END IF;

    v_start_relative := substring(v_start FROM length(v_prefix) + 1);

    -- Direction affects only the indexed name range and its ordering. Cursor
    -- state transitions and within-key version ordering stay shared.
    IF v_is_asc THEN
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" > $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" >= $2';
        IF v_upper_bound IS NOT NULL THEN
            v_exact_range_predicate := 'o.name COLLATE "C" < $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" < $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" < $3';
        END IF;
    ELSE
        v_exact_range_predicate := 'TRUE';
        v_strict_range_predicate := 'o.name COLLATE "C" < $2';
        v_inclusive_range_predicate := 'o.name COLLATE "C" < $2';
        IF v_prefix <> '' THEN
            v_exact_range_predicate := 'o.name COLLATE "C" >= $3';
            v_strict_range_predicate := v_strict_range_predicate || ' AND o.name COLLATE "C" >= $3';
            v_inclusive_range_predicate := v_inclusive_range_predicate || ' AND o.name COLLATE "C" >= $3';
        END IF;
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    -- The multi-row order matches the externally serialized cursor exactly:
    -- archived_at at millisecond precision, then version as the final tiebreak.
    --
    -- When v_multi_row, the seek is a keyset tuple comparison ("name > $2 OR
    -- (name = $2 AND tiebreak)") - Postgres won't split that OR into indexable
    -- form (confirmed even with fully literal values), so as one WHERE clause
    -- it forces a full bucket scan filtered row-by-row. Splitting it into two
    -- independently-indexable branches (exact name match with the tiebreak
    -- filter, vs. strictly-past names) combined with UNION ALL lets each
    -- branch keep name as a real index condition; the outer ORDER BY/LIMIT
    -- re-merges them into the same page the single query used to produce.
    IF v_multi_row THEN
        v_batch_query := format(
            $sql$
            SELECT *
            FROM (
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND o.name COLLATE "C" = $2
                      AND %s
                      AND NOT $7::boolean
                      AND (
                          $5::timestamptz IS NULL
                          OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < $5
                          OR (
                              COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = $5
                              AND COALESCE(o.version, '') > $6
                          )
                      )
                      %s
                    ORDER BY
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
                UNION ALL
                (
                    SELECT o.name, o.id, o.updated_at, o.created_at,
                           o.last_accessed_at, o.metadata, o.version,
                           o.archived_at, o.is_delete_marker, o.is_versioned
                    FROM storage.objects o
                    WHERE o.bucket_id = $1
                      AND %s
                      %s
                    ORDER BY
                        o.name COLLATE "C" %s,
                        COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC,
                        COALESCE(o.version, '') ASC
                    LIMIT $4
                )
            ) sub
            ORDER BY
                sub.name COLLATE "C" %s,
                COALESCE(date_trunc('milliseconds', sub.archived_at), 'infinity'::timestamptz) DESC,
                COALESCE(sub.version, '') ASC
            LIMIT $4
            $sql$,
            v_exact_range_predicate,
            v_version_filter,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order,
            v_name_order
        );
    ELSE
        v_batch_query := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_inclusive_range_predicate,
            v_version_filter,
            v_name_order
        );

        -- Strict counterpart of the query above: used once the single-row
        -- ASC batch advance (below) has left v_next_seek pointing at the
        -- last row already emitted, so an inclusive predicate would
        -- re-match it forever. Only single-row mode ever sets strict mode,
        -- so this variant is never needed when v_multi_row.
        v_batch_query_strict := format(
            $sql$
            SELECT o.name, o.id, o.updated_at, o.created_at,
                   o.last_accessed_at, o.metadata, o.version,
                   o.archived_at, o.is_delete_marker, o.is_versioned
            FROM storage.objects o
            WHERE o.bucket_id = $1
              AND %s
              %s
            ORDER BY o.name COLLATE "C" %s, o.archived_at DESC
            LIMIT $4
            $sql$,
            v_strict_range_predicate,
            v_version_filter,
            v_name_order
        );
    END IF;

    -- The static peek predicates cannot use the partial delete-marker index
    -- once PL/pgSQL switches to a generic plan because whether
    -- is_delete_marker is required remains parameter-dependent. Reuse the
    -- already-specialized batch query with a one-row limit for this sparse
    -- filter so the plan sees a literal `o.is_delete_marker` predicate.
    IF delete_markers = 'only' THEN
        v_delete_marker_peek_query :=
            'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        IF NOT v_multi_row THEN
            v_delete_marker_peek_query_strict :=
                'SELECT marker_page.name FROM (' || v_batch_query_strict || ') marker_page LIMIT 1';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor performs one specialized initial seek so
            -- partial current-version and delete-marker indexes remain available.
            EXECUTE format(
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY o.name COLLATE "C" DESC LIMIT 1',
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND o.name COLLATE "C" >= $2 AND o.name COLLATE "C" < $3'
                    ELSE ''
                END,
                v_version_filter
            )
            INTO v_next_seek
            USING _bucket_id, v_prefix, v_upper_bound;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Folder continuation tokens retain their trailing delimiter. A
        -- delimiter-less startAfter is always a literal key boundary.
        v_cursor_is_folder := delimiter_param <> ''
            AND v_start_relative <> ''
            AND right(v_start_relative, length(delimiter_param)) = delimiter_param;

        IF v_cursor_is_folder THEN
            v_next_seek := CASE
                WHEN right(v_start, length(delimiter_param)) = delimiter_param
                    THEN v_start
                ELSE v_start || delimiter_param
            END;
            IF v_is_asc THEN
                v_next_seek := left(v_next_seek, -1)
                    || chr(ascii(right(v_next_seek, 1)) + 1);
            END IF;
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- leaf object: when v_multi_row, stay on v_start with the
            -- caller-supplied tiebreak so a page boundary mid-key resumes
            -- that key's remaining rows instead of skipping them. Truncate
            -- to milliseconds like every other v_next_seek_at assignment -
            -- harmless today since object.ts's cursor always round-trips
            -- through JS Date first, but this shouldn't rely on that.
            IF v_multi_row THEN
                v_next_seek := v_start;
                v_next_seek_at := date_trunc('milliseconds', next_token_archived_at);
                v_next_seek_version := coalesce(next_token_version, '');
                v_next_seek_strict := coalesce(next_token, '') = '';
            ELSIF v_is_asc THEN
                v_next_seek := v_start;
                v_next_seek_strict := true;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        -- v_multi_row is branched here (rather than folded into the WHERE
        -- clause as a bound parameter) so each concrete query keeps an
        -- unconditional seek predicate - once PL/pgSQL switches to its
        -- cached generic plan (after 5 calls), a parameter-gated
        -- "(NOT v_multi_row AND name >= $x) OR (v_multi_row AND ...)"
        -- predicate stops the planner from using name as an index
        -- condition at all, degrading every subsequent peek to a full
        -- index scan filtered row-by-row instead of a bounded range scan.
        -- v_multi_row's seek predicate is a keyset tuple comparison
        -- ("name > x OR (name = x AND tiebreak)") - Postgres does not
        -- split this OR into indexable form even with fully literal
        -- values, so it falls back to a full scan filtered row-by-row.
        -- Splitting it into two independently-indexable branches (exact
        -- name match with the tiebreak filter, vs. strictly-past name)
        -- combined with UNION ALL lets each branch keep name as a real
        -- index condition; the outer ORDER BY/LIMIT picks whichever of
        -- the (at most 2) rows sorts first.
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING _bucket_id, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END,
                    1, v_next_seek_at, v_next_seek_version, v_next_seek_strict;
        ELSIF v_multi_row THEN
            IF v_is_asc THEN
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" < v_upper_bound
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek AND o.name COLLATE "C" < v_upper_bound
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" > v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" ASC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND o.name COLLATE "C" >= v_prefix
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT sub.name INTO v_peek_name FROM (
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" = v_next_seek
                           AND NOT v_next_seek_strict
                           AND (v_next_seek_at IS NULL
                                OR COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) < v_next_seek_at
                                OR (COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) = v_next_seek_at
                                    AND COALESCE(o.version, '') > v_next_seek_version))
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY COALESCE(date_trunc('milliseconds', o.archived_at), 'infinity'::timestamptz) DESC, COALESCE(o.version, '') ASC LIMIT 1)
                        UNION ALL
                        (SELECT o.name FROM storage.objects o
                         WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                           AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                           AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                           AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                           AND (delete_markers != 'only' OR o.is_delete_marker)
                         ORDER BY o.name COLLATE "C" DESC LIMIT 1)
                    ) sub ORDER BY sub.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        ELSE
            -- Single-row mode is always noncurrent_versions='exclude'. Keep
            -- this predicate literal so generic plans use the current index.
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.name COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSE
                IF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.name COLLATE "C" >= v_prefix
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = _bucket_id
                      AND o.name COLLATE "C" < v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                      AND (delete_markers != 'only' OR o.is_delete_marker)
                    ORDER BY o.name COLLATE "C" DESC LIMIT 1;
                END IF;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := v_common_prefix;
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            version := NULL;
            archived_at := NULL;
            is_delete_marker := NULL;
            is_versioned := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1)
                    || chr(ascii(right(v_common_prefix, 1)) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
            v_next_seek_strict := NOT v_is_asc;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE CASE WHEN v_next_seek_strict AND NOT v_multi_row THEN v_batch_query_strict ELSE v_batch_query END
                USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size, v_next_seek_at, v_next_seek_version,
                v_next_seek_strict
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN v_current.name
                        ELSE v_current.name || delimiter_param
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                version := v_current.version;
                archived_at := v_current.archived_at;
                is_delete_marker := v_current.is_delete_marker;
                is_versioned := v_current.is_versioned;
                RETURN NEXT;
                v_count := v_count + 1;

                -- when v_multi_row, stay on this name and record its
                -- archived_at as the new tiebreak so remaining rows for the
                -- same key are picked up before moving to the next name
                IF v_multi_row THEN
                    v_next_seek := v_current.name;
                    v_next_seek_at := COALESCE(date_trunc('milliseconds', v_current.archived_at), 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                    v_next_seek_strict := false;
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor
                    -- would skip a real key like `name || '!'` (or any
                    -- character sorting below the delimiter), which sorts
                    -- between `name` and `name || delimiter`. Track the real
                    -- name and mark the next comparison strict instead.
                    v_next_seek := v_current.name;
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.list_objects_with_delimiter made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text, noncurrent_versions text, delete_markers text, next_token_archived_at timestamp with time zone, next_token_version text) OWNER TO supabase_storage_admin;

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
-- Name: protect_active_lifecycle_states(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_active_lifecycle_states() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM storage.bucket_lifecycle_states
        WHERE bucket_id = OLD.id
          AND NOT (
              continuation IS NULL
              OR (continuation @> '{"continuationVersion": 1}' AND continuation #> '{batch,inFlight}' IS NULL)
          )
    ) THEN
        RAISE EXCEPTION 'update or delete on table "buckets" violates foreign key constraint "bucket_lifecycle_states_bucket_id_fkey" on table "bucket_lifecycle_states"'
            USING ERRCODE = 'foreign_key_violation',
                  DETAIL = format('Key (id)=(%s) is still referenced from table "bucket_lifecycle_states".', OLD.id),
                  SCHEMA = 'storage',
                  TABLE = 'bucket_lifecycle_states',
                  CONSTRAINT = 'bucket_lifecycle_states_bucket_id_fkey';
    END IF;
    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.protect_active_lifecycle_states() OWNER TO supabase_storage_admin;

--
-- Name: protect_bucket_control_columns(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_bucket_control_columns() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  configuration_changed boolean;
BEGIN
  IF TG_OP = 'INSERT' THEN
    IF NEW.lifecycle_configuration IS NOT NULL
       OR NEW.lifecycle_configuration_generation IS NOT NULL THEN
      IF NOT pg_has_role(current_user, TG_ARGV[0], 'MEMBER') THEN
        RAISE EXCEPTION 'only members of the configured storage service role may insert lifecycle policy state'
          USING ERRCODE = '42501',
                HINT = format(
                  'Insert with both lifecycle columns NULL and configure lifecycle through the Storage API afterward, or insert as a member of %I.',
                  TG_ARGV[0]
                );
      END IF;
    END IF;

    RETURN NEW;
  END IF;

  configuration_changed =
    OLD.lifecycle_configuration IS DISTINCT FROM NEW.lifecycle_configuration
    OR OLD.lifecycle_configuration_generation IS DISTINCT FROM NEW.lifecycle_configuration_generation;

  IF NOT configuration_changed THEN
    RETURN NEW;
  END IF;

  IF NEW.type IS DISTINCT FROM 'STANDARD' THEN
    RAISE EXCEPTION 'bucket versioning and lifecycle controls require a Standard bucket'
      USING ERRCODE = '0A000';
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     AND NEW.lifecycle_configuration_generation IS NULL THEN
    RETURN NEW;
  END IF;

  IF NEW.lifecycle_configuration IS NULL
     OR NEW.lifecycle_configuration_generation IS NULL
     OR OLD.lifecycle_configuration IS NOT DISTINCT FROM NEW.lifecycle_configuration
     OR OLD.lifecycle_configuration_generation IS NOT DISTINCT FROM NEW.lifecycle_configuration_generation THEN
    RAISE EXCEPTION 'a changed lifecycle policy requires a new non-null generation'
      USING ERRCODE = '22023';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION storage.protect_bucket_control_columns() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: reconcile_lifecycle_state(text, boolean); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
    bucket storage.buckets%ROWTYPE;
    active boolean;
    idle boolean;
    state_generation uuid;
BEGIN
    SELECT * INTO bucket FROM storage.buckets WHERE id = target_bucket_id FOR NO KEY UPDATE;
    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT continuation IS NULL OR (
               continuation @> '{"continuationVersion": 1}'
               AND continuation #> '{batch,inFlight}' IS NULL
           ), generation
    INTO idle, state_generation
    FROM storage.bucket_lifecycle_states
    WHERE bucket_id = target_bucket_id
    FOR UPDATE;

    IF bucket.lifecycle_configuration IS NULL THEN
        DELETE FROM storage.bucket_lifecycle_states
        WHERE bucket_id = target_bucket_id
          AND idle IS TRUE;

        UPDATE storage.bucket_lifecycle_states
        SET next_run_at = clock_timestamp(), updated_at = clock_timestamp()
        WHERE bucket_id = target_bucket_id
          AND idle IS NOT TRUE;
        RETURN;
    END IF;

    active := bucket.versioning_status <> 'DISABLED'
        AND bucket.lifecycle_configuration @> '{"rules":[{"status":"Enabled"}]}'::jsonb;

    -- The state row records the generation it was reconciled with so callers need not detect
    -- policy changes. Rows without a recorded generation keep their work.
    policy_changed := policy_changed OR (
        state_generation IS NOT NULL AND state_generation <> bucket.lifecycle_configuration_generation
    );

    INSERT INTO storage.bucket_lifecycle_states AS state (bucket_id, generation, next_run_at)
    VALUES (bucket.id, bucket.lifecycle_configuration_generation, CASE WHEN active THEN clock_timestamp() END)
    ON CONFLICT (bucket_id) DO UPDATE
    SET next_run_at = CASE
            WHEN policy_changed THEN
                CASE WHEN active OR idle IS NOT TRUE THEN clock_timestamp() END
            ELSE EXCLUDED.next_run_at
        END,
        generation = EXCLUDED.generation,
        claim_id = CASE WHEN policy_changed AND idle IS TRUE
                        THEN NULL ELSE state.claim_id END,
        claim_until = CASE WHEN policy_changed AND idle IS TRUE
                           THEN NULL ELSE state.claim_until END,
        continuation = CASE WHEN policy_changed AND idle IS TRUE
                            THEN NULL ELSE state.continuation END,
        failure_count = CASE WHEN policy_changed AND idle IS TRUE
                             THEN 0 ELSE state.failure_count END,
        last_error = CASE WHEN policy_changed AND idle IS TRUE
                          THEN NULL ELSE state.last_error END,
        updated_at = clock_timestamp()
    WHERE policy_changed OR (state.next_run_at IS NULL AND EXCLUDED.next_run_at IS NOT NULL);
END;
$$;


ALTER FUNCTION storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean) OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_prefix_len INT;
    v_prefix_start INT;
    v_combined_levels INT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;
    v_version_filter TEXT;
    v_multi_row BOOLEAN;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;
    v_delete_marker_peek_query TEXT;
    v_delete_marker_peek_query_strict TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_next_seek_at TIMESTAMPTZ;
    v_next_seek_version TEXT;
    v_next_seek_strict BOOLEAN := false;
    v_count INT := 0;
    v_skipped INT := 0;
    v_previous_seek TEXT;
    v_previous_seek_at TIMESTAMPTZ;
    v_previous_seek_version TEXT;
    v_previous_count INT;
    v_previous_skipped INT;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_prefix_len := length(coalesce(prefix, ''));
    v_prefix_start := coalesce(array_length(string_to_array(coalesce(prefix, ''), v_delimiter), 1), 1);
    v_combined_levels := coalesce(array_length(string_to_array(v_prefix, v_delimiter), 1), 1);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);
    v_next_seek_at := NULL;
    v_next_seek_version := '';

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    v_multi_row := noncurrent_versions IN ('only', 'include');

    v_version_filter := '';
    IF noncurrent_versions = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NULL';
    ELSIF noncurrent_versions = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.archived_at IS NOT NULL';
    END IF;
    IF delete_markers = 'exclude' THEN
        v_version_filter := v_version_filter || ' AND NOT o.is_delete_marker';
    ELSIF delete_markers = 'only' THEN
        v_version_filter := v_version_filter || ' AND o.is_delete_marker';
    END IF;

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT array_to_string(path_tokens[$1:$2], '/') AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $3 || '%%'
                  AND bucket_id = $4
                  AND array_length(objects.path_tokens, 1) <> $2
                  AND ($7 != 'exclude' OR objects.archived_at IS NULL)
                  AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
                  AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
                  AND ($8 != 'only' OR objects.is_delete_marker)
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata,
                   NULL::text AS version,
                   NULL::timestamptz AS archived_at,
                   NULL::boolean AS is_delete_marker,
                   NULL::boolean AS is_versioned FROM folders)
            UNION ALL
            (SELECT array_to_string(path_tokens[$1:$2], '/') AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata,
                   version, archived_at, is_delete_marker, is_versioned
             FROM storage.objects
             WHERE objects.name ILIKE $3 || '%%'
               AND bucket_id = $4
               AND array_length(objects.path_tokens, 1) = $2
               AND ($7 != 'exclude' OR objects.archived_at IS NULL)
               AND ($7 != 'only' OR objects.archived_at IS NOT NULL)
               AND ($8 != 'exclude' OR NOT objects.is_delete_marker)
               AND ($8 != 'only' OR objects.is_delete_marker)
             -- name, then version, as tiebreaks so two versions of the same
             -- key tying on the sort column still sort deterministically
             ORDER BY %I %s, name COLLATE "C" %s, COALESCE(version, '') %s)
            LIMIT $5 OFFSET $6
            $sql$, v_sort_order, v_order_by, v_sort_order, v_sort_order, v_sort_order
        ) USING v_prefix_start, v_combined_levels, v_prefix, bucketname, v_limit, offsets, noncurrent_versions, delete_markers;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build a resume-safe batch query. The exact-name branch returns remaining
    -- versions after the current (archived_at, version) boundary; the strict
    -- name branch returns subsequent keys. UNION ALL keeps both predicates
    -- independently indexable.
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2 AND lower(o.name) COLLATE "C" < $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" > $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" ASC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 AND lower(o.name) COLLATE "C" >= $3' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT * FROM (' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" = $2 AND ($5::timestamptz IS NULL OR COALESCE(o.archived_at, ''infinity''::timestamptz) < $5 OR (COALESCE(o.archived_at, ''infinity''::timestamptz) = $5 AND COALESCE(o.version, '''') > $6))' ||
                v_version_filter || ' ORDER BY COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4) UNION ALL ' ||
                '(SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata, o.version, o.archived_at, o.is_delete_marker, o.is_versioned FROM storage.objects o ' ||
                'WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2' || v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC, COALESCE(o.archived_at, ''infinity''::timestamptz) DESC, COALESCE(o.version, '''') ASC LIMIT $4)' ||
                ') sub ORDER BY lower(sub.name) COLLATE "C" DESC, COALESCE(sub.archived_at, ''infinity''::timestamptz) DESC, COALESCE(sub.version, '''') ASC LIMIT $4';
        END IF;
    END IF;

    -- Keep the delete-marker predicate literal so the cached generic
    -- plan can use idx_objects_delete_markers during the main-loop peek.
    IF delete_markers = 'only' THEN
        IF v_multi_row THEN
            v_delete_marker_peek_query :=
                'SELECT marker_page.name FROM (' || v_batch_query || ') marker_page LIMIT 1';
        ELSIF v_is_asc THEN
            -- Two separate literal query strings, not one gated by a bound
            -- boolean: folding "$n AND op1 OR NOT $n AND op2" into a single
            -- query defeats the generic plan's ability to push either
            -- comparison into the index. Branching in PL/pgSQL control flow
            -- instead keeps each query's index condition intact.
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" >= $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
            -- Strict variant: used once the single-row ASC batch advance
            -- (below) has left v_next_seek pointing at the last row already
            -- emitted, so a plain >= would re-match it forever.
            v_delete_marker_peek_query_strict :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" > $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" < $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1';
        ELSE
            v_delete_marker_peek_query :=
                'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1 ' ||
                'AND lower(o.name) COLLATE "C" < $2' ||
                CASE WHEN v_upper_bound IS NOT NULL
                    THEN ' AND lower(o.name) COLLATE "C" >= $3'
                    ELSE ''
                END ||
                v_version_filter ||
                ' ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC performs one specialized initial seek so partial current-version
        -- and delete-marker indexes remain available.
        EXECUTE format(
            'SELECT o.name FROM storage.objects o WHERE o.bucket_id = $1%s%s ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1',
            CASE WHEN v_upper_bound IS NOT NULL
                THEN ' AND lower(o.name) COLLATE "C" >= $2 AND lower(o.name) COLLATE "C" < $3'
                ELSE ''
            END,
            v_version_filter
        )
        INTO v_peek_name
        USING bucketname, v_prefix_lower, v_upper_bound;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch and
    -- the delete-marker-only path
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        v_previous_seek := v_next_seek;
        v_previous_seek_at := v_next_seek_at;
        v_previous_seek_version := v_next_seek_version;
        v_previous_count := v_count;
        v_previous_skipped := v_skipped;

        -- STEP 1: PEEK
        v_peek_name := NULL;
        IF delete_markers = 'only' THEN
            EXECUTE CASE WHEN v_next_seek_strict
                THEN v_delete_marker_peek_query_strict
                ELSE v_delete_marker_peek_query
            END
                INTO v_peek_name
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END,
                    1, v_next_seek_at, v_next_seek_version;
        ELSIF v_multi_row AND v_next_seek_at IS NOT NULL THEN
            SELECT o.name INTO v_peek_name
            FROM storage.objects o
            WHERE o.bucket_id = bucketname
              AND lower(o.name) COLLATE "C" = v_next_seek
              AND (COALESCE(o.archived_at, 'infinity'::timestamptz) < v_next_seek_at
                   OR (COALESCE(o.archived_at, 'infinity'::timestamptz) = v_next_seek_at
                       AND COALESCE(o.version, '') > v_next_seek_version))
              AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
              AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
              AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
              AND (delete_markers != 'only' OR o.is_delete_marker)
            ORDER BY COALESCE(o.archived_at, 'infinity'::timestamptz) DESC,
                     COALESCE(o.version, '') ASC
            LIMIT 1;

            -- The current key is exhausted. Clear its version boundary and
            -- make the following ASC name peek strict. Appending '/' is not a
            -- valid lexical successor because keys ending in characters such
            -- as '!' sort between the exhausted name and name || '/'.
            IF v_peek_name IS NULL THEN
                IF v_is_asc THEN
                    v_next_seek_strict := true;
                END IF;
                v_next_seek_at := NULL;
                v_next_seek_version := '';
            END IF;
        END IF;

        -- Single-row mode is always noncurrent_versions='exclude'. Keep the
        -- current-row predicate literal so generic plans use the current index.
        IF delete_markers != 'only' AND v_peek_name IS NULL AND NOT v_multi_row THEN
            IF v_is_asc THEN
                IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_next_seek_strict THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSIF v_upper_bound IS NOT NULL THEN
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                ELSE
                    SELECT o.name INTO v_peek_name FROM storage.objects o
                    WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                      AND o.archived_at IS NULL
                      AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                    ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
                END IF;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND o.archived_at IS NULL
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL AND v_is_asc THEN
            IF v_next_seek_strict AND v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_next_seek_strict THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" > v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSIF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSIF delete_markers != 'only' AND v_peek_name IS NULL THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                  AND (noncurrent_versions != 'exclude' OR o.archived_at IS NULL)
                  AND (noncurrent_versions != 'only' OR o.archived_at IS NOT NULL)
                  AND (delete_markers != 'exclude' OR NOT o.is_delete_marker)
                  AND (delete_markers != 'only' OR o.is_delete_marker)
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- If the peek landed on a different key than we were tracking, any
        -- version boundary belongs to the OLD key and must not leak into the
        -- new one - e.g. the deleteMarkers='only' peek doesn't know or care
        -- whether it's continuing the same key or jumping to a new one, so
        -- it never clears these itself.
        IF lower(v_peek_name) IS DISTINCT FROM v_next_seek THEN
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        END IF;

        -- The peek is authoritative for the next key to process. This is
        -- especially important after exhausting a multi-version key: the
        -- version boundary has been cleared, so executing the batch against
        -- a stale v_next_seek would replay every version of that old key.
        v_next_seek := lower(v_peek_name);
        v_next_seek_strict := false;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := substring(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter) from v_prefix_len + 1);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                version := NULL;
                archived_at := NULL;
                is_delete_marker := NULL;
                is_versioned := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
            v_next_seek_at := NULL;
            v_next_seek_version := '';
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size,
                    v_next_seek_at, v_next_seek_version
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it. Reset
                    -- strict mode too - it may have been set by an earlier
                    -- row in this same batch (see the single-row ASC advance
                    -- below), and v_next_seek here is the folder-triggering
                    -- row's own name, which the next peek must find inclusively.
                    v_next_seek := CASE
                        WHEN v_is_asc THEN lower(v_current.name)
                        ELSE lower(v_current.name) || v_delimiter
                    END;
                    v_next_seek_at := NULL;
                    v_next_seek_version := '';
                    v_next_seek_strict := false;
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := substring(v_current.name from v_prefix_len + 1);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    version := v_current.version;
                    archived_at := v_current.archived_at;
                    is_delete_marker := v_current.is_delete_marker;
                    is_versioned := v_current.is_versioned;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Multi-row mode must remain on this key until all of its
                -- versions have crossed the internal batch boundary.
                IF v_multi_row THEN
                    v_next_seek := lower(v_current.name);
                    v_next_seek_at := COALESCE(v_current.archived_at, 'infinity'::timestamptz);
                    v_next_seek_version := COALESCE(v_current.version, '');
                ELSIF v_is_asc THEN
                    -- Appending the delimiter as a fake lexical successor would
                    -- skip a real key like `name || '!'` (or any character
                    -- sorting below the delimiter), which sorts between `name`
                    -- and `name || delimiter`. Track the real name and mark the
                    -- next comparison strict instead - same fix as the
                    -- exhausted-key case above.
                    v_next_seek := lower(v_current.name);
                    v_next_seek_strict := true;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;

        IF v_count = v_previous_count
           AND v_skipped = v_previous_skipped
           AND v_next_seek IS NOT DISTINCT FROM v_previous_seek
           AND v_next_seek_at IS NOT DISTINCT FROM v_previous_seek_at
           AND v_next_seek_version IS NOT DISTINCT FROM v_previous_seek_version THEN
            RAISE EXCEPTION 'storage.search made no progress at seek (%, %, %)',
                v_next_seek, v_next_seek_at, v_next_seek_version;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text, noncurrent_versions text, delete_markers text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, p_start_after_version text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
    v_prefix_pattern text;
    v_sort_order text;
    v_sort_column text;
    v_version_tiebreak text;
BEGIN
    v_prefix := coalesce(p_prefix, '');
    -- Keep the raw prefix for common-prefix calculations and escape only LIKE metacharacters.
    v_prefix_pattern := replace(v_prefix, chr(92), chr(92) || chr(92));
    v_prefix_pattern := replace(v_prefix_pattern, '%', chr(92) || '%');
    v_prefix_pattern := replace(v_prefix_pattern, '_', chr(92) || '_');

    -- COALESCE first: NULL NOT IN (...) evaluates to NULL (not TRUE), so a
    -- bare NOT IN check silently leaves an explicit NULL argument unreset.
    noncurrent_versions := COALESCE(noncurrent_versions, 'exclude');
    delete_markers := COALESCE(delete_markers, 'exclude');
    IF noncurrent_versions NOT IN ('exclude', 'only', 'include') THEN
        noncurrent_versions := 'exclude';
    END IF;
    IF delete_markers NOT IN ('exclude', 'only', 'include') THEN
        delete_markers := 'exclude';
    END IF;

    -- $9 is only populated in multi-row mode; it's always '' otherwise, so
    -- only use each row's real version as a tiebreak in multi-row mode.
    v_version_tiebreak := CASE WHEN noncurrent_versions IN ('only', 'include') THEN 'COALESCE(version, '''')' ELSE '''''' END;

    -- Defense-in-depth: this function is independently reachable and must
    -- not trust p_sort_order/p_sort_column to already be validated by a
    -- caller. Normalize to the same strict allow-list storage.search_v2
    -- uses before interpolating anything into dynamic SQL below.
    v_sort_order := lower(coalesce(p_sort_order, 'asc'));
    IF v_sort_order NOT IN ('asc', 'desc') THEN
        v_sort_order := 'asc';
    END IF;

    v_sort_column := lower(coalesce(p_sort_column, 'updated_at'));
    IF v_sort_column NOT IN ('updated_at', 'created_at') THEN
        v_sort_column := 'updated_at';
    END IF;

    IF v_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                o.version AS obj_version,
                o.archived_at AS obj_archived_at,
                o.is_delete_marker AS obj_is_delete_marker,
                o.is_versioned AS obj_is_versioned,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $10 || '%%'
              AND ($7 != 'exclude' OR o.archived_at IS NULL)
              AND ($7 != 'only' OR o.archived_at IS NOT NULL)
              AND ($8 != 'exclude' OR NOT o.is_delete_marker)
              AND ($8 != 'only' OR o.is_delete_marker)
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                common_prefix AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                NULL::text AS version,
                NULL::timestamptz AS archived_at,
                NULL::boolean AS is_delete_marker,
                NULL::boolean AS is_versioned,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                obj_version AS version,
                obj_archived_at AS archived_at,
                obj_is_delete_marker AS is_delete_marker,
                obj_is_versioned AS is_versioned,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz),
                    name COLLATE "C",
                    %s
                ) %s ROW(
                    -- truncated the same way as the stored value above
                    date_trunc('milliseconds', COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz)),
                    $5,
                    $9
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata,
            version,
            archived_at,
            is_delete_marker,
            is_versioned
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s,
            COALESCE(version, '') %s
        LIMIT $4
    $sql$,
        v_sort_column,
        v_version_tiebreak,
        v_cursor_op,
        v_sort_column,
        v_sort_order,
        v_sort_order,
        v_sort_order
    );

    -- version is the third tiebreak component for two versions of the same
    -- key tying on both timestamp and name (see filtered CTE / ORDER BY above)
    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after, noncurrent_versions, delete_markers, coalesce(p_start_after_version, ''), v_prefix_pattern;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text, noncurrent_versions text, delete_markers text, p_start_after_version text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text, text, text, timestamp with time zone, text, boolean); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text, noncurrent_versions text DEFAULT 'exclude'::text, delete_markers text DEFAULT 'exclude'::text, start_after_archived_at timestamp with time zone DEFAULT NULL::timestamp with time zone, start_after_version text DEFAULT ''::text, start_after_is_continuation boolean DEFAULT false) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb, version text, archived_at timestamp with time zone, is_delete_marker boolean, is_versioned boolean)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata,
            l.version,
            l.archived_at,
            l.is_delete_marker,
            l.is_versioned
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            CASE WHEN start_after_is_continuation THEN '' ELSE start_after END,
            CASE WHEN start_after_is_continuation THEN start_after ELSE '' END,
            v_sort_ord,
            noncurrent_versions,
            delete_markers,
            start_after_archived_at,
            start_after_version
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after,
            noncurrent_versions, delete_markers, start_after_version
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text, noncurrent_versions text, delete_markers text, start_after_archived_at timestamp with time zone, start_after_version text, start_after_is_continuation boolean) OWNER TO supabase_storage_admin;

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

--
-- Name: wake_lifecycle_state(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.wake_lifecycle_state() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.lifecycle_configuration IS NULL THEN
        RETURN NEW;
    END IF;

    PERFORM storage.reconcile_lifecycle_state(NEW.id, false);
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.wake_lifecycle_state() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
    DECLARE
      request_id bigint;
      payload jsonb;
      url text := TG_ARGV[0]::text;
      method text := TG_ARGV[1]::text;
      headers jsonb DEFAULT '{}'::jsonb;
      params jsonb DEFAULT '{}'::jsonb;
      timeout_ms integer DEFAULT 1000;
    BEGIN
      IF url IS NULL OR url = 'null' THEN
        RAISE EXCEPTION 'url argument is missing';
      END IF;

      IF method IS NULL OR method = 'null' THEN
        RAISE EXCEPTION 'method argument is missing';
      END IF;

      IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
        headers = '{"Content-Type": "application/json"}'::jsonb;
      ELSE
        headers = TG_ARGV[2]::jsonb;
      END IF;

      IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
        params = '{}'::jsonb;
      ELSE
        params = TG_ARGV[3]::jsonb;
      END IF;

      IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
        timeout_ms = 1000;
      ELSE
        timeout_ms = TG_ARGV[4]::integer;
      END IF;

      CASE
        WHEN method = 'GET' THEN
          SELECT http_get INTO request_id FROM net.http_get(
            url,
            params,
            headers,
            timeout_ms
          );
        WHEN method = 'POST' THEN
          payload = jsonb_build_object(
            'old_record', OLD,
            'record', NEW,
            'type', TG_OP,
            'table', TG_TABLE_NAME,
            'schema', TG_TABLE_SCHEMA
          );

          SELECT http_post INTO request_id FROM net.http_post(
            url,
            payload,
            params,
            headers,
            timeout_ms
          );
        ELSE
          RAISE EXCEPTION 'method argument % is invalid', method;
      END CASE;

      INSERT INTO supabase_functions.hooks
        (hook_table_id, hook_name, request_id)
      VALUES
        (TG_RELID, TG_NAME, request_id);

      RETURN NEW;
    END
  $$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

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
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    custom_claims_allowlist text[] DEFAULT '{}'::text[] NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


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
-- Name: mfa_recovery_code_sets; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_recovery_code_sets (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    mfa_factor_id uuid NOT NULL,
    failed_verification_count integer DEFAULT 0 NOT NULL,
    verification_locked_until timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mfa_recovery_code_sets_failed_verification_count_check CHECK ((failed_verification_count >= 0))
);


ALTER TABLE auth.mfa_recovery_code_sets OWNER TO supabase_auth_admin;

--
-- Name: mfa_recovery_codes; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_recovery_codes (
    id uuid NOT NULL,
    mfa_recovery_code_set_id uuid NOT NULL,
    code_hash text NOT NULL,
    consumed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE auth.mfa_recovery_codes OWNER TO supabase_auth_admin;

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
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
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
    expires_at timestamp with time zone,
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
-- Name: scim_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.scim_tokens (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    token_hash text NOT NULL,
    prefix text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    revoked_at timestamp with time zone,
    last_used_at timestamp with time zone,
    CONSTRAINT scim_tokens_expires_at_future CHECK (((expires_at IS NULL) OR (expires_at > created_at))),
    CONSTRAINT scim_tokens_revoked_after_created CHECK (((revoked_at IS NULL) OR (revoked_at >= created_at))),
    CONSTRAINT scim_tokens_token_hash_check CHECK ((token_hash ~ '^[0-9a-f]{64}$'::text))
);


ALTER TABLE auth.scim_tokens OWNER TO supabase_auth_admin;

--
-- Name: scim_users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.scim_users (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    user_id uuid,
    resource jsonb NOT NULL,
    user_name text GENERATED ALWAYS AS (lower((resource ->> 'userName'::text))) STORED NOT NULL,
    external_id text GENERATED ALWAYS AS ((resource ->> 'externalId'::text)) STORED,
    active boolean GENERATED ALWAYS AS (COALESCE(((resource ->> 'active'::text))::boolean, true)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE auth.scim_users OWNER TO supabase_auth_admin;

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
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id bigint NOT NULL,
    actor_user_id uuid,
    action text NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid,
    description text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.activity_logs ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.activity_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid,
    device_id uuid,
    alert_type text NOT NULL,
    severity text DEFAULT 'warning'::text NOT NULL,
    title text NOT NULL,
    message text,
    status text DEFAULT 'active'::text NOT NULL,
    acknowledged_by uuid,
    acknowledged_at timestamp with time zone,
    resolved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT alerts_acknowledgement_consistency CHECK (((acknowledged_at IS NULL) OR (acknowledged_by IS NOT NULL))),
    CONSTRAINT alerts_alert_type_check CHECK ((alert_type = ANY (ARRAY['low_water'::text, 'feeding_failure'::text, 'motor_error'::text, 'lid_error'::text, 'device_offline'::text, 'camera_offline'::text, 'missed_feeding'::text]))),
    CONSTRAINT alerts_resolved_after_creation CHECK (((resolved_at IS NULL) OR (resolved_at >= created_at))),
    CONSTRAINT alerts_severity_check CHECK ((severity = ANY (ARRAY['info'::text, 'warning'::text, 'critical'::text]))),
    CONSTRAINT alerts_status_check CHECK ((status = ANY (ARRAY['active'::text, 'acknowledged'::text, 'resolved'::text])))
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- Name: boarding_extension_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boarding_extension_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    owner_id uuid NOT NULL,
    requested_checkout_at timestamp with time zone NOT NULL,
    reason text,
    status text DEFAULT 'pending'::text NOT NULL,
    reviewed_by uuid,
    reviewed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    additional_amount_due numeric(12,2),
    payment_status text DEFAULT 'unverified'::text NOT NULL,
    payment_reference text,
    payment_verified_by uuid,
    payment_verified_at timestamp with time zone,
    original_checkout_at timestamp with time zone,
    CONSTRAINT boarding_extension_amount_nonnegative CHECK (((additional_amount_due IS NULL) OR (additional_amount_due >= (0)::numeric))),
    CONSTRAINT boarding_extension_payment_status_check CHECK ((payment_status = ANY (ARRAY['unverified'::text, 'paid'::text, 'waived'::text, 'not_required'::text]))),
    CONSTRAINT boarding_extension_requests_reason_check CHECK ((char_length(reason) <= 500)),
    CONSTRAINT boarding_extension_requests_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'declined'::text])))
);


ALTER TABLE public.boarding_extension_requests OWNER TO postgres;

--
-- Name: boarding_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boarding_reviews (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    owner_id uuid NOT NULL,
    rating integer NOT NULL,
    comment text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    reviewed_at timestamp with time zone,
    reviewed_by uuid,
    CONSTRAINT boarding_reviews_comment_check CHECK (((char_length(TRIM(BOTH FROM comment)) >= 1) AND (char_length(TRIM(BOTH FROM comment)) <= 1500))),
    CONSTRAINT boarding_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
    CONSTRAINT boarding_reviews_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


ALTER TABLE public.boarding_reviews OWNER TO postgres;

--
-- Name: booking_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_access (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    owner_id uuid,
    invited_email text NOT NULL,
    access_code_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    redeemed_at timestamp with time zone,
    revoked_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    access_type text DEFAULT 'owner'::text NOT NULL,
    redeemed_by_user_id uuid,
    CONSTRAINT booking_access_expiration_after_creation CHECK ((expires_at > created_at)),
    CONSTRAINT booking_access_redemption_requires_owner CHECK (((redeemed_at IS NULL) OR (owner_id IS NOT NULL) OR (redeemed_by_user_id IS NOT NULL))),
    CONSTRAINT booking_access_revoked_after_creation CHECK (((revoked_at IS NULL) OR (revoked_at >= created_at))),
    CONSTRAINT booking_access_type_check CHECK ((access_type = ANY (ARRAY['owner'::text, 'shared'::text])))
);


ALTER TABLE public.booking_access OWNER TO postgres;

--
-- Name: booking_code_redemption_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_code_redemption_attempts (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL,
    successful boolean DEFAULT false NOT NULL
);


ALTER TABLE public.booking_code_redemption_attempts OWNER TO postgres;

--
-- Name: booking_code_redemption_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.booking_code_redemption_attempts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.booking_code_redemption_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_code text NOT NULL,
    pet_id uuid NOT NULL,
    room_id uuid NOT NULL,
    check_in_at timestamp with time zone NOT NULL,
    expected_check_out_at timestamp with time zone NOT NULL,
    actual_check_out_at timestamp with time zone,
    status text DEFAULT 'pending'::text NOT NULL,
    special_instructions text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT bookings_actual_checkout_after_checkin CHECK (((actual_check_out_at IS NULL) OR (actual_check_out_at >= check_in_at))),
    CONSTRAINT bookings_expected_checkout_after_checkin CHECK ((expected_check_out_at > check_in_at)),
    CONSTRAINT bookings_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'checked_in'::text, 'checked_out'::text, 'cancelled'::text, 'no_show'::text])))
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: camera_wifi_switch_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera_wifi_switch_requests (
    device_code text NOT NULL,
    request_id uuid DEFAULT gen_random_uuid() NOT NULL,
    target_ssid text NOT NULL,
    state text DEFAULT 'pending'::text NOT NULL,
    requested_at timestamp with time zone DEFAULT now() NOT NULL,
    delivered_at timestamp with time zone,
    CONSTRAINT camera_wifi_switch_requests_state_check CHECK ((state = ANY (ARRAY['pending'::text, 'delivered'::text]))),
    CONSTRAINT camera_wifi_switch_requests_target_ssid_check CHECK (((char_length(target_ssid) >= 1) AND (char_length(target_ssid) <= 32)))
);


ALTER TABLE public.camera_wifi_switch_requests OWNER TO postgres;

--
-- Name: carefur_feeding_dispatches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carefur_feeding_dispatches (
    schedule_id uuid NOT NULL,
    command_id uuid,
    device_code text NOT NULL,
    queued_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.carefur_feeding_dispatches OWNER TO postgres;

--
-- Name: carefur_feeding_push_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carefur_feeding_push_events (
    event_key text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.carefur_feeding_push_events OWNER TO postgres;

--
-- Name: carefur_feeding_push_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carefur_feeding_push_tokens (
    expo_push_token text NOT NULL,
    auth_user_id uuid NOT NULL,
    platform text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT carefur_feeding_push_tokens_platform_check CHECK ((platform = ANY (ARRAY['android'::text, 'ios'::text])))
);


ALTER TABLE public.carefur_feeding_push_tokens OWNER TO postgres;

--
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    owner_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    owner_email text
);

ALTER TABLE ONLY public.conversations REPLICA IDENTITY FULL;


ALTER TABLE public.conversations OWNER TO postgres;

--
-- Name: device_wifi_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_wifi_status (
    device_code text NOT NULL,
    connected boolean DEFAULT false NOT NULL,
    saved_ssid text DEFAULT ''::text NOT NULL,
    connected_ssid text DEFAULT ''::text NOT NULL,
    ip_address text DEFAULT ''::text NOT NULL,
    rssi smallint,
    paused boolean DEFAULT false NOT NULL,
    last_seen timestamp with time zone DEFAULT now() NOT NULL,
    saved_networks jsonb DEFAULT '[]'::jsonb NOT NULL,
    CONSTRAINT device_wifi_status_rssi_check CHECK ((((rssi >= '-120'::integer) AND (rssi <= 0)) OR (rssi IS NULL)))
);


ALTER TABLE public.device_wifi_status OWNER TO postgres;

--
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    device_code text NOT NULL,
    device_name text,
    device_type text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    last_seen_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT devices_device_type_check CHECK ((device_type = ANY (ARRAY['feeder'::text, 'camera'::text]))),
    CONSTRAINT devices_status_check CHECK ((status = ANY (ARRAY['active'::text, 'maintenance'::text, 'retired'::text])))
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- Name: feeder_eating_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeder_eating_sessions (
    session_id text NOT NULL,
    device_code text NOT NULL,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone,
    relative_weight_drop numeric(12,2) DEFAULT 0 NOT NULL,
    duration_seconds integer,
    time_source text DEFAULT 'device_rtc'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT eating_session_drop_nonnegative CHECK ((relative_weight_drop >= (0)::numeric)),
    CONSTRAINT eating_session_duration_valid CHECK (((duration_seconds IS NULL) OR (duration_seconds >= 0))),
    CONSTRAINT eating_session_ends_after_start CHECK (((ended_at IS NULL) OR (ended_at >= started_at))),
    CONSTRAINT eating_session_identity_length CHECK (((char_length(session_id) >= 8) AND (char_length(session_id) <= 150))),
    CONSTRAINT eating_session_time_source CHECK ((time_source = ANY (ARRAY['device_rtc'::text, 'server_received'::text])))
);


ALTER TABLE public.feeder_eating_sessions OWNER TO postgres;

--
-- Name: feeder_food_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeder_food_events (
    id bigint NOT NULL,
    device_code text NOT NULL,
    event_type text NOT NULL,
    weight_estimate_g numeric(10,2) NOT NULL,
    weight_change_g numeric(10,2),
    message text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feeder_food_events_event_type_check CHECK ((event_type = ANY (ARRAY['food_detected'::text, 'possible_eating'::text, 'plate_empty'::text])))
);


ALTER TABLE public.feeder_food_events OWNER TO postgres;

--
-- Name: feeder_food_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_food_events ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.feeder_food_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: feeder_food_state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeder_food_state (
    device_code text NOT NULL,
    weight_estimate_g numeric(10,2) DEFAULT 0 NOT NULL,
    state text DEFAULT 'empty'::text NOT NULL,
    peak_weight_g numeric(10,2) DEFAULT 0 NOT NULL,
    drop_candidate_at timestamp with time zone,
    last_event_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feeder_food_state_state_check CHECK ((state = ANY (ARRAY['empty'::text, 'food_stable'::text, 'possible_eating'::text])))
);


ALTER TABLE public.feeder_food_state OWNER TO postgres;

--
-- Name: feeder_rtc_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeder_rtc_configs (
    device_code text NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    morning_time time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    afternoon_time time without time zone DEFAULT '13:00:00'::time without time zone NOT NULL,
    evening_time time without time zone DEFAULT '19:00:00'::time without time zone NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by uuid,
    cached_version integer,
    cached_at timestamp with time zone,
    lease_mode text,
    lease_expires_at timestamp with time zone,
    booking_id uuid,
    room_id uuid,
    CONSTRAINT feeder_rtc_cached_version_nonnegative CHECK (((cached_version IS NULL) OR (cached_version >= 0)))
);


ALTER TABLE public.feeder_rtc_configs OWNER TO postgres;

--
-- Name: TABLE feeder_rtc_configs; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feeder_rtc_configs IS 'Device caches this config in NVS; no cloud motor dispatch may run for the same device.';


--
-- Name: feeder_test_commands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeder_test_commands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    device_code text NOT NULL,
    steps integer NOT NULL,
    direction text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    requested_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    claimed_at timestamp with time zone,
    completed_at timestamp with time zone,
    command_type text DEFAULT 'rotate'::text NOT NULL,
    target_compartment smallint,
    CONSTRAINT carefur_feeder_target_compartment_range CHECK (((target_compartment IS NULL) OR ((target_compartment >= 1) AND (target_compartment <= 3)))),
    CONSTRAINT feeder_test_claimed_consistency CHECK (((status <> 'claimed'::text) OR (claimed_at IS NOT NULL))),
    CONSTRAINT feeder_test_commands_command_type_check CHECK ((command_type = ANY (ARRAY['rotate'::text, 'home'::text]))),
    CONSTRAINT feeder_test_commands_direction_check CHECK ((direction = ANY (ARRAY['clockwise'::text, 'counterclockwise'::text]))),
    CONSTRAINT feeder_test_commands_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'claimed'::text, 'completed'::text, 'failed'::text, 'cancelled'::text]))),
    CONSTRAINT feeder_test_commands_steps_check CHECK ((steps = ANY (ARRAY[50, 100, 267, 533])))
);


ALTER TABLE public.feeder_test_commands OWNER TO postgres;

--
-- Name: feeder_test_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeder_test_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    device_code text NOT NULL,
    created_by uuid NOT NULL,
    schedule_type text NOT NULL,
    run_at timestamp with time zone,
    local_time time without time zone,
    enabled boolean DEFAULT true NOT NULL,
    last_fired_key text,
    last_command_id uuid,
    last_result text,
    last_attempt_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feeder_schedule_fields CHECK ((((schedule_type = 'once'::text) AND (run_at IS NOT NULL) AND (local_time IS NULL)) OR ((schedule_type = 'daily'::text) AND (run_at IS NULL) AND (local_time IS NOT NULL)))),
    CONSTRAINT feeder_test_schedules_schedule_type_check CHECK ((schedule_type = ANY (ARRAY['once'::text, 'daily'::text])))
);


ALTER TABLE public.feeder_test_schedules OWNER TO postgres;

--
-- Name: feeding_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeding_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    schedule_id uuid,
    feeder_device_id uuid,
    feeding_method text NOT NULL,
    compartment_number integer,
    performed_by uuid,
    served_weight_grams numeric(7,2),
    remaining_weight_grams numeric(7,2),
    result text NOT NULL,
    completed_at timestamp with time zone DEFAULT now() NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feeding_logs_compartment_range CHECK (((compartment_number IS NULL) OR ((compartment_number >= 1) AND (compartment_number <= 3)))),
    CONSTRAINT feeding_logs_feeding_method_check CHECK ((feeding_method = ANY (ARRAY['automatic'::text, 'manual'::text]))),
    CONSTRAINT feeding_logs_remaining_weight_grams_check CHECK (((remaining_weight_grams IS NULL) OR (remaining_weight_grams >= (0)::numeric))),
    CONSTRAINT feeding_logs_result_check CHECK ((result = ANY (ARRAY['success'::text, 'partial'::text, 'failed'::text, 'skipped'::text]))),
    CONSTRAINT feeding_logs_served_weight_grams_check CHECK (((served_weight_grams IS NULL) OR (served_weight_grams >= (0)::numeric)))
);


ALTER TABLE public.feeding_logs OWNER TO postgres;

--
-- Name: feeding_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feeding_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    booking_id uuid NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    feeding_method text DEFAULT 'automatic'::text NOT NULL,
    compartment_number integer,
    portion_grams numeric(7,2),
    instructions text,
    status text DEFAULT 'pending'::text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feeding_schedules_automatic_compartment_required CHECK (((feeding_method = 'manual'::text) OR (compartment_number IS NOT NULL))),
    CONSTRAINT feeding_schedules_compartment_range CHECK (((compartment_number IS NULL) OR ((compartment_number >= 1) AND (compartment_number <= 3)))),
    CONSTRAINT feeding_schedules_feeding_method_check CHECK ((feeding_method = ANY (ARRAY['automatic'::text, 'manual'::text]))),
    CONSTRAINT feeding_schedules_portion_grams_check CHECK (((portion_grams IS NULL) OR (portion_grams > (0)::numeric))),
    CONSTRAINT feeding_schedules_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'completed'::text, 'missed'::text, 'cancelled'::text])))
);


ALTER TABLE public.feeding_schedules OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    sender_user_id uuid,
    sender_type text NOT NULL,
    message text NOT NULL,
    read_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    sender_name text,
    CONSTRAINT messages_sender_type_check CHECK ((sender_type = ANY (ARRAY['customer'::text, 'staff'::text, 'guest'::text, 'system'::text])))
);

ALTER TABLE ONLY public.messages REPLICA IDENTITY FULL;


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text,
    notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: pet_owner_links; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pet_owner_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pet_id uuid NOT NULL,
    owner_id uuid NOT NULL,
    relationship text,
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pet_owner_links OWNER TO postgres;

--
-- Name: pet_vaccinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pet_vaccinations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pet_id uuid NOT NULL,
    vaccine_name text NOT NULL,
    administered_at date,
    next_due_at date,
    veterinarian text,
    clinic_name text,
    document_url text,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pet_vaccinations OWNER TO postgres;

--
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    species text NOT NULL,
    breed text,
    sex text,
    birth_date date,
    weight_kg numeric(6,2),
    allergies text,
    medical_notes text,
    feeding_notes text,
    photo_url text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT pets_sex_check CHECK ((sex = ANY (ARRAY['male'::text, 'female'::text, 'unknown'::text]))),
    CONSTRAINT pets_weight_kg_check CHECK (((weight_kg IS NULL) OR (weight_kg > (0)::numeric)))
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- Name: public_inquiries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_inquiries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_user_id uuid,
    client_name text NOT NULL,
    client_email text NOT NULL,
    subject text NOT NULL,
    status text DEFAULT 'open'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    access_token_hash text,
    CONSTRAINT public_inquiries_status_check CHECK ((status = ANY (ARRAY['open'::text, 'closed'::text])))
);


ALTER TABLE public.public_inquiries OWNER TO postgres;

--
-- Name: public_inquiry_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_inquiry_messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    inquiry_id uuid NOT NULL,
    sender_user_id uuid,
    sender_type text NOT NULL,
    message text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    sender_name text,
    staff_user_id uuid,
    CONSTRAINT public_inquiry_messages_sender_type_check CHECK ((sender_type = ANY (ARRAY['client'::text, 'staff'::text])))
);


ALTER TABLE public.public_inquiry_messages OWNER TO postgres;

--
-- Name: public_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.public_reviews (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    reviewer_user_id uuid,
    reviewer_name text NOT NULL,
    rating integer NOT NULL,
    comment text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    reviewer_email text,
    CONSTRAINT public_reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
    CONSTRAINT public_reviews_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


ALTER TABLE public.public_reviews OWNER TO postgres;

--
-- Name: reservation_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_user_id uuid,
    owner_name text NOT NULL,
    email text NOT NULL,
    phone text,
    pet_name text NOT NULL,
    pet_species text,
    pet_breed text,
    room_id uuid,
    check_in_at timestamp with time zone NOT NULL,
    expected_check_out_at timestamp with time zone NOT NULL,
    special_instructions text,
    status text DEFAULT 'pending_payment'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    requested_room_number text,
    room_rate_per_night numeric(10,2),
    nights integer,
    estimated_total numeric(10,2),
    request_code text,
    boarding_booking_id uuid,
    paid_at timestamp with time zone,
    paid_by uuid,
    paid_sms_status text DEFAULT 'not_sent'::text NOT NULL,
    paid_sms_error text,
    paid_sms_updated_at timestamp with time zone,
    CONSTRAINT reservation_requests_status_check CHECK ((status = ANY (ARRAY['pending_payment'::text, 'confirmed'::text, 'declined'::text, 'cancelled'::text])))
);


ALTER TABLE public.reservation_requests OWNER TO postgres;

--
-- Name: reservation_sms_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservation_sms_notifications (
    request_id uuid NOT NULL,
    status text NOT NULL,
    error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT reservation_sms_notifications_status_check CHECK ((status = ANY (ARRAY['sending'::text, 'queued'::text, 'failed'::text])))
);


ALTER TABLE public.reservation_sms_notifications OWNER TO postgres;

--
-- Name: room_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room_devices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_id uuid NOT NULL,
    device_id uuid NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    unassigned_at timestamp with time zone,
    assigned_by uuid,
    CONSTRAINT room_devices_valid_dates CHECK (((unassigned_at IS NULL) OR (unassigned_at >= assigned_at)))
);


ALTER TABLE public.room_devices OWNER TO postgres;

--
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    room_number text NOT NULL,
    room_name text,
    capacity integer DEFAULT 1 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    status_reason text,
    status_changed_at timestamp with time zone,
    status_changed_by uuid,
    maintenance_until date,
    CONSTRAINT rooms_capacity_check CHECK ((capacity > 0)),
    CONSTRAINT rooms_status_check CHECK ((status = ANY (ARRAY['active'::text, 'maintenance'::text, 'inactive'::text])))
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- Name: smart_units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.smart_units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    unit_code text NOT NULL,
    unit_name text,
    feeder_device_id uuid NOT NULL,
    camera_device_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT smart_units_distinct_devices CHECK ((feeder_device_id <> camera_device_id))
);


ALTER TABLE public.smart_units OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT auth.uid() NOT NULL,
    full_name text NOT NULL,
    email text,
    phone text,
    avatar_url text,
    role public.user_role DEFAULT 'owner'::public.user_role NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_05; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_05 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_05 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_06; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_06 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_06 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_07; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_07 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_07 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_08; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_08 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_08 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_09; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_09 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_09 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_10; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_10 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_10 OWNER TO supabase_realtime_admin;

--
-- Name: messages_2026_11_11; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages_2026_11_11 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('utc'::text, clock_timestamp()) NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    binary_payload bytea,
    skip_broadcast boolean DEFAULT false NOT NULL,
    CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL)))
);


ALTER TABLE realtime.messages_2026_11_11 OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    selected_columns text[],
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_realtime_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_realtime_admin
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
-- Name: bucket_lifecycle_states; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.bucket_lifecycle_states (
    bucket_id text NOT NULL,
    generation uuid,
    next_run_at timestamp with time zone,
    claim_id uuid,
    claim_until timestamp with time zone,
    continuation jsonb,
    last_started_at timestamp with time zone,
    last_completed_at timestamp with time zone,
    last_success_at timestamp with time zone,
    last_result jsonb,
    failure_count integer DEFAULT 0 NOT NULL,
    last_error jsonb,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT bucket_lifecycle_continuation_object_check CHECK (((continuation IS NULL) OR (jsonb_typeof(continuation) = 'object'::text))),
    CONSTRAINT bucket_lifecycle_failure_count_check CHECK ((failure_count >= 0)),
    CONSTRAINT bucket_lifecycle_last_result_object_check CHECK (((last_result IS NULL) OR (jsonb_typeof(last_result) = 'object'::text))),
    CONSTRAINT bucket_lifecycle_recovery_due_check CHECK (((next_run_at IS NOT NULL) OR (NOT jsonb_path_exists(COALESCE(continuation, '{}'::jsonb), '$."batch"."inFlight"'::jsonpath))))
);


ALTER TABLE storage.bucket_lifecycle_states OWNER TO supabase_storage_admin;

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
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL,
    versioning_status text DEFAULT 'DISABLED'::text NOT NULL,
    lifecycle_configuration jsonb,
    lifecycle_configuration_generation uuid,
    CONSTRAINT buckets_lifecycle_configuration_pair_check CHECK (((lifecycle_configuration IS NULL) = (lifecycle_configuration_generation IS NULL))),
    CONSTRAINT buckets_lifecycle_configuration_shape_check CHECK (((lifecycle_configuration IS NULL) OR ((jsonb_typeof(lifecycle_configuration) = 'object'::text) AND (lifecycle_configuration ? 'rules'::text) AND
CASE
    WHEN (jsonb_typeof((lifecycle_configuration -> 'rules'::text)) = 'array'::text) THEN ((jsonb_array_length((lifecycle_configuration -> 'rules'::text)) >= 1) AND (jsonb_array_length((lifecycle_configuration -> 'rules'::text)) <= 1000))
    ELSE false
END))),
    CONSTRAINT buckets_lifecycle_configuration_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR ((lifecycle_configuration IS NULL) AND (lifecycle_configuration_generation IS NULL)))),
    CONSTRAINT buckets_versioning_standard_only_check CHECK (((type = 'STANDARD'::storage.buckettype) OR (versioning_status = 'DISABLED'::text))),
    CONSTRAINT buckets_versioning_status_check CHECK ((versioning_status = ANY (ARRAY['DISABLED'::text, 'ENABLED'::text, 'SUSPENDED'::text])))
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
-- Name: lifecycle_abandoned_artifacts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.lifecycle_abandoned_artifacts (
    bucket_id text NOT NULL,
    key text NOT NULL,
    name text NOT NULL,
    version text,
    attempted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.lifecycle_abandoned_artifacts OWNER TO supabase_storage_admin;

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
    archived_at timestamp with time zone,
    is_delete_marker boolean DEFAULT false NOT NULL,
    is_versioned boolean DEFAULT false NOT NULL
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


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
    user_metadata jsonb,
    metadata jsonb
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
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: postgres
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO postgres;

--
-- Name: messages_2026_11_05; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_05 FOR VALUES FROM ('2026-11-05 00:00:00') TO ('2026-11-06 00:00:00');


--
-- Name: messages_2026_11_06; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_06 FOR VALUES FROM ('2026-11-06 00:00:00') TO ('2026-11-07 00:00:00');


--
-- Name: messages_2026_11_07; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_07 FOR VALUES FROM ('2026-11-07 00:00:00') TO ('2026-11-08 00:00:00');


--
-- Name: messages_2026_11_08; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_08 FOR VALUES FROM ('2026-11-08 00:00:00') TO ('2026-11-09 00:00:00');


--
-- Name: messages_2026_11_09; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_09 FOR VALUES FROM ('2026-11-09 00:00:00') TO ('2026-11-10 00:00:00');


--
-- Name: messages_2026_11_10; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_10 FOR VALUES FROM ('2026-11-10 00:00:00') TO ('2026-11-11 00:00:00');


--
-- Name: messages_2026_11_11; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_11_11 FOR VALUES FROM ('2026-11-11 00:00:00') TO ('2026-11-12 00:00:00');


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


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
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


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
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_key UNIQUE (mfa_factor_id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_pkey PRIMARY KEY (id);


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_key UNIQUE (user_id);


--
-- Name: mfa_recovery_codes mfa_recovery_codes_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_pkey PRIMARY KEY (id);


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
-- Name: scim_tokens scim_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_pkey PRIMARY KEY (id);


--
-- Name: scim_users scim_users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_pkey PRIMARY KEY (id);


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
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: boarding_extension_requests boarding_extension_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_extension_requests
    ADD CONSTRAINT boarding_extension_requests_pkey PRIMARY KEY (id);


--
-- Name: boarding_reviews boarding_reviews_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_reviews
    ADD CONSTRAINT boarding_reviews_booking_id_key UNIQUE (booking_id);


--
-- Name: boarding_reviews boarding_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_reviews
    ADD CONSTRAINT boarding_reviews_pkey PRIMARY KEY (id);


--
-- Name: booking_access booking_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_access
    ADD CONSTRAINT booking_access_pkey PRIMARY KEY (id);


--
-- Name: booking_code_redemption_attempts booking_code_redemption_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_code_redemption_attempts
    ADD CONSTRAINT booking_code_redemption_attempts_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_booking_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_booking_code_key UNIQUE (booking_code);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: camera_wifi_switch_requests camera_wifi_switch_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_wifi_switch_requests
    ADD CONSTRAINT camera_wifi_switch_requests_pkey PRIMARY KEY (device_code);


--
-- Name: carefur_feeding_dispatches carefur_feeding_dispatches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carefur_feeding_dispatches
    ADD CONSTRAINT carefur_feeding_dispatches_pkey PRIMARY KEY (schedule_id);


--
-- Name: carefur_feeding_push_events carefur_feeding_push_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carefur_feeding_push_events
    ADD CONSTRAINT carefur_feeding_push_events_pkey PRIMARY KEY (event_key);


--
-- Name: carefur_feeding_push_tokens carefur_feeding_push_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carefur_feeding_push_tokens
    ADD CONSTRAINT carefur_feeding_push_tokens_pkey PRIMARY KEY (expo_push_token);


--
-- Name: conversations conversations_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_booking_id_key UNIQUE (booking_id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: device_wifi_status device_wifi_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_wifi_status
    ADD CONSTRAINT device_wifi_status_pkey PRIMARY KEY (device_code);


--
-- Name: devices devices_device_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_device_code_key UNIQUE (device_code);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: feeder_eating_sessions feeder_eating_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_eating_sessions
    ADD CONSTRAINT feeder_eating_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: feeder_food_events feeder_food_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_food_events
    ADD CONSTRAINT feeder_food_events_pkey PRIMARY KEY (id);


--
-- Name: feeder_food_state feeder_food_state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_food_state
    ADD CONSTRAINT feeder_food_state_pkey PRIMARY KEY (device_code);


--
-- Name: feeder_rtc_configs feeder_rtc_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_rtc_configs
    ADD CONSTRAINT feeder_rtc_configs_pkey PRIMARY KEY (device_code);


--
-- Name: feeder_test_commands feeder_test_commands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_test_commands
    ADD CONSTRAINT feeder_test_commands_pkey PRIMARY KEY (id);


--
-- Name: feeder_test_schedules feeder_test_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_test_schedules
    ADD CONSTRAINT feeder_test_schedules_pkey PRIMARY KEY (id);


--
-- Name: feeding_logs feeding_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_logs
    ADD CONSTRAINT feeding_logs_pkey PRIMARY KEY (id);


--
-- Name: feeding_schedules feeding_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_schedules
    ADD CONSTRAINT feeding_schedules_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (id);


--
-- Name: pet_owner_links pet_owner_links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_owner_links
    ADD CONSTRAINT pet_owner_links_pkey PRIMARY KEY (id);


--
-- Name: pet_owner_links pet_owner_links_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_owner_links
    ADD CONSTRAINT pet_owner_links_unique UNIQUE (pet_id, owner_id);


--
-- Name: pet_vaccinations pet_vaccinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_vaccinations
    ADD CONSTRAINT pet_vaccinations_pkey PRIMARY KEY (id);


--
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (id);


--
-- Name: public_inquiries public_inquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_inquiries
    ADD CONSTRAINT public_inquiries_pkey PRIMARY KEY (id);


--
-- Name: public_inquiry_messages public_inquiry_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_inquiry_messages
    ADD CONSTRAINT public_inquiry_messages_pkey PRIMARY KEY (id);


--
-- Name: public_reviews public_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_reviews
    ADD CONSTRAINT public_reviews_pkey PRIMARY KEY (id);


--
-- Name: reservation_requests reservation_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_requests
    ADD CONSTRAINT reservation_requests_pkey PRIMARY KEY (id);


--
-- Name: reservation_sms_notifications reservation_sms_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_sms_notifications
    ADD CONSTRAINT reservation_sms_notifications_pkey PRIMARY KEY (request_id);


--
-- Name: room_devices room_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_devices
    ADD CONSTRAINT room_devices_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_room_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_room_number_key UNIQUE (room_number);


--
-- Name: smart_units smart_units_camera_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smart_units
    ADD CONSTRAINT smart_units_camera_device_id_key UNIQUE (camera_device_id);


--
-- Name: smart_units smart_units_feeder_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smart_units
    ADD CONSTRAINT smart_units_feeder_device_id_key UNIQUE (feeder_device_id);


--
-- Name: smart_units smart_units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smart_units
    ADD CONSTRAINT smart_units_pkey PRIMARY KEY (id);


--
-- Name: smart_units smart_units_unit_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smart_units
    ADD CONSTRAINT smart_units_unit_code_key UNIQUE (unit_code);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_05 messages_2026_11_05_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_05
    ADD CONSTRAINT messages_2026_11_05_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_06 messages_2026_11_06_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_06
    ADD CONSTRAINT messages_2026_11_06_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_07 messages_2026_11_07_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_07
    ADD CONSTRAINT messages_2026_11_07_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_08 messages_2026_11_08_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_08
    ADD CONSTRAINT messages_2026_11_08_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_09 messages_2026_11_09_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_09
    ADD CONSTRAINT messages_2026_11_09_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_10 messages_2026_11_10_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_10
    ADD CONSTRAINT messages_2026_11_10_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2026_11_11 messages_2026_11_11_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages_2026_11_11
    ADD CONSTRAINT messages_2026_11_11_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages messages_payload_exclusive; Type: CHECK CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages
    ADD CONSTRAINT messages_payload_exclusive CHECK (((payload IS NULL) OR (binary_payload IS NULL))) NOT VALID;


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: bucket_lifecycle_states bucket_lifecycle_states_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.bucket_lifecycle_states
    ADD CONSTRAINT bucket_lifecycle_states_pkey PRIMARY KEY (bucket_id);


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
-- Name: lifecycle_abandoned_artifacts lifecycle_abandoned_artifacts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.lifecycle_abandoned_artifacts
    ADD CONSTRAINT lifecycle_abandoned_artifacts_pkey PRIMARY KEY (bucket_id, key);


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
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: postgres
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


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
-- Name: idx_users_created_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_created_at_desc ON auth.users USING btree (created_at DESC);


--
-- Name: idx_users_email; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_email ON auth.users USING btree (email);


--
-- Name: idx_users_last_sign_in_at_desc; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_last_sign_in_at_desc ON auth.users USING btree (last_sign_in_at DESC);


--
-- Name: idx_users_name; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_users_name ON auth.users USING btree (((raw_user_meta_data ->> 'name'::text))) WHERE ((raw_user_meta_data ->> 'name'::text) IS NOT NULL);


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
-- Name: mfa_recovery_codes_set_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_recovery_codes_set_id_idx ON auth.mfa_recovery_codes USING btree (mfa_recovery_code_set_id);


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
-- Name: scim_tokens_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_tokens_expires_at_idx ON auth.scim_tokens USING btree (expires_at);


--
-- Name: scim_tokens_revoked_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_tokens_revoked_at_idx ON auth.scim_tokens USING btree (revoked_at);


--
-- Name: scim_tokens_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_tokens_sso_provider_id_idx ON auth.scim_tokens USING btree (sso_provider_id);


--
-- Name: scim_tokens_token_hash_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX scim_tokens_token_hash_key ON auth.scim_tokens USING btree (token_hash);


--
-- Name: scim_users_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_created_at_idx ON auth.scim_users USING btree (sso_provider_id, created_at, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_deleted_at_idx ON auth.scim_users USING btree (deleted_at);


--
-- Name: scim_users_external_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX scim_users_external_id_key ON auth.scim_users USING btree (sso_provider_id, external_id) WHERE ((external_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: scim_users_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_id_idx ON auth.scim_users USING btree (sso_provider_id, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_sso_provider_id_idx ON auth.scim_users USING btree (sso_provider_id);


--
-- Name: scim_users_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_updated_at_idx ON auth.scim_users USING btree (sso_provider_id, updated_at, id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_user_id_idx ON auth.scim_users USING btree (user_id);


--
-- Name: scim_users_user_name_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX scim_users_user_name_idx ON auth.scim_users USING btree (sso_provider_id, user_name COLLATE "C", id) WHERE (deleted_at IS NULL);


--
-- Name: scim_users_user_name_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX scim_users_user_name_key ON auth.scim_users USING btree (sso_provider_id, user_name) WHERE (deleted_at IS NULL);


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
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: activity_logs_actor_user_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX activity_logs_actor_user_id_idx ON public.activity_logs USING btree (actor_user_id);


--
-- Name: activity_logs_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX activity_logs_created_at_idx ON public.activity_logs USING btree (created_at DESC);


--
-- Name: activity_logs_entity_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX activity_logs_entity_idx ON public.activity_logs USING btree (entity_type, entity_id);


--
-- Name: alerts_booking_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alerts_booking_id_idx ON public.alerts USING btree (booking_id);


--
-- Name: alerts_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alerts_created_at_idx ON public.alerts USING btree (created_at DESC);


--
-- Name: alerts_device_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alerts_device_id_idx ON public.alerts USING btree (device_id);


--
-- Name: alerts_severity_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alerts_severity_idx ON public.alerts USING btree (severity);


--
-- Name: alerts_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX alerts_status_idx ON public.alerts USING btree (status);


--
-- Name: boarding_reviews_one_per_booking_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX boarding_reviews_one_per_booking_idx ON public.boarding_reviews USING btree (booking_id);


--
-- Name: booking_access_booking_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX booking_access_booking_id_idx ON public.booking_access USING btree (booking_id);


--
-- Name: booking_access_code_hash_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX booking_access_code_hash_idx ON public.booking_access USING btree (access_code_hash);


--
-- Name: booking_access_invited_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX booking_access_invited_email_idx ON public.booking_access USING btree (lower(invited_email));


--
-- Name: booking_access_owner_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX booking_access_owner_id_idx ON public.booking_access USING btree (owner_id);


--
-- Name: booking_access_unique_owner_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX booking_access_unique_owner_idx ON public.booking_access USING btree (booking_id, owner_id) WHERE (owner_id IS NOT NULL);


--
-- Name: booking_code_attempts_user_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX booking_code_attempts_user_time_idx ON public.booking_code_redemption_attempts USING btree (user_id, attempted_at DESC);


--
-- Name: bookings_check_in_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_check_in_at_idx ON public.bookings USING btree (check_in_at);


--
-- Name: bookings_pet_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_pet_id_idx ON public.bookings USING btree (pet_id);


--
-- Name: bookings_room_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_room_id_idx ON public.bookings USING btree (room_id);


--
-- Name: bookings_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX bookings_status_idx ON public.bookings USING btree (status);


--
-- Name: carefur_booking_shares_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carefur_booking_shares_lookup ON public.booking_access USING btree (booking_id, access_type, expires_at) WHERE (revoked_at IS NULL);


--
-- Name: carefur_extension_booking_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carefur_extension_booking_idx ON public.boarding_extension_requests USING btree (booking_id);


--
-- Name: carefur_feeding_dispatches_command_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX carefur_feeding_dispatches_command_unique ON public.carefur_feeding_dispatches USING btree (command_id) WHERE (command_id IS NOT NULL);


--
-- Name: carefur_feeding_push_tokens_user_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX carefur_feeding_push_tokens_user_idx ON public.carefur_feeding_push_tokens USING btree (auth_user_id);


--
-- Name: carefur_one_pending_extension_per_booking; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX carefur_one_pending_extension_per_booking ON public.boarding_extension_requests USING btree (booking_id) WHERE (status = 'pending'::text);


--
-- Name: conversations_booking_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conversations_booking_id_idx ON public.conversations USING btree (booking_id);


--
-- Name: conversations_booking_id_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX conversations_booking_id_unique ON public.conversations USING btree (booking_id);


--
-- Name: conversations_owner_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conversations_owner_email_idx ON public.conversations USING btree (owner_email);


--
-- Name: conversations_owner_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conversations_owner_id_idx ON public.conversations USING btree (owner_id);


--
-- Name: conversations_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX conversations_updated_at_idx ON public.conversations USING btree (updated_at DESC);


--
-- Name: devices_device_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devices_device_type_idx ON public.devices USING btree (device_type);


--
-- Name: devices_last_seen_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX devices_last_seen_at_idx ON public.devices USING btree (last_seen_at);


--
-- Name: feeder_eating_sessions_device_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeder_eating_sessions_device_time_idx ON public.feeder_eating_sessions USING btree (device_code, started_at DESC);


--
-- Name: feeder_food_events_device_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeder_food_events_device_time ON public.feeder_food_events USING btree (device_code, created_at DESC);


--
-- Name: feeder_test_commands_device_status_created_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeder_test_commands_device_status_created_idx ON public.feeder_test_commands USING btree (device_code, status, created_at);


--
-- Name: feeder_test_commands_one_active_per_device_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX feeder_test_commands_one_active_per_device_idx ON public.feeder_test_commands USING btree (device_code) WHERE (status = ANY (ARRAY['pending'::text, 'claimed'::text]));


--
-- Name: feeder_test_pending_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeder_test_pending_idx ON public.feeder_test_commands USING btree (device_code, created_at) WHERE (status = 'pending'::text);


--
-- Name: feeder_test_schedules_device_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeder_test_schedules_device_idx ON public.feeder_test_schedules USING btree (device_code, created_at DESC);


--
-- Name: feeding_logs_booking_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_logs_booking_id_idx ON public.feeding_logs USING btree (booking_id);


--
-- Name: feeding_logs_completed_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_logs_completed_at_idx ON public.feeding_logs USING btree (completed_at);


--
-- Name: feeding_logs_result_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_logs_result_idx ON public.feeding_logs USING btree (result);


--
-- Name: feeding_logs_schedule_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_logs_schedule_id_idx ON public.feeding_logs USING btree (schedule_id);


--
-- Name: feeding_schedules_booking_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_schedules_booking_id_idx ON public.feeding_schedules USING btree (booking_id);


--
-- Name: feeding_schedules_scheduled_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_schedules_scheduled_at_idx ON public.feeding_schedules USING btree (scheduled_at);


--
-- Name: feeding_schedules_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX feeding_schedules_status_idx ON public.feeding_schedules USING btree (status);


--
-- Name: messages_conversation_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_conversation_created_at_idx ON public.messages USING btree (conversation_id, created_at);


--
-- Name: messages_conversation_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_conversation_id_idx ON public.messages USING btree (conversation_id);


--
-- Name: messages_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX messages_created_at_idx ON public.messages USING btree (created_at);


--
-- Name: owners_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX owners_email_idx ON public.owners USING btree (email);


--
-- Name: owners_email_normalized_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX owners_email_normalized_unique ON public.owners USING btree (lower(TRIM(BOTH FROM email))) WHERE ((email IS NOT NULL) AND (TRIM(BOTH FROM email) <> ''::text));


--
-- Name: owners_phone_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX owners_phone_idx ON public.owners USING btree (phone);


--
-- Name: pet_owner_links_one_primary_owner_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pet_owner_links_one_primary_owner_idx ON public.pet_owner_links USING btree (pet_id) WHERE (is_primary = true);


--
-- Name: pet_owner_links_owner_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pet_owner_links_owner_id_idx ON public.pet_owner_links USING btree (owner_id);


--
-- Name: pet_owner_links_pet_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pet_owner_links_pet_id_idx ON public.pet_owner_links USING btree (pet_id);


--
-- Name: public_inquiries_updated_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX public_inquiries_updated_at_idx ON public.public_inquiries USING btree (updated_at DESC);


--
-- Name: public_reviews_status_created_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX public_reviews_status_created_idx ON public.public_reviews USING btree (status, created_at DESC);


--
-- Name: reservation_requests_one_boarding_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX reservation_requests_one_boarding_idx ON public.reservation_requests USING btree (boarding_booking_id) WHERE (boarding_booking_id IS NOT NULL);


--
-- Name: room_devices_device_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX room_devices_device_id_idx ON public.room_devices USING btree (device_id);


--
-- Name: room_devices_one_current_room_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX room_devices_one_current_room_idx ON public.room_devices USING btree (device_id) WHERE (unassigned_at IS NULL);


--
-- Name: room_devices_room_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX room_devices_room_id_idx ON public.room_devices USING btree (room_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_05_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_05_inserted_at_topic_idx ON realtime.messages_2026_11_05 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_06_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_06_inserted_at_topic_idx ON realtime.messages_2026_11_06 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_07_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_07_inserted_at_topic_idx ON realtime.messages_2026_11_07 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_08_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_08_inserted_at_topic_idx ON realtime.messages_2026_11_08 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_09_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_09_inserted_at_topic_idx ON realtime.messages_2026_11_09 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_10_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_10_inserted_at_topic_idx ON realtime.messages_2026_11_10 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: messages_2026_11_11_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_2026_11_11_inserted_at_topic_idx ON realtime.messages_2026_11_11 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_selec; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_selec ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter, COALESCE(selected_columns, '{}'::text[]));


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucket_lifecycle_states_due_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX bucket_lifecycle_states_due_idx ON storage.bucket_lifecycle_states USING btree (next_run_at, bucket_id) WHERE (next_run_at IS NOT NULL);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: idx_objects_current_version; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_objects_current_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (archived_at IS NULL);


--
-- Name: idx_objects_delete_markers; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_delete_markers ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE is_delete_marker;


--
-- Name: idx_objects_null_version; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX idx_objects_null_version ON storage.objects USING btree (bucket_id, name COLLATE "C") WHERE (NOT is_versioned);


--
-- Name: lifecycle_abandoned_artifacts_attempted_at_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX lifecycle_abandoned_artifacts_attempted_at_idx ON storage.lifecycle_abandoned_artifacts USING btree (attempted_at);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: objects_archived_due_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX objects_archived_due_idx ON storage.objects USING btree (bucket_id, archived_at, name COLLATE "C") INCLUDE (id, version, is_delete_marker) WHERE (archived_at IS NOT NULL);


--
-- Name: objects_archived_order_uq; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_archived_order_uq ON storage.objects USING btree (bucket_id, name COLLATE "C", archived_at) WHERE (archived_at IS NOT NULL);


--
-- Name: objects_bucket_id_name_version_key; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX objects_bucket_id_name_version_key ON storage.objects USING btree (bucket_id, name COLLATE "C", version) NULLS NOT DISTINCT;


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2026_11_05_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_05_inserted_at_topic_idx;


--
-- Name: messages_2026_11_05_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_05_pkey;


--
-- Name: messages_2026_11_06_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_06_inserted_at_topic_idx;


--
-- Name: messages_2026_11_06_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_06_pkey;


--
-- Name: messages_2026_11_07_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_07_inserted_at_topic_idx;


--
-- Name: messages_2026_11_07_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_07_pkey;


--
-- Name: messages_2026_11_08_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_08_inserted_at_topic_idx;


--
-- Name: messages_2026_11_08_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_08_pkey;


--
-- Name: messages_2026_11_09_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_09_inserted_at_topic_idx;


--
-- Name: messages_2026_11_09_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_09_pkey;


--
-- Name: messages_2026_11_10_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_10_inserted_at_topic_idx;


--
-- Name: messages_2026_11_10_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_10_pkey;


--
-- Name: messages_2026_11_11_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_11_11_inserted_at_topic_idx;


--
-- Name: messages_2026_11_11_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_11_11_pkey;


--
-- Name: reservation_requests carefur-reservation-request-sms; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "carefur-reservation-request-sms" AFTER INSERT ON public.reservation_requests FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/reservation-request-sms', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlzd3N0aXNpZWNkdGFkdHducGtqIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4NDk5NjY3OSwiZXhwIjoyMTAwNTcyNjc5fQ.0H6kBDB_Uh50B17lrK8vKeKHDwaOlqSgaQZopM57z-c","x-carefur-webhook-secret":"STTQXsqPIwDn7l1PzM/w6W5SafyVh/rkZ9ycqWrtEQ4="}', '{}', '5000');


--
-- Name: feeder_test_commands carefur_auto_feed_result_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_auto_feed_result_trigger AFTER UPDATE OF status ON public.feeder_test_commands FOR EACH ROW EXECUTE FUNCTION public.carefur_sync_auto_feeding_result();


--
-- Name: feeding_schedules carefur_auto_status_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_auto_status_guard BEFORE UPDATE OF status ON public.feeding_schedules FOR EACH ROW EXECUTE FUNCTION public.carefur_reject_manual_auto_completion();


--
-- Name: feeder_test_commands carefur_block_cloud_when_rtc_active_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_block_cloud_when_rtc_active_trigger BEFORE INSERT OR UPDATE OF status, device_code ON public.feeder_test_commands FOR EACH ROW EXECUTE FUNCTION public.carefur_block_cloud_when_rtc_active();


--
-- Name: boarding_extension_requests carefur_capture_extension_original_checkout_trg; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_capture_extension_original_checkout_trg BEFORE INSERT ON public.boarding_extension_requests FOR EACH ROW EXECUTE FUNCTION public.carefur_capture_extension_original_checkout();


--
-- Name: room_devices carefur_guard_rtc_room_move_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_guard_rtc_room_move_trigger BEFORE INSERT OR DELETE OR UPDATE ON public.room_devices FOR EACH ROW EXECUTE FUNCTION public.carefur_guard_rtc_room_move();


--
-- Name: booking_access carefur_limit_shared_invitations_insert; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_limit_shared_invitations_insert BEFORE INSERT ON public.booking_access FOR EACH ROW EXECUTE FUNCTION public.carefur_limit_shared_invitations();


--
-- Name: feeder_test_commands carefur_lock_feeder_command_movement_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_lock_feeder_command_movement_trigger BEFORE INSERT OR UPDATE OF status, device_code ON public.feeder_test_commands FOR EACH ROW EXECUTE FUNCTION public.carefur_lock_feeder_command_movement();


--
-- Name: messages carefur_mobile_message_push; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_mobile_message_push AFTER INSERT ON public.messages FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/send-message-push', 'POST', '{"Content-type":"application/json","x-carefur-webhook-secret":"00478c78132636cb4826661d69b5ec79c392082ab672f2b22542f2c2bb1df988"}', '{}', '5000');


--
-- Name: reservation_requests carefur_paid_confirmation_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_paid_confirmation_guard BEFORE INSERT OR UPDATE OF status, boarding_booking_id ON public.reservation_requests FOR EACH ROW EXECUTE FUNCTION public.carefur_prevent_unlinked_confirmation();


--
-- Name: reservation_requests carefur_reservation_overlap_guard; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_reservation_overlap_guard BEFORE INSERT ON public.reservation_requests FOR EACH ROW EXECUTE FUNCTION public.carefur_reject_overlapping_reservation();


--
-- Name: smart_units carefur_validate_smart_unit_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER carefur_validate_smart_unit_trigger BEFORE INSERT OR UPDATE OF feeder_device_id, camera_device_id ON public.smart_units FOR EACH ROW EXECUTE FUNCTION public.carefur_validate_smart_unit();


--
-- Name: messages messages_update_conversation_time; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER messages_update_conversation_time AFTER INSERT ON public.messages FOR EACH ROW EXECUTE FUNCTION public.update_conversation_updated_at();


--
-- Name: bookings set_bookings_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_bookings_updated_at BEFORE UPDATE ON public.bookings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: devices set_devices_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_devices_updated_at BEFORE UPDATE ON public.devices FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: feeding_schedules set_feeding_schedules_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_feeding_schedules_updated_at BEFORE UPDATE ON public.feeding_schedules FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: pet_vaccinations set_pet_vaccinations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_pet_vaccinations_updated_at BEFORE UPDATE ON public.pet_vaccinations FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: pets set_pets_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_pets_updated_at BEFORE UPDATE ON public.pets FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: public_inquiries set_public_inquiries_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_inquiries_updated_at BEFORE UPDATE ON public.public_inquiries FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: reservation_requests set_reservation_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_reservation_requests_updated_at BEFORE UPDATE ON public.reservation_requests FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: rooms set_rooms_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_rooms_updated_at BEFORE UPDATE ON public.rooms FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets enforce_versioning_status_transition; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_versioning_status_transition BEFORE UPDATE OF versioning_status ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_versioning_status_transition();


--
-- Name: buckets protect_active_lifecycle_states; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_active_lifecycle_states BEFORE DELETE ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_active_lifecycle_states();


--
-- Name: buckets protect_bucket_control_insert; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_bucket_control_insert BEFORE INSERT ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns('service_role');


--
-- Name: buckets protect_bucket_control_update; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_bucket_control_update BEFORE UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.protect_bucket_control_columns();


--
-- Name: buckets protect_bucket_control_update_role; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_bucket_control_update_role AFTER UPDATE OF lifecycle_configuration, lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_lifecycle_service_role('service_role');


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: buckets wake_lifecycle_on_policy_write; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER wake_lifecycle_on_policy_write AFTER INSERT OR UPDATE OF lifecycle_configuration_generation ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.wake_lifecycle_state();


--
-- Name: buckets wake_lifecycle_on_versioning_enable; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER wake_lifecycle_on_versioning_enable AFTER UPDATE OF versioning_status ON storage.buckets FOR EACH ROW WHEN ((new.lifecycle_configuration IS NOT NULL)) EXECUTE FUNCTION storage.wake_lifecycle_state();


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
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_mfa_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_mfa_factor_id_fkey FOREIGN KEY (mfa_factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_code_sets mfa_recovery_code_sets_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_code_sets
    ADD CONSTRAINT mfa_recovery_code_sets_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_recovery_codes mfa_recovery_codes_mfa_recovery_code_set_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_recovery_codes
    ADD CONSTRAINT mfa_recovery_codes_mfa_recovery_code_set_id_fkey FOREIGN KEY (mfa_recovery_code_set_id) REFERENCES auth.mfa_recovery_code_sets(id) ON DELETE CASCADE;


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
-- Name: scim_tokens scim_tokens_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_tokens
    ADD CONSTRAINT scim_tokens_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_users scim_users_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: scim_users scim_users_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.scim_users
    ADD CONSTRAINT scim_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


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
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: activity_logs activity_logs_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: alerts alerts_acknowledged_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_acknowledged_by_fkey FOREIGN KEY (acknowledged_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: alerts alerts_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: alerts alerts_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id) ON DELETE SET NULL;


--
-- Name: boarding_extension_requests boarding_extension_requests_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_extension_requests
    ADD CONSTRAINT boarding_extension_requests_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: boarding_extension_requests boarding_extension_requests_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_extension_requests
    ADD CONSTRAINT boarding_extension_requests_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(id);


--
-- Name: boarding_extension_requests boarding_extension_requests_payment_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_extension_requests
    ADD CONSTRAINT boarding_extension_requests_payment_verified_by_fkey FOREIGN KEY (payment_verified_by) REFERENCES public.users(id);


--
-- Name: boarding_extension_requests boarding_extension_requests_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_extension_requests
    ADD CONSTRAINT boarding_extension_requests_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: boarding_reviews boarding_reviews_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_reviews
    ADD CONSTRAINT boarding_reviews_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: boarding_reviews boarding_reviews_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boarding_reviews
    ADD CONSTRAINT boarding_reviews_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(id);


--
-- Name: booking_access booking_access_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_access
    ADD CONSTRAINT booking_access_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: booking_access booking_access_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_access
    ADD CONSTRAINT booking_access_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: booking_access booking_access_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_access
    ADD CONSTRAINT booking_access_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: booking_access booking_access_redeemed_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_access
    ADD CONSTRAINT booking_access_redeemed_by_user_id_fkey FOREIGN KEY (redeemed_by_user_id) REFERENCES auth.users(id);


--
-- Name: bookings bookings_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: bookings bookings_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(id) ON DELETE RESTRICT;


--
-- Name: bookings bookings_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE RESTRICT;


--
-- Name: carefur_feeding_dispatches carefur_feeding_dispatches_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carefur_feeding_dispatches
    ADD CONSTRAINT carefur_feeding_dispatches_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.feeding_schedules(id) ON DELETE CASCADE;


--
-- Name: carefur_feeding_push_tokens carefur_feeding_push_tokens_auth_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carefur_feeding_push_tokens
    ADD CONSTRAINT carefur_feeding_push_tokens_auth_user_id_fkey FOREIGN KEY (auth_user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: conversations conversations_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: conversations conversations_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: feeder_eating_sessions feeder_eating_sessions_device_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_eating_sessions
    ADD CONSTRAINT feeder_eating_sessions_device_code_fkey FOREIGN KEY (device_code) REFERENCES public.devices(device_code);


--
-- Name: feeder_food_events feeder_food_events_device_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_food_events
    ADD CONSTRAINT feeder_food_events_device_code_fkey FOREIGN KEY (device_code) REFERENCES public.devices(device_code) ON DELETE CASCADE;


--
-- Name: feeder_food_state feeder_food_state_device_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_food_state
    ADD CONSTRAINT feeder_food_state_device_code_fkey FOREIGN KEY (device_code) REFERENCES public.devices(device_code) ON DELETE CASCADE;


--
-- Name: feeder_rtc_configs feeder_rtc_configs_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_rtc_configs
    ADD CONSTRAINT feeder_rtc_configs_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: feeder_test_commands feeder_test_commands_device_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_test_commands
    ADD CONSTRAINT feeder_test_commands_device_fk FOREIGN KEY (device_code) REFERENCES public.devices(device_code) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: feeder_test_commands feeder_test_commands_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeder_test_commands
    ADD CONSTRAINT feeder_test_commands_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES auth.users(id);


--
-- Name: feeding_logs feeding_logs_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_logs
    ADD CONSTRAINT feeding_logs_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: feeding_logs feeding_logs_feeder_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_logs
    ADD CONSTRAINT feeding_logs_feeder_device_id_fkey FOREIGN KEY (feeder_device_id) REFERENCES public.devices(id) ON DELETE SET NULL;


--
-- Name: feeding_logs feeding_logs_performed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_logs
    ADD CONSTRAINT feeding_logs_performed_by_fkey FOREIGN KEY (performed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: feeding_logs feeding_logs_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_logs
    ADD CONSTRAINT feeding_logs_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.feeding_schedules(id) ON DELETE SET NULL;


--
-- Name: feeding_schedules feeding_schedules_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_schedules
    ADD CONSTRAINT feeding_schedules_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id) ON DELETE CASCADE;


--
-- Name: feeding_schedules feeding_schedules_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feeding_schedules
    ADD CONSTRAINT feeding_schedules_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: pet_owner_links pet_owner_links_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_owner_links
    ADD CONSTRAINT pet_owner_links_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.owners(id) ON DELETE CASCADE;


--
-- Name: pet_owner_links pet_owner_links_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_owner_links
    ADD CONSTRAINT pet_owner_links_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(id) ON DELETE CASCADE;


--
-- Name: pet_vaccinations pet_vaccinations_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_vaccinations
    ADD CONSTRAINT pet_vaccinations_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(id) ON DELETE CASCADE;


--
-- Name: pets pets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: public_inquiries public_inquiries_client_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_inquiries
    ADD CONSTRAINT public_inquiries_client_user_id_fkey FOREIGN KEY (client_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: public_inquiry_messages public_inquiry_messages_inquiry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_inquiry_messages
    ADD CONSTRAINT public_inquiry_messages_inquiry_id_fkey FOREIGN KEY (inquiry_id) REFERENCES public.public_inquiries(id) ON DELETE CASCADE;


--
-- Name: public_inquiry_messages public_inquiry_messages_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_inquiry_messages
    ADD CONSTRAINT public_inquiry_messages_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: public_inquiry_messages public_inquiry_messages_staff_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_inquiry_messages
    ADD CONSTRAINT public_inquiry_messages_staff_user_id_fkey FOREIGN KEY (staff_user_id) REFERENCES public.users(id);


--
-- Name: public_reviews public_reviews_reviewer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.public_reviews
    ADD CONSTRAINT public_reviews_reviewer_user_id_fkey FOREIGN KEY (reviewer_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reservation_requests reservation_requests_boarding_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_requests
    ADD CONSTRAINT reservation_requests_boarding_booking_id_fkey FOREIGN KEY (boarding_booking_id) REFERENCES public.bookings(id) ON DELETE RESTRICT;


--
-- Name: reservation_requests reservation_requests_client_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_requests
    ADD CONSTRAINT reservation_requests_client_user_id_fkey FOREIGN KEY (client_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reservation_requests reservation_requests_paid_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_requests
    ADD CONSTRAINT reservation_requests_paid_by_fkey FOREIGN KEY (paid_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reservation_requests reservation_requests_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_requests
    ADD CONSTRAINT reservation_requests_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE SET NULL;


--
-- Name: reservation_sms_notifications reservation_sms_notifications_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservation_sms_notifications
    ADD CONSTRAINT reservation_sms_notifications_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.reservation_requests(id) ON DELETE CASCADE;


--
-- Name: room_devices room_devices_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_devices
    ADD CONSTRAINT room_devices_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: room_devices room_devices_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_devices
    ADD CONSTRAINT room_devices_device_id_fkey FOREIGN KEY (device_id) REFERENCES public.devices(id) ON DELETE CASCADE;


--
-- Name: room_devices room_devices_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room_devices
    ADD CONSTRAINT room_devices_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: smart_units smart_units_camera_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smart_units
    ADD CONSTRAINT smart_units_camera_device_id_fkey FOREIGN KEY (camera_device_id) REFERENCES public.devices(id) ON DELETE RESTRICT;


--
-- Name: smart_units smart_units_feeder_device_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.smart_units
    ADD CONSTRAINT smart_units_feeder_device_id_fkey FOREIGN KEY (feeder_device_id) REFERENCES public.devices(id) ON DELETE RESTRICT;


--
-- Name: bucket_lifecycle_states bucket_lifecycle_states_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.bucket_lifecycle_states
    ADD CONSTRAINT bucket_lifecycle_states_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


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
-- Name: users Admins can delete user profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can delete user profiles" ON public.users FOR DELETE TO authenticated USING (( SELECT public.is_admin() AS is_admin));


--
-- Name: users Admins can insert user profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can insert user profiles" ON public.users FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_admin() AS is_admin));


--
-- Name: users Admins can update user profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update user profiles" ON public.users FOR UPDATE TO authenticated USING (( SELECT public.is_admin() AS is_admin)) WITH CHECK (( SELECT public.is_admin() AS is_admin));


--
-- Name: public_reviews Authenticated users can submit reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated users can submit reviews" ON public.public_reviews FOR INSERT TO authenticated WITH CHECK ((reviewer_user_id = auth.uid()));


--
-- Name: public_inquiries Clients can create own inquiries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can create own inquiries" ON public.public_inquiries FOR INSERT TO authenticated WITH CHECK ((client_user_id = auth.uid()));


--
-- Name: reservation_requests Clients can create reservation requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can create reservation requests" ON public.reservation_requests FOR INSERT TO authenticated WITH CHECK ((client_user_id = auth.uid()));


--
-- Name: public_inquiries Clients can read own inquiries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can read own inquiries" ON public.public_inquiries FOR SELECT TO authenticated USING ((client_user_id = auth.uid()));


--
-- Name: public_inquiry_messages Clients can read own inquiry messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can read own inquiry messages" ON public.public_inquiry_messages FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.public_inquiries i
  WHERE ((i.id = public_inquiry_messages.inquiry_id) AND (i.client_user_id = auth.uid())))));


--
-- Name: reservation_requests Clients can read own reservation requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can read own reservation requests" ON public.reservation_requests FOR SELECT TO authenticated USING ((client_user_id = auth.uid()));


--
-- Name: public_inquiry_messages Clients can send inquiry messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Clients can send inquiry messages" ON public.public_inquiry_messages FOR INSERT TO authenticated WITH CHECK (((sender_user_id = auth.uid()) AND (sender_type = 'client'::text) AND (EXISTS ( SELECT 1
   FROM public.public_inquiries i
  WHERE ((i.id = public_inquiry_messages.inquiry_id) AND (i.client_user_id = auth.uid()))))));


--
-- Name: conversations Owners can create conversations for accessible bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can create conversations for accessible bookings" ON public.conversations FOR INSERT TO authenticated WITH CHECK ((public.owner_has_booking_access(booking_id) AND (owner_id = auth.uid())));


--
-- Name: devices Owners can read assigned booking devices; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read assigned booking devices" ON public.devices FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (public.room_devices rd
     JOIN public.bookings b ON ((b.room_id = rd.room_id)))
  WHERE ((rd.device_id = devices.id) AND (rd.unassigned_at IS NULL) AND ( SELECT public.owner_has_booking_access(b.id) AS owner_has_booking_access)))));


--
-- Name: alerts Owners can read linked booking alerts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked booking alerts" ON public.alerts FOR SELECT TO authenticated USING (((booking_id IS NOT NULL) AND ( SELECT public.owner_has_booking_access(alerts.booking_id) AS owner_has_booking_access)));


--
-- Name: bookings Owners can read linked bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked bookings" ON public.bookings FOR SELECT TO authenticated USING (( SELECT public.owner_has_booking_access(bookings.id) AS owner_has_booking_access));


--
-- Name: feeding_logs Owners can read linked feeding logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked feeding logs" ON public.feeding_logs FOR SELECT TO authenticated USING (( SELECT public.owner_has_booking_access(feeding_logs.booking_id) AS owner_has_booking_access));


--
-- Name: feeding_schedules Owners can read linked feeding schedules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked feeding schedules" ON public.feeding_schedules FOR SELECT TO authenticated USING (( SELECT public.owner_has_booking_access(feeding_schedules.booking_id) AS owner_has_booking_access));


--
-- Name: pet_vaccinations Owners can read linked pet vaccinations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked pet vaccinations" ON public.pet_vaccinations FOR SELECT TO authenticated USING (public.owner_has_pet_access(pet_id));


--
-- Name: pets Owners can read linked pets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked pets" ON public.pets FOR SELECT TO authenticated USING (( SELECT public.owner_has_pet_access(pets.id) AS owner_has_pet_access));


--
-- Name: room_devices Owners can read linked room devices; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read linked room devices" ON public.room_devices FOR SELECT TO authenticated USING (((unassigned_at IS NULL) AND (EXISTS ( SELECT 1
   FROM public.bookings b
  WHERE ((b.room_id = room_devices.room_id) AND ( SELECT public.owner_has_booking_access(b.id) AS owner_has_booking_access))))));


--
-- Name: rooms Owners can read rooms for linked bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read rooms for linked bookings" ON public.rooms FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.bookings b
  WHERE ((b.room_id = rooms.id) AND ( SELECT public.owner_has_booking_access(b.id) AS owner_has_booking_access)))));


--
-- Name: pet_owner_links Owners can read their own pet links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read their own pet links" ON public.pet_owner_links FOR SELECT TO authenticated USING ((owner_id = ( SELECT auth.uid() AS uid)));


--
-- Name: booking_access Owners can read their redeemed booking access; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can read their redeemed booking access" ON public.booking_access FOR SELECT TO authenticated USING (((owner_id = ( SELECT auth.uid() AS uid)) AND (redeemed_at IS NOT NULL) AND (revoked_at IS NULL)));


--
-- Name: messages Owners can send messages for accessible conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can send messages for accessible conversations" ON public.messages FOR INSERT TO authenticated WITH CHECK (((sender_user_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM public.conversations c
  WHERE ((c.id = messages.conversation_id) AND public.owner_has_booking_access(c.booking_id))))));


--
-- Name: conversations Owners can view conversations for accessible bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can view conversations for accessible bookings" ON public.conversations FOR SELECT TO authenticated USING (public.owner_has_booking_access(booking_id));


--
-- Name: messages Owners can view messages for accessible conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Owners can view messages for accessible conversations" ON public.messages FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.conversations c
  WHERE ((c.id = messages.conversation_id) AND public.owner_has_booking_access(c.booking_id)))));


--
-- Name: public_reviews Public can read approved reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public can read approved reviews" ON public.public_reviews FOR SELECT TO authenticated, anon USING ((status = 'approved'::text));


--
-- Name: activity_logs Staff can create activity logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create activity logs" ON public.activity_logs FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: alerts Staff can create alerts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create alerts" ON public.alerts FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: booking_access Staff can create booking access records; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create booking access records" ON public.booking_access FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: bookings Staff can create bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create bookings" ON public.bookings FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: devices Staff can create devices; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create devices" ON public.devices FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_logs Staff can create feeding logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create feeding logs" ON public.feeding_logs FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_schedules Staff can create feeding schedules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create feeding schedules" ON public.feeding_schedules FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: owners Staff can create owners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create owners" ON public.owners FOR INSERT TO authenticated WITH CHECK (public.is_staff_member());


--
-- Name: pet_owner_links Staff can create pet owner links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create pet owner links" ON public.pet_owner_links FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: pets Staff can create pets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create pets" ON public.pets FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: room_devices Staff can create room device assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create room device assignments" ON public.room_devices FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: rooms Staff can create rooms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can create rooms" ON public.rooms FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: alerts Staff can delete alerts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete alerts" ON public.alerts FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: booking_access Staff can delete booking access records; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete booking access records" ON public.booking_access FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: bookings Staff can delete bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete bookings" ON public.bookings FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: devices Staff can delete devices; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete devices" ON public.devices FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_logs Staff can delete feeding logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete feeding logs" ON public.feeding_logs FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_schedules Staff can delete feeding schedules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete feeding schedules" ON public.feeding_schedules FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: pet_owner_links Staff can delete pet owner links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete pet owner links" ON public.pet_owner_links FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: pet_vaccinations Staff can delete pet vaccinations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete pet vaccinations" ON public.pet_vaccinations FOR DELETE TO authenticated USING ((public.is_staff_member() OR public.is_admin()));


--
-- Name: pets Staff can delete pets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete pets" ON public.pets FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: room_devices Staff can delete room device assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete room device assignments" ON public.room_devices FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: rooms Staff can delete rooms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can delete rooms" ON public.rooms FOR DELETE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: pet_vaccinations Staff can insert pet vaccinations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can insert pet vaccinations" ON public.pet_vaccinations FOR INSERT TO authenticated WITH CHECK ((public.is_staff_member() OR public.is_admin()));


--
-- Name: public_inquiry_messages Staff can manage inquiry messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can manage inquiry messages" ON public.public_inquiry_messages TO authenticated USING ((public.is_staff_member() OR public.is_admin())) WITH CHECK ((public.is_staff_member() OR public.is_admin()));


--
-- Name: public_inquiries Staff can manage public inquiries; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can manage public inquiries" ON public.public_inquiries TO authenticated USING ((public.is_staff_member() OR public.is_admin())) WITH CHECK ((public.is_staff_member() OR public.is_admin()));


--
-- Name: reservation_requests Staff can manage reservation requests; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can manage reservation requests" ON public.reservation_requests TO authenticated USING ((public.is_staff_member() OR public.is_admin())) WITH CHECK ((public.is_staff_member() OR public.is_admin()));


--
-- Name: public_reviews Staff can manage reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can manage reviews" ON public.public_reviews TO authenticated USING ((public.is_staff_member() OR public.is_admin())) WITH CHECK ((public.is_staff_member() OR public.is_admin()));


--
-- Name: activity_logs Staff can read activity logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read activity logs" ON public.activity_logs FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: alerts Staff can read alerts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read alerts" ON public.alerts FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: users Staff can read all user profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read all user profiles" ON public.users FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: booking_access Staff can read booking access records; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read booking access records" ON public.booking_access FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: bookings Staff can read bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read bookings" ON public.bookings FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: devices Staff can read devices; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read devices" ON public.devices FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_logs Staff can read feeding logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read feeding logs" ON public.feeding_logs FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_schedules Staff can read feeding schedules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read feeding schedules" ON public.feeding_schedules FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: owners Staff can read owners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read owners" ON public.owners FOR SELECT TO authenticated USING (public.is_staff_member());


--
-- Name: pet_owner_links Staff can read pet owner links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read pet owner links" ON public.pet_owner_links FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: pet_vaccinations Staff can read pet vaccinations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read pet vaccinations" ON public.pet_vaccinations FOR SELECT TO authenticated USING ((public.is_staff_member() OR public.is_admin()));


--
-- Name: pets Staff can read pets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read pets" ON public.pets FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: room_devices Staff can read room device assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read room device assignments" ON public.room_devices FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: rooms Staff can read rooms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can read rooms" ON public.rooms FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: alerts Staff can update alerts; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update alerts" ON public.alerts FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: booking_access Staff can update booking access records; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update booking access records" ON public.booking_access FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: bookings Staff can update bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update bookings" ON public.bookings FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: devices Staff can update devices; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update devices" ON public.devices FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_logs Staff can update feeding logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update feeding logs" ON public.feeding_logs FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeding_schedules Staff can update feeding schedules; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update feeding schedules" ON public.feeding_schedules FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: owners Staff can update owners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update owners" ON public.owners FOR UPDATE TO authenticated USING (public.is_staff_member()) WITH CHECK (public.is_staff_member());


--
-- Name: pet_owner_links Staff can update pet owner links; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update pet owner links" ON public.pet_owner_links FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: pet_vaccinations Staff can update pet vaccinations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update pet vaccinations" ON public.pet_vaccinations FOR UPDATE TO authenticated USING ((public.is_staff_member() OR public.is_admin())) WITH CHECK ((public.is_staff_member() OR public.is_admin()));


--
-- Name: pets Staff can update pets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update pets" ON public.pets FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: room_devices Staff can update room device assignments; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update room device assignments" ON public.room_devices FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: rooms Staff can update rooms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff can update rooms" ON public.rooms FOR UPDATE TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member)) WITH CHECK (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeder_food_events Staff view food events; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff view food events" ON public.feeder_food_events FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: feeder_food_state Staff view food states; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff view food states" ON public.feeder_food_state FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: owners Users can insert their own owner profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own owner profile" ON public.owners FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: users Users can read their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can read their own profile" ON public.users FOR SELECT TO authenticated USING ((id = ( SELECT auth.uid() AS uid)));


--
-- Name: owners Users can update their own owner profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own owner profile" ON public.owners FOR UPDATE TO authenticated USING ((auth.uid() = id)) WITH CHECK ((auth.uid() = id));


--
-- Name: owners Users can view their own owner profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own owner profile" ON public.owners FOR SELECT TO authenticated USING ((auth.uid() = id));


--
-- Name: users Users can view their own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own profile" ON public.users FOR SELECT TO authenticated USING ((( SELECT auth.uid() AS uid) = id));


--
-- Name: activity_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: alerts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.alerts ENABLE ROW LEVEL SECURITY;

--
-- Name: boarding_extension_requests; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.boarding_extension_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: boarding_reviews; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.boarding_reviews ENABLE ROW LEVEL SECURITY;

--
-- Name: booking_access; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.booking_access ENABLE ROW LEVEL SECURITY;

--
-- Name: booking_code_redemption_attempts; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.booking_code_redemption_attempts ENABLE ROW LEVEL SECURITY;

--
-- Name: bookings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

--
-- Name: camera_wifi_switch_requests; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.camera_wifi_switch_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: boarding_extension_requests carefur_extension_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_extension_read ON public.boarding_extension_requests FOR SELECT TO authenticated USING ((public.carefur_boarding_staff() OR ((owner_id = ( SELECT auth.uid() AS uid)) AND public.carefur_owns_booking(booking_id))));


--
-- Name: boarding_extension_requests carefur_extension_request; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_extension_request ON public.boarding_extension_requests FOR INSERT TO authenticated WITH CHECK (((owner_id = ( SELECT auth.uid() AS uid)) AND public.carefur_owns_booking(booking_id) AND (status = 'pending'::text) AND (reviewed_by IS NULL) AND (reviewed_at IS NULL) AND (EXISTS ( SELECT 1
   FROM public.bookings b
  WHERE ((b.id = boarding_extension_requests.booking_id) AND (b.status = 'checked_in'::text) AND (b.expected_check_out_at > now()) AND (boarding_extension_requests.requested_checkout_at > b.expected_check_out_at) AND (boarding_extension_requests.requested_checkout_at <= (b.expected_check_out_at + '30 days'::interval)))))));


--
-- Name: carefur_feeding_dispatches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.carefur_feeding_dispatches ENABLE ROW LEVEL SECURITY;

--
-- Name: carefur_feeding_push_events; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.carefur_feeding_push_events ENABLE ROW LEVEL SECURITY;

--
-- Name: carefur_feeding_push_tokens; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.carefur_feeding_push_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: room_devices carefur_protect_paired_delete; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_protect_paired_delete ON public.room_devices AS RESTRICTIVE FOR DELETE TO authenticated USING ((NOT public.carefur_is_paired_device(device_id)));


--
-- Name: room_devices carefur_protect_paired_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_protect_paired_insert ON public.room_devices AS RESTRICTIVE FOR INSERT TO authenticated WITH CHECK ((NOT public.carefur_is_paired_device(device_id)));


--
-- Name: room_devices carefur_protect_paired_update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_protect_paired_update ON public.room_devices AS RESTRICTIVE FOR UPDATE TO authenticated USING ((NOT public.carefur_is_paired_device(device_id))) WITH CHECK ((NOT public.carefur_is_paired_device(device_id)));


--
-- Name: boarding_reviews carefur_review_insert; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_review_insert ON public.boarding_reviews FOR INSERT TO authenticated WITH CHECK (((owner_id = ( SELECT auth.uid() AS uid)) AND public.carefur_owns_booking(booking_id) AND (EXISTS ( SELECT 1
   FROM public.bookings b
  WHERE ((b.id = boarding_reviews.booking_id) AND (b.status = 'checked_out'::text) AND (b.actual_check_out_at IS NOT NULL))))));


--
-- Name: boarding_reviews carefur_review_read; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_review_read ON public.boarding_reviews FOR SELECT TO authenticated USING ((public.carefur_boarding_staff() OR ((owner_id = ( SELECT auth.uid() AS uid)) AND public.carefur_owns_booking(booking_id))));


--
-- Name: feeder_eating_sessions carefur_staff_read_eating_sessions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY carefur_staff_read_eating_sessions ON public.feeder_eating_sessions FOR SELECT TO authenticated USING (( SELECT public.is_staff_member() AS is_staff_member));


--
-- Name: conversations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;

--
-- Name: device_wifi_status; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.device_wifi_status ENABLE ROW LEVEL SECURITY;

--
-- Name: devices; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.devices ENABLE ROW LEVEL SECURITY;

--
-- Name: feeder_eating_sessions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_eating_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: feeder_food_events; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_food_events ENABLE ROW LEVEL SECURITY;

--
-- Name: feeder_food_state; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_food_state ENABLE ROW LEVEL SECURITY;

--
-- Name: feeder_rtc_configs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_rtc_configs ENABLE ROW LEVEL SECURITY;

--
-- Name: feeder_test_commands; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_test_commands ENABLE ROW LEVEL SECURITY;

--
-- Name: feeder_test_schedules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeder_test_schedules ENABLE ROW LEVEL SECURITY;

--
-- Name: feeding_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeding_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: feeding_schedules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feeding_schedules ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: owners; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.owners ENABLE ROW LEVEL SECURITY;

--
-- Name: pet_owner_links; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.pet_owner_links ENABLE ROW LEVEL SECURITY;

--
-- Name: pet_vaccinations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.pet_vaccinations ENABLE ROW LEVEL SECURITY;

--
-- Name: pets; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.pets ENABLE ROW LEVEL SECURITY;

--
-- Name: public_inquiries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.public_inquiries ENABLE ROW LEVEL SECURITY;

--
-- Name: public_inquiry_messages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.public_inquiry_messages ENABLE ROW LEVEL SECURITY;

--
-- Name: public_reviews; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.public_reviews ENABLE ROW LEVEL SECURITY;

--
-- Name: reservation_requests; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reservation_requests ENABLE ROW LEVEL SECURITY;

--
-- Name: reservation_sms_notifications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reservation_sms_notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: room_devices; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.room_devices ENABLE ROW LEVEL SECURITY;

--
-- Name: rooms; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;

--
-- Name: smart_units; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.smart_units ENABLE ROW LEVEL SECURITY;

--
-- Name: conversations staff can delete conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can delete conversations" ON public.conversations FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: messages staff can delete messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can delete messages" ON public.messages FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: conversations staff can insert conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can insert conversations" ON public.conversations FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: conversations staff can read conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can read conversations" ON public.conversations FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: messages staff can read messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can read messages" ON public.messages FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: messages staff can send messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can send messages" ON public.messages FOR INSERT TO authenticated WITH CHECK (((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))) AND (sender_type = 'staff'::text) AND (sender_user_id = auth.uid())));


--
-- Name: conversations staff can update conversations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can update conversations" ON public.conversations FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: messages staff can update messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "staff can update messages" ON public.messages FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.users u
  WHERE ((u.id = auth.uid()) AND (u.role = ANY (ARRAY['admin'::public.user_role, 'staff'::public.user_role]))))));


--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: bucket_lifecycle_states; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.bucket_lifecycle_states ENABLE ROW LEVEL SECURITY;

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
-- Name: objects carefur owners read chat attachments; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "carefur owners read chat attachments" ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'chat-attachments'::text));


--
-- Name: objects carefur owners upload chat attachments; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "carefur owners upload chat attachments" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'chat-attachments'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- Name: lifecycle_abandoned_artifacts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.lifecycle_abandoned_artifacts ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

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
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- Name: supabase_realtime conversations; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.conversations;


--
-- Name: supabase_realtime feeder_food_events; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.feeder_food_events;


--
-- Name: supabase_realtime feeder_food_state; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.feeder_food_state;


--
-- Name: supabase_realtime messages; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.messages;


--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


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
-- Name: SCHEMA cron; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA cron TO postgres WITH GRANT OPTION;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO postgres;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;
GRANT USAGE ON SCHEMA realtime TO authenticated;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


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
-- Name: FUNCTION alter_job(job_id bigint, schedule text, command text, database text, username text, active boolean); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.alter_job(job_id bigint, schedule text, command text, database text, username text, active boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION job_cache_invalidate(); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.job_cache_invalidate() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule(schedule text, command text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule(schedule text, command text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule(job_name text, schedule text, command text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule(job_name text, schedule text, command text) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION schedule_in_database(job_name text, schedule text, command text, database text, username text, active boolean); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.schedule_in_database(job_name text, schedule text, command text, database text, username text, active boolean) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION unschedule(job_id bigint); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.unschedule(job_id bigint) TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION unschedule(job_name text); Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT ALL ON FUNCTION cron.unschedule(job_name text) TO postgres WITH GRANT OPTION;


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
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION carefur_block_cloud_when_rtc_active(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_block_cloud_when_rtc_active() TO anon;
GRANT ALL ON FUNCTION public.carefur_block_cloud_when_rtc_active() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_block_cloud_when_rtc_active() TO service_role;


--
-- Name: FUNCTION carefur_boarding_staff(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_boarding_staff() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_boarding_staff() TO anon;
GRANT ALL ON FUNCTION public.carefur_boarding_staff() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_boarding_staff() TO service_role;


--
-- Name: FUNCTION carefur_can_view_boarding_camera(p_booking_id uuid, p_camera_device_code text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_can_view_boarding_camera(p_booking_id uuid, p_camera_device_code text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_can_view_boarding_camera(p_booking_id uuid, p_camera_device_code text) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_can_view_boarding_camera(p_booking_id uuid, p_camera_device_code text) TO service_role;


--
-- Name: FUNCTION carefur_capture_extension_original_checkout(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_capture_extension_original_checkout() TO anon;
GRANT ALL ON FUNCTION public.carefur_capture_extension_original_checkout() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_capture_extension_original_checkout() TO service_role;


--
-- Name: FUNCTION carefur_claim_paid_reservation_sms(p_request_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_claim_paid_reservation_sms(p_request_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_claim_paid_reservation_sms(p_request_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_claim_paid_reservation_sms(p_request_id uuid) TO service_role;


--
-- Name: FUNCTION carefur_convert_paid_reservation(p_request_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_convert_paid_reservation(p_request_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_convert_paid_reservation(p_request_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_convert_paid_reservation(p_request_id uuid) TO service_role;


--
-- Name: FUNCTION carefur_dispatch_confirmed_feeding(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_dispatch_confirmed_feeding() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_dispatch_confirmed_feeding() TO service_role;


--
-- Name: FUNCTION carefur_dispatch_feeder_test_schedules(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_dispatch_feeder_test_schedules() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_dispatch_feeder_test_schedules() TO service_role;


--
-- Name: FUNCTION carefur_finish_paid_reservation_sms(p_request_id uuid, p_status text, p_error text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_finish_paid_reservation_sms(p_request_id uuid, p_status text, p_error text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_finish_paid_reservation_sms(p_request_id uuid, p_status text, p_error text) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_finish_paid_reservation_sms(p_request_id uuid, p_status text, p_error text) TO service_role;


--
-- Name: FUNCTION carefur_guard_rtc_room_move(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_guard_rtc_room_move() TO anon;
GRANT ALL ON FUNCTION public.carefur_guard_rtc_room_move() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_guard_rtc_room_move() TO service_role;


--
-- Name: FUNCTION carefur_is_paired_device(p_device_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_is_paired_device(p_device_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_is_paired_device(p_device_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_is_paired_device(p_device_id uuid) TO service_role;


--
-- Name: FUNCTION carefur_is_staff(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_is_staff() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_is_staff() TO anon;
GRANT ALL ON FUNCTION public.carefur_is_staff() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_is_staff() TO service_role;


--
-- Name: FUNCTION carefur_limit_shared_invitations(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_limit_shared_invitations() TO anon;
GRANT ALL ON FUNCTION public.carefur_limit_shared_invitations() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_limit_shared_invitations() TO service_role;


--
-- Name: FUNCTION carefur_lock_feeder_command_movement(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_lock_feeder_command_movement() TO anon;
GRANT ALL ON FUNCTION public.carefur_lock_feeder_command_movement() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_lock_feeder_command_movement() TO service_role;


--
-- Name: FUNCTION carefur_mark_no_shows(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_mark_no_shows() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_mark_no_shows() TO service_role;


--
-- Name: FUNCTION carefur_move_smart_unit(p_unit_code text, p_room_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_move_smart_unit(p_unit_code text, p_room_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_move_smart_unit(p_unit_code text, p_room_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_move_smart_unit(p_unit_code text, p_room_id uuid) TO service_role;


--
-- Name: FUNCTION carefur_owns_booking(p_booking_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_owns_booking(p_booking_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_owns_booking(p_booking_id uuid) TO anon;
GRANT ALL ON FUNCTION public.carefur_owns_booking(p_booking_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_owns_booking(p_booking_id uuid) TO service_role;


--
-- Name: FUNCTION carefur_prevent_unlinked_confirmation(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_prevent_unlinked_confirmation() TO anon;
GRANT ALL ON FUNCTION public.carefur_prevent_unlinked_confirmation() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_prevent_unlinked_confirmation() TO service_role;


--
-- Name: FUNCTION carefur_redeem_booking_code(p_code text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_redeem_booking_code(p_code text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_redeem_booking_code(p_code text) TO service_role;
GRANT ALL ON FUNCTION public.carefur_redeem_booking_code(p_code text) TO authenticated;


--
-- Name: FUNCTION carefur_refresh_no_shows(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_refresh_no_shows() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_refresh_no_shows() TO anon;
GRANT ALL ON FUNCTION public.carefur_refresh_no_shows() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_refresh_no_shows() TO service_role;


--
-- Name: FUNCTION carefur_refresh_paid_access_code(p_request_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_refresh_paid_access_code(p_request_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_refresh_paid_access_code(p_request_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_refresh_paid_access_code(p_request_id uuid) TO service_role;


--
-- Name: FUNCTION carefur_reject_manual_auto_completion(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_reject_manual_auto_completion() TO anon;
GRANT ALL ON FUNCTION public.carefur_reject_manual_auto_completion() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_reject_manual_auto_completion() TO service_role;


--
-- Name: FUNCTION carefur_reject_overlapping_reservation(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_reject_overlapping_reservation() TO anon;
GRANT ALL ON FUNCTION public.carefur_reject_overlapping_reservation() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_reject_overlapping_reservation() TO service_role;


--
-- Name: FUNCTION carefur_review_extension(p_request_id uuid, p_approve boolean); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_review_extension(p_request_id uuid, p_approve boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_review_extension(p_request_id uuid, p_approve boolean) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_review_extension(p_request_id uuid, p_approve boolean) TO service_role;


--
-- Name: FUNCTION carefur_review_reservation_request(p_request_id uuid, p_status text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_review_reservation_request(p_request_id uuid, p_status text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_review_reservation_request(p_request_id uuid, p_status text) TO anon;
GRANT ALL ON FUNCTION public.carefur_review_reservation_request(p_request_id uuid, p_status text) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_review_reservation_request(p_request_id uuid, p_status text) TO service_role;


--
-- Name: FUNCTION carefur_rtc_device_sync(p_device_code text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_rtc_device_sync(p_device_code text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_rtc_device_sync(p_device_code text) TO service_role;


--
-- Name: FUNCTION carefur_rtc_save_lease(p_device_code text, p_enabled boolean, p_morning text, p_afternoon text, p_evening text, p_mode text, p_actor uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_rtc_save_lease(p_device_code text, p_enabled boolean, p_morning text, p_afternoon text, p_evening text, p_mode text, p_actor uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_rtc_save_lease(p_device_code text, p_enabled boolean, p_morning text, p_afternoon text, p_evening text, p_mode text, p_actor uuid) TO service_role;


--
-- Name: FUNCTION carefur_set_extension_payment(p_request_id uuid, p_amount_due numeric, p_payment_status text, p_payment_reference text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_set_extension_payment(p_request_id uuid, p_amount_due numeric, p_payment_status text, p_payment_reference text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_set_extension_payment(p_request_id uuid, p_amount_due numeric, p_payment_status text, p_payment_reference text) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_set_extension_payment(p_request_id uuid, p_amount_due numeric, p_payment_status text, p_payment_reference text) TO service_role;


--
-- Name: FUNCTION carefur_smart_unit_status(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_smart_unit_status() FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_smart_unit_status() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_smart_unit_status() TO service_role;


--
-- Name: FUNCTION carefur_staff_boarding_action(p_booking_id uuid, p_action text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.carefur_staff_boarding_action(p_booking_id uuid, p_action text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.carefur_staff_boarding_action(p_booking_id uuid, p_action text) TO anon;
GRANT ALL ON FUNCTION public.carefur_staff_boarding_action(p_booking_id uuid, p_action text) TO authenticated;
GRANT ALL ON FUNCTION public.carefur_staff_boarding_action(p_booking_id uuid, p_action text) TO service_role;


--
-- Name: FUNCTION carefur_sync_auto_feeding_result(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_sync_auto_feeding_result() TO anon;
GRANT ALL ON FUNCTION public.carefur_sync_auto_feeding_result() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_sync_auto_feeding_result() TO service_role;


--
-- Name: FUNCTION carefur_validate_smart_unit(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.carefur_validate_smart_unit() TO anon;
GRANT ALL ON FUNCTION public.carefur_validate_smart_unit() TO authenticated;
GRANT ALL ON FUNCTION public.carefur_validate_smart_unit() TO service_role;


--
-- Name: FUNCTION create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text) TO anon;
GRANT ALL ON FUNCTION public.create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text) TO authenticated;
GRANT ALL ON FUNCTION public.create_public_inquiry(p_client_name text, p_client_email text, p_subject text, p_first_message text) TO service_role;


--
-- Name: FUNCTION create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric) FROM PUBLIC;
GRANT ALL ON FUNCTION public.create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric) TO anon;
GRANT ALL ON FUNCTION public.create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric) TO authenticated;
GRANT ALL ON FUNCTION public.create_public_reservation_request(p_owner_name text, p_email text, p_phone text, p_pet_name text, p_pet_species text, p_pet_breed text, p_room_id uuid, p_requested_room_number text, p_check_in_at timestamp with time zone, p_expected_check_out_at timestamp with time zone, p_special_instructions text, p_room_rate_per_night numeric, p_nights integer, p_estimated_total numeric) TO service_role;


--
-- Name: FUNCTION current_user_role(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.current_user_role() FROM PUBLIC;
GRANT ALL ON FUNCTION public.current_user_role() TO anon;
GRANT ALL ON FUNCTION public.current_user_role() TO authenticated;
GRANT ALL ON FUNCTION public.current_user_role() TO service_role;


--
-- Name: FUNCTION get_customer_boarding_reviews(p_limit integer); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.get_customer_boarding_reviews(p_limit integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.get_customer_boarding_reviews(p_limit integer) TO service_role;
GRANT ALL ON FUNCTION public.get_customer_boarding_reviews(p_limit integer) TO anon;
GRANT ALL ON FUNCTION public.get_customer_boarding_reviews(p_limit integer) TO authenticated;


--
-- Name: FUNCTION get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text) TO anon;
GRANT ALL ON FUNCTION public.get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text) TO authenticated;
GRANT ALL ON FUNCTION public.get_public_inquiry_thread(p_inquiry_id uuid, p_access_token text) TO service_role;


--
-- Name: FUNCTION get_verified_boarding_reviews(p_limit integer); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.get_verified_boarding_reviews(p_limit integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.get_verified_boarding_reviews(p_limit integer) TO anon;
GRANT ALL ON FUNCTION public.get_verified_boarding_reviews(p_limit integer) TO authenticated;
GRANT ALL ON FUNCTION public.get_verified_boarding_reviews(p_limit integer) TO service_role;


--
-- Name: FUNCTION is_admin(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC;
GRANT ALL ON FUNCTION public.is_admin() TO anon;
GRANT ALL ON FUNCTION public.is_admin() TO authenticated;
GRANT ALL ON FUNCTION public.is_admin() TO service_role;


--
-- Name: FUNCTION is_staff_member(); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.is_staff_member() FROM PUBLIC;
GRANT ALL ON FUNCTION public.is_staff_member() TO anon;
GRANT ALL ON FUNCTION public.is_staff_member() TO authenticated;
GRANT ALL ON FUNCTION public.is_staff_member() TO service_role;


--
-- Name: FUNCTION owner_has_booking_access(target_booking_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.owner_has_booking_access(target_booking_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.owner_has_booking_access(target_booking_id uuid) TO anon;
GRANT ALL ON FUNCTION public.owner_has_booking_access(target_booking_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.owner_has_booking_access(target_booking_id uuid) TO service_role;


--
-- Name: FUNCTION owner_has_pet_access(target_pet_id uuid); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.owner_has_pet_access(target_pet_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.owner_has_pet_access(target_pet_id uuid) TO anon;
GRANT ALL ON FUNCTION public.owner_has_pet_access(target_pet_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.owner_has_pet_access(target_pet_id uuid) TO service_role;


--
-- Name: FUNCTION public_room_availability(target_date date); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.public_room_availability(target_date date) FROM PUBLIC;
GRANT ALL ON FUNCTION public.public_room_availability(target_date date) TO anon;
GRANT ALL ON FUNCTION public.public_room_availability(target_date date) TO authenticated;
GRANT ALL ON FUNCTION public.public_room_availability(target_date date) TO service_role;


--
-- Name: FUNCTION public_room_availability_range(p_check_in date, p_check_out date); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.public_room_availability_range(p_check_in date, p_check_out date) FROM PUBLIC;
GRANT ALL ON FUNCTION public.public_room_availability_range(p_check_in date, p_check_out date) TO anon;
GRANT ALL ON FUNCTION public.public_room_availability_range(p_check_in date, p_check_out date) TO authenticated;
GRANT ALL ON FUNCTION public.public_room_availability_range(p_check_in date, p_check_out date) TO service_role;


--
-- Name: FUNCTION send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text) TO anon;
GRANT ALL ON FUNCTION public.send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text) TO authenticated;
GRANT ALL ON FUNCTION public.send_public_inquiry_message(p_inquiry_id uuid, p_access_token text, p_sender_name text, p_message text) TO service_role;


--
-- Name: FUNCTION set_room_status(p_room_id uuid, p_status text, p_reason text, p_until date, p_force boolean); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.set_room_status(p_room_id uuid, p_status text, p_reason text, p_until date, p_force boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION public.set_room_status(p_room_id uuid, p_status text, p_reason text, p_until date, p_force boolean) TO authenticated;
GRANT ALL ON FUNCTION public.set_room_status(p_room_id uuid, p_status text, p_reason text, p_until date, p_force boolean) TO service_role;


--
-- Name: FUNCTION set_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_updated_at() TO anon;
GRANT ALL ON FUNCTION public.set_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.set_updated_at() TO service_role;


--
-- Name: FUNCTION submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text) TO anon;
GRANT ALL ON FUNCTION public.submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text) TO authenticated;
GRANT ALL ON FUNCTION public.submit_boarding_review_by_email(p_email text, p_rating integer, p_comment text) TO service_role;


--
-- Name: FUNCTION submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION public.submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text) TO service_role;
GRANT ALL ON FUNCTION public.submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text) TO anon;
GRANT ALL ON FUNCTION public.submit_public_review(p_reviewer_name text, p_reviewer_email text, p_rating integer, p_comment text) TO authenticated;


--
-- Name: FUNCTION update_conversation_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_conversation_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_conversation_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_conversation_updated_at() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;


--
-- Name: FUNCTION authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]) TO postgres;
GRANT ALL ON FUNCTION realtime.authorize(role_name text, topic_name text, claims text, sub text, headers text, read_extensions text[], write_extensions text[], OUT read_allowed boolean[], OUT write_allowed boolean[]) TO dashboard_user;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text, negate boolean) TO service_role;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes_sync(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION send_binary(payload bytea, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send_binary(payload bytea, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]) TO postgres;
GRANT ALL ON FUNCTION realtime.settled_changes(slot_name name, max_changes integer, VARIADIC opts text[]) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION wal2json_escape_identifier(name text); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO postgres;
GRANT ALL ON FUNCTION realtime.wal2json_escape_identifier(name text) TO dashboard_user;


--
-- Name: FUNCTION delete_lifecycle_objects(object_ids uuid[]); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON FUNCTION storage.delete_lifecycle_objects(object_ids uuid[]) FROM PUBLIC;
GRANT ALL ON FUNCTION storage.delete_lifecycle_objects(object_ids uuid[]) TO postgres;
GRANT ALL ON FUNCTION storage.delete_lifecycle_objects(object_ids uuid[]) TO service_role;


--
-- Name: FUNCTION protect_active_lifecycle_states(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON FUNCTION storage.protect_active_lifecycle_states() FROM PUBLIC;


--
-- Name: FUNCTION reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON FUNCTION storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean) TO postgres;
GRANT ALL ON FUNCTION storage.reconcile_lifecycle_state(target_bucket_id text, policy_changed boolean) TO service_role;


--
-- Name: FUNCTION wake_lifecycle_state(); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON FUNCTION storage.wake_lifecycle_state() FROM PUBLIC;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO anon;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO authenticated;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO service_role;


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
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


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
-- Name: TABLE mfa_recovery_code_sets; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_recovery_code_sets TO postgres;
GRANT ALL ON TABLE auth.mfa_recovery_code_sets TO dashboard_user;


--
-- Name: TABLE mfa_recovery_codes; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_recovery_codes TO postgres;
GRANT ALL ON TABLE auth.mfa_recovery_codes TO dashboard_user;


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
-- Name: TABLE scim_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.scim_tokens TO postgres;
GRANT ALL ON TABLE auth.scim_tokens TO dashboard_user;


--
-- Name: TABLE scim_users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.scim_users TO postgres;
GRANT ALL ON TABLE auth.scim_users TO dashboard_user;


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
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE job; Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT SELECT ON TABLE cron.job TO postgres WITH GRANT OPTION;


--
-- Name: TABLE job_run_details; Type: ACL; Schema: cron; Owner: supabase_admin
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRUNCATE,MAINTAIN,UPDATE ON TABLE cron.job_run_details TO postgres WITH GRANT OPTION;


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
-- Name: TABLE activity_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.activity_logs TO anon;
GRANT ALL ON TABLE public.activity_logs TO authenticated;
GRANT ALL ON TABLE public.activity_logs TO service_role;


--
-- Name: SEQUENCE activity_logs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.activity_logs_id_seq TO anon;
GRANT ALL ON SEQUENCE public.activity_logs_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.activity_logs_id_seq TO service_role;


--
-- Name: TABLE alerts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.alerts TO anon;
GRANT ALL ON TABLE public.alerts TO authenticated;
GRANT ALL ON TABLE public.alerts TO service_role;


--
-- Name: TABLE boarding_extension_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.boarding_extension_requests TO anon;
GRANT ALL ON TABLE public.boarding_extension_requests TO authenticated;
GRANT ALL ON TABLE public.boarding_extension_requests TO service_role;


--
-- Name: TABLE boarding_reviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.boarding_reviews TO anon;
GRANT ALL ON TABLE public.boarding_reviews TO authenticated;
GRANT ALL ON TABLE public.boarding_reviews TO service_role;


--
-- Name: TABLE booking_access; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.booking_access TO anon;
GRANT ALL ON TABLE public.booking_access TO authenticated;
GRANT ALL ON TABLE public.booking_access TO service_role;


--
-- Name: TABLE booking_code_redemption_attempts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.booking_code_redemption_attempts TO service_role;


--
-- Name: SEQUENCE booking_code_redemption_attempts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.booking_code_redemption_attempts_id_seq TO anon;
GRANT ALL ON SEQUENCE public.booking_code_redemption_attempts_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.booking_code_redemption_attempts_id_seq TO service_role;


--
-- Name: TABLE bookings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bookings TO anon;
GRANT ALL ON TABLE public.bookings TO authenticated;
GRANT ALL ON TABLE public.bookings TO service_role;


--
-- Name: TABLE camera_wifi_switch_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.camera_wifi_switch_requests TO service_role;


--
-- Name: TABLE carefur_feeding_dispatches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.carefur_feeding_dispatches TO service_role;


--
-- Name: TABLE carefur_feeding_push_events; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.carefur_feeding_push_events TO service_role;


--
-- Name: TABLE carefur_feeding_push_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.carefur_feeding_push_tokens TO service_role;


--
-- Name: TABLE conversations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.conversations TO anon;
GRANT ALL ON TABLE public.conversations TO authenticated;
GRANT ALL ON TABLE public.conversations TO service_role;


--
-- Name: TABLE device_wifi_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.device_wifi_status TO service_role;


--
-- Name: TABLE devices; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.devices TO anon;
GRANT ALL ON TABLE public.devices TO authenticated;
GRANT ALL ON TABLE public.devices TO service_role;


--
-- Name: TABLE feeder_eating_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeder_eating_sessions TO service_role;
GRANT SELECT ON TABLE public.feeder_eating_sessions TO authenticated;


--
-- Name: TABLE feeder_food_events; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeder_food_events TO anon;
GRANT ALL ON TABLE public.feeder_food_events TO authenticated;
GRANT ALL ON TABLE public.feeder_food_events TO service_role;


--
-- Name: SEQUENCE feeder_food_events_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.feeder_food_events_id_seq TO anon;
GRANT ALL ON SEQUENCE public.feeder_food_events_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.feeder_food_events_id_seq TO service_role;


--
-- Name: TABLE feeder_food_state; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeder_food_state TO anon;
GRANT ALL ON TABLE public.feeder_food_state TO authenticated;
GRANT ALL ON TABLE public.feeder_food_state TO service_role;


--
-- Name: TABLE feeder_rtc_configs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeder_rtc_configs TO service_role;


--
-- Name: TABLE feeder_test_commands; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeder_test_commands TO service_role;


--
-- Name: TABLE feeder_test_schedules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeder_test_schedules TO service_role;


--
-- Name: TABLE feeding_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeding_logs TO anon;
GRANT ALL ON TABLE public.feeding_logs TO authenticated;
GRANT ALL ON TABLE public.feeding_logs TO service_role;


--
-- Name: TABLE feeding_schedules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feeding_schedules TO anon;
GRANT ALL ON TABLE public.feeding_schedules TO authenticated;
GRANT ALL ON TABLE public.feeding_schedules TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE owners; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.owners TO anon;
GRANT ALL ON TABLE public.owners TO authenticated;
GRANT ALL ON TABLE public.owners TO service_role;


--
-- Name: TABLE pet_owner_links; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pet_owner_links TO anon;
GRANT ALL ON TABLE public.pet_owner_links TO authenticated;
GRANT ALL ON TABLE public.pet_owner_links TO service_role;


--
-- Name: TABLE pet_vaccinations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pet_vaccinations TO anon;
GRANT ALL ON TABLE public.pet_vaccinations TO authenticated;
GRANT ALL ON TABLE public.pet_vaccinations TO service_role;


--
-- Name: TABLE pets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pets TO anon;
GRANT ALL ON TABLE public.pets TO authenticated;
GRANT ALL ON TABLE public.pets TO service_role;


--
-- Name: TABLE public_inquiries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_inquiries TO anon;
GRANT ALL ON TABLE public.public_inquiries TO authenticated;
GRANT ALL ON TABLE public.public_inquiries TO service_role;


--
-- Name: TABLE public_inquiry_messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_inquiry_messages TO anon;
GRANT ALL ON TABLE public.public_inquiry_messages TO authenticated;
GRANT ALL ON TABLE public.public_inquiry_messages TO service_role;


--
-- Name: TABLE public_reviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.public_reviews TO anon;
GRANT ALL ON TABLE public.public_reviews TO authenticated;
GRANT ALL ON TABLE public.public_reviews TO service_role;


--
-- Name: TABLE reservation_requests; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reservation_requests TO anon;
GRANT ALL ON TABLE public.reservation_requests TO authenticated;
GRANT ALL ON TABLE public.reservation_requests TO service_role;


--
-- Name: TABLE reservation_sms_notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reservation_sms_notifications TO service_role;


--
-- Name: TABLE room_devices; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.room_devices TO anon;
GRANT ALL ON TABLE public.room_devices TO authenticated;
GRANT ALL ON TABLE public.room_devices TO service_role;


--
-- Name: TABLE rooms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rooms TO anon;
GRANT ALL ON TABLE public.rooms TO authenticated;
GRANT ALL ON TABLE public.rooms TO service_role;


--
-- Name: TABLE smart_units; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.smart_units TO anon;
GRANT ALL ON TABLE public.smart_units TO authenticated;
GRANT ALL ON TABLE public.smart_units TO service_role;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO anon;
GRANT ALL ON TABLE public.users TO authenticated;
GRANT ALL ON TABLE public.users TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE messages_2026_11_05; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_05 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_05 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_05 TO dashboard_user;


--
-- Name: TABLE messages_2026_11_06; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_06 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_06 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_06 TO dashboard_user;


--
-- Name: TABLE messages_2026_11_07; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_07 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_07 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_07 TO dashboard_user;


--
-- Name: TABLE messages_2026_11_08; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_08 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_08 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_08 TO dashboard_user;


--
-- Name: TABLE messages_2026_11_09; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_09 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_09 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_09 TO dashboard_user;


--
-- Name: TABLE messages_2026_11_10; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_10 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_10 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_10 TO dashboard_user;


--
-- Name: TABLE messages_2026_11_11; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE realtime.messages_2026_11_11 TO postgres;
GRANT SELECT,INSERT ON TABLE realtime.messages_2026_11_11 TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE realtime.messages_2026_11_11 TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;


--
-- Name: TABLE bucket_lifecycle_states; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.bucket_lifecycle_states TO postgres;
GRANT ALL ON TABLE storage.bucket_lifecycle_states TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storage.buckets TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storage.buckets_analytics TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;


--
-- Name: TABLE lifecycle_abandoned_artifacts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.lifecycle_abandoned_artifacts TO postgres;
GRANT ALL ON TABLE storage.lifecycle_abandoned_artifacts TO service_role;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storage.objects TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


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
GRANT SELECT ON TABLE storage.vector_indexes TO anon;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;
GRANT ALL ON TABLE supabase_functions.hooks TO anon;
GRANT ALL ON TABLE supabase_functions.hooks TO authenticated;
GRANT ALL ON TABLE supabase_functions.hooks TO service_role;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO anon;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO authenticated;
GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO service_role;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;
GRANT ALL ON TABLE supabase_functions.migrations TO anon;
GRANT ALL ON TABLE supabase_functions.migrations TO authenticated;
GRANT ALL ON TABLE supabase_functions.migrations TO service_role;


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
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: cron; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA cron GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


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

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT SELECT,INSERT ON TABLES TO postgres WITH GRANT OPTION;
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
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES TO service_role;


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
         WHEN TAG IN ('CREATE EXTENSION')
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

\unrestrict wCzY7145MDN9nU3hIw8aI72WO2fnmwqMORzWRHICCdcqIEEhy3Nhxz0Z3XUyLjo

