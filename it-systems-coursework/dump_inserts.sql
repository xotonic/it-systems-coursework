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
    id serial primary key,
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
    id serial primary key,
    id_model integer,
    price_rub double precision
);


ALTER TABLE pc_objects OWNER TO postgres;

--
-- Name: pc_producers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pc_producers (
    id serial primary key,
    name text
);


ALTER TABLE pc_producers OWNER TO postgres;

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


--
-- Data for Name: pc_objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO pc_objects VALUES (1, 0, 4000);
INSERT INTO pc_objects VALUES (2, 1, 80000);
INSERT INTO pc_objects VALUES (3, 1, 80000);
INSERT INTO pc_objects VALUES (4, 2, 120000);
INSERT INTO pc_objects VALUES (5, 2, 110000);
INSERT INTO pc_objects VALUES (6, 3, 90000);
INSERT INTO pc_objects VALUES (7, 3, 89000);
INSERT INTO pc_objects VALUES (8, 3, 89000);
INSERT INTO pc_objects VALUES (9, 4, 140000);
INSERT INTO pc_objects VALUES (0, 4, 140000);
INSERT INTO pc_objects VALUES (10, 4, 140000);
INSERT INTO pc_objects VALUES (11, 5, 30000);
INSERT INTO pc_objects VALUES (12, 5, 30000);
INSERT INTO pc_objects VALUES (13, 5, 30000);
INSERT INTO pc_objects VALUES (14, 5, 30000);
INSERT INTO pc_objects VALUES (15, 5, 30000);
INSERT INTO pc_objects VALUES (16, 5, 30000);
INSERT INTO pc_objects VALUES (17, 6, 50000);
INSERT INTO pc_objects VALUES (18, 6, 51999);


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

