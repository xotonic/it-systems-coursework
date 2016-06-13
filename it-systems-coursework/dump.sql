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
-- Name: pc_objects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pc_objects (
    id integer NOT NULL,
    id_model integer,
    price_rub double precision
);


ALTER TABLE pc_objects OWNER TO postgres;

--
-- Name: pc_producers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pc_producers (
    id integer NOT NULL,
    name text
);


ALTER TABLE pc_producers OWNER TO postgres;

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
\.


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
10	4	140000
11	5	30000
12	5	30000
13	5	30000
14	5	30000
15	5	30000
16	5	30000
17	6	50000
18	6	51999
\.


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
\.


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

