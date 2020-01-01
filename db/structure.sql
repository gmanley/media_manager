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
-- Name: host_providers; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.host_providers AS ENUM (
    'mega',
    'backblaze'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    online boolean DEFAULT true NOT NULL,
    public boolean DEFAULT true NOT NULL,
    host_provider public.host_providers NOT NULL,
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
    download_url character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    primary_source_file_id bigint NOT NULL,
    csv_number integer
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
-- Name: videos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos ALTER COLUMN id SET DEFAULT nextval('public.videos_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


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
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


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
-- Name: index_uploads_on_host_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_host_provider ON public.uploads USING btree (host_provider);


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
('20200101013923');


