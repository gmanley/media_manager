SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: users_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.users_role AS ENUM (
    'admin',
    'contributor',
    'consumer'
);


SET default_tablespace = '';

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: host_provider_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.host_provider_accounts (
    id bigint NOT NULL,
    name character varying,
    username character varying NOT NULL,
    password character varying NOT NULL,
    online boolean DEFAULT true NOT NULL,
    used_storage bigint DEFAULT 0 NOT NULL,
    info jsonb,
    host_provider_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    total_storage bigint
);


--
-- Name: host_provider_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.host_provider_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: host_provider_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.host_provider_accounts_id_seq OWNED BY public.host_provider_accounts.id;


--
-- Name: host_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.host_providers (
    id bigint NOT NULL,
    url character varying NOT NULL,
    name character varying NOT NULL,
    default_storage_limit bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: host_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.host_providers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: host_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.host_providers_id_seq OWNED BY public.host_providers.id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invites (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email character varying NOT NULL,
    role public.users_role DEFAULT 'consumer'::public.users_role,
    sender_id bigint NOT NULL,
    recipient_id bigint,
    redeemed_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: snapshot_indices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshot_indices (
    id bigint NOT NULL,
    grid_size integer[] DEFAULT '{3,3}'::integer[],
    image character varying,
    video_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapshot_indices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snapshot_indices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshot_indices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapshot_indices_id_seq OWNED BY public.snapshot_indices.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snapshots (
    id bigint NOT NULL,
    video_time numeric NOT NULL,
    processed boolean DEFAULT false NOT NULL,
    image character varying,
    snapshot_index_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snapshots_id_seq OWNED BY public.snapshots.id;


--
-- Name: source_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.source_files (
    id bigint NOT NULL,
    path character varying NOT NULL,
    video_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: source_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.source_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: source_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.source_files_id_seq OWNED BY public.source_files.id;


--
-- Name: uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.uploads (
    id bigint NOT NULL,
    url character varying NOT NULL,
    remote_path character varying,
    online boolean DEFAULT true NOT NULL,
    public boolean DEFAULT true NOT NULL,
    host_provider_id bigint,
    host_provider_account_id bigint,
    video_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.uploads_id_seq OWNED BY public.uploads.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    email character varying NOT NULL,
    encrypted_password character varying(128) NOT NULL,
    confirmation_token character varying(128),
    remember_token character varying(128) NOT NULL,
    role public.users_role DEFAULT 'consumer'::public.users_role,
    username character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object jsonb,
    created_at timestamp without time zone,
    object_changes jsonb
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.videos (
    id bigint NOT NULL,
    file_metadata jsonb,
    file_hash character varying,
    name character varying NOT NULL,
    air_date date,
    duration numeric,
    processed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    primary_source_file_id bigint NOT NULL,
    external_id character varying
);


--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.videos_id_seq OWNED BY public.videos.id;


--
-- Name: host_provider_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_provider_accounts ALTER COLUMN id SET DEFAULT nextval('public.host_provider_accounts_id_seq'::regclass);


--
-- Name: host_providers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_providers ALTER COLUMN id SET DEFAULT nextval('public.host_providers_id_seq'::regclass);


--
-- Name: snapshot_indices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshot_indices ALTER COLUMN id SET DEFAULT nextval('public.snapshot_indices_id_seq'::regclass);


--
-- Name: snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots ALTER COLUMN id SET DEFAULT nextval('public.snapshots_id_seq'::regclass);


--
-- Name: source_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_files ALTER COLUMN id SET DEFAULT nextval('public.source_files_id_seq'::regclass);


--
-- Name: uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads ALTER COLUMN id SET DEFAULT nextval('public.uploads_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: host_provider_accounts host_provider_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_provider_accounts
    ADD CONSTRAINT host_provider_accounts_pkey PRIMARY KEY (id);


--
-- Name: host_providers host_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.host_providers
    ADD CONSTRAINT host_providers_pkey PRIMARY KEY (id);


--
-- Name: invites invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: snapshot_indices snapshot_indices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshot_indices
    ADD CONSTRAINT snapshot_indices_pkey PRIMARY KEY (id);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: source_files source_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source_files
    ADD CONSTRAINT source_files_pkey PRIMARY KEY (id);


--
-- Name: uploads uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: index_host_provider_accounts_on_host_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_provider_accounts_on_host_provider_id ON public.host_provider_accounts USING btree (host_provider_id);


--
-- Name: index_host_providers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_host_providers_on_name ON public.host_providers USING btree (name);


--
-- Name: index_invites_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invites_on_recipient_id ON public.invites USING btree (recipient_id);


--
-- Name: index_invites_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invites_on_sender_id ON public.invites USING btree (sender_id);


--
-- Name: index_snapshot_indices_on_video_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshot_indices_on_video_id ON public.snapshot_indices USING btree (video_id);


--
-- Name: index_snapshots_on_snapshot_index_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_snapshot_index_id ON public.snapshots USING btree (snapshot_index_id);


--
-- Name: index_source_files_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_source_files_on_path ON public.source_files USING btree (path);


--
-- Name: index_source_files_on_video_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_source_files_on_video_id ON public.source_files USING btree (video_id);


--
-- Name: index_uploads_on_host_provider_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_host_provider_account_id ON public.uploads USING btree (host_provider_account_id);


--
-- Name: index_uploads_on_host_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_host_provider_id ON public.uploads USING btree (host_provider_id);


--
-- Name: index_uploads_on_online; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_online ON public.uploads USING btree (online);


--
-- Name: index_uploads_on_public; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_public ON public.uploads USING btree (public);


--
-- Name: index_uploads_on_video_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_video_id ON public.uploads USING btree (video_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_remember_token ON public.users USING btree (remember_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20191215014500'),
('20191215015032'),
('20191215015342'),
('20191227030352'),
('20191227031306'),
('20191228002901'),
('20191230064858'),
('20200101010119'),
('20200101010120'),
('20200101013923'),
('20200107005550'),
('20200123024406'),
('20200203005240'),
('20200203041456'),
('20200204011815'),
('20200327222338'),
('20200328012327'),
('20200517174921'),
('20200517174922');


