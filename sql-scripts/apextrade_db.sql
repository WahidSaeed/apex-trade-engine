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

--
-- Name: assign_default_role(); Type: FUNCTION; Schema: auth_schema; Owner: apextrader
--

CREATE FUNCTION auth_schema.assign_default_role() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- This assumes ROLE_USER always has ID 1 (based on your dump)
    INSERT INTO auth_schema.user_roles (user_id, role_id)
    VALUES (NEW.id, 1);
    RETURN NEW;
END;
$$;


ALTER FUNCTION auth_schema.assign_default_role() OWNER TO apextrader;

--
-- Name: initialize_user_wallets(); Type: FUNCTION; Schema: wallet_schema; Owner: apextrader
--

CREATE FUNCTION wallet_schema.initialize_user_wallets() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Create the USD Wallet
    INSERT INTO wallet_schema.wallets (user_name, currency, balance)
    VALUES (NEW.user_name, 'USD', 100000.00000000);

    -- Create the BTC Wallet
    INSERT INTO wallet_schema.wallets (user_name, currency, balance)
    VALUES (NEW.user_name, 'BTC', 0.70000000);

    RETURN NEW;
END;
$$;


ALTER FUNCTION wallet_schema.initialize_user_wallets() OWNER TO apextrader;

--
-- Name: process_trade_settlement(character varying, character varying, character varying, numeric, numeric); Type: PROCEDURE; Schema: wallet_schema; Owner: apextrader
--

