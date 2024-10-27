-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 1.1.4
-- PostgreSQL version: 16.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: eltrans | type: DATABASE --
-- DROP DATABASE IF EXISTS eltrans;
CREATE DATABASE eltrans;
-- ddl-end --


-- object: public.trip | type: TABLE --
-- DROP TABLE IF EXISTS public.trip CASCADE;
CREATE TABLE public.trip (
	source varchar NOT NULL,
	destination varchar,
	start_time timestamp NOT NULL,
	end_time timestamp,
	vehicle varchar NOT NULL,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	trailer varchar,
	driver_id smallint NOT NULL,
	CONSTRAINT "TRIP_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.trip OWNER TO postgres;
-- ddl-end --

-- object: public.vehicle | type: TABLE --
-- DROP TABLE IF EXISTS public.vehicle CASCADE;
CREATE TABLE public.vehicle (
	vehicle_type smallint NOT NULL,
	number_plate varchar,
	fuel_capacity integer NOT NULL,
	fuel_type_id smallint NOT NULL,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	CONSTRAINT "VEHICLE_pk" PRIMARY KEY (id),
	CONSTRAINT unique_vehicle_plate UNIQUE NULLS NOT DISTINCT (number_plate)
);
-- ddl-end --
ALTER TABLE public.vehicle OWNER TO postgres;
-- ddl-end --

-- object: public.measurement | type: TABLE --
-- DROP TABLE IF EXISTS public.measurement CASCADE;
CREATE TABLE public.measurement (
	fuel_level float NOT NULL,
	"timestamp" timestamp NOT NULL,
	vehicle_id smallint NOT NULL,
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	CONSTRAINT "MEASUREMENT_pk" PRIMARY KEY (id)
);
-- ddl-end --
COMMENT ON COLUMN public.measurement."timestamp" IS E'timestamp instead of datetime to avoid time zone confusion';
-- ddl-end --
ALTER TABLE public.measurement OWNER TO postgres;
-- ddl-end --

-- object: public.trailer | type: TABLE --
-- DROP TABLE IF EXISTS public.trailer CASCADE;
CREATE TABLE public.trailer (
	fuel_capacity float,
	fuel_type_id smallint,
	number_plate varchar,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	CONSTRAINT "TRAILER_pk" PRIMARY KEY (id),
	CONSTRAINT unique_trailer_plate UNIQUE NULLS NOT DISTINCT (number_plate)
);
-- ddl-end --
ALTER TABLE public.trailer OWNER TO postgres;
-- ddl-end --

-- object: public.driver | type: TABLE --
-- DROP TABLE IF EXISTS public.driver CASCADE;
CREATE TABLE public.driver (
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	is_active bool NOT NULL,
	CONSTRAINT "DRIVER_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.driver OWNER TO postgres;
-- ddl-end --

-- object: public.sale | type: TABLE --
-- DROP TABLE IF EXISTS public.sale CASCADE;
CREATE TABLE public.sale (
	cost decimal NOT NULL,
	currency_code char(3) NOT NULL,
	location varchar,
	card_id smallint NOT NULL,
	vendor_id smallint NOT NULL,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	fuel_amount float,
	fuel_type_id smallint,
	CONSTRAINT "SALE_pk" PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.sale OWNER TO postgres;
-- ddl-end --

-- object: public.card | type: TABLE --
-- DROP TABLE IF EXISTS public.card CASCADE;
CREATE TABLE public.card (
	number varchar NOT NULL,
	owner_id smallint NOT NULL,
	vendor_id smallint NOT NULL,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	CONSTRAINT "CARD_pk" PRIMARY KEY (id),
	CONSTRAINT one_driver_one_vendor_one_card UNIQUE (owner_id,vendor_id),
	CONSTRAINT unique_numbers UNIQUE (number)
);
-- ddl-end --
ALTER TABLE public.card OWNER TO postgres;
-- ddl-end --

-- object: public.vendor | type: TABLE --
-- DROP TABLE IF EXISTS public.vendor CASCADE;
CREATE TABLE public.vendor (
	name varchar NOT NULL,
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	country varchar NOT NULL,
	tax_id varchar NOT NULL,
	CONSTRAINT "VENDOR_pk" PRIMARY KEY (id),
	CONSTRAINT unique_tax_id_in_country UNIQUE (country,tax_id)
);
-- ddl-end --
ALTER TABLE public.vendor OWNER TO postgres;
-- ddl-end --

-- object: public.fuel_type | type: TABLE --
-- DROP TABLE IF EXISTS public.fuel_type CASCADE;
CREATE TABLE public.fuel_type (
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar NOT NULL,
	CONSTRAINT fuel_types_pk PRIMARY KEY (id),
	CONSTRAINT unique_fuel_names UNIQUE (name)
);
-- ddl-end --
ALTER TABLE public.fuel_type OWNER TO postgres;
-- ddl-end --

-- object: public.vehicle_type | type: TABLE --
-- DROP TABLE IF EXISTS public.vehicle_type CASCADE;
CREATE TABLE public.vehicle_type (
	id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	name varchar NOT NULL,
	CONSTRAINT unique_type UNIQUE (name),
	CONSTRAINT vehicle_type_pk PRIMARY KEY (id)
);
-- ddl-end --
ALTER TABLE public.vehicle_type OWNER TO postgres;
-- ddl-end --

-- object: vehicle | type: CONSTRAINT --
-- ALTER TABLE public.trip DROP CONSTRAINT IF EXISTS vehicle CASCADE;
ALTER TABLE public.trip ADD CONSTRAINT vehicle FOREIGN KEY (vehicle)
REFERENCES public.vehicle (number_plate) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: trailer | type: CONSTRAINT --
-- ALTER TABLE public.trip DROP CONSTRAINT IF EXISTS trailer CASCADE;
ALTER TABLE public.trip ADD CONSTRAINT trailer FOREIGN KEY (trailer)
REFERENCES public.trailer (number_plate) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: driver | type: CONSTRAINT --
-- ALTER TABLE public.trip DROP CONSTRAINT IF EXISTS driver CASCADE;
ALTER TABLE public.trip ADD CONSTRAINT driver FOREIGN KEY (driver_id)
REFERENCES public.driver (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vehicle_fuel_type | type: CONSTRAINT --
-- ALTER TABLE public.vehicle DROP CONSTRAINT IF EXISTS vehicle_fuel_type CASCADE;
ALTER TABLE public.vehicle ADD CONSTRAINT vehicle_fuel_type FOREIGN KEY (fuel_type_id)
REFERENCES public.fuel_type (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vehicle_type | type: CONSTRAINT --
-- ALTER TABLE public.vehicle DROP CONSTRAINT IF EXISTS vehicle_type CASCADE;
ALTER TABLE public.vehicle ADD CONSTRAINT vehicle_type FOREIGN KEY (vehicle_type)
REFERENCES public.vehicle_type (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vehicle | type: CONSTRAINT --
-- ALTER TABLE public.measurement DROP CONSTRAINT IF EXISTS vehicle CASCADE;
ALTER TABLE public.measurement ADD CONSTRAINT vehicle FOREIGN KEY (vehicle_id)
REFERENCES public.vehicle (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: trailer_fuel_type | type: CONSTRAINT --
-- ALTER TABLE public.trailer DROP CONSTRAINT IF EXISTS trailer_fuel_type CASCADE;
ALTER TABLE public.trailer ADD CONSTRAINT trailer_fuel_type FOREIGN KEY (fuel_type_id)
REFERENCES public.fuel_type (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: card_used | type: CONSTRAINT --
-- ALTER TABLE public.sale DROP CONSTRAINT IF EXISTS card_used CASCADE;
ALTER TABLE public.sale ADD CONSTRAINT card_used FOREIGN KEY (card_id)
REFERENCES public.card (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vendor | type: CONSTRAINT --
-- ALTER TABLE public.sale DROP CONSTRAINT IF EXISTS vendor CASCADE;
ALTER TABLE public.sale ADD CONSTRAINT vendor FOREIGN KEY (vendor_id)
REFERENCES public.vendor (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: purchased_fuel_type | type: CONSTRAINT --
-- ALTER TABLE public.sale DROP CONSTRAINT IF EXISTS purchased_fuel_type CASCADE;
ALTER TABLE public.sale ADD CONSTRAINT purchased_fuel_type FOREIGN KEY (fuel_type_id)
REFERENCES public.fuel_type (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: card_owner | type: CONSTRAINT --
-- ALTER TABLE public.card DROP CONSTRAINT IF EXISTS card_owner CASCADE;
ALTER TABLE public.card ADD CONSTRAINT card_owner FOREIGN KEY (owner_id)
REFERENCES public.driver (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vendor | type: CONSTRAINT --
-- ALTER TABLE public.card DROP CONSTRAINT IF EXISTS vendor CASCADE;
ALTER TABLE public.card ADD CONSTRAINT vendor FOREIGN KEY (vendor_id)
REFERENCES public.vendor (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


