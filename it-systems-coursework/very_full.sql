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
-- Name: add_order(text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION add_order(pcustomer text, paddress text, plogin text, ppassword text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare userid int;
begin
select id from users into userid where login = plogin and password = ppassword;
insert into orders(starttime, user_id, customer, address) 
values (current_date, userid ,pcustomer, paddress);
Return;
end;
$$;


ALTER FUNCTION public.add_order(pcustomer text, paddress text, plogin text, ppassword text) OWNER TO postgres;

--
-- Name: attach_computer(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION attach_computer(integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
update  pc_objects set attached = $2 where id = $1;
end;
$_$;


ALTER FUNCTION public.attach_computer(integer, integer) OWNER TO postgres;

--
-- Name: attach_software(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION attach_software(integer, integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
update  sw_objects set attached = $2 where id = $1;
end;
$_$;


ALTER FUNCTION public.attach_software(integer, integer) OWNER TO postgres;

--
-- Name: cancel_order(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION cancel_order(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
update  pc_objects set sold = false, attached = null 
where attached = $1;
update sw_objects set sold = false, attached = null
where attached = $1;
delete from orders where id = $1;
end;
$_$;


ALTER FUNCTION public.cancel_order(integer) OWNER TO postgres;

--
-- Name: check_user(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION check_user(_login text, _password text) RETURNS TABLE(firstname text, secondname text, admin boolean)
    LANGUAGE plpgsql
    AS $$
begin
return query select users.firstname, users.secondname, users.admin from users where
users.login = _login and users.password = _password;
end;
$$;


ALTER FUNCTION public.check_user(_login text, _password text) OWNER TO postgres;

--
-- Name: close_order(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION close_order(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
update  pc_objects set sold = true, soldtime = current_date 
where attached = $1;
update sw_objects set sold = true, soldtime = current_date 
where attached = $1;
update orders set endtime = current_date where id = $1;
end;
$_$;


ALTER FUNCTION public.close_order(integer) OWNER TO postgres;

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
pc_objects.id_model = pc_models.id and
pc_objects.sold = false;
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
-- Name: delete_software(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION delete_software(id_object integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$ begin 
delete from sw_objects where id = $1;
Return;
end; $_$;


ALTER FUNCTION public.delete_software(id_object integer) OWNER TO postgres;

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
( pc_models.name like ('%' || $1 || '%') or pc_producers.name like ('%' || $1 || '%') ) and
pc_objects.sold = false;
--order by producer asc, name asc;
end;
 $_$;


ALTER FUNCTION public.find_computers(str text) OWNER TO postgres;

--
-- Name: find_orders(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_orders(str text, login text, password text) RETURNS TABLE(id integer, customer text, address text, opened date, closed date, id_user integer, firstname text, secondname text)
    LANGUAGE plpgsql
    AS $_$
begin

if ( (select count(*) from users where users.login=$2 and users.password=$3 and admin=true) = 0)
then
return query select 
orders.id as id,
orders.customer as customer,
orders.address as address,
orders.starttime as opened,
orders.endtime as closed,
users.id as id_user,
users.firstname as firstname,
users.secondname as secondname
from orders, users
where
orders.user_id = users.id and
users.login = $2 and
users.password = $3 and
( orders.customer like '%'|| $1 ||'%' or
  orders.address like '%'|| $1 ||'%');

else
return query select 
orders.id as id,
orders.customer as customer,
orders.address as address,
orders.starttime as opened,
orders.endtime as closed,
users.id as id_user,
users.firstname as firstname,
users.secondname as secondname
from orders, users
where
orders.user_id = users.id and
( orders.customer like '%'|| $1 ||'%' or
  orders.address like '%'|| $1 ||'%');
end if;

end;
 $_$;


ALTER FUNCTION public.find_orders(str text, login text, password text) OWNER TO postgres;

--
-- Name: find_software(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_software(str text) RETURNS TABLE(id_producer integer, id_model integer, id_object integer, producer text, model text, price_rub double precision)
    LANGUAGE plpgsql
    AS $_$
begin
return query select
sw_producers.id as id_producer,
sw_models.id as id_model,
sw_objects.id as id_object,
sw_producers.name as producer ,
sw_models.name as model,
sw_objects.price_rub as price_rub
from
sw_models,
sw_objects,
sw_producers
where
sw_models.id_producer = sw_producers.id and
sw_objects.id_model = sw_models.id and
( sw_models.name like ('%' || $1 || '%') or sw_producers.name like ('%' || $1 || '%') ) and
sw_objects.sold = false;
--order by producer asc, name asc;
end;
 $_$;


ALTER FUNCTION public.find_software(str text) OWNER TO postgres;

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
-- Name: insert_software(text, text, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION insert_software(producer text, model text, price double precision) RETURNS void
    LANGUAGE plpgsql
    AS $_$ begin 
if (select COUNT(*) from sw_producers where name = $1) = 0
then 
insert into sw_producers values ((select max(id)+1 from sw_producers), $1);
end if;

if (select COUNT(*) from sw_models where name = $2) = 0
then 
insert into sw_models values (
(select max(id)+1 from sw_models),
(select id from sw_producers where name = $1),
$2);
end if;

insert into sw_objects values (
(select max(id)+1 from sw_objects), 
(select id from sw_models where name = $2),
$3);

Return;
end; $_$;


ALTER FUNCTION public.insert_software(producer text, model text, price double precision) OWNER TO postgres;

--
-- Name: ordered_computers(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ordered_computers(integer) RETURNS TABLE(id integer, producer text, model text, price double precision)
    LANGUAGE plpgsql
    AS $_$
begin
return query select 
pc_objects.id as id,
pc_producers.name as producer,
pc_models.name as model,
pc_objects.price_rub as price
from pc_objects, pc_models, pc_producers
where 
pc_models.id_producer = pc_producers.id and
pc_objects.id_model = pc_models.id and
pc_objects.attached = $1;
end;
$_$;


ALTER FUNCTION public.ordered_computers(integer) OWNER TO postgres;

--
-- Name: ordered_software(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ordered_software(integer) RETURNS TABLE(id integer, producer text, model text, price double precision)
    LANGUAGE plpgsql
    AS $_$
begin
return query select 
sw_objects.id as id,
sw_producers.name as producer,
sw_models.name as model,
sw_objects.price_rub as price
from sw_objects, sw_models, sw_producers
where 
sw_models.id_producer = sw_producers.id and
sw_objects.id_model = sw_models.id and
sw_objects.attached = $1;
end;
$_$;


ALTER FUNCTION public.ordered_software(integer) OWNER TO postgres;

--
-- Name: period_computers(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION period_computers(_from date, _to date) RETURNS TABLE(producer text, model text, price double precision)
    LANGUAGE plpgsql
    AS $$
begin
return query select pc_producers.name as producer, pc_models.name as model, pc_objects.price_rub as price from pc_producers, pc_models, pc_objects where pc_objects.sold = true and pc_objects.soldtime >= _from and pc_objects.soldtime <= _to and pc_objects.id_model = pc_models.id and pc_models.id_producer = pc_producers.id;
end;
$$;


ALTER FUNCTION public.period_computers(_from date, _to date) OWNER TO postgres;

--
-- Name: period_software(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION period_software(_from date, _to date) RETURNS TABLE(producer text, model text, price double precision)
    LANGUAGE plpgsql
    AS $$
begin
return query select sw_producers.name as producer, sw_models.name as model, sw_objects.price_rub as price from sw_producers, sw_models, sw_objects where sw_objects.sold = true and sw_objects.soldtime >= _from and sw_objects.soldtime <= _to and sw_objects.id_model = sw_models.id and sw_models.id_producer = sw_producers.id;
end;
$$;


ALTER FUNCTION public.period_software(_from date, _to date) OWNER TO postgres;

--
-- Name: sell_computer(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sell_computer(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
update  pc_objects set sold = true where id = $1;
update  pc_objects set soldtime = current_date where id = $1;
end;
$_$;


ALTER FUNCTION public.sell_computer(integer) OWNER TO postgres;

--
-- Name: sell_software(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sell_software(integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
begin
update  sw_objects set sold = true where id = $1;
update  sw_objects set soldtime = current_date where id = $1;
end;
$_$;


ALTER FUNCTION public.sell_software(integer) OWNER TO postgres;

--
-- Name: software_all_with_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION software_all_with_id() RETURNS TABLE(id_producer integer, id_model integer, id_object integer, producer text, model text, price_rub double precision)
    LANGUAGE plpgsql
    AS $$
begin
return query select
sw_producers.id as id_producer,
sw_models.id as id_model,
sw_objects.id as id_object,
sw_producers.name as producer ,
sw_models.name as model,
sw_objects.price_rub as price_rub
from
sw_models,
sw_objects,
sw_producers
where
sw_models.id_producer = sw_producers.id and
sw_objects.id_model = sw_models.id and
sw_objects.sold = false;
--order by producer asc, name asc;
end;
 $$;


ALTER FUNCTION public.software_all_with_id() OWNER TO postgres;

--
-- Name: top_computers(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION top_computers() RETURNS TABLE(producer text, model text, count bigint)
    LANGUAGE plpgsql
    AS $$
begin
return query select pc_producers.name as producer, pc_models.name as model, count(pc_models.name ) from pc_producers, pc_models, pc_objects where pc_objects.sold = true  and pc_objects.id_model = pc_models.id and pc_models.id_producer = pc_producers.id group by producer, model order by count(pc_models.name) desc;
end;
$$;


ALTER FUNCTION public.top_computers() OWNER TO postgres;

--
-- Name: top_software(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION top_software() RETURNS TABLE(producer text, model text, count bigint)
    LANGUAGE plpgsql
    AS $$
begin
return query select sw_producers.name as producer, sw_models.name as model, count(sw_models.name ) from sw_producers, sw_models, sw_objects where sw_objects.sold = true  and sw_objects.id_model = sw_models.id and sw_models.id_producer = sw_producers.id group by producer, model order by count(sw_models.name) desc;
end;
$$;


ALTER FUNCTION public.top_software() OWNER TO postgres;

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

--
-- Name: update_software(integer, integer, integer, text, text, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION update_software(id_object integer, id_model integer, id_producer integer, producer text, model text, price double precision) RETURNS TABLE(idmobj integer, idmod integer, idpro integer)
    LANGUAGE plpgsql
    AS $_$ 
declare
idm int; idp int;
begin
idm := $2; idp := $3;
if ((select count(*) from sw_producers where id = id_producer and name = $4) = 0)
then
insert into sw_producers values ((select max(id)+1 from sw_producers), $4);
select max(id) into idp from sw_producers;
end if;
if ((select count(*) from sw_models where id = id_model and name = $5) = 0)
then
insert into sw_models values ((select max(id)+1 from sw_models), idp, $5);
select max(id) into idm from sw_models;
end if;

update sw_objects set price_rub=$6, id_model=idm where id = $1;

Return query select $1 as id_object, idm as id_model, idp as id_producer;
end; $_$;


ALTER FUNCTION public.update_software(id_object integer, id_model integer, id_producer integer, producer text, model text, price double precision) OWNER TO postgres;

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
    customer text DEFAULT '€­®­¨¬'::text,
    address text DEFAULT '¥¨§¢¥áâ­®'::text
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

COPY orders (id, starttime, endtime, user_id, customer, address) FROM stdin;
5	2016-06-16	2016-06-16	2	ÃÀÇØÒÎÐÌÏÐÎÌÑÀÏÎÃÈ	ñ. Ãîðþ÷åâî
3	2016-06-16	2016-06-16	2	ÍÃÒÓ	ÊÅÊ
6	2016-06-16	2016-06-16	2	Òóðíèð ïî äîòêå	Øòàá Äóíäè
7	2016-06-16	2016-06-16	2	Òóðíèð ïî îâåðâàò÷	Øòàá Ñàíüêà
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('orders_id_seq', 7, true);


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
12	5	KekGaming	4	500	4	3	1024
\.


--
-- Name: pc_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pc_models_id_seq', 1, false);


--
-- Data for Name: pc_objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY pc_objects (id, id_model, price_rub, sold, soldtime, attached) FROM stdin;
6	3	90000	f	\N	\N
9	4	140000	f	\N	\N
0	4	140000	f	\N	\N
11	5	30000	f	\N	\N
12	5	30000	f	\N	\N
13	5	30000	f	\N	\N
17	6	50000	f	\N	\N
18	6	51999	f	\N	\N
19	7	400000	f	\N	\N
20	7	400000	f	\N	\N
1	0	4000	f	2016-06-16	\N
21	11	30000	t	2016-06-16	5
2	1	80000	t	2016-06-16	3
3	1	80000	t	2016-06-16	3
4	2	120000	t	2016-06-16	3
5	2	110000	t	2016-06-16	3
8	3	89000	t	2016-06-16	3
7	3	89000	t	2016-06-16	3
31	12	25000	t	2016-06-16	6
30	12	25000	t	2016-06-16	6
29	12	25000	t	2016-06-16	6
28	12	25000	t	2016-06-16	6
27	12	25000	t	2016-06-16	6
26	12	25000	t	2016-06-16	6
25	12	25000	t	2016-06-16	6
24	12	25000	t	2016-06-16	6
23	12	25000	t	2016-06-16	6
22	12	25000	t	2016-06-16	6
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
-- Data for Name: sw_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sw_models (id, id_producer, name) FROM stdin;
1	2	Photoshop
2	2	SoundForge
3	2	Bridge
4	1	Office 2016
5	1	Windows Server 2012 RC
6	5	3ds Max
7	2	Photoshop CS3
8	6	ReSharper Ultimate
9	7	Overwatch
\.


--
-- Name: sw_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sw_models_id_seq', 5, true);


--
-- Data for Name: sw_objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sw_objects (id, id_model, price_rub, sold, soldtime, attached) FROM stdin;
1	7	2999	t	2016-06-16	5
4	8	40000	t	2016-06-16	3
3	6	29999	t	2016-06-16	3
5	9	1999	t	2016-06-16	7
6	9	1999	t	2016-06-16	7
7	9	1999	t	2016-06-16	7
8	9	1999	t	2016-06-16	7
9	9	1999	t	2016-06-16	7
10	9	1999	t	2016-06-16	7
11	9	1999	t	2016-06-16	7
12	9	1999	t	2016-06-16	7
13	9	1999	t	2016-06-16	7
14	9	1999	t	2016-06-16	7
\.


--
-- Name: sw_objects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sw_objects_id_seq', 1, false);


--
-- Data for Name: sw_producers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY sw_producers (id, name) FROM stdin;
1	Microsoft
2	Adobe
3	Mozilla
4	Kaspersky Lab.
5	Autodesk
6	JetBrains
7	Blizzard
\.


--
-- Name: sw_producers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('sw_producers_id_seq', 4, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, firstname, secondname, login, password, admin) FROM stdin;
1	ˆ¢ ­	Š «ëâîª	iogann	baltos	f
2	„¬¨âà¨©	Šã§ì¬¨­	xotonic	admin	t
\.


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