CREATE PROCEDURE wallet_schema.process_trade_settlement(IN p_buy_user character varying, IN p_sell_user character varying, IN p_symbol character varying, IN p_price numeric, IN p_quantity numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_base_curr VARCHAR := split_part(p_symbol, '-', 1); -- e.g., BTC
    v_quote_curr VARCHAR := split_part(p_symbol, '-', 2); -- e.g., USD
    v_total_cost NUMERIC := p_price * p_quantity;
BEGIN
    -- 1. Deduct Quote (USD) from Buyer
    UPDATE wallet_schema.wallets SET balance = balance - v_total_cost 
    WHERE user_name = p_buy_user AND currency = v_quote_curr;

    -- 2. Add Base (BTC) to Buyer
    UPDATE wallet_schema.wallets SET balance = balance + p_quantity 
    WHERE user_name = p_buy_user AND currency = v_base_curr;

    -- 3. Add Quote (USD) to Seller
    UPDATE wallet_schema.wallets SET balance = balance + v_total_cost 
    WHERE user_name = p_sell_user AND currency = v_quote_curr;

    -- 4. Deduct Base (BTC) from Seller
    UPDATE wallet_schema.wallets SET balance = balance - p_quantity 
    WHERE user_name = p_sell_user AND currency = v_base_curr;

    -- 5. Safety Check: Ensure no negative balances (Post-Trade)
    IF EXISTS (SELECT 1 FROM wallet_schema.wallets WHERE balance < 0) THEN
        RAISE EXCEPTION 'Settlement failed: Insufficient funds for trade.';
    END IF;
END;
$$;


ALTER PROCEDURE wallet_schema.process_trade_settlement(IN p_buy_user character varying, IN p_sell_user character varying, IN p_symbol character varying, IN p_price numeric, IN p_quantity numeric) OWNER TO apextrader;

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
-- Name: roles; Type: TABLE; Schema: order_schema; Owner: apextrader
--

CREATE TABLE order_schema.roles (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE order_schema.roles OWNER TO apextrader;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: order_schema; Owner: apextrader
--

CREATE SEQUENCE order_schema.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE order_schema.roles_id_seq OWNER TO apextrader;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: order_schema; Owner: apextrader
--

ALTER SEQUENCE order_schema.roles_id_seq OWNED BY order_schema.roles.id;


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
-- Name: view_market_depth; Type: VIEW; Schema: order_schema; Owner: apextrader
--

CREATE VIEW order_schema.view_market_depth AS
 SELECT symbol,
    side,
    price,
    sum(1) AS total_quantity,
    count(id) AS order_count
   FROM order_schema.orders
  WHERE ((status)::text = 'PENDING'::text)
  GROUP BY symbol, side, price
  ORDER BY symbol, side DESC, price;


ALTER VIEW order_schema.view_market_depth OWNER TO apextrader;

--
-- Name: view_trade_history; Type: VIEW; Schema: order_schema; Owner: apextrader
--

CREATE VIEW order_schema.view_trade_history AS
 SELECT t.id AS trade_id,
    t.symbol,
    o.price AS execution_price,
    t.quantity,
    (o.price * t.quantity) AS total_value,
    t.executed_at
   FROM (order_schema.trades t
     JOIN order_schema.orders o ON ((t.buy_order_id = o.id)));


ALTER VIEW order_schema.view_trade_history OWNER TO apextrader;

--
-- Name: view_trade_velocity; Type: VIEW; Schema: order_schema; Owner: apextrader
--

CREATE VIEW order_schema.view_trade_velocity AS
 SELECT symbol,
    date_trunc('minute'::text, executed_at) AS minute_slot,
    count(*) AS trades_per_minute,
    sum((quantity * price)) AS usd_volume_per_minute
   FROM order_schema.trades
  GROUP BY symbol, (date_trunc('minute'::text, executed_at))
  ORDER BY (date_trunc('minute'::text, executed_at)) DESC;


ALTER VIEW order_schema.view_trade_velocity OWNER TO apextrader;

--
-- Name: view_whale_trades; Type: VIEW; Schema: order_schema; Owner: apextrader
--

CREATE VIEW order_schema.view_whale_trades AS
 WITH stats AS (
         SELECT trades.symbol,
            avg(trades.quantity) AS avg_qty
           FROM order_schema.trades
          GROUP BY trades.symbol
        )
 SELECT t.id,
    t.buy_order_id,
    t.sell_order_id,
    t.symbol,
    t.price,
    t.quantity,
    t.executed_at,
    s.avg_qty
   FROM (order_schema.trades t
     JOIN stats s ON (((t.symbol)::text = (s.symbol)::text)))
  WHERE (t.quantity > (s.avg_qty * (3)::numeric))
  ORDER BY t.executed_at DESC;


ALTER VIEW order_schema.view_whale_trades OWNER TO apextrader;

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
    balance numeric(18,8) DEFAULT 0.0,
    CONSTRAINT current_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE wallet_schema.wallets OWNER TO apextrader;

--
-- Name: user_portfolio_valuation; Type: MATERIALIZED VIEW; Schema: wallet_schema; Owner: apextrader
--

CREATE MATERIALIZED VIEW wallet_schema.user_portfolio_valuation AS
 WITH last_prices AS (
         SELECT DISTINCT ON (trades.symbol) trades.symbol,
            trades.price
           FROM order_schema.trades
          ORDER BY trades.symbol, trades.executed_at DESC
        )
 SELECT w.user_name,
    sum(
        CASE
            WHEN ((w.currency)::text = 'USD'::text) THEN w.balance
            ELSE (w.balance * COALESCE(lp.price, (0)::numeric))
        END) AS total_usd_valuation
   FROM (wallet_schema.wallets w
     LEFT JOIN last_prices lp ON (((lp.symbol)::text = ((w.currency)::text || '-USD'::text))))
  GROUP BY w.user_name
  WITH NO DATA;


ALTER MATERIALIZED VIEW wallet_schema.user_portfolio_valuation OWNER TO apextrader;

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
-- Name: roles id; Type: DEFAULT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.roles ALTER COLUMN id SET DEFAULT nextval('order_schema.roles_id_seq'::regclass);


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
3	1
4	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth_schema; Owner: apextrader
--

COPY auth_schema.users (id, user_name, password, created_at) FROM stdin;
3	wahidsaeed1	$2a$10$GGHLXOQQtFmR914RPJihUO.LvT252owdzueKwJSp1EsDDE5z1/3oi	2026-03-23 08:29:30.821744
4	mazharHameed1	$2a$10$scD25Tomt52H6IE5DwQ.huCeLO984WnenmnXywa7rbfO1xgvuasDK	2026-03-23 10:27:56.577626
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
1	wahidsaeed1	BTC-USD	BUY	500.00000000	FILLED	2026-03-23 10:27:17.675356
3	mazharHameed1	BTC-USD	SELL	0.03000000	FILLED	2026-03-23 10:34:29.186608
8	wahidsaeed1	BTC-USD	BUY	40000.00000000	FILLED	2026-03-26 12:39:37.018024
7	mazharHameed1	BTC-USD	SELL	40000.00000000	FILLED	2026-03-26 12:39:15.142633
201	mazharHameed1	BTC-USD	SELL	42000.00000000	FILLED	2026-03-24 10:00:00
202	wahidsaeed1	BTC-USD	BUY	42000.00000000	FILLED	2026-03-24 10:01:00
203	mazharHameed1	BTC-USD	SELL	43500.00000000	FILLED	2026-03-25 15:00:00
204	wahidsaeed1	BTC-USD	BUY	43500.00000000	FILLED	2026-03-25 15:05:00
10	wahidsaeed1	BTC-USD	BUY	40000.00000000	FILLED	2026-03-26 14:16:23.879812
9	mazharHameed1	BTC-USD	SELL	40000.00000000	FILLED	2026-03-26 14:10:27.125771
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: order_schema; Owner: apextrader
--

COPY order_schema.roles (id, name) FROM stdin;
\.


--
-- Data for Name: trades; Type: TABLE DATA; Schema: order_schema; Owner: apextrader
--

COPY order_schema.trades (id, buy_order_id, sell_order_id, symbol, price, quantity, executed_at) FROM stdin;
1	1	3	BTC-USD	500.00000000	1.00000000	2026-03-23 10:34:36.309969
2	8	7	BTC-USD	40000.00000000	0.50000000	2026-03-26 12:39:52.263964
4	202	201	BTC-USD	42000.00000000	1.00000000	2026-03-24 10:01:00
5	204	203	BTC-USD	43500.00000000	0.50000000	2026-03-25 15:05:00
6	10	9	BTC-USD	40000.00000000	0.50000000	2026-03-26 14:16:55.754238
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
7	wahidsaeed1	USD	60000.00000000
8	wahidsaeed1	BTC	1.70000000
9	mazharHameed1	USD	140000.00000000
10	mazharHameed1	BTC	0.20000000
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: auth_schema; Owner: apextrader
--

SELECT pg_catalog.setval('auth_schema.roles_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: auth_schema; Owner: apextrader
--

SELECT pg_catalog.setval('auth_schema.users_id_seq', 4, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: order_schema; Owner: apextrader
--

SELECT pg_catalog.setval('order_schema.orders_id_seq', 10, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: order_schema; Owner: apextrader
--

SELECT pg_catalog.setval('order_schema.roles_id_seq', 1, false);


--
-- Name: trades_id_seq; Type: SEQUENCE SET; Schema: order_schema; Owner: apextrader
--

SELECT pg_catalog.setval('order_schema.trades_id_seq', 6, true);


--
-- Name: wallets_id_seq; Type: SEQUENCE SET; Schema: wallet_schema; Owner: apextrader
--

SELECT pg_catalog.setval('wallet_schema.wallets_id_seq', 10, true);


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
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: order_schema; Owner: apextrader
--

ALTER TABLE ONLY order_schema.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


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
-- Name: users trg_assign_default_role; Type: TRIGGER; Schema: auth_schema; Owner: apextrader
--

CREATE TRIGGER trg_assign_default_role AFTER INSERT ON auth_schema.users FOR EACH ROW EXECUTE FUNCTION auth_schema.assign_default_role();


--
-- Name: users trg_initialize_wallets; Type: TRIGGER; Schema: auth_schema; Owner: apextrader
--

CREATE TRIGGER trg_initialize_wallets AFTER INSERT ON auth_schema.users FOR EACH ROW EXECUTE FUNCTION wallet_schema.initialize_user_wallets();


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
-- Name: user_portfolio_valuation; Type: MATERIALIZED VIEW DATA; Schema: wallet_schema; Owner: apextrader
--

REFRESH MATERIALIZED VIEW wallet_schema.user_portfolio_valuation;


--
-- PostgreSQL database dump complete
--







INSERT INTO auth_schema.users (user_name, password)
SELECT 
    'user_' || i, 
    '$2a$10$GGHLXOQQtFmR914RPJihUO.LvT252owdzueKwJSp1EsDDE5z1/3oi' -- Dummy hash
FROM generate_series(10, 115) AS i;


INSERT INTO order_schema.orders (user_name, symbol, side, price, status)
SELECT 
    CASE WHEN i % 2 = 0 THEN 'wahidsaeed1' ELSE 'mazharHameed1' END,
    'BTC-USD',
    CASE WHEN i % 2 = 0 THEN 'BUY' ELSE 'SELL' END,
    40000 + (i * 10), -- Varied pricing
    'FILLED'
FROM generate_series(10, 120) AS i;



INSERT INTO order_schema.trades (buy_order_id, sell_order_id, symbol, price, quantity, executed_at)
SELECT 
    8, 
    7, 
    'BTC-USD',
    40000 + (i % 50),
    0.005,
    NOW() - (i || ' minutes')::interval
FROM generate_series(1, 110) AS i;

