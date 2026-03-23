--
-- PostgreSQL database dump
--

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.3

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
-- Name: auth_schema; Type: SCHEMA; Schema: -; Owner: apextrader
--

CREATE SCHEMA auth_schema;


ALTER SCHEMA auth_schema OWNER TO apextrader;

--
-- Name: order_schema; Type: SCHEMA; Schema: -; Owner: apextrader
--

CREATE SCHEMA order_schema;


ALTER SCHEMA order_schema OWNER TO apextrader;

--
-- Name: wallet_schema; Type: SCHEMA; Schema: -; Owner: apextrader
--

CREATE SCHEMA wallet_schema;


ALTER SCHEMA wallet_schema OWNER TO apextrader;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: auth_schema; Owner: apextrader
--

CREATE TABLE auth_schema.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE auth_schema.flyway_schema_history OWNER TO apextrader;

--
-- Name: roles; Type: TABLE; Schema: auth_schema; Owner: apextrader
--

CREATE TABLE auth_schema.roles (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE auth_schema.roles OWNER TO apextrader;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: auth_schema; Owner: apextrader
--

CREATE SEQUENCE auth_schema.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth_schema.roles_id_seq OWNER TO apextrader;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: auth_schema; Owner: apextrader
--

ALTER SEQUENCE auth_schema.roles_id_seq OWNED BY auth_schema.roles.id;


--
-- Name: user_roles; Type: TABLE; Schema: auth_schema; Owner: apextrader
--

CREATE TABLE auth_schema.user_roles (
    user_id bigint NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE auth_schema.user_roles OWNER TO apextrader;

--
-- Name: users; Type: TABLE; Schema: auth_schema; Owner: apextrader
--

CREATE TABLE auth_schema.users (
    id bigint NOT NULL,
    user_name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE auth_schema.users OWNER TO apextrader;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: auth_schema; Owner: apextrader
--

CREATE SEQUENCE auth_schema.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth_schema.users_id_seq OWNER TO apextrader;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: auth_schema; Owner: apextrader
--

ALTER SEQUENCE auth_schema.users_id_seq OWNED BY auth_schema.users.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: order_schema; Owner: apextrader
--

CREATE TABLE order_schema.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE order_schema.flyway_schema_history OWNER TO apextrader;

--
-- Name: orders; Type: TABLE; Schema: order_schema; Owner: apextrader
--

CREATE TABLE order_schema.orders (
    id bigint NOT NULL,
    user_name character varying(255) NOT NULL,
    symbol character varying(20) NOT NULL,
    side character varying(10) NOT NULL,
    price numeric(18,8) NOT NULL,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE order_schema.orders OWNER TO apextrader;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: order_schema; Owner: apextrader
--

CREATE SEQUENCE order_schema.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE order_schema.orders_id_seq OWNER TO apextrader;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: order_schema; Owner: apextrader
--

ALTER SEQUENCE order_schema.orders_id_seq OWNED BY order_schema.orders.id;


--
-- Name: trades; Type: TABLE; Schema: order_schema; Owner: apextrader
--

CREATE TABLE order_schema.trades (
    id bigint NOT NULL,
    buy_order_id bigint NOT NULL,
    sell_order_id bigint NOT NULL,
    symbol character varying(20) NOT NULL,
    price numeric(18,8) NOT NULL,
    quantity numeric(18,8) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE order_schema.trades OWNER TO apextrader;

--
-- Name: trades_id_seq; Type: SEQUENCE; Schema: order_schema; Owner: apextrader
--

CREATE SEQUENCE order_schema.trades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE order_schema.trades_id_seq OWNER TO apextrader;

--
-- Name: trades_id_seq; Type: SEQUENCE OWNED BY; Schema: order_schema; Owner: apextrader
--

ALTER SEQUENCE order_schema.trades_id_seq OWNED BY order_schema.trades.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: wallet_schema; Owner: apextrader
--

CREATE TABLE wallet_schema.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE wallet_schema.flyway_schema_history OWNER TO apextrader;

--
-- Name: wallets; Type: TABLE; Schema: wallet_schema; Owner: apextrader
--

CREATE TABLE wallet_schema.wallets (
    id bigint NOT NULL,
    user_name character varying(255) NOT NULL,
    currency character varying(10) NOT NULL,
    balance numeric(18,8) DEFAULT 0.0
);


ALTER TABLE wallet_schema.wallets OWNER TO apextrader;

--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: wallet_schema; Owner: apextrader
--

CREATE SEQUENCE wallet_schema.wallets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE wallet_schema.wallets_id_seq OWNER TO apextrader;

--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: wallet_schema; Owner: apextrader
--

ALTER SEQUENCE wallet_schema.wallets_id_seq OWNED BY wallet_schema.wallets.id;


--
-- Name: roles id; Type: DEFAULT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.roles ALTER COLUMN id SET DEFAULT nextval('auth_schema.roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.users ALTER COLUMN id SET DEFAULT nextval('auth_schema.users_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.orders ALTER COLUMN id SET DEFAULT nextval('order_schema.orders_id_seq'::regclass);


--
-- Name: trades id; Type: DEFAULT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.trades ALTER COLUMN id SET DEFAULT nextval('order_schema.trades_id_seq'::regclass);


--
-- Name: wallets id; Type: DEFAULT; Schema: wallet_schema; Owner: apextrader
--

ALTER TABLE ONLY wallet_schema.wallets ALTER COLUMN id SET DEFAULT nextval('wallet_schema.wallets_id_seq'::regclass);


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: auth_schema; Owner: apextrader
--

COPY auth_schema.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
0	\N	<< Flyway Schema Creation >>	SCHEMA	"auth_schema"	\N	apextrader	2026-03-23 04:32:43.013099	0	t
1	1	init auth schema	SQL	V1__init_auth_schema.sql	241579606	apextrader	2026-03-23 04:40:03.978931	67	t
2	2	Add User Role Relationships	SQL	V2__Add_User_Role_Relationships.sql	-1544985120	apextrader	2026-03-23 07:17:27.239294	38	t
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: auth_schema; Owner: apextrader
--

COPY auth_schema.roles (id, name) FROM stdin;
1	ROLE_USER
2	ROLE_ADMIN
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: auth_schema; Owner: apextrader
--

COPY auth_schema.user_roles (user_id, role_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth_schema; Owner: apextrader
--

COPY auth_schema.users (id, user_name, password, created_at) FROM stdin;
1	wahidsaeed1	$2a$10$UdbPEZ/1E1dY/8tbhTzIqOXeqam0juhL3OAqS1ZDs0yMA.7iCxHuW	2026-03-23 06:12:00.107171
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: order_schema; Owner: apextrader
--

COPY order_schema.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
0	\N	<< Flyway Schema Creation >>	SCHEMA	"order_schema"	\N	apextrader	2026-03-23 05:59:11.299382	0	t
1	1	create orders table	SQL	V1__create_orders_table.sql	1463867834	apextrader	2026-03-23 05:59:11.33477	19	t
2	2	create trades table	SQL	V2__create_trades_table.sql	-1038228074	apextrader	2026-03-23 05:59:11.366622	7	t
3	3	update orders table	SQL	V3__update_orders_table.sql	132946541	apextrader	2026-03-23 05:59:11.381911	8	t
4	4	Add Trade Order Relationships	SQL	V4__Add_Trade_Order_Relationships.sql	-1926814013	apextrader	2026-03-23 07:04:37.998711	56	t
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: order_schema; Owner: apextrader
--

COPY order_schema.orders (id, user_name, symbol, side, price, status, created_at) FROM stdin;
\.


--
-- Data for Name: trades; Type: TABLE DATA; Schema: order_schema; Owner: apextrader
--

COPY order_schema.trades (id, buy_order_id, sell_order_id, symbol, price, quantity, executed_at) FROM stdin;
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: wallet_schema; Owner: apextrader
--

COPY wallet_schema.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
0	\N	<< Flyway Schema Creation >>	SCHEMA	"wallet_schema"	\N	apextrader	2026-03-21 02:33:26.157681	0	t
1	1	create wallets table	SQL	V1__create_wallets_table.sql	1027434708	apextrader	2026-03-21 02:33:26.188876	18	t
2	2	rename user id to user name	SQL	V2__rename_user_id_to_user_name.sql	-1702138998	apextrader	2026-03-23 06:06:05.935039	27	t
\.


--
-- Data for Name: wallets; Type: TABLE DATA; Schema: wallet_schema; Owner: apextrader
--

COPY wallet_schema.wallets (id, user_name, currency, balance) FROM stdin;
1	abdul-001	USD	0.00000000
2	abdul-001	BTC	0.70000000
5	elena-003	USD	4000.00000000
6	elena-003	BTC	1.10000000
3	stefan-002	USD	26000.00000000
4	stefan-002	BTC	0.70000000
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: auth_schema; Owner: apextrader
--

SELECT pg_catalog.setval('auth_schema.roles_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: auth_schema; Owner: apextrader
--

SELECT pg_catalog.setval('auth_schema.users_id_seq', 1, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: order_schema; Owner: apextrader
--

SELECT pg_catalog.setval('order_schema.orders_id_seq', 1, false);


--
-- Name: trades_id_seq; Type: SEQUENCE SET; Schema: order_schema; Owner: apextrader
--

SELECT pg_catalog.setval('order_schema.trades_id_seq', 1, false);


--
-- Name: wallets_id_seq; Type: SEQUENCE SET; Schema: wallet_schema; Owner: apextrader
--

SELECT pg_catalog.setval('wallet_schema.wallets_id_seq', 6, true);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_user_name_key; Type: CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.users
    ADD CONSTRAINT users_user_name_key UNIQUE (user_name);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: trades trades_pkey; Type: CONSTRAINT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.trades
    ADD CONSTRAINT trades_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: wallet_schema; Owner: apextrader
--

ALTER TABLE ONLY wallet_schema.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: wallets unique_user_currency; Type: CONSTRAINT; Schema: wallet_schema; Owner: apextrader
--

ALTER TABLE ONLY wallet_schema.wallets
    ADD CONSTRAINT unique_user_currency UNIQUE (user_name, currency);


--
-- Name: wallets wallets_pkey; Type: CONSTRAINT; Schema: wallet_schema; Owner: apextrader
--

ALTER TABLE ONLY wallet_schema.wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: auth_schema; Owner: apextrader
--

CREATE INDEX flyway_schema_history_s_idx ON auth_schema.flyway_schema_history USING btree (success);


--
-- Name: idx_user_roles_user_id; Type: INDEX; Schema: auth_schema; Owner: apextrader
--

CREATE INDEX idx_user_roles_user_id ON auth_schema.user_roles USING btree (user_id);


--
-- Name: idx_users_username; Type: INDEX; Schema: auth_schema; Owner: apextrader
--

CREATE INDEX idx_users_username ON auth_schema.users USING btree (user_name);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: order_schema; Owner: apextrader
--

CREATE INDEX flyway_schema_history_s_idx ON order_schema.flyway_schema_history USING btree (success);


--
-- Name: idx_orders_user_name; Type: INDEX; Schema: order_schema; Owner: apextrader
--

CREATE INDEX idx_orders_user_name ON order_schema.orders USING btree (user_name);


--
-- Name: idx_trades_buy_order_id; Type: INDEX; Schema: order_schema; Owner: apextrader
--

CREATE INDEX idx_trades_buy_order_id ON order_schema.trades USING btree (buy_order_id);


--
-- Name: idx_trades_sell_order_id; Type: INDEX; Schema: order_schema; Owner: apextrader
--

CREATE INDEX idx_trades_sell_order_id ON order_schema.trades USING btree (sell_order_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: wallet_schema; Owner: apextrader
--

CREATE INDEX flyway_schema_history_s_idx ON wallet_schema.flyway_schema_history USING btree (success);


--
-- Name: user_roles fk_role_id; Type: FK CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.user_roles
    ADD CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES auth_schema.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles fk_user_id; Type: FK CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.user_roles
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES auth_schema.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES auth_schema.roles(id);


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: auth_schema; Owner: apextrader
--

ALTER TABLE ONLY auth_schema.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_schema.users(id);


--
-- Name: trades fk_buy_order; Type: FK CONSTRAINT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.trades
    ADD CONSTRAINT fk_buy_order FOREIGN KEY (buy_order_id) REFERENCES order_schema.orders(id);


--
-- Name: trades fk_sell_order; Type: FK CONSTRAINT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.trades
    ADD CONSTRAINT fk_sell_order FOREIGN KEY (sell_order_id) REFERENCES order_schema.orders(id);


--
-- PostgreSQL database dump complete
--

