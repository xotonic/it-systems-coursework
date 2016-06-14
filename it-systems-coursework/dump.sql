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
    price_rub double precision
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
-- Data for Name: pc_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pc_models (id, id_producer, name, ram_gb, hdd_gb, cpu_core_num, cpu_clock_freq_hz, gpu_mem_mb) FROM stdin;
0	0	Aspire V5-650	8	1000	4	3	2048
1	0	Aspire V6-550	16	2000	8	3	4048
2	0	Aspire V7-950	16	4000	8	3	4048
3	6	iMac	8	1000	4	3	2048
4	6	iMac Pro	8	2000	8	3	2048
5	5	IxionPC	8	1000	4	3	2048
6	3	Palivion 320	8	2000	8	3	2048
7	10	Monster	32	4000	16	3	4000
8	11	CorolaPC	2	30	2	2	256
9	5	Azura	4	400	2	2.5	512
10	5	Azura	4	400	2	2.5	513
11	11	SupraPc	2	30	2	2	256
\.


--
-- Name: pc_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_models_id_seq', 1, false);


--
-- Data for Name: pc_objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pc_objects (id, id_model, price_rub) FROM stdin;
1	0	4000
2	1	80000
3	1	80000
4	2	120000
5	2	110000
6	3	90000
7	3	89000
8	3	89000
9	4	140000
0	4	140000
11	5	30000
12	5	30000
13	5	30000
17	6	50000
18	6	51999
19	7	400000
20	7	400000
21	11	30000
\.


--
-- Name: pc_objects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_objects_id_seq', 1, false);


--
-- Data for Name: pc_producers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pc_producers (id, name) FROM stdin;
0	Acer
1	PCI
2	Lenovo
3	HP
4	MSI
5	DEXP
6	Apple
7	Dell
8	Microsoft
9	Kek
10	Intel
11	Toyota
\.


--
-- Name: pc_producers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_producers_id_seq', 1, true);


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

