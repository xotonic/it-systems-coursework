--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'WIN1251';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: computers_all(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION computers_all() RETURNS TABLE(producer text, model text, price_rub double precision, ram_gb double precision, hdd_gb double precision, cpu_core_num integer, cpu_clock_freq_ghz double precision, gpu_mem_gb double precision)
    LANGUAGE plpgsql
    AS $$
begin
return query select 
pc_producers.name as producer ,
pc_models.name as model,
pc_objects.price_rub as price_rub,
pc_models.ram_gb as ram_gb,
pc_models.hdd_gb as hdd_gb,
pc_models.cpu_core_num as cpu_core_num,
pc_models.cpu_clock_freq_hz as cpu_clock_freq_ghz,
pc_models.gpu_mem_mb as gpu_mem_gb
from
pc_models,
pc_objects,
pc_producers
where
pc_models.id_producer = pc_producers.id and
pc_objects.id_model = pc_models.id;
--order by producer asc, name asc;
end;
 $$;


ALTER FUNCTION public.computers_all() OWNER TO postgres;

--
-- Name: computers_all_with_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION computers_all_with_id() RETURNS TABLE(id_producer integer, id_model integer, id_object integer, producer text, model text, price_rub double precision, ram_gb double precision, hdd_gb double precision, cpu_core_num integer, cpu_clock_freq_ghz double precision, gpu_mem_gb double precision)
    LANGUAGE plpgsql
    AS $$
begin
return query select
pc_producers.id as id_producer,
pc_models.id as id_model,
pc_objects.id as id_object,
pc_producers.name as producer ,
pc_models.name as model,
pc_objects.price_rub as price_rub,
pc_models.ram_gb as ram_gb,
pc_models.hdd_gb as hdd_gb,
pc_models.cpu_core_num as cpu_core_num,
pc_models.cpu_clock_freq_hz as cpu_clock_freq_ghz,
pc_models.gpu_mem_mb as gpu_mem_gb
from
pc_models,
pc_objects,
pc_producers
where
pc_models.id_producer = pc_producers.id and
pc_objects.id_model = pc_models.id;
--order by producer asc, name asc;
end;
 $$;


ALTER FUNCTION public.computers_all_with_id() OWNER TO postgres;

--
-- Name: delete_computer(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_computer(id_object integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$ begin 
delete from pc_objects where id = $1;
Return;
end; $_$;


ALTER FUNCTION public.delete_computer(id_object integer) OWNER TO postgres;

--
-- Name: find_computers(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_computers(str text) RETURNS TABLE(id_producer integer, id_model integer, id_object integer, producer text, model text, price_rub double precision, ram_gb double precision, hdd_gb double precision, cpu_core_num integer, cpu_clock_freq_ghz double precision, gpu_mem_gb double precision)
    LANGUAGE plpgsql
    AS $_$
begin
return query select
pc_producers.id as id_producer,
pc_models.id as id_model,
pc_objects.id as id_object,
pc_producers.name as producer ,
pc_models.name as model,
pc_objects.price_rub as price_rub,
pc_models.ram_gb as ram_gb,
pc_models.hdd_gb as hdd_gb,
pc_models.cpu_core_num as cpu_core_num,
pc_models.cpu_clock_freq_hz as cpu_clock_freq_ghz,
pc_models.gpu_mem_mb as gpu_mem_gb
from
pc_models,
pc_objects,
pc_producers
where
pc_models.id_producer = pc_producers.id and
pc_objects.id_model = pc_models.id and
( pc_models.name like ('%' || $1 || '%') or pc_producers.name like ('%' || $1 || '%') );
--order by producer asc, name asc;
end;
 $_$;


ALTER FUNCTION public.find_computers(str text) OWNER TO postgres;

--
-- Name: insert_computer(text, text, double precision, double precision, double precision, integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_computer(producer text, model text, price double precision, ram double precision, hdd double precision, cores integer, freq double precision, gpu double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$ begin 
if (select COUNT(*) from pc_producers where name = $1) = 0
then 
insert into pc_producers values ((select max(id)+1 from pc_producers), $1);
end if;

if (select COUNT(*) from pc_models where name = $2 and $4 = ram_gb and $5 = hdd_gb and $6 = cpu_core_num and $7 = cpu_clock_freq_hz and $8 = gpu_mem_mb) = 0
then 
insert into pc_models values (
(select max(id)+1 from pc_models),
(select id from pc_producers where name = $1),
$2, $4, $5 ,$6, $7, $8);
end if;

insert into pc_objects values (
(select max(id)+1 from pc_objects), 
(select id from pc_models where name = $2),
$3);

Return;
end; $_$;


ALTER FUNCTION public.insert_computer(producer text, model text, price double precision, ram double precision, hdd double precision, cores integer, freq double precision, gpu double precision) OWNER TO postgres;

--
-- Name: update_computer(integer, integer, integer, text, text, double precision, double precision, double precision, integer, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_computer(id_object integer, id_model integer, id_producer integer, producer text, model text, price double precision, ram double precision, hdd double precision, cores integer, freq double precision, gpu double precision) RETURNS TABLE(idmobj integer, idmod integer, idpro integer)
    LANGUAGE plpgsql
    AS $_$ 
declare
idm int; idp int;
begin
idm := $2; idp := $3;
if ((select count(*) from pc_producers where id = id_producer and name = $4) = 0)
then
insert into pc_producers values ((select max(id)+1 from pc_producers), $4);
select max(id) into idp from pc_producers;
end if;
if ((select count(*) from pc_models where id = id_model and name = $5 and ram_gb = $7 and hdd_gb = $8 and cpu_core_num = $9 and cpu_clock_freq_hz = $10 and gpu_mem_mb = $11) = 0)
then
insert into pc_models values ((select max(id)+1 from pc_models), idp, $5, $7, $8, $9, $10, $11);
select max(id) into idm from pc_models;
end if;

update pc_objects set price_rub=$6, id_model=idm where id = $1;

Return query select $1 as id_object, idm as id_model, idp as id_producer;
end; $_$;


ALTER FUNCTION public.update_computer(id_object integer, id_model integer, id_producer integer, producer text, model text, price double precision, ram double precision, hdd double precision, cores integer, freq double precision, gpu double precision) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE orders (
    id integer NOT NULL,
    starttime date,
    endtime date,
    user_id integer NOT NULL,
    customer text DEFAULT 'Аноним'::text,
    address text DEFAULT 'Неизвестно'::text
);


ALTER TABLE orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: pc_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pc_models (
    id integer NOT NULL,
    id_producer integer,
    name text,
    ram_gb double precision,
    hdd_gb double precision,
    cpu_core_num integer,
    cpu_clock_freq_hz double precision,
    gpu_mem_mb double precision
);


ALTER TABLE pc_models OWNER TO postgres;

--
-- Name: pc_models_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pc_models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pc_models_id_seq OWNER TO postgres;

--
-- Name: pc_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pc_models_id_seq OWNED BY pc_models.id;


--
-- Name: pc_objects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pc_objects (
    id integer NOT NULL,
    id_model integer,
    price_rub double precision,
    sold boolean DEFAULT false,
    soldtime date,
    attached integer
);


ALTER TABLE pc_objects OWNER TO postgres;

--
-- Name: pc_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pc_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pc_objects_id_seq OWNER TO postgres;

--
-- Name: pc_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pc_objects_id_seq OWNED BY pc_objects.id;


--
-- Name: pc_producers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pc_producers (
    id integer NOT NULL,
    name text
);


ALTER TABLE pc_producers OWNER TO postgres;

--
-- Name: pc_producers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pc_producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pc_producers_id_seq OWNER TO postgres;

--
-- Name: pc_producers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pc_producers_id_seq OWNED BY pc_producers.id;


--
-- Name: sw_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sw_models (
    id integer NOT NULL,
    id_producer integer,
    name text
);


ALTER TABLE sw_models OWNER TO postgres;

--
-- Name: sw_models_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sw_models_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sw_models_id_seq OWNER TO postgres;

--
-- Name: sw_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sw_models_id_seq OWNED BY sw_models.id;


--
-- Name: sw_objects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sw_objects (
    id integer NOT NULL,
    id_model integer,
    price_rub double precision,
    sold boolean DEFAULT false,
    soldtime date,
    attached integer
);


ALTER TABLE sw_objects OWNER TO postgres;

--
-- Name: sw_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sw_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sw_objects_id_seq OWNER TO postgres;

--
-- Name: sw_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sw_objects_id_seq OWNED BY sw_objects.id;


--
-- Name: sw_producers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE sw_producers (
    id integer NOT NULL,
    name text
);


ALTER TABLE sw_producers OWNER TO postgres;

--
-- Name: sw_producers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sw_producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sw_producers_id_seq OWNER TO postgres;

--
-- Name: sw_producers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE sw_producers_id_seq OWNED BY sw_producers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    id integer NOT NULL,
    firstname text,
    secondname text,
    login text NOT NULL,
    password text NOT NULL,
    admin boolean DEFAULT false
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_models ALTER COLUMN id SET DEFAULT nextval('pc_models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_objects ALTER COLUMN id SET DEFAULT nextval('pc_objects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_producers ALTER COLUMN id SET DEFAULT nextval('pc_producers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_models ALTER COLUMN id SET DEFAULT nextval('sw_models_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_objects ALTER COLUMN id SET DEFAULT nextval('sw_objects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_producers ALTER COLUMN id SET DEFAULT nextval('sw_producers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO orders VALUES (1, '2016-06-14', '2016-06-15', 1, 'НГТУ', 'Немидовича-Данченоко 123');


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('orders_id_seq', 1, false);


--
-- Data for Name: pc_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO pc_models VALUES (0, 0, 'Aspire V5-650', 8, 1000, 4, 3, 2048);
INSERT INTO pc_models VALUES (1, 0, 'Aspire V6-550', 16, 2000, 8, 3, 4048);
INSERT INTO pc_models VALUES (2, 0, 'Aspire V7-950', 16, 4000, 8, 3, 4048);
INSERT INTO pc_models VALUES (3, 6, 'iMac', 8, 1000, 4, 3, 2048);
INSERT INTO pc_models VALUES (4, 6, 'iMac Pro', 8, 2000, 8, 3, 2048);
INSERT INTO pc_models VALUES (5, 5, 'IxionPC', 8, 1000, 4, 3, 2048);
INSERT INTO pc_models VALUES (6, 3, 'Palivion 320', 8, 2000, 8, 3, 2048);
INSERT INTO pc_models VALUES (7, 10, 'Monster', 32, 4000, 16, 3, 4000);
INSERT INTO pc_models VALUES (8, 11, 'CorolaPC', 2, 30, 2, 2, 256);
INSERT INTO pc_models VALUES (9, 5, 'Azura', 4, 400, 2, 2.5, 512);
INSERT INTO pc_models VALUES (10, 5, 'Azura', 4, 400, 2, 2.5, 513);
INSERT INTO pc_models VALUES (11, 11, 'SupraPc', 2, 30, 2, 2, 256);


--
-- Name: pc_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_models_id_seq', 1, false);


--
-- Data for Name: pc_objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO pc_objects VALUES (1, 0, 4000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (2, 1, 80000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (3, 1, 80000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (4, 2, 120000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (5, 2, 110000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (6, 3, 90000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (7, 3, 89000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (8, 3, 89000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (9, 4, 140000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (0, 4, 140000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (11, 5, 30000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (12, 5, 30000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (13, 5, 30000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (17, 6, 50000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (18, 6, 51999, false, NULL, NULL);
INSERT INTO pc_objects VALUES (19, 7, 400000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (20, 7, 400000, false, NULL, NULL);
INSERT INTO pc_objects VALUES (21, 11, 30000, false, NULL, NULL);


--
-- Name: pc_objects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_objects_id_seq', 1, false);


--
-- Data for Name: pc_producers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO pc_producers VALUES (0, 'Acer');
INSERT INTO pc_producers VALUES (1, 'PCI');
INSERT INTO pc_producers VALUES (2, 'Lenovo');
INSERT INTO pc_producers VALUES (3, 'HP');
INSERT INTO pc_producers VALUES (4, 'MSI');
INSERT INTO pc_producers VALUES (5, 'DEXP');
INSERT INTO pc_producers VALUES (6, 'Apple');
INSERT INTO pc_producers VALUES (7, 'Dell');
INSERT INTO pc_producers VALUES (8, 'Microsoft');
INSERT INTO pc_producers VALUES (9, 'Kek');
INSERT INTO pc_producers VALUES (10, 'Intel');
INSERT INTO pc_producers VALUES (11, 'Toyota');


--
-- Name: pc_producers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_producers_id_seq', 1, true);


--
-- Data for Name: sw_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sw_models VALUES (1, 2, 'Photoshop');
INSERT INTO sw_models VALUES (2, 2, 'SoundForge');
INSERT INTO sw_models VALUES (3, 2, 'Bridge');
INSERT INTO sw_models VALUES (4, 1, 'Office 2016');
INSERT INTO sw_models VALUES (5, 1, 'Windows Server 2012 RC');


--
-- Name: sw_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sw_models_id_seq', 5, true);


--
-- Data for Name: sw_objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sw_objects VALUES (1, 1, 999, false, '2016-06-15', 1);


--
-- Name: sw_objects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sw_objects_id_seq', 1, false);


--
-- Data for Name: sw_producers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO sw_producers VALUES (1, 'Microsoft');
INSERT INTO sw_producers VALUES (2, 'Adobe');
INSERT INTO sw_producers VALUES (3, 'Mozilla');
INSERT INTO sw_producers VALUES (4, 'Kaspersky Lab.');


--
-- Name: sw_producers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sw_producers_id_seq', 4, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users VALUES (1, 'Иван', 'Калытюк', 'iogann', 'baltos', false);
INSERT INTO users VALUES (2, 'Дмитрий', 'Кузьмин', 'xotonic', 'admin', true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pc_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_models
    ADD CONSTRAINT pc_models_pkey PRIMARY KEY (id);


--
-- Name: pc_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_objects
    ADD CONSTRAINT pc_objects_pkey PRIMARY KEY (id);


--
-- Name: pc_producers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_producers
    ADD CONSTRAINT pc_producers_pkey PRIMARY KEY (id);


--
-- Name: sw_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_models
    ADD CONSTRAINT sw_models_pkey PRIMARY KEY (id);


--
-- Name: sw_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_objects
    ADD CONSTRAINT sw_objects_pkey PRIMARY KEY (id);


--
-- Name: sw_producers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_producers
    ADD CONSTRAINT sw_producers_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fkmidp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_models
    ADD CONSTRAINT fkmidp FOREIGN KEY (id_producer) REFERENCES sw_producers(id);


--
-- Name: fkoidm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY sw_objects
    ADD CONSTRAINT fkoidm FOREIGN KEY (id_model) REFERENCES sw_models(id);


--
-- Name: fkpcoido; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_objects
    ADD CONSTRAINT fkpcoido FOREIGN KEY (attached) REFERENCES orders(id);


--
-- Name: pc_models_id_producer_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_models
    ADD CONSTRAINT pc_models_id_producer_fkey FOREIGN KEY (id_producer) REFERENCES pc_producers(id);


--
-- Name: pc_objects_id_model_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pc_objects
    ADD CONSTRAINT pc_objects_id_model_fkey FOREIGN KEY (id_model) REFERENCES pc_models(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

