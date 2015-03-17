--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    company_name character varying(255),
    about text,
    phone_number character varying(255),
    plan_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    stripe_customer_token character varying(255),
    stripe_subscription_token character varying(255),
    storage_usage integer
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    city character varying(255),
    postal_code character varying(255),
    state character varying(255),
    addressable_id integer,
    addressable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: ahoy_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ahoy_events (
    id uuid NOT NULL,
    visit_id uuid,
    user_id integer,
    user_type character varying(255),
    name character varying(255),
    properties json,
    "time" timestamp without time zone
);


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contacts (
    id integer NOT NULL,
    name character varying(255),
    phone character varying(255),
    email character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    social_media hstore,
    title character varying(255),
    description text
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contacts_id_seq OWNED BY contacts.id;


--
-- Name: forms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forms (
    id integer NOT NULL,
    name character varying(255),
    fields json,
    column_style integer,
    styles text,
    scripts text,
    emails json,
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    ecommerce_type character varying(255),
    thank_msg text
);


--
-- Name: forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forms_id_seq OWNED BY forms.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE images (
    id integer NOT NULL,
    image character varying(255),
    viewable_id integer,
    viewable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    title character varying(255),
    content text,
    notable_id integer,
    notable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE plans (
    id integer NOT NULL,
    name character varying(255),
    price numeric,
    users integer,
    forms integer,
    storage integer,
    requests integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE plans_id_seq OWNED BY plans.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE quotes (
    id integer NOT NULL,
    amount numeric(10,2),
    options json,
    token character varying(255),
    expires_at timestamp without time zone,
    request_id integer,
    description text,
    signature text,
    status character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    template_id integer,
    email_sent integer DEFAULT 0,
    email_opened integer DEFAULT 0
);


--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE quotes_id_seq OWNED BY quotes.id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE requests (
    id integer NOT NULL,
    fields json,
    form_id integer,
    status character varying(255),
    account_id integer,
    contact_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE requests_id_seq OWNED BY requests.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: templates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE templates (
    id integer NOT NULL,
    name character varying(255),
    content text,
    description text,
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE templates_id_seq OWNED BY templates.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    firstname character varying(255),
    lastname character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role character varying(255) DEFAULT 'viewer'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: visits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE visits (
    id uuid NOT NULL,
    visitor_id uuid,
    ip character varying(255),
    user_agent text,
    referrer text,
    landing_page text,
    user_id integer,
    eventable_id integer,
    eventable_type character varying(255),
    referring_domain character varying(255),
    search_keyword character varying(255),
    browser character varying(255),
    os character varying(255),
    device_type character varying(255),
    screen_height integer,
    screen_width integer,
    country character varying(255),
    region character varying(255),
    city character varying(255),
    utm_source character varying(255),
    utm_medium character varying(255),
    utm_term character varying(255),
    utm_content character varying(255),
    utm_campaign character varying(255),
    started_at timestamp without time zone
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contacts ALTER COLUMN id SET DEFAULT nextval('contacts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forms ALTER COLUMN id SET DEFAULT nextval('forms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY plans ALTER COLUMN id SET DEFAULT nextval('plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY requests ALTER COLUMN id SET DEFAULT nextval('requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY templates ALTER COLUMN id SET DEFAULT nextval('templates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: ahoy_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ahoy_events
    ADD CONSTRAINT ahoy_events_pkey PRIMARY KEY (id);


--
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forms
    ADD CONSTRAINT forms_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: quotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY quotes
    ADD CONSTRAINT quotes_pkey PRIMARY KEY (id);


--
-- Name: requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_plan_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_plan_id ON accounts USING btree (plan_id);


--
-- Name: index_addresses_on_addressable_id_and_addressable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_addressable_id_and_addressable_type ON addresses USING btree (addressable_id, addressable_type);


--
-- Name: index_ahoy_events_on_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ahoy_events_on_time ON ahoy_events USING btree ("time");


--
-- Name: index_ahoy_events_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ahoy_events_on_user_id ON ahoy_events USING btree (user_id);


--
-- Name: index_ahoy_events_on_user_id_and_user_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ahoy_events_on_user_id_and_user_type ON ahoy_events USING btree (user_id, user_type);


--
-- Name: index_ahoy_events_on_visit_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ahoy_events_on_visit_id ON ahoy_events USING btree (visit_id);


--
-- Name: index_contacts_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_contacts_on_account_id ON contacts USING btree (account_id);


--
-- Name: index_forms_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_forms_on_account_id ON forms USING btree (account_id);


--
-- Name: index_images_on_viewable_id_and_viewable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_images_on_viewable_id_and_viewable_type ON images USING btree (viewable_id, viewable_type);


--
-- Name: index_notes_on_notable_id_and_notable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notes_on_notable_id_and_notable_type ON notes USING btree (notable_id, notable_type);


--
-- Name: index_quotes_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quotes_on_account_id ON quotes USING btree (account_id);


--
-- Name: index_quotes_on_request_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quotes_on_request_id ON quotes USING btree (request_id);


--
-- Name: index_quotes_on_template_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_quotes_on_template_id ON quotes USING btree (template_id);


--
-- Name: index_requests_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_account_id ON requests USING btree (account_id);


--
-- Name: index_requests_on_contact_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_contact_id ON requests USING btree (contact_id);


--
-- Name: index_requests_on_form_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_requests_on_form_id ON requests USING btree (form_id);


--
-- Name: index_templates_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_templates_on_account_id ON templates USING btree (account_id);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_account_id ON users USING btree (account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_visits_on_eventable_id_and_eventable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_eventable_id_and_eventable_type ON visits USING btree (eventable_id, eventable_type);


--
-- Name: index_visits_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_visits_on_user_id ON visits USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140421173127');

INSERT INTO schema_migrations (version) VALUES ('20140421173219');

INSERT INTO schema_migrations (version) VALUES ('20140421173738');

INSERT INTO schema_migrations (version) VALUES ('20140421182151');

INSERT INTO schema_migrations (version) VALUES ('20140421182233');

INSERT INTO schema_migrations (version) VALUES ('20140611130446');

INSERT INTO schema_migrations (version) VALUES ('20150302030823');

INSERT INTO schema_migrations (version) VALUES ('20150304085723');

INSERT INTO schema_migrations (version) VALUES ('20150305092901');

INSERT INTO schema_migrations (version) VALUES ('20150306073658');

INSERT INTO schema_migrations (version) VALUES ('20150310060819');

INSERT INTO schema_migrations (version) VALUES ('20150311052625');

INSERT INTO schema_migrations (version) VALUES ('20150311064220');

INSERT INTO schema_migrations (version) VALUES ('20150311083622');

INSERT INTO schema_migrations (version) VALUES ('20150311100151');

INSERT INTO schema_migrations (version) VALUES ('20150312053327');

INSERT INTO schema_migrations (version) VALUES ('20150312053328');

INSERT INTO schema_migrations (version) VALUES ('20150312122544');

INSERT INTO schema_migrations (version) VALUES ('20150313033119');

INSERT INTO schema_migrations (version) VALUES ('20150313033202');

INSERT INTO schema_migrations (version) VALUES ('20150316033449');

INSERT INTO schema_migrations (version) VALUES ('20150317021749');

INSERT INTO schema_migrations (version) VALUES ('20150317021812');

INSERT INTO schema_migrations (version) VALUES ('20150317022046');

INSERT INTO schema_migrations (version) VALUES ('20150317081922');

INSERT INTO schema_migrations (version) VALUES ('20150317091023');

