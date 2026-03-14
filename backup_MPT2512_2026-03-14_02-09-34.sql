--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

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
-- Name: person_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.person_type AS ENUM (
    'individual',
    'legal_entity'
);


ALTER TYPE public.person_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: base_education; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.base_education (
    id smallint NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.base_education OWNER TO postgres;

--
-- Name: contacts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    residence_address character varying(1000),
    home_phone character varying(50),
    contact_phone character varying(50) NOT NULL,
    work_phone character varying(50),
    email character varying(254),
    created_at timestamp without time zone DEFAULT now(),
    postal_code character varying(20),
    region character varying(200),
    city character varying(200)
);


ALTER TABLE public.contacts OWNER TO postgres;

--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.contacts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract (
    id bigint NOT NULL,
    contract_number character varying(200) NOT NULL,
    contract_date date NOT NULL,
    contract_type_id integer NOT NULL,
    program_id bigint NOT NULL,
    start_date date,
    end_date date,
    is_group boolean DEFAULT false NOT NULL,
    payer_id bigint NOT NULL,
    listener_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    itog_document_option_key character varying(50),
    time_option_key character varying(50),
    study_option_key character varying(50),
    signer_id integer,
    payment_option_key character varying(50)
);


ALTER TABLE public.contract OWNER TO postgres;

--
-- Name: contract_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.contract ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contract_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract_type (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    file_path character varying(1000) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.contract_type OWNER TO postgres;

--
-- Name: contract_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contract_type_id_seq OWNER TO postgres;

--
-- Name: contract_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_type_id_seq OWNED BY public.contract_type.id;


--
-- Name: education; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.education (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    enrollment_date date NOT NULL,
    base_education_id smallint,
    education_level_id smallint,
    series character varying(50),
    number character varying(100) NOT NULL,
    issue_date date NOT NULL,
    issued_by character varying(500) NOT NULL,
    place_of_issue character varying(500) NOT NULL,
    specialty character varying(300),
    created_at timestamp without time zone DEFAULT now(),
    city character varying(200)
);


ALTER TABLE public.education OWNER TO postgres;

--
-- Name: education_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.education ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.education_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: education_level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.education_level (
    id smallint NOT NULL,
    name character varying(100)
);


ALTER TABLE public.education_level OWNER TO postgres;

--
-- Name: gender; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gender (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.gender OWNER TO postgres;

--
-- Name: holiday_calendar_day; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.holiday_calendar_day (
    id bigint NOT NULL,
    holiday_date date NOT NULL,
    holiday_name character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.holiday_calendar_day OWNER TO postgres;

--
-- Name: holiday_calendar_day_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.holiday_calendar_day ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.holiday_calendar_day_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: learning_program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learning_program (
    id bigint NOT NULL,
    name character varying(500) NOT NULL,
    format character varying(200) NOT NULL,
    program_view_id integer NOT NULL,
    hours integer NOT NULL,
    lessons_count integer NOT NULL,
    price numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    image character varying(255),
    source_url character varying(500),
    CONSTRAINT learning_program_hours_check CHECK ((hours >= 0)),
    CONSTRAINT learning_program_lessons_count_check CHECK ((lessons_count >= 0)),
    CONSTRAINT learning_program_price_check CHECK ((price >= (0)::numeric))
);


ALTER TABLE public.learning_program OWNER TO postgres;

--
-- Name: COLUMN learning_program.source_url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.learning_program.source_url IS 'URL программы на сайте 25-12.ru';


--
-- Name: learning_program_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.learning_program ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.learning_program_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organization (
    organization_name character varying(500) NOT NULL,
    director_fio character varying(300) NOT NULL,
    ogrn character varying(13) NOT NULL,
    inn character varying(10) NOT NULL,
    kpp character varying(9) NOT NULL,
    legal_address character varying(1000) NOT NULL,
    email character varying(254),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    id bigint NOT NULL,
    CONSTRAINT kpp_format CHECK (((kpp)::text ~ '^[0-9]{9}$'::text)),
    CONSTRAINT ogrn_format CHECK (((ogrn)::text ~ '^[0-9]{13}$'::text)),
    CONSTRAINT org_inn_format CHECK (((inn)::text ~ '^[0-9]{10}$'::text))
);


ALTER TABLE public.organization OWNER TO postgres;

--
-- Name: organization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.organization ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: passport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passport (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    series character varying(10) NOT NULL,
    number character varying(10) NOT NULL,
    issuance_date date NOT NULL,
    issued_by character varying(500) NOT NULL,
    division_code character varying(20) NOT NULL,
    registration_date date NOT NULL,
    passport_valid_from date,
    created_at timestamp without time zone DEFAULT now(),
    registration_address character varying(1000)
);


ALTER TABLE public.passport OWNER TO postgres;

--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.passport ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.passport_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id bigint NOT NULL,
    last_name character varying(200) NOT NULL,
    first_name character varying(200) NOT NULL,
    patronymic character varying(200),
    date_of_birth date NOT NULL,
    gender_id smallint NOT NULL,
    place_of_birth character varying(500),
    citizenship character varying(200) NOT NULL,
    snils character varying(11) NOT NULL,
    inn character varying(12),
    workplace character varying(500),
    "position" character varying(200),
    contacts_id bigint,
    education_id bigint,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT inn_format CHECK (((inn IS NULL) OR ((inn)::text ~ '^[0-9]{10}([0-9]{2})?$'::text))),
    CONSTRAINT snils_format CHECK (((snils)::text ~ '^[0-9]{11}$'::text))
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.person ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: program_module; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_module (
    id bigint NOT NULL,
    program_id bigint NOT NULL,
    module_number integer NOT NULL,
    module_name character varying(500) NOT NULL,
    description text,
    hours integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.program_module OWNER TO postgres;

--
-- Name: TABLE program_module; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.program_module IS 'Модули программ обучения';


--
-- Name: COLUMN program_module.module_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.program_module.module_number IS 'Номер модуля по порядку';


--
-- Name: COLUMN program_module.module_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.program_module.module_name IS 'Название модуля';


--
-- Name: COLUMN program_module.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.program_module.description IS 'Описание модуля';


--
-- Name: COLUMN program_module.hours; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.program_module.hours IS 'Количество часов модуля';


--
-- Name: program_module_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_module_id_seq OWNER TO postgres;

--
-- Name: program_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_module_id_seq OWNED BY public.program_module.id;


--
-- Name: program_view; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_view (
    id integer NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.program_view OWNER TO postgres;

--
-- Name: program_view_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_view_id_seq OWNER TO postgres;

--
-- Name: program_view_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_view_id_seq OWNED BY public.program_view.id;


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher (
    id bigint NOT NULL,
    full_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.teacher OWNER TO postgres;

--
-- Name: TABLE teacher; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.teacher IS 'Таблица преподавателей';


--
-- Name: COLUMN teacher.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teacher.id IS 'Уникальный идентификатор преподавателя';


--
-- Name: COLUMN teacher.full_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teacher.full_name IS 'ФИО преподавателя';


--
-- Name: COLUMN teacher.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teacher.created_at IS 'Дата и время создания записи';


--
-- Name: COLUMN teacher.updated_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.teacher.updated_at IS 'Дата и время последнего обновления записи';


--
-- Name: teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teacher_id_seq OWNER TO postgres;

--
-- Name: teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_id_seq OWNED BY public.teacher.id;


--
-- Name: workload_batch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workload_batch (
    id bigint NOT NULL,
    program_id bigint NOT NULL,
    teacher_id bigint,
    group_name character varying(255),
    is_group boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.workload_batch OWNER TO postgres;

--
-- Name: workload_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workload_batch ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.workload_batch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workload_document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workload_document (
    id bigint NOT NULL,
    program_id bigint NOT NULL,
    teacher_id bigint,
    program_type character varying(255),
    file_name character varying(500) NOT NULL,
    file_path character varying(1000) NOT NULL,
    generated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    batch_id bigint,
    contract_id bigint,
    listener_id bigint,
    group_name character varying(255),
    is_group boolean DEFAULT false NOT NULL
);


ALTER TABLE public.workload_document OWNER TO postgres;

--
-- Name: workload_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workload_document ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.workload_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: workload_schedule_entry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workload_schedule_entry (
    id bigint NOT NULL,
    workload_document_id bigint NOT NULL,
    lesson_number integer NOT NULL,
    module_number integer,
    module_name character varying(500),
    topic text NOT NULL,
    lesson_date date,
    day_of_week character varying(50),
    start_time time without time zone,
    end_time time without time zone,
    hours integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.workload_schedule_entry OWNER TO postgres;

--
-- Name: workload_schedule_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.workload_schedule_entry ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.workload_schedule_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contract_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_type ALTER COLUMN id SET DEFAULT nextval('public.contract_type_id_seq'::regclass);


--
-- Name: program_module id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_module ALTER COLUMN id SET DEFAULT nextval('public.program_module_id_seq'::regclass);


--
-- Name: program_view id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_view ALTER COLUMN id SET DEFAULT nextval('public.program_view_id_seq'::regclass);


--
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.teacher_id_seq'::regclass);


--
-- Data for Name: base_education; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.base_education (id, name) FROM stdin;
1	Среднее
2	Среднее профиссиональное
3	Высшее
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contacts (id, residence_address, home_phone, contact_phone, work_phone, email, created_at, postal_code, region, city) FROM stdin;
2	\N	\N	78363784632	\N	ramil.khalikov@gmail.com	2025-12-04 15:48:11.205141	\N	\N	\N
3	\N	\N	12312312312	\N	Тест	2025-12-05 01:18:02.966039	\N	\N	\N
1	Россошанска дом 1, корпус 1 кв 577	\N	89852649299	\N	nikita.kudrov@gmail.com	2025-12-04 14:35:33.48862	117535	Москва	Москва
4	Ул. Красногвардейская	\N	79856589022	\N	rustam@gmail.com	2025-12-16 15:30:21.840626	378294	\N	Москва
5	Ул. Красногвардейская	\N	79856589022	\N	rustam@gmail.com	2025-12-16 15:32:21.155886	378294	\N	Москва
6	Ул. Красногвардейская	\N	79856589022	\N	rustam@gmail.com	2025-12-16 15:32:33.332056	378294	\N	Москва
7	Ул. Красногвардейская	-	79856589022	-	rustam@gmail.com	2025-12-16 15:33:36.885886	378294	-	Москва
8	Ул. Красногвардейская	-	79856589022	-	rustam@gmail.com	2025-12-16 15:33:43.814598	378294	-	Москва
9	Ул. Красногвардейская	\N	79856589022	\N	rustam@gmail.com	2025-12-16 15:34:13.781051	378294	\N	Москва
10	Ул. Красногвардейская	\N	79856589022	\N	rustam@gmail.com	2025-12-16 15:34:16.829712	378294	\N	Москва
11	Ул. Красногвардейская	\N	79856589022	\N	rustam@gmail.com	2025-12-16 15:35:49.877039	378294	\N	Москва
12	Ул. Центральная	\N	79009993344	\N	ivan@gmail.com	2025-12-16 15:39:15.113322	342524	\N	Москва
13	Ул. Центральная	\N	79009993344	\N	ivan@gmail.com	2025-12-16 15:39:35.26074	342524	\N	Москва
14	Ул. Центральная	\N	79009993344	\N	ivan@gmail.com	2025-12-16 15:39:46.809029	342524	\N	Москва
15	Ул. Центральная	\N	79009993344	\N	ivan@gmail.com	2025-12-16 15:40:39.61375	342524	\N	Москва
16	Москва	\N	89002344433	\N	ivan@gmail.com	2025-12-16 15:42:57.134712	342342	\N	Москва
18	Москва	\N	79006785433	\N	ivan@gmail.com	2025-12-16 15:56:54.873924	321533	\N	Москва
\.


--
-- Data for Name: contract; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract (id, contract_number, contract_date, contract_type_id, program_id, start_date, end_date, is_group, payer_id, listener_id, created_at, itog_document_option_key, time_option_key, study_option_key, signer_id, payment_option_key) FROM stdin;
1	ДОП-01 04.12.25	2025-12-04	1	1	2025-12-01	2025-12-06	f	1	1	2025-12-04 14:44:06.491289	\N	\N	\N	\N	\N
2	ДОП-02 04.12.25	2025-12-04	1	1	2025-12-06	2025-12-11	f	1	1	2025-12-04 14:49:27.476993	\N	\N	\N	\N	\N
3	ДОП-01	2025-12-04	1	1	2025-12-01	2025-12-18	f	1	1	2025-12-04 15:16:07.270582	\N	\N	\N	\N	\N
4	ДОП-03 04.12.25	2025-12-04	1	1	2025-12-07	2025-12-21	f	1	1	2025-12-04 15:20:04.768497	\N	\N	\N	\N	\N
5	ДОП-04 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-12	f	1	1	2025-12-04 15:25:09.156887	\N	\N	\N	\N	\N
6	ДОП-05 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-20	f	1	1	2025-12-04 15:28:19.470603	\N	\N	\N	\N	\N
7	ДОП-06 04.12.25	2025-12-04	1	1	2025-12-06	2025-12-19	f	1	1	2025-12-04 15:35:50.441851	\N	\N	\N	\N	\N
8	ДОП-07 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-20	f	1	1	2025-12-04 15:40:16.690284	\N	\N	\N	\N	\N
9	ДОП-08 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 15:52:43.941287	\N	\N	\N	\N	\N
10	ДОП-09 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 15:59:02.579784	\N	\N	\N	\N	\N
11	ДОП-10 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 16:02:10.965696	\N	\N	\N	\N	\N
12	ДОП-11 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 16:04:47.912124	\N	\N	\N	\N	\N
13	ДОП-12 04.12.25	2025-12-04	1	1	2025-11-27	2025-12-19	f	1	2	2025-12-04 16:07:45.550874	\N	\N	\N	\N	\N
14	ДОП-13 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 16:11:21.786903	\N	\N	\N	\N	\N
15	ДОП-14 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-18	f	1	2	2025-12-04 16:16:06.271075	\N	\N	\N	\N	\N
16	ДОП-15 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-18	f	1	2	2025-12-04 16:19:39.420111	\N	\N	\N	\N	\N
17	ДОП-16 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 16:22:13.188658	\N	\N	\N	\N	\N
18	ДОП-17 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-26	f	1	2	2025-12-04 16:24:19.021499	\N	\N	\N	\N	\N
19	ДОП-18 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-25	f	1	2	2025-12-04 16:26:12.540722	\N	\N	\N	\N	\N
20	ДОП-19 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-13	f	1	2	2025-12-04 16:28:13.544516	\N	\N	\N	\N	\N
21	ДОП-20 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-25	f	1	2	2025-12-04 16:49:35.112552	\N	\N	\N	\N	\N
22	ДОП-21 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 16:53:54.744243	\N	\N	\N	\N	\N
23	ДОП-22 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-18	f	1	2	2025-12-04 16:55:35.032765	\N	\N	\N	\N	\N
24	ДОП-23 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 16:58:25.797345	\N	\N	\N	\N	\N
25	ДОП-24 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:11:58.697791	\N	\N	\N	\N	\N
26	ДОП-25 04.12.25	2025-12-04	1	1	2025-11-29	2025-12-18	f	1	2	2025-12-04 17:12:46.206366	\N	\N	\N	\N	\N
27	ДОП-26 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:18:15.485863	\N	\N	\N	\N	\N
28	ДОП-27 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:19:37.371259	\N	\N	\N	\N	\N
29	ДОП-28 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:20:05.334361	\N	\N	\N	\N	\N
30	ДОП-29 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:20:47.657046	\N	\N	\N	\N	\N
31	ДОП-30 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:21:39.267052	\N	\N	\N	\N	\N
32	ДОП-31 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-09	f	1	2	2025-12-04 17:22:06.943117	\N	\N	\N	\N	\N
33	ДОП-32 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-19	f	1	2	2025-12-04 17:31:29.538968	\N	\N	\N	\N	\N
34	ДОП-33 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-31	f	1	2	2025-12-04 17:35:23.327714	\N	\N	\N	\N	\N
35	ДОП-34 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-18	f	1	2	2025-12-04 17:38:17.9524	\N	\N	\N	\N	\N
36	ДОП-35 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-10	f	1	2	2025-12-04 17:43:21.526173	\N	\N	\N	\N	\N
37	ДОП-36 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-09	f	1	2	2025-12-04 17:44:51.218935	\N	\N	\N	\N	\N
38	ДОП-37 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-10	f	1	2	2025-12-04 17:46:59.4217	\N	\N	\N	\N	\N
39	ДОП-38 04.12.25	2025-12-04	1	1	2025-12-13	2025-12-23	f	1	2	2025-12-04 17:48:10.460747	\N	\N	\N	\N	\N
40	ДОП-39 04.12.25	2025-12-04	1	1	2025-11-29	2025-12-20	f	1	2	2025-12-04 17:51:37.118545	\N	\N	\N	\N	\N
41	ДОП-40 04.12.25	2025-12-04	1	1	2025-12-04	2025-12-18	f	1	2	2025-12-04 17:54:07.311946	\N	\N	\N	\N	\N
42	ДОП-41 04.12.25	2025-12-04	1	1	2025-12-05	2025-12-12	f	1	2	2025-12-04 17:55:51.189765	\N	\N	\N	\N	\N
43	ДОП-01 05.12.25	2025-12-05	1	1	2025-12-02	2025-12-18	f	1	2	2025-12-05 01:14:04.800051	\N	\N	\N	\N	\N
44	ДОП-02 05.12.25	2025-12-05	1	1	2025-11-28	2025-12-19	f	1	2	2025-12-05 01:15:38.624077	\N	\N	\N	\N	\N
45	ДОП-42 05.12.25	2025-12-05	1	1	2025-12-04	2025-12-19	f	1	2	2025-12-05 14:55:34.495835	\N	\N	\N	\N	\N
46	ПК-01 05.12.25	2025-12-05	2	3	2025-12-03	2025-12-18	f	1	1	2025-12-05 16:51:21.694884	\N	\N	\N	\N	\N
47	ПК-02 05.12.25	2025-12-05	2	3	2025-12-04	2025-12-19	f	1	1	2025-12-05 16:55:24.686318	\N	\N	\N	\N	\N
48	ДОП-43 05.12.25	2025-12-05	1	1	2025-12-04	2025-12-19	f	1	2	2025-12-05 17:00:24.040275	\N	\N	\N	\N	\N
49	ПП-01 05.12.25	2025-12-05	4	2	2025-12-04	2025-12-19	f	1	1	2025-12-05 17:35:41.966577	\N	\N	\N	\N	\N
50	ДОП-44 05.12.25	2025-12-05	1	1	2025-12-04	2025-12-18	f	1	2	2025-12-05 18:18:10.209734	\N	\N	\N	\N	\N
51	ПП-02 08.12.25	2025-12-08	4	2	2025-12-04	2025-12-18	f	1	1	2025-12-08 12:06:04.041366	\N	\N	\N	\N	\N
52	ПП-03 08.12.25	2025-12-08	4	3	2025-12-04	2025-12-25	f	2	2	2025-12-08 12:15:53.471251	\N	\N	\N	\N	\N
53	ПК-03 08.12.25	2025-12-08	2	3	2025-12-04	2025-12-24	f	2	2	2025-12-08 12:27:47.858618	Option_Itog1	Option_Time1	Option_study1	1	option1
54	ПП-04 08.12.25	2025-12-08	4	2	2025-12-04	2025-12-17	f	1	1	2025-12-08 12:28:40.551647	Option_Itog1	Option_Time1	Option_study1	1	option1
55	ПП-05 08.12.25	2025-12-08	4	2	2025-12-04	2025-12-27	f	1	1	2025-12-08 12:29:26.893217	Option_Itog1	Option_Time1	Option_study1	1	option1
56	ПК-04 08.12.25	2025-12-08	2	3	2025-12-05	2025-12-24	f	1	1	2025-12-08 12:40:37.294091	Option_Itog1	Option_Time1	Option_study1	1	option1
57	ПП-06 08.12.25	2025-12-08	4	2	2025-12-10	2025-12-25	f	1	1	2025-12-08 12:46:35.074997	Option_Itog1	Option_Time1	Option_study1	1	option2
58	ДОП-45 08.12.25	2025-12-08	1	1	2025-12-08	2025-12-22	f	1	2	2025-12-08 15:16:16.16877	\N	\N	Option_study1	1	option1
59	ПП-07 08.12.25	2025-12-08	4	3	2025-12-10	2025-12-25	f	1	2	2025-12-08 15:51:20.719362	Option_Itog2	Option_Time3	Option_study1	2	option2
60	ПК-05 08.12.25	2025-12-08	2	2	2025-12-16	2025-12-23	f	1	1	2025-12-08 16:13:52.902702	Option_Itog1	Option_Time1	Option_study1	1	option1
61	ПК-06 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-15	f	1	1	2025-12-08 16:18:10.064585	Option_Itog1	Option_Time1	Option_study1	1	option1
62	ДОП-46 08.12.25	2025-12-08	1	1	2025-12-05	2025-12-17	f	1	2	2025-12-08 16:20:34.495697	\N	\N	Option_study1	1	option1
63	ПП-08 08.12.25	2025-12-08	4	3	2025-12-15	2025-12-18	f	1	1	2025-12-08 16:24:07.457761	Option_Itog1	Option_Time1	Option_study1	1	option1
64	ПК-07 08.12.25	2025-12-08	2	2	2025-12-09	2025-12-15	f	1	1	2025-12-08 16:30:25.623003	Option_Itog1	Option_Time1	Option_study1	1	option1
65	ПК-08 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-22	f	1	1	2025-12-08 16:40:08.930937	Option_Itog1	Option_Time1	Option_study1	1	option1
66	ПК-09 08.12.25	2025-12-08	2	2	2025-12-11	2025-12-16	f	1	1	2025-12-08 16:42:19.787509	Option_Itog1	Option_Time1	Option_study1	1	option1
67	ПК-10 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-22	f	1	1	2025-12-08 16:45:37.637472	Option_Itog1	Option_Time1	Option_study1	1	option1
68	ПК-11 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-15	f	1	1	2025-12-08 16:48:20.479432	Option_Itog1	Option_Time1	Option_study1	1	option1
69	ПК-12 08.12.25	2025-12-08	2	2	2025-12-11	2025-12-10	f	2	1	2025-12-08 16:50:33.334133	Option_Itog1	Option_Time1	Option_study1	1	option1
70	ПК-13 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-15	f	1	1	2025-12-08 16:53:57.94738	Option_Itog1	Option_Time1	Option_study1	1	option1
71	ПК-14 08.12.25	2025-12-08	2	2	2025-12-15	2025-12-16	f	1	1	2025-12-08 16:56:19.693754	Option_Itog1	Option_Time1	Option_study1	1	option1
72	ПП-09 08.12.25	2025-12-08	4	2	2025-12-08	2025-12-15	f	1	1	2025-12-08 16:57:56.638168	Option_Itog1	Option_Time1	Option_study1	1	option1
73	ПК-15 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-15	f	1	1	2025-12-08 17:01:18.135174	Option_Itog1	Option_Time1	Option_study1	3	option1
74	ПК-16 08.12.25	2025-12-08	2	2	2025-12-08	2025-12-15	f	1	1	2025-12-08 17:05:18.560663	Option_Itog2	Option_Time1	Option_study1	2	option2
75	ПП-10 08.12.25	2025-12-08	4	2	2025-12-12	2025-12-08	f	1	1	2025-12-08 17:12:05.927496	Option_Itog1	Option_Time1	Option_study1	1	option1
76	ПК-17 09.12.25	2025-12-09	2	3	2025-12-11	2025-12-19	f	1	1	2025-12-09 14:20:31.935119	Option_Itog1	Option_Time1	Option_study1	1	option2
77	ПК-18 09.12.25	2025-12-09	2	3	2025-12-10	2025-12-24	f	1	1	2025-12-09 14:27:36.691564	Option_Itog1	Option_Time1	Option_study1	1	option1
78	ПК-19 09.12.25	2025-12-09	2	3	2025-12-10	2025-12-24	f	1	1	2025-12-09 14:38:52.189436	Option_Itog1	Option_Time1	Option_study1	1	option1
79	ПК-20 09.12.25	2025-12-09	2	3	2025-12-11	2025-12-25	f	1	1	2025-12-09 14:39:53.972952	Option_Itog1	Option_Time1	Option_study1	1	option1
80	ПК-21 09.12.25	2025-12-09	2	3	2025-12-10	2025-12-26	f	1	1	2025-12-09 14:52:18.000242	Option_Itog1	Option_Time1	Option_study1	1	option1
81	ПК-22 09.12.25	2025-12-09	2	3	2025-12-11	2025-12-26	f	1	1	2025-12-09 15:08:30.582673	Option_Itog1	Option_Time1	Option_study1	1	option1
82	ПК-23 09.12.25	2025-12-09	2	3	2025-12-10	2025-12-19	f	1	1	2025-12-09 15:11:13.351308	Option_Itog1	Option_Time1	Option_study1	1	option1
83	ПК-24 09.12.25	2025-12-09	2	3	2025-12-11	2025-12-25	f	1	1	2025-12-09 15:13:53.932578	Option_Itog1	Option_Time1	Option_study1	1	option1
84	ПП-11 09.12.25	2025-12-09	4	2	2025-12-11	2025-12-17	f	1	1	2025-12-09 15:51:22.167372	Option_Itog1	Option_Time1	Option_study1	1	option1
85	ДОП-47 09.12.25	2025-12-09	1	2	2025-12-11	2025-12-25	f	1	2	2025-12-09 15:52:49.057145	Option_Itog1	Option_Time1	Option_study1	1	option1
86	ПП-12 09.12.25	2025-12-09	4	2	2025-12-04	2025-12-19	f	1	1	2025-12-09 15:56:50.302182	Option_Itog1	Option_Time1	Option_study1	1	option1
87	ПП-13 09.12.25	2025-12-09	4	2	2025-12-10	2025-12-26	f	1	1	2025-12-09 15:57:52.319589	Option_Itog1	Option_Time1	Option_study1	1	option1
88	ПП-14 09.12.25	2025-12-09	4	2	2025-12-04	2025-12-18	f	1	1	2025-12-09 15:59:55.287199	Option_Itog1	Option_Time1	Option_study1	1	option1
89	ПК-25 11.12.25	2025-12-11	2	2	2025-12-12	2025-12-26	f	1	1	2025-12-11 16:31:22.053073	Option_Itog2	Option_Time3	Option_study1	3	option1
90	ПК-26 11.12.25	2025-12-11	2	2	2025-12-12	2025-12-25	f	1	1	2025-12-11 16:35:20.899324	Option_Itog1	Option_Time1	Option_study1	1	option1
91	ПК-27 11.12.25	2025-12-11	2	2	2025-12-12	2025-12-26	f	2	2	2025-12-11 16:38:16.737998	Option_Itog1	Option_Time1	Option_study1	1	option1
92	ПК-28 11.12.25	2025-12-11	2	3	2025-12-05	2025-12-05	f	1	1	2025-12-11 16:42:49.637907	Option_Itog1	Option_Time1	Option_study1	1	option1
93	ПК-29 11.12.25	2025-12-11	2	3	2025-12-12	2025-12-26	f	1	1	2025-12-11 16:50:56.44193	Option_Itog1	Option_Time1	Option_study1	1	option1
94	ПК-30 11.12.25	2025-12-11	2	3	2025-12-12	2025-12-26	f	1	1	2025-12-11 16:54:45.21837	Option_Itog1	Option_Time1	Option_study1	1	option1
95	ПК-31 11.12.25	2025-12-11	2	3	2025-12-12	2025-12-26	f	1	1	2025-12-11 16:57:44.961116	Option_Itog1	Option_Time1	Option_study1	1	option1
96	ПК-32 11.12.25	2025-12-11	2	2	2025-12-12	2025-12-27	f	2	2	2025-12-11 17:04:38.165289	Option_Itog1	Option_Time1	Option_study1	1	option1
97	ПК-33 12.12.25	2025-12-12	2	2	2025-12-11	2025-12-25	f	1	1	2025-12-12 13:46:38.032043	Option_Itog1	Option_Time1	Option_study1	1	option1
98	ПК-34 12.12.25	2025-12-12	2	2	2025-12-13	2025-12-26	f	2	2	2025-12-12 13:49:57.862203	Option_Itog1	Option_Time1	Option_study1	1	option1
99	ПК-35 12.12.25	2025-12-12	2	2	2025-12-13	2025-12-27	f	2	2	2025-12-12 13:51:02.793338	Option_Itog1	Option_Time1	Option_study1	1	option1
100	ПК-36 12.12.25	2025-12-12	2	2	2025-12-11	2025-12-19	f	2	2	2025-12-12 13:53:34.210439	Option_Itog1	Option_Time1	Option_study1	1	option1
101	ПК-37 15.12.25	2025-12-15	2	2	2025-12-03	2025-12-25	f	2	2	2025-12-15 16:06:55.336259	Option_Itog2	Option_Time4	Option_study1	3	option2
102	ПП-15 15.12.25	2025-12-15	8	3	2025-12-12	2025-12-26	f	1	2	2025-12-15 16:08:22.172591	Option_Itog1	Option_Time1	Option_study1	1	option1
103	ПК-38 15.12.25	2025-12-15	9	2	2025-12-10	2025-12-30	f	1	2	2025-12-15 16:21:48.58395	Option_Itog1	Option_Time1	Option_study1	1	option1
104	ПП-16 15.12.25	2025-12-15	8	2	2025-12-11	2025-12-25	f	1	2	2025-12-15 16:26:24.716796	Option_Itog1	Option_Time1	Option_study1	1	option1
105	ПК-39 15.12.25	2025-12-15	9	3	2025-12-05	2025-12-14	f	1	2	2025-12-15 16:31:23.085406	Option_Itog1	Option_Time1	Option_study1	1	option1
106	ПП-17 15.12.25	2025-12-15	8	3	2025-12-17	2025-12-24	f	1	2	2025-12-15 16:33:49.16231	Option_Itog1	Option_Time1	Option_study1	1	option1
107	ПП-18 15.12.25	2025-12-15	8	2	2025-12-10	2025-12-24	f	1	2	2025-12-15 16:37:17.358585	Option_Itog1	Option_Time1	Option_study1	1	option1
108	ПК-40 15.12.25	2025-12-15	9	3	2025-12-24	2025-12-24	f	1	2	2025-12-15 16:38:16.386789	Option_Itog1	Option_Time1	Option_study1	1	option1
109	ПК-41 16.12.25	2025-12-16	2	2	2025-12-03	2025-12-18	f	1	1	2025-12-16 15:58:18.008096	Option_Itog1	Option_Time1	Option_study1	1	option1
110	ПК-42 16.12.25	2025-12-16	7	3	2025-12-04	2025-12-18	f	1	4	2025-12-16 16:40:28.265165	Option_Itog1	Option_Time1	Option_study1	1	option1
111	ПК-43 16.12.25	2025-12-16	7	2	2025-12-10	2025-12-25	f	1	4	2025-12-16 17:05:44.730649	Option_Itog1	Option_Time1	Option_study1	1	option1
112	ПП-19 16.12.25	2025-12-16	6	2	2025-12-06	2025-12-25	f	1	4	2025-12-16 17:13:11.960333	Option_Itog1	Option_Time1	Option_study1	1	option1
113	ПК-44 16.12.25	2025-12-16	7	2	2025-12-12	2025-12-27	f	1	4	2025-12-16 17:20:31.078022	Option_Itog1	Option_Time1	Option_study1	1	option1
114	ПК-45 16.12.25	2025-12-16	7	2	2025-12-04	2025-12-25	f	1	4	2025-12-16 17:30:11.191296	Option_Itog1	Option_Time1	Option_study1	1	option1
115	ПК-46 16.12.25	2025-12-16	7	2	2025-12-05	2025-12-26	f	1	4	2025-12-16 17:35:32.256741	Option_Itog1	Option_Time1	Option_study1	1	option1
116	ПК-47 16.12.25	2025-12-16	7	3	2025-12-12	2025-12-25	f	1	4	2025-12-16 17:37:10.406533	Option_Itog1	Option_Time1	Option_study1	1	option1
117	ПК-48 16.12.25	2025-12-16	2	2	2025-12-04	2025-12-19	f	1	1	2025-12-16 17:40:45.952035	Option_Itog1	Option_Time1	Option_study1	1	option1
118	ПК-49 16.12.25	2025-12-16	2	2	2025-12-12	2025-12-26	f	1	1	2025-12-16 17:46:44.225318	Option_Itog1	Option_Time1	Option_study1	1	option1
119	ПК-50 16.12.25	2025-12-16	7	2	2025-12-10	2025-12-19	f	1	4	2025-12-16 17:47:17.698242	Option_Itog1	Option_Time1	Option_study1	1	option1
120	ПК-51 16.12.25	2025-12-16	9	2	2025-12-11	2025-12-18	f	1	2	2025-12-16 17:48:16.447607	Option_Itog1	Option_Time1	Option_study1	1	option1
121	ПК-52 16.12.25	2025-12-16	9	2	2025-12-03	2025-12-19	f	1	2	2025-12-16 17:52:41.54013	Option_Itog1	Option_Time1	Option_study1	1	option1
122	ПП-20 16.12.25	2025-12-16	6	2	2025-12-05	2025-12-19	f	1	4	2025-12-16 17:53:47.501465	Option_Itog1	Option_Time1	Option_study1	1	option1
123	ДОП-48 16.12.25	2025-12-16	1	1	2025-12-03	2025-12-19	f	1	2	2025-12-16 18:17:54.12686	\N	\N	Option_study1	1	option1
124	ПК-53 16.12.25	2025-12-16	2	2	2025-12-04	2025-12-18	f	1	1	2025-12-16 18:19:21.328876	Option_Itog1	Option_Time1	Option_study1	1	option1
125	ПП-21 16.12.25	2025-12-16	8	3	2025-12-12	2025-12-26	f	1	2	2025-12-16 18:22:55.111322	Option_Itog2	Option_Time3	Option_study1	1	option2
126	ПП-22 16.12.25	2025-12-16	8	2	2025-12-11	2025-12-26	f	1	2	2025-12-16 18:26:12.857879	Option_Itog1	Option_Time1	Option_study1	1	option1
127	ПК-54 16.12.25	2025-12-16	9	2	2025-12-11	2025-12-12	f	1	2	2025-12-16 18:27:24.031519	Option_Itog1	Option_Time1	Option_study1	1	option1
128	ПК-55 16.12.25	2025-12-16	9	3	2025-12-11	2025-12-13	f	1	2	2025-12-16 18:28:43.318716	Option_Itog1	Option_Time1	Option_study1	1	option2
129	ПК-56 16.12.25	2025-12-16	2	2	2025-12-11	2025-12-25	f	1	1	2025-12-16 18:34:44.06278	Option_Itog1	Option_Time1	Option_study1	1	option1
130	ПК-57 16.12.25	2025-12-16	9	2	2025-12-06	2025-12-19	f	1	2	2025-12-16 18:41:28.07684	Option_Itog1	Option_Time1	Option_study1	1	option1
131	ПК-58 16.12.25	2025-12-16	9	2	2025-12-04	2025-12-18	f	1	2	2025-12-16 18:44:52.585589	Option_Itog1	Option_Time1	Option_study1	1	option1
132	ПК-59 16.12.25	2025-12-16	2	2	2025-12-10	2025-12-27	f	1	1	2025-12-16 18:45:33.357752	Option_Itog1	Option_Time1	Option_study1	1	option1
133	ПК-60 16.12.25	2025-12-16	2	2	2025-12-12	2025-12-26	f	1	1	2025-12-16 18:52:17.27556	Option_Itog1	Option_Time1	Option_study1	1	option1
134	ПК-61 16.12.25	2025-12-16	2	2	2025-12-12	2025-12-27	f	1	1	2025-12-16 18:54:08.87182	Option_Itog1	Option_Time1	Option_study1	1	option1
135	ПК-62 16.12.25	2025-12-16	2	2	2025-12-19	2025-12-26	f	1	1	2025-12-16 18:54:37.949654	Option_Itog1	Option_Time1	Option_study1	1	option2
136	ПК-63 16.12.25	2025-12-16	2	2	2025-12-10	2025-12-18	f	1	1	2025-12-16 18:56:44.686583	Option_Itog1	Option_Time1	Option_study1	1	option1
137	ПК-64 16.12.25	2025-12-16	2	2	2025-12-11	2025-12-26	f	1	1	2025-12-16 18:57:09.459432	Option_Itog1	Option_Time1	Option_study1	1	option2
138	ПК-65 16.12.25	2025-12-16	7	2	2025-12-05	2025-12-26	f	1	4	2025-12-16 19:02:55.603947	Option_Itog1	Option_Time1	Option_study1	1	option2
139	ПК-66 17.12.25	2025-12-17	2	2	2025-12-04	2025-12-19	f	1	1	2025-12-17 15:32:48.030033	Option_Itog2	Option_Time3	Option_study1	2	option2
140	ПП-23 18.12.25	2025-12-18	6	2	2025-12-10	2025-12-17	f	1	4	2025-12-18 12:17:11.395228	Option_Itog1	Option_Time1	Option_study1	1	option1
141	ПК-67 18.12.25	2025-12-18	2	2	2025-12-01	2025-12-16	f	1	1	2025-12-18 13:25:19.455923	Option_Itog1	Option_Time5	Option_study1	1	option1
142	ПК-68 18.12.25	2025-12-18	2	2	2025-12-03	2025-12-17	f	1	1	2025-12-18 13:32:46.062577	Option_Itog1	Option_Time5	Option_study1	1	option1
143	ПК-69 18.12.25	2025-12-18	2	2	2025-12-01	2025-12-22	f	1	1	2025-12-18 13:40:00.857529	Option_Itog1	Option_Time4	Option_study1	1	option1
144	ПК-70 18.12.25	2025-12-18	2	2	2025-12-10	2025-12-26	f	1	1	2025-12-18 13:45:01.908029	Option_Itog1	Option_Time4	Option_study1	1	option1
145	ПК-71 18.12.25	2025-12-18	2	2	2025-12-02	2025-12-23	f	1	1	2025-12-18 13:48:28.647409	Option_Itog1	Option_Time4	Option_study1	1	option1
146	ПК-72 18.12.25	2025-12-18	2	2	2025-12-02	2025-12-25	f	1	1	2025-12-18 13:51:14.273335	Option_Itog1	Option_Time5	Option_study1	1	option1
147	ПК-73 18.12.25	2025-12-18	2	2	2025-12-09	2025-12-15	f	1	1	2025-12-18 13:53:17.944072	Option_Itog1	Option_Time1	Option_study1	1	option1
148	ДОП-49 25.01.26	2026-01-25	1	1	2026-01-07	2026-01-21	f	1	2	2026-01-25 14:44:56.863937	\N	\N	Option_study1	1	option1
149	ПК-74 25.01.26	2026-01-25	2	1	2026-01-13	2026-01-22	f	1	1	2026-01-25 14:50:19.444483	Option_Itog1	Option_Time3	Option_study1	1	option1
150	ДОП-50 25.01.26	2026-01-25	1	1	2026-01-12	2026-01-23	f	1	2	2026-01-25 15:49:55.098039	\N	\N	Option_study1	1	option1
151	ДОП-51 25.01.26	2026-01-25	1	1	2026-01-07	2026-01-15	f	1	2	2026-01-25 15:57:45.460333	\N	\N	Option_study1	1	option1
152	ДОП-52 25.01.26	2026-01-25	1	1	2026-01-07	2026-01-15	f	1	2	2026-01-25 16:01:16.833069	\N	\N	Option_study1	1	option1
153	ДОП-53 25.01.26	2026-01-25	1	1	2026-01-15	2026-01-23	f	1	2	2026-01-25 16:02:14.383246	\N	\N	Option_study1	1	option1
154	ДОП-54 25.01.26	2026-01-25	1	1	2026-01-13	2026-01-29	f	1	2	2026-01-25 16:03:33.183857	\N	\N	Option_study1	1	option1
155	ДОП-55 25.01.26	2026-01-25	1	1	2026-01-08	2026-01-22	f	1	2	2026-01-25 16:17:09.313861	\N	\N	Option_study1	1	option1
156	ДОП-56 25.01.26	2026-01-25	1	1	2026-01-08	2026-01-22	f	1	2	2026-01-25 16:24:57.509443	\N	\N	Option_study1	1	option1
157	ДОП-57 26.01.26	2026-01-26	1	2	2026-01-22	2026-01-21	f	1	6	2026-01-26 14:29:27.478668	\N	\N	Option_study4	1	option1
158	ДОП-58 26.01.26	2026-01-26	1	1	2026-01-02	2026-01-15	f	1	4	2026-01-26 14:52:34.09529	\N	Option_Time1	Option_study1	1	option1
159	ДОП-59 26.01.26	2026-01-26	1	1	2026-01-17	2026-01-24	f	1	2	2026-01-26 14:56:49.969251	\N	Option_Time3	Option_study1	1	option1
160	ДОП-60 26.01.26	2026-01-26	1	1	2026-01-09	2026-01-23	f	1	6	2026-01-26 15:09:50.121383	Option_Itog1	Option_Time1	Option_study4	1	option1
161	ДОП-61 27.01.26	2026-01-27	1	1	2026-01-08	2026-01-23	f	1	6	2026-01-27 12:32:54.811337	\N	Option_Time1	Option_study5	1	option1
162	ДОП-62 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-16	f	1	6	2026-01-27 12:41:55.308268	\N	Option_Time1	Option_study3	1	option2
163	ДОП-63 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-21	f	1	6	2026-01-27 12:47:53.420654	\N	Option_Time1	Option_study4	1	option1
164	ДОП-64 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-21	f	1	6	2026-01-27 12:54:04.3969	\N	Option_Time1	Option_study2	1	option1
165	ДОП-65 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-22	f	1	2	2026-01-27 13:24:22.18885	\N	Option_Time1	Option_study2	1	option1
166	ДОП-66 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-23	f	1	2	2026-01-27 13:25:49.36293	\N	Option_Time1	Option_study2	1	option1
167	ДОП-67 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-22	f	1	2	2026-01-27 13:38:22.409874	\N	Option_Time1	Option_study4	1	option1
168	ДОП-68 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-21	f	1	6	2026-01-27 13:40:47.50967	\N	Option_Time1	Option_study2	1	option1
169	ДОП-69 27.01.26	2026-01-27	1	1	2026-01-07	2026-01-24	f	1	7	2026-01-27 13:43:14.383139	\N	Option_Time1	Option_study5	1	option1
170	ПК-75 27.01.26	2026-01-27	2	2	2026-01-10	2026-01-23	f	1	1	2026-01-27 13:45:30.87995	Option_Itog2	Option_Time3	Option_study1	2	option2
171	ДОП-70 27.01.26	2026-01-27	1	8	2026-01-08	2026-01-21	f	1	7	2026-01-27 14:03:40.808101	\N	Option_Time1	Option_study2	1	option1
172	ДОП-71 27.01.26	2026-01-27	1	7	2026-01-06	2026-01-22	f	1	2	2026-01-27 14:04:48.022848	\N	Option_Time1	Option_study4	1	option1
173	ПК-76 28.02.26	2026-02-28	2	2	2026-02-12	2026-02-26	f	1	1	2026-02-28 14:13:36.865942	Option_Itog1	Option_Time1	Option_study1	3	option1
174	ПП-24 28.02.26	2026-02-28	4	2	2026-02-03	2026-02-19	f	1	1	2026-02-28 14:18:33.466531	Option_Itog1	Option_Time1	Option_study1	2	option1
175	ПП-25 28.02.26	2026-02-28	4	3	2026-02-06	2026-02-27	f	1	1	2026-02-28 14:26:03.731214	Option_Itog1	Option_Time3	Option_study1	2	option1
176	ПП-26 28.02.26	2026-02-28	8	7	2026-02-12	2026-02-20	f	1	2	2026-02-28 14:52:07.421965	Option_Itog1	Option_Time4	Option_study1	1	option1
177	ПП-27 28.02.26	2026-02-28	6	7	2026-02-11	2026-02-26	f	1	2	2026-02-28 14:53:59.438178	Option_Itog1	Option_Time6	Option_study1	1	option1
178	ПК-77 28.02.26	2026-02-28	9	2	2026-02-05	2026-02-26	f	1	2	2026-02-28 14:58:56.549148	Option_Itog1	Option_Time2	Option_study1	1	option1
179	ПК-78 28.02.26	2026-02-28	7	2	2026-02-12	2026-02-19	f	1	2	2026-02-28 15:00:26.374394	Option_Itog2	Option_Time5	Option_study1	2	option2
180	ПП-28 28.02.26	2026-02-28	4	1	2026-02-12	2026-02-19	f	1	1	2026-02-28 15:04:41.304911	Option_Itog1	Option_Time1	Option_study1	3	option1
181	ПП-29 28.02.26	2026-02-28	6	1	2026-02-04	2026-02-20	f	1	2	2026-02-28 15:09:03.960683	Option_Itog1	Option_Time1	Option_study1	3	option1
182	ПК-79 28.02.26	2026-02-28	7	2	2026-02-04	2026-02-19	f	1	2	2026-02-28 15:10:22.597727	Option_Itog1	Option_Time1	Option_study1	2	option1
183	ПК-80 09.03.26	2026-03-09	9	416	2026-03-02	2026-07-27	f	1	2	2026-03-09 16:11:07.385748	Option_Itog1	Option_Time1	Option_study1	1	option1
184	ПК-81 09.03.26	2026-03-09	9	416	2026-03-02	2026-07-27	f	1	4	2026-03-09 16:24:14.600183	Option_Itog1	Option_Time1	Option_study1	1	option1
185	ПП-30 10.03.26	2026-03-10	4	3	2026-03-10	2026-03-25	f	1	2	2026-03-10 16:40:34.386301	Option_Itog1	Option_Time1	Option_study1	1	option1
\.


--
-- Data for Name: contract_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract_type (id, name, file_path) FROM stdin;
1	Договор ДОП физических лиц (трёхсторонний)	C:\\Dogovora\\Договор ДОП физ лиц.docx
2	Договор ПК физических лиц (двухсторонний)	C:\\Dogovora\\Договор ПК физ лиц.docx
4	Договор ПП физических лиц (двухсторонний)	C:\\Dogovora\\Договор ПП физ лиц.docx
6	Договор ПП юридических лиц (трёхсторонний)	C:\\Dogovora\\Договор_пп_юр_лиц_трехсторонний.docx
7	Договор ПК юридических лиц (трёхсторонний)	C:\\Dogovora\\Договор_пк_юр_лиц_трехсторонний.docx
8	Договор ПП физических лиц (трёхсторонний)	C:\\Dogovora\\Договор ПП физ лиц трёхсторонний.docx
9	Договор ПК физических лиц (трёхсторонний)	C:\\Dogovora\\Договор ПК физ лиц трёхсторонний.docx
\.


--
-- Data for Name: education; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.education (id, person_id, enrollment_date, base_education_id, education_level_id, series, number, issue_date, issued_by, place_of_issue, specialty, created_at, city) FROM stdin;
2	2	2025-10-10	1	\N	\N	3527535	2025-10-24	Школа 1	Школа 1	\N	2025-12-04 15:48:11.277486	\N
1	1	2025-12-03	3	1	637492	2840924	2025-11-28	МГУ	МГУ	Программист	2025-12-04 14:35:33.673945	Москва
17	4	2025-07-18	3	1	321324	2412422	2025-09-03	РЭУ РФ	Москва	Бизнес информатика	2025-12-16 15:56:55.038899	Москва
\.


--
-- Data for Name: education_level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.education_level (id, name) FROM stdin;
1	Бакалавр
2	Магистратура
3	Сециалист
\.


--
-- Data for Name: gender; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gender (id, name) FROM stdin;
1	Мужской
2	Женский
3	Не указан
\.


--
-- Data for Name: holiday_calendar_day; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.holiday_calendar_day (id, holiday_date, holiday_name, created_at) FROM stdin;
1	2026-03-09	8 марта	2026-03-09 15:37:06.41586
2	2026-05-01	День труда	2026-03-09 15:39:04.132539
3	2026-05-11	9 мая	2026-03-09 15:39:29.762503
4	2026-06-12	День России	2026-03-09 15:39:45.648507
\.


--
-- Data for Name: learning_program; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learning_program (id, name, format, program_view_id, hours, lessons_count, price, created_at, image, source_url) FROM stdin;
1	Разработка игровых продуктов на Unity	С преподавателем в группе	1	256	160	146000.00	2025-12-04 14:41:44.389411	https://clck.ru/3QfxmS	\N
416	Компьютерное зрение и искусственный интеллект на Python	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:13:50.12371	\N	https://25-12.ru/courses/%d0%ba%d0%be%d0%bc%d0%bf%d1%8c%d1%8e%d1%82%d0%b5%d1%80%d0%bd%d0%be%d0%b5-%d0%b7%d1%80%d0%b5%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b8%d1%81%d0%ba%d1%83%d1%81%d1%81%d1%82%d0%b2%d0%b5%d0%bd%d0%bd%d1%8b%d0%b9-2/
2	Разработка кроссплатформенных мобильных приложений на Flutter	Индивидуально с преподавателем	2	256	144	288000.00	2025-12-04 18:25:25.64275	https://clck.ru/3Qfynr	\N
3	Разработка REST API и интеграция с клиентской частью WEB-приложений	Индивидуально с преподавателем	3	40	40	76000.00	2025-12-04 18:28:50.623118	https://clck.ru/3QfytE	\N
417	Аналитика и проектирование цифровых систем	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:13:51.647879	\N	https://25-12.ru/courses/%d0%b0%d0%bd%d0%b0%d0%bb%d0%b8%d1%82%d0%b8%d0%ba%d0%b0-%d0%b8-%d0%bf%d1%80%d0%be%d0%b5%d0%ba%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d1%86%d0%b8%d1%84%d1%80%d0%be%d0%b2%d1%8b%d1%85-2/
418	Аналитика и проектирование цифровых систем	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:13:52.475486	\N	https://25-12.ru/courses/%d0%b0%d0%bd%d0%b0%d0%bb%d0%b8%d1%82%d0%b8%d0%ba%d0%b0-%d0%b8-%d0%bf%d1%80%d0%be%d0%b5%d0%ba%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d1%86%d0%b8%d1%84%d1%80%d0%be%d0%b2%d1%8b%d1%85/
419	Компьютерное зрение и искусственный интеллект на Python	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:13:53.326257	\N	https://25-12.ru/courses/%d0%ba%d0%be%d0%bc%d0%bf%d1%8c%d1%8e%d1%82%d0%b5%d1%80%d0%bd%d0%be%d0%b5-%d0%b7%d1%80%d0%b5%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b8%d1%81%d0%ba%d1%83%d1%81%d1%81%d1%82%d0%b2%d0%b5%d0%bd%d0%bd%d1%8b%d0%b9/
420	Разработка игровых продуктов на Unity	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:13:54.925713	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%b8%d0%b3%d1%80%d0%be%d0%b2%d1%8b%d1%85-%d0%bf%d1%80%d0%be%d0%b4%d1%83%d0%ba%d1%82%d0%be%d0%b2-%d0%bd%d0%b0-unity-2/
7	Blender Junior: первые шаги в 3D	Индивидуально с преподавателем	1	20	20	40000.00	2026-01-27 13:51:54.262707	https://clck.ru/3RUpFW	\N
8	Junior AI: искусственный интеллект своими руками	С преподавателем в группе	1	20	20	20000.00	2026-01-27 13:53:13.738099	https://clck.ru/3RUpNx	\N
421	Разработка корпоративных приложений на Java	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:13:55.77003	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%ba%d0%be%d1%80%d0%bf%d0%be%d1%80%d0%b0%d1%82%d0%b8%d0%b2%d0%bd%d1%8b%d1%85-%d0%bf%d1%80%d0%b8%d0%bb%d0%be%d0%b6%d0%b5%d0%bd%d0%b8-2/
422	Разработка корпоративных приложений на Java	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:13:56.885996	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%ba%d0%be%d1%80%d0%bf%d0%be%d1%80%d0%b0%d1%82%d0%b8%d0%b2%d0%bd%d1%8b%d1%85-%d0%bf%d1%80%d0%b8%d0%bb%d0%be%d0%b6%d0%b5%d0%bd%d0%b8%d0%b9/
423	Backend-разработка на JavaScript (Node.js, Express)	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:13:57.710147	\N	https://25-12.ru/courses/backend-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-javascript-node-js-express-%d0%ba%d0%b2%d0%b0%d0%bb%d0%b8%d1%84%d0%b8%d0%ba%d0%b0%d1%86%d0%b8%d1%8f-%d0%ba%d0%b2%d0%b0/
424	Backend-разработка на JavaScript (Node.js, Express)	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:13:58.5323	\N	https://25-12.ru/courses/backend-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-javascript-node-js-express/
425	Frontend‑разработка на JavaScript (React.js)	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:13:59.393509	\N	https://25-12.ru/courses/frontend%e2%80%91%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-javascript-react-js-%d0%ba%d0%b2%d0%b0%d0%bb%d0%b8%d1%84%d0%b8%d0%ba%d0%b0%d1%86%d0%b8%d1%8f-%d0%ba%d0%b2/
426	Frontend‑разработка на JavaScript (React.js)	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:00.223582	\N	https://25-12.ru/courses/frontend%e2%80%91%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-javascript-react-js-%d0%ba%d0%b2%d0%b0%d0%bb%d0%b8%d1%84%d0%b8%d0%ba%d0%b0%d1%86%d0%b8%d1%8f-%d1%80%d0%b0/
427	Автоматизированное тестирование на Python	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:14:01.704036	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%bd%d0%be%d0%b5-%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0/
428	Автоматизированное тестирование на Python	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:02.536906	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%bd%d0%be%d0%b5-%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-pytho/
429	Python в DevOps и автоматизация инфраструктуры	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:14:03.381925	\N	https://25-12.ru/courses/python-%d0%b2-devops-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b8%d0%bd%d1%84%d1%80%d0%b0%d1%81%d1%82%d1%80%d1%83%d0%ba%d1%82%d1%83%d1%80%d1%8b/
430	Python в DevOps и автоматизация инфраструктуры	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:04.210131	\N	https://25-12.ru/courses/python-%d0%b2-devops-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b8%d0%bd%d1%84%d1%80%d0%b0%d1%81%d1%82%d1%80%d1%83%d0%ba%d1%82%d1%83%d1%80%d1%8b-%d1%81/
431	Машинное обучение и основы искусственного интеллекта на Python	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:14:05.04361	\N	https://25-12.ru/courses/%d0%bc%d0%b0%d1%88%d0%b8%d0%bd%d0%bd%d0%be%d0%b5-%d0%be%d0%b1%d1%83%d1%87%d0%b5%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%be%d1%81%d0%bd%d0%be%d0%b2%d1%8b-%d0%b8%d1%81%d0%ba%d1%83%d1%81%d1%81%d1%82%d0%b2-%d0%ba/
432	Машинное обучение и основы искусственного интеллекта на Python	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:05.872101	\N	https://25-12.ru/courses/%d0%bc%d0%b0%d1%88%d0%b8%d0%bd%d0%bd%d0%be%d0%b5-%d0%be%d0%b1%d1%83%d1%87%d0%b5%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%be%d1%81%d0%bd%d0%be%d0%b2%d1%8b-%d0%b8%d1%81%d0%ba%d1%83%d1%81%d1%81%d1%82%d0%b2%d0%b5/
433	Data Science на Python: анализ и визуализация данных	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:14:07.294113	\N	https://25-12.ru/courses/data-science-%d0%bd%d0%b0-python-%d0%b0%d0%bd%d0%b0%d0%bb%d0%b8%d0%b7-%d0%b8-%d0%b2%d0%b8%d0%b7%d1%83%d0%b0%d0%bb%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b4%d0%b0%d0%bd%d0%bd%d1%8b%d1%85-%d0%ba-%d0%ba/
434	Data Science на Python: анализ и визуализация данных	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:08.281145	\N	https://25-12.ru/courses/data-science-%d0%bd%d0%b0-python-%d0%b0%d0%bd%d0%b0%d0%bb%d0%b8%d0%b7-%d0%b8-%d0%b2%d0%b8%d0%b7%d1%83%d0%b0%d0%bb%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b4%d0%b0%d0%bd%d0%bd%d1%8b%d1%85-%d0%ba/
435	Разработка WEB-приложений на Python (Django)	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:14:09.132157	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-web-%d0%bf%d1%80%d0%b8%d0%bb%d0%be%d0%b6%d0%b5%d0%bd%d0%b8%d0%b9-%d0%bd%d0%b0-python-django-individually/
436	Разработка WEB-приложений на Python (Django)	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:10.060711	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-web-%d0%bf%d1%80%d0%b8%d0%bb%d0%be%d0%b6%d0%b5%d0%bd%d0%b8%d0%b9-%d0%bd%d0%b0-python-django-%d0%ba%d0%b2%d0%b0%d0%bb%d0%b8%d1%84%d0%b8/
437	Разработка и автоматизация на Python	Индивидуально с преподавателем	2	256	144	288000.00	2026-03-04 00:14:10.89308	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bd%d0%b0-python-%d0%ba%d0%b2%d0%b0%d0%bb%d0%b8-in/
438	Разработка и автоматизация на Python	С преподавателем в группе	2	256	144	144000.00	2026-03-04 00:14:11.723376	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bd%d0%b0-python-%d0%bf%d1%80%d0%be%d0%b3%d1%80/
439	Работа с базами данных и интеграция с backend	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:12.554709	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d1%81%d0%b5%d1%80%d0%b2%d0%b5%d1%80%d0%bd%d0%be%d0%b9-%d1%87%d0%b0%d1%81%d1%82%d0%b8-%d0%bf%d1%80%d0%b8%d0%bb%d0%be%d0%b6%d0%b5%d0%bd-indi/
440	Работа с базами данных и интеграция с backend	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:15.316838	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d1%81%d0%b5%d1%80%d0%b2%d0%b5%d1%80%d0%bd%d0%be%d0%b9-%d1%87%d0%b0%d1%81%d1%82%d0%b8-%d0%bf%d1%80%d0%b8%d0%bb%d0%be%d0%b6%d0%b5%d0%bd/
441	React.js: компоненты, состояние и маршрутизация	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:15.864152	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-%d1%84%d1%80%d0%b5%d0%b9%d0%bc%d0%b2%d0%be%d1%80%d0%ba%d0%b5-react-js-individually/
442	React.js: компоненты, состояние и маршрутизация	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:16.438946	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-%d1%84%d1%80%d0%b5%d0%b9%d0%bc%d0%b2%d0%be%d1%80%d0%ba%d0%b5-react-js/
443	Основы веба и базовый JavaScript	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:17.514822	\N	https://25-12.ru/courses/javascript-%d0%b4%d0%bb%d1%8f-frontend-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b8-individually/
444	Основы веба и базовый JavaScript	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:18.670572	\N	https://25-12.ru/courses/javascript-%d0%b4%d0%bb%d1%8f-frontend-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b8/
445	Основы JavaScript и серверная среда Node.js	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:19.221692	\N	https://25-12.ru/courses/%d0%bf%d1%80%d0%be%d0%b3%d1%80%d0%b0%d0%bc%d0%bc%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-%d1%8f%d0%b7%d1%8b%d0%ba%d0%b5-javascript-individually/
446	Основы JavaScript и серверная среда Node.js	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:19.777709	\N	https://25-12.ru/courses/%d0%bf%d1%80%d0%be%d0%b3%d1%80%d0%b0%d0%bc%d0%bc%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-%d1%8f%d0%b7%d1%8b%d0%ba%d0%b5-javascript/
447	Современная вёрстка: HTML5, CSS3, адаптивность и инструменты	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:20.345752	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-web-%d1%81%d1%82%d1%80%d0%b0%d0%bd%d0%b8%d1%86-%d0%bd%d0%b0-html-%d0%b8-css-individually/
448	Современная вёрстка: HTML5, CSS3, адаптивность и инструменты	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:21.80279	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-web-%d1%81%d1%82%d1%80%d0%b0%d0%bd%d0%b8%d1%86-%d0%bd%d0%b0-html-%d0%b8-css/
449	Автоматизация DevOps-процессов на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:22.356924	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-devops-%d0%bf%d1%80%d0%be%d1%86%d0%b5%d1%81%d1%81%d0%be%d0%b2-%d0%bd%d0%b0-python-individually/
450	Автоматизация DevOps-процессов на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:23.041873	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-devops-%d0%bf%d1%80%d0%be%d1%86%d0%b5%d1%81%d1%81%d0%be%d0%b2-%d0%bd%d0%b0-python/
451	3D-моделирование и визуализация в Blender	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:23.647171	\N	https://25-12.ru/courses/3d-%d0%bc%d0%be%d0%b4%d0%b5%d0%bb%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%b2-blender-individually/
452	3D-моделирование и визуализация в Blender	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:24.200021	\N	https://25-12.ru/courses/3d-%d0%bc%d0%be%d0%b4%d0%b5%d0%bb%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%b2-blender/
453	Автоматизация тестирования на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:24.772697	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d1%8f-%d0%bd%d0%b0-python-individually/
454	Автоматизация тестирования на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:25.322903	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d1%8f-%d0%bd%d0%b0-python/
455	DevOps для QA: инфраструктура, CI/CD и масштабирование	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:25.920457	\N	https://25-12.ru/courses/api-%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bd%d0%b0-python-individually/
456	DevOps для QA: инфраструктура, CI/CD и масштабирование	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:26.472557	\N	https://25-12.ru/courses/api-%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bd%d0%b0-python/
457	Основы тестирования и ручное QA	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:27.709776	\N	https://25-12.ru/courses/%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bd%d0%b0-python-individually/
458	Основы тестирования и ручное QA	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:28.463099	\N	https://25-12.ru/courses/%d1%82%d0%b5%d1%81%d1%82%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%b8-%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bd%d0%b0-python/
459	Работа с Docker и Kubernetes	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:29.01341	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%b0-%d1%81-docker-%d0%b8-kubernetes-individually/
460	Работа с Docker и Kubernetes	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:29.562619	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%b0-%d1%81-docker-%d0%b8-kubernetes/
461	Python для DevOps	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:30.118835	\N	https://25-12.ru/courses/python-%d0%b4%d0%bb%d1%8f-devops-individually/
462	Python для DevOps	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:30.699287	\N	https://25-12.ru/courses/python-%d0%b4%d0%bb%d1%8f-devops/
463	Визуализация данных на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:31.252772	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bf%d0%b0%d0%b9%d0%bf%d0%bb%d0%b0%d0%b9%d0%bd%d0%be%d0%b2-%d0%b8-%d0%bf%d0%be%d0%b4%d0%b3%d0%be%d1%82%d0%be%d0%b2-indi/
464	Визуализация данных на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:31.807868	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bf%d0%b0%d0%b9%d0%bf%d0%bb%d0%b0%d0%b9%d0%bd%d0%be%d0%b2-%d0%b8-%d0%bf%d0%be%d0%b4%d0%b3%d0%be%d1%82%d0%be%d0%b2/
465	Основы машинного обучения на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:32.357687	\N	https://25-12.ru/courses/%d0%bc%d0%b0%d1%88%d0%b8%d0%bd%d0%bd%d0%be%d0%b5-%d0%be%d0%b1%d1%83%d1%87%d0%b5%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-python-individually/
466	Основы машинного обучения на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:32.950819	\N	https://25-12.ru/courses/%d0%bc%d0%b0%d1%88%d0%b8%d0%bd%d0%bd%d0%be%d0%b5-%d0%be%d0%b1%d1%83%d1%87%d0%b5%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-python/
467	Анализ данных на Python (Pandas, NumPy)	Индивидуально с преподавателем	3	72	36	72000.00	2026-03-04 00:14:34.397514	\N	https://25-12.ru/courses/%d0%b2%d0%b8%d0%b7%d1%83%d0%b0%d0%bb%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b4%d0%b0%d0%bd%d0%bd%d1%8b%d1%85-%d0%bd%d0%b0-python-matplotlib-seaborn-individually/
468	Анализ данных на Python (Pandas, NumPy)	С преподавателем в группе	3	72	36	36000.00	2026-03-04 00:14:35.022745	\N	https://25-12.ru/courses/%d0%b2%d0%b8%d0%b7%d1%83%d0%b0%d0%bb%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b4%d0%b0%d0%bd%d0%bd%d1%8b%d1%85-%d0%bd%d0%b0-python-matplotlib-seaborn/
469	Автоматизация процессов в WEB-разработке на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:35.572344	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bf%d1%80%d0%be%d1%86%d0%b5%d1%81%d1%81%d0%be%d0%b2-%d0%b2-web-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82-indivi/
470	Автоматизация процессов в WEB-разработке на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:36.126544	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%bf%d1%80%d0%be%d1%86%d0%b5%d1%81%d1%81%d0%be%d0%b2-%d0%b2-web-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba/
471	Работа с базами данных в Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:36.679937	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%b0-%d1%81-%d0%b1%d0%b0%d0%b7%d0%b0%d0%bc%d0%b8-%d0%b4%d0%b0%d0%bd%d0%bd%d1%8b%d1%85-%d0%b2-python-individually/
472	Работа с базами данных в Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:37.238629	\N	https://25-12.ru/courses/%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%b0-%d1%81-%d0%b1%d0%b0%d0%b7%d0%b0%d0%bc%d0%b8-%d0%b4%d0%b0%d0%bd%d0%bd%d1%8b%d1%85-%d0%b2-python/
473	WEB-разработка на Python (Django)	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:37.809086	\N	https://25-12.ru/courses/web-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-python-django-individually/
474	WEB-разработка на Python (Django)	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:38.376767	\N	https://25-12.ru/courses/web-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-python-django/
475	Автоматизация задач разработки на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:38.930862	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b7%d0%b0%d0%b4%d0%b0%d1%87-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b8-%d0%bd%d0%b0-python-individua/
476	Автоматизация задач разработки на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:39.492635	\N	https://25-12.ru/courses/%d0%b0%d0%b2%d1%82%d0%be%d0%bc%d0%b0%d1%82%d0%b8%d0%b7%d0%b0%d1%86%d0%b8%d1%8f-%d0%b7%d0%b0%d0%b4%d0%b0%d1%87-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b8-%d0%bd%d0%b0-python/
477	WEB-разработка на Python (Flask)	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:40.905962	\N	https://25-12.ru/courses/web-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-python-flask-individually/
478	WEB-разработка на Python (Flask)	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:41.456637	\N	https://25-12.ru/courses/web-%d1%80%d0%b0%d0%b7%d1%80%d0%b0%d0%b1%d0%be%d1%82%d0%ba%d0%b0-%d0%bd%d0%b0-python-flask/
479	Продвинутое программирование на Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:42.023933	\N	https://25-12.ru/courses/%d0%bf%d1%80%d0%be%d0%b4%d0%b2%d0%b8%d0%bd%d1%83%d1%82%d0%be%d0%b5-%d0%bf%d1%80%d0%be%d0%b3%d1%80%d0%b0%d0%bc%d0%bc%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-python-individually/
480	Продвинутое программирование на Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:42.578031	\N	https://25-12.ru/courses/%d0%bf%d1%80%d0%be%d0%b4%d0%b2%d0%b8%d0%bd%d1%83%d1%82%d0%be%d0%b5-%d0%bf%d1%80%d0%be%d0%b3%d1%80%d0%b0%d0%bc%d0%bc%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-python/
481	Программирование на языке Python	Индивидуально с преподавателем	3	60	36	72000.00	2026-03-04 00:14:43.13635	\N	https://25-12.ru/courses/%d0%bf%d1%80%d0%be%d0%b3%d1%80%d0%b0%d0%bc%d0%bc%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-%d1%8f%d0%b7%d1%8b%d0%ba%d0%b5-python-individually/
482	Программирование на языке Python	С преподавателем в группе	3	60	36	36000.00	2026-03-04 00:14:43.732901	\N	https://25-12.ru/courses/%d0%bf%d1%80%d0%be%d0%b3%d1%80%d0%b0%d0%bc%d0%bc%d0%b8%d1%80%d0%be%d0%b2%d0%b0%d0%bd%d0%b8%d0%b5-%d0%bd%d0%b0-%d1%8f%d0%b7%d1%8b%d0%ba%d0%b5-python/
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organization (organization_name, director_fio, ogrn, inn, kpp, legal_address, email, phone, created_at, updated_at, id) FROM stdin;
Общество с ограниченной ответственностью «Барашек»	Мержоев Ахмед Микаилович	8348283482734	3247324783	324927437	Г. Москва ул. Нахимовский пр-т 20	ahmed@gmail.com	79002234451	2025-12-16 16:05:34.447108	\N	1
\.


--
-- Data for Name: passport; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passport (id, person_id, series, number, issuance_date, issued_by, division_code, registration_date, passport_valid_from, created_at, registration_address) FROM stdin;
1	1	4519	536157	2025-12-01	ГУ МВД по г.Москве	649-826	2025-12-02	\N	2025-12-04 14:35:33.657108	г. Москва
2	2	7319	247263	2025-05-16	ГУ МВД по Ульяновской области	365-294	2025-09-10	\N	2025-12-04 15:48:11.261395	Муратовка
4	4	3223	435436	2024-07-18	ГУ МВД по г. Москве	234-768	2025-02-19	\N	2025-12-16 15:56:55.010426	Москва
5	6	4525	312231	2025-12-17	ГУ МВД по г.Москве	321-532	2017-06-07	\N	2026-01-25 14:18:55.323227	г. Москва
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (id, last_name, first_name, patronymic, date_of_birth, gender_id, place_of_birth, citizenship, snils, inn, workplace, "position", contacts_id, education_id, created_at, updated_at) FROM stdin;
2	Халиков	Рамиль	Наимович	2025-01-07	1	Муратовка	Российская Федерация	63628437222	\N	\N	\N	2	\N	\N	2025-12-05 01:18:43.780002
1	Кудров	Никита	Николаевич	2024-05-09	1	г. Москва	Российская Федерация	12312312323	\N	\N	\N	1	\N	\N	2025-12-08 13:41:47.750922
4	Иванов	Иван	Иванович	2016-03-10	1	Москва	Российская Федерация	43568645745	555666777888	ООО "Барашек"	\N	18	\N	2025-12-16 15:56:54.871463	2025-12-16 15:57:36.48661
6	Иванов	Тест	Иванович	2016-07-14	1	Москва	Российская Федерация	12312312312	\N	\N	\N	\N	\N	2026-01-25 14:16:47.878653	2026-01-26 14:29:04.53848
7	Петров	Петр	Петрович	2015-06-04	1	Город Москва	Российская Федерация	44455566677	\N	\N	\N	\N	\N	2026-01-27 13:42:42.582345	2026-01-27 13:42:42.583291
\.


--
-- Data for Name: program_module; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_module (id, program_id, module_number, module_name, description, hours, created_at, updated_at) FROM stdin;
1	416	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Функции в Python: основы\n18. Практическая работа №9. Создание пользовательских функций\n19. Передача аргументов, *args, **kwargs\n20. Практическая работа №10. Работа с *args и **kwargs\n21. Работа с файлами: чтение и запись\n22. Практическая работа №11. Работа с файлами: чтение и запись данных\n23. Работа с CSV и JSON файлами\n24. Практическая работа №12. Чтение и запись данных в CSV и JSON\n25. Обработка ошибок и исключения\n26. Практическая работа №13. Обработка ошибок в программах\n27. Регулярные выражения (re)\n28. Практическая работа №14. Поиск и замена данных с использованием regex\n29. Основы ООП в Python\n30. Практическая работа №15. Создание классов и объектов\n31. Наследование и полиморфизм\n32. Практическая работа №16. Реализация наследования в Python\n33. Генераторы списков и lambda-функции\n34. Практическая работа №17. Оптимизация кода с генераторами\n35. Модули и виртуальные окружения\n36. Практическая работа №18. Создание и использование venv	\N	\N	\N
2	416	2	Модуль 2. Анализ и обработка данных на Python	1. Введение в анализ данных и Big Data\n2. Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook\n3. Основы работы с библиотекой NumPy\n4. Практическая работа №2. Создание и манипуляции с многомерными массивами\n5. Основы работы с библиотекой Pandas\n6. Практическая работа  №3. Загрузка и первичный анализ структурированных данных\n7. Чтение и запись данных в форматах CSV, JSON, Parquet\n8. Практическая работа №4. Импорт и экспорт данных с использованием Pandas\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов\n11. Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy\n12. Практическая работа №6. Выполнение SQL-запросов из Python-скриптов\n13. Фильтрация и сортировка данных в Pandas\n14. Практическая работа №7. Отбор строк и столбцов по условию\n15. Группировка данных и агрегация\n16. Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)\n17. Сводные таблицы и кросстабуляции\n18. Практическая работа №9. Построение аналитических сводок по категориальным данным\n19. Объединение и слияние датафреймов\n20. Практическая работа №10. Объединение таблиц по ключам (join/merge)\n21. Работа с временными рядами\n22. Практическая работа №11. Преобразование строковых дат и агрегация по периодам\n23. Обработка пропущенных данных\n24. Практическая работа №12. Поиск, удаление и импутация пропусков\n25. Работа с выбросами и аномалиями\n26. Практическая работа №13. Выявление выбросов методами IQR и Z-score\n27. Кодирование категориальных признаков\n28. Практическая работа №14. One-hot и label-кодирование\n29. Нормализация и стандартизация данных\n30. Практическая работа №15. Масштабирование признаков для ML-моделей\n31. Работа с большими наборами данных\n32. Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки\n33. Визуализация данных с помощью Matplotlib\n34. Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков\n35. Визуализация данных с помощью Seaborn\n36. Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N
3	416	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	1. Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)\n2. Практическая работа №1. Постановка ML-задач на основе реальных датасетов\n3. Подготовка данных для машинного обучения\n4. Практическая работа №2. Разделение данных на обучающую и тестовую выборки\n5. Обучение первой модели: линейная регрессия\n6. Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn\n7. Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall\n8. Практическая работа №4. Оценка качества моделей на тестовой выборке\n9. Классификация: логистическая регрессия и kNN\n10. Практическая работа №5. Решение задач бинарной и многоклассовой классификации\n11. Деревья решений и случайный лес\n12. Практическая работа №6. Обучение и визуализация дерева решений\n13. Кластеризация: K-Means и иерархическая кластеризация\n14. Практическая работа №7. Группировка клиентов или объектов без разметки\n15. Работа с несбалансированными данными\n16. Практическая работа  №8. Применение oversampling (SMOTE) и undersampling\n17. Кросс-валидация и подбор гиперпараметров\n18. Практическая работа №9. Подбор параметров с помощью GridSearchCV\n19. Основы нейросетей: перцептрон и многослойные сети\n20. Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow\n21. Обучение нейросетей на табличных данных\n22. Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками\n23. Введение в нейросети для обработки изображений\n24. Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL\n25. Сверточные нейронные сети (CNN): архитектура и принцип работы\n26. Практическая работа №13. Построение первой CNN для классификации CIFAR-10\n27. Обучение CNN на собственном датасете\n28. Практическая работа №14. Подготовка изображений и обучение модели под задачу\n29. Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)\n30. Практическая работа №15. Применение аугментации и регуляризации в Keras\n31. Использование предобученных моделей (Transfer Learning)\n32. Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу\n33. Оценка и интерпретация моделей компьютерного зрения\n34. Практическая работа №17. Визуализация активаций и ошибок предсказаний\n35. Применение сквозного ML-пайплайна для задачи классификации изображений\n36. Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N
4	416	4	Модуль 4. Компьютерное зрение и обработка больших данных	1. Введение в компьютерное зрение: задачи и применения\n2. Практическая работа №1. Установка OpenCV и загрузка изображений\n3. Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету\n4. Работа с изображениями: цветовые пространства, каналы, гистограммы\n5. Фильтрация и шумоподавление: Gaussian, Median, Bilateral\n6. Практическая работа №3. Улучшение качества изображений с OpenCV\n7. Геометрические преобразования: масштабирование, поворот, аффинные преобразования\n8. Практическая работа №4. Коррекция перспективы и выравнивание объектов\n9. Обнаружение границ и контуров (Canny, Sobel, Laplacian)\n10. Практическая работа №5. Поиск и отрисовка контуров объектов\n11. Сегментация изображений: пороговая, адаптивная, watershed\n12. Практическая работа №6. Выделение фона и переднего плана\n13. Обнаружение объектов: метод скользящего окна, Haar-каскады\n14. Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов\n15. Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)\n16. Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)\n17. Работа с видео: чтение, запись, обработка кадров\n18. Практическая работа №9. Обнаружение движущихся объектов в видеопотоке\n19. Обработка больших объёмов изображений (пакетная обработка)\n20. Практическая работа №10. Создание пайплайна для обработки тысяч изображений\n21. Анализ структурированных и полуструктурированных данных в контексте Big Data\n22. Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask\n23. Введение в распределённые вычисления: Dask и локальные кластеры\n24. Практическая работа №12. Параллельная обработка данных без облачных сервисов\n25. Хранение и обработка данных: Apache Parquet, DuckDB\n26. Практическая работа №13. Эффективное хранение и запросы к большим данным\n27. Основы MLOps: сохранение и загрузка моделей, логирование экспериментов\n28. Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление\n29. Развёртывание ML-модели: локальный REST API на Flask/FastAPI\n30. Практическая работа №15. Создание API для получения предсказаний модели по HTTP\n31. Интеграция компьютерного зрения в аналитические системы\n32. Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений\n33. Этические и правовые аспекты работы со зрительными данными\n34. Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным\n35. Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему\n36. Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N
19	420	3	Модуль 3. 3D-моделирование и визуализация в Blender	1. Введение в 3D-моделирование и установка Blender\n2. Практическая работа №1. Настройка интерфейса и управления.\n3. Основные объекты и примитивы\n4. Практическая работа №2. Создание 3D-моделей из примитивов.\n5. Редактирование вершин, рёбер и полигонов\n6. Практическая работа №3. Формирование геометрии объектов.\n7. Модификаторы и скульптинг\n8. Практическая работа №4. Использование модификаторов и скульптуры.\n9. UV-развёртка и текстурирование\n10. Практическая работа №5. Создание развёртки и нанесение текстуры.\n11. Материалы и освещение\n12. Практическая работа №6. Создание материалов и источников света.\n13. Рендеринг в Eevee и Cycles\n14. Практическая работа №7. Настройка параметров рендеринга.\n15. Импорт и экспорт 3D-моделей\n16. Практическая работа №8. Экспорт модели в формат FBX.\n17. Создание персонажей\n18. Практическая работа №9. Моделирование игрового персонажа.\n19. Риггинг и анимация\n20. Практическая работа №10. Создание анимации персонажа.\n21. Работа с камерой и сценой\n22. Практическая работа №11. Настройка камеры и сцены.\n23. Импорт в Unity и тестирование\n24. Практическая работа №12. Импорт анимированного персонажа.\n25. Создание объектов окружения\n26. Практическая работа №13. Моделирование деревьев и зданий.\n27. Оптимизация моделей\n28. Практическая работа №14. Уменьшение полигонажа.\n29. Постобработка изображений\n30. Практическая работа №15. Использование Compositor.\n31. Создание визуального набора ресурсов\n32. Практическая работа №16. Подготовка библиотеки объектов.\n33. Настройка материалов в Unity\n34. Практическая работа №17. Применение PBR-материалов.\n35. Анимация взаимодействия с объектами\n36. Практическая работа №18. Сценарий анимации объекта.	\N	\N	\N
5	417	1	Модуль 1. Информационные системы и жизненный цикл разработки	1. Введение в цифровые системы: понятия, цели, участники\n2. Практическая работа №1. Создание репозитория проекта и шаблонов документации\n3. Типы информационных систем: MIS, DSS, ERP, CRM и др.\n4. Практическая работа №2. Классификация существующих ИС на примерах из открытых источников\n5. Жизненный цикл ИС: waterfall, V-model, spiral\n6. Практическая работа №3. Сравнение моделей ЖЦ на реальных кейсах\n7. Гибкие методологии: Scrum, Kanban, XP\n8. Практическая работа №4. Настройка доски задач в Notion/AnyType под Scrum\n9. Роли в проекте: заказчик, аналитик, разработчик, тестировщик\n10. Практическая работа №5. Карта взаимодействия ролей в типовом проекте\n11. Фазы ЖЦ: инициация, анализ, проектирование, реализация, эксплуатация\n12. Практическая работа №6. Создание roadmap проекта в LibreOffice Calc\n13. Управление требованиями: концепция, цели, инструменты\n14. Практическая работа №7. Создание базового трассировочного документа требований\n15. Принципы построения архитектуры ИС\n16. Практическая работа №8. Анализ архитектуры открытой системы (например, Moodle)\n17. Интеграционные шины и API в цифровых системах\n18. Практическая работа №9. Исследование REST API через Postman\n19. Качественные атрибуты ИС: масштабируемость, надежность, безопасность\n20. Практическая работа №10. Оценка качества ИС по открытой документации\n21. Стандарты в разработке: ISO/IEC 12207, ISO/IEC 25010\n22. Практическая работа №11. Сопоставление требований проекта со стандартами\n23. Управление конфигурациями и версиями\n24. Практическая работа №12. Настройка Git-репозитория с ветками под фазы ЖЦ\n25. Документация на разных этапах ЖЦ\n26. Практическая работа №13. Шаблон технического задания в LibreOffice Writer\n27. Оценка стоимости и рисков проекта\n28. Практическая работа №14. Расчет рисков по методике SWOT в Calc\n29. Введение в профстандарты: системный аналитик, архитектор\n30. Практическая работа №15. Анализ профстандарта 06.034 и сопоставление с задачами\n31. Этические аспекты проектирования ИС\n32. Практическая работа №16. Разбор кейсов по этике данных и приватности\n33. Введение в цифровую трансформацию\n34. Практическая работа №17. Карта цифровизации процессов в условной компании\n35. Синтез этапов жизненного цикла в единую модель разработки\n36. Практическая работа №18. Формирование описания информационной системы и её жизненного цикла по шаблону	\N	\N	\N
6	417	2	Модуль 2. Анализ требований и моделирование бизнес-процессов	1. Виды требований: функциональные, нефункциональные, бизнес-требования\n2. Практическая работа №1. Классификация требований на примере open-source ИС\n3. Методы сбора требований: интервью, анкетирование, наблюдение\n4. Практическая работа №2. Проведение виртуального интервью и оформление результатов\n5. Stakeholder analysis: идентификация и приоритизация\n6. Практическая работа №3. Построение карты заинтересованных сторон\n7. User stories и use cases: различия и применение\n8. Практическая работа №4. Написание user stories и use case для учебного проекта\n9. Техники валидации требований: walkthrough, inspection\n10. Практическая работа №5. Проведение peer-review требований в команде\n11. Введение в моделирование бизнес-процессов\n12. Практическая работа №6. Анализ существующего процесса (например, приём заявок)\n13. Нотация BPMN: основные элементы\n14. Практическая работа №7. Построение простого процесса в draw.io\n15. События, задачи, шлюзы в BPMN\n16. Практическая работа №8. Моделирование ветвления и параллельных потоков\n17. Пулы и дорожки в BPMN\n18. Практическая работа №9. Моделирование межподразделенческого процесса\n19. Анализ «как есть» и «как должно быть» (AS-IS / TO-BE)\n20. Практическая работа №10. Построение пары диаграмм AS-IS / TO-BE\n21. Метрики эффективности процессов: время, стоимость, ошибки\n22. Практическая работа №11. Расчёт KPI для учебного процесса\n23. SWOT- и PESTLE-анализ в контексте требований\n24. Практическая работа №12. Проведение PESTLE для условного проекта\n25. Приоритизация требований: MoSCoW, Kano\n26. Практическая работа №13. Применение MoSCoW к набору требований\n27. Трассировка требований: цели и методы\n28. Практическая работа №14. Построение матрицы трассировки в Calc\n29. Управление изменениями требований\n30. Практическая работа №15. Моделирование workflow изменения требований в Notion\n31. Работа с конфликтующими требованиями\n32. Практическая работа №16. Разрешение конфликта через фасилитацию\n33. Документ «Спецификация требований» (SRS)\n34. Практическая работа №17. Написание раздела SRS по шаблону IEEE\n35. Интеграция бизнес-требований и моделей процессов в спецификацию системы\n36. Практическая работа №18. Оформление согласованного пакета: бизнес-процесс (BPMN) и сопутствующие требования	\N	\N	\N
7	417	3	Модуль 3. UML, BPMN и проектная документация	1. Введение в UML: цели, история, диаграммы\n2. Практическая работа №1. Установка StarUML / PlantUML и создание первого проекта\n3. Диаграмма прецедентов (Use Case Diagram)\n4. Практическая работа №2. Моделирование прецедентов для системы бронирования\n5. Диаграмма классов (Class Diagram)\n6. Практическая работа №3. Построение доменной модели на UML\n7. Диаграмма последовательности (Sequence Diagram)\n8. Практическая работа №4. Моделирование сценария авторизации\n9. Диаграмма состояний (State Machine Diagram)\n10. Практическая работа №5. Моделирование жизненного цикла заказа\n11. Диаграмма деятельности (Activity Diagram)\n12. Практическая работа №6. Сравнение с BPMN: когда что использовать\n13. Компонентные и развертывания диаграммы\n14. Практическая работа №7. Архитектура развертывания учебной системы\n15. Пакетные диаграммы и организация модели\n16. Практическая работа №8. Структурирование проекта в StarUML\n17. Интеграция UML и BPMN в одном проекте\n18. Практическая работа №9. Связь бизнес-процесса и системных прецедентов\n19. Генерация кода из UML (ограниченно, для понимания)\n20. Практическая работа №10. Экспорт модели в псевдокод через PlantUML\n21. Версионирование моделей в Git\n22. Практическая работа №11. Коммит и сравнение версий диаграмм\n23. Проектная документация: структура и стандарты\n24. Практическая работа №12. Создание оглавления пакета документации\n25. Техническое задание (ТЗ) по ГОСТ 19.201–78\n26. Практическая работа №13. Написание ТЗ в LibreOffice Writer\n27. Программа и методика испытаний\n28. Практическая работа №14. Разработка тест-кейсов на основе требований\n29. Руководство пользователя и администратора\n30. Практическая работа №15. Создание инструкции с диаграммами из draw.io\n31. Управление документацией в команде\n32. Практическая работа №16. Настройка совместного доступа к документам через Git\n33. Архивация и передача проекта на поддержку\n34. Практическая работа №17. Формирование архива проекта с документацией\n35. Согласование моделей и документации в рамках единого проектного артефакта\n36. Практическая работа №18. Сборка согласованного комплекта диаграмм и сопроводительной документации	\N	\N	\N
8	417	4	Модуль 4. Системное проектирование и сопровождение цифровых решений	1. Принципы системного проектирования\n2. Практическая работа №1. Анализ архитектурных паттернов (слоистая, микросервисы)\n3. Декомпозиция системы на подсистемы\n4. Практическая работа №2. Создание компонентной диаграммы ИС\n5. Проектирование интерфейсов взаимодействия\n6. Практическая работа №3. Описание API в формате OpenAPI (вручную)\n7. Проектирование БД: ER-диаграммы, нормализация\n8. Практическая работа №4. Построение ERD в draw.io\n9. Выбор технологического стека под требования\n10. Практическая работа №5. Сравнение стеков на основе нефункциональных требований\n11. Проектирование безопасности ИС\n12. Практическая работа №6. Карта угроз и контрмер по методике STRIDE\n13. Проектирование отказоустойчивости и масштабируемости\n14. Практическая работа №7. Архитектурные решения для нагрузки и резервирования\n15. Введение в DevOps-культуру для аналитиков\n16. Практическая работа №8. Моделирование CI/CD-пайплайна в draw.io\n17. Мониторинг и логирование в ИС\n18. Практическая работа №9. Создание схемы сбора метрик\n19. Поддержка ИС: инциденты, SLA, регламенты\n20. Практическая работа №10. Разработка регламента обработки заявок\n21. Эволюция ИС: реинжиниринг, рефакторинг, миграция\n22. Практическая работа №11. Планирование миграции унаследованной системы\n23. Управление знаниями в команде поддержки\n24. Практическая работа №12. Создание базы знаний в Notion/AnyType\n25. Обратная связь от пользователей и итеративное улучшение\n26. Практическая работа №13. Проектирование формы сбора фидбэка\n27. Аудит ИС и соответствие требованиям\n28. Практическая работа №14. Чек-лист аудита по ФГОС/профстандарту\n29. Завершение проекта: передача, обучение, закрытие\n30. Практическая работа №15. План передачи системы на поддержку\n31. Юридические аспекты сопровождения ИС\n32. Практическая работа №16. Анализ лицензий ПО в стеке проекта\n33. Карьера системного аналитика: развитие компетенций\n34. Практическая работа №17. Составление индивидуального roadmap развития\n35. Этические и экологические аспекты эксплуатации ИС\n36. Практическая работа №18. Оценка цифрового следа и устойчивого проектирования	\N	\N	\N
20	420	4	Модуль 4. Разработка и оптимизация игровых проектов в Unity	1. Интеграция 3D-моделей в Unity\n2. Практическая работа №1. Импорт сцен из Blender.\n3. Настройка материалов и анимаций\n4. Практическая работа №2. Настройка анимаций персонажа.\n5. Создание управляемого персонажа\n6. Практическая работа №3. Реализация управления персонажем.\n7. Система событий и коллизий\n8. Практическая работа №4. Настройка взаимодействий.\n9. UI и игровое меню\n10. Практическая работа №5. Разработка игрового меню.\n11. Работа со звуком и музыкой\n12. Практическая работа №6. Настройка аудиосистемы.\n13. Сценарии и игровая логика\n14. Практическая работа №7. Реализация игровой логики.\n15. AI и Pathfinding\n16. Практическая работа №8. Настройка поведения NPC.\n17. Система очков и инвентарь\n18. Практическая работа №9. Реализация системы очков.\n19. Сохранение прогресса\n20. Практическая работа №10. Реализация системы сохранений.\n21. Оптимизация производительности\n22. Практическая работа №11. Профилирование проекта.\n23. Постобработка и визуальные эффекты\n24. Практическая работа №12. Настройка эффектов.\n25. Тестирование игрового процесса\n26. Практическая работа №13. Проведение тестирования.\n27. Экспорт и сборка проекта\n28. Практическая работа №14. Создание финального билда.\n29. Контроль версий и Git\n30. Практическая работа №15. Настройка репозитория Git.\n31. Документирование игры\n32. Практическая работа №16. Подготовка документации проекта.\n33. Подготовка трейлера и обложки\n34. Практическая работа №17. Создание рекламных материалов.\n35. Тестирование пользовательского опыта\n36. Практическая работа №18. Анализ игрового UX.	\N	\N	\N
9	418	1	Модуль 1. Информационные системы и жизненный цикл разработки	1. Введение в цифровые системы: понятия, цели, участники\n2. Практическая работа №1. Создание репозитория проекта и шаблонов документации\n3. Типы информационных систем: MIS, DSS, ERP, CRM и др.\n4. Практическая работа №2. Классификация существующих ИС на примерах из открытых источников\n5. Жизненный цикл ИС: waterfall, V-model, spiral\n6. Практическая работа №3. Сравнение моделей ЖЦ на реальных кейсах\n7. Гибкие методологии: Scrum, Kanban, XP\n8. Практическая работа №4. Настройка доски задач в Notion/AnyType под Scrum\n9. Роли в проекте: заказчик, аналитик, разработчик, тестировщик\n10. Практическая работа №5. Карта взаимодействия ролей в типовом проекте\n11. Фазы ЖЦ: инициация, анализ, проектирование, реализация, эксплуатация\n12. Практическая работа №6. Создание roadmap проекта в LibreOffice Calc\n13. Управление требованиями: концепция, цели, инструменты\n14. Практическая работа №7. Создание базового трассировочного документа требований\n15. Принципы построения архитектуры ИС\n16. Практическая работа №8. Анализ архитектуры открытой системы (например, Moodle)\n17. Интеграционные шины и API в цифровых системах\n18. Практическая работа №9. Исследование REST API через Postman\n19. Качественные атрибуты ИС: масштабируемость, надежность, безопасность\n20. Практическая работа №10. Оценка качества ИС по открытой документации\n21. Стандарты в разработке: ISO/IEC 12207, ISO/IEC 25010\n22. Практическая работа №11. Сопоставление требований проекта со стандартами\n23. Управление конфигурациями и версиями\n24. Практическая работа №12. Настройка Git-репозитория с ветками под фазы ЖЦ\n25. Документация на разных этапах ЖЦ\n26. Практическая работа №13. Шаблон технического задания в LibreOffice Writer\n27. Оценка стоимости и рисков проекта\n28. Практическая работа №14. Расчет рисков по методике SWOT в Calc\n29. Введение в профстандарты: системный аналитик, архитектор\n30. Практическая работа №15. Анализ профстандарта 06.034 и сопоставление с задачами\n31. Этические аспекты проектирования ИС\n32. Практическая работа №16. Разбор кейсов по этике данных и приватности\n33. Введение в цифровую трансформацию\n34. Практическая работа №17. Карта цифровизации процессов в условной компании\n35. Синтез этапов жизненного цикла в единую модель разработки\n36. Практическая работа №18. Формирование описания информационной системы и её жизненного цикла по шаблону	\N	\N	\N
10	418	2	Модуль 2. Анализ требований и моделирование бизнес-процессов	1. Виды требований: функциональные, нефункциональные, бизнес-требования\n2. Практическая работа №1. Классификация требований на примере open-source ИС\n3. Методы сбора требований: интервью, анкетирование, наблюдение\n4. Практическая работа №2. Проведение виртуального интервью и оформление результатов\n5. Stakeholder analysis: идентификация и приоритизация\n6. Практическая работа №3. Построение карты заинтересованных сторон\n7. User stories и use cases: различия и применение\n8. Практическая работа №4. Написание user stories и use case для учебного проекта\n9. Техники валидации требований: walkthrough, inspection\n10. Практическая работа №5. Проведение peer-review требований в команде\n11. Введение в моделирование бизнес-процессов\n12. Практическая работа №6. Анализ существующего процесса (например, приём заявок)\n13. Нотация BPMN: основные элементы\n14. Практическая работа №7. Построение простого процесса в draw.io\n15. События, задачи, шлюзы в BPMN\n16. Практическая работа №8. Моделирование ветвления и параллельных потоков\n17. Пулы и дорожки в BPMN\n18. Практическая работа №9. Моделирование межподразделенческого процесса\n19. Анализ «как есть» и «как должно быть» (AS-IS / TO-BE)\n20. Практическая работа №10. Построение пары диаграмм AS-IS / TO-BE\n21. Метрики эффективности процессов: время, стоимость, ошибки\n22. Практическая работа №11. Расчёт KPI для учебного процесса\n23. SWOT- и PESTLE-анализ в контексте требований\n24. Практическая работа №12. Проведение PESTLE для условного проекта\n25. Приоритизация требований: MoSCoW, Kano\n26. Практическая работа №13. Применение MoSCoW к набору требований\n27. Трассировка требований: цели и методы\n28. Практическая работа №14. Построение матрицы трассировки в Calc\n29. Управление изменениями требований\n30. Практическая работа №15. Моделирование workflow изменения требований в Notion\n31. Работа с конфликтующими требованиями\n32. Практическая работа №16. Разрешение конфликта через фасилитацию\n33. Документ «Спецификация требований» (SRS)\n34. Практическая работа №17. Написание раздела SRS по шаблону IEEE\n35. Интеграция бизнес-требований и моделей процессов в спецификацию системы\n36. Практическая работа №18. Оформление согласованного пакета: бизнес-процесс (BPMN) и сопутствующие требования	\N	\N	\N
11	418	3	Модуль 3. UML, BPMN и проектная документация	1. Введение в UML: цели, история, диаграммы\n2. Практическая работа №1. Установка StarUML / PlantUML и создание первого проекта\n3. Диаграмма прецедентов (Use Case Diagram)\n4. Практическая работа №2. Моделирование прецедентов для системы бронирования\n5. Диаграмма классов (Class Diagram)\n6. Практическая работа №3. Построение доменной модели на UML\n7. Диаграмма последовательности (Sequence Diagram)\n8. Практическая работа №4. Моделирование сценария авторизации\n9. Диаграмма состояний (State Machine Diagram)\n10. Практическая работа №5. Моделирование жизненного цикла заказа\n11. Диаграмма деятельности (Activity Diagram)\n12. Практическая работа №6. Сравнение с BPMN: когда что использовать\n13. Компонентные и развертывания диаграммы\n14. Практическая работа №7. Архитектура развертывания учебной системы\n15. Пакетные диаграммы и организация модели\n16. Практическая работа №8. Структурирование проекта в StarUML\n17. Интеграция UML и BPMN в одном проекте\n18. Практическая работа №9. Связь бизнес-процесса и системных прецедентов\n19. Генерация кода из UML (ограниченно, для понимания)\n20. Практическая работа №10. Экспорт модели в псевдокод через PlantUML\n21. Версионирование моделей в Git\n22. Практическая работа №11. Коммит и сравнение версий диаграмм\n23. Проектная документация: структура и стандарты\n24. Практическая работа №12. Создание оглавления пакета документации\n25. Техническое задание (ТЗ) по ГОСТ 19.201–78\n26. Практическая работа №13. Написание ТЗ в LibreOffice Writer\n27. Программа и методика испытаний\n28. Практическая работа №14. Разработка тест-кейсов на основе требований\n29. Руководство пользователя и администратора\n30. Практическая работа №15. Создание инструкции с диаграммами из draw.io\n31. Управление документацией в команде\n32. Практическая работа №16. Настройка совместного доступа к документам через Git\n33. Архивация и передача проекта на поддержку\n34. Практическая работа №17. Формирование архива проекта с документацией\n35. Согласование моделей и документации в рамках единого проектного артефакта\n36. Практическая работа №18. Сборка согласованного комплекта диаграмм и сопроводительной документации	\N	\N	\N
12	418	4	Модуль 4. Системное проектирование и сопровождение цифровых решений	1. Принципы системного проектирования\n2. Практическая работа №1. Анализ архитектурных паттернов (слоистая, микросервисы)\n3. Декомпозиция системы на подсистемы\n4. Практическая работа №2. Создание компонентной диаграммы ИС\n5. Проектирование интерфейсов взаимодействия\n6. Практическая работа №3. Описание API в формате OpenAPI (вручную)\n7. Проектирование БД: ER-диаграммы, нормализация\n8. Практическая работа №4. Построение ERD в draw.io\n9. Выбор технологического стека под требования\n10. Практическая работа №5. Сравнение стеков на основе нефункциональных требований\n11. Проектирование безопасности ИС\n12. Практическая работа №6. Карта угроз и контрмер по методике STRIDE\n13. Проектирование отказоустойчивости и масштабируемости\n14. Практическая работа №7. Архитектурные решения для нагрузки и резервирования\n15. Введение в DevOps-культуру для аналитиков\n16. Практическая работа №8. Моделирование CI/CD-пайплайна в draw.io\n17. Мониторинг и логирование в ИС\n18. Практическая работа №9. Создание схемы сбора метрик\n19. Поддержка ИС: инциденты, SLA, регламенты\n20. Практическая работа №10. Разработка регламента обработки заявок\n21. Эволюция ИС: реинжиниринг, рефакторинг, миграция\n22. Практическая работа №11. Планирование миграции унаследованной системы\n23. Управление знаниями в команде поддержки\n24. Практическая работа №12. Создание базы знаний в Notion/AnyType\n25. Обратная связь от пользователей и итеративное улучшение\n26. Практическая работа №13. Проектирование формы сбора фидбэка\n27. Аудит ИС и соответствие требованиям\n28. Практическая работа №14. Чек-лист аудита по ФГОС/профстандарту\n29. Завершение проекта: передача, обучение, закрытие\n30. Практическая работа №15. План передачи системы на поддержку\n31. Юридические аспекты сопровождения ИС\n32. Практическая работа №16. Анализ лицензий ПО в стеке проекта\n33. Карьера системного аналитика: развитие компетенций\n34. Практическая работа №17. Составление индивидуального roadmap развития\n35. Этические и экологические аспекты эксплуатации ИС\n36. Практическая работа №18. Оценка цифрового следа и устойчивого проектирования	\N	\N	\N
13	419	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Функции в Python: основы\n18. Практическая работа №9. Создание пользовательских функций\n19. Передача аргументов, *args, **kwargs\n20. Практическая работа №10. Работа с *args и **kwargs\n21. Работа с файлами: чтение и запись\n22. Практическая работа №11. Работа с файлами: чтение и запись данных\n23. Работа с CSV и JSON файлами\n24. Практическая работа №12. Чтение и запись данных в CSV и JSON\n25. Обработка ошибок и исключения\n26. Практическая работа №13. Обработка ошибок в программах\n27. Регулярные выражения (re)\n28. Практическая работа №14. Поиск и замена данных с использованием regex\n29. Основы ООП в Python\n30. Практическая работа №15. Создание классов и объектов\n31. Наследование и полиморфизм\n32. Практическая работа №16. Реализация наследования в Python\n33. Генераторы списков и lambda-функции\n34. Практическая работа №17. Оптимизация кода с генераторами\n35. Модули и виртуальные окружения\n36. Практическая работа №18. Создание и использование venv	\N	\N	\N
14	419	2	Модуль 2. Анализ и обработка данных на Python	1. Введение в анализ данных и Big Data\n2. Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook\n3. Основы работы с библиотекой NumPy\n4. Практическая работа №2. Создание и манипуляции с многомерными массивами\n5. Основы работы с библиотекой Pandas\n6. Практическая работа №3. Загрузка и первичный анализ структурированных данных\n7. Чтение и запись данных в форматах CSV, JSON, Parquet\n8. Практическая работа №4. Импорт и экспорт данных с использованием Pandas\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов\n11. Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy\n12. Практическая работа №6. Выполнение SQL-запросов из Python-скриптов\n13. Фильтрация и сортировка данных в Pandas\n14. Практическая работа №7. Отбор строк и столбцов по условию\n15. Группировка данных и агрегация\n16. Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)\n17. Сводные таблицы и кросстабуляции\n18. Практическая работа №9. Построение аналитических сводок по категориальным данным\n19. Объединение и слияние датафреймов\n20. Практическая работа №10. Объединение таблиц по ключам (join/merge)\n21. Работа с временными рядами\n22. Практическая работа №11. Преобразование строковых дат и агрегация по периодам\n23. Обработка пропущенных данных\n24. Практическая работа №12. Поиск, удаление и импутация пропусков\n25. Работа с выбросами и аномалиями\n26. Практическая работа №13. Выявление выбросов методами IQR и Z-score\n27. Кодирование категориальных признаков\n28. Практическая работа №14. One-hot и label-кодирование\n29. Нормализация и стандартизация данных\n30. Практическая работа №15. Масштабирование признаков для ML-моделей\n31. Работа с большими наборами данных\n32. Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки\n33. Визуализация данных с помощью Matplotlib\n34. Практическая работа №17. Построение гистограмм, boxplot, scatter и линейных графиков\n35. Визуализация данных с помощью Seaborn\n36. Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N
15	419	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	1. Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)\n2. Практическая работа №1. Постановка ML-задач на основе реальных датасетов\n3. Подготовка данных для машинного обучения\n4. Практическая работа №2. Разделение данных на обучающую и тестовую выборки\n5. Обучение первой модели: линейная регрессия\n6. Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn\n7. Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall\n8. Практическая работа №4. Оценка качества моделей на тестовой выборке\n9. Классификация: логистическая регрессия и kNN\n10. Практическая работа №5. Решение задач бинарной и многоклассовой классификации\n11. Деревья решений и случайный лес\n12. Практическая работа №6. Обучение и визуализация дерева решений\n13. Кластеризация: K-Means и иерархическая кластеризация\n14. Практическая работа №7. Группировка клиентов или объектов без разметки\n15. Работа с несбалансированными данными\n16. Практическая работа  №8. Применение oversampling (SMOTE) и undersampling\n17. Кросс-валидация и подбор гиперпараметров\n18. Практическая работа №9. Подбор параметров с помощью GridSearchCV\n19. Основы нейросетей: перцептрон и многослойные сети\n20. Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow\n21. Обучение нейросетей на табличных данных\n22. Практическая работа №11. Построение модели для предсказания с числовыми/категориальными признаками\n23. Введение в нейросети для обработки изображений\n24. Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL\n25. Сверточные нейронные сети (CNN): архитектура и принцип работы\n26. Практическая работа №13. Построение первой CNN для классификации CIFAR-10\n27. Обучение CNN на собственном датасете\n28. Практическая работа №14. Подготовка изображений и обучение модели под задачу\n29. Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)\n30. Практическая работа №15. Применение аугментации и регуляризации в Keras\n31. Использование предобученных моделей (Transfer Learning)\n32. Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу\n33. Оценка и интерпретация моделей компьютерного зрения\n34. Практическая работа №17. Визуализация активаций и ошибок предсказаний\n35. Применение сквозного ML-пайплайна для задачи классификации изображений\n36. Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N
16	419	4	Модуль 4. Компьютерное зрение и обработка больших данных	1. Введение в компьютерное зрение: задачи и применения\n2. Практическая работа №1. Установка OpenCV и загрузка изображений\n3. Работа с изображениями: цветовые пространства, каналы, гистограммы\n4. Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету\n5. Фильтрация и шумоподавление: Gaussian, Median, Bilateral\n6. Практическая работа №3. Улучшение качества изображений с OpenCV\n7. Геометрические преобразования: масштабирование, поворот, аффинные преобразования\n8. Практическая работа №4. Коррекция перспективы и выравнивание объектов\n9. Обнаружение границ и контуров (Canny, Sobel, Laplacian)\n10. Практическая работа №5. Поиск и отрисовка контуров объектов\n11. Сегментация изображений: пороговая, адаптивная, watershed\n12. Практическая работа №6. Выделение фона и переднего плана\n13. Обнаружение объектов: метод скользящего окна, Haar-каскады\n14. Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов\n15. Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)\n16. Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)\n17. Работа с видео: чтение, запись, обработка кадров\n18. Практическая работа №9. Обнаружение движущихся объектов в видеопотоке\n19. Обработка больших объёмов изображений (пакетная обработка)\n20. Практическая работа №10. Создание пайплайна для обработки тысяч изображений\n21. Анализ структурированных и полуструктурированных данных в контексте Big Data\n22. Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask\n23. Введение в распределённые вычисления: Dask и локальные кластеры\n24. Практическая работа №12. Параллельная обработка данных без облачных сервисов\n25. Хранение и обработка данных: Apache Parquet, DuckDB\n26. Практическая работа №13. Эффективное хранение и запросы к большим данным\n27. Основы MLOps: сохранение и загрузка моделей, логирование экспериментов\n28. Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление\n29. Развёртывание ML-модели: локальный REST API на Flask/FastAPI\n30. Практическая работа №15. Создание API для получения предсказаний модели по HTTP\n31. Интеграция компьютерного зрения в аналитические системы\n32. Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений\n33. Этические и правовые аспекты работы со зрительными данными\n34. Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным\n35. Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему\n36. Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N
17	420	1	Модуль 1. Программирование на языке C#	1. Введение в язык C# и установка окружения\n2. Практическая работа №1. Установка .NET SDK и настройка Visual Studio Code.\n3. Синтаксис и структура программы\n4. Практическая работа №2. Создание первого консольного приложения.\n5. Типы данных и операторы\n6. Практическая работа №3. Работа с переменными и операциями.\n7. Условные конструкции и циклы\n8. Практическая работа №4. Реализация ветвлений и циклов.\n9. Функции и методы\n10. Практическая работа №5. Создание и вызов методов.\n11. Классы и объекты\n12. Практическая работа №6. Создание классов и экземпляров.\n13. Инкапсуляция и модификаторы доступа\n14. Практическая работа №7. Реализация private/public членов.\n15. Наследование и полиморфизм\n16. Практическая работа №8. Создание иерархии классов.\n17. Интерфейсы и абстрактные классы\n18. Практическая работа №9. Реализация абстракций.\n19. Коллекции и генерики\n20. Практическая работа №10. Использование List, Dictionary, Generics.\n21. Обработка исключений\n22. Практическая работа №11. Работа с try-catch-finally.\n23. Работа с файлами и потоками\n24. Практическая работа №12. Чтение и запись в файл.\n25. Lambda-выражения и LINQ\n26. Практическая работа №13. Фильтрация и обработка данных.\n27. События и делегаты\n28. Практическая работа №14. Создание и подписка на события.\n29. Статические члены и константы\n30. Практическая работа №15. Использование static и readonly.\n31. Работа со временем и датами\n32. Практическая работа №16. Применение DateTime.\n33. Тестирование и отладка кода\n34. Практическая работа №17. Использование отладчика и точек остановки.\n35. Пространства имён и сборка проекта\n36. Практическая работа №18. Организация структуры кода.	\N	\N	\N
18	420	2	Модуль 2. Разработка интерактивных сцен в Unity	1. Установка и настройка Unity Hub\n2. Практическая работа №1. Создание нового Unity-проекта.\n3. Интерфейс и основные панели Unity\n4. Практическая работа №2. Навигация в Scene и Inspector.\n5. Объекты и компоненты\n6. Практическая работа №3. Создание и редактирование GameObject.\n7. Материалы и освещение\n8. Практическая работа №4. Добавление материалов и света.\n9. Физика в Unity\n10. Практическая работа №5. Применение RigidBody и Collider.\n11. Скрипты и взаимодействие с объектами\n12. Практическая работа №6. Реализация переходов Navigator.\n13. Префабы и иерархия объектов\n14. Практическая работа №7. Создание префабов.\n15. Сцены и загрузка уровней\n16. Практическая работа №8. Настройка Scene Management.\n17. UI в Unity: Canvas, Button, Text\n18. Практическая работа №9. Создание игрового интерфейса.\n19. Анимация объектов\n20. Практическая работа №10. Использование Animator и Animation Clips.\n21. События и триггеры\n22. Практическая работа №11. Реакция на события игрока.\n23. Камера и настройка перспективы\n24. Практическая работа №12. Настройка движения камеры.\n25. Работа со звуком\n26. Практическая работа №13. Добавление аудиоэффектов.\n27. Адаптивный UI и вёрстка интерфейса\n28. Практическая работа №14. Оптимизация UI и адаптация под разрешения.\n29. Постобработка и эффекты\n30. Практическая работа №15. Добавление Bloom и Color Grading.\n31. Навигация и AI Pathfinding\n32. Практическая работа №16. Создание AI-персонажа.\n33. Создание меню и экранов\n34. Практическая работа №17. Разработка главного меню.\n35. Инвентарь и система очков\n36. Практическая работа №18. Создание UI-счётчиков.	\N	\N	\N
21	421	1	Модуль 1. Программирование на языке Java	1. Введение в язык Java и установка окружения\n2. Практическая работа №1. Установка OpenJDK и настройка среды разработки Eclipse.\n3. Основы синтаксиса Java и структура программы\n4. Практическая работа №2. Написание первой программы и компиляция кода.\n5. Типы данных, переменные и константы\n6. Практическая работа №3. Объявление и использование различных типов данных.\n7. Операторы и выражения в Java\n8. Практическая работа №4. Использование арифметических и логических операторов.\n9. Условные конструкции и ветвления\n10. Практическая работа №5. Реализация ветвлений с помощью if, switch.\n11. Циклы и итерации\n12. Практическая работа №6. Создание циклов for, while, do-while.\n13. Методы и передача параметров\n14. Практическая работа №7. Разработка пользовательских методов и вызов из main.\n15. Область видимости и модификаторы доступа\n16. Практическая работа №8. Демонстрация public, private, protected в классе.\n17. Массивы и коллекции\n18. Практическая работа №9. Использование одномерных и многомерных массивов.\n19. Работа со строками и классом StringBuilder\n20. Практическая работа №10. Форматирование и обработка строковых данных.\n21. Введение в объектно-ориентированное программирование\n22. Практическая работа №11. Создание класса и объекта, инкапсуляция данных.\n23. Наследование и переопределение методов\n24. Практическая работа №12. Реализация наследования и иерархии классов.\n25. Полиморфизм и интерфейсы\n26. Практическая работа №13. Использование интерфейсов и абстрактных классов.\n27. Работа с пакетами и импортом классов\n28. Практическая работа №14. Организация проекта с использованием пакетов.\n29. Обработка исключений\n30. Практическая работа №15. Реализация обработки ошибок через try-catch-finally.\n31. Файловый ввод-вывод и потоки данных\n32. Практическая работа №16. Чтение и запись данных в файлы.\n33. Работа с датой и временем\n34. Практическая работа №17. Использование классов LocalDate и LocalDateTime.\n35. Основы работы с регулярными выражениями\n36. Практическая работа №18. Проверка корректности данных с помощью regex.	\N	\N	\N
22	421	2	Модуль 2. Объектно-ориентированное программирование и работа с файлами и потоками ввода-вывода	1. Принципы ООП: инкапсуляция, наследование, полиморфизм\n2. Практическая работа №1. Создание иерархии классов с наследованием.\n3. Интерфейсы и абстрактные классы\n4. Практическая работа №2. Реализация интерфейсов и абстрактных методов.\n5. Перегрузка и переопределение методов\n6. Практическая работа №3. Демонстрация полиморфизма и переопределения.\n7. Внутренние и анонимные классы\n8. Практическая работа №4. Реализация внутренних и вложенных классов.\n9. Работа с файлами и потоками ввода-вывода\n10. Практическая работа №5. Чтение и запись данных с использованием FileInputStream и FileWriter.\n11. Буферизация и сериализация\n12. Практическая работа №6. Создание сериализуемых объектов и сохранение в файл.\n13. Работа с каталогами и файловой системой\n14. Практическая работа №7. Перебор файлов и каталогов средствами Java NIO.\n15. Исключения при работе с файлами\n16. Практическая работа №8. Обработка IOException при чтении данных.\n17. Коллекции и generics\n18. Практическая работа №9. Реализация универсальных классов и методов.\n19. Lambda-выражения и функциональные интерфейсы\n20. Практическая работа №10. Применение лямбда-функций для обработки коллекций.\n21. Stream API\n22. Практическая работа №11. Использование потоков данных для фильтрации и сортировки.\n23. Работа с JSON и XML\n24. Практическая работа №12. Чтение и запись данных в форматах JSON и XML.\n25. Использование библиотек для работы с файлами (Gson, Jackson)\n26. Практическая работа №13. Конвертация объектов в JSON и обратно.\n27. Логирование в Java\n28. Практическая работа №14. Настройка логирования с использованием java.util.logging.\n29. Работа с аргументами командной строки\n30. Практическая работа №15. Обработка параметров запуска программы.\n31. Создание простого CLI-приложения\n32. Практическая работа №16. Разработка командного интерфейса на Java.\n33. Пакетирование и сборка проекта\n34. Практическая работа №17. Создание jar-файла и запуск из консоли.\n35. Тестирование кода с JUnit\n36. Практическая работа №18. Написание юнит-тестов.	\N	\N	\N
23	421	3	Модуль 3. Работа с базами данных и SQL	1. Введение в базы данных и принципы реляционной модели\n2. Практическая работа №1. Установка и настройка PostgreSQL.\n3. Создание таблиц и связей\n4. Практическая работа №2. Реализация таблиц и внешних ключей.\n5. Основы SQL: SELECT, INSERT, UPDATE, DELETE\n6. Практическая работа №3. Написание запросов для выборки и обновления данных.\n7. Фильтрация, сортировка и агрегатные функции\n8. Практическая работа №4. Создание запросов с условиями WHERE и GROUP BY.\n9. Объединения таблиц и подзапросы\n10. Практическая работа №5. Использование JOIN и подзапросов.\n11. Индексы и оптимизация запросов\n12. Практическая работа №6. Анализ производительности SQL-запросов.\n13. Транзакции и управление целостностью данных\n14. Практическая работа №7. Реализация транзакций и откатов.\n15. Нормализация баз данных\n16. Практическая работа №8. Преобразование таблиц в нормальные формы.\n17. Работа с JDBC\n18. Практическая работа №9. Подключение к базе данных и выполнение запросов.\n19. Использование PreparedStatement и ResultSet\n20. Практическая работа №10. Защита от SQL-инъекций.\n21. Создание DAO-классов\n22. Практическая работа №11. Инкапсуляция доступа к данным.\n23. Введение в ORM и Hibernate\n24. Практическая работа №12. Настройка Hibernate и создание сущностей.\n25. Аннотации JPA и сопоставление объектов\n26. Практическая работа №13. Реализация связей OneToMany и ManyToMany.\n27. Работа с репозиториями\n28. Практическая работа №14. Разработка CRUD-операций через ORM.\n29. Тестирование базы данных\n30. Практическая работа №15. Проверка целостности и связей данных.\n31. Проектирование ER-диаграмм\n32. Практическая работа №16. Создание схемы базы данных корпоративного приложения.\n33. Импорт и экспорт данных\n34. Практическая работа №17. Реализация импорта и экспорта данных.\n35. Резервное копирование и восстановление\n36. Практическая работа №18. Создание механизма резервного копирования базы данных.	\N	\N	\N
24	421	4	Модуль 4. Разработка и интеграция корпоративных веб-приложений на Java	1. Основы клиент-серверной архитектуры\n2. Практическая работа №1. Создание простого клиент-серверного взаимодействия.\n3. Введение в сервлеты и контейнеры\n4. Практическая работа №2. Разработка сервлета и его развертывание.\n5. Java EE и Jakarta EE\n6. Практическая работа №3. Настройка проекта на Jakarta EE.\n7. Шаблоны MVC и разделение логики\n8. Практическая работа №4. Реализация MVC-архитектуры.\n9. Работа с REST API\n10. Практическая работа №5. Создание REST-контроллера.\n11. Передача данных в формате JSON\n12. Практическая работа №6. Обработка JSON-запросов и ответов.\n13. Spring Framework: основы и структура проекта\n14. Практическая работа №7. Создание Spring Boot приложения.\n15. Внедрение зависимостей (IoC, DI)\n16. Практическая работа №8. Реализация Dependency Injection.\n17. Работа с базами данных через Spring Data JPA\n18. Практическая работа №9. Подключение базы данных через Spring Data JPA.\n19. Аутентификация и безопасность\n20. Практическая работа №10. Настройка Spring Security.\n21. Валидация данных на сервере\n22. Практическая работа №11. Реализация серверной валидации данных.\n23. Логирование и мониторинг\n24. Практическая работа №12. Настройка логирования и мониторинга приложения.\n25. Тестирование REST API\n26. Практическая работа №13. Тестирование REST-контроллеров.\n27. Работа с внешними API\n28. Практическая работа №14. Интеграция с внешним API.\n29. Фронтенд-взаимодействие\n30. Практическая работа №15. Связь backend и frontend.\n31. Контейнеризация приложения\n32. Практическая работа №16. Создание Docker-образа приложения.\n33. CI/CD для Java-приложения\n34. Практическая работа №17. Настройка CI/CD пайплайна.\n35. Оптимизация и масштабирование\n36. Практическая работа №18. Настройка масштабирования приложения.	\N	\N	\N
25	422	1	Модуль 1. Программирование на языке Java	1. Введение в язык Java и установка окружения\n2. Практическая работа №1. Установка OpenJDK и настройка среды разработки Eclipse.\n3. Основы синтаксиса Java и структура программы\n4. Практическая работа №2. Написание первой программы и компиляция кода.\n5. Типы данных, переменные и константы\n6. Практическая работа №3. Объявление и использование различных типов данных.\n7. Операторы и выражения в Java\n8. Практическая работа №4. Использование арифметических и логических операторов.\n9. Условные конструкции и ветвления\n10. Практическая работа №5. Реализация ветвлений с помощью if, switch.\n11. Циклы и итерации\n12. Практическая работа №6. Создание циклов for, while, do-while.\n13. Методы и передача параметров\n14. Практическая работа №7. Разработка пользовательских методов и вызов из main.\n15. Область видимости и модификаторы доступа\n16. Практическая работа №8. Демонстрация public, private, protected в классе.\n17. Массивы и коллекции\n18. Практическая работа №9. Использование одномерных и многомерных массивов.\n19. Работа со строками и классом StringBuilder\n20. Практическая работа №10. Форматирование и обработка строковых данных.\n21. Введение в объектно-ориентированное программирование\n22. Практическая работа №11. Создание класса и объекта, инкапсуляция данных.\n23. Наследование и переопределение методов\n24. Практическая работа №12. Реализация наследования и иерархии классов.\n25. Полиморфизм и интерфейсы\n26. Практическая работа №13. Использование интерфейсов и абстрактных классов.\n27. Работа с пакетами и импортом классов\n28. Практическая работа №14. Организация проекта с использованием пакетов.\n29. Обработка исключений\n30. Практическая работа №15. Реализация обработки ошибок через try-catch-finally.\n31. Файловый ввод-вывод и потоки данных\n32. Практическая работа №16. Чтение и запись данных в файлы.\n33. Работа с датой и временем\n34. Практическая работа №17. Использование классов LocalDate и LocalDateTime.\n35. Основы работы с регулярными выражениями\n36. Практическая работа №18. Проверка корректности данных с помощью regex.	\N	\N	\N
26	422	2	Модуль 2. Объектно-ориентированное программирование и работа с файлами и потоками ввода-вывода	1. Принципы ООП: инкапсуляция, наследование, полиморфизм\n2. Практическая работа №1. Создание иерархии классов с наследованием.\n3. Интерфейсы и абстрактные классы\n4. Практическая работа №2. Реализация интерфейсов и абстрактных методов.\n5. Перегрузка и переопределение методов\n6. Практическая работа №3. Демонстрация полиморфизма и переопределения.\n7. Внутренние и анонимные классы\n8. Практическая работа №4. Реализация внутренних и вложенных классов.\n9. Работа с файлами и потоками ввода-вывода\n10. Практическая работа №5. Чтение и запись данных с использованием FileInputStream и FileWriter.\n11. Буферизация и сериализация\n12. Практическая работа №6. Создание сериализуемых объектов и сохранение в файл.\n13. Работа с каталогами и файловой системой\n14. Практическая работа №7. Перебор файлов и каталогов средствами Java NIO.\n15. Исключения при работе с файлами\n16. Практическая работа №8. Обработка IOException при чтении данных.\n17. Коллекции и generics\n18. Практическая работа №9. Реализация универсальных классов и методов.\n19. Lambda-выражения и функциональные интерфейсы\n20. Практическая работа №10. Применение лямбда-функций для обработки коллекций.\n21. Stream API\n22. Практическая работа №11. Использование потоков данных для фильтрации и сортировки.\n23. Работа с JSON и XML\n24. Практическая работа №12. Чтение и запись данных в форматах JSON и XML.\n25. Использование библиотек для работы с файлами (Gson, Jackson)\n26. Практическая работа №13. Конвертация объектов в JSON и обратно.\n27. Логирование в Java\n28. Практическая работа №14. Настройка логирования с использованием java.util.logging.\n29. Работа с аргументами командной строки\n30. Практическая работа №15. Обработка параметров запуска программы.\n31. Создание простого CLI-приложения\n32. Практическая работа №16. Разработка командного интерфейса на Java.\n33. Пакетирование и сборка проекта\n34. Практическая работа №17. Создание jar-файла и запуск из консоли.\n35. Тестирование кода с JUnit\n36. Практическая работа №18. Написание юнит-тестов.	\N	\N	\N
27	422	3	Модуль 3. Работа с базами данных и SQL	1. Введение в базы данных и принципы реляционной модели\n2. Практическая работа №1. Установка и настройка PostgreSQL.\n3. Создание таблиц и связей\n4. Практическая работа №2. Реализация таблиц и внешних ключей.\n5. Основы SQL: SELECT, INSERT, UPDATE, DELETE\n6. Практическая работа №3. Написание запросов для выборки и обновления данных.\n7. Фильтрация, сортировка и агрегатные функции\n8. Практическая работа №4. Создание запросов с условиями WHERE и GROUP BY.\n9. Объединения таблиц и подзапросы\n10. Практическая работа №5. Использование JOIN и подзапросов.\n11. Индексы и оптимизация запросов\n12. Практическая работа №6. Анализ производительности SQL-запросов.\n13. Транзакции и управление целостностью данных\n14. Практическая работа №7. Реализация транзакций и откатов.\n15. Нормализация баз данных\n16. Практическая работа №8. Преобразование таблиц в нормальные формы.\n17. Работа с JDBC\n18. Практическая работа №9. Подключение к базе данных и выполнение запросов.\n19. Использование PreparedStatement и ResultSet\n20. Практическая работа №10. Защита от SQL-инъекций.\n21. Создание DAO-классов\n22. Практическая работа №11. Инкапсуляция доступа к данным.\n23. Введение в ORM и Hibernate\n24. Практическая работа №12. Настройка Hibernate и создание сущностей.\n25. Аннотации JPA и сопоставление объектов\n26. Практическая работа №13. Реализация связей OneToMany и ManyToMany.\n27. Работа с репозиториями\n28. Практическая работа №14. Разработка CRUD-операций через ORM.\n29. Тестирование базы данных\n30. Практическая работа №15. Проверка целостности и связей данных.\n31. Проектирование ER-диаграмм\n32. Практическая работа №16. Создание схемы базы данных корпоративного приложения.\n33. Импорт и экспорт данных\n34. Практическая работа №17. Реализация импорта и экспорта данных.\n35. Резервное копирование и восстановление\n36. Практическая работа №18. Создание механизма резервного копирования базы данных.	\N	\N	\N
28	422	4	Модуль 4. Разработка и интеграция корпоративных веб-приложений на Java	1. Основы клиент-серверной архитектуры\n2. Практическая работа №1. Создание простого клиент-серверного взаимодействия.\n3. Введение в сервлеты и контейнеры\n4. Практическая работа №2. Разработка сервлета и его развертывание.\n5. Java EE и Jakarta EE\n6. Практическая работа №3. Настройка проекта на Jakarta EE.\n7. Шаблоны MVC и разделение логики\n8. Практическая работа №4. Реализация MVC-архитектуры.\n9. Работа с REST API\n10. Практическая работа №5. Создание REST-контроллера.\n11. Передача данных в формате JSON\n12. Практическая работа №6. Обработка JSON-запросов и ответов.\n13. Spring Framework: основы и структура проекта\n14. Практическая работа №7. Создание Spring Boot приложения.\n15. Внедрение зависимостей (IoC, DI)\n16. Практическая работа №8. Реализация Dependency Injection.\n17. Работа с базами данных через Spring Data JPA\n18. Практическая работа №9. Подключение базы данных через Spring Data JPA.\n19. Аутентификация и безопасность\n20. Практическая работа №10. Настройка Spring Security.\n21. Валидация данных на сервере\n22. Практическая работа №11. Реализация серверной валидации данных.\n23. Логирование и мониторинг\n24. Практическая работа №12. Настройка логирования и мониторинга приложения.\n25. Тестирование REST API\n26. Практическая работа №13. Тестирование REST-контроллеров.\n27. Работа с внешними API\n28. Практическая работа №14. Интеграция с внешним API.\n29. Фронтенд-взаимодействие\n30. Практическая работа №15. Связь backend и frontend.\n31. Контейнеризация приложения\n32. Практическая работа №16. Создание Docker-образа приложения.\n33. CI/CD для Java-приложения\n34. Практическая работа №17. Настройка CI/CD пайплайна.\n35. Оптимизация и масштабирование\n36. Практическая работа №18. Настройка масштабирования приложения.	\N	\N	\N
29	423	1	Модуль 1. Программирование на языке JavaScript	1. Введение в JavaScript и настройка окружения\n2. Практическая работа №1. Подключение JavaScript и работа в консоли\n3. Переменные и типы данных в JavaScript\n4. Практическая работа №2. Работа с переменными и преобразование типов\n5. Операторы и выражения в JavaScript\n6. Практическая работа №3. Использование операторов и выражений\n7. Условные конструкции и ветвления\n8. Практическая работа №4. Написание условных конструкций\n9. Циклы в JavaScript\n10. Практическая работа №5. Создание циклических алгоритмов\n11. Функции в JavaScript\n12. Практическая работа №6. Написание пользовательских функций\n13. Работа с областями видимости и контекстом this\n14. Практическая работа №7. Работа с this и контекстом функций\n15. Массивы и их методы\n16. Практическая работа №8. Работа с массивами и методами обработки данных\n17. Объекты в JavaScript\n18. Практическая работа №9. Создание и работа с объектами\n19. Деструктуризация и spread/rest-операторы\n20. Практическая работа №10. Использование деструктуризации и spread/rest\n21. Основы работы с DOM\n22. Практическая работа №11. Манипуляция DOM-элементами\n23. Обработчики событий в JavaScript\n24. Практическая работа №12. Работа с обработчиками событий\n25. Таймеры и задержки\n26. Практическая работа №13. Работа с таймерами и задержками\n27. Промисы и работа с асинхронным кодом\n28. Практическая работа №14. Создание и работа с промисами\n29. Async/Await и обработка данных\n30. Практическая работа №15. Использование fetch() и async/await\n31. Модули в JavaScript (import/export)\n32. Практическая работа №16. Работа с модулями JavaScript\n33. Работа с localStorage и sessionStorage\n34. Практическая работа №17. Хранение пользовательских данных\n35. Работа с API и JSON\n36. Практическая работа №18. Запрос к API и отображение данных	\N	\N	\N
30	423	2	Модуль 2. Разработка серверной части приложений на Node.js	1. Введение в Node.js и настройка окружения\n2. Практическая работа №1. Установка Node.js и написание первого скрипта\n3. Работа с модулями и пакеты в Node.js\n4. Практическая работа №2. Разработка небольшого проекта с несколькими модулями\n5. Асинхронное программирование и работа с файлами\n6. Практическая работа №3. Реализация чтения и записи данных в файлы\n7. Создание простого HTTP-сервера без Express\n8. Практическая работа №4. Создание простого HTTP-сервера и базовой маршрутизации\n9. Установка и базовая настройка Express\n10. Практическая работа №5. Настройка нового проекта на Express\n11. Маршрутизация и параметры запросов\n12. Практическая работа №6. Создание CRUD-маршрутов на Express\n13. Работа с шаблонизаторами (EJS, Pug)\n14. Практическая работа №7. Рендер динамической страницы через шаблонизатор\n15. Обработка статических файлов и логирование\n16. Практическая работа №8. Настройка статических файлов и логирования запросов\n17. Понятие middleware и создание собственного middleware\n18. Практическая работа №9. Разработка логирующего middleware\n19. Аутентификация и авторизация (JWT)\n20. Практическая работа №10. Реализация аутентификации с помощью JWT\n21. Обработка ошибок и валидация данных\n22. Практическая работа №11. Настройка валидации данных и обработки ошибок\n23. Защита API и CORS\n24. Практическая работа №12. Настройка и проверка CORS в Express\n25. Подключение к базам данных (MongoDB, PostgreSQL)\n26. Практическая работа №13. Создание и чтение данных из MongoDB / PostgreSQL\n27. Создание REST API и взаимодействие с клиентом\n28. Практическая работа №14. Реализация полнофункционального REST API\n29. Асинхронность и производительность\n30. Практическая работа №15. Оптимизация асинхронных запросов и кеширование\n31. Взаимодействие с внешними API\n32. Практическая работа №16. Получение и обработка данных из внешнего API\n33. Логирование и мониторинг\n34. Практическая работа №17. Настройка логирования и базового мониторинга\n35. Тестирование приложений на Node.js\n36. Практическая работа №18. Написание тестов для маршрутов Express	\N	\N	\N
31	423	3	Модуль 3. Работа с базами данных для WEB-приложений (MongoDB, PostgreSQL)	1. Введение в базы данных\n2. Практическая работа №1. Разработка первого приложения с базой данных\n3. Основы SQL и реляционные базы данных (PostgreSQL)\n4. Практическая работа №2. Написание SQL-запросов для работы с данными\n5. PostgreSQL: создание таблиц и связей\n6. Практическая работа №3. Создание таблиц и установление связей в PostgreSQL\n7. Основы работы с MongoDB (NoSQL)\n8. Практическая работа №4. Создание коллекций и работа с документами в MongoDB\n9. Работа с индексацией и оптимизация запросов в PostgreSQL\n10. Практическая работа №5. Создание индексов и оптимизация SQL-запросов\n11. Работа с подзапросами и объединениями в PostgreSQL\n12. Практическая работа №6. Работа с подзапросами и объединениями в PostgreSQL\n13. Хранение и обработка больших объемов данных в PostgreSQL\n14. Практическая работа №7. Работа с большими объемами данных в PostgreSQL\n15. Операции с MongoDB: фильтрация, обновление и удаление данных\n16. Практическая работа №8. Фильтрация, обновление и удаление данных в MongoDB\n17. Интеграция PostgreSQL с Node.js\n18. Практическая работа №9. Интеграция PostgreSQL с Node.js\n19. Использование MongoDB с Node.js\n20. Практическая работа №10. Подключение и работа с MongoDB в Node.js\n21. Реализация CRUD операций с PostgreSQL\n22. Практическая работа №11. Реализация CRUD операций с PostgreSQL\n23. Реализация CRUD операций с MongoDB\n24. Практическая работа №12. Реализация CRUD операций с MongoDB\n25. Оптимизация работы с базами данных\n26. Практическая работа №13. Оптимизация запросов в PostgreSQL и MongoDB\n27. Безопасность в PostgreSQL\n28. Практическая работа №14. Реализация безопасности в PostgreSQL\n29. Безопасность и защита данных в MongoDB\n30. Практическая работа №15. Реализация безопасности и защиты данных в MongoDB\n31. Резервное копирование и восстановление данных\n32. Практическая работа №16. Настройка резервного копирования и восстановления\n33. Моделирование данных и проектирование баз данных\n34. Практическая работа №17. Проектирование структуры базы данных для проекта\n35. Построение многозвенных приложений с интеграцией баз данных\n36. Практическая работа №18. Разработка многозвенного приложения с БД	\N	\N	\N
32	423	4	Модуль 4. Разработка REST API и интеграция с клиентской частью WEB-приложений	1. Введение в REST API\n2. Практическая работа №1. Создание простого API с использованием HTTP методов\n3. Разработка первого REST API\n4. Практическая работа №2. Разработка базового REST API на Express\n5. Управление данными через API\n6. Практическая работа №3. Реализация операций управления данными через API\n7. Работа с параметрами запроса\n8. Практическая работа №4. Работа с параметрами запроса в API\n9. Основы авторизации и аутентификации\n10. Практическая работа №5. Реализация базовой аутентификации\n11. Защита API с помощью JWT\n12. Практическая работа №6. Настройка защиты API с использованием JWT\n13. Работа с CORS (Cross-Origin Resource Sharing)\n14. Практическая работа №7. Настройка CORS для API\n15. Ограничение доступа и использование ролей\n16. Практическая работа №8. Реализация ролевой модели доступа\n17. Введение в взаимодействие API и фронтенда\n18. Практическая работа №9. Интеграция API с фронтендом\n19. Обработка ответов API на фронтенде\n20. Практическая работа №10. Обработка ответов API на клиентской стороне\n21. Интеграция с фронтендом с использованием AJAX\n22. Практическая работа №11. Интеграция API через AJAX\n23. Работа с формами на фронтенде через API\n24. Практическая работа №12. Отправка и обработка форм через API\n25. Логирование и мониторинг API\n26. Практическая работа №13. Настройка логирования API\n27. Обработка ошибок в REST API\n28. Практическая работа №14. Реализация обработки ошибок в API\n29. Кэширование данных в API\n30. Практическая работа №15. Реализация кэширования данных\n31. Разработка версионированных API\n32. Практическая работа №16. Создание версионированного API\n33. Основы тестирования API\n34. Практическая работа №17. Написание тестов для REST API\n35. Создание документации для API\n36. Практическая работа №18. Создание документации REST API	\N	\N	\N
33	424	1	Модуль 1. Программирование на языке JavaScript	1. Введение в JavaScript и настройка окружения\n2. Практическая работа №1. Подключение JavaScript и работа в консоли\n3. Переменные и типы данных в JavaScript\n4. Практическая работа №2. Работа с переменными и преобразование типов\n5. Операторы и выражения в JavaScript\n6. Практическая работа №3. Использование операторов и выражений\n7. Условные конструкции и ветвления\n8. Практическая работа №4. Написание условных конструкций\n9. Циклы в JavaScript\n10. Практическая работа №5. Создание циклических алгоритмов\n11. Функции в JavaScript\n12. Практическая работа №6. Написание пользовательских функций\n13. Работа с областями видимости и контекстом this\n14. Практическая работа №7. Работа с this и контекстом функций\n15. Массивы и их методы\n16. Практическая работа №8. Работа с массивами и методами обработки данных\n17. Объекты в JavaScript\n18. Практическая работа №9. Создание и работа с объектами\n19. Деструктуризация и spread/rest-операторы\n20. Практическая работа №10. Использование деструктуризации и spread/rest\n21. Основы работы с DOM\n22. Практическая работа №11. Манипуляция DOM-элементами\n23. Обработчики событий в JavaScript\n24. Практическая работа №12. Работа с обработчиками событий\n25. Таймеры и задержки\n26. Практическая работа №13. Работа с таймерами и задержками\n27. Промисы и работа с асинхронным кодом\n28. Практическая работа №14. Создание и работа с промисами\n29. Async/Await и обработка данных\n30. Практическая работа №15. Использование fetch() и async/await\n31. Модули в JavaScript (import/export)\n32. Практическая работа №16. Работа с модулями JavaScript\n33. Работа с localStorage и sessionStorage\n34. Практическая работа №17. Хранение пользовательских данных\n35. Работа с API и JSON\n36. Практическая работа №18. Запрос к API и отображение данных	\N	\N	\N
34	424	2	Модуль 2. Работа с базами данных и интеграция с backend	1. Введение в Node.js и настройка окружения\n2. Практическая работа №1. Установка Node.js и написание первого скрипта\n3. Работа с модулями и пакеты в Node.js\n4. Практическая работа №2. Разработка небольшого проекта с несколькими модулями\n5. Асинхронное программирование и работа с файлами\n6. Практическая работа №3. Реализация чтения и записи данных в файлы\n7. Создание простого HTTP-сервера без Express\n8. Практическая работа №4. Создание простого HTTP-сервера и базовой маршрутизации\n9. Установка и базовая настройка Express\n10. Практическая работа №5. Настройка нового проекта на Express\n11. Маршрутизация и параметры запросов\n12. Практическая работа №6. Создание CRUD-маршрутов на Express\n13. Работа с шаблонизаторами (EJS, Pug)\n14. Практическая работа №7. Рендер динамической страницы через шаблонизатор\n15. Обработка статических файлов и логирование\n16. Практическая работа №8. Настройка статических файлов и логирования запросов\n17. Понятие middleware и создание собственного middleware\n18. Практическая работа №9. Разработка логирующего middleware\n19. Аутентификация и авторизация (JWT)\n20. Практическая работа №10. Реализация аутентификации с помощью JWT\n21. Обработка ошибок и валидация данных\n22. Практическая работа №11 Настройка валидации данных и обработки ошибок\n23. Защита API и CORS\n24. Практическая работа №12. Настройка и проверка CORS в Express\n25. Подключение к базам данных (MongoDB, PostgreSQL)\n26. Практическая работа №13.. Создание и чтение данных из MongoDB / PostgreSQL\n27. Создание REST API и взаимодействие с клиентом\n28. Практическая работа №14. Реализация полнофункционального REST API\n29. Асинхронность и производительность\n30. Практическая работа №15. Оптимизация асинхронных запросов и кеширование\n31. Взаимодействие с внешними API\n32. Практическая работа №16. Получение и обработка данных из внешнего API\n33. Логирование и мониторинг\n34. Практическая работа №17. Настройка логирования и базового мониторинга\n35. Тестирование приложений на Node.js\n36. Практическая работа №18. Написание тестов для маршрутов Express	\N	\N	\N
35	424	3	Модуль 3. Аутентификация, авторизация и продвинутый backend	1. Введение в базы данных\n2. Практическая работа №1. Разработка первого приложения с базой данных\n3. Основы SQL и реляционные базы данных (PostgreSQL)\n4. Практическая работа №2. Написание SQL-запросов для работы с данными\n5. PostgreSQL: создание таблиц и связей\n6. Практическая работа №3. Создание таблиц и установление связей в PostgreSQL\n7. Основы работы с MongoDB (NoSQL)\n8. Практическая работа №4. Создание коллекций и работа с документами в MongoDB\n9. Работа с индексацией и оптимизация запросов в PostgreSQL\n10. Практическая работа №5. Создание индексов и оптимизация SQL-запросов\n11. Работа с подзапросами и объединениями в PostgreSQL\n12. Практическая работа №6. Работа с подзапросами и объединениями в PostgreSQL\n13. Хранение и обработка больших объемов данных в PostgreSQL\n14. Практическая работа №7. Работа с большими объемами данных в PostgreSQL\n15. Операции с MongoDB: фильтрация, обновление и удаление данных\n16. Практическая работа №8. Фильтрация, обновление и удаление данных в MongoDB\n17. Интеграция PostgreSQL с Node.js\n18. Практическая работа №9. Интеграция PostgreSQL с Node.js\n19. Использование MongoDB с Node.js\n20. Практическая работа №10. Подключение и работа с MongoDB в Node.js\n21. Реализация CRUD операций с PostgreSQL\n22. Практическая работа №11. Реализация CRUD операций с PostgreSQL\n23. Реализация CRUD операций с MongoDB\n24. Практическая работа №12. Реализация CRUD операций с MongoDB\n25. Оптимизация работы с базами данных\n26. Практическая работа №13. Оптимизация запросов в PostgreSQL и MongoDB\n27. Безопасность в PostgreSQL\n28. Практическая работа №14. Реализация безопасности в PostgreSQL\n29. Безопасность и защита данных в MongoDB\n30. Практическая работа №15. Реализация безопасности и защиты данных в MongoDB\n31. Резервное копирование и восстановление данных\n32. Практическая работа №16. Настройка резервного копирования и восстановления\n33. Моделирование данных и проектирование баз данных\n34. Практическая работа №17. Проектирование структуры базы данных для проекта\n35. Построение многозвенных приложений с интеграцией баз данных\n36. Практическая работа №18. Разработка многозвенного приложения с БД	\N	\N	\N
36	424	4	Модуль 4. Разработка REST API и интеграция с клиентской частью WEB-приложений	1. Введение в REST API\n2. Практическая работа №1. Создание простого API с использованием HTTP методов\n3. Разработка первого REST API\n4. Практическая работа №2. Разработка базового REST API на Express\n5. Управление данными через API\n6. Практическая работа №3. Реализация операций управления данными через API\n7. Работа с параметрами запроса\n8. Практическая работа №4. Работа с параметрами запроса в API\n9. Основы авторизации и аутентификации\n10. Практическая работа №5. Реализация базовой аутентификации\n11. Защита API с помощью JWT\n12. Практическая работа №6. Настройка защиты API с использованием JWT\n13. Работа с CORS (Cross-Origin Resource Sharing)\n14. Практическая работа №7. Настройка CORS для API\n15. Ограничение доступа и использование ролей\n16. Практическая работа №8. Реализация ролевой модели доступа\n17. Введение в взаимодействие API и фронтенда\n18. Практическая работа №9. Интеграция API с фронтендом\n19. Обработка ответов API на фронтенде\n20. Практическая работа №10. Обработка ответов API на клиентской стороне\n21. Интеграция с фронтендом с использованием AJAX\n22. Практическая работа №11. Интеграция API через AJAX\n23. Работа с формами на фронтенде через API\n24. Практическая работа №12. Отправка и обработка форм через API\n25. Логирование и мониторинг API\n26. Практическая работа №13. Настройка логирования API\n27. Обработка ошибок в REST API\n28. Практическая работа №14. Реализация обработки ошибок в API\n29. Кэширование данных в API\n30. Практическая работа №15. Реализация кэширования данных\n31. Разработка версионированных API\n32. Практическая работа №16. Создание версионированного API\n33. Основы тестирования API\n34. Практическая работа №17. Написание тестов для REST API\n35. Создание документации для API\n36. Практическая работа №18. Создание документации REST API	\N	\N	\N
37	425	1	Модуль 1. Разработка WEB-страниц на HTML и CSS	1. Введение в веб-разработку и структура HTML-документа\n2. Практическая работа №1. Создание базовой HTML-страницы\n3. Работа с текстом в HTML\n4. Практическая работа №2. Разметка текста и списков на веб-странице\n5. Работа с изображениями, ссылками и медиа\n6. Практическая работа №3. Создание страницы с мультимедийным контентом\n7. Формы и пользовательский ввод\n8. Практическая работа №4. Создание формы регистрации\n9. Основы CSS и стилизация текста\n10. Практическая работа №5. Применение CSS к тексту и заголовкам\n11. Блочная модель и размеры элементов\n12. Практическая работа №6. Создание многоуровневой структуры страницы\n13. Расположение элементов и Flexbox\n14. Практическая работа №7. Создание адаптивного блока с Flexbox\n15. Сетка CSS Grid\n16. Практическая работа №8. Создание сетки для страницы\n17. Медиа-запросы и адаптивность\n18. Практическая работа №9. Адаптация страницы под мобильные устройства\n19. CSS-анимации и переходы\n20. Практическая работа №10. Добавление анимации к кнопке\n21. Введение в SCSS и препроцессоры\n22. Практическая работа №11. Работа с SCSS\n23. Работа с иконочными шрифтами и SVG\n24. Практическая работа №12. Использование иконок на веб-странице\n25. Темизация сайтов (темная и светлая темы)\n26. Практическая работа №13. Создание переключателя тем\n27. Основы взаимодействия HTML и JavaScript\n28. Практическая работа №14. Изменение стиля страницы через JS\n29. Валидация форм с помощью JavaScript\n30. Практическая работа №15. Реализация валидации формы\n31. Основы работы с макетами Figma\n32. Практическая работа №16. Анализ макета Figma\n33. Верстка по макету Figma\n34. Практическая работа №17. Верстка макета из Figma\n35. Пространства имён и сборка проекта\n36. Практическая работа №18. Оптимизация готовой страницы	\N	\N	\N
38	425	2	Модуль 2. Программирование на языке JavaScript	1. Введение в JavaScript и настройка окружения\n2. Практическая работа №1. Подключение JavaScript и работа в консоли\n3. Переменные и типы данных в JavaScript\n4. Практическая работа №2. Работа с переменными и преобразование типов\n5. Операторы и выражения в JavaScript\n6. Практическая работа №3. Использование операторов и выражений\n7. Условные конструкции и ветвления\n8. Практическая работа №4. Написание условных конструкций\n9. Циклы в JavaScript\n10. Практическая работа №5. Создание циклических алгоритмов\n11. Функции в JavaScript\n12. Практическая работа №6. Написание пользовательских функций\n13. Работа с областями видимости и контекстом this\n14. Практическая работа №7. Работа с this и контекстом функций\n15. Массивы и их методы\n16. Практическая работа №8. Работа с массивами и методами обработки данных\n17. Объекты в JavaScript\n18. Практическая работа №9. Создание и работа с объектами\n19. Деструктуризация и spread/rest-операторы\n20. Практическая работа №10. Использование деструктуризации и spread/rest\n21. Основы работы с DOM\n22. Практическая работа №11. Манипуляция DOM-элементами\n23. Обработчики событий в JavaScript\n24. Практическая работа №12. Работа с обработчиками событий\n25. Таймеры и задержки\n26. Практическая работа №13. Работа с таймерами и задержками\n27. Промисы и работа с асинхронным кодом\n28. Практическая работа №14. Создание и работа с промисами\n29. Async/Await и обработка данных\n30. Практическая работа №15. Использование fetch() и async/await\n31. Модули в JavaScript (import/export)\n32. Практическая работа №16. Работа с модулями JavaScript\n33. Работа с localStorage и sessionStorage\n34. Практическая работа №17. Хранение пользовательских данных\n35. Работа с API и JSON\n36. Практическая работа №18. Запрос к API и отображение данных	\N	\N	\N
39	425	3	Модуль 3. JavaScript для frontend-разработки	1. Глубже в JavaScript: продвинутая работа с переменными и типами данных\n2. Практическая работа №1. Исследование типов данных и областей видимости\n3. Callback-функции и функциональное программирование\n4. Практическая работа №2. Работа с callback-функциями\n5. Работа с массивами: продвинутые методы\n6. Практическая работа №3. Фильтрация и сортировка данных в массиве\n7. Объекты, прототипное наследование и классы\n8. Практическая работа №4. Создание классов и работа с объектами\n9. DOM-дерево и его манипуляция\n10. Практическая работа №5. Динамическое изменение веб-страницы с помощью JS\n11. Работа с событиями в браузере\n12. Практическая работа №6. Добавление обработчиков событий на страницу\n13. Анимации и стилизация элементов через JavaScript\n14. Практическая работа №7. Создание динамической анимации на JS\n15. Основы jQuery: подключение и селекторы\n16. Практическая работа №8. Работа с селекторами jQuery\n17. События в jQuery\n18. Практическая работа №9. Работа с событиями в jQuery\n19. Эффекты и анимации в jQuery\n20. Практическая работа №10. Добавление анимаций с jQuery\n21. Работа с AJAX и JSON в JavaScript\n22. Практическая работа №11. Запрос данных с API и их отображение на странице\n23. AJAX-запросы в jQuery\n24. Практическая работа №12. Получение данных с сервера через AJAX\n25. Работа с localStorage и sessionStorage\n26. Практическая работа №13. Реализация локального хранения данных\n27. Работа с модулями ES6\n28. Практическая работа №14. Подключение и работа с модулями.\n29. Работа с асинхронными операциями (Async/Await)\n30. Практическая работа №15. Написание асинхронного запроса к API.\n31. Ошибки и их обработка в JavaScript\n32. Практическая работа №16. Обработка ошибок в коде\n33. Оптимизация кода и рефакторинг\n34. Практическая работа №17. Рефакторинг и оптимизация JS-кода.\n35. Взаимодействие фронтенда и бэкенда\n36. Практическая работа №18. Создание взаимодействия между клиентом и сервером.	\N	\N	\N
40	425	4	Модуль 4. Разработка на фреймворке React.js	1. Введение в React.js и создание первого проекта\n2. Практическая работа №1. Создание первого React-приложения\n3. JSX и основы работы с компонентами\n4. Практическая работа №2. Создание компонентов с использованием JSX\n5. Работа с пропсами и состоянием (props & state)\n6. Практическая работа №3. Работа с props и state\n7. Основы хуков (hooks) в React\n8. Практическая работа №4. Использование хуков в React\n9. Работа с событиями в React\n10. Практическая работа №5. Обработка событий в React\n11. Использование CSS-модулей и стилизация компонентов\n12. Практическая работа №6. Стилизация компонентов React\n13. Управление списками и рендеринг данных\n14. Практическая работа №7. Рендеринг списков данных\n15. Контролируемые и неконтролируемые компоненты\n16. Практическая работа №8. Работа с формами в React\n17. React Router: основы навигации\n18. Практическая работа №9. Настройка маршрутизации\n19. Работа с REST API в React\n20. Практическая работа №10. Интеграция React-приложения с API\n21. Управление состоянием с Redux\n22. Практическая работа №11. Настройка Redux в проекте\n23. Работа с контекстом (Context API)\n24. Практическая работа №12. Использование Context API\n25. Оптимизация рендеринга компонентов\n26. Практическая работа №13. Оптимизация производительности React\n27. Ленивая загрузка компонентов\n28. Практическая работа №14. Реализация lazy loading\n29. Тестирование React-приложений\n30. Практическая работа №15. Тестирование компонентов\n31. Работа с анимацией в React\n32. Практическая работа №16. Добавление анимаций\n33. Подключение Firebase в React-приложении\n34. Практическая работа №17. Интеграция Firebase\n35. Работа с WebSockets (Socket.io)\n36. Практическая работа №18. Реализация WebSocket-соединения	\N	\N	\N
41	426	1	Модуль 1. Разработка WEB-страниц на HTML и CSS	1. Введение в веб-разработку и структура HTML-документа\n2. Практическая работа №1. Создание базовой HTML-страницы\n3. Работа с текстом в HTML\n4. Практическая работа №2. Разметка текста и списков на веб-странице\n5. Работа с изображениями, ссылками и медиа\n6. Практическая работа №3. Создание страницы с мультимедийным контентом\n7. Формы и пользовательский ввод\n8. Практическая работа №4. Создание формы регистрации\n9. Основы CSS и стилизация текста\n10. Практическая работа №5. Применение CSS к тексту и заголовкам\n11. Блочная модель и размеры элементов\n12. Практическая работа №6. Создание многоуровневой структуры страницы\n13. Расположение элементов и Flexbox\n14. Практическая работа №7. Создание адаптивного блока с Flexbox\n15. Сетка CSS Grid\n16. Практическая работа №8. Создание сетки для страницы\n17. Медиа-запросы и адаптивность\n18. Практическая работа №9. Адаптация страницы под мобильные устройства\n19. CSS-анимации и переходы\n20. Практическая работа №10. Добавление анимации к кнопке\n21. Введение в SCSS и препроцессоры\n22. Практическая работа №11. Работа с SCSS\n23. Работа с иконочными шрифтами и SVG\n24. Практическая работа №12. Использование иконок на веб-странице\n25. Темизация сайтов (темная и светлая темы)\n26. Практическая работа №13. Создание переключателя тем\n27. Основы взаимодействия HTML и JavaScript\n28. Практическая работа №14. Изменение стиля страницы через JS\n29. Валидация форм с помощью JavaScript\n30. Практическая работа №15. Реализация валидации формы\n31. Основы работы с макетами Figma\n32. Практическая работа №16. Анализ макета Figma\n33. Верстка по макету Figma\n34. Практическая работа №17. Верстка макета из Figma\n35. Пространства имён и сборка проекта\n36. Практическая работа №18. Оптимизация готовой страницы	\N	\N	\N
42	426	2	Модуль 2. Программирование на языке JavaScript	1. Введение в JavaScript и настройка окружения\n2. Практическая работа №1. Подключение JavaScript и работа в консоли\n3. Переменные и типы данных в JavaScript\n4. Практическая работа №2. Работа с переменными и преобразование типов\n5. Операторы и выражения в JavaScript\n6. Практическая работа №3. Использование операторов и выражений\n7. Условные конструкции и ветвления\n8. Практическая работа №4. Написание условных конструкций\n9. Циклы в JavaScript\n10. Практическая работа №5. Создание циклических алгоритмов\n11. Функции в JavaScript\n12. Практическая работа №6. Написание пользовательских функций\n13. Работа с областями видимости и контекстом this\n14. Практическая работа №7. Работа с this и контекстом функций\n15. Массивы и их методы\n16. Практическая работа №8. Работа с массивами и методами обработки данных\n17. Объекты в JavaScript\n18. Практическая работа №9. Создание и работа с объектами\n19. Деструктуризация и spread/rest-операторы\n20. Практическая работа №10. Использование деструктуризации и spread/rest\n21. Основы работы с DOM\n22. Практическая работа №11. Манипуляция DOM-элементами\n23. Обработчики событий в JavaScript\n24. Практическая работа №12. Работа с обработчиками событий\n25. Таймеры и задержки\n26. Практическая работа №13. Работа с таймерами и задержками\n27. Промисы и работа с асинхронным кодом\n28. Практическая работа №14. Создание и работа с промисами\n29. Async/Await и обработка данных\n30. Практическая работа №15. Использование fetch() и async/await\n31. Модули в JavaScript (import/export)\n32. Практическая работа №16. Работа с модулями JavaScript\n33. Работа с localStorage и sessionStorage\n34. Практическая работа №17. Хранение пользовательских данных\n35. Работа с API и JSON\n36. Практическая работа №18. Запрос к API и отображение данных	\N	\N	\N
43	426	3	Модуль 3. JavaScript для frontend-разработки	1. Глубже в JavaScript: продвинутая работа с переменными и типами данных\n2. Практическая работа №1. Исследование типов данных и областей видимости\n3. Callback-функции и функциональное программирование\n4. Практическая работа №2. Работа с callback-функциями\n5. Работа с массивами: продвинутые методы\n6. Практическая работа №3. Фильтрация и сортировка данных в массиве\n7. Объекты, прототипное наследование и классы\n8. Практическая работа №4. Создание классов и работа с объектами\n9. DOM-дерево и его манипуляция\n10. Практическая работа №5. Динамическое изменение веб-страницы с помощью JS\n11. Работа с событиями в браузере\n12. Практическая работа №6. Добавление обработчиков событий на страницу\n13. Анимации и стилизация элементов через JavaScript\n14. Практическая работа №7. Создание динамической анимации на JS\n15. Основы jQuery: подключение и селекторы\n16. Практическая работа №8. Работа с селекторами jQuery\n17. События в jQuery\n18. Практическая работа №9. Работа с событиями в jQuery\n19. Эффекты и анимации в jQuery\n20. Практическая работа №10. Добавление анимаций с jQuery\n21. Работа с AJAX и JSON в JavaScript\n22. Практическая работа №11. Запрос данных с API и их отображение на странице\n23. AJAX-запросы в jQuery\n24. Практическая работа №12. Получение данных с сервера через AJAX\n25. Работа с localStorage и sessionStorage\n26. Практическая работа №13. Реализация локального хранения данных\n27. Работа с модулями ES6\n28. Практическая работа №14. Подключение и работа с модулями.\n29. Работа с асинхронными операциями (Async/Await)\n30. Практическая работа №15. Написание асинхронного запроса к API.\n31. Ошибки и их обработка в JavaScript\n32. Практическая работа №16. Обработка ошибок в коде\n33. Оптимизация кода и рефакторинг\n34. Практическая работа №17. Рефакторинг и оптимизация JS-кода.\n35. Взаимодействие фронтенда и бэкенда\n36. Практическая работа №18. Создание взаимодействия между клиентом и сервером.	\N	\N	\N
44	426	4	Модуль 4. Разработка на фреймворке React.js	1. Введение в React.js и создание первого проекта\n2. Практическая работа №1. Создание первого React-приложения\n3. JSX и основы работы с компонентами\n4. Практическая работа №2. Создание компонентов с использованием JSX\n5. Работа с пропсами и состоянием (props & state)\n6. Практическая работа №3. Работа с props и state\n7. Основы хуков (hooks) в React\n8. Практическая работа №4. Использование хуков в React\n9. Работа с событиями в React\n10. Практическая работа №5. Обработка событий в React\n11. Использование CSS-модулей и стилизация компонентов\n12. Практическая работа №6. Стилизация компонентов React\n13. Управление списками и рендеринг данных\n14. Практическая работа №7. Рендеринг списков данных\n15. Контролируемые и неконтролируемые компоненты\n16. Практическая работа №8. Работа с формами в React\n17. React Router: основы навигации\n18. Практическая работа №9. Настройка маршрутизации\n19. Работа с REST API в React\n20. Практическая работа №10. Интеграция React-приложения с API\n21. Управление состоянием с Redux\n22. Практическая работа №11. Настройка Redux в проекте\n23. Работа с контекстом (Context API)\n24. Практическая работа №12. Использование Context API\n25. Оптимизация рендеринга компонентов\n26. Практическая работа №13. Оптимизация производительности React\n27. Ленивая загрузка компонентов\n28. Практическая работа №14. Реализация lazy loading\n29. Тестирование React-приложений\n30. Практическая работа №15. Тестирование компонентов\n31. Работа с анимацией в React\n32. Практическая работа №16. Добавление анимаций\n33. Подключение Firebase в React-приложении\n34. Практическая работа №17. Интеграция Firebase\n35. Работа с WebSockets (Socket.io)\n36. Практическая работа №18. Реализация WebSocket-соединения	\N	\N	\N
45	427	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями.\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных.\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций.\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях.\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов.\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных.\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных.\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON.\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах.\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений.	\N	\N	\N
46	427	2	Модуль 2. Тестирование и автоматизация на Python	1. Введение в тестирование программного обеспечения\n2. Практическая работа №1. Установка инструментов для автоматизированного тестирования.\n3. Основные принципы тестирования\n4. Практическая работа №2. Разработка чек-листа тестирования веб-приложения.\n5. Разработка тест-кейсов\n6. Практическая работа №3. Написание тест-кейсов для API-приложения.\n7. Основы автоматизации тестирования\n8. Практическая работа №4. Написание первых автотестов на Python.\n9. Автоматизация UI-тестирования (Selenium)\n10. Практическая работа №5. Запуск первого автотеста с Selenium.\n11. Локаторы в Selenium\n12. Практическая работа №6. Использование различных локаторов в Selenium.\n13. Работа с формами, кнопками и событиями\n14. Практическая работа №7. Автоматизация работы с формами на веб-странице.\n15. Ожидания в Selenium (Implicit и Explicit Waits)\n16. Практическая работа №8. Реализация ожиданий при автоматизированном тестировании.\n17. Основы юнит-тестирования на Python\n18. Практическая работа №9. Написание первого юнит-теста на pytest.\n19. Использование фикстур в Pytest\n20. Практическая работа №10. Использование фикстур в тестировании API.\n21. Ассерты и параметризация тестов\n22. Практическая работа №11. Создание параметризованных тестов на Python.\n23. Изоляция тестов и моки (mocking)\n24. Практическая работа №12. Имитация зависимостей с mock-объектами.\n25. Использование Allure для отчетов\n26. Практическая работа №13. Настройка отчётов Allure для тестирования Python-кода.\n27. Запуск тестов в параллельном режиме\n28. Практическая работа №14. Запуск параллельных тестов с Pytest.\n29. Автоматизация тестирования REST API\n30. Практическая работа №15. Автоматическое тестирование API с использованием Pytest.\n31. Введение в CI/CD и автоматизацию тестов\n32. Практическая работа №16. Интеграция тестов в CI/CD пайплайн.\n33. Использование Docker для тестирования\n34. Практическая работа №17. Запуск автотестов в контейнерах Docker.\n35. Генерация тестовых данных\n36. Практическая работа №18. Генерация тестовых данных в автотестах.	\N	\N	\N
47	427	3	Модуль 3. API-тестирование и автоматизация на Python	1. Введение в API и принципы работы REST\n2. Практическая работа №1. Отправка HTTP-запросов вручную с Postman и cURL.\n3. HTTP-запросы и коды ответов\n4. Практическая работа №2. Отправка HTTP-запросов с разными методами и заголовками.\n5. Основы API-тестирования\n6. Практическая работа №3. Разработка тест-кейсов для API-тестирования.\n7. Работа с JSON и обработка ответов API\n8. Практическая работа №4. Обработка JSON-ответов и проверка их структуры.\n9. Введение в Postman\n10. Практическая работа №5. Создание тестового сценария API в Postman.\n11. Написание тестов в Postman (Test Scripts)\n12. Практическая работа №6. Написание тестов для API в Postman.\n13. Передача переменных и авторизация в Postman\n14. Практическая работа №7. Авторизация и тестирование API с токенами.\n15. Импорт API-запросов в Python из Postman\n16. Практическая работа №8. Экспорт тестов из Postman и запуск их в Python.\n17. Использование Requests для API-тестирования\n18. Практическая работа №9. Написание тестов API на основе requests.\n19. Использование Pytest для API-тестов\n20. Практическая работа №10. Организация API-тестов в Pytest.\n21. Валидация JSON-схем API\n22. Практическая работа №11. Валидация JSON-ответов API с jsonschema.\n23. Работа с mock-серверами и тестирование API без бэкенда\n24. Практическая работа №12. Создание мокированного API для тестирования.\n25. Асинхронные API-запросы с aiohttp\n26. Практическая работа №13. Запуск асинхронных API-запросов.\n27. Обработка ошибок и таймаутов в API\n28. Практическая работа №14. Обработка ошибок в API-запросах.\n29. Логирование API-запросов\n30. Практическая работа №15. Настройка логирования API-запросов.\n31. Введение в CI/CD для API-тестов\n32. Практическая работа №16. Запуск API-тестов в Jenkins\n33. Контейнеризация API-тестов с Docker\n34. Практическая работа №17. Автоматизированный запуск API-тестов в Docker\n35. Нагрузочное тестирование API (Locust, JMeter)\n36. Практическая работа №18. Запуск нагрузочного теста API с Locust	\N	\N	\N
48	427	4	Модуль 4. Автоматизация тестирования на Python	1. Введение в автоматизацию тестирования\n2. Практическая работа №1. Настройка окружения для автоматизированного тестирования\n3. Автоматизация UI-тестирования в браузере\n4. Практическая работа №2. Написание автотеста для веб-приложения\n5. Автоматизация API-тестирования\n6. Практическая работа №3. Автоматизированное тестирование API с pytest\n7. Автоматизация тестирования мобильных приложений\n8. Практическая работа №4. Запуск автотеста мобильного приложения в эмуляторе\n9. Введение в CI/CD и тестирование\n10. Практическая работа №5. Настройка автоматического запуска тестов в CI/CD\n11. Запуск автотестов в контейнерах (Docker)\n12. Практическая работа №6. Запуск автотестов в Docker-контейнере\n13. Управление тестовыми окружениями в Kubernetes\n14. Практическая работа №7. Запуск тестового окружения в Kubernetes\n15. Использование Terraform и Ansible для настройки тестовой инфраструктуры\n16. Практическая работа №8. Автоматизированное развертывание тестовой инфраструктуры с Ansible\n17. Введение в системы отчетности тестирования\n18. Практическая работа №9. Настройка отчетности Allure для тестов\n19. Логирование тестов и анализ ошибок\n20. Практическая работа №10. Настройка логирования и анализа ошибок автотестов.\n21. Интеграция отчетов в CI/CD\n22. Практическая работа №11. Автоматическая публикация отчетов в CI/CD\n23. Мониторинг автотестов в реальном времени\n24. Практическая работа №12. Настройка мониторинга автотестов с Prometheus\n25. Оптимизация тестов: ускорение и параллельный запуск\n26. Практическая работа №13. Запуск тестов в многопоточном режиме\n27. Использование моков и заглушек\n28. Практическая работа №14. Использование моков для тестирования зависимостей\n29. Динамическое тестирование: генерация тестов на лету\n30. Практическая работа №15. Генерация тестов на основе случайных данных\n31. Инструменты мониторинга тестов в продакшене\n32. Практическая работа №16. Мониторинг автотестов после релиза\n33. Тестирование в продакшене (Shift Right Testing)\n34. Практическая работа №17. Анализ логов пользователей и тестирование в продакшене\n35. Автоматизация тестирования безопасности (Security Testing)\n36. Практическая работа №18. Тестирование безопасности API	\N	\N	\N
49	428	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями.\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных.\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций.\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях.\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов.\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных.\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных.\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON.\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах.\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений.	\N	\N	\N
50	428	2	Модуль 2. Тестирование и автоматизация на Python	1. Введение в тестирование программного обеспечения\n2. Практическая работа №1. Установка инструментов для автоматизированного тестирования.\n3. Основные принципы тестирования\n4. Практическая работа №2. Разработка чек-листа тестирования веб-приложения.\n5. Разработка тест-кейсов\n6. Практическая работа №3. Написание тест-кейсов для API-приложения.\n7. Основы автоматизации тестирования\n8. Практическая работа №4. Написание первых автотестов на Python.\n9. Автоматизация UI-тестирования (Selenium)\n10. Практическая работа №5. Запуск первого автотеста с Selenium.\n11. Локаторы в Selenium\n12. Практическая работа №6. Использование различных локаторов в Selenium.\n13. Работа с формами, кнопками и событиями\n14. Практическая работа №7. Автоматизация работы с формами на веб-странице.\n15. Ожидания в Selenium (Implicit и Explicit Waits)\n16. Практическая работа №8. Реализация ожиданий при автоматизированном тестировании.\n17. Основы юнит-тестирования на Python\n18. Практическая работа №9. Написание первого юнит-теста на pytest.\n19. Использование фикстур в Pytest\n20. Практическая работа №10. Использование фикстур в тестировании API.\n21. Ассерты и параметризация тестов\n22. Практическая работа №11. Создание параметризованных тестов на Python.\n23. Изоляция тестов и моки (mocking)\n24. Практическая работа №12. Имитация зависимостей с mock-объектами.\n25. Использование Allure для отчетов\n26. Практическая работа №13. Настройка отчётов Allure для тестирования Python-кода.\n27. Запуск тестов в параллельном режиме\n28. Практическая работа №14. Запуск параллельных тестов с Pytest.\n29. Автоматизация тестирования REST API\n30. Практическая работа №15. Автоматическое тестирование API с использованием Pytest.\n31. Введение в CI/CD и автоматизацию тестов\n32. Практическая работа №16. Интеграция тестов в CI/CD пайплайн.\n33. Использование Docker для тестирования\n34. Практическая работа №17. Запуск автотестов в контейнерах Docker.\n35. Генерация тестовых данных\n36. Практическая работа №18. Генерация тестовых данных в автотестах.	\N	\N	\N
51	428	3	Модуль 3. API-тестирование и автоматизация на Python	1. Введение в API и принципы работы REST\n2. Практическая работа №1. Отправка HTTP-запросов вручную с Postman и cURL.\n3. HTTP-запросы и коды ответов\n4. Практическая работа №2. Отправка HTTP-запросов с разными методами и заголовками.\n5. Основы API-тестирования\n6. Практическая работа №3. Разработка тест-кейсов для API-тестирования.\n7. Работа с JSON и обработка ответов API\n8. Практическая работа №4. Обработка JSON-ответов и проверка их структуры.\n9. Введение в Postman\n10. Практическая работа №5. Создание тестового сценария API в Postman.\n11. Написание тестов в Postman (Test Scripts)\n12. Практическая работа №6. Написание тестов для API в Postman.\n13. Передача переменных и авторизация в Postman\n14. Практическая работа №7. Авторизация и тестирование API с токенами.\n15. Импорт API-запросов в Python из Postman\n16. Практическая работа №8. Экспорт тестов из Postman и запуск их в Python.\n17. Использование Requests для API-тестирования\n18. Практическая работа №9. Написание тестов API на основе requests.\n19. Использование Pytest для API-тестов\n20. Практическая работа №10. Организация API-тестов в Pytest.\n21. Валидация JSON-схем API\n22. Практическая работа №11. Валидация JSON-ответов API с jsonschema.\n23. Работа с mock-серверами и тестирование API без бэкенда\n24. Практическая работа №12. Создание мокированного API для тестирования.\n25. Асинхронные API-запросы с aiohttp\n26. Практическая работа №13. Запуск асинхронных API-запросов.\n27. Обработка ошибок и таймаутов в API\n28. Практическая работа №14. Обработка ошибок в API-запросах.\n29. Логирование API-запросов\n30. Практическая работа №15. Настройка логирования API-запросов.\n31. Введение в CI/CD для API-тестов\n32. Практическая работа №16. Запуск API-тестов в Jenkins\n33. Контейнеризация API-тестов с Docker\n34. Практическая работа №17. Автоматизированный запуск API-тестов в Docker\n35. Нагрузочное тестирование API (Locust, JMeter)\n36. Практическая работа №18. Запуск нагрузочного теста API с Locust	\N	\N	\N
52	428	4	Модуль 4. Автоматизация тестирования на Python	1. Введение в автоматизацию тестирования\n2. Практическая работа №1. Настройка окружения для автоматизированного тестирования\n3. Автоматизация UI-тестирования в браузере\n4. Практическая работа №2. Написание автотеста для веб-приложения\n5. Автоматизация API-тестирования\n6. Практическая работа №3. Автоматизированное тестирование API с pytest\n7. Автоматизация тестирования мобильных приложений\n8. Практическая работа №4. Запуск автотеста мобильного приложения в эмуляторе\n9. Введение в CI/CD и тестирование\n10. Практическая работа №5. Настройка автоматического запуска тестов в CI/CD\n11. Запуск автотестов в контейнерах (Docker)\n12. Практическая работа №6. Запуск автотестов в Docker-контейнере\n13. Управление тестовыми окружениями в Kubernetes\n14. Практическая работа №7. Запуск тестового окружения в Kubernetes\n15. Использование Terraform и Ansible для настройки тестовой инфраструктуры\n16. Практическая работа №8. Автоматизированное развертывание тестовой инфраструктуры с Ansible\n17. Введение в системы отчетности тестирования\n18. Практическая работа №9. Настройка отчетности Allure для тестов\n19. Логирование тестов и анализ ошибок\n20. Практическая работа №10. Настройка логирования и анализа ошибок автотестов.\n21. Интеграция отчетов в CI/CD\n22. Практическая работа №11. Автоматическая публикация отчетов в CI/CD\n23. Мониторинг автотестов в реальном времени\n24. Практическая работа №12. Настройка мониторинга автотестов с Prometheus\n25. Оптимизация тестов: ускорение и параллельный запуск\n26. Практическая работа №13. Запуск тестов в многопоточном режиме\n27. Использование моков и заглушек\n28. Практическая работа №14. Использование моков для тестирования зависимостей\n29. Динамическое тестирование: генерация тестов на лету\n30. Практическая работа №15. Генерация тестов на основе случайных данных\n31. Инструменты мониторинга тестов в продакшене\n32. Практическая работа №16. Мониторинг автотестов после релиза\n33. Тестирование в продакшене (Shift Right Testing)\n34. Практическая работа №17. Анализ логов пользователей и тестирование в продакшене\n35. Автоматизация тестирования безопасности (Security Testing)\n36. Практическая работа №18. Тестирование безопасности API	\N	\N	\N
53	429	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями.\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных.\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций.\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях.\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов.\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных.\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных.\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON.\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах.\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений.	\N	\N	\N
54	429	2	Модуль 2. Python для DevOps	1. Введение в DevOps и автоматизацию инфраструктуры\n2. Практическая работа №1. Установка и настройка окружения DevOps на локальной машине.\n3. Работа с серверами через SSH и Python\n4. Практическая работа №2. Написание Python-скрипта для удалённого администрирования сервера.\n5. Основы работы с Linux и автоматизация задач\n6. Практическая работа №3. Автоматизация резервного копирования файлов с помощью Python.\n7. Управление пользователями и правами доступа\n8. Практическая работа №4. Автоматизация управления пользователями на сервере.\n9. Введение в Ansible: автоматизация серверных конфигураций\n10. Практическая работа №5. Написание Ansible-плейбука для настройки сервера.\n11. Использование Python в Ansible\n12. Практическая работа №6. Создание пользовательского Ansible-модуля на Python\n13. Автоматизация инфраструктуры с Terraform\n14. Практическая работа №7. Написание Terraform-скрипта для развертывания серверов в облаке\n15. Python-скрипты для управления облачной инфраструктурой\n16. Практическая работа №8. Написание Python-скрипта для управления ресурсами\n17. Основы мониторинга и логирования в DevOps\n18. Практическая работа №9. Настройка базового мониторинга сервера с Prometheus\n19. Сбор метрик с помощью Prometheus\n20. Практическая работа №10. Разработка Python-метрик для Prometheus\n21. Визуализация метрик в Grafana\n22. Практическая работа №11. Настройка дашборда в Grafana для мониторинга серверов\n23. Логирование и анализ данных с ELK Stack\n24. Практическая работа №12. Настройка централизованного логирования с ELK Stack\n25. Автоматизация работы с логами\n26. Практическая работа №13. Создание системы логирования для DevOps инфраструктуры\n27. Настройка алертинга в DevOps\n28. Практическая работа №14. Автоматическая отправка уведомлений при сбоях системы\n29. Сбор и анализ системных логов\n30. Практическая работа №15. Автоматизированный анализ логов и мониторинг событий\n31. Основы CI/CD и автоматизированного развертывания\n32. Практическая работа №16. Настройка базового CI/CD пайплайна\n33. Интеграция Python-скриптов в CI/CD\n34. Практическая работа №17. Автоматизация тестов и деплоя с помощью CI/CD\n35. Kubernetes и оркестрация контейнеров\n36. Практическая работа №18. Деплой Python-приложения в Kubernetes	\N	\N	\N
55	429	3	Модуль 3. Работа с Docker и Kubernetes	1. Введение в контейнеризацию и Docker\n2. Практическая работа №1. Установка Docker и запуск первого контейнера\n3. Управление образами и контейнерами\n4. Практическая работа №2. Управление контейнерами и образами в Docker\n5. Работа с реестрами Docker\n6. Практическая работа №3. Размещение собственного Docker-образа в Docker Hub\n7. Сетевое взаимодействие контейнеров\n8. Практическая работа №4. Создание сети и подключение нескольких контейнеров\n9. Основы создания образов с Dockerfile\n10. Практическая работа №5. Написание Dockerfile для Python-приложения\n11. Переменные окружения и конфигурация контейнеров\n12. Практическая работа №6. Использование переменных окружения в контейнерах\n13. Оптимизация Docker-образов\n14. Практическая работа №7. Оптимизация Dockerfile для уменьшения размера образа\n15. Работа с Docker Logs и отладка контейнеров\n16. Практическая работа №8. Логирование и отладка контейнеров в Docker\n17. Введение в Docker Compose\n18. Практическая работа №9. Запуск нескольких контейнеров с Docker Compose\n19. Связь контейнеров в Docker Compose\n20. Практическая работа №10. Создание связанного стека контейнеров (API + БД)\n21. Масштабирование контейнеров в Docker Compose\n22. Практическая работа №11. Масштабирование веб-приложения с Docker Compose\n23. Автоматизация развертывания с Docker Compose\n24. Практическая работа №12. Развертывание приложения в облаке с Docker Compose.\n25. Основные концепции Kubernetes\n26. Практическая работа №13. Установка Minikube и запуск первого Pod\n27. Управление подами в Kubernetes\n28. Практическая работа №14. Развертывание контейнера в Pod\n29. Деплойменты и обновления в Kubernetes\n30. Практическая работа №15. Обновление приложения в Kubernetes\n31. Конфигурации и секреты в Kubernetes\n32. Практическая работа №16. Подключение ConfigMap и Secret в Pod\n33. Балансировка нагрузки в Kubernetes\n34. Практическая работа №17. Настройка балансировки нагрузки в Kubernetes\n35. Масштабирование приложений в Kubernetes\n36. Практическая работа №18. Настройка автоскейлинга в Kubernetes	\N	\N	\N
56	429	4	Модуль 4. Автоматизация DevOps-процессов на Python	1. Основы DevOps и роль Python в автоматизации\n2. Практическая работа №1. Написание первого DevOps-скрипта на Python\n3. Работа с процессами и файлами в Python\n4. Практическая работа №2. Создание Python-скрипта для автоматизации работы с файлами и процессами\n5. Инфраструктура как код с Python\n6. Практическая работа №3. Написание скрипта для автоматизированного развертывания серверов с Ansible\n7. Управление облачными сервисами через Python\n8. Практическая работа №4. Написание Python-скрипта для управления облачными ресурсами\n9. Мониторинг DevOps-инфраструктуры с Python\n10. Практическая работа №5. Настройка мониторинга Python-скрипта с Prometheus\n11. Логирование и обработка логов\n12. Практическая работа №6. Настройка логирования в Python-скрипте с отправкой в централизованное хранилище\n13. CI/CD и автоматизация деплоя\n14. Практическая работа №7. Автоматизация CI/CD пайплайна с Python\n15. Интеграция Python с CI/CD инструментами\n16. Практическая работа №8. Интеграция Python-скрипта с CI/CD пайплайном\n17. Контейнеризация Python-приложений с Docker\n18. Практическая работа №9. Написание Dockerfile и создание контейнера для Python-приложения\n19. Автоматизация Kubernetes через Python\n20. Практическая работа №10. Написание Python-скрипта для работы с Kubernetes\n21. Масштабирование DevOps-скриптов\n22. Практическая работа №11. Написание асинхронного DevOps-скрипта\n23. Управление конфигурациями серверов через Python\n24. Практическая работа №12. Написание Python-скрипта для автоматизированного администрирования серверов\n25. Автоматизация тестирования DevOps-инфраструктуры\n26. Практическая работа №13. Написание тестов для DevOps-инфраструктуры\n27. Автоматизированный анализ уязвимостей\n28. Практическая работа №14. Разработка Python-скрипта для автоматического анализа безопасности\n29. Автоматизированный бэкап и восстановление данных\n30. Практическая работа №15. Написание скрипта для автоматического бэкапа и восстановления\n31. Автоматизация управления доступом и пользователями\n32. Практическая работа №16. Разработка Python-скрипта для управления учетными записями пользователей\n33. Настройка алертинга и уведомлений в DevOps\n34. Практическая работа №17. Разработка Python-скрипта для отправки уведомлений о сбоях\n35. Автоматизация управления сетевой инфраструктурой\n36. Практическая работа №18. Написание Python-скрипта для настройки сетевых устройств	\N	\N	\N
57	430	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями.\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных.\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций.\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях.\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов.\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных.\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных.\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON.\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах.\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений.	\N	\N	\N
58	430	2	Модуль 2. Python для DevOps	1. Введение в DevOps и автоматизацию инфраструктуры\n2. Практическая работа №1. Установка и настройка окружения DevOps на локальной машине.\n3. Работа с серверами через SSH и Python\n4. Практическая работа №2. Написание Python-скрипта для удалённого администрирования сервера.\n5. Основы работы с Linux и автоматизация задач\n6. Практическая работа №3. Автоматизация резервного копирования файлов с помощью Python.\n7. Управление пользователями и правами доступа\n8. Практическая работа №4. Автоматизация управления пользователями на сервере.\n9. Введение в Ansible: автоматизация серверных конфигураций\n10. Практическая работа №5. Написание Ansible-плейбука для настройки сервера.\n11. Использование Python в Ansible\n12. Практическая работа №6. Создание пользовательского Ansible-модуля на Python\n13. Автоматизация инфраструктуры с Terraform\n14. Практическая работа №7. Написание Terraform-скрипта для развертывания серверов в облаке\n15. Python-скрипты для управления облачной инфраструктурой\n16. Практическая работа №8. Написание Python-скрипта для управления ресурсами\n17. Основы мониторинга и логирования в DevOps\n18. Практическая работа №9. Настройка базового мониторинга сервера с Prometheus\n19. Сбор метрик с помощью Prometheus\n20. Практическая работа №10. Разработка Python-метрик для Prometheus\n21. Визуализация метрик в Grafana\n22. Практическая работа №11. Настройка дашборда в Grafana для мониторинга серверов\n23. Логирование и анализ данных с ELK Stack\n24. Практическая работа №12. Настройка централизованного логирования с ELK Stack\n25. Автоматизация работы с логами\n26. Практическая работа №13. Создание системы логирования для DevOps инфраструктуры\n27. Настройка алертинга в DevOps\n28. Практическая работа №14. Автоматическая отправка уведомлений при сбоях системы\n29. Сбор и анализ системных логов\n30. Практическая работа №15. Автоматизированный анализ логов и мониторинг событий\n31. Основы CI/CD и автоматизированного развертывания\n32. Практическая работа №16. Настройка базового CI/CD пайплайна\n33. Интеграция Python-скриптов в CI/CD\n34. Практическая работа №17. Автоматизация тестов и деплоя с помощью CI/CD\n35. Kubernetes и оркестрация контейнеров\n36. Практическая работа №18. Деплой Python-приложения в Kubernetes	\N	\N	\N
59	430	3	Модуль 3. Работа с Docker и Kubernetes	1. Введение в контейнеризацию и Docker\n2. Практическая работа №1. Установка Docker и запуск первого контейнера\n3. Управление образами и контейнерами\n4. Практическая работа №2. Управление контейнерами и образами в Docker\n5. Работа с реестрами Docker\n6. Практическая работа №3. Размещение собственного Docker-образа в Docker Hub\n7. Сетевое взаимодействие контейнеров\n8. Практическая работа №4. Создание сети и подключение нескольких контейнеров\n9. Основы создания образов с Dockerfile\n10. Практическая работа №5. Написание Dockerfile для Python-приложения\n11. Переменные окружения и конфигурация контейнеров\n12. Практическая работа №6. Использование переменных окружения в контейнерах\n13. Оптимизация Docker-образов\n14. Практическая работа №7. Оптимизация Dockerfile для уменьшения размера образа\n15. Работа с Docker Logs и отладка контейнеров\n16. Практическая работа №8. Логирование и отладка контейнеров в Docker\n17. Введение в Docker Compose\n18. Практическая работа №9. Запуск нескольких контейнеров с Docker Compose\n19. Связь контейнеров в Docker Compose\n20. Практическая работа №10. Создание связанного стека контейнеров (API + БД)\n21. Масштабирование контейнеров в Docker Compose\n22. Практическая работа №11. Масштабирование веб-приложения с Docker Compose.\n23. Автоматизация развертывания с Docker Compose\n24. Практическая работа №12. Развертывание приложения в облаке с Docker Compose.\n25. Основные концепции Kubernetes\n26. Практическая работа №13. Установка Minikube и запуск первого Pod\n27. Управление подами в Kubernetes\n28. Практическая работа №14. Развертывание контейнера в Pod\n29. Деплойменты и обновления в Kubernetes\n30. Практическая работа №15. Обновление приложения в Kubernetes\n31. Конфигурации и секреты в Kubernetes\n32. Практическая работа №16. Подключение ConfigMap и Secret в Pod\n33. Балансировка нагрузки в Kubernetes\n34. Практическая работа №17. Настройка балансировки нагрузки в Kubernetes\n35. Масштабирование приложений в Kubernetes\n36. Практическая работа №18. Настройка автоскейлинга в Kubernetes	\N	\N	\N
60	430	4	Модуль 4. Автоматизация DevOps-процессов на Python	1. Основы DevOps и роль Python в автоматизации\n2. Практическая работа №1. Написание первого DevOps-скрипта на Python\n3. Работа с процессами и файлами в Python\n4. Практическая работа №2. Создание Python-скрипта для автоматизации работы с файлами и процессами\n5. Инфраструктура как код с Python\n6. Практическая работа №3. Написание скрипта для автоматизированного развертывания серверов с Ansible\n7. Управление облачными сервисами через Python\n8. Практическая работа №4. Написание Python-скрипта для управления облачными ресурсами\n9. Мониторинг DevOps-инфраструктуры с Python\n10. Практическая работа №5. Настройка мониторинга Python-скрипта с Prometheus\n11. Логирование и обработка логов\n12. Практическая работа №6. Настройка логирования в Python-скрипте с отправкой в централизованное хранилище\n13. CI/CD и автоматизация деплоя\n14. Практическая работа №7. Автоматизация CI/CD пайплайна с Python\n15. Интеграция Python с CI/CD инструментами\n16. Практическая работа №8. Интеграция Python-скрипта с CI/CD пайплайном\n17. Контейнеризация Python-приложений с Docker\n18. Практическая работа №9. Написание Dockerfile и создание контейнера для Python-приложения\n19. Автоматизация Kubernetes через Python\n20. Практическая работа №10. Написание Python-скрипта для работы с Kubernetes\n21. Масштабирование DevOps-скриптов\n22. Практическая работа №11. Написание асинхронного DevOps-скрипта\n23. Управление конфигурациями серверов через Python\n24. Практическая работа №12. Написание Python-скрипта для автоматизированного администрирования серверов\n25. Автоматизация тестирования DevOps-инфраструктуры\n26. Практическая работа №13. Написание тестов для DevOps-инфраструктуры\n27. Автоматизированный анализ уязвимостей\n28. Практическая работа №14. Разработка Python-скрипта для автоматического анализа безопасности\n29. Автоматизированный бэкап и восстановление данных\n30. Практическая работа №15. Написание скрипта для автоматического бэкапа и восстановления\n31. Автоматизация управления доступом и пользователями\n32. Практическая работа №16. Разработка Python-скрипта для управления учетными записями пользователей\n33. Настройка алертинга и уведомлений в DevOps\n34. Практическая работа №17. Разработка Python-скрипта для отправки уведомлений о сбоях\n35. Автоматизация управления сетевой инфраструктурой\n36. Практическая работа №18. Написание Python-скрипта для настройки сетевых устройств	\N	\N	\N
61	431	1	Модуль 1. Автоматизация пайплайнов и подготовки данных на Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Структуры данных: списки, кортежи, множества, словари\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений	\N	\N	\N
62	431	2	Модуль 2. Анализ данных на Python	1. Введение в анализ данных и инструменты\n2. Практическая работа №1. Установка Pandas и NumPy, создание первых объектов\n3. Основы работы с NumPy\n4. Практическая работа №2. Операции с массивами NumPy\n5. Основы работы с Pandas\n6. Практическая работа №3. Создание и модификация DataFrame\n7. Чтение и запись CSV-файлов\n8. Практическая работа №4. Чтение и запись данных в CSV\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка Excel-файлов в Pandas\n11. Подключение к базам данных (SQLAlchemy)\n12. Практическая работа №6. Подключение к базе и выполнение SQL-запросов в Pandas\n13. Фильтрация данных в Pandas\n14. Практическая работа №7. Фильтрация данных в DataFrame\n15. Группировка данных и агрегация\n16. Практическая работа №8. Группировка и агрегация данных\n17. Сводные таблицы (Pivot Table)\n18. Практическая работа №9. Создание сводной таблицы для анализа данных\n19. Объединение и слияние данных\n20. Практическая работа №10. Слияние и объединение нескольких таблиц\n21. Работа с временными рядами\n22. Практическая работа №11. Работа с датами и временными рядами\n23. Декомпозиция временных рядов\n24. Практическая работа №12. Анализ трендов временного ряда\n25. Визуализация данных\n26. Практическая работа №13. Визуализация данных с Matplotlib и Seaborn\n27. Обнаружение и обработка пропущенных данных\n28. Практическая работа №14. Обработка пропущенных данных в DataFrame\n29. Работа с выбросами и аномалиями\n30. Практическая работа №15. Поиск и устранение выбросов в данных\n31. Кодирование категориальных переменных\n32. Практическая работа №16. Кодирование категориальных данных\n33. Нормализация и стандартизация данных\n34. Практическая работа №17. Нормализация данных для анализа\n35. Оптимизация работы с большими таблицами\n36. Практическая работа №18. Оптимизация работы с большими наборами данных	\N	\N	\N
63	431	3	Модуль 3. Машинное обучение на Python	1. Основные концепции машинного обучения\n2. Практическая работа №1. Настройка окружения и работа с датасетом\n3. Основные библиотеки и инструменты для машинного обучения\n4. Практическая работа №2. Загрузка и исследование датасета (EDA)\n5. Разделение данных на обучающую и тестовую выборки\n6. Практическая работа №3. Разделение данных и проверка их качества\n7. Работа с пропущенными значениями\n8. Практическая работа №4. Обработка пропущенных значений в датасете\n9. Кодирование категориальных признаков\n10. Практическая работа №5. Кодирование категориальных признаков\n11. Масштабирование данных\n12. Практическая работа №6. Масштабирование признаков для машинного обучения\n13. Выбор важных признаков (Feature Selection)\n14. Практическая работа №7. Автоматический отбор признаков\n15. Введение в методы классификации\n16. Практическая работа №8. Реализация простого классификатора\n17. Линейные модели: Логистическая регрессия\n18. Практическая работа №9. Обучение логистической регрессии на реальных данных\n19. Деревья решений в классификации\n20. Практическая работа №10. Классификация с использованием деревьев решений\n21. Ансамбли моделей: Random Forest и градиентный бустинг\n22. Практическая работа №11. Использование ансамблевых методов для улучшения классификации\n23. Методы регрессии: Линейная и полиномиальная регрессия\n24. Практическая работа №12. Моделирование зависимости с помощью линейной регрессии\n25. Введение в кластеризацию данных\n26. Практическая работа №13. Кластеризация данных с использованием KMeans\n27. Снижение размерности с PCA (Principal Component Analysis)\n28. Практическая работа №14. Применение PCA для снижения размерности данных\n29. DBSCAN и агломеративная кластеризация\n30. Практическая работа №15. Кластеризация с использованием DBSCAN и агломеративного метода\n31. Оценка качества модели: метрики и кросс-валидация\n32. Практическая работа №16. Оценка качества модели и кросс-валидация\n33. Балансировка классов в данных\n34. Практическая работа №17. Балансировка данных перед обучением модели.\n35. Подбор гиперпараметров моделей\n36. Практическая работа №18. Подбор гиперпараметров модели	\N	\N	\N
64	431	4	Модуль 4. Автоматизация пайплайнов и подготовки данных на Python	1. Введение в ETL-процессы\n2. Практическая работа №1. Создание базового ETL-скрипта для обработки данных.\n3. Извлечение данных из различных источников\n4. Практическая работа №2. Извлечение данных из различных источников и сохранение в базу.\n5. Трансформация данных в ETL-процессах\n6. Практическая работа №3. Автоматическая очистка данных в ETL-пайплайне.\n7. Загрузка данных в базы и хранилища\n8. Практическая работа №4. Автоматическая загрузка данных в базу данных.\n9. Автоматическая очистка и нормализация данных\n10. Практическая работа №5. Создание модуля очистки данных.\n11. Автоматизация работы с большими объемами данных\n12. Практическая работа №6. Обработка большого объема данных с Dask.\n13. Управление метаданными и мониторинг ETL-процессов\n14. Практическая работа №7. Настройка логирования и мониторинга ETL-процесса.\n15. Распределенная обработка данных\n16. Практическая работа №8. Реализация распределенной обработки данных с Apache Spark.\n17. Введение в потоковую обработку данных\n18. Практическая работа №9. Создание простого потокового процессора на Python.\n19. Использование Apache Kafka для потоковой обработки\n20. Практическая работа №10. Потоковая обработка данных с Apache Kafka.\n21. Реализация потоковой аналитики с Apache Spark\n22. Практическая работа №11. Обработка потоковых данных с Apache Spark.\n23. Автоматизация потоковых ETL-процессов\n24. Практическая работа №12. Автоматизация потокового ETL-пайплайна.\n25. Введение в Apache Airflow\n26. Практическая работа №13. Установка Airflow и запуск первого DAG.\n27. Автоматизация ETL с использованием Airflow\n28. Практическая работа №14. Разработка ETL-процесса в Airflow.\n29. Интеграция Airflow с внешними сервисами\n30. Практическая работа №15. Подключение Airflow к базе данных и API.\n31. Оптимизация работы пайплайнов в Airflow\n32. Практическая работа №16. Оптимизация работы DAG в Airflow.\n33. Автоматизация подготовки данных для машинного обучения\n34. Практическая работа №17. Автоматизация предобработки данных в ML-пайплайне.\n35. Автоматизация обучения моделей\n36. Практическая работа №18. Автоматический подбор модели и её обучение.	\N	\N	\N
65	432	1	Модуль 1. Автоматизация пайплайнов и подготовки данных на Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Структуры данных: списки, кортежи, множества, словари\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений	\N	\N	\N
66	432	2	Модуль 2. Анализ данных на Python	1. Введение в анализ данных и инструменты\n2. Практическая работа №1. Установка Pandas и NumPy, создание первых объектов\n3. Основы работы с NumPy\n4. Практическая работа №2. Операции с массивами NumPy\n5. Основы работы с Pandas\n6. Практическая работа №3. Создание и модификация DataFrame\n7. Чтение и запись CSV-файлов\n8. Практическая работа №4. Чтение и запись данных в CSV\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка Excel-файлов в Pandas\n11. Подключение к базам данных (SQLAlchemy)\n12. Практическая работа №6. Подключение к базе и выполнение SQL-запросов в Pandas\n13. Фильтрация данных в Pandas\n14. Практическая работа №7. Фильтрация данных в DataFrame\n15. Группировка данных и агрегация\n16. Практическая работа №8. Группировка и агрегация данных\n17. Сводные таблицы (Pivot Table)\n18. Практическая работа №9. Создание сводной таблицы для анализа данных\n19. Объединение и слияние данных\n20. Практическая работа №10. Слияние и объединение нескольких таблиц\n21. Работа с временными рядами\n22. Практическая работа №11. Работа с датами и временными рядами\n23. Декомпозиция временных рядов\n24. Практическая работа №12. Анализ трендов временного ряда\n25. Визуализация данных\n26. Практическая работа №13. Визуализация данных с Matplotlib и Seaborn\n27. Обнаружение и обработка пропущенных данных\n28. Практическая работа №14. Обработка пропущенных данных в DataFrame\n29. Работа с выбросами и аномалиями\n30. Практическая работа №15. Поиск и устранение выбросов в данных\n31. Кодирование категориальных переменных\n32. Практическая работа №16. Кодирование категориальных данных\n33. Нормализация и стандартизация данных\n34. Практическая работа №17. Нормализация данных для анализа\n35. Оптимизация работы с большими таблицами\n36. Практическая работа №18. Оптимизация работы с большими наборами данных	\N	\N	\N
67	432	3	Модуль 3. Машинное обучение на Python	1. Основные концепции машинного обучения\n2. Практическая работа №1. Настройка окружения и работа с датасетом\n3. Основные библиотеки и инструменты для машинного обучения\n4. Практическая работа №2. Загрузка и исследование датасета (EDA)\n5. Разделение данных на обучающую и тестовую выборки\n6. Практическая работа №3. Разделение данных и проверка их качества\n7. Работа с пропущенными значениями\n8. Практическая работа №4. Обработка пропущенных значений в датасете\n9. Кодирование категориальных признаков\n10. Практическая работа №5. Кодирование категориальных признаков\n11. Масштабирование данных\n12. Практическая работа №6. Масштабирование признаков для машинного обучения\n13. Выбор важных признаков (Feature Selection)\n14. Практическая работа №7. Автоматический отбор признаков\n15. Введение в методы классификации\n16. Практическая работа №8. Реализация простого классификатора\n17. Линейные модели: Логистическая регрессия\n18. Практическая работа №9. Обучение логистической регрессии на реальных данных\n19. Деревья решений в классификации\n20. Практическая работа №10. Классификация с использованием деревьев решений\n21. Ансамбли моделей: Random Forest и градиентный бустинг\n22. Практическая работа №11. Использование ансамблевых методов для улучшения классификации\n23. Методы регрессии: Линейная и полиномиальная регрессия\n24. Практическая работа №12. Моделирование зависимости с помощью линейной регрессии\n25. Введение в кластеризацию данных\n26. Практическая работа №13. Кластеризация данных с использованием KMeans\n27. Снижение размерности с PCA (Principal Component Analysis)\n28. Практическая работа №14. Применение PCA для снижения размерности данных\n29. DBSCAN и агломеративная кластеризация\n30. Практическая работа №15. Кластеризация с использованием DBSCAN и агломеративного метода\n31. Оценка качества модели: метрики и кросс-валидация\n32. Практическая работа №16. Оценка качества модели и кросс-валидация\n33. Балансировка классов в данных\n34. Практическая работа №17. Балансировка данных перед обучением модели.\n35. Подбор гиперпараметров моделей\n36. Практическая работа №18. Подбор гиперпараметров модели	\N	\N	\N
68	432	4	Модуль 4. Автоматизация пайплайнов и подготовки данных на Python	1. Введение в ETL-процессы\n2. Практическая работа №1. Создание базового ETL-скрипта для обработки данных.\n3. Извлечение данных из различных источников\n4. Практическая работа №2. Извлечение данных из различных источников и сохранение в базу.\n5. Трансформация данных в ETL-процессах\n6. Практическая работа №3. Автоматическая очистка данных в ETL-пайплайне.\n7. Загрузка данных в базы и хранилища\n8. Практическая работа №4. Автоматическая загрузка данных в базу данных.\n9. Автоматическая очистка и нормализация данных\n10. Практическая работа №5. Создание модуля очистки данных.\n11. Автоматизация работы с большими объемами данных\n12. Практическая работа №6. Обработка большого объема данных с Dask.\n13. Управление метаданными и мониторинг ETL-процессов\n14. Практическая работа №7. Настройка логирования и мониторинга ETL-процесса.\n15. Распределенная обработка данных\n16. Практическая работа №8. Реализация распределенной обработки данных с Apache Spark.\n17. Введение в потоковую обработку данных\n18. Практическая работа №9. Создание простого потокового процессора на Python.\n19. Использование Apache Kafka для потоковой обработки\n20. Практическая работа №10. Потоковая обработка данных с Apache Kafka.\n21. Реализация потоковой аналитики с Apache Spark\n22. Практическая работа №11. Обработка потоковых данных с Apache Spark.\n23. Автоматизация потоковых ETL-процессов\n24. Практическая работа №12. Автоматизация потокового ETL-пайплайна.\n25. Введение в Apache Airflow\n26. Практическая работа №13. Установка Airflow и запуск первого DAG.\n27. Автоматизация ETL с использованием Airflow\n28. Практическая работа №14. Разработка ETL-процесса в Airflow.\n29. Интеграция Airflow с внешними сервисами\n30. Практическая работа №15. Подключение Airflow к базе данных и API.\n31. Оптимизация работы пайплайнов в Airflow\n32. Практическая работа №16. Оптимизация работы DAG в Airflow.\n33. Автоматизация подготовки данных для машинного обучения\n34. Практическая работа №17. Автоматизация предобработки данных в ML-пайплайне.\n35. Автоматизация обучения моделей\n36. Практическая работа №18. Автоматический подбор модели и её обучение.	\N	\N	\N
69	433	1	Модуль 1. Программирование на языке Python	1. Основы синтаксиса, переменные, типы данных\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями.\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных.\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций.\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях.\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных.\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных.\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON.\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах.\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений.	\N	\N	\N
70	433	2	Модуль 2. Анализ данных на Python (Pandas, NumPy)	1. Введение в анализ данных и инструменты\n2. Практическая работа №1. Установка Pandas и NumPy, создание первых объектов.\n3. Основы работы с NumPy\n4. Практическая работа №2. Операции с массивами NumPy.\n5. Основы работы с Pandas\n6. Практическая работа №3. Создание и модификация DataFrame.\n7. Чтение и запись CSV-файлов\n8. Практическая работа №4. Чтение и запись данных в CSV.\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка Excel-файлов в Pandas.\n11. Подключение к базам данных (SQLAlchemy)\n12. Практическая работа №6. Подключение к базе и выполнение SQL-запросов в Pandas.\n13. Фильтрация данных в Pandas\n14. Практическая работа №7. Фильтрация данных в DataFrame.\n15. Группировка данных и агрегация\n16. Практическая работа №8. Группировка и агрегация данных.\n17. Сводные таблицы (Pivot Table)\n18. Практическая работа №9. Создание сводной таблицы для анализа данных.\n19. Объединение и слияние данных\n20. Практическая работа №10. Слияние и объединение нескольких таблиц.\n21. Работа с временными рядами\n22. Практическая работа №11. Работа с датами и временными рядами.\n23. Декомпозиция временных рядов\n24. Практическая работа №12. Анализ трендов временного ряда.\n25. Визуализация данных\n26. Практическая работа №13. Визуализация данных с Matplotlib и Seaborn.\n27. Обнаружение и обработка пропущенных данных\n28. Практическая работа №14. Обработка пропущенных данных в DataFrame.\n29. Работа с выбросами и аномалиями\n30. Практическая работа №15. Поиск и устранение выбросов в данных.\n31. Кодирование категориальных переменных\n32. Практическая работа №16. Кодирование категориальных данных.\n33. Нормализация и стандартизация данных\n34. Практическая работа №17. Нормализация данных для анализа.\n35. Оптимизация работы с большими таблицами\n36. Практическая работа №18. Оптимизация работы с большими наборами данных.	\N	\N	\N
71	433	3	Модуль 3. Визуализация данных на Python	1. Введение в визуализацию данных и библиотеку Matplotlib\n2. Практическая работа №1. Построение первых графиков с Matplotlib.\n3. Работа с линейными графиками\n4. Практическая работа №2. Создание линейного графика с аннотациями.\n5. Гистограммы и столбчатые диаграммы\n6. Практическая работа №3. Визуализация распределения данных с помощью гистограмм.\n7. Круговые диаграммы и тепловые карты\n8. Практическая работа №4. Визуализация пропорций с помощью круговых диаграмм.\n9. Введение в работу с временными рядами\n10. Практическая работа №5. Визуализация временного ряда.\n11. Скользящее среднее и тренды во временных рядах\n12. Практическая работа №6. Анализ сезонности временного ряда.\n13. Графики временных рядов с Seaborn\n14. Практическая работа №7. Анализ временных рядов с Seaborn.\n15. Визуализация нескольких временных рядов на одном графике\n16. Практическая работа №8. Визуализация сравнения двух временных рядов.\n17. Основы Plotly: построение интерактивных графиков\n18. Практическая работа №9. Создание интерактивного линейного графика с Plotly.\n19. Взаимодействие с пользователем в интерактивных графиках\n20. Практическая работа №10. Добавление интерактивных элементов в график.\n21. Построение интерактивных временных рядов в Plotly\n22. Практическая работа №11. Визуализация временного ряда с анимацией.\n23. Интерактивные тепловые карты и геоданные\n24. Практическая работа №12. Построение интерактивной карты данных.\n25. Диаграммы рассеяния и регрессия в Seaborn\n26. Практическая работа №13. Визуализация корреляции данных с Seaborn.\n27. Ящиковые диаграммы и violinplot\n28. Практическая работа №14. Анализ распределения данных с помощью boxplot.\n29. Построение корреляционных матриц\n30. Практическая работа №15. Визуализация корреляции переменных с Seaborn.\n31. Генерация отчетов в Jupyter Notebook\n32. Практическая работа №16. Создание интерактивного отчета в Jupyter Notebook.\n33. Создание автоматизированных отчетов в Python\n34. Практическая работа №17. Автоматическая генерация отчетов с Python.\n35. Динамическая визуализация данных в Streamlit\n36. Практическая работа №18. Разработка веб-интерфейса для анализа данных.	\N	\N	\N
72	433	4	Модуль 4. Автоматизация обработки и анализа данных на Python	1. Введение в автоматизацию обработки данных\n2. Практическая работа №1. Создание скрипта автоматической обработки данных.\n3. Обнаружение и обработка пропущенных данных\n4. Практическая работа №2. Автоматическая очистка данных.\n5. Работа с выбросами и дубликатами\n6. Практическая работа №3. Обработка выбросов и удаление дубликатов.\n7. Преобразование типов данных и нормализация\n8. Практическая работа №4. Преобразование и нормализация данных.\n9. Генерация отчетов в Excel\n10. Практическая работа №5. Автоматическое создание Excel-отчета.\n11. Автоматическое создание PDF-отчетов\n12. Практическая работа №6. Формирование PDF-отчета.\n13. Создание интерактивных дашбордов\n14. Практическая работа №7. Разработка интерактивного дашборда.\n15. Автоматизация отчетности и отправка данных\n16. Практическая работа №8. Настройка автоматической отправки отчетов.\n17. Работа с внешними API\n18. Практическая работа №9. Получение данных через API.\n19. Парсинг данных с веб-страниц\n20. Практическая работа №10. Парсинг HTML-страницы.\n21. Работа с динамическими веб-страницами\n22. Практическая работа №11. Сбор данных с динамического сайта.\n23. Интеграция с облачными сервисами\n24. Практическая работа №12. Загрузка данных в облачный сервис.\n25. Оптимизация работы с большими CSV-файлами\n26. Практическая работа №13. Оптимизация чтения больших файлов.\n27. Работа с базами данных для больших данных\n28. Практическая работа №14. Интеграция с БД для хранения данных.\n29. Обработка данных в многопоточном режиме\n30. Практическая работа №15. Реализация многопоточной обработки.\n31. Работа с распределёнными вычислениями\n32. Практическая работа №16. Обработка данных с использованием распределённых инструментов.\n33. Профилирование и отладка кода\n34. Практическая работа №17. Анализ производительности кода.\n35. Использование кеширования для ускорения работы\n36. Практическая работа №18. Реализация кеширования данных.	\N	\N	\N
73	434	1	Модуль 1. Программирование на языке Python	1. Основы синтаксиса, переменные, типы данных\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями.\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных.\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций.\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях.\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных.\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных.\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON.\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах.\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений.	\N	\N	\N
74	434	2	Модуль 2. Анализ данных на Python (Pandas, NumPy)	1. Введение в анализ данных и инструменты\n2. Практическая работа №1. Установка Pandas и NumPy, создание первых объектов.\n3. Основы работы с NumPy\n4. Практическая работа №2. Операции с массивами NumPy.\n5. Основы работы с Pandas\n6. Практическая работа №3. Создание и модификация DataFrame.\n7. Чтение и запись CSV-файлов\n8. Практическая работа №4. Чтение и запись данных в CSV.\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка Excel-файлов в Pandas.\n11. Подключение к базам данных (SQLAlchemy)\n12. Практическая работа №6. Подключение к базе и выполнение SQL-запросов в Pandas.\n13. Фильтрация данных в Pandas\n14. Практическая работа №7. Фильтрация данных в DataFrame.\n15. Группировка данных и агрегация\n16. Практическая работа №8. Группировка и агрегация данных.\n17. Сводные таблицы (Pivot Table)\n18. Практическая работа №9. Создание сводной таблицы для анализа данных.\n19. Объединение и слияние данных\n20. Практическая работа №10. Слияние и объединение нескольких таблиц.\n21. Работа с временными рядами\n22. Практическая работа №11. Работа с датами и временными рядами.\n23. Декомпозиция временных рядов\n24. Практическая работа №12. Анализ трендов временного ряда.\n25. Визуализация данных\n26. Практическая работа №13. Визуализация данных с Matplotlib и Seaborn.\n27. Обнаружение и обработка пропущенных данных\n28. Практическая работа №14. Обработка пропущенных данных в DataFrame.\n29. Работа с выбросами и аномалиями\n30. Практическая работа №15. Поиск и устранение выбросов в данных.\n31. Кодирование категориальных переменных\n32. Практическая работа №16. Кодирование категориальных данных.\n33. Нормализация и стандартизация данных\n34. Практическая работа №17. Нормализация данных для анализа.\n35. Оптимизация работы с большими таблицами\n36. Практическая работа №18. Оптимизация работы с большими наборами данных.	\N	\N	\N
75	434	3	Модуль 3. Визуализация данных на Python	1. Введение в визуализацию данных и библиотеку Matplotlib\n2. Практическая работа №1. Построение первых графиков с Matplotlib.\n3. Работа с линейными графиками\n4. Практическая работа №2. Создание линейного графика с аннотациями.\n5. Гистограммы и столбчатые диаграммы\n6. Практическая работа №3. Визуализация распределения данных с помощью гистограмм.\n7. Круговые диаграммы и тепловые карты\n8. Практическая работа №4. Визуализация пропорций с помощью круговых диаграмм.\n9. Введение в работу с временными рядами\n10. Практическая работа №5. Визуализация временного ряда.\n11. Скользящее среднее и тренды во временных рядах\n12. Практическая работа №6. Анализ сезонности временного ряда.\n13. Графики временных рядов с Seaborn\n14. Практическая работа №7. Анализ временных рядов с Seaborn.\n15. Визуализация нескольких временных рядов на одном графике\n16. Практическая работа №8. Визуализация сравнения двух временных рядов.\n17. Основы Plotly: построение интерактивных графиков\n18. Практическая работа №9. Создание интерактивного линейного графика с Plotly.\n19. Взаимодействие с пользователем в интерактивных графиках\n20. Практическая работа №10. Добавление интерактивных элементов в график.\n21. Построение интерактивных временных рядов в Plotly\n22. Практическая работа №11. Визуализация временного ряда с анимацией.\n23. Интерактивные тепловые карты и геоданные\n24. Практическая работа №12. Построение интерактивной карты данных.\n25. Диаграммы рассеяния и регрессия в Seaborn\n26. Практическая работа №13. Визуализация корреляции данных с Seaborn.\n27. Ящиковые диаграммы и violinplot\n28. Практическая работа №14. Анализ распределения данных с помощью boxplot.\n29. Построение корреляционных матриц\n30. Практическая работа №15. Визуализация корреляции переменных с Seaborn.\n31. Генерация отчетов в Jupyter Notebook\n32. Практическая работа №16. Создание интерактивного отчета в Jupyter Notebook.\n33. Создание автоматизированных отчетов в Python\n34. Практическая работа №17. Автоматическая генерация отчетов с Python.\n35. Динамическая визуализация данных в Streamlit\n36. Практическая работа №18. Разработка веб-интерфейса для анализа данных.	\N	\N	\N
76	434	4	Модуль 4. Автоматизация обработки и анализа данных на Python	1. Введение в автоматизацию обработки данных\n2. Практическая работа №1. Создание скрипта автоматической обработки данных.\n3. Обнаружение и обработка пропущенных данных\n4. Практическая работа №2. Автоматическая очистка данных.\n5. Работа с выбросами и дубликатами\n6. Практическая работа №3. Обработка выбросов и удаление дубликатов.\n7. Преобразование типов данных и нормализация\n8. Практическая работа №4. Преобразование и нормализация данных.\n9. Генерация отчетов в Excel\n10. Практическая работа №5. Автоматическое создание Excel-отчета.\n11. Автоматическое создание PDF-отчетов\n12. Практическая работа №6. Формирование PDF-отчета.\n13. Создание интерактивных дашбордов\n14. Практическая работа №7. Разработка интерактивного дашборда.\n15. Автоматизация отчетности и отправка данных\n16. Практическая работа №8. Настройка автоматической отправки отчетов.\n17. Работа с внешними API\n18. Практическая работа №9. Получение данных через API.\n19. Парсинг данных с веб-страниц\n20. Практическая работа №10. Парсинг HTML-страницы.\n21. Работа с динамическими веб-страницами\n22. Практическая работа №11. Сбор данных с динамического сайта.\n23. Интеграция с облачными сервисами\n24. Практическая работа №12. Загрузка данных в облачный сервис.\n25. Оптимизация работы с большими CSV-файлами\n26. Практическая работа №13. Оптимизация чтения больших файлов.\n27. Работа с базами данных для больших данных\n28. Практическая работа №14. Интеграция с БД для хранения данных.\n29. Обработка данных в многопоточном режиме\n30. Практическая работа №15. Реализация многопоточной обработки.\n31. Работа с распределёнными вычислениями\n32. Практическая работа №16. Обработка данных с использованием распределённых инструментов.\n33. Профилирование и отладка кода\n34. Практическая работа №17. Анализ производительности кода.\n35. Использование кеширования для ускорения работы\n36. Практическая работа №18. Реализация кеширования данных.	\N	\N	\N
77	435	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений	\N	\N	\N
78	435	2	Модуль 2. WEB-разработка на Python (Django)	1. Основы Django: структура проекта\n2. Практическая работа №1. Установка Django и запуск первого проекта\n3. Работа с Django-приложениями и маршрутизация\n4. Практическая работа №2. Создание Django-приложения и настройка маршрутов\n5. Представления (Views) и шаблоны (Templates)\n6. Практическая работа №3. Разработка системы шаблонов и отображение данных\n7. Работа со статическими файлами\n8. Практическая работа №4. Добавление стилей и изображений в Django приложение\n9. Основы Django ORM: модели данных\n10. Практическая работа №5. Создание моделей и выполнение миграций\n11. Запросы к базе данных через ORM\n12. Практическая работа №6. Работа с базой данных через ORM\n13. Отношения между моделями\n14. Практическая работа №7. Создание связанных моделей и работа с ними\n15. Админ-панель Django\n16. Практическая работа №8. Настройка админ-панели и управление пользователями\n17. Основы Django Forms\n18. Практическая работа №9. Создание формы для ввода данных\n19. Работа с запросами (GET, POST)\n20. Практическая работа №10. Создание формы обратной связи с обработкой данных\n21. Работа с пользователями в Django\n22. Практическая работа №11. Реализация системы регистрации и входа\n23. Работа с правами доступа\n24. Практическая работа №12. Настройка ролевой системы доступа\n25. Введение в Django REST Framework\n26. Практическая работа №13. Создание REST API с Django REST Framework\n27. Работа с сериализаторами (Serializers)\n28. Практическая работа №14. Реализация API для работы с моделями\n29. Авторизация и аутентификация в API\n30. Практическая работа №15. Настройка аутентификации в API\n31. Развёртывание Django-приложения на сервере\n32. Практическая работа №16. Развёртывание Django-приложения на удалённом сервере\n33. Контейнеризация Django-приложения (Docker)\n34. Практическая работа №17. Запуск Django-приложения в Docker-контейнере\n35. CI/CD для Django\n36. Практическая работа №18. Настройка CI/CD пайплайна для Django приложения	\N	\N	\N
79	435	3	Модуль 3. Работа с базами данных в Python	1. Введение в базы данных и SQL\n2. Практическая работа №1. Создание и наполнение базы данных SQL\n3. Операции с данными в SQL\n4. Практическая работа №2. Запросы и работа с данными в SQL\n5. Взаимосвязи между таблицами\n6. Практическая работа №3. Работа с несколькими таблицами и JOIN\n7. Работа с SQLite в Python\n8. Практическая работа №4. Создание и управление базой данных в SQLite\n9. Работа с PostgreSQL в Python\n10. Практическая работа №5. Подключение Python-программы к PostgreSQL\n11. Работа с MySQL в Python\n12. Практическая работа №6. Работа с MySQL в Python\n13. Введение в ORM и SQLAlchemy\n14. Практическая работа №7. Создание моделей и базы данных с SQLAlchemy\n15. CRUD-операции в SQLAlchemy\n16. Практическая работа №8. CRUD-операции в SQLAlchemy\n17. Django ORM: работа с базами данных\n18. Практическая работа №9. Создание моделей и миграций в Django ORM\n19. Оптимизация запросов в ORM\n20. Практическая работа №10. Оптимизация работы ORM в Django и SQLAlchemy\n21. Индексы в базах данных\n22. Практическая работа №11. Добавление индексов в базу данных и анализ скорости работы\n23. Оптимизация SQL-запросов\n24. Практическая работа №12. Анализ и оптимизация SQL-запросов\n25. Введение в NoSQL и MongoDB\n26. Практическая работа №13. Работа с MongoDB через Python (pymongo)\n27. Запросы и агрегации в MongoDB\n28. Практическая работа №14. Работа с MongoDB и агрегацией данных\n29. Использование Redis в Python\n30. Практическая работа №15. Настройка Redis и кеширование данных\n31. Создание резервных копий баз данных\n32. Практическая работа №16. Создание резервной копии базы данных PostgreSQL\n33. Восстановление данных из бэкапа\n34. Практическая работа №17. Восстановление данных из резервной копии\n35. Автоматизация резервного копирования\n36. Практическая работа №18. Автоматизация создания бэкапов	\N	\N	\N
80	435	4	Модуль 4. Автоматизация процессов в WEB-разработке на Python	1. Основы автоматизированного развертывания веб-приложений\n2. Практическая работа №1. Настройка базового сценария развертывания Django-приложения\n3. Контейнеризация Django-приложений с Docker\n4. Практическая работа №2. Запуск Django-приложения в контейнере с Docker\n5. Развертывание Django-приложения на удаленном сервере\n6. Практическая работа №3. Развертывание Django-приложения с использованием Ansible\n7. Управление миграциями и статиками в Django\n8. Практическая работа №4. Управление миграциями и статикой\n9. Основы фоновых процессов и отложенных задач\n10. Практическая работа №5. Настройка фоновых задач\n11. Настройка CRON-задач для Django-приложений\n12. Практическая работа №6. Настройка периодических задач в Django с Celery и BackgroundScheduler\n13. Очереди задач и брокеры сообщений\n14. Практическая работа №7. Настройка очередей задач\n15. Оптимизация фоновых задач и их мониторинг\n16. Практическая работа №8. Мониторинг фоновых процессов\n17. Работа с REST API в Django\n18. Практическая работа №9. Интеграция Django-приложения с внешним API\n19. Работа с веб-хуками\n20. Практическая работа №10. Создание веб-хука для получения данных из внешнего сервиса\n21. Автоматизированный обмен данными\n22. Практическая работа №11. Реализация системы автоматического сбора данных через API\n23. Взаимодействие Django-приложений с облачными сервисами\n24. Практическая работа №12. Подключение Django-приложения к Google API\n25. Введение в CI/CD\n26. Практическая работа №13. Создание базового CI/CD пайплайна для Django\n27. Автоматизация тестирования в CI/CD\n28. Практическая работа №14. Интеграция тестов в CI/CD пайплайн\n29. Автоматизация деплоя в облаке\n30. Практическая работа №15. Развёртывание Django-приложения с CI/CD\n31. Мониторинг и логирование Django-приложений\n32. Практическая работа №16. Настройка логирования и мониторинга Django-приложения\n33. Нагрузочное тестирование Django-приложений\n34. Практическая работа №17. Проведение нагрузочного тестирования веб-приложения\n35. Оптимизация Django-приложений\n36. Практическая работа №18. Оптимизация производительности веб-приложения	\N	\N	\N
81	436	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений	\N	\N	\N
82	436	2	Модуль 2. WEB-разработка на Python (Django)	1. Основы Django: структура проекта\n2. Практическая работа №1. Установка Django и запуск первого проекта\n3. Работа с Django-приложениями и маршрутизация\n4. Практическая работа №2. Создание Django-приложения и настройка маршрутов\n5. Представления (Views) и шаблоны (Templates)\n6. Практическая работа №3. Разработка системы шаблонов и отображение данных\n7. Работа со статическими файлами\n8. Практическая работа №4. Добавление стилей и изображений в Django приложение\n9. Основы Django ORM: модели данных\n10. Практическая работа №5. Создание моделей и выполнение миграций\n11. Запросы к базе данных через ORM\n12. Практическая работа №6. Работа с базой данных через ORM\n13. Отношения между моделями\n14. Практическая работа №7. Создание связанных моделей и работа с ними\n15. Админ-панель Django\n16. Практическая работа №8. Настройка админ-панели и управление пользователями\n17. Основы Django Forms\n18. Практическая работа №9. Создание формы для ввода данных\n19. Работа с запросами (GET, POST)\n20. Практическая работа №10. Создание формы обратной связи с обработкой данных\n21. Работа с пользователями в Django\n22. Практическая работа №11. Реализация системы регистрации и входа\n23. Работа с правами доступа\n24. Практическая работа №12. Настройка ролевой системы доступа\n25. Введение в Django REST Framework\n26. Практическая работа №13. Создание REST API с Django REST Framework\n27. Работа с сериализаторами (Serializers)\n28. Практическая работа №14. Реализация API для работы с моделями\n29. Авторизация и аутентификация в API\n30. Практическая работа №15. Настройка аутентификации в API\n31. Развёртывание Django-приложения на сервере\n32. Практическая работа №16. Развёртывание Django-приложения на удалённом сервере\n33. Контейнеризация Django-приложения (Docker)\n34. Практическая работа №17. Запуск Django-приложения в Docker-контейнере\n35. CI/CD для Django\n36. Практическая работа №18. Настройка CI/CD пайплайна для Django приложения	\N	\N	\N
83	436	3	Модуль 3. Работа с базами данных в Python	1. Введение в базы данных и SQL\n2. Практическая работа №1. Создание и наполнение базы данных SQL\n3. Операции с данными в SQL\n4. Практическая работа №2. Запросы и работа с данными в SQL\n5. Взаимосвязи между таблицами\n6. Практическая работа №3. Работа с несколькими таблицами и JOIN\n7. Работа с SQLite в Python\n8. Практическая работа №4. Создание и управление базой данных в SQLite\n9. Работа с PostgreSQL в Python\n10. Практическая работа №5. Подключение Python-программы к PostgreSQL\n11. Работа с MySQL в Python\n12. Практическая работа №6. Работа с MySQL в Python\n13. Введение в ORM и SQLAlchemy\n14. Практическая работа №7. Создание моделей и базы данных с SQLAlchemy\n15. CRUD-операции в SQLAlchemy\n16. Практическая работа №8. CRUD-операции в SQLAlchemy\n17. Django ORM: работа с базами данных\n18. Практическая работа №9. Создание моделей и миграций в Django ORM\n19. Оптимизация запросов в ORM\n20. Практическая работа №10. Оптимизация работы ORM в Django и SQLAlchemy\n21. Индексы в базах данных\n22. Практическая работа №11. Добавление индексов в базу данных и анализ скорости работы\n23. Оптимизация SQL-запросов\n24. Практическая работа №12. Анализ и оптимизация SQL-запросов\n25. Введение в NoSQL и MongoDB\n26. Практическая работа №13. Работа с MongoDB через Python (pymongo)\n27. Запросы и агрегации в MongoDB\n28. Практическая работа №14. Работа с MongoDB и агрегацией данных\n29. Использование Redis в Python\n30. Практическая работа №15. Настройка Redis и кеширование данных\n31. Создание резервных копий баз данных\n32. Практическая работа №16. Создание резервной копии базы данных PostgreSQL\n33. Восстановление данных из бэкапа\n34. Практическая работа №17. Восстановление данных из резервной копии\n35. Автоматизация резервного копирования\n36. Практическая работа №18. Автоматизация создания бэкапов	\N	\N	\N
84	436	4	Модуль 4. Автоматизация процессов в WEB-разработке на Python	1. Основы автоматизированного развертывания веб-приложений\n2. Практическая работа №1. Настройка базового сценария развертывания Django-приложения\n3. Контейнеризация Django-приложений с Docker\n4. Практическая работа №2. Запуск Django-приложения в контейнере с Docker\n5. Развертывание Django-приложения на удаленном сервере\n6. Практическая работа №3. Развертывание Django-приложения с использованием Ansible\n7. Управление миграциями и статиками в Django\n8. Практическая работа №4. Управление миграциями и статикой\n9. Основы фоновых процессов и отложенных задач\n10. Практическая работа №5. Настройка фоновых задач\n11. Настройка CRON-задач для Django-приложений\n12. Практическая работа №6. Настройка периодических задач в Django с Celery и BackgroundScheduler\n13. Очереди задач и брокеры сообщений\n14. Практическая работа №7. Настройка очередей задач\n15. Оптимизация фоновых задач и их мониторинг\n16. Практическая работа №8. Мониторинг фоновых процессов\n17. Работа с REST API в Django\n18. Практическая работа №9. Интеграция Django-приложения с внешним API\n19. Работа с веб-хуками\n20. Практическая работа №10. Создание веб-хука для получения данных из внешнего сервиса\n21. Автоматизированный обмен данными между сервисами\n22. Практическая работа №11. Реализация системы автоматического сбора данных через API\n23. Взаимодействие Django-приложений с облачными сервисами\n24. Практическая работа №12. Подключение Django-приложения к Google API\n25. Введение в CI/CD\n26. Практическая работа №13. Создание базового CI/CD пайплайна для Django\n27. Автоматизация тестирования в CI/CD\n28. Практическая работа №14. Интеграция тестов в CI/CD пайплайн\n29. Автоматизация деплоя в облаке\n30. Практическая работа №15. Развёртывание Django-приложения с CI/CD\n31. Мониторинг и логирование Django-приложений\n32. Практическая работа №16. Настройка логирования и мониторинга Django-приложения\n33. Нагрузочное тестирование Django-приложений\n34. Практическая работа №17. Проведение нагрузочного тестирования веб-приложения\n35. Оптимизация Django-приложений\n36. Практическая работа №18. Оптимизация производительности веб-приложения	\N	\N	\N
85	437	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений	\N	\N	\N
86	437	2	Модуль 2. Продвинутое программирование на Python	1. Декораторы в Python: основы\n2. Практическая работа №1. Реализация базовых декораторов\n3. Продвинутые декораторы\n4. Практическая работа №2. Написание сложных декораторов с параметрами\n5. Генераторы и ленивые вычисления\n6. Практическая работа №3. Создание генераторов для обработки данных\n7. Потоковая обработка данных с генераторами\n8. Практическая работа №4. Написание генераторов для обработки файлов и потоков данных\n9. Основы многопоточного программирования\n10. Практическая работа №5. Создание многопоточных программ\n11. Работа с очередями в многопоточности\n12. Практическая работа №6. Организация обработки данных через многопоточные очереди\n13. Асинхронное программирование в Python\n14. Практическая работа №7. Написание асинхронных программ с asyncio\n15. Асинхронные вызовы и Future-объекты\n16. Практическая работа №8. Оптимизация асинхронного кода\n17. Основы регулярных выражений\n18. Практическая работа №9. Использование регулярных выражений для поиска и фильтрации данных\n19. Продвинутая работа с регулярными выражениями\n20. Практическая работа №10. Написание сложных регулярных выражений\n21. Исключения: обработка ошибок\n22. Практическая работа №11. Создание системы обработки ошибок в приложении\n23. Логирование в Python\n24. Практическая работа №12. Внедрение логирования в Python-программу\n25. Основы метапрограммирования в Python\n26. Практическая работа №13. Написание программы с динамическим изменением классов\n27. Работа с объектами и introspection\n28. Практическая работа №14. Инспекция классов и функций с использованием introspection\n29. Глубокая работа с метаклассами\n30. Практическая работа №15. Создание собственных метаклассов\n31. Оптимизация кода и профилирование\n32. Практическая работа №16. Анализ производительности Python-кода\n33. Управление памятью в Python\n34. Практическая работа №17. Оптимизация работы с памятью\n35. Использование Cython и Numba для оптимизации Python-кода\n36. Практическая работа №18. Оптимизация вычислений с помощью Numba	\N	\N	\N
87	437	3	Модуль 3. WEB-разработка на Python (Flask)	1. Введение в Flask и создание первого веб-приложения\n2. Практическая работа №1. Установка Flask и создание первого маршрута\n3. Маршруты и обработка запросов\n4. Практическая работа №2. Обработка маршрутов и параметров в Flask\n5. Шаблоны Jinja2 в Flask\n6. Практическая работа №3. Создание HTML-шаблонов с динамическими данными\n7. Формы и обработка данных\n8. Практическая работа №4. Создание формы авторизации с валидацией\n9. Основы REST API в Flask\n10. Практическая работа №5. Создание простого API с Flask\n11. Создание API с использованием Flask-RESTful\n12. Практическая работа №6. Разработка CRUD API с Flask-RESTful\n13. Аутентификация и авторизация в Flask API\n14. Практическая работа №7. Реализация JWT-аутентификации в Flask API\n15. Защита API и обработка ошибок\n16. Практическая работа №8. Улучшение безопасности API и обработка ошибок\n17. Введение в базы данных и SQLAlchemy\n18. Практическая работа №9. Настройка базы данных с SQLAlchemy\n19. Работа с моделями данных в Flask\n20. Практическая работа №10. Создание модели пользователей и управление данными\n21. AJAX-запросы в Flask\n22. Практическая работа №11. Создание динамической веб-страницы с AJAX\n23. Интеграция Flask с фронтендом\n24. Практическая работа №12. Интеграция фронтенда с Flask API\n25. Развёртывание Flask-приложения на Gunicorn и Nginx\n26. Практическая работа №13. Развёртывание Flask-приложения на сервере\n27. Хостинг Flask-приложения в облаке\n28. Практическая работа №14. Развёртывание Flask-приложения в облаке\n29. Оптимизация производительности Flask-приложений\n30. Практическая работа №15. Оптимизация производительности приложения\n31. Защита веб-приложений на Flask\n32. Практическая работа №16. Улучшение безопасности веб-приложения\n33. Мониторинг и логирование\n34. Практическая работа №17. Добавление логирования и мониторинга в Flask приложение\n35. Работа с фоновыми задачами в Flask\n36. Практическая работа №18. Создание фоновой задачи в Flask	\N	\N	\N
88	437	4	Модуль 4. Автоматизация задач разработки на Python	1. Инструменты автоматизации процессов разработки\n2. Практическая работа №1. Написание простого скрипта автоматизации с Invoke\n3. Управление зависимостями и виртуальными окружениями\n4. Практическая работа №2. Автоматическое управление зависимостями в проекте\n5. Автоматизация тестирования кода\n6. Практическая работа №3. Написание тестов и их автоматический запуск\n7. Сборка и упаковка Python-проектов\n8. Практическая работа №4. Упаковка Python-приложения в исполняемый файл\n9. Работа с внешними API и requests\n10. Практическая работа №5. Запрос данных с внешнего API\n11. Аутентификация при работе с API\n12. Практическая работа №6. Аутентификация через API и работа с защищёнными ресурсами\n13. Автоматизация обработки данных с API\n14. Практическая работа №7. Асинхронные запросы и кеширование API-ответов\n15. Интеграция Python-скриптов с облачными сервисами\n16. Практическая работа №8. Автоматизация загрузки и обработки данных с Google Sheets\n17. Основы разработки CLI-приложений\n18. Практическая работа №9. Написание базового CLI-инструмента\n19. Улучшение CLI-приложений\n20. Практическая работа №10. Разработка продвинутого CLI-приложения с логированием\n21. Основы парсинга веб-страниц\n22. Практическая работа №11. Парсинг веб-страницы и извлечение данных\n23. Парсинг динамических сайтов\n24. Практическая работа №12. Использование Selenium для получения данных с динамических страниц\n25. Автоматизированная работа с файлами и директориями\n26. Практическая работа №13. Написание скрипта для организации файлов в папках\n27. Автоматизированная обработка данных\n28. Практическая работа №14. Обработка и анализ данных из CSV и Excel\n29. Основы CI/CD и автоматизация развёртывания\n30. Практическая работа №15. Создание простого CI/CD пайплайна\n31. Docker и контейнеризация Python-приложений\n32. Практическая работа №16. Контейнеризация Flask-приложения с Docker\n33. Настройка автоматических тестов в CI/CD\n34. Практическая работа №17. Автоматизация тестирования в CI/CD пайплайне\n35. Автоматизация развёртывания приложений\n36. Практическая работа №18. Автоматизация развёртывания приложения	\N	\N	\N
89	438	1	Модуль 1. Программирование на языке Python	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и запуск первой программы\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Генераторы списков, тернарный оператор\n18. Практическая работа №9. Оптимизация кода с генераторами и lambda-функциями\n19. Итоговые задания по структурам данных\n20. Практическая работа №10. Задачи на работу со структурами данных\n21. Функции в Python: основы\n22. Практическая работа №11. Создание пользовательских функций\n23. Передача аргументов, *args, **kwargs\n24. Практическая работа №12. Работа с *args и **kwargs в пользовательских функциях\n25. Рекурсия в Python\n26. Практическая работа №13. Реализация рекурсивных алгоритмов\n27. Генераторы и итераторы\n28. Практическая работа №14. Написание собственных генераторов данных\n29. Работа с файлами: чтение и запись\n30. Практическая работа №15. Работа с файлами: чтение и запись данных\n31. Работа с CSV и JSON файлами\n32. Практическая работа №16. Чтение и запись данных в CSV и JSON\n33. Обработка ошибок и исключения\n34. Практическая работа №17. Обработка ошибок в пользовательских программах\n35. Работа с регулярными выражениями (re)\n36. Практическая работа №18. Поиск и замена данных с использованием регулярных выражений	\N	\N	\N
90	438	2	Модуль 2. Продвинутое программирование на Python	1. Декораторы в Python: основы\n2. Практическая работа №1. Реализация базовых декораторов\n3. Продвинутые декораторы\n4. Практическая работа №2. Написание сложных декораторов с параметрами\n5. Генераторы и ленивые вычисления\n6. Практическая работа №3. Создание генераторов для обработки данных\n7. Потоковая обработка данных с генераторами\n8. Практическая работа №4. Написание генераторов для обработки файлов и потоков данных\n9. Основы многопоточного программирования\n10. Практическая работа №5. Создание многопоточных программ\n11. Работа с очередями в многопоточности\n12. Практическая работа №6. Организация обработки данных через многопоточные очереди\n13. Асинхронное программирование в Python\n14. Практическая работа №7. Написание асинхронных программ с asyncio\n15. Асинхронные вызовы и Future-объекты\n16. Практическая работа №8. Оптимизация асинхронного кода\n17. Основы регулярных выражений\n18. Практическая работа №9. Использование регулярных выражений для поиска и фильтрации данных\n19. Продвинутая работа с регулярными выражениями\n20. Практическая работа №10. Написание сложных регулярных выражений\n21. Исключения: обработка ошибок\n22. Практическая работа №11. Создание системы обработки ошибок в приложении\n23. Логирование в Python\n24. Практическая работа №12. Внедрение логирования в Python-программу\n25. Основы метапрограммирования в Python\n26. Практическая работа №13. Написание программы с динамическим изменением классов\n27. Работа с объектами и introspection\n28. Практическая работа №14. Инспекция классов и функций с использованием introspection\n29. Глубокая работа с метаклассами\n30. Практическая работа №15. Создание собственных метаклассов\n31. Оптимизация кода и профилирование\n32. Практическая работа №16. Анализ производительности Python-кода\n33. Управление памятью в Python\n34. Практическая работа №17. Оптимизация работы с памятью\n35. Использование Cython и Numba для оптимизации Python-кода\n36. Практическая работа №18. Оптимизация вычислений с помощью Numba	\N	\N	\N
91	438	3	Модуль 3. WEB-разработка на Python (Flask)	1. Введение в Flask и создание первого веб-приложения\n2. Практическая работа №1. Установка Flask и создание первого маршрута\n3. Маршруты и обработка запросов\n4. Практическая работа №2. Обработка маршрутов и параметров в Flask\n5. Шаблоны Jinja2 в Flask\n6. Практическая работа №3. Создание HTML-шаблонов с динамическими данными\n7. Формы и обработка данных\n8. Практическая работа №4. Создание формы авторизации с валидацией\n9. Основы REST API в Flask\n10. Практическая работа №5. Создание простого API с Flask\n11. Создание API с использованием Flask-RESTful\n12. Практическая работа №6. Разработка CRUD API с Flask-RESTful\n13. Аутентификация и авторизация в Flask API\n14. Практическая работа №7. Реализация JWT-аутентификации в Flask API\n15. Защита API и обработка ошибок\n16. Практическая работа №8. Улучшение безопасности API и обработка ошибок\n17. Введение в базы данных и SQLAlchemy\n18. Практическая работа №9. Настройка базы данных с SQLAlchemy\n19. Работа с моделями данных в Flask\n20. Практическая работа №10. Создание модели пользователей и управление данными\n21. AJAX-запросы в Flask\n22. Практическая работа №11. Создание динамической веб-страницы с AJAX\n23. Интеграция Flask с фронтендом\n24. Практическая работа №12. Интеграция фронтенда с Flask API\n25. Развёртывание Flask-приложения на Gunicorn и Nginx\n26. Практическая работа №13. Развёртывание Flask-приложения на сервере\n27. Хостинг Flask-приложения в облаке\n28. Практическая работа №14. Развёртывание Flask-приложения в облаке\n29. Оптимизация производительности Flask-приложений\n30. Практическая работа №15. Оптимизация производительности приложения\n31. Защита веб-приложений на Flask\n32. Практическая работа №16. Улучшение безопасности веб-приложения\n33. Мониторинг и логирование\n34. Практическая работа №17. Добавление логирования и мониторинга в Flask приложение\n35. Работа с фоновыми задачами в Flask\n36. Практическая работа №18. Создание фоновой задачи в Flask	\N	\N	\N
92	438	4	Модуль 4. Автоматизация задач разработки на Python	1. Инструменты автоматизации процессов разработки\n2. Практическая работа №1. Написание простого скрипта автоматизации с Invoke\n3. Управление зависимостями и виртуальными окружениями\n4. Практическая работа №2. Автоматическое управление зависимостями в проекте\n5. Автоматизация тестирования кода\n6. Практическая работа №3. Написание тестов и их автоматический запуск\n7. Сборка и упаковка Python-проектов\n8. Практическая работа №4. Упаковка Python-приложения в исполняемый файл\n9. Работа с внешними API и requests\n10. Практическая работа №5. Запрос данных с внешнего API\n11. Аутентификация при работе с API\n12. Практическая работа №6. Аутентификация через API и работа с защищёнными ресурсами\n13. Автоматизация обработки данных с API\n14. Практическая работа №7. Асинхронные запросы и кеширование API-ответов\n15. Интеграция Python-скриптов с облачными сервисами\n16. Практическая работа №8. Автоматизация загрузки и обработки данных с Google Sheets\n17. Основы разработки CLI-приложений\n18. Практическая работа №9. Написание базового CLI-инструмента\n19. Улучшение CLI-приложений\n20. Практическая работа №10. Разработка продвинутого CLI-приложения с логированием\n21. Основы парсинга веб-страниц\n22. Практическая работа №11. Парсинг веб-страницы и извлечение данных\n23. Парсинг динамических сайтов\n24. Практическая работа №12. Использование Selenium для получения данных с динамических страниц\n25. Автоматизированная работа с файлами и директориями\n26. Практическая работа №13. Написание скрипта для организации файлов в папках\n27. Автоматизированная обработка данных\n28. Практическая работа №14. Обработка и анализ данных из CSV и Excel\n29. Основы CI/CD и автоматизация развёртывания\n30. Практическая работа №15. Создание простого CI/CD пайплайна\n31. Docker и контейнеризация Python-приложений\n32. Практическая работа №16. Контейнеризация Flask-приложения с Docker\n33. Настройка автоматических тестов в CI/CD\n34. Практическая работа №17. Автоматизация тестирования в CI/CD пайплайне\n35. Автоматизация развёртывания приложений\n36. Практическая работа №18. Автоматизация развёртывания приложения	\N	\N	\N
93	439	1	Программа курса	1. Реляционные и нереляционные базы: обзор и выбор\n2. Практическая работа №1. Установка и настройка PostgreSQL и MongoDB Community\n3. Подключение PostgreSQL к Node.js через pg\n4. Практическая работа №2. Выполнение SQL-запросов из приложения\n5. ORM Sequelize: модели, миграции, связи\n6. Практическая работа №3. Создание таблиц и отношений с помощью Sequelize CLI\n7. CRUD-операции через Sequelize\n8. Практическая работа №4. Реализация полного цикла работы с данными\n9. Подключение MongoDB к Node.js через Mongoose\n10. Практическая работа №5. Настройка схем и коллекций\n11. Работа с документами в MongoDB\n12. Практическая работа №6. Вставка, выборка, обновление и удаление\n13. Вложенные документы и агрегации в MongoDB\n14. Практическая работа №7. Сложные запросы и группировки данных\n15. SQLite как лёгкая альтернатива для обучения\n16. Практическая работа №8. Использование SQLite в локальных проектах\n17. Транзакции и обеспечение целостности данных\n18. Практическая работа №9. Работа с транзакциями в PostgreSQL\n19. Оптимизация запросов и индексы\n20. Практическая работа №10. Анализ производительности и настройка индексов\n21. Валидация данных на стороне сервера\n22. Практическая работа №11. Реализация middleware для проверки входных данных\n23. Работа с загрузкой файлов\n24. Практическая работа №12. Приём и сохранение изображений от пользователя\n25. Пагинация и фильтрация в API\n26. Практическая работа №13. Реализация постраничного вывода и поиска\n27. Кэширование с Redis\n28. Практическая работа №14. Настройка кэша для часто запрашиваемых данных\n29. Работа с миграциями и версионированием БД\n30. Практическая работа №15. Применение миграций в Sequelize\n31. Безопасность данных: SQL-инъекции и санитизация\n32. Практическая работа №16. Защита приложения от типовых уязвимостей\n33. Проектирование базы под бизнес-логику\n34. Практическая работа №17. Создание схемы для интернет-магазина или блога\n35. Стратегии миграции между СУБД и выбор БД под задачу\n36. Практическая работа №18. Сравнительный анализ производительности: выполнение одинаковых операций в PostgreSQL и MongoDB	\N	\N	\N
94	440	1	Программа курса	1. Реляционные и нереляционные базы: обзор и выбор\n2. Практическая работа №1. Установка и настройка PostgreSQL и MongoDB Community\n3. Подключение PostgreSQL к Node.js через pg\n4. Практическая работа №2. Выполнение SQL-запросов из приложения\n5. ORM Sequelize: модели, миграции, связи\n6. Практическая работа №3. Создание таблиц и отношений с помощью Sequelize CLI\n7. CRUD-операции через Sequelize\n8. Практическая работа №4. Реализация полного цикла работы с данными\n9. Подключение MongoDB к Node.js через Mongoose\n10. Практическая работа №5. Настройка схем и коллекций\n11. Работа с документами в MongoDB\n12. Практическая работа №6. Вставка, выборка, обновление и удаление\n13. Вложенные документы и агрегации в MongoDB\n14. Практическая работа №7. Сложные запросы и группировки данных\n15. SQLite как лёгкая альтернатива для обучения\n16. Практическая работа №8. Использование SQLite в локальных проектах\n17. Транзакции и обеспечение целостности данных\n18. Практическая работа №9. Работа с транзакциями в PostgreSQL\n19. Оптимизация запросов и индексы\n20. Практическая работа №10. Анализ производительности и настройка индексов\n21. Валидация данных на стороне сервера\n22. Практическая работа №11. Реализация middleware для проверки входных данных\n23. Работа с загрузкой файлов\n24. Практическая работа №12. Приём и сохранение изображений от пользователя\n25. Пагинация и фильтрация в API\n26. Практическая работа №13. Реализация постраничного вывода и поиска\n27. Кэширование с Redis\n28. Практическая работа №14. Настройка кэша для часто запрашиваемых данных\n29. Работа с миграциями и версионированием БД\n30. Практическая работа №15. Применение миграций в Sequelize\n31. Безопасность данных: SQL-инъекции и санитизация\n32. Практическая работа №16. Защита приложения от типовых уязвимостей\n33. Проектирование базы под бизнес-логику\n34. Практическая работа №17. Создание схемы для интернет-магазина или блога\n35. Стратегии миграции между СУБД и выбор БД под задачу\n36. Практическая работа №18. Сравнительный анализ производительности: выполнение одинаковых операций в PostgreSQL и MongoDB	\N	\N	\N
95	441	1	Программа курса	1. Введение в React: JSX, Virtual DOM, компоненты\n2. Практическая работа №1. Создание первого приложения на Vite + React\n3. Функциональные компоненты и props\n4. Практическая работа №2. Разработка переиспользуемых компонентов из Figma-макета\n5. Состояние: useState, управление формой\n6. Практическая работа №3. Реализация интерактивного списка задач\n7. Побочные эффекты: useEffect, загрузка данных\n8. Практическая работа №4. Интеграция с JSONPlaceholder API для отображения постов\n9. Условный рендеринг и списки\n10. Практическая работа №5. Отображение статуса загрузки и ошибок при работе с API\n11. Стилизация компонентов: CSS Modules, styled-components\n12. Практическая работа №6. Создание темной/светлой темы с CSS Modules\n13. Контекст: Context API для глобального состояния\n14. Практическая работа №7. Настройка темы и языка через провайдеры\n15. Маршрутизация: React Router v6 (роуты, навигация)\n16. Практическая работа №8. Создание многостраничного приложения с хедера и активными ссылками\n17. Формы: управление состоянием, валидация\n18. Практическая работа №9. Реализация формы регистрации с мгновенной валидацией\n19. Хуки: useCallback, useMemo, useRef\n20. Практическая работа №10. Оптимизация ререндеров в компоненте с графиком\n21. Тестирование: Jest + React Testing Library\n22. Практическая работа №11. Написание тестов для компонента списка и хуков\n23. Типизация: TypeScript в React (базовый уровень)\n24. Практическая работа №12. Добавление типов к компонентам и API-запросам\n25. Анимации: Framer Motion для переходов\n26. Практическая работа №13. Анимация появления модального окна и маршрутов\n27. Работа с медиа: изображения, видео, адаптивные форматы\n28. Практическая работа №14. Создание галереи с ленивой загрузкой и адаптивными изображениями\n29. Локальное хранилище: localStorage, кастомные хуки\n30. Практическая работа №15. Сохранение темы и данных формы между перезагрузками\n31. Отладка: React DevTools, логирование, мониторинг ошибок\n32. Практическая работа №16. Диагностика ошибки в сложном компоненте через DevTools\n33. Интеграция с библиотеками: Chart.js для визуализации\n34. Практическая работа №17. Отображение динамических данных в виде графика\n35. Производительность: React.memo, code splitting\n36. Практическая работа №18. Оптимизация приложения с использованием useMemo и lazy/Suspense	\N	\N	\N
96	442	1	Программа курса	1. Введение в React: JSX, Virtual DOM, компоненты\n2. Практическая работа №1. Создание первого приложения на Vite + React\n3. Функциональные компоненты и props\n4. Практическая работа №2. Разработка переиспользуемых компонентов из Figma-макета\n5. Состояние: useState, управление формой\n6. Практическая работа №3. Реализация интерактивного списка задач\n7. Побочные эффекты: useEffect, загрузка данных\n8. Практическая работа №4. Интеграция с JSONPlaceholder API для отображения постов\n9. Условный рендеринг и списки\n10. Практическая работа №5. Отображение статуса загрузки и ошибок при работе с API\n11. Стилизация компонентов: CSS Modules, styled-components\n12. Практическая работа №6. Создание темной/светлой темы с CSS Modules\n13. Контекст: Context API для глобального состояния\n14. Практическая работа №7. Настройка темы и языка через провайдеры\n15. Маршрутизация: React Router v6 (роуты, навигация)\n16. Практическая работа №8. Создание многостраничного приложения с хедера и активными ссылками\n17. Формы: управление состоянием, валидация\n18. Практическая работа №9. Реализация формы регистрации с мгновенной валидацией\n19. Хуки: useCallback, useMemo, useRef\n20. Практическая работа №10. Оптимизация ререндеров в компоненте с графиком\n21. Тестирование: Jest + React Testing Library\n22. Практическая работа №11. Написание тестов для компонента списка и хуков\n23. Типизация: TypeScript в React (базовый уровень)\n24. Практическая работа №12. Добавление типов к компонентам и API-запросам\n25. Анимации: Framer Motion для переходов\n26. Практическая работа №13. Анимация появления модального окна и маршрутов\n27. Работа с медиа: изображения, видео, адаптивные форматы\n28. Практическая работа №14. Создание галереи с ленивой загрузкой и адаптивными изображениями\n29. Локальное хранилище: localStorage, кастомные хуки\n30. Практическая работа №15. Сохранение темы и данных формы между перезагрузками\n31. Отладка: React DevTools, логирование, мониторинг ошибок\n32. Практическая работа №16. Диагностика ошибки в сложном компоненте через DevTools\n33. Интеграция с библиотеками: Chart.js для визуализации\n34. Практическая работа №17. Отображение динамических данных в виде графика\n35. Производительность: React.memo, code splitting\n36. Практическая работа №18. Оптимизация приложения с использованием useMemo и lazy/Suspense	\N	\N	\N
97	443	1	Программа курса	1. Введение в веб-разработку: клиент-сервер, роль frontend\n2. Практическая работа №1. Анализ структуры веб-страницы в DevTools\n3. Основы HTML5: теги, атрибуты, семантика\n4. Практическая работа №2. Создание многосекционной HTML-страницы\n5. Основы CSS3: селекторы, свойства, каскад\n6. Практическая работа №3. Стилизация страницы с использованием внешних стилей\n7. Типы данных и переменные в JavaScript\n8. Практическая работа №4. Работа с примитивами и объектами в консоли браузера\n9. Операторы и логические выражения\n10. Практическая работа №5. Валидация пользовательского ввода через prompt\n11. Условные конструкции: if, else, switch\n12. Практическая работа №6. Изменение стиля элемента в зависимости от условия\n13. Циклы: for, while, for…of\n14. Практическая работа №7. Динамическое создание списка элементов в DOM\n15. Функции: объявление, параметры, возврат\n16. Практическая работа №8. Создание интерактивных обработчиков событий\n17. Область видимости и замыкания\n18. Практическая работа №9. Реализация счётчика с приватным состоянием\n19. Работа с массивами: методы map, filter, reduce\n20. Практическая работа №10. Фильтрация и отображение данных из массива\n21. Работа с объектами: деструктуризация, spread\n22. Практическая работа №11. Обновление UI на основе объектных данных\n23. Модули ES6+: import/export\n24. Практическая работа №12. Разделение логики на модули в Vite-проекте\n25. Асинхронность: Promise, async/await\n26. Практическая работа №13. Загрузка данных с JSONPlaceholder и отображение\n27. Работа с DOM: выбор, создание, изменение элементов\n28. Практическая работа №14. Построение динамического интерфейса без фреймворков\n29. Обработка событий: click, input, submit\n30. Практическая работа №15. Создание интерактивной формы с валидацией\n31. Работа с локальным хранилищем: localStorage\n32. Практическая работа №16. Сохранение состояния приложения между перезагрузками\n33. Отладка и инструменты разработчика\n34. Практическая работа №17. Диагностика ошибок и профилирование производительности\n35. Интеграция HTML, CSS и JavaScript в единое приложение\n36. Практическая работа №18. Реализация одностраничного интерфейса для управления списком задач	\N	\N	\N
98	444	1	Программа курса	1. Введение в веб-разработку: клиент-сервер, роль frontend\n2. Практическая работа №1. Анализ структуры веб-страницы в DevTools\n3. Основы HTML5: теги, атрибуты, семантика\n4. Практическая работа №2. Создание многосекционной HTML-страницы\n5. Основы CSS3: селекторы, свойства, каскад\n6. Практическая работа №3. Стилизация страницы с использованием внешних стилей\n7. Типы данных и переменные в JavaScript\n8. Практическая работа №4. Работа с примитивами и объектами в консоли браузера\n9. Операторы и логические выражения\n10. Практическая работа №5. Валидация пользовательского ввода через prompt\n11. Условные конструкции: if, else, switch\n12. Практическая работа №6. Изменение стиля элемента в зависимости от условия\n13. Циклы: for, while, for…of\n14. Практическая работа №7. Динамическое создание списка элементов в DOM\n15. Функции: объявление, параметры, возврат\n16. Практическая работа №8. Создание интерактивных обработчиков событий\n17. Область видимости и замыкания\n18. Практическая работа №9. Реализация счётчика с приватным состоянием\n19. Работа с массивами: методы map, filter, reduce\n20. Практическая работа №10. Фильтрация и отображение данных из массива\n21. Работа с объектами: деструктуризация, spread\n22. Практическая работа №11. Обновление UI на основе объектных данных\n23. Модули ES6+: import/export\n24. Практическая работа №12. Разделение логики на модули в Vite-проекте\n25. Асинхронность: Promise, async/await\n26. Практическая работа №13. Загрузка данных с JSONPlaceholder и отображение\n27. Работа с DOM: выбор, создание, изменение элементов\n28. Практическая работа №14. Построение динамического интерфейса без фреймворков\n29. Обработка событий: click, input, submit\n30. Практическая работа №15. Создание интерактивной формы с валидацией\n31. Работа с локальным хранилищем: localStorage\n32. Практическая работа №16. Сохранение состояния приложения между перезагрузками\n33. Отладка и инструменты разработчика\n34. Практическая работа №17. Диагностика ошибок и профилирование производительности\n35. Интеграция HTML, CSS и JavaScript в единое приложение\n36. Практическая работа №18. Реализация одностраничного интерфейса для управления списком задач	\N	\N	\N
99	445	1	Программа курса	1. Основы языка JavaScript\n2. Практическая работа №1. Работа с переменными, типами и операторами\n3. Функции, замыкания и области видимости\n4. Практическая работа №2. Создание и вызов функций с разными контекстами\n5. Работа с массивами и объектами\n6. Работа с массивами и объектами\n7. Модули и система импортов/экспортов в JavaScript (ES6+)\n8. Практическая работа №4. Создание и подключение собственных модулей\n9. Асинхронное программирование: Callbacks, Promises, async/await\n10. Практическая работа №5. Реализация асинхронных операций с Promise\n11. Работа с файловой системой в Node.js\n12. Практическая работа №6. Чтение, запись и обработка файлов\n13. Встроенные модули Node.js: path, fs, os, events\n14. Практическая работа №7. Использование встроенных модулей для системных задач\n15. NPM и управление зависимостями\n16. Практическая работа №8. Инициализация проекта и установка пакетов\n17. Основы архитектуры серверного приложения\n18. Практическая работа №9. Создание простого HTTP-сервера без фреймворков\n19. Введение в Express.js: маршрутизация и middleware\n20. Практическая работа №10. Настройка первого Express-приложения\n21. Обработка запросов: GET, POST, PUT, DELETE\n22. Практическая работа №11. Реализация REST-методов в приложении\n23. Работа с телом запроса: body-parser и JSON\n24. Практическая работа №12. Приём и валидация данных от клиента\n25. Параметры маршрутов и query-строки\n26. Практическая работа №13. Обработка динамических URL и параметров\n27. Ошибки и обработка исключений на сервере\n28. Практическая работа №14. Создание централизованного обработчика ошибок\n29. Логирование и отладка серверных приложений\n30. Практическая работа №15. Настройка логирования с помощью winston\n31. Настройка структуры проекта (MVC-подобная архитектура)\n32. Практическая работа №16. Организация кода по папкам: routes, controllers, utils\n33. Работа с переменными окружения и dotenv\n34. Практическая работа №17. Безопасное хранение конфиденциальных данных\n35. Подходы к проектированию чистого и поддерживаемого серверного кода (Обзор принципов: DRY, KISS, SRP, разделение ответственности, организация утилит и хелперов)\n36. Практическая работа №18. Рефакторинг HTTP-сервера: выделение логики в контроллеры и middleware	\N	\N	\N
100	446	1	Программа курса	1. Основы языка JavaScript\n2. Практическая работа №1. Работа с переменными, типами и операторами\n3. Функции, замыкания и области видимости\n4. Практическая работа №2. Создание и вызов функций с разными контекстами\n5. Работа с массивами и объектами\n6. Практическая работа №3. Обработка данных с использованием map, filter, reduce\n7. Модули и система импортов/экспортов в JavaScript (ES6+)\n8. Практическая работа №4. Создание и подключение собственных модулей\n9. Асинхронное программирование: Callbacks, Promises, async/await\n10. Практическая работа №5. Реализация асинхронных операций с Promise\n11. Работа с файловой системой в Node.js\n12. Практическая работа №6. Чтение, запись и обработка файлов\n13. Встроенные модули Node.js: path, fs, os, events\n14. Практическая работа №7. Использование встроенных модулей для системных задач\n15. NPM и управление зависимостями\n16. Практическая работа №8. Инициализация проекта и установка пакетов\n17. Основы архитектуры серверного приложения\n18. Практическая работа №9. Создание простого HTTP-сервера без фреймворков\n19. Введение в Express.js: маршрутизация и middleware\n20. Практическая работа №10. Настройка первого Express-приложения\n21. Обработка запросов: GET, POST, PUT, DELETE\n22. Практическая работа №11. Реализация REST-методов в приложении\n23. Работа с телом запроса: body-parser и JSON\n24. Практическая работа №12. Приём и валидация данных от клиента\n25. Параметры маршрутов и query-строки\n26. Практическая работа №13. Обработка динамических URL и параметров\n27. Ошибки и обработка исключений на сервере\n28. Практическая работа №14. Создание централизованного обработчика ошибок\n29. Логирование и отладка серверных приложений\n30. Практическая работа №15. Настройка логирования с помощью winston\n31. Настройка структуры проекта (MVC-подобная архитектура)\n32. Практическая работа №16. Организация кода по папкам: routes, controllers, utils\n33. Работа с переменными окружения и dotenv\n34. Практическая работа №17. Безопасное хранение конфиденциальных данных\n35. Подходы к проектированию чистого и поддерживаемого серверного кода (Обзор принципов: DRY, KISS, SRP, разделение ответственности, организация утилит и хелперов)\n36. Практическая работа №18. Рефакторинг HTTP-сервера: выделение логики в контроллеры и middleware	\N	\N	\N
105	451	1	Программа курса	1. Знакомство с Blender: интерфейс, настройка\n2. Практическая работа №1. Установка Blender, создание первого объекта\n3. Основы навигации и трансформации\n4. Практическая работа №2. Перемещение, вращение, масштабирование объектов\n5. Примитивы и редактирование мешей\n6. Практическая работа №3. Создание простого 3D-объекта\n7. Режим редактирования: вершины, рёбра, грани\n8. Практическая работа №4. Моделирование простого оружия или предмета\n9. Модификаторы: Subdivision, Boolean, Mirror\n10. Практическая работа №5. Применение модификаторов для ускорения моделирования\n11. Материалы и шейдеры в Blender\n12. Практическая работа №6. Создание PBR-материала для объекта\n13. UV-развёртка и текстурирование\n14. Практическая работа №7. Развёртка и наложение текстуры на модель\n15. Создание текстур в Krita / GIMP\n16. Практическая работа №8. Рисование текстуры для игрового объекта\n17. Арматура и риггинг\n18. Практическая работа №9. Создание скелета для персонажа\n19. Анимация в Blender\n20. Практическая работа №10. Анимация ходьбы персонажа\n21. Экспорт моделей в Unity (.fbx)\n22. Практическая работа №11. Настройка экспорта и импорт в Unity\n23. Оптимизация полигональности\n24. Практическая работа №12. Редуцирование полигонов для мобильных игр\n25. LOD (уровни детализации)\n26. Практическая работа №13. Создание LOD-моделей в Blender и Unity\n27. Создание простого ландшафта\n28. Практическая работа №14. Моделирование холмов и скал\n29. Системы частиц в Blender\n30. Практическая работа №15. Создание огня или дыма для визуализации\n31. Рендеринг: Cycles и Eevee\n32. Практическая работа №16. Рендер сцены для презентации\n33. Создание простого UI-элемента в Blender\n34. Практическая работа №17. Моделирование 3D-кнопки или иконки\n35. Настройка рабочего процесса Blender–Unity\n36. Практическая работа №18. Полный цикл: от модели до использования в игре	\N	\N	\N
101	447	1	Программа курса	1. Структура HTML5: семантические теги и доступность\n2. Структура HTML5: семантические теги и доступность\n3. CSS3: селекторы, box model, позиционирование\n4. Практическая работа №2. Стилизация страницы с использованием CSS-переменных\n5. Адаптивный дизайн: медиа-запросы, mobile-first\n6. Практическая работа №3. Верстка макета для трёх точек останова\n7. Flexbox и CSS Grid: продвинутые макеты\n8. Практическая работа №4. Создание сложного Grid-макета с областями\n9. Препроцессоры: SCSS (вложенность, миксины, функции)\n10. Практическая работа №5. Конвертация CSS в SCSS с переменными и циклами\n11. Анимации и переходы: keyframes, transform, opacity\n12. Практическая работа №6. Реализация интерактивных эффектов при наведении\n13. Оптимизация изображений: форматы, lazy loading, SVG\n14. Практическая работа №7. Интеграция SVG-иконок и оптимизация загрузки фото\n15. CSS-архитектура: БЭМ, компонентный подход\n16. Практическая работа №8. Рефакторинг стилей по методологии БЭМ\n17. Кроссбраузерная вёрстка: особенности Firefox/Chrome/Safari\n18. Практическая работа №9. Исправление браузерных особенностей в макете\n19. Инструменты сборки: Vite для статических сайтов\n20. Практическая работа №10. Настройка проекта с поддержкой SCSS и автоперезагрузки\n21. Работа с Figma: экспорт стилей, спейсов, изображений\n22. Практическая работа №11. Верстка pixel-perfect секции по макету из Figma\n23. CSS-фреймворки: Tailwind CSS (основы и кастомизация)\n24. Практическая работа №12. Прототипирование интерфейса с использованием Tailwind\n25. Тестирование верстки: DevTools, Lighthouse, axe\n26. Практическая работа №13. Анализ производительности и доступности страницы\n27. Версия контроля: Git для верстки (ветки, коммиты, GitHub Pages)\n28. Практическая работа №14. Настройка деплоя на GitHub Pages (ручная сборка)\n29. Оптимизация скорости: критический CSS, шрифты, кэширование\n30. Практическая работа №15. Улучшение показателей Lighthouse до 90+\n31. Методологии: Agile в верстке, оценка задач в story points\n32. Практическая работа №16. Разбиение макета на задачи в AnyType или локальном Kanban-инструменте (WeKan)\n33. Документирование компонентов: Styleguidist для верстки\n34. Практическая работа №17. Создание living style guide для UI-библиотеки\n35. Создание портфолио: структура, хостинг, домен\n36. Практическая работа №18. Публикация портфолио на VK Cloud Pages	\N	\N	\N
102	448	1	Программа курса	1. Структура HTML5: семантические теги и доступность\n2. Практическая работа №1. Создание семантической страницы с поддержкой a11y\n3. CSS3: селекторы, box model, позиционирование\n4. Практическая работа №2. Стилизация страницы с использованием CSS-переменных\n5. Адаптивный дизайн: медиа-запросы, mobile-first\n6. Практическая работа №3. Верстка макета для трёх точек останова\n7. Flexbox и CSS Grid: продвинутые макеты\n8. Практическая работа №4. Создание сложного Grid-макета с областями\n9. Препроцессоры: SCSS (вложенность, миксины, функции)\n10. Практическая работа №5. Конвертация CSS в SCSS с переменными и циклами\n11. Анимации и переходы: keyframes, transform, opacity\n12. Практическая работа №6. Реализация интерактивных эффектов при наведении\n13. Оптимизация изображений: форматы, lazy loading, SVG\n14. Практическая работа №7. Интеграция SVG-иконок и оптимизация загрузки фото\n15. CSS-архитектура: БЭМ, компонентный подход\n16. Практическая работа №8. Рефакторинг стилей по методологии БЭМ\n17. Кроссбраузерная вёрстка: особенности Firefox/Chrome/Safari\n18. Практическая работа №9. Исправление браузерных особенностей в макете\n19. Инструменты сборки: Vite для статических сайтов\n20. Практическая работа №10. Настройка проекта с поддержкой SCSS и автоперезагрузки\n21. Работа с Figma: экспорт стилей, спейсов, изображений\n22. Практическая работа №11. Верстка pixel-perfect секции по макету из Figma\n23. CSS-фреймворки: Tailwind CSS (основы и кастомизация)\n24. Практическая работа №12. Прототипирование интерфейса с использованием Tailwind\n25. Тестирование верстки: DevTools, Lighthouse, axe\n26. Практическая работа №13. Анализ производительности и доступности страницы\n27. Версия контроля: Git для верстки (ветки, коммиты, GitHub Pages)\n28. Практическая работа №14. Настройка деплоя на GitHub Pages (ручная сборка)\n29. Оптимизация скорости: критический CSS, шрифты, кэширование\n30. Практическая работа №15. Улучшение показателей Lighthouse до 90+\n31. Методологии: Agile в верстке, оценка задач в story points\n32. Практическая работа №16. Разбиение макета на задачи в AnyType или локальном Kanban-инструменте (WeKan)\n33. Документирование компонентов: Styleguidist для верстки\n34. Практическая работа №17. Создание living style guide для UI-библиотеки\n35. Создание портфолио: структура, хостинг, домен\n36. Практическая работа №18. Публикация портфолио на VK Cloud Pages	\N	\N	\N
103	449	1	Программа курса	1. Основы DevOps и роль Python в автоматизации\n2. Практическая работа №1. Написание первого DevOps-скрипта на Python (мониторинг доступности сервиса)\n3. Работа с процессами и файлами в Python\n4. Практическая работа №2. Автоматизация архивирования и очистки логов\n5. Инфраструктура как код (IaC) с Python\n6. Практическая работа №3. Генерация конфигураций Ansible через Python-скрипты\n7. Управление облачными сервисами через Python\n8. Практическая работа №4. Работа с Yandex.Cloud через официальный Python SDK\n9. Мониторинг DevOps-инфраструктуры с Python\n10. Практическая работа №5. Создание простого экспортера метрик для Prometheus\n11. Логирование и обработка логов\n12. Практическая работа №6. Настройка структурированного логирования с использованием Python logging + JSON\n13. CI/CD и автоматизация деплоя\n14. Практическая работа №7. Написание скрипта для автоматизированной сборки и тестирования\n15. Интеграция Python с CI/CD инструментами\n16. Практическая работа №8. Запуск Python-валидации конфигураций в GitLab CI\n17. Контейнеризация Python-приложений с Docker\n18. Практическая работа №9. Создание оптимизированного Docker-образа для CLI-инструмента\n19. Автоматизация Kubernetes через Python\n20. Практическая работа №10. Использование официального Kubernetes Python client для управления кластером\n21. Масштабирование DevOps-скриптов\n22. Практическая работа №11. Применение асинхронного программирования (async/await) для параллельных задач\n23. Управление конфигурациями серверов через Python\n24. Практическая работа №12. Генерация конфигурационных файлов (nginx, systemd) с шаблонами Jinja2\n25. Автоматизация тестирования DevOps-инфраструктуры\n26. Практическая работа №13. Написание health-check скрипта для проверки целостности инфраструктуры\n27. Автоматизированный анализ уязвимостей\n28. Практическая работа №14. Скрипт для сканирования зависимостей Python-приложений на уязвимости (safety, bandit)\n29. Автоматизированный бэкап и восстановление данных\n30. Практическая работа №15. Резервное копирование базы данных PostgreSQL с отправкой в облако\n31. Автоматизация управления доступом и пользователями\n32. Практическая работа №16. Управление SSH-ключами и sudoers через Python\n33. Настройка алертинга и уведомлений в DevOps\n34. Практическая работа №17. Отправка оповещений в Telegram при нештатной ситуации\n35. Интеграция DevOps-инструментов в единый автоматизированный пайплайн\n36. Практическая работа №18. Реализация интегрированного DevOps-пайплайна: мониторинг, логирование, резервное копирование и автоматическое восстановление	\N	\N	\N
104	450	1	Программа курса	1. Основы DevOps и роль Python в автоматизации\n2. Практическая работа №1. Написание первого DevOps-скрипта на Python (мониторинг доступности сервиса)\n3. Работа с процессами и файлами в Python\n4. Практическая работа №2. Автоматизация архивирования и очистки логов\n5. Инфраструктура как код (IaC) с Python\n6. Практическая работа №3. Генерация конфигураций Ansible через Python-скрипты\n7. Управление облачными сервисами через Python\n8. Практическая работа №4. Работа с Yandex.Cloud через официальный Python SDK\n9. Мониторинг DevOps-инфраструктуры с Python\n10. Практическая работа №5. Создание простого экспортера метрик для Prometheus\n11. Логирование и обработка логов\n12. Практическая работа №6. Настройка структурированного логирования с использованием Python logging + JSON\n13. CI/CD и автоматизация деплоя\n14. Практическая работа №7. Написание скрипта для автоматизированной сборки и тестирования\n15. Интеграция Python с CI/CD инструментами\n16. Практическая работа №8. Запуск Python-валидации конфигураций в GitLab CI\n17. Контейнеризация Python-приложений с Docker\n18. Практическая работа №9. Создание оптимизированного Docker-образа для CLI-инструмента\n19. Автоматизация Kubernetes через Python\n20. Практическая работа №10. Использование официального Kubernetes Python client для управления кластером\n21. Масштабирование DevOps-скриптов\n22. Практическая работа №11. Применение асинхронного программирования (async/await) для параллельных задач\n23. Управление конфигурациями серверов через Python\n24. Практическая работа №12. Генерация конфигурационных файлов (nginx, systemd) с шаблонами Jinja2\n25. Автоматизация тестирования DevOps-инфраструктуры\n26. Практическая работа №13. Написание health-check скрипта для проверки целостности инфраструктуры\n27. Автоматизированный анализ уязвимостей\n28. Практическая работа №14. Скрипт для сканирования зависимостей Python-приложений на уязвимости (safety, bandit)\n29. Автоматизированный бэкап и восстановление данных\n30. Практическая работа №15. Резервное копирование базы данных PostgreSQL с отправкой в облако\n31. Автоматизация управления доступом и пользователями\n32. Практическая работа №16. Управление SSH-ключами и sudoers через Python\n33. Настройка алертинга и уведомлений в DevOps\n34. Практическая работа №17. Отправка оповещений в Telegram при нештатной ситуации\n35. Интеграция DevOps-инструментов в единый автоматизированный пайплайн\n36. Практическая работа №18. Реализация интегрированного DevOps-пайплайна: мониторинг, логирование, резервное копирование и автоматическое восстановление	\N	\N	\N
106	452	1	Программа курса	1. Знакомство с Blender: интерфейс, настройка\n2. Практическая работа №1. Установка Blender, создание первого объекта\n3. Основы навигации и трансформации\n4. Практическая работа №2. Перемещение, вращение, масштабирование объектов\n5. Примитивы и редактирование мешей\n6. Практическая работа №3. Создание простого 3D-объекта\n7. Режим редактирования: вершины, рёбра, грани\n8. Практическая работа №4. Моделирование простого оружия или предмета\n9. Модификаторы: Subdivision, Boolean, Mirror\n10. Практическая работа №5. Применение модификаторов для ускорения моделирования\n11. Материалы и шейдеры в Blender\n12. Практическая работа №6. Создание PBR-материала для объекта\n13. UV-развёртка и текстурирование\n14. Практическая работа №7. Развёртка и наложение текстуры на модель\n15. Создание текстур в Krita / GIMP\n16. Практическая работа №8. Рисование текстуры для игрового объекта\n17. Арматура и риггинг\n18. Практическая работа №9. Создание скелета для персонажа\n19. Анимация в Blender\n20. Практическая работа №10. Анимация ходьбы персонажа\n21. Экспорт моделей в Unity (.fbx)\n22. Практическая работа №11. Настройка экспорта и импорт в Unity\n23. Оптимизация полигональности\n24. Практическая работа №12. Редуцирование полигонов для мобильных игр\n25. LOD (уровни детализации)\n26. Практическая работа №13. Создание LOD-моделей в Blender и Unity\n27. Создание простого ландшафта\n28. Практическая работа №14. Моделирование холмов и скал\n29. Системы частиц в Blender\n30. Практическая работа №15. Создание огня или дыма для визуализации\n31. Рендеринг: Cycles и Eevee\n32. Практическая работа №16. Рендер сцены для презентации\n33. Создание простого UI-элемента в Blender\n34. Практическая работа №17. Моделирование 3D-кнопки или иконки\n35. Настройка рабочего процесса Blender–Unity\n36. Практическая работа №18. Полный цикл: от модели до использования в игре	\N	\N	\N
107	453	1	Программа курса	1. Введение в автоматизированное тестирование: когда и что автоматизировать\n2. Практическая работа №1. Оценка ROI для автоматизации тест-кейсов\n3. Основы Pytest: структура, assert, фикстуры\n4. Практическая работа №2. Написание первого теста с Pytest\n5. Параметризация и data-driven тестирование в Pytest\n6. Практическая работа №3. Запуск одного теста с разными входными данными\n7. Работа с фикстурами: setup/teardown, scope\n8. Практическая работа №4. Создание фикстур для подключения к API\n9. Тестирование REST API с Requests и Pytest\n10. Практическая работа №5. Автоматизация проверок публичного API\n11. Валидация JSON-ответов и схем (jsonschema)\n12. Практическая работа №6. Проверка структуры ответа по схеме\n13. Работа с заголовками, авторизацией (Bearer, Basic)\n14. Практическая работа №7. Тестирование защищённых эндпоинтов\n15. UI-автоматизация с Selenium WebDriver\n16. Практическая работа №8. Установка драйверов и запуск браузера\n17. Поиск элементов: ID, XPath, CSS-селекторы\n18. Практическая работа №9. Авторизация на сайте через автотест\n19. Ожидания: implicit vs explicit (WebDriverWait)\n20. Практическая работа №10. Стабилизация тестов с ожиданиями\n21. Работа с выпадающими списками, чекбоксами, алертами\n22. Практическая работа №11. Взаимодействие со сложными элементами UI\n23. Скриншоты и логирование в автотестах\n24. Практическая работа №12. Автоматическое сохранение скриншотов при падении\n25. Генерация отчётов: pytest-html / HTMLTestRunner\n26. Практическая работа №13. Генерация HTML-отчёта о результатах тестов\n27. Тестирование файловых операций и загрузок\n28. Практическая работа №14. Автотест на загрузку и обработку файла\n29. Headless-режим и параллельный запуск\n30. Практическая работа №15. Ускорение тестов через headless-браузер\n31. Организация структуры проекта автотестов\n32. Организация структуры проекта автотестов\n33. Покрытие тестами: измерение и анализ\n34. Практическая работа №17. Расчёт покрытия функционала автотестами\n35. Поддержка и рефакторинг автотестов\n36. Практическая работа №18. Обновление устаревших селекторов и логики	\N	\N	\N
108	454	1	Программа курса	1. Введение в автоматизированное тестирование: когда и что автоматизировать\n2. Практическая работа №1. Оценка ROI для автоматизации тест-кейсов\n3. Основы Pytest: структура, assert, фикстуры\n4. Практическая работа №2. Написание первого теста с Pytest\n5. Параметризация и data-driven тестирование в Pytest\n6. Практическая работа №3. Запуск одного теста с разными входными данными\n7. Работа с фикстурами: setup/teardown, scope\n8. Практическая работа №4. Создание фикстур для подключения к API\n9. Тестирование REST API с Requests и Pytest\n10. Практическая работа №5. Автоматизация проверок публичного API\n11. Валидация JSON-ответов и схем (jsonschema)\n12. Практическая работа №6. Проверка структуры ответа по схеме\n13. Работа с заголовками, авторизацией (Bearer, Basic)\n14. Практическая работа №7. Тестирование защищённых эндпоинтов\n15. UI-автоматизация с Selenium WebDriver\n16. Практическая работа №8. Установка драйверов и запуск браузера\n17. Поиск элементов: ID, XPath, CSS-селекторы\n18. Практическая работа №9. Авторизация на сайте через автотест\n19. Ожидания: implicit vs explicit (WebDriverWait)\n20. Практическая работа №10. Стабилизация тестов с ожиданиями\n21. Работа с выпадающими списками, чекбоксами, алертами\n22. Практическая работа №11. Взаимодействие со сложными элементами UI\n23. Скриншоты и логирование в автотестах\n24. Практическая работа №12. Автоматическое сохранение скриншотов при падении\n25. Генерация отчётов: pytest-html / HTMLTestRunner\n26. Практическая работа №13. Генерация HTML-отчёта о результатах тестов\n27. Тестирование файловых операций и загрузок\n28. Практическая работа №14. Автотест на загрузку и обработку файла\n29. Headless-режим и параллельный запуск\n30. Практическая работа №15. Ускорение тестов через headless-браузер\n31. Организация структуры проекта автотестов\n32. Практическая работа №16. Создание многоуровневого тестового репозитория\n33. Покрытие тестами: измерение и анализ\n34. Практическая работа №17. Расчёт покрытия функционала автотестами\n35. Поддержка и рефакторинг автотестов\n36. Практическая работа №18. Обновление устаревших селекторов и логики	\N	\N	\N
109	455	1	Программа курса	1. Git для тестировщика: ветки, коммиты, pull request\n2. Практическая работа №1. Версионирование тестов и совместная работа\n3. Docker для QA: контейнеризация тестовых сред\n4. Практическая работа №2. Запуск автотестов в Docker-контейнере\n5. Docker Compose: поднятие полного стека (приложение + БД + тесты)\n6. Практическая работа №3. Интеграционное тестирование в изолированной среде\n7. Введение в Kubernetes: Pods, Deployments, Services (опционально, с акцентом на локальное использование)\n8. Практическая работа №4. Развёртывание тестового приложения в Minikube или Docker Compose\n9. Тестирование в облачных и распределённых системах\n10. Практическая работа №5. Проверка работы сервиса в кластере\n11. CI/CD для QA: зачем и как интегрировать тесты (GitLab CI / Jenkins)\n12. Практическая работа №6. Создание пайплайна в GitLab CI\n13. Запуск тестов при пуше и пуле-реквесте\n14. Практическая работа №7. Настройка триггеров и условий выполнения\n15. Работа с секретами: токены, пароли в CI\n16. Практическая работа №8. Безопасное хранение учётных данных\n17. Отчётность в CI: публикация HTML-отчётов как артефактов\n18. Практическая работа №9. Интеграция отчётов в пайплайн\n19. Запуск тестов по расписанию (cron в CI)\n20. Практическая работа №10. Ежедневная проверка стабильности API\n21. Мониторинг и алертинг по результатам тестов\n22. Практическая работа №11. Отправка уведомлений в Telegram\n23. Тестирование в микросервисной архитектуре\n24. Практическая работа №12. Мокирование зависимостей (Mock Server / WireMock / Python-моки)\n25. Нагрузочное тестирование (Locust)\n26. Практическая работа №13. Проверка устойчивости API под нагрузкой\n27. Безопасность автотестов: инъекции, утечки данных\n28. Практическая работа №14. Аудит тестовых скриптов на безопасность\n29. Создание собственного тестового фреймворка\n30. Практическая работа №15. Разработка базовой обёртки над Selenium + Pytest\n31. Интеграция с системами мониторинга (Prometheus, Grafana)\n32. Практическая работа №16. Визуализация метрик качества\n33. Интеграция компонентов автоматизированного тестирования: от тест-плана до CI/CD\n34. Практическая работа №17. Реализация сквозного тестового сценария: проектирование, автоматизация, интеграция в пайплайн\n35. Автоматизация тестирования безопасности (Security Testing)\n36. Практическая работа №18. Формирование профессионального портфолио: документация, метрики качества и рекомендации по поддержке тестов	\N	\N	\N
110	456	1	Программа курса	1. Git для тестировщика: ветки, коммиты, pull request\n2. Практическая работа №1. Версионирование тестов и совместная работа\n3. Docker для QA: контейнеризация тестовых сред\n4. Практическая работа №2. Запуск автотестов в Docker-контейнере\n5. Docker Compose: поднятие полного стека (приложение + БД + тесты)\n6. Практическая работа №3. Интеграционное тестирование в изолированной среде\n7. Введение в Kubernetes: Pods, Deployments, Services (опционально, с акцентом на локальное использование)\n8. Практическая работа №4. Развёртывание тестового приложения в Minikube или Docker Compose\n9. Тестирование в облачных и распределённых системах\n10. Практическая работа №5. Проверка работы сервиса в кластере\n11. CI/CD для QA: зачем и как интегрировать тесты (GitLab CI / Jenkins)\n12. Практическая работа №6. Создание пайплайна в GitLab CI\n13. Запуск тестов при пуше и пуле-реквесте\n14. Практическая работа №7. Настройка триггеров и условий выполнения\n15. Работа с секретами: токены, пароли в CI\n16. Практическая работа №8. Безопасное хранение учётных данных\n17. Отчётность в CI: публикация HTML-отчётов как артефактов\n18. Практическая работа №9. Интеграция отчётов в пайплайн\n19. Запуск тестов по расписанию (cron в CI)\n20. Практическая работа №10. Ежедневная проверка стабильности API\n21. Мониторинг и алертинг по результатам тестов\n22. Практическая работа №11. Отправка уведомлений в Telegram\n23. Тестирование в микросервисной архитектуре\n24. Практическая работа №12. Мокирование зависимостей (Mock Server / WireMock / Python-моки)\n25. Нагрузочное тестирование (Locust)\n26. Практическая работа №13. Проверка устойчивости API под нагрузкой\n27. Безопасность автотестов: инъекции, утечки данных\n28. Практическая работа №14. Аудит тестовых скриптов на безопасность\n29. Создание собственного тестового фреймворка\n30. Практическая работа №15. Разработка базовой обёртки над Selenium + Pytest\n31. Интеграция с системами мониторинга (Prometheus, Grafana)\n32. Практическая работа №16. Визуализация метрик качества\n33. Интеграция компонентов автоматизированного тестирования: от тест-плана до CI/CD\n34. Практическая работа №17. Реализация сквозного тестового сценария: проектирование, автоматизация, интеграция в пайплайн\n35. Автоматизация тестирования безопасности (Security Testing)\n36. Практическая работа №18. Формирование профессионального портфолио: документация, метрики качества и рекомендации по поддержке тестов	\N	\N	\N
111	457	1	Программа курса	1. Введение в QA: роль тестировщика в SDLC\n2. Практическая работа №1. Анализ жизненного цикла ПО\n3. Виды тестирования\n4. Практическая работа №2. Классификация тест-кейсов\n5. Методы тест-дизайна\n6. Практическая работа №3. Создание тест-кейсов\n7. Документация в QA\n8. Практическая работа №4. Написание баг-репорта\n9. Работа с системами отслеживания задач (Redmine, YouGile, Taiga)\n10. Практическая работа №5. Создание задачи и трекинг статусов в Redmine\n11. Тестирование веб-интерфейсов: HTML, DOM, DevTools\n12. Практическая работа №6. Анализ элементов страницы и их атрибутов\n13. Тестирование REST API с Insomnia / Python (requests)\n14. Практическая работа №7. Отправка запросов и валидация ответов\n15. Статус-коды, заголовки, тело ответа — что проверять\n16. Практическая работа №8. Проверка корректности API по спецификации\n17. Тестирование авторизации и сессий\n18. Практическая работа №9. Проверка логина, logout и прав доступа вручную\n19. Тестирование на разных браузерах и устройствах\n20. Практическая работа №10. Кросс-браузерная проверка интерфейса\n21. Локализация и интернационализация: тестирование мультиязычности\n22. Практическая работа №11. Проверка перевода и форматов дат/чисел\n23. Метрики качества: покрытие, плотность багов, время на тестирование\n24. Практическая работа №12. Расчёт базовых QA-метрик по данным\n25. Тестирование безопасности: базовые уязвимости (XSS, CSRF)\n26. Практическая работа №13. Поиск простых уязвимостей через DevTools\n27. Тестирование производительности вручную\n28. Практическая работа №14. Замер времени загрузки и реакции интерфейса\n29. Подготовка тестового окружения\n30. Практическая работа №15. Настройка локального сервера для тестов\n31. Версионирование и управление изменениями в требованиях\n32. Практическая работа №16. Отслеживание изменений в функционале\n33. Работа в команде: взаимодействие с разработчиками и аналитиками\n34. Практическая работа №17. Ролевая игра: защита бага перед разработчиком\n35. Подведение итогов модуля: создание тест-плана\n36. Практическая работа №18. Разработка тест-плана для условного проекта	\N	\N	\N
112	458	1	Программа курса	1. Введение в QA: роль тестировщика в SDLC\n2. Практическая работа №1. Анализ жизненного цикла ПО\n3. Виды тестирования\n4. Практическая работа №2. Классификация тест-кейсов\n5. Методы тест-дизайна\n6. Практическая работа №3. Создание тест-кейсов\n7. Документация в QA\n8. Практическая работа №4. Написание баг-репорта\n9. Работа с системами отслеживания задач (Redmine, YouGile, Taiga)\n10. Практическая работа №5. Создание задачи и трекинг статусов в Redmine\n11. Тестирование веб-интерфейсов: HTML, DOM, DevTools\n12. Практическая работа №6. Анализ элементов страницы и их атрибутов\n13. Тестирование REST API с Insomnia / Python (requests)\n14. Практическая работа №7. Отправка запросов и валидация ответов\n15. Статус-коды, заголовки, тело ответа — что проверять\n16. Практическая работа №8. Проверка корректности API по спецификации\n17. Тестирование авторизации и сессий\n18. Практическая работа №9. Проверка логина, logout и прав доступа вручную\n19. Тестирование на разных браузерах и устройствах\n20. Практическая работа №10. Кросс-браузерная проверка интерфейса\n21. Локализация и интернационализация: тестирование мультиязычности\n22. Практическая работа №11. Проверка перевода и форматов дат/чисел\n23. Метрики качества: покрытие, плотность багов, время на тестирование\n24. Практическая работа №12. Расчёт базовых QA-метрик по данным\n25. Тестирование безопасности: базовые уязвимости (XSS, CSRF)\n26. Практическая работа №13. Поиск простых уязвимостей через DevTools\n27. Тестирование производительности вручную\n28. Практическая работа №14. Замер времени загрузки и реакции интерфейса\n29. Подготовка тестового окружения\n30. Практическая работа №15. Настройка локального сервера для тестов\n31. Версионирование и управление изменениями в требованиях\n32. Практическая работа №16. Отслеживание изменений в функционале\n33. Работа в команде: взаимодействие с разработчиками и аналитиками\n34. Практическая работа №17. Ролевая игра: защита бага перед разработчиком\n35. Подведение итогов модуля: создание тест-плана\n36. Практическая работа №18. Разработка тест-плана для условного проекта	\N	\N	\N
113	459	1	Программа курса	1. Введение в контейнеризацию и Docker\n2. Практическая работа №1. Установка Docker и запуск первого контейнера\n3. Управление образами и контейнерами\n4. Практическая работа №2. Работа с Docker CLI: запуск, остановка, удаление контейнеров и образов\n5. Работа с реестрами контейнеров\n6. Практическая работа №3. Публикация образа в GitHub Container Registry\n7. Сетевое взаимодействие контейнеров\n8. Практическая работа №4. Создание пользовательской сети и настройка связи между контейнерами\n9. Основы создания образов с Dockerfile\n10. Практическая работа №5. Написание Dockerfile для Python-веб-приложения\n11. Переменные окружения и конфигурация контейнеров\n12. Практическая работа №6. Передача конфигурации через .env и –env в Docker\n13. Оптимизация Docker-образов\n14. Практическая работа №7. Использование multi-stage сборки для уменьшения размера образа\n15. Работа с Docker Logs и отладка контейнеров\n16. Практическая работа №8. Анализ логов контейнеров и отладка с использованием docker logs и exec\n17. Введение в Docker Compose\n18. Практическая работа №9. Запуск нескольких сервисов с помощью docker-compose.yml\n19. Связь контейнеров в Docker Compose\n20. Практическая работа №10. Развертывание связки: Flask-приложение + PostgreSQL\n21. Масштабирование контейнеров в Docker Compose\n22. Практическая работа №11. Масштабирование веб-сервиса с помощью docker-compose scale\n23. Автоматизация развертывания с Docker Compose\n24. Практическая работа №12. Развёртывание стека на виртуальной машине в облаке\n25. Основные концепции Kubernetes\n26. Практическая работа №13. Установка Minikube и запуск первого Pod\n27. Управление подами (Pods) в Kubernetes\n28. Практическая работа №14. Развёртывание Python-контейнера в Pod через kubectl\n29. Деплойменты и обновления в Kubernetes\n30. Практическая работа №15. Развёртывание приложения через Deployment и обновление версии\n31. Конфигурации и секреты в Kubernetes\n32. Практическая работа №16. Использование ConfigMap и Secret для передачи конфигурации\n33. Балансировка нагрузки в Kubernetes\n34. Практическая работа №17. Настройка Service типа LoadBalancer (или NodePort для локального кластера)\n35. Масштабирование приложений в Kubernetes\n36. Практическая работа №18. Настройка Horizontal Pod Autoscaler (HPA) на основе CPU	\N	\N	\N
114	460	1	Программа курса	1. Введение в контейнеризацию и Docker\n2. Практическая работа №1. Установка Docker и запуск первого контейнера\n3. Управление образами и контейнерами\n4. Практическая работа №2. Работа с Docker CLI: запуск, остановка, удаление контейнеров и образов\n5. Работа с реестрами контейнеров\n6. Практическая работа №3. Публикация образа в GitHub Container Registry\n7. Сетевое взаимодействие контейнеров\n8. Практическая работа №4. Создание пользовательской сети и настройка связи между контейнерами\n9. Основы создания образов с Dockerfile\n10. Практическая работа №5. Написание Dockerfile для Python-веб-приложения\n11. Переменные окружения и конфигурация контейнеров\n12. Практическая работа №6. Передача конфигурации через .env и –env в Docker\n13. Оптимизация Docker-образов\n14. Практическая работа №7. Использование multi-stage сборки для уменьшения размера образа\n15. Работа с Docker Logs и отладка контейнеров\n16. Практическая работа №8. Анализ логов контейнеров и отладка с использованием docker logs и exec\n17. Введение в Docker Compose\n18. Практическая работа №9. Запуск нескольких сервисов с помощью docker-compose.yml\n19. Связь контейнеров в Docker Compose\n20. Практическая работа №10. Развертывание связки: Flask-приложение + PostgreSQL\n21. Масштабирование контейнеров в Docker Compose\n22. Практическая работа №11. Масштабирование веб-сервиса с помощью docker-compose scale\n23. Автоматизация развертывания с Docker Compose\n24. Практическая работа №12. Развёртывание стека на виртуальной машине в облаке\n25. Основные концепции Kubernetes\n26. Практическая работа №13. Установка Minikube и запуск первого Pod\n27. Управление подами (Pods) в Kubernetes\n28. Практическая работа №14. Развёртывание Python-контейнера в Pod через kubectl\n29. Деплойменты и обновления в Kubernetes\n30. Практическая работа №15. Развёртывание приложения через Deployment и обновление версии\n31. Конфигурации и секреты в Kubernetes\n32. Практическая работа №16. Использование ConfigMap и Secret для передачи конфигурации\n33. Балансировка нагрузки в Kubernetes\n34. Практическая работа №17. Настройка Service типа LoadBalancer (или NodePort для локального кластера)\n35. Масштабирование приложений в Kubernetes\n36. Практическая работа №18. Настройка Horizontal Pod Autoscaler (HPA) на основе CPU	\N	\N	\N
115	461	1	Программа курса	1. Введение в DevOps и автоматизацию инфраструктуры\n2. Практическая работа №1. Установка и настройка локального DevOps-окружения (Python, Git, SSH)\n3. Работа с серверами через SSH и Python\n4. Практическая работа №2. Написание Python-скрипта для удалённого выполнения команд по SSH\n5. Основы работы с Linux и автоматизация задач\n6. Практическая работа №3. Автоматизация резервного копирования с использованием Python и cron\n7. Управление пользователями и правами доступа\n8. Практическая работа №4. Автоматизация управления пользователями на сервере\n9. Введение в Ansible: автоматизация серверных конфигураций\n10. Практическая работа №5. Создание Ansible-плейбука для настройки Python-окружения\n11. Использование Python в Ansible\n12. Практическая работа №6. Разработка кастомного модуля Ansible на Python\n13. Автоматизация инфраструктуры с Terraform\n14. Практическая работа №7. Написание Terraform-конфигурации для развертывания виртуальной машины\n15. Python-скрипты для управления облачной инфраструктурой\n16. Практическая работа №8. Управление облачными ресурсами через Python (с использованием Yandex.Cloud SDK)\n17. Основы мониторинга и логирования в DevOps\n18. Практическая работа №9. Настройка Prometheus для сбора системных метрик\n19. Сбор метрик с помощью Prometheus\n20. Практическая работа №10. Разработка Python-экспортера метрик для Prometheus\n21. Визуализация метрик в Grafana\n22. Практическая работа №11. Настройка дашборда Grafana для отображения метрик\n23. Логирование и анализ данных с ELK Stack\n24. Практическая работа №12. Настройка централизованного логирования с Filebeat + Elasticsearch + Kibana\n25. Автоматизация работы с логами\n26. Практическая работа №13. Скрипт на Python для парсинга и отправки логов в централизованное хранилище\n27. Настройка алертинга в DevOps\n28. Практическая работа №14. Интеграция уведомлений в Telegram при сбое сервиса\n29. Сбор и анализ системных логов\n30. Практическая работа №15. Автоматизированный анализ логов systemd через Python\n31. Основы CI/CD и автоматизированного развертывания\n32. Практическая работа №16. Настройка пайплайна в GitLab CI для Python-приложения\n33. Интеграция Python-скриптов в CI/CD\n34. Практическая работа №17. Запуск автоматизированных тестов и деплоя через GitLab CI\n35. Kubernetes и оркестрация контейнеров\n36. Практическая работа №18. Деплой Python-приложения в локальный Kubernetes-кластер (Minikube)	\N	\N	\N
116	462	1	Программа курса	1. Введение в DevOps и автоматизацию инфраструктуры\n2. Практическая работа №1. Установка и настройка локального DevOps-окружения (Python, Git, SSH)\n3. Работа с серверами через SSH и Python\n4. Практическая работа №2. Написание Python-скрипта для удалённого выполнения команд по SSH\n5. Основы работы с Linux и автоматизация задач\n6. Практическая работа №3. Автоматизация резервного копирования с использованием Python и cron\n7. Управление пользователями и правами доступа\n8. Практическая работа №4. Автоматизация управления пользователями на сервере\n9. Введение в Ansible: автоматизация серверных конфигураций\n10. Практическая работа №5. Создание Ansible-плейбука для настройки Python-окружения\n11. Использование Python в Ansible\n12. Практическая работа №6. Разработка кастомного модуля Ansible на Python\n13. Автоматизация инфраструктуры с Terraform\n14. Практическая работа №7. Написание Terraform-конфигурации для развертывания виртуальной машины\n15. Python-скрипты для управления облачной инфраструктурой\n16. Практическая работа №8. Управление облачными ресурсами через Python (с использованием Yandex.Cloud SDK)\n17. Основы мониторинга и логирования в DevOps\n18. Практическая работа №9. Настройка Prometheus для сбора системных метрик\n19. Сбор метрик с помощью Prometheus\n20. Практическая работа №10. Разработка Python-экспортера метрик для Prometheus\n21. Визуализация метрик в Grafana\n22. Практическая работа №11. Настройка дашборда Grafana для отображения метрик\n23. Логирование и анализ данных с ELK Stack\n24. Практическая работа №12. Настройка централизованного логирования с Filebeat + Elasticsearch + Kibana\n25. Автоматизация работы с логами\n26. Практическая работа №13. Скрипт на Python для парсинга и отправки логов в централизованное хранилище\n27. Настройка алертинга в DevOps\n28. Практическая работа №14. Интеграция уведомлений в Telegram при сбое сервиса\n29. Сбор и анализ системных логов\n30. Практическая работа №15. Автоматизированный анализ логов systemd через Python\n31. Основы CI/CD и автоматизированного развертывания\n32. Практическая работа №16. Настройка пайплайна в GitLab CI для Python-приложения\n33. Интеграция Python-скриптов в CI/CD\n34. Практическая работа №17. Запуск автоматизированных тестов и деплоя через GitLab CI\n35. Kubernetes и оркестрация контейнеров\n36. Практическая работа №18. Деплой Python-приложения в локальный Kubernetes-кластер (Minikube)	\N	\N	\N
117	463	1	Программа курса	1. Принципы эффективной визуализации данных\n2. Практическая работа №1. Создание первого графика с Matplotlib\n3. Настройка стиля и оформления графиков\n4. Практическая работа №2. Кастомизация цветов, меток и легенд\n5. Линейные графики и аннотации\n6. Практическая работа №3. Визуализация динамики показателей во времени\n7. Гистограммы и столбчатые диаграммы\n8. Практическая работа №4. Анализ распределений и категориальных данных\n9. Круговые диаграммы и тепловые карты\n10. Практическая работа №5. Визуализация пропорций и матриц корреляции\n11. Визуализация временных рядов: тренды и волатильность\n12. Практическая работа №6. Построение графиков с подвижным средним\n13. Использование Seaborn для статистической визуализации\n14. Практическая работа №7. Построение графиков с автоматической стилизацией\n15. Сравнение нескольких временных рядов\n16. Практическая работа №8. Наложение и синхронизация нескольких временных рядов\n17. Введение в Plotly: интерактивные графики\n18. Практическая работа №9. Создание интерактивного линейного графика в Jupyter\n19. Элементы управления в интерактивных графиках\n20. Практическая работа №10. Добавление слайдеров и выпадающих меню в Plotly\n21. Визуализация временных рядов с анимацией\n22. Практическая работа №11. Анимированные временные ряды в Plotly\n23. Интерактивные тепловые карты и картограммы\n24. Практическая работа №12. Построение интерактивной карты с геоданными\n25. Диаграммы рассеяния и регрессионные линии\n26. Практическая работа №13. Визуализация зависимостей между переменными\n27. Ящиковые и скрипичные диаграммы\n28. Практическая работа №14. Сравнение распределений по группам\n29. Корреляционные матрицы и heatmap\n30. Практическая работа №15. Визуализация взаимосвязей признаков\n31. Отчёты в Jupyter Notebook\n32. Практическая работа №16. Оформление аналитического отчёта в Jupyter\n33. Публикация отчётов: HTML и PDF\n34. Практическая работа №17. Экспорт Jupyter Notebook в статический отчёт\n35. Разработка веб-интерфейса с Streamlit\n36. Практическая работа №18. Создание интерактивного дашборда для анализа данных	\N	\N	\N
118	464	1	Программа курса	1. Принципы эффективной визуализации данных\n2. Практическая работа №1. Создание первого графика с Matplotlib\n3. Настройка стиля и оформления графиков\n4. Практическая работа №2. Кастомизация цветов, меток и легенд\n5. Линейные графики и аннотации\n6. Практическая работа №3. Визуализация динамики показателей во времени\n7. Гистограммы и столбчатые диаграммы\n8. Практическая работа №4. Анализ распределений и категориальных данных\n9. Круговые диаграммы и тепловые карты\n10. Практическая работа №5. Визуализация пропорций и матриц корреляции\n11. Визуализация временных рядов: тренды и волатильность\n12. Практическая работа №6. Построение графиков с подвижным средним\n13. Использование Seaborn для статистической визуализации\n14. Практическая работа №7. Построение графиков с автоматической стилизацией\n15. Сравнение нескольких временных рядов\n16. Практическая работа №8. Наложение и синхронизация нескольких временных рядов\n17. Введение в Plotly: интерактивные графики\n18. Практическая работа №9. Создание интерактивного линейного графика в Jupyter\n19. Элементы управления в интерактивных графиках\n20. Практическая работа №11. Анимированные временные ряды в Plotly\n21. Интерактивные тепловые карты и картограммы\n22. Практическая работа №10. Добавление слайдеров и выпадающих меню в Plotly\n23. Визуализация временных рядов с анимацией\n24. Практическая работа №12. Построение интерактивной карты с геоданными\n25. Диаграммы рассеяния и регрессионные линии\n26. Практическая работа №13. Визуализация зависимостей между переменными\n27. Ящиковые и скрипичные диаграммы\n28. Практическая работа №14. Сравнение распределений по группам\n29. Корреляционные матрицы и heatmap\n30. Практическая работа №15. Визуализация взаимосвязей признаков\n31. Отчёты в Jupyter Notebook\n32. Практическая работа №16. Оформление аналитического отчёта в Jupyter\n33. Публикация отчётов: HTML и PDF\n34. Практическая работа №17. Экспорт Jupyter Notebook в статический отчёт\n35. Разработка веб-интерфейса с Streamlit\n36. Практическая работа №18. Создание интерактивного дашборда для анализа данных	\N	\N	\N
119	465	1	Программа курса	1. Введение в машинное обучение: типы задач и цикл ML\n2. Практическая работа №1. Загрузка датасета и первичный анализ\n3. Обзор ключевых библиотек: Scikit-learn, joblib\n4. Практическая работа №2. Исследовательский анализ данных (EDA) с Pandas и Seaborn\n5. Разделение данных: train/test и stratification\n6. Практическая работа №3. Разделение набора данных на выборки\n7. Обработка пропущенных значений в ML-контексте\n8. Практическая работа №4. Импутация пропущенных данных\n9. Кодирование признаков для моделей\n10. Практическая работа №5. Подготовка категориальных данных для обучения\n11. Масштабирование признаков: StandardScaler, MinMaxScaler\n12. Практическая работа №6. Применение скалеров к данным\n13. Отбор признаков: методы фильтрации и обертки\n14. Практическая работа №7. Отбор признаков с SelectKBest\n15. Логистическая регрессия: теория и применение\n16. Практическая работа №8. Обучение классификатора на реальных данных\n17. Деревья решений: принцип работы и настройка\n18. Практическая работа №9. Построение и визуализация дерева\n19. Ансамбли: Random Forest\n20. Практическая работа №10. Обучение и оценка Random Forest\n21. Введение в регрессионные задачи\n22. Практическая работа №11. Линейная и полиномиальная регрессия\n23. Кластеризация: K-Means\n24. Практическая работа №12. Группировка данных без учителя\n25. Альтернативные методы кластеризации: Agglomerative, DBSCAN\n26. Практическая работа №13. Сравнение алгоритмов кластеризации\n27. Снижение размерности: PCA\n28. Практическая работа №14. Применение PCA для визуализации и сжатия\n29. Оценка качества классификации: accuracy, precision, recall, F1\n30. Практическая работа №15. Построение confusion matrix и ROC-кривой\n31. Кросс-валидация и устойчивость моделей\n32. Практическая работа №16. Кросс-валидация с cross_val_score\n33. Балансировка классов: SMOTE и взвешивание\n34. Практическая работа №17. Работа с несбалансированными данными\n35. Подбор гиперпараметров: GridSearch и RandomizedSearch\n36. Практическая работа №18. Оптимизация модели через поиск параметров	\N	\N	\N
120	466	1	Программа курса	1. Введение в машинное обучение: типы задач и цикл ML\n2. Практическая работа №1. Загрузка датасета и первичный анализ\n3. Обзор ключевых библиотек: Scikit-learn, joblib\n4. Практическая работа №2. Исследовательский анализ данных (EDA) с Pandas и Seaborn\n5. Разделение данных: train/test и stratification\n6. Практическая работа №3. Разделение набора данных на выборки\n7. Обработка пропущенных значений в ML-контексте\n8. Практическая работа №4. Импутация пропущенных данных\n9. Кодирование признаков для моделей\n10. Практическая работа №5. Подготовка категориальных данных для обучения\n11. Масштабирование признаков: StandardScaler, MinMaxScaler\n12. Практическая работа №6. Применение скалеров к данным\n13. Отбор признаков: методы фильтрации и обертки\n14. Практическая работа №7. Отбор признаков с SelectKBest\n15. Логистическая регрессия: теория и применение\n16. Практическая работа №8. Обучение классификатора на реальных данных\n17. Деревья решений: принцип работы и настройка\n18. Практическая работа №9. Построение и визуализация дерева\n19. Ансамбли: Random Forest\n20. Практическая работа №10. Обучение и оценка Random Forest\n21. Введение в регрессионные задачи\n22. Практическая работа №11. Линейная и полиномиальная регрессия\n23. Кластеризация: K-Means\n24. Практическая работа №12. Группировка данных без учителя\n25. Альтернативные методы кластеризации: Agglomerative, DBSCAN\n26. Практическая работа №13. Сравнение алгоритмов кластеризации\n27. Снижение размерности: PCA\n28. Практическая работа №14. Применение PCA для визуализации и сжатия\n29. Оценка качества классификации: accuracy, precision, recall, F1\n30. Практическая работа №15. Построение confusion matrix и ROC-кривой\n31. Кросс-валидация и устойчивость моделей\n32. Практическая работа №16. Кросс-валидация с cross_val_score\n33. Балансировка классов: SMOTE и взвешивание\n34. Практическая работа №17. Работа с несбалансированными данными\n35. Подбор гиперпараметров: GridSearch и RandomizedSearch\n36. Практическая работа №18. Оптимизация модели через поиск параметров	\N	\N	\N
121	467	1	Программа курса	1. Введение в анализ данных и инструменты\n2. Практическая работа №1. Установка Pandas и NumPy, создание первых объектов.\n3. Основы работы с NumPy\n4. Практическая работа №2. Операции с массивами NumPy.\n5. Основы работы с Pandas\n6. Практическая работа №3. Создание и модификация DataFrame.\n7. Чтение и запись CSV-файлов\n8. Практическая работа №4. Чтение и запись данных в CSV.\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка Excel-файлов в Pandas.\n11. Подключение к базам данных (SQLAlchemy)\n12. Практическая работа №6. Подключение к базе и выполнение SQL-запросов в Pandas.\n13. Фильтрация данных в Pandas\n14. Практическая работа №7. Фильтрация данных в DataFrame.\n15. Группировка данных и агрегация\n16. Практическая работа №8. Группировка и агрегация данных.\n17. Сводные таблицы (Pivot Table)\n18. Практическая работа №9. Создание сводной таблицы для анализа данных.\n19. Объединение и слияние данных\n20. Практическая работа №10. Слияние и объединение нескольких таблиц.\n21. Работа с временными рядами\n22. Практическая работа №11. Работа с датами и временными рядами.\n23. Декомпозиция временных рядов\n24. Практическая работа №12. Анализ трендов временного ряда.\n25. Визуализация данных\n26. Практическая работа №13. Визуализация данных с Matplotlib и Seaborn.\n27. Обнаружение и обработка пропущенных данных\n28. Практическая работа №14. Обработка пропущенных данных в DataFrame.\n29. Работа с выбросами и аномалиями\n30. Практическая работа №15. Поиск и устранение выбросов в данных.\n31. Кодирование категориальных переменных\n32. Практическая работа №16. Кодирование категориальных данных.\n33. Нормализация и стандартизация данных\n34. Практическая работа №17. Нормализация данных для анализа.\n35. Оптимизация работы с большими таблицами\n36. Практическая работа №18. Оптимизация работы с большими наборами данных.	\N	\N	\N
122	468	1	Программа курса	1. Введение в анализ данных и инструменты\n2. Практическая работа №1. Установка Pandas и NumPy, создание первых объектов.\n3. Основы работы с NumPy\n4. Практическая работа №2. Операции с массивами NumPy.\n5. Основы работы с Pandas\n6. Практическая работа №3. Создание и модификация DataFrame.\n7. Чтение и запись CSV-файлов\n8. Практическая работа №4. Чтение и запись данных в CSV.\n9. Работа с Excel-файлами\n10. Практическая работа №5. Обработка Excel-файлов в Pandas.\n11. Подключение к базам данных (SQLAlchemy)\n12. Практическая работа №6. Подключение к базе и выполнение SQL-запросов в Pandas.\n13. Фильтрация данных в Pandas\n14. Практическая работа №7. Фильтрация данных в DataFrame.\n15. Группировка данных и агрегация\n16. Практическая работа №8. Группировка и агрегация данных.\n17. Сводные таблицы (Pivot Table)\n18. Практическая работа №9. Создание сводной таблицы для анализа данных.\n19. Объединение и слияние данных\n20. Практическая работа №10. Слияние и объединение нескольких таблиц.\n21. Работа с временными рядами\n22. Практическая работа №11. Работа с датами и временными рядами.\n23. Декомпозиция временных рядов\n24. Практическая работа №12. Анализ трендов временного ряда.\n25. Визуализация данных\n26. Практическая работа №13. Визуализация данных с Matplotlib и Seaborn.\n27. Обнаружение и обработка пропущенных данных\n28. Практическая работа №14. Обработка пропущенных данных в DataFrame.\n29. Работа с выбросами и аномалиями\n30. Практическая работа №15. Поиск и устранение выбросов в данных.\n31. Кодирование категориальных переменных\n32. Практическая работа №16. Кодирование категориальных данных.\n33. Нормализация и стандартизация данных\n34. Практическая работа №17. Нормализация данных для анализа.\n35. Оптимизация работы с большими таблицами\n36. Практическая работа №18. Оптимизация работы с большими наборами данных.	\N	\N	\N
123	469	1	Программа курса	1. Основы автоматизированного развертывания веб-приложений\n2. Практическая работа №1. Настройка базового сценария развертывания Django-приложения\n3. Контейнеризация Django-приложений с Docker\n4. Практическая работа №2. Запуск Django-приложения в контейнере с Docker\n5. Развертывание Django-приложения на удаленном сервере\n6. Практическая работа №3. Развертывание Django-приложения с использованием Ansible\n7. Управление миграциями и статиками в Django\n8. Практическая работа №4. Автоматизация управления миграциями и статическими файлами\n9. Основы фоновых процессов и отложенных задач\n10. Практическая работа №5. Запуск фоновой задачи в Django с Celery\n11. Настройка CRON-задач для Django-приложений\n12. Практическая работа №6. Настройка периодических задач в Django с Celery и BackgroundScheduler\n13. Очереди задач и брокеры сообщений\n14. Практическая работа №7. Организация асинхронной обработки запросов с Celery и Redis\n15. Оптимизация фоновых задач и их мониторинг\n16. Практическая работа №8. Настройка мониторинга Celery\n17. Работа с REST API в Django\n18. Практическая работа №9. Интеграция Django-приложения с внешним API\n19. Работа с веб-хуками\n20. Практическая работа №10. Создание веб-хука для данных\n21. Автоматизированный обмен данными\n22. Практическая работа №11. Система автоматического сбора данных\n23. Введение в CI/CD\n24. Практическая работа №12. Создание базового CI/CD пайплайна\n25. Автоматизация тестирования в CI/CD\n26. Практическая работа №13. Интеграция тестов в CI/CD\n27. Автоматизация деплоя в облаке\n28. Практическая работа №14. Развёртывание с CI/CD\n29. Мониторинг и логирование\n30. Практическая работа №15. Настройка логирования и мониторинга\n31. Нагрузочное тестирование\n32. Практическая работа №16. Проведение нагрузочного тестирования\n33. Оптимизация производительности\n34. Практическая работа №17. Оптимизация веб-приложения\n35. Безопасность веб-приложений\n36. Практическая работа №18. Настройка защиты от атак	\N	\N	\N
124	470	1	Программа курса	1. Основы автоматизированного развертывания веб-приложений\n2. Практическая работа №1. Настройка базового сценария развертывания Django-приложения\n3. Контейнеризация Django-приложений с Docker\n4. Практическая работа №2. Запуск Django-приложения в контейнере с Docker\n5. Развертывание Django-приложения на удаленном сервере\n6. Практическая работа №3. Развертывание Django-приложения с использованием Ansible\n7. Управление миграциями и статиками в Django\n8. Практическая работа №4. Автоматизация управления миграциями и статическими файлами\n9. Основы фоновых процессов и отложенных задач\n10. Практическая работа №5. Запуск фоновой задачи в Django с Celery\n11. Настройка CRON-задач для Django-приложений\n12. Практическая работа №6. Настройка периодических задач в Django с Celery и BackgroundScheduler\n13. Очереди задач и брокеры сообщений\n14. Практическая работа №7. Организация асинхронной обработки запросов с Celery и Redis\n15. Оптимизация фоновых задач и их мониторинг\n16. Практическая работа №8. Настройка мониторинга Celery\n17. Работа с REST API в Django\n18. Практическая работа №9. Интеграция Django-приложения с внешним API\n19. Работа с веб-хуками\n20. Практическая работа №10. Создание веб-хука для данных\n21. Автоматизированный обмен данными\n22. Практическая работа №11. Система автоматического сбора данных\n23. Введение в CI/CD\n24. Практическая работа №12. Создание базового CI/CD пайплайна\n25. Автоматизация тестирования в CI/CD\n26. Практическая работа №13. Интеграция тестов в CI/CD\n27. Автоматизация деплоя в облаке\n28. Практическая работа №14. Развёртывание с CI/CD\n29. Мониторинг и логирование\n30. Практическая работа №15. Настройка логирования и мониторинга\n31. Нагрузочное тестирование\n32. Практическая работа №16. Проведение нагрузочного тестирования\n33. Оптимизация производительности\n34. Практическая работа №17. Оптимизация веб-приложения\n35. Безопасность веб-приложений\n36. Практическая работа №18. Настройка защиты от атак	\N	\N	\N
125	471	1	Программа курса	1. Введение в базы данных и SQL\n2. Практическая работа №1. Создание и наполнение базы данных SQL\n3. Операции с данными в SQL\n4. Практическая работа №2. Запросы и работа с данными в SQL\n5. Взаимосвязи между таблицами\n6. Практическая работа №3. Работа с несколькими таблицами и JOIN\n7. Работа с SQLite в Python\n8. Практическая работа №4. Создание и управление базой данных в SQLite\n9. Работа с PostgreSQL в Python\n10. Практическая работа №5. Подключение Python-программы к PostgreSQL\n11. Введение в ORM и SQLAlchemy\n12. Практическая работа №6. Создание моделей в SQLAlchemy\n13. CRUD-операции в SQLAlchemy\n14. Практическая работа №7. CRUD-операции в SQLAlchemy\n15. Django ORM: работа с базами данных\n16. Практическая работа №8. Создание моделей и миграций в Django ORM\n17. Индексы в базах данных\n18. Практическая работа №9. Оптимизация работы ORM\n19. Оптимизация запросов в ORM\n20. Практическая работа №10. Добавление индексов в БД\n21. Оптимизация SQL-запросов\n22. Практическая работа №11. Анализ и оптимизация SQL-запросов\n23. Введение в NoSQL и MongoDB\n24. Практическая работа №12. Работа с MongoDB через pymongo\n25. Запросы и агрегации в MongoDB\n26. Практическая работа №13. Агрегация данных в MongoDB\n27. Использование Redis в Python\n28. Практическая работа №14. Настройка Redis и кеширование\n29. Создание резервных копий БД\n30. Практическая работа №15. Создание резервной копии PostgreSQL\n31. Восстановление данных из бэкапа\n32. Практическая работа №16. Восстановление данных из резервной копии\n33. Автоматизация резервного копирования\n34. Практическая работа №17. Автоматизация создания бэкапов\n35. Транзакции и ACID\n36. Практическая работа №18. Работа с транзакциями	\N	\N	\N
126	472	1	Программа курса	1. Введение в базы данных и SQL\n2. Практическая работа №1. Создание и наполнение базы данных SQL\n3. Операции с данными в SQL\n4. Практическая работа №2. Запросы и работа с данными в SQL\n5. Взаимосвязи между таблицами\n6. Практическая работа №3. Работа с несколькими таблицами и JOIN\n7. Работа с SQLite в Python\n8. Практическая работа №4. Создание и управление базой данных в SQLite\n9. Работа с PostgreSQL в Python\n10. Практическая работа №5. Подключение Python-программы к PostgreSQL\n11. Введение в ORM и SQLAlchemy\n12. Практическая работа №6. Создание моделей в SQLAlchemy\n13. CRUD-операции в SQLAlchemy\n14. Практическая работа №7. CRUD-операции в SQLAlchemy\n15. Django ORM: работа с базами данных\n16. Практическая работа №8. Создание моделей и миграций в Django ORM\n17. Индексы в базах данных\n18. Практическая работа №9. Оптимизация работы ORM\n19. Оптимизация запросов в ORM\n20. Практическая работа №10. Добавление индексов в БД\n21. Оптимизация SQL-запросов\n22. Практическая работа №11. Анализ и оптимизация SQL-запросов\n23. Введение в NoSQL и MongoDB\n24. Практическая работа №12. Работа с MongoDB через pymongo\n25. Запросы и агрегации в MongoDB\n26. Практическая работа №13. Агрегация данных в MongoDB\n27. Использование Redis в Python\n28. Практическая работа №14. Настройка Redis и кеширование\n29. Создание резервных копий БД\n30. Практическая работа №15. Создание резервной копии PostgreSQL\n31. Восстановление данных из бэкапа\n32. Практическая работа №16. Восстановление данных из резервной копии\n33. Автоматизация резервного копирования\n34. Практическая работа №17. Автоматизация создания бэкапов\n35. Транзакции и ACID\n36. Практическая работа №18. Работа с транзакциями	\N	\N	\N
127	473	1	Программа курса	1. Основы Django: структура проекта\n2. Практическая работа №1. Установка Django и запуск первого проекта\n3. Работа с Django-приложениями и маршрутизация\n4. Практическая работа №2. Создание Django-приложения и настройка маршрутов\n5. Представления (Views) и шаблоны (Templates)\n6. Практическая работа №3. Разработка системы шаблонов и отображение данных\n7. Работа со статическими файлами\n8. Практическая работа №4. Добавление стилей и изображений в Django приложение\n9. Основы Django ORM: модели данных\n10. Практическая работа №5. Создание моделей и выполнение миграций\n11. Запросы к базе данных через ORM\n12. Практическая работа №6. Работа с базой данных через ORM\n13. Отношения между моделями\n14. Практическая работа №7. Создание связанных моделей и работа с ними\n15. Админ-панель Django\n16. Практическая работа №8. Настройка админ-панели и управление пользователями\n17. Основы Django Forms\n18. Практическая работа №9. Создание формы для ввода данных\n19. Работа с запросами (GET, POST)\n20. Практическая работа №10. Создание формы обратной связи с обработкой данных\n21. Работа с пользователями в Django\n22. Практическая работа №11. Реализация системы регистрации и входа\n23. Работа с правами доступа\n24. Практическая работа №12. Настройка ролевой системы доступа\n25. Введение в Django REST Framework\n26. Практическая работа №13. Создание REST API с Django REST Framework\n27. Работа с сериализаторами (Serializers)\n28. Практическая работа №14. Реализация API для работы с моделями\n29. Авторизация и аутентификация в API\n30. Практическая работа №15. Настройка аутентификации в API\n31. Развёртывание Django-приложения на сервере\n32. Практическая работа №16. Развёртывание Django-приложения на удалённом сервере\n33. Контейнеризация Django-приложения (Docker)\n34. Практическая работа №17. Запуск Django-приложения в Docker-контейнере\n35. Основы кеширования в Django\n36. Практическая работа №18. Настройка кеширования	\N	\N	\N
128	474	1	Программа курса	1. Основы Django: структура проекта\n2. Практическая работа №1. Установка Django и запуск первого проекта\n3. Работа с Django-приложениями и маршрутизация\n4. Практическая работа №2. Создание Django-приложения и настройка маршрутов\n5. Представления (Views) и шаблоны (Templates)\n6. Практическая работа №3. Разработка системы шаблонов и отображение данных\n7. Работа со статическими файлами\n8. Практическая работа №4. Добавление стилей и изображений в Django приложение\n9. Основы Django ORM: модели данных\n10. Практическая работа №5. Создание моделей и выполнение миграций\n11. Запросы к базе данных через ORM\n12. Практическая работа №6. Работа с базой данных через ORM\n13. Отношения между моделями\n14. Практическая работа №7. Создание связанных моделей и работа с ними\n15. Админ-панель Django\n16. Практическая работа №8. Настройка админ-панели и управление пользователями\n17. Основы Django Forms\n18. Практическая работа №9. Создание формы для ввода данных\n19. Работа с запросами (GET, POST)\n20. Практическая работа №10. Создание формы обратной связи с обработкой данных\n21. Работа с пользователями в Django\n22. Практическая работа №11. Реализация системы регистрации и входа\n23. Работа с правами доступа\n24. Практическая работа №12. Настройка ролевой системы доступа\n25. Введение в Django REST Framework\n26. Практическая работа №13. Создание REST API с Django REST Framework\n27. Работа с сериализаторами (Serializers)\n28. Практическая работа №14. Реализация API для работы с моделями\n29. Авторизация и аутентификация в API\n30. Практическая работа №15. Настройка аутентификации в API\n31. Развёртывание Django-приложения на сервере\n32. Практическая работа №16. Развёртывание Django-приложения на удалённом сервере\n33. Контейнеризация Django-приложения (Docker)\n34. Контейнеризация Django-приложения (Docker)\n35. Практическая работа №17. Запуск Django-приложения в Docker-контейнере\n36. Основы кеширования в Django\n37. Практическая работа №18. Настройка кеширования	\N	\N	\N
129	475	1	Программа курса	1. Инструменты автоматизации процессов разработки\n2. Практическая работа №1. Написание простого скрипта автоматизации с Invoke\n3. Управление зависимостями и виртуальными окружениями\n4. Практическая работа №2. Автоматическое управление зависимостями в проекте\n5. Автоматизация тестирования кода\n6. Практическая работа №3. Написание тестов и их автоматический запуск\n7. Сборка и упаковка Python-проектов\n8. Практическая работа №4. Упаковка Python-приложения в исполняемый файл\n9. Работа с внешними API и requests\n10. Практическая работа №5. Запрос данных с внешнего API\n11. Аутентификация при работе с API\n12. Практическая работа №6. Аутентификация через API и работа с защищёнными ресурсами\n13. Автоматизация обработки данных с API\n14. Практическая работа №7. Асинхронные запросы и кеширование API-ответов\n15. Интеграция Python-скриптов с облачными сервисами\n16. Практическая работа №8. Автоматизация загрузки и обработки данных с Google Sheets\n17. Основы разработки CLI-приложений\n18. Практическая работа №9. Написание базового CLI-инструмента\n19. Улучшение CLI-приложений\n20. Практическая работа №10. Разработка продвинутого CLI-приложения с логированием\n21. Основы парсинга веб-страниц\n22. Практическая работа №11. Парсинг веб-страницы и извлечение данных\n23. Парсинг динамических сайтов\n24. Практическая работа №12. Использование Selenium для получения данных с динамических страниц\n25. Автоматизированная работа с файлами и директориями\n26. Практическая работа №13. Написание скрипта для организации файлов в папках\n27. Автоматизированная обработка данных\n28. Практическая работа №14. Обработка и анализ данных из CSV и Excel\n29. Основы CI/CD и автоматизация развёртывания\n30. Практическая работа №15. Создание простого CI/CD пайплайна\n31. Docker и контейнеризация Python-приложений\n32. Практическая работа №16. Контейнеризация Flask-приложения с Docker\n33. Настройка автоматических тестов в CI/CD\n34. Практическая работа №17. Автоматизация тестирования в CI/CD пайплайне\n35. Автоматизация развёртывания приложений\n36. Практическая работа №18. Автоматизация развёртывания приложения	\N	\N	\N
130	476	1	Программа курса	1. Инструменты автоматизации процессов разработки\n2. Практическая работа №1. Написание простого скрипта автоматизации с Invoke\n3. Управление зависимостями и виртуальными окружениями\n4. Практическая работа №2. Автоматическое управление зависимостями в проекте\n5. Автоматизация тестирования кода\n6. Практическая работа №3. Написание тестов и их автоматический запуск\n7. Сборка и упаковка Python-проектов\n8. Практическая работа №4. Упаковка Python-приложения в исполняемый файл\n9. Работа с внешними API и requests\n10. Практическая работа №5. Запрос данных с внешнего API\n11. Аутентификация при работе с API\n12. Практическая работа №6. Аутентификация через API и работа с защищёнными ресурсами\n13. Автоматизация обработки данных с API\n14. Практическая работа №7. Асинхронные запросы и кеширование API-ответов\n15. Интеграция Python-скриптов с облачными сервисами\n16. Практическая работа №8. Автоматизация загрузки и обработки данных с Google Sheets\n17. Основы разработки CLI-приложений\n18. Практическая работа №9. Написание базового CLI-инструмента\n19. Улучшение CLI-приложений\n20. Практическая работа №10. Разработка продвинутого CLI-приложения с логированием\n21. Основы парсинга веб-страниц\n22. Практическая работа №11. Парсинг веб-страницы и извлечение данных\n23. Парсинг динамических сайтов\n24. Практическая работа №12. Использование Selenium для получения данных с динамических страниц\n25. Автоматизированная работа с файлами и директориями\n26. Практическая работа №13. Написание скрипта для организации файлов в папках\n27. Автоматизированная обработка данных\n28. Практическая работа №14. Обработка и анализ данных из CSV и Excel\n29. Основы CI/CD и автоматизация развёртывания\n30. Практическая работа №15. Создание простого CI/CD пайплайна\n31. Docker и контейнеризация Python-приложений\n32. Практическая работа №16. Контейнеризация Flask-приложения с Docker\n33. Настройка автоматических тестов в CI/CD\n34. Практическая работа №17. Автоматизация тестирования в CI/CD пайплайне\n35. Автоматизация развёртывания приложений\n36. Практическая работа №18. Автоматизация развёртывания приложения	\N	\N	\N
131	477	1	Программа курса	1. Введение в Flask и создание первого веб-приложения\n2. Практическая работа №1. Установка Flask и создание первого маршрута\n3. Маршруты и обработка запросов\n4. Практическая работа №2. Обработка маршрутов и параметров в Flask\n5. Шаблоны Jinja2 в Flask\n6. Практическая работа №3. Создание HTML-шаблонов с динамическими данными\n7. Формы и обработка данных\n8. Практическая работа №4. Создание формы авторизации с валидацией\n9. Основы REST API в Flask\n10. Практическая работа №5. Создание простого API с Flask\n11. Создание API с использованием Flask-RESTful\n12. Практическая работа №6. Разработка CRUD API с Flask-RESTful\n13. Аутентификация и авторизация в Flask API\n14. Практическая работа №7. Реализация JWT-аутентификации в Flask API\n15. Защита API и обработка ошибок\n16. Практическая работа №8. Улучшение безопасности API и обработка ошибок\n17. Введение в базы данных и SQLAlchemy\n18. Практическая работа №9. Настройка базы данных с SQLAlchemy\n19. Работа с моделями данных в Flask\n20. Практическая работа №10. Создание модели пользователей и управление данными\n21. AJAX-запросы в Flask\n22. Практическая работа №11. Создание динамической веб-страницы с AJAX\n23. Интеграция Flask с фронтендом\n24. Практическая работа №12. Интеграция фронтенда с Flask API\n25. Развёртывание Flask-приложения на Gunicorn и Nginx\n26. Практическая работа №13. Развёртывание Flask-приложения на сервере\n27. Хостинг Flask-приложения в облаке\n28. Практическая работа №14. Развёртывание Flask-приложения в облаке\n29. Оптимизация производительности Flask-приложений\n30. Практическая работа №15. Оптимизация производительности приложения\n31. Защита веб-приложений на Flask\n32. Мониторинг и логирование\n33. Практическая работа №16. Улучшение безопасности веб-приложения\n34. Практическая работа №17. Добавление логирования и мониторинга в Flaskприложение\n35. Работа с фоновыми задачами в Flask\n36. Практическая работа №18. Создание фоновой задачи в Flask	\N	\N	\N
132	478	1	Программа курса	1. Введение в Flask и создание первого веб-приложения\n2. Практическая работа №1. Установка Flask и создание первого маршрута\n3. Маршруты и обработка запросов\n4. Практическая работа №2. Обработка маршрутов и параметров в Flask\n5. Шаблоны Jinja2 в Flask\n6. Практическая работа №3. Создание HTML-шаблонов с динамическими данными\n7. Формы и обработка данных\n8. Практическая работа №4. Создание формы авторизации с валидацией\n9. Основы REST API в Flask\n10. Практическая работа №5. Создание простого API с Flask\n11. Создание API с использованием Flask-RESTful\n12. Практическая работа №6. Разработка CRUD API с Flask-RESTful\n13. Аутентификация и авторизация в Flask API\n14. Практическая работа №7. Реализация JWT-аутентификации в Flask API\n15. Защита API и обработка ошибок\n16. Практическая работа №8. Улучшение безопасности API и обработка ошибок\n17. Введение в базы данных и SQLAlchemy\n18. Практическая работа №9. Настройка базы данных с SQLAlchemy\n19. Работа с моделями данных в Flask\n20. Практическая работа №10. Создание модели пользователей и управление данными\n21. AJAX-запросы в Flask\n22. Практическая работа №11. Создание динамической веб-страницы с AJAX\n23. Интеграция Flask с фронтендом\n24. Практическая работа №12. Интеграция фронтенда с Flask API\n25. Развёртывание Flask-приложения на Gunicorn и Nginx\n26. Практическая работа №13. Развёртывание Flask-приложения на сервере\n27. Хостинг Flask-приложения в облаке\n28. Практическая работа №14. Развёртывание Flask-приложения в облаке\n29. Оптимизация производительности Flask-приложений\n30. Практическая работа №15. Оптимизация производительности приложения\n31. Защита веб-приложений на Flask\n32. Практическая работа №16. Улучшение безопасности веб-приложения\n33. Мониторинг и логирование\n34. Практическая работа №17. Добавление логирования и мониторинга в Flaskприложение\n35. Работа с фоновыми задачами в Flask\n36. Практическая работа №18. Создание фоновой задачи в Flask	\N	\N	\N
133	479	1	Программа курса	1. Декораторы в Python: основы\n2. Практическая работа №1. Реализация базовых декораторов\n3. Продвинутые декораторы\n4. Практическая работа №2. Написание сложных декораторов с параметрами\n5. Генераторы и ленивые вычисления\n6. Практическая работа №3. Создание генераторов для обработки данных\n7. Потоковая обработка данных с генераторами\n8. Практическая работа №4. Написание генераторов для обработки файлов и потоков данных\n9. Основы многопоточного программирования\n10. Практическая работа №5. Создание многопоточных программ\n11. Работа с очередями в многопоточности\n12. Практическая работа №6. Организация обработки данных через многопоточные очереди\n13. Асинхронное программирование в Python\n14. Практическая работа №7. Написание асинхронных программ с asyncio\n15. Асинхронные вызовы и Future-объекты\n16. Практическая работа №8. Оптимизация асинхронного кода\n17. Основы регулярных выражений\n18. Практическая работа №9. Использование регулярных выражений для поиска и фильтрации данных\n19. Продвинутая работа с регулярными выражениями\n20. Практическая работа №10. Написание сложных регулярных выражений\n21. Исключения: обработка ошибок\n22. Практическая работа №11. Создание системы обработки ошибок в приложении\n23. Логирование в Python\n24. Практическая работа №12. Внедрение логирования в Python-программу\n25. Основы метапрограммирования в Python\n26. Практическая работа №13. Написание программы с динамическим изменением классов\n27. Работа с объектами и introspection\n28. Практическая работа №14. Инспекция классов и функций с использованием introspection\n29. Глубокая работа с метаклассами\n30. Практическая работа №15. Создание собственных метаклассов\n31. Оптимизация кода и профилирование\n32. Практическая работа №16. Анализ производительности Python-кода\n33. Управление памятью в Python\n34. Практическая работа №17. Оптимизация работы с памятью\n35. Использование Cython и Numba для оптимизации Python-кода\n36. Практическая работа №18. Оптимизация вычислений с помощью Numba	\N	\N	\N
134	480	1	Программа курса	1. Декораторы в Python: основы\n2. Практическая работа №1. Реализация базовых декораторов\n3. Продвинутые декораторы\n4. Практическая работа №2. Написание сложных декораторов с параметрами\n5. Генераторы и ленивые вычисления\n6. Практическая работа №3. Создание генераторов для обработки данных\n7. Потоковая обработка данных с генераторами\n8. Практическая работа №4. Написание генераторов для обработки файлов и потоков данных\n9. Основы многопоточного программирования\n10. Практическая работа №5. Создание многопоточных программ\n11. Работа с очередями в многопоточности\n12. Практическая работа №6. Организация обработки данных через многопоточные очереди\n13. Асинхронное программирование в Python\n14. Практическая работа №7. Написание асинхронных программ с asyncio\n15. Асинхронные вызовы и Future-объекты\n16. Практическая работа №8. Оптимизация асинхронного кода\n17. Основы регулярных выражений\n18. Практическая работа №9. Использование регулярных выражений для поиска и фильтрации данных\n19. Продвинутая работа с регулярными выражениями\n20. Практическая работа №10. Написание сложных регулярных выражений\n21. Исключения: обработка ошибок\n22. Практическая работа №11. Создание системы обработки ошибок в приложении\n23. Логирование в Python\n24. Практическая работа №12. Внедрение логирования в Python-программу\n25. Основы метапрограммирования в Python\n26. Практическая работа №13. Написание программы с динамическим изменением классов\n27. Работа с объектами и introspection\n28. Практическая работа №14. Инспекция классов и функций с использованием introspection\n29. Глубокая работа с метаклассами\n30. Практическая работа №15. Создание собственных метаклассов\n31. Оптимизация кода и профилирование\n32. Практическая работа №16. Анализ производительности Python-кода\n33. Управление памятью в Python\n34. Практическая работа №17. Оптимизация работы с памятью\n35. Использование Cython и Numba для оптимизации Python-кода\n36. Практическая работа №18. Оптимизация вычислений с помощью Numba	\N	\N	\N
135	481	1	Программа курса	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Функции в Python: основы\n18. Практическая работа №9. Создание пользовательских функций\n19. Передача аргументов, *args, **kwargs\n20. Практическая работа №10. Работа с *args и **kwargs\n21. Работа с файлами: чтение и запись\n22. Практическая работа №11. Работа с файлами: чтение и запись данных\n23. Работа с CSV и JSON файлами\n24. Практическая работа №12. Чтение и запись данных в CSV и JSON\n25. Обработка ошибок и исключения\n26. Практическая работа №13. Обработка ошибок в программах\n27. Регулярные выражения (re)\n28. Практическая работа №14. Поиск и замена данных с использованием regex\n29. Основы ООП в Python\n30. Практическая работа №15. Создание классов и объектов\n31. Наследование и полиморфизм\n32. Практическая работа №16. Реализация наследования в Python\n33. Генераторы списков и lambda-функции\n34. Практическая работа №17. Оптимизация кода с генераторами\n35. Модули и виртуальные окружения\n36. Практическая работа №18. Создание и использование venv	\N	\N	\N
136	482	1	Программа курса	1. Введение в Python и установка среды разработки\n2. Практическая работа №1. Установка Python и\n3. Переменные и типы данных\n4. Практическая работа №2. Работа с переменными и типами данных\n5. Операторы в Python\n6. Практическая работа №3. Вычисления и логические операции в Python\n7. Условные конструкции\n8. Практическая работа №4. Программы с условными операторами\n9. Циклы в Python\n10. Практическая работа №5. Написание циклических программ\n11. Работа со строками\n12. Практическая работа №6. Обработка строк\n13. Списки и кортежи\n14. Практическая работа №7. Работа со списками\n15. Словари и множества\n16. Практическая работа №8. Использование словарей\n17. Функции в Python: основы\n18. Практическая работа №9. Создание пользовательских функций\n19. Передача аргументов, *args, **kwargs\n20. Практическая работа №10. Работа с *args и **kwargs\n21. Работа с файлами: чтение и запись\n22. Практическая работа №11. Работа с файлами: чтение и запись данных\n23. Работа с CSV и JSON файлами\n24. Практическая работа №12. Чтение и запись данных в CSV и JSON\n25. Обработка ошибок и исключения\n26. Практическая работа №13. Обработка ошибок в программах\n27. Регулярные выражения (re)\n28. Практическая работа №14. Поиск и замена данных с использованием regex\n29. Основы ООП в Python\n30. Практическая работа №15. Создание классов и объектов\n31. Наследование и полиморфизм\n32. Практическая работа №16. Реализация наследования в Python\n33. Генераторы списков и lambda-функции\n34. Практическая работа №17. Оптимизация кода с генераторами\n35. Модули и виртуальные окружения\n36. Практическая работа №18. Создание и использование venv	\N	\N	\N
\.


--
-- Data for Name: program_view; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_view (id, name) FROM stdin;
1	ДОП
2	ПП
3	ПК
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher (id, full_name, created_at, updated_at) FROM stdin;
1	Образцова Ксения Сергеевна	2026-03-08 15:42:57.754465	2026-03-08 15:42:57.754468
\.


--
-- Data for Name: workload_batch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workload_batch (id, program_id, teacher_id, group_name, is_group, created_at) FROM stdin;
1	416	1	Тест	t	2026-03-09 16:14:35.186188
2	416	1	Тест2	t	2026-03-09 16:25:27.680362
3	416	1	Т50-11-23	t	2026-03-11 15:18:20.036092
4	416	1	Тест4	t	2026-03-12 12:32:29.694565
\.


--
-- Data for Name: workload_document; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workload_document (id, program_id, teacher_id, program_type, file_name, file_path, generated_at, created_at, batch_id, contract_id, listener_id, group_name, is_group) FROM stdin;
1	451	1	ПК	Учебная_нагрузка_3D-моделирование и визуализация в Blender_20260309_150003.xlsx	C:\\Users\\Fotters\\Documents\\Учебная нагрузка\\Учебная_нагрузка_3D-моделирование и визуализация в Blender_20260309_150003.xlsx	2026-03-09 15:00:05.167763	2026-03-09 15:00:05.167763	\N	\N	\N	\N	f
2	416	1	ПП	Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260309_161435_1.xlsx	C:\\Users\\Fotters\\Documents\\Учебная нагрузка\\Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260309_161435_1.xlsx	2026-03-09 16:14:35.186188	2026-03-09 16:14:35.186188	1	183	2	Тест	t
3	416	1	ПП	Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Иванов Иван Иванович_20260309_162527_1.xlsx	C:\\Users\\Fotters\\Documents\\Учебная нагрузка\\Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Иванов Иван Иванович_20260309_162527_1.xlsx	2026-03-09 16:25:27.680362	2026-03-09 16:25:27.680362	2	184	4	Тест2	t
4	416	1	ПП	Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260309_162527_2.xlsx	C:\\Users\\Fotters\\Documents\\Учебная нагрузка\\Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260309_162527_2.xlsx	2026-03-09 16:25:27.680362	2026-03-09 16:25:27.680362	2	183	2	Тест2	t
5	416	1	ПП	Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Иванов Иван Иванович_20260311_151820_1.xlsx	C:\\Users\\Fotters\\Documents\\Учебная нагрузка\\Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Иванов Иван Иванович_20260311_151820_1.xlsx	2026-03-11 15:18:20.036092	2026-03-11 15:18:20.036092	3	184	4	Т50-11-23	t
6	416	1	ПП	Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260311_151820_2.xlsx	C:\\Users\\Fotters\\Documents\\Учебная нагрузка\\Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260311_151820_2.xlsx	2026-03-11 15:18:20.036092	2026-03-11 15:18:20.036092	3	183	2	Т50-11-23	t
7	416	1	ПП	Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260312_123229_1.xlsx	C:\\Users\\rhali\\OneDrive\\Документы\\Учебная нагрузка\\Учебная_нагрузка_Компьютерное зрение и искусственный интеллект на Python_Халиков Рамиль Наимович_20260312_123229_1.xlsx	2026-03-12 12:32:29.694565	2026-03-12 12:32:29.694565	4	183	2	Тест4	t
\.


--
-- Data for Name: workload_schedule_entry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workload_schedule_entry (id, workload_document_id, lesson_number, module_number, module_name, topic, lesson_date, day_of_week, start_time, end_time, hours, created_at) FROM stdin;
1	1	1	1	Программа курса	Знакомство с Blender: интерфейс, настройка	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
2	1	2	1	Программа курса	Практическая работа №1. Установка Blender, создание первого объекта	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
3	1	3	1	Программа курса	Основы навигации и трансформации	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
4	1	4	1	Программа курса	Практическая работа №2. Перемещение, вращение, масштабирование объектов	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
5	1	5	1	Программа курса	Примитивы и редактирование мешей	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
6	1	6	1	Программа курса	Практическая работа №3. Создание простого 3D-объекта	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
7	1	7	1	Программа курса	Режим редактирования: вершины, рёбра, грани	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
8	1	8	1	Программа курса	Практическая работа №4. Моделирование простого оружия или предмета	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
9	1	9	1	Программа курса	Модификаторы: Subdivision, Boolean, Mirror	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
10	1	10	1	Программа курса	Практическая работа №5. Применение модификаторов для ускорения моделирования	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
11	1	11	1	Программа курса	Материалы и шейдеры в Blender	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
12	1	12	1	Программа курса	Практическая работа №6. Создание PBR-материала для объекта	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
13	1	13	1	Программа курса	UV-развёртка и текстурирование	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
14	1	14	1	Программа курса	Практическая работа №7. Развёртка и наложение текстуры на модель	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
15	1	15	1	Программа курса	Создание текстур в Krita / GIMP	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
16	1	16	1	Программа курса	Практическая работа №8. Рисование текстуры для игрового объекта	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
17	1	17	1	Программа курса	Арматура и риггинг	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
18	1	18	1	Программа курса	Практическая работа №9. Создание скелета для персонажа	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
19	1	19	1	Программа курса	Анимация в Blender	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
20	1	20	1	Программа курса	Практическая работа №10. Анимация ходьбы персонажа	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
21	1	21	1	Программа курса	Экспорт моделей в Unity (.fbx)	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
22	1	22	1	Программа курса	Практическая работа №11. Настройка экспорта и импорт в Unity	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
23	1	23	1	Программа курса	Оптимизация полигональности	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
24	1	24	1	Программа курса	Практическая работа №12. Редуцирование полигонов для мобильных игр	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
25	1	25	1	Программа курса	LOD (уровни детализации)	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
26	1	26	1	Программа курса	Практическая работа №13. Создание LOD-моделей в Blender и Unity	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
27	1	27	1	Программа курса	Создание простого ландшафта	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
28	1	28	1	Программа курса	Практическая работа №14. Моделирование холмов и скал	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
29	1	29	1	Программа курса	Системы частиц в Blender	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
30	1	30	1	Программа курса	Практическая работа №15. Создание огня или дыма для визуализации	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
31	1	31	1	Программа курса	Рендеринг: Cycles и Eevee	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
32	1	32	1	Программа курса	Практическая работа №16. Рендер сцены для презентации	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
33	1	33	1	Программа курса	Создание простого UI-элемента в Blender	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
34	1	34	1	Программа курса	Практическая работа №17. Моделирование 3D-кнопки или иконки	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
35	1	35	1	Программа курса	Настройка рабочего процесса Blender–Unity	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
36	1	36	1	Программа курса	Практическая работа №18. Полный цикл: от модели до использования в игре	\N	\N	\N	\N	1	2026-03-09 15:00:05.167763
37	2	1	1	Модуль 1. Программирование на языке Python	Введение в Python и установка среды разработки	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
38	2	2	1	Модуль 1. Программирование на языке Python	Практическая работа №1. Установка Python и запуск первой программы	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
39	2	3	1	Модуль 1. Программирование на языке Python	Переменные и типы данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
40	2	4	1	Модуль 1. Программирование на языке Python	Практическая работа №2. Работа с переменными и типами данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
41	2	5	1	Модуль 1. Программирование на языке Python	Операторы в Python	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
192	3	12	1	Модуль 1. Программирование на языке Python	Практическая работа №6. Обработка строк	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
42	2	6	1	Модуль 1. Программирование на языке Python	Практическая работа №3. Вычисления и логические операции в Python	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
43	2	7	1	Модуль 1. Программирование на языке Python	Условные конструкции	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
44	2	8	1	Модуль 1. Программирование на языке Python	Практическая работа №4. Программы с условными операторами	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
45	2	9	1	Модуль 1. Программирование на языке Python	Циклы в Python	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
46	2	10	1	Модуль 1. Программирование на языке Python	Практическая работа №5. Написание циклических программ	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
47	2	11	1	Модуль 1. Программирование на языке Python	Работа со строками	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
48	2	12	1	Модуль 1. Программирование на языке Python	Практическая работа №6. Обработка строк	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
49	2	13	1	Модуль 1. Программирование на языке Python	Списки и кортежи	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
50	2	14	1	Модуль 1. Программирование на языке Python	Практическая работа №7. Работа со списками	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
51	2	15	1	Модуль 1. Программирование на языке Python	Словари и множества	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
52	2	16	1	Модуль 1. Программирование на языке Python	Практическая работа №8. Использование словарей	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
53	2	17	1	Модуль 1. Программирование на языке Python	Функции в Python: основы	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
54	2	18	1	Модуль 1. Программирование на языке Python	Практическая работа №9. Создание пользовательских функций	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
55	2	19	1	Модуль 1. Программирование на языке Python	Передача аргументов, *args, **kwargs	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
56	2	20	1	Модуль 1. Программирование на языке Python	Практическая работа №10. Работа с *args и **kwargs	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
57	2	21	1	Модуль 1. Программирование на языке Python	Работа с файлами: чтение и запись	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
58	2	22	1	Модуль 1. Программирование на языке Python	Практическая работа №11. Работа с файлами: чтение и запись данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
59	2	23	1	Модуль 1. Программирование на языке Python	Работа с CSV и JSON файлами	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
60	2	24	1	Модуль 1. Программирование на языке Python	Практическая работа №12. Чтение и запись данных в CSV и JSON	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
61	2	25	1	Модуль 1. Программирование на языке Python	Обработка ошибок и исключения	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
62	2	26	1	Модуль 1. Программирование на языке Python	Практическая работа №13. Обработка ошибок в программах	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
63	2	27	1	Модуль 1. Программирование на языке Python	Регулярные выражения (re)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
64	2	28	1	Модуль 1. Программирование на языке Python	Практическая работа №14. Поиск и замена данных с использованием regex	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
65	2	29	1	Модуль 1. Программирование на языке Python	Основы ООП в Python	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
66	2	30	1	Модуль 1. Программирование на языке Python	Практическая работа №15. Создание классов и объектов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
67	2	31	1	Модуль 1. Программирование на языке Python	Наследование и полиморфизм	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
68	2	32	1	Модуль 1. Программирование на языке Python	Практическая работа №16. Реализация наследования в Python	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
69	2	33	1	Модуль 1. Программирование на языке Python	Генераторы списков и lambda-функции	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
70	2	34	1	Модуль 1. Программирование на языке Python	Практическая работа №17. Оптимизация кода с генераторами	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
71	2	35	1	Модуль 1. Программирование на языке Python	Модули и виртуальные окружения	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
72	2	36	1	Модуль 1. Программирование на языке Python	Практическая работа №18. Создание и использование venv	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
73	2	37	2	Модуль 2. Анализ и обработка данных на Python	Введение в анализ данных и Big Data	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
74	2	38	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
75	2	39	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой NumPy	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
76	2	40	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №2. Создание и манипуляции с многомерными массивами	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
77	2	41	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой Pandas	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
78	2	42	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа  №3. Загрузка и первичный анализ структурированных данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
79	2	43	2	Модуль 2. Анализ и обработка данных на Python	Чтение и запись данных в форматах CSV, JSON, Parquet	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
80	2	44	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №4. Импорт и экспорт данных с использованием Pandas	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
81	2	45	2	Модуль 2. Анализ и обработка данных на Python	Работа с Excel-файлами	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
82	2	46	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
83	2	47	2	Модуль 2. Анализ и обработка данных на Python	Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
84	2	48	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №6. Выполнение SQL-запросов из Python-скриптов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
85	2	49	2	Модуль 2. Анализ и обработка данных на Python	Фильтрация и сортировка данных в Pandas	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
86	2	50	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №7. Отбор строк и столбцов по условию	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
87	2	51	2	Модуль 2. Анализ и обработка данных на Python	Группировка данных и агрегация	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
88	2	52	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
89	2	53	2	Модуль 2. Анализ и обработка данных на Python	Сводные таблицы и кросстабуляции	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
90	2	54	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №9. Построение аналитических сводок по категориальным данным	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
91	2	55	2	Модуль 2. Анализ и обработка данных на Python	Объединение и слияние датафреймов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
92	2	56	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №10. Объединение таблиц по ключам (join/merge)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
93	2	57	2	Модуль 2. Анализ и обработка данных на Python	Работа с временными рядами	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
94	2	58	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №11. Преобразование строковых дат и агрегация по периодам	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
95	2	59	2	Модуль 2. Анализ и обработка данных на Python	Обработка пропущенных данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
96	2	60	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №12. Поиск, удаление и импутация пропусков	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
97	2	61	2	Модуль 2. Анализ и обработка данных на Python	Работа с выбросами и аномалиями	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
98	2	62	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №13. Выявление выбросов методами IQR и Z-score	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
99	2	63	2	Модуль 2. Анализ и обработка данных на Python	Кодирование категориальных признаков	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
100	2	64	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №14. One-hot и label-кодирование	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
101	2	65	2	Модуль 2. Анализ и обработка данных на Python	Нормализация и стандартизация данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
102	2	66	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №15. Масштабирование признаков для ML-моделей	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
103	2	67	2	Модуль 2. Анализ и обработка данных на Python	Работа с большими наборами данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
104	2	68	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
105	2	69	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Matplotlib	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
106	2	70	2	Модуль 2. Анализ и обработка данных на Python	Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
107	2	71	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Seaborn	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
108	2	72	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
109	2	73	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
110	2	74	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №1. Постановка ML-задач на основе реальных датасетов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
111	2	75	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Подготовка данных для машинного обучения	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
112	2	76	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №2. Разделение данных на обучающую и тестовую выборки	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
113	2	77	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение первой модели: линейная регрессия	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
114	2	78	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
115	2	79	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
116	2	80	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №4. Оценка качества моделей на тестовой выборке	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
117	2	81	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Классификация: логистическая регрессия и kNN	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
118	2	82	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №5. Решение задач бинарной и многоклассовой классификации	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
119	2	83	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Деревья решений и случайный лес	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
120	2	84	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №6. Обучение и визуализация дерева решений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
121	2	85	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кластеризация: K-Means и иерархическая кластеризация	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
122	2	86	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №7. Группировка клиентов или объектов без разметки	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
123	2	87	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Работа с несбалансированными данными	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
124	2	88	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №8. Применение oversampling (SMOTE) и undersampling	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
125	2	89	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кросс-валидация и подбор гиперпараметров	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
126	2	90	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №9. Подбор параметров с помощью GridSearchCV	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
127	2	91	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Основы нейросетей: перцептрон и многослойные сети	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
128	2	92	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
129	2	93	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение нейросетей на табличных данных	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
130	2	94	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
131	2	95	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в нейросети для обработки изображений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
132	2	96	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
133	2	97	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Сверточные нейронные сети (CNN): архитектура и принцип работы	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
134	2	98	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №13. Построение первой CNN для классификации CIFAR-10	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
135	2	99	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение CNN на собственном датасете	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
190	3	10	1	Модуль 1. Программирование на языке Python	Практическая работа №5. Написание циклических программ	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
136	2	100	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №14. Подготовка изображений и обучение модели под задачу	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
137	2	101	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
138	2	102	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №15. Применение аугментации и регуляризации в Keras	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
139	2	103	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Использование предобученных моделей (Transfer Learning)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
140	2	104	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
141	2	105	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Оценка и интерпретация моделей компьютерного зрения	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
142	2	106	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №17. Визуализация активаций и ошибок предсказаний	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
143	2	107	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Применение сквозного ML-пайплайна для задачи классификации изображений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
144	2	108	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
145	2	109	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в компьютерное зрение: задачи и применения	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
146	2	110	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №1. Установка OpenCV и загрузка изображений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
147	2	111	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
148	2	112	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с изображениями: цветовые пространства, каналы, гистограммы	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
149	2	113	4	Модуль 4. Компьютерное зрение и обработка больших данных	Фильтрация и шумоподавление: Gaussian, Median, Bilateral	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
150	2	114	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №3. Улучшение качества изображений с OpenCV	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
151	2	115	4	Модуль 4. Компьютерное зрение и обработка больших данных	Геометрические преобразования: масштабирование, поворот, аффинные преобразования	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
152	2	116	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №4. Коррекция перспективы и выравнивание объектов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
153	2	117	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение границ и контуров (Canny, Sobel, Laplacian)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
154	2	118	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №5. Поиск и отрисовка контуров объектов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
155	2	119	4	Модуль 4. Компьютерное зрение и обработка больших данных	Сегментация изображений: пороговая, адаптивная, watershed	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
156	2	120	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №6. Выделение фона и переднего плана	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
157	2	121	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение объектов: метод скользящего окна, Haar-каскады	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
158	2	122	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
159	2	123	4	Модуль 4. Компьютерное зрение и обработка больших данных	Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
160	2	124	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
161	2	125	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с видео: чтение, запись, обработка кадров	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
191	3	11	1	Модуль 1. Программирование на языке Python	Работа со строками	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
162	2	126	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №9. Обнаружение движущихся объектов в видеопотоке	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
163	2	127	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обработка больших объёмов изображений (пакетная обработка)	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
164	2	128	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №10. Создание пайплайна для обработки тысяч изображений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
165	2	129	4	Модуль 4. Компьютерное зрение и обработка больших данных	Анализ структурированных и полуструктурированных данных в контексте Big Data	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
166	2	130	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
167	2	131	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в распределённые вычисления: Dask и локальные кластеры	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
168	2	132	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №12. Параллельная обработка данных без облачных сервисов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
169	2	133	4	Модуль 4. Компьютерное зрение и обработка больших данных	Хранение и обработка данных: Apache Parquet, DuckDB	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
170	2	134	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №13. Эффективное хранение и запросы к большим данным	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
171	2	135	4	Модуль 4. Компьютерное зрение и обработка больших данных	Основы MLOps: сохранение и загрузка моделей, логирование экспериментов	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
172	2	136	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
173	2	137	4	Модуль 4. Компьютерное зрение и обработка больших данных	Развёртывание ML-модели: локальный REST API на Flask/FastAPI	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
174	2	138	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №15. Создание API для получения предсказаний модели по HTTP	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
175	2	139	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компьютерного зрения в аналитические системы	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
176	2	140	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
177	2	141	4	Модуль 4. Компьютерное зрение и обработка больших данных	Этические и правовые аспекты работы со зрительными данными	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
178	2	142	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
179	2	143	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
180	2	144	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N	\N	1	2026-03-09 16:14:35.186188
181	3	1	1	Модуль 1. Программирование на языке Python	Введение в Python и установка среды разработки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
182	3	2	1	Модуль 1. Программирование на языке Python	Практическая работа №1. Установка Python и запуск первой программы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
183	3	3	1	Модуль 1. Программирование на языке Python	Переменные и типы данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
184	3	4	1	Модуль 1. Программирование на языке Python	Практическая работа №2. Работа с переменными и типами данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
185	3	5	1	Модуль 1. Программирование на языке Python	Операторы в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
186	3	6	1	Модуль 1. Программирование на языке Python	Практическая работа №3. Вычисления и логические операции в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
187	3	7	1	Модуль 1. Программирование на языке Python	Условные конструкции	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
188	3	8	1	Модуль 1. Программирование на языке Python	Практическая работа №4. Программы с условными операторами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
189	3	9	1	Модуль 1. Программирование на языке Python	Циклы в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
193	3	13	1	Модуль 1. Программирование на языке Python	Списки и кортежи	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
194	3	14	1	Модуль 1. Программирование на языке Python	Практическая работа №7. Работа со списками	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
195	3	15	1	Модуль 1. Программирование на языке Python	Словари и множества	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
196	3	16	1	Модуль 1. Программирование на языке Python	Практическая работа №8. Использование словарей	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
197	3	17	1	Модуль 1. Программирование на языке Python	Функции в Python: основы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
198	3	18	1	Модуль 1. Программирование на языке Python	Практическая работа №9. Создание пользовательских функций	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
199	3	19	1	Модуль 1. Программирование на языке Python	Передача аргументов, *args, **kwargs	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
200	3	20	1	Модуль 1. Программирование на языке Python	Практическая работа №10. Работа с *args и **kwargs	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
201	3	21	1	Модуль 1. Программирование на языке Python	Работа с файлами: чтение и запись	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
202	3	22	1	Модуль 1. Программирование на языке Python	Практическая работа №11. Работа с файлами: чтение и запись данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
203	3	23	1	Модуль 1. Программирование на языке Python	Работа с CSV и JSON файлами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
204	3	24	1	Модуль 1. Программирование на языке Python	Практическая работа №12. Чтение и запись данных в CSV и JSON	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
205	3	25	1	Модуль 1. Программирование на языке Python	Обработка ошибок и исключения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
206	3	26	1	Модуль 1. Программирование на языке Python	Практическая работа №13. Обработка ошибок в программах	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
207	3	27	1	Модуль 1. Программирование на языке Python	Регулярные выражения (re)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
208	3	28	1	Модуль 1. Программирование на языке Python	Практическая работа №14. Поиск и замена данных с использованием regex	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
209	3	29	1	Модуль 1. Программирование на языке Python	Основы ООП в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
210	3	30	1	Модуль 1. Программирование на языке Python	Практическая работа №15. Создание классов и объектов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
211	3	31	1	Модуль 1. Программирование на языке Python	Наследование и полиморфизм	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
212	3	32	1	Модуль 1. Программирование на языке Python	Практическая работа №16. Реализация наследования в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
213	3	33	1	Модуль 1. Программирование на языке Python	Генераторы списков и lambda-функции	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
214	3	34	1	Модуль 1. Программирование на языке Python	Практическая работа №17. Оптимизация кода с генераторами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
215	3	35	1	Модуль 1. Программирование на языке Python	Модули и виртуальные окружения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
216	3	36	1	Модуль 1. Программирование на языке Python	Практическая работа №18. Создание и использование venv	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
217	3	37	2	Модуль 2. Анализ и обработка данных на Python	Введение в анализ данных и Big Data	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
218	3	38	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
219	3	39	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой NumPy	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
220	3	40	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №2. Создание и манипуляции с многомерными массивами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
221	3	41	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой Pandas	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
222	3	42	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа  №3. Загрузка и первичный анализ структурированных данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
223	3	43	2	Модуль 2. Анализ и обработка данных на Python	Чтение и запись данных в форматах CSV, JSON, Parquet	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
224	3	44	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №4. Импорт и экспорт данных с использованием Pandas	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
225	3	45	2	Модуль 2. Анализ и обработка данных на Python	Работа с Excel-файлами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
226	3	46	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
227	3	47	2	Модуль 2. Анализ и обработка данных на Python	Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
228	3	48	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №6. Выполнение SQL-запросов из Python-скриптов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
229	3	49	2	Модуль 2. Анализ и обработка данных на Python	Фильтрация и сортировка данных в Pandas	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
230	3	50	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №7. Отбор строк и столбцов по условию	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
231	3	51	2	Модуль 2. Анализ и обработка данных на Python	Группировка данных и агрегация	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
232	3	52	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
233	3	53	2	Модуль 2. Анализ и обработка данных на Python	Сводные таблицы и кросстабуляции	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
234	3	54	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №9. Построение аналитических сводок по категориальным данным	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
235	3	55	2	Модуль 2. Анализ и обработка данных на Python	Объединение и слияние датафреймов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
236	3	56	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №10. Объединение таблиц по ключам (join/merge)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
237	3	57	2	Модуль 2. Анализ и обработка данных на Python	Работа с временными рядами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
238	3	58	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №11. Преобразование строковых дат и агрегация по периодам	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
239	3	59	2	Модуль 2. Анализ и обработка данных на Python	Обработка пропущенных данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
240	3	60	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №12. Поиск, удаление и импутация пропусков	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
241	3	61	2	Модуль 2. Анализ и обработка данных на Python	Работа с выбросами и аномалиями	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
242	3	62	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №13. Выявление выбросов методами IQR и Z-score	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
243	3	63	2	Модуль 2. Анализ и обработка данных на Python	Кодирование категориальных признаков	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
244	3	64	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №14. One-hot и label-кодирование	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
245	3	65	2	Модуль 2. Анализ и обработка данных на Python	Нормализация и стандартизация данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
246	3	66	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №15. Масштабирование признаков для ML-моделей	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
247	3	67	2	Модуль 2. Анализ и обработка данных на Python	Работа с большими наборами данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
248	3	68	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
249	3	69	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Matplotlib	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
250	3	70	2	Модуль 2. Анализ и обработка данных на Python	Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
251	3	71	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Seaborn	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
252	3	72	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
253	3	73	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
254	3	74	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №1. Постановка ML-задач на основе реальных датасетов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
255	3	75	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Подготовка данных для машинного обучения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
256	3	76	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №2. Разделение данных на обучающую и тестовую выборки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
257	3	77	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение первой модели: линейная регрессия	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
258	3	78	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
259	3	79	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
260	3	80	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №4. Оценка качества моделей на тестовой выборке	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
261	3	81	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Классификация: логистическая регрессия и kNN	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
262	3	82	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №5. Решение задач бинарной и многоклассовой классификации	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
263	3	83	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Деревья решений и случайный лес	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
264	3	84	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №6. Обучение и визуализация дерева решений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
265	3	85	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кластеризация: K-Means и иерархическая кластеризация	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
266	3	86	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №7. Группировка клиентов или объектов без разметки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
267	3	87	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Работа с несбалансированными данными	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
268	3	88	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №8. Применение oversampling (SMOTE) и undersampling	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
269	3	89	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кросс-валидация и подбор гиперпараметров	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
270	3	90	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №9. Подбор параметров с помощью GridSearchCV	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
271	3	91	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Основы нейросетей: перцептрон и многослойные сети	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
272	3	92	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
273	3	93	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение нейросетей на табличных данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
274	3	94	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
275	3	95	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в нейросети для обработки изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
276	3	96	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
277	3	97	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Сверточные нейронные сети (CNN): архитектура и принцип работы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
278	3	98	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №13. Построение первой CNN для классификации CIFAR-10	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
279	3	99	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение CNN на собственном датасете	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
280	3	100	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №14. Подготовка изображений и обучение модели под задачу	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
281	3	101	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
282	3	102	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №15. Применение аугментации и регуляризации в Keras	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
283	3	103	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Использование предобученных моделей (Transfer Learning)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
284	3	104	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
342	4	18	1	Модуль 1. Программирование на языке Python	Практическая работа №9. Создание пользовательских функций	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
285	3	105	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Оценка и интерпретация моделей компьютерного зрения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
286	3	106	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №17. Визуализация активаций и ошибок предсказаний	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
287	3	107	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Применение сквозного ML-пайплайна для задачи классификации изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
288	3	108	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
289	3	109	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в компьютерное зрение: задачи и применения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
290	3	110	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №1. Установка OpenCV и загрузка изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
291	3	111	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
292	3	112	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с изображениями: цветовые пространства, каналы, гистограммы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
293	3	113	4	Модуль 4. Компьютерное зрение и обработка больших данных	Фильтрация и шумоподавление: Gaussian, Median, Bilateral	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
294	3	114	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №3. Улучшение качества изображений с OpenCV	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
295	3	115	4	Модуль 4. Компьютерное зрение и обработка больших данных	Геометрические преобразования: масштабирование, поворот, аффинные преобразования	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
296	3	116	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №4. Коррекция перспективы и выравнивание объектов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
297	3	117	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение границ и контуров (Canny, Sobel, Laplacian)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
298	3	118	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №5. Поиск и отрисовка контуров объектов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
299	3	119	4	Модуль 4. Компьютерное зрение и обработка больших данных	Сегментация изображений: пороговая, адаптивная, watershed	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
300	3	120	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №6. Выделение фона и переднего плана	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
301	3	121	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение объектов: метод скользящего окна, Haar-каскады	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
302	3	122	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
303	3	123	4	Модуль 4. Компьютерное зрение и обработка больших данных	Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
304	3	124	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
305	3	125	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с видео: чтение, запись, обработка кадров	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
306	3	126	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №9. Обнаружение движущихся объектов в видеопотоке	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
307	3	127	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обработка больших объёмов изображений (пакетная обработка)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
308	3	128	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №10. Создание пайплайна для обработки тысяч изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
309	3	129	4	Модуль 4. Компьютерное зрение и обработка больших данных	Анализ структурированных и полуструктурированных данных в контексте Big Data	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
310	3	130	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
343	4	19	1	Модуль 1. Программирование на языке Python	Передача аргументов, *args, **kwargs	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
311	3	131	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в распределённые вычисления: Dask и локальные кластеры	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
312	3	132	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №12. Параллельная обработка данных без облачных сервисов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
313	3	133	4	Модуль 4. Компьютерное зрение и обработка больших данных	Хранение и обработка данных: Apache Parquet, DuckDB	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
314	3	134	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №13. Эффективное хранение и запросы к большим данным	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
315	3	135	4	Модуль 4. Компьютерное зрение и обработка больших данных	Основы MLOps: сохранение и загрузка моделей, логирование экспериментов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
316	3	136	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
317	3	137	4	Модуль 4. Компьютерное зрение и обработка больших данных	Развёртывание ML-модели: локальный REST API на Flask/FastAPI	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
318	3	138	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №15. Создание API для получения предсказаний модели по HTTP	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
319	3	139	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компьютерного зрения в аналитические системы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
320	3	140	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
321	3	141	4	Модуль 4. Компьютерное зрение и обработка больших данных	Этические и правовые аспекты работы со зрительными данными	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
322	3	142	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
323	3	143	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
324	3	144	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
325	4	1	1	Модуль 1. Программирование на языке Python	Введение в Python и установка среды разработки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
326	4	2	1	Модуль 1. Программирование на языке Python	Практическая работа №1. Установка Python и запуск первой программы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
327	4	3	1	Модуль 1. Программирование на языке Python	Переменные и типы данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
328	4	4	1	Модуль 1. Программирование на языке Python	Практическая работа №2. Работа с переменными и типами данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
329	4	5	1	Модуль 1. Программирование на языке Python	Операторы в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
330	4	6	1	Модуль 1. Программирование на языке Python	Практическая работа №3. Вычисления и логические операции в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
331	4	7	1	Модуль 1. Программирование на языке Python	Условные конструкции	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
332	4	8	1	Модуль 1. Программирование на языке Python	Практическая работа №4. Программы с условными операторами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
333	4	9	1	Модуль 1. Программирование на языке Python	Циклы в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
334	4	10	1	Модуль 1. Программирование на языке Python	Практическая работа №5. Написание циклических программ	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
335	4	11	1	Модуль 1. Программирование на языке Python	Работа со строками	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
336	4	12	1	Модуль 1. Программирование на языке Python	Практическая работа №6. Обработка строк	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
337	4	13	1	Модуль 1. Программирование на языке Python	Списки и кортежи	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
338	4	14	1	Модуль 1. Программирование на языке Python	Практическая работа №7. Работа со списками	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
339	4	15	1	Модуль 1. Программирование на языке Python	Словари и множества	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
340	4	16	1	Модуль 1. Программирование на языке Python	Практическая работа №8. Использование словарей	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
341	4	17	1	Модуль 1. Программирование на языке Python	Функции в Python: основы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
344	4	20	1	Модуль 1. Программирование на языке Python	Практическая работа №10. Работа с *args и **kwargs	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
345	4	21	1	Модуль 1. Программирование на языке Python	Работа с файлами: чтение и запись	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
346	4	22	1	Модуль 1. Программирование на языке Python	Практическая работа №11. Работа с файлами: чтение и запись данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
347	4	23	1	Модуль 1. Программирование на языке Python	Работа с CSV и JSON файлами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
348	4	24	1	Модуль 1. Программирование на языке Python	Практическая работа №12. Чтение и запись данных в CSV и JSON	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
349	4	25	1	Модуль 1. Программирование на языке Python	Обработка ошибок и исключения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
350	4	26	1	Модуль 1. Программирование на языке Python	Практическая работа №13. Обработка ошибок в программах	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
351	4	27	1	Модуль 1. Программирование на языке Python	Регулярные выражения (re)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
352	4	28	1	Модуль 1. Программирование на языке Python	Практическая работа №14. Поиск и замена данных с использованием regex	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
353	4	29	1	Модуль 1. Программирование на языке Python	Основы ООП в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
354	4	30	1	Модуль 1. Программирование на языке Python	Практическая работа №15. Создание классов и объектов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
355	4	31	1	Модуль 1. Программирование на языке Python	Наследование и полиморфизм	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
356	4	32	1	Модуль 1. Программирование на языке Python	Практическая работа №16. Реализация наследования в Python	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
357	4	33	1	Модуль 1. Программирование на языке Python	Генераторы списков и lambda-функции	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
358	4	34	1	Модуль 1. Программирование на языке Python	Практическая работа №17. Оптимизация кода с генераторами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
359	4	35	1	Модуль 1. Программирование на языке Python	Модули и виртуальные окружения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
360	4	36	1	Модуль 1. Программирование на языке Python	Практическая работа №18. Создание и использование venv	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
361	4	37	2	Модуль 2. Анализ и обработка данных на Python	Введение в анализ данных и Big Data	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
362	4	38	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
363	4	39	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой NumPy	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
364	4	40	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №2. Создание и манипуляции с многомерными массивами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
365	4	41	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой Pandas	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
366	4	42	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа  №3. Загрузка и первичный анализ структурированных данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
367	4	43	2	Модуль 2. Анализ и обработка данных на Python	Чтение и запись данных в форматах CSV, JSON, Parquet	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
368	4	44	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №4. Импорт и экспорт данных с использованием Pandas	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
369	4	45	2	Модуль 2. Анализ и обработка данных на Python	Работа с Excel-файлами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
370	4	46	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
371	4	47	2	Модуль 2. Анализ и обработка данных на Python	Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
372	4	48	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №6. Выполнение SQL-запросов из Python-скриптов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
373	4	49	2	Модуль 2. Анализ и обработка данных на Python	Фильтрация и сортировка данных в Pandas	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
374	4	50	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №7. Отбор строк и столбцов по условию	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
375	4	51	2	Модуль 2. Анализ и обработка данных на Python	Группировка данных и агрегация	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
376	4	52	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
377	4	53	2	Модуль 2. Анализ и обработка данных на Python	Сводные таблицы и кросстабуляции	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
378	4	54	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №9. Построение аналитических сводок по категориальным данным	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
379	4	55	2	Модуль 2. Анализ и обработка данных на Python	Объединение и слияние датафреймов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
380	4	56	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №10. Объединение таблиц по ключам (join/merge)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
381	4	57	2	Модуль 2. Анализ и обработка данных на Python	Работа с временными рядами	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
382	4	58	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №11. Преобразование строковых дат и агрегация по периодам	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
383	4	59	2	Модуль 2. Анализ и обработка данных на Python	Обработка пропущенных данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
384	4	60	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №12. Поиск, удаление и импутация пропусков	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
385	4	61	2	Модуль 2. Анализ и обработка данных на Python	Работа с выбросами и аномалиями	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
386	4	62	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №13. Выявление выбросов методами IQR и Z-score	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
387	4	63	2	Модуль 2. Анализ и обработка данных на Python	Кодирование категориальных признаков	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
388	4	64	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №14. One-hot и label-кодирование	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
389	4	65	2	Модуль 2. Анализ и обработка данных на Python	Нормализация и стандартизация данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
390	4	66	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №15. Масштабирование признаков для ML-моделей	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
391	4	67	2	Модуль 2. Анализ и обработка данных на Python	Работа с большими наборами данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
392	4	68	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
393	4	69	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Matplotlib	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
394	4	70	2	Модуль 2. Анализ и обработка данных на Python	Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
395	4	71	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Seaborn	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
396	4	72	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
397	4	73	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
398	4	74	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №1. Постановка ML-задач на основе реальных датасетов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
399	4	75	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Подготовка данных для машинного обучения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
400	4	76	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №2. Разделение данных на обучающую и тестовую выборки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
401	4	77	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение первой модели: линейная регрессия	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
402	4	78	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
403	4	79	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
404	4	80	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №4. Оценка качества моделей на тестовой выборке	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
405	4	81	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Классификация: логистическая регрессия и kNN	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
406	4	82	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №5. Решение задач бинарной и многоклассовой классификации	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
407	4	83	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Деревья решений и случайный лес	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
408	4	84	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №6. Обучение и визуализация дерева решений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
409	4	85	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кластеризация: K-Means и иерархическая кластеризация	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
410	4	86	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №7. Группировка клиентов или объектов без разметки	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
411	4	87	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Работа с несбалансированными данными	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
412	4	88	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №8. Применение oversampling (SMOTE) и undersampling	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
413	4	89	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кросс-валидация и подбор гиперпараметров	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
414	4	90	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №9. Подбор параметров с помощью GridSearchCV	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
415	4	91	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Основы нейросетей: перцептрон и многослойные сети	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
416	4	92	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
417	4	93	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение нейросетей на табличных данных	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
418	4	94	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
419	4	95	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в нейросети для обработки изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
420	4	96	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
421	4	97	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Сверточные нейронные сети (CNN): архитектура и принцип работы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
422	4	98	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №13. Построение первой CNN для классификации CIFAR-10	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
423	4	99	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение CNN на собственном датасете	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
424	4	100	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №14. Подготовка изображений и обучение модели под задачу	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
425	4	101	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
426	4	102	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №15. Применение аугментации и регуляризации в Keras	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
427	4	103	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Использование предобученных моделей (Transfer Learning)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
428	4	104	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
429	4	105	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Оценка и интерпретация моделей компьютерного зрения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
430	4	106	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №17. Визуализация активаций и ошибок предсказаний	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
431	4	107	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Применение сквозного ML-пайплайна для задачи классификации изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
432	4	108	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
433	4	109	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в компьютерное зрение: задачи и применения	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
434	4	110	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №1. Установка OpenCV и загрузка изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
435	4	111	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
436	4	112	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с изображениями: цветовые пространства, каналы, гистограммы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
437	4	113	4	Модуль 4. Компьютерное зрение и обработка больших данных	Фильтрация и шумоподавление: Gaussian, Median, Bilateral	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
438	4	114	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №3. Улучшение качества изображений с OpenCV	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
439	4	115	4	Модуль 4. Компьютерное зрение и обработка больших данных	Геометрические преобразования: масштабирование, поворот, аффинные преобразования	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
440	4	116	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №4. Коррекция перспективы и выравнивание объектов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
441	4	117	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение границ и контуров (Canny, Sobel, Laplacian)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
442	4	118	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №5. Поиск и отрисовка контуров объектов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
443	4	119	4	Модуль 4. Компьютерное зрение и обработка больших данных	Сегментация изображений: пороговая, адаптивная, watershed	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
444	4	120	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №6. Выделение фона и переднего плана	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
445	4	121	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение объектов: метод скользящего окна, Haar-каскады	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
446	4	122	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
447	4	123	4	Модуль 4. Компьютерное зрение и обработка больших данных	Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
448	4	124	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
449	4	125	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с видео: чтение, запись, обработка кадров	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
450	4	126	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №9. Обнаружение движущихся объектов в видеопотоке	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
451	4	127	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обработка больших объёмов изображений (пакетная обработка)	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
452	4	128	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №10. Создание пайплайна для обработки тысяч изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
453	4	129	4	Модуль 4. Компьютерное зрение и обработка больших данных	Анализ структурированных и полуструктурированных данных в контексте Big Data	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
454	4	130	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
455	4	131	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в распределённые вычисления: Dask и локальные кластеры	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
456	4	132	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №12. Параллельная обработка данных без облачных сервисов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
457	4	133	4	Модуль 4. Компьютерное зрение и обработка больших данных	Хранение и обработка данных: Apache Parquet, DuckDB	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
458	4	134	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №13. Эффективное хранение и запросы к большим данным	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
459	4	135	4	Модуль 4. Компьютерное зрение и обработка больших данных	Основы MLOps: сохранение и загрузка моделей, логирование экспериментов	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
460	4	136	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
461	4	137	4	Модуль 4. Компьютерное зрение и обработка больших данных	Развёртывание ML-модели: локальный REST API на Flask/FastAPI	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
462	4	138	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №15. Создание API для получения предсказаний модели по HTTP	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
463	4	139	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компьютерного зрения в аналитические системы	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
464	4	140	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
465	4	141	4	Модуль 4. Компьютерное зрение и обработка больших данных	Этические и правовые аспекты работы со зрительными данными	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
466	4	142	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
467	4	143	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
468	4	144	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N	\N	1	2026-03-09 16:25:27.680362
469	5	1	1	Модуль 1. Программирование на языке Python	Введение в Python и установка среды разработки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
470	5	2	1	Модуль 1. Программирование на языке Python	Практическая работа №1. Установка Python и запуск первой программы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
471	5	3	1	Модуль 1. Программирование на языке Python	Переменные и типы данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
472	5	4	1	Модуль 1. Программирование на языке Python	Практическая работа №2. Работа с переменными и типами данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
473	5	5	1	Модуль 1. Программирование на языке Python	Операторы в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
474	5	6	1	Модуль 1. Программирование на языке Python	Практическая работа №3. Вычисления и логические операции в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
475	5	7	1	Модуль 1. Программирование на языке Python	Условные конструкции	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
476	5	8	1	Модуль 1. Программирование на языке Python	Практическая работа №4. Программы с условными операторами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
477	5	9	1	Модуль 1. Программирование на языке Python	Циклы в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
478	5	10	1	Модуль 1. Программирование на языке Python	Практическая работа №5. Написание циклических программ	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
479	5	11	1	Модуль 1. Программирование на языке Python	Работа со строками	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
480	5	12	1	Модуль 1. Программирование на языке Python	Практическая работа №6. Обработка строк	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
481	5	13	1	Модуль 1. Программирование на языке Python	Списки и кортежи	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
482	5	14	1	Модуль 1. Программирование на языке Python	Практическая работа №7. Работа со списками	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
483	5	15	1	Модуль 1. Программирование на языке Python	Словари и множества	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
484	5	16	1	Модуль 1. Программирование на языке Python	Практическая работа №8. Использование словарей	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
485	5	17	1	Модуль 1. Программирование на языке Python	Функции в Python: основы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
486	5	18	1	Модуль 1. Программирование на языке Python	Практическая работа №9. Создание пользовательских функций	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
487	5	19	1	Модуль 1. Программирование на языке Python	Передача аргументов, *args, **kwargs	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
488	5	20	1	Модуль 1. Программирование на языке Python	Практическая работа №10. Работа с *args и **kwargs	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
489	5	21	1	Модуль 1. Программирование на языке Python	Работа с файлами: чтение и запись	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
490	5	22	1	Модуль 1. Программирование на языке Python	Практическая работа №11. Работа с файлами: чтение и запись данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
491	5	23	1	Модуль 1. Программирование на языке Python	Работа с CSV и JSON файлами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
492	5	24	1	Модуль 1. Программирование на языке Python	Практическая работа №12. Чтение и запись данных в CSV и JSON	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
493	5	25	1	Модуль 1. Программирование на языке Python	Обработка ошибок и исключения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
494	5	26	1	Модуль 1. Программирование на языке Python	Практическая работа №13. Обработка ошибок в программах	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
495	5	27	1	Модуль 1. Программирование на языке Python	Регулярные выражения (re)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
496	5	28	1	Модуль 1. Программирование на языке Python	Практическая работа №14. Поиск и замена данных с использованием regex	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
497	5	29	1	Модуль 1. Программирование на языке Python	Основы ООП в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
498	5	30	1	Модуль 1. Программирование на языке Python	Практическая работа №15. Создание классов и объектов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
499	5	31	1	Модуль 1. Программирование на языке Python	Наследование и полиморфизм	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
500	5	32	1	Модуль 1. Программирование на языке Python	Практическая работа №16. Реализация наследования в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
501	5	33	1	Модуль 1. Программирование на языке Python	Генераторы списков и lambda-функции	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
502	5	34	1	Модуль 1. Программирование на языке Python	Практическая работа №17. Оптимизация кода с генераторами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
503	5	35	1	Модуль 1. Программирование на языке Python	Модули и виртуальные окружения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
504	5	36	1	Модуль 1. Программирование на языке Python	Практическая работа №18. Создание и использование venv	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
505	5	37	2	Модуль 2. Анализ и обработка данных на Python	Введение в анализ данных и Big Data	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
506	5	38	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
507	5	39	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой NumPy	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
508	5	40	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №2. Создание и манипуляции с многомерными массивами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
509	5	41	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой Pandas	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
510	5	42	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа  №3. Загрузка и первичный анализ структурированных данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
511	5	43	2	Модуль 2. Анализ и обработка данных на Python	Чтение и запись данных в форматах CSV, JSON, Parquet	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
512	5	44	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №4. Импорт и экспорт данных с использованием Pandas	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
513	5	45	2	Модуль 2. Анализ и обработка данных на Python	Работа с Excel-файлами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
514	5	46	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
515	5	47	2	Модуль 2. Анализ и обработка данных на Python	Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
516	5	48	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №6. Выполнение SQL-запросов из Python-скриптов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
517	5	49	2	Модуль 2. Анализ и обработка данных на Python	Фильтрация и сортировка данных в Pandas	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
518	5	50	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №7. Отбор строк и столбцов по условию	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
519	5	51	2	Модуль 2. Анализ и обработка данных на Python	Группировка данных и агрегация	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
520	5	52	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
521	5	53	2	Модуль 2. Анализ и обработка данных на Python	Сводные таблицы и кросстабуляции	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
522	5	54	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №9. Построение аналитических сводок по категориальным данным	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
523	5	55	2	Модуль 2. Анализ и обработка данных на Python	Объединение и слияние датафреймов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
524	5	56	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №10. Объединение таблиц по ключам (join/merge)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
525	5	57	2	Модуль 2. Анализ и обработка данных на Python	Работа с временными рядами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
526	5	58	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №11. Преобразование строковых дат и агрегация по периодам	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
527	5	59	2	Модуль 2. Анализ и обработка данных на Python	Обработка пропущенных данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
528	5	60	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №12. Поиск, удаление и импутация пропусков	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
529	5	61	2	Модуль 2. Анализ и обработка данных на Python	Работа с выбросами и аномалиями	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
530	5	62	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №13. Выявление выбросов методами IQR и Z-score	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
531	5	63	2	Модуль 2. Анализ и обработка данных на Python	Кодирование категориальных признаков	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
532	5	64	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №14. One-hot и label-кодирование	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
533	5	65	2	Модуль 2. Анализ и обработка данных на Python	Нормализация и стандартизация данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
534	5	66	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №15. Масштабирование признаков для ML-моделей	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
535	5	67	2	Модуль 2. Анализ и обработка данных на Python	Работа с большими наборами данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
536	5	68	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
537	5	69	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Matplotlib	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
538	5	70	2	Модуль 2. Анализ и обработка данных на Python	Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
539	5	71	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Seaborn	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
540	5	72	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
541	5	73	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
542	5	74	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №1. Постановка ML-задач на основе реальных датасетов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
543	5	75	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Подготовка данных для машинного обучения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
544	5	76	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №2. Разделение данных на обучающую и тестовую выборки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
545	5	77	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение первой модели: линейная регрессия	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
546	5	78	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
547	5	79	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
548	5	80	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №4. Оценка качества моделей на тестовой выборке	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
549	5	81	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Классификация: логистическая регрессия и kNN	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
550	5	82	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №5. Решение задач бинарной и многоклассовой классификации	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
551	5	83	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Деревья решений и случайный лес	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
552	5	84	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №6. Обучение и визуализация дерева решений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
553	5	85	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кластеризация: K-Means и иерархическая кластеризация	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
554	5	86	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №7. Группировка клиентов или объектов без разметки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
555	5	87	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Работа с несбалансированными данными	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
556	5	88	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №8. Применение oversampling (SMOTE) и undersampling	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
557	5	89	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кросс-валидация и подбор гиперпараметров	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
558	5	90	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №9. Подбор параметров с помощью GridSearchCV	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
559	5	91	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Основы нейросетей: перцептрон и многослойные сети	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
560	5	92	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
561	5	93	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение нейросетей на табличных данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
562	5	94	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
563	5	95	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в нейросети для обработки изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
564	5	96	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
565	5	97	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Сверточные нейронные сети (CNN): архитектура и принцип работы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
566	5	98	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №13. Построение первой CNN для классификации CIFAR-10	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
567	5	99	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение CNN на собственном датасете	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
568	5	100	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №14. Подготовка изображений и обучение модели под задачу	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
569	5	101	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
570	5	102	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №15. Применение аугментации и регуляризации в Keras	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
571	5	103	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Использование предобученных моделей (Transfer Learning)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
572	5	104	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
573	5	105	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Оценка и интерпретация моделей компьютерного зрения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
574	5	106	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №17. Визуализация активаций и ошибок предсказаний	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
575	5	107	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Применение сквозного ML-пайплайна для задачи классификации изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
576	5	108	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
577	5	109	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в компьютерное зрение: задачи и применения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
578	5	110	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №1. Установка OpenCV и загрузка изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
579	5	111	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
580	5	112	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с изображениями: цветовые пространства, каналы, гистограммы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
581	5	113	4	Модуль 4. Компьютерное зрение и обработка больших данных	Фильтрация и шумоподавление: Gaussian, Median, Bilateral	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
582	5	114	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №3. Улучшение качества изображений с OpenCV	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
583	5	115	4	Модуль 4. Компьютерное зрение и обработка больших данных	Геометрические преобразования: масштабирование, поворот, аффинные преобразования	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
584	5	116	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №4. Коррекция перспективы и выравнивание объектов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
585	5	117	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение границ и контуров (Canny, Sobel, Laplacian)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
586	5	118	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №5. Поиск и отрисовка контуров объектов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
587	5	119	4	Модуль 4. Компьютерное зрение и обработка больших данных	Сегментация изображений: пороговая, адаптивная, watershed	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
588	5	120	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №6. Выделение фона и переднего плана	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
589	5	121	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение объектов: метод скользящего окна, Haar-каскады	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
590	5	122	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
591	5	123	4	Модуль 4. Компьютерное зрение и обработка больших данных	Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
592	5	124	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
593	5	125	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с видео: чтение, запись, обработка кадров	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
594	5	126	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №9. Обнаружение движущихся объектов в видеопотоке	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
595	5	127	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обработка больших объёмов изображений (пакетная обработка)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
596	5	128	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №10. Создание пайплайна для обработки тысяч изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
597	5	129	4	Модуль 4. Компьютерное зрение и обработка больших данных	Анализ структурированных и полуструктурированных данных в контексте Big Data	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
598	5	130	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
599	5	131	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в распределённые вычисления: Dask и локальные кластеры	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
600	5	132	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №12. Параллельная обработка данных без облачных сервисов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
601	5	133	4	Модуль 4. Компьютерное зрение и обработка больших данных	Хранение и обработка данных: Apache Parquet, DuckDB	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
602	5	134	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №13. Эффективное хранение и запросы к большим данным	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
603	5	135	4	Модуль 4. Компьютерное зрение и обработка больших данных	Основы MLOps: сохранение и загрузка моделей, логирование экспериментов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
604	5	136	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
605	5	137	4	Модуль 4. Компьютерное зрение и обработка больших данных	Развёртывание ML-модели: локальный REST API на Flask/FastAPI	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
606	5	138	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №15. Создание API для получения предсказаний модели по HTTP	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
607	5	139	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компьютерного зрения в аналитические системы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
608	5	140	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
609	5	141	4	Модуль 4. Компьютерное зрение и обработка больших данных	Этические и правовые аспекты работы со зрительными данными	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
610	5	142	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
611	5	143	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
612	5	144	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
613	6	1	1	Модуль 1. Программирование на языке Python	Введение в Python и установка среды разработки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
614	6	2	1	Модуль 1. Программирование на языке Python	Практическая работа №1. Установка Python и запуск первой программы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
615	6	3	1	Модуль 1. Программирование на языке Python	Переменные и типы данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
616	6	4	1	Модуль 1. Программирование на языке Python	Практическая работа №2. Работа с переменными и типами данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
617	6	5	1	Модуль 1. Программирование на языке Python	Операторы в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
618	6	6	1	Модуль 1. Программирование на языке Python	Практическая работа №3. Вычисления и логические операции в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
619	6	7	1	Модуль 1. Программирование на языке Python	Условные конструкции	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
620	6	8	1	Модуль 1. Программирование на языке Python	Практическая работа №4. Программы с условными операторами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
621	6	9	1	Модуль 1. Программирование на языке Python	Циклы в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
622	6	10	1	Модуль 1. Программирование на языке Python	Практическая работа №5. Написание циклических программ	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
623	6	11	1	Модуль 1. Программирование на языке Python	Работа со строками	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
624	6	12	1	Модуль 1. Программирование на языке Python	Практическая работа №6. Обработка строк	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
625	6	13	1	Модуль 1. Программирование на языке Python	Списки и кортежи	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
626	6	14	1	Модуль 1. Программирование на языке Python	Практическая работа №7. Работа со списками	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
627	6	15	1	Модуль 1. Программирование на языке Python	Словари и множества	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
628	6	16	1	Модуль 1. Программирование на языке Python	Практическая работа №8. Использование словарей	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
629	6	17	1	Модуль 1. Программирование на языке Python	Функции в Python: основы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
630	6	18	1	Модуль 1. Программирование на языке Python	Практическая работа №9. Создание пользовательских функций	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
631	6	19	1	Модуль 1. Программирование на языке Python	Передача аргументов, *args, **kwargs	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
632	6	20	1	Модуль 1. Программирование на языке Python	Практическая работа №10. Работа с *args и **kwargs	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
633	6	21	1	Модуль 1. Программирование на языке Python	Работа с файлами: чтение и запись	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
634	6	22	1	Модуль 1. Программирование на языке Python	Практическая работа №11. Работа с файлами: чтение и запись данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
635	6	23	1	Модуль 1. Программирование на языке Python	Работа с CSV и JSON файлами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
636	6	24	1	Модуль 1. Программирование на языке Python	Практическая работа №12. Чтение и запись данных в CSV и JSON	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
637	6	25	1	Модуль 1. Программирование на языке Python	Обработка ошибок и исключения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
638	6	26	1	Модуль 1. Программирование на языке Python	Практическая работа №13. Обработка ошибок в программах	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
639	6	27	1	Модуль 1. Программирование на языке Python	Регулярные выражения (re)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
640	6	28	1	Модуль 1. Программирование на языке Python	Практическая работа №14. Поиск и замена данных с использованием regex	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
641	6	29	1	Модуль 1. Программирование на языке Python	Основы ООП в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
642	6	30	1	Модуль 1. Программирование на языке Python	Практическая работа №15. Создание классов и объектов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
643	6	31	1	Модуль 1. Программирование на языке Python	Наследование и полиморфизм	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
644	6	32	1	Модуль 1. Программирование на языке Python	Практическая работа №16. Реализация наследования в Python	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
645	6	33	1	Модуль 1. Программирование на языке Python	Генераторы списков и lambda-функции	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
646	6	34	1	Модуль 1. Программирование на языке Python	Практическая работа №17. Оптимизация кода с генераторами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
647	6	35	1	Модуль 1. Программирование на языке Python	Модули и виртуальные окружения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
648	6	36	1	Модуль 1. Программирование на языке Python	Практическая работа №18. Создание и использование venv	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
649	6	37	2	Модуль 2. Анализ и обработка данных на Python	Введение в анализ данных и Big Data	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
650	6	38	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
651	6	39	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой NumPy	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
652	6	40	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №2. Создание и манипуляции с многомерными массивами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
653	6	41	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой Pandas	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
654	6	42	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа  №3. Загрузка и первичный анализ структурированных данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
655	6	43	2	Модуль 2. Анализ и обработка данных на Python	Чтение и запись данных в форматах CSV, JSON, Parquet	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
656	6	44	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №4. Импорт и экспорт данных с использованием Pandas	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
657	6	45	2	Модуль 2. Анализ и обработка данных на Python	Работа с Excel-файлами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
658	6	46	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
659	6	47	2	Модуль 2. Анализ и обработка данных на Python	Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
660	6	48	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №6. Выполнение SQL-запросов из Python-скриптов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
661	6	49	2	Модуль 2. Анализ и обработка данных на Python	Фильтрация и сортировка данных в Pandas	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
662	6	50	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №7. Отбор строк и столбцов по условию	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
663	6	51	2	Модуль 2. Анализ и обработка данных на Python	Группировка данных и агрегация	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
664	6	52	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
665	6	53	2	Модуль 2. Анализ и обработка данных на Python	Сводные таблицы и кросстабуляции	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
666	6	54	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №9. Построение аналитических сводок по категориальным данным	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
667	6	55	2	Модуль 2. Анализ и обработка данных на Python	Объединение и слияние датафреймов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
668	6	56	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №10. Объединение таблиц по ключам (join/merge)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
669	6	57	2	Модуль 2. Анализ и обработка данных на Python	Работа с временными рядами	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
670	6	58	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №11. Преобразование строковых дат и агрегация по периодам	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
671	6	59	2	Модуль 2. Анализ и обработка данных на Python	Обработка пропущенных данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
672	6	60	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №12. Поиск, удаление и импутация пропусков	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
673	6	61	2	Модуль 2. Анализ и обработка данных на Python	Работа с выбросами и аномалиями	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
674	6	62	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №13. Выявление выбросов методами IQR и Z-score	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
675	6	63	2	Модуль 2. Анализ и обработка данных на Python	Кодирование категориальных признаков	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
676	6	64	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №14. One-hot и label-кодирование	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
677	6	65	2	Модуль 2. Анализ и обработка данных на Python	Нормализация и стандартизация данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
678	6	66	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №15. Масштабирование признаков для ML-моделей	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
679	6	67	2	Модуль 2. Анализ и обработка данных на Python	Работа с большими наборами данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
680	6	68	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
681	6	69	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Matplotlib	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
682	6	70	2	Модуль 2. Анализ и обработка данных на Python	Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
683	6	71	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Seaborn	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
684	6	72	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
685	6	73	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
686	6	74	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №1. Постановка ML-задач на основе реальных датасетов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
687	6	75	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Подготовка данных для машинного обучения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
688	6	76	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №2. Разделение данных на обучающую и тестовую выборки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
689	6	77	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение первой модели: линейная регрессия	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
690	6	78	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
691	6	79	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
692	6	80	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №4. Оценка качества моделей на тестовой выборке	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
693	6	81	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Классификация: логистическая регрессия и kNN	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
694	6	82	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №5. Решение задач бинарной и многоклассовой классификации	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
695	6	83	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Деревья решений и случайный лес	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
696	6	84	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №6. Обучение и визуализация дерева решений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
697	6	85	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кластеризация: K-Means и иерархическая кластеризация	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
698	6	86	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №7. Группировка клиентов или объектов без разметки	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
699	6	87	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Работа с несбалансированными данными	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
700	6	88	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №8. Применение oversampling (SMOTE) и undersampling	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
701	6	89	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кросс-валидация и подбор гиперпараметров	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
702	6	90	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №9. Подбор параметров с помощью GridSearchCV	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
703	6	91	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Основы нейросетей: перцептрон и многослойные сети	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
704	6	92	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
705	6	93	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение нейросетей на табличных данных	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
706	6	94	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
707	6	95	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в нейросети для обработки изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
708	6	96	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
709	6	97	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Сверточные нейронные сети (CNN): архитектура и принцип работы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
710	6	98	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №13. Построение первой CNN для классификации CIFAR-10	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
711	6	99	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение CNN на собственном датасете	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
712	6	100	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №14. Подготовка изображений и обучение модели под задачу	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
713	6	101	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
714	6	102	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №15. Применение аугментации и регуляризации в Keras	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
715	6	103	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Использование предобученных моделей (Transfer Learning)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
716	6	104	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
717	6	105	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Оценка и интерпретация моделей компьютерного зрения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
718	6	106	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №17. Визуализация активаций и ошибок предсказаний	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
719	6	107	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Применение сквозного ML-пайплайна для задачи классификации изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
720	6	108	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
721	6	109	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в компьютерное зрение: задачи и применения	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
722	6	110	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №1. Установка OpenCV и загрузка изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
723	6	111	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
724	6	112	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с изображениями: цветовые пространства, каналы, гистограммы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
725	6	113	4	Модуль 4. Компьютерное зрение и обработка больших данных	Фильтрация и шумоподавление: Gaussian, Median, Bilateral	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
726	6	114	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №3. Улучшение качества изображений с OpenCV	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
727	6	115	4	Модуль 4. Компьютерное зрение и обработка больших данных	Геометрические преобразования: масштабирование, поворот, аффинные преобразования	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
728	6	116	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №4. Коррекция перспективы и выравнивание объектов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
729	6	117	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение границ и контуров (Canny, Sobel, Laplacian)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
730	6	118	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №5. Поиск и отрисовка контуров объектов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
731	6	119	4	Модуль 4. Компьютерное зрение и обработка больших данных	Сегментация изображений: пороговая, адаптивная, watershed	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
732	6	120	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №6. Выделение фона и переднего плана	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
733	6	121	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение объектов: метод скользящего окна, Haar-каскады	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
734	6	122	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
735	6	123	4	Модуль 4. Компьютерное зрение и обработка больших данных	Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
736	6	124	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
737	6	125	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с видео: чтение, запись, обработка кадров	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
738	6	126	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №9. Обнаружение движущихся объектов в видеопотоке	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
739	6	127	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обработка больших объёмов изображений (пакетная обработка)	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
740	6	128	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №10. Создание пайплайна для обработки тысяч изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
741	6	129	4	Модуль 4. Компьютерное зрение и обработка больших данных	Анализ структурированных и полуструктурированных данных в контексте Big Data	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
742	6	130	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
743	6	131	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в распределённые вычисления: Dask и локальные кластеры	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
744	6	132	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №12. Параллельная обработка данных без облачных сервисов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
745	6	133	4	Модуль 4. Компьютерное зрение и обработка больших данных	Хранение и обработка данных: Apache Parquet, DuckDB	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
746	6	134	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №13. Эффективное хранение и запросы к большим данным	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
747	6	135	4	Модуль 4. Компьютерное зрение и обработка больших данных	Основы MLOps: сохранение и загрузка моделей, логирование экспериментов	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
748	6	136	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
749	6	137	4	Модуль 4. Компьютерное зрение и обработка больших данных	Развёртывание ML-модели: локальный REST API на Flask/FastAPI	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
750	6	138	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №15. Создание API для получения предсказаний модели по HTTP	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
751	6	139	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компьютерного зрения в аналитические системы	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
752	6	140	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
753	6	141	4	Модуль 4. Компьютерное зрение и обработка больших данных	Этические и правовые аспекты работы со зрительными данными	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
754	6	142	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
755	6	143	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
756	6	144	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N	\N	1	2026-03-11 15:18:20.036092
757	7	1	1	Модуль 1. Программирование на языке Python	Введение в Python и установка среды разработки	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
758	7	2	1	Модуль 1. Программирование на языке Python	Практическая работа №1. Установка Python и запуск первой программы	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
759	7	3	1	Модуль 1. Программирование на языке Python	Переменные и типы данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
760	7	4	1	Модуль 1. Программирование на языке Python	Практическая работа №2. Работа с переменными и типами данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
761	7	5	1	Модуль 1. Программирование на языке Python	Операторы в Python	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
762	7	6	1	Модуль 1. Программирование на языке Python	Практическая работа №3. Вычисления и логические операции в Python	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
763	7	7	1	Модуль 1. Программирование на языке Python	Условные конструкции	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
764	7	8	1	Модуль 1. Программирование на языке Python	Практическая работа №4. Программы с условными операторами	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
765	7	9	1	Модуль 1. Программирование на языке Python	Циклы в Python	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
766	7	10	1	Модуль 1. Программирование на языке Python	Практическая работа №5. Написание циклических программ	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
767	7	11	1	Модуль 1. Программирование на языке Python	Работа со строками	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
768	7	12	1	Модуль 1. Программирование на языке Python	Практическая работа №6. Обработка строк	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
769	7	13	1	Модуль 1. Программирование на языке Python	Списки и кортежи	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
770	7	14	1	Модуль 1. Программирование на языке Python	Практическая работа №7. Работа со списками	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
771	7	15	1	Модуль 1. Программирование на языке Python	Словари и множества	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
772	7	16	1	Модуль 1. Программирование на языке Python	Практическая работа №8. Использование словарей	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
773	7	17	1	Модуль 1. Программирование на языке Python	Функции в Python: основы	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
774	7	18	1	Модуль 1. Программирование на языке Python	Практическая работа №9. Создание пользовательских функций	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
775	7	19	1	Модуль 1. Программирование на языке Python	Передача аргументов, *args, **kwargs	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
776	7	20	1	Модуль 1. Программирование на языке Python	Практическая работа №10. Работа с *args и **kwargs	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
777	7	21	1	Модуль 1. Программирование на языке Python	Работа с файлами: чтение и запись	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
778	7	22	1	Модуль 1. Программирование на языке Python	Практическая работа №11. Работа с файлами: чтение и запись данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
779	7	23	1	Модуль 1. Программирование на языке Python	Работа с CSV и JSON файлами	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
780	7	24	1	Модуль 1. Программирование на языке Python	Практическая работа №12. Чтение и запись данных в CSV и JSON	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
781	7	25	1	Модуль 1. Программирование на языке Python	Обработка ошибок и исключения	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
782	7	26	1	Модуль 1. Программирование на языке Python	Практическая работа №13. Обработка ошибок в программах	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
783	7	27	1	Модуль 1. Программирование на языке Python	Регулярные выражения (re)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
784	7	28	1	Модуль 1. Программирование на языке Python	Практическая работа №14. Поиск и замена данных с использованием regex	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
785	7	29	1	Модуль 1. Программирование на языке Python	Основы ООП в Python	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
786	7	30	1	Модуль 1. Программирование на языке Python	Практическая работа №15. Создание классов и объектов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
787	7	31	1	Модуль 1. Программирование на языке Python	Наследование и полиморфизм	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
788	7	32	1	Модуль 1. Программирование на языке Python	Практическая работа №16. Реализация наследования в Python	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
789	7	33	1	Модуль 1. Программирование на языке Python	Генераторы списков и lambda-функции	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
790	7	34	1	Модуль 1. Программирование на языке Python	Практическая работа №17. Оптимизация кода с генераторами	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
791	7	35	1	Модуль 1. Программирование на языке Python	Модули и виртуальные окружения	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
792	7	36	1	Модуль 1. Программирование на языке Python	Практическая работа №18. Создание и использование venv	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
793	7	37	2	Модуль 2. Анализ и обработка данных на Python	Введение в анализ данных и Big Data	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
794	7	38	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №1. Установка и настройка Anaconda, Jupyter Notebook	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
795	7	39	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой NumPy	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
796	7	40	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №2. Создание и манипуляции с многомерными массивами	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
797	7	41	2	Модуль 2. Анализ и обработка данных на Python	Основы работы с библиотекой Pandas	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
798	7	42	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа  №3. Загрузка и первичный анализ структурированных данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
799	7	43	2	Модуль 2. Анализ и обработка данных на Python	Чтение и запись данных в форматах CSV, JSON, Parquet	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
800	7	44	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №4. Импорт и экспорт данных с использованием Pandas	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
801	7	45	2	Модуль 2. Анализ и обработка данных на Python	Работа с Excel-файлами	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
802	7	46	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №5. Обработка табличных данных из Excel без внешних облачных сервисов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
803	7	47	2	Модуль 2. Анализ и обработка данных на Python	Подключение к локальным базам данных (SQLite, PostgreSQL) через SQLAlchemy	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
804	7	48	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №6. Выполнение SQL-запросов из Python-скриптов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
805	7	49	2	Модуль 2. Анализ и обработка данных на Python	Фильтрация и сортировка данных в Pandas	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
806	7	50	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №7. Отбор строк и столбцов по условию	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
807	7	51	2	Модуль 2. Анализ и обработка данных на Python	Группировка данных и агрегация	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
808	7	52	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №8. Расчёт статистик по группам (среднее, сумма, количество)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
809	7	53	2	Модуль 2. Анализ и обработка данных на Python	Сводные таблицы и кросстабуляции	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
810	7	54	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №9. Построение аналитических сводок по категориальным данным	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
811	7	55	2	Модуль 2. Анализ и обработка данных на Python	Объединение и слияние датафреймов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
812	7	56	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №10. Объединение таблиц по ключам (join/merge)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
813	7	57	2	Модуль 2. Анализ и обработка данных на Python	Работа с временными рядами	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
814	7	58	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №11. Преобразование строковых дат и агрегация по периодам	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
815	7	59	2	Модуль 2. Анализ и обработка данных на Python	Обработка пропущенных данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
816	7	60	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №12. Поиск, удаление и импутация пропусков	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
817	7	61	2	Модуль 2. Анализ и обработка данных на Python	Работа с выбросами и аномалиями	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
818	7	62	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №13. Выявление выбросов методами IQR и Z-score	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
819	7	63	2	Модуль 2. Анализ и обработка данных на Python	Кодирование категориальных признаков	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
820	7	64	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №14. One-hot и label-кодирование	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
821	7	65	2	Модуль 2. Анализ и обработка данных на Python	Нормализация и стандартизация данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
822	7	66	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №15. Масштабирование признаков для ML-моделей	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
823	7	67	2	Модуль 2. Анализ и обработка данных на Python	Работа с большими наборами данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
851	7	95	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в нейросети для обработки изображений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
824	7	68	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №16. Оптимизация типов данных и использование chunk-загрузки	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
825	7	69	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Matplotlib	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
826	7	70	2	Модуль 2. Анализ и обработка данных на Python	Практическая  работа №17. Построение гистограмм, boxplot, scatter и линейных графиков	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
827	7	71	2	Модуль 2. Анализ и обработка данных на Python	Визуализация данных с помощью Seaborn	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
828	7	72	2	Модуль 2. Анализ и обработка данных на Python	Практическая работа №18. Построение тепловых карт, парных графиков и распределений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
829	7	73	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Введение в машинное обучение: типы задач (классификация, регрессия, кластеризация)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
830	7	74	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №1. Постановка ML-задач на основе реальных датасетов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
831	7	75	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Подготовка данных для машинного обучения	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
832	7	76	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №2. Разделение данных на обучающую и тестовую выборки	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
833	7	77	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение первой модели: линейная регрессия	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
834	7	78	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №3. Прогнозирование числовых значений с помощью scikit-learn	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
835	7	79	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Метрики качества моделей: MAE, MSE, R², accuracy, precision, recall	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
836	7	80	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №4. Оценка качества моделей на тестовой выборке	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
837	7	81	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Классификация: логистическая регрессия и kNN	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
838	7	82	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №5. Решение задач бинарной и многоклассовой классификации	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
839	7	83	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Деревья решений и случайный лес	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
840	7	84	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №6. Обучение и визуализация дерева решений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
841	7	85	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кластеризация: K-Means и иерархическая кластеризация	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
842	7	86	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №7. Группировка клиентов или объектов без разметки	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
843	7	87	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Работа с несбалансированными данными	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
844	7	88	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №8. Применение oversampling (SMOTE) и undersampling	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
845	7	89	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Кросс-валидация и подбор гиперпараметров	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
846	7	90	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №9. Подбор параметров с помощью GridSearchCV	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
847	7	91	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Основы нейросетей: перцептрон и многослойные сети	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
848	7	92	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №10. Создание простой нейросети с помощью Keras/TensorFlow	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
849	7	93	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение нейросетей на табличных данных	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
850	7	94	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа  №11. Построение модели для предсказания с числовыми/категориальными признаками	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
852	7	96	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №12. Загрузка и предобработка изображений с помощью OpenCV и PIL	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
853	7	97	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Сверточные нейронные сети (CNN): архитектура и принцип работы	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
854	7	98	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №13. Построение первой CNN для классификации CIFAR-10	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
855	7	99	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Обучение CNN на собственном датасете	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
856	7	100	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №14. Подготовка изображений и обучение модели под задачу	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
857	7	101	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Техники ускорения и уменьшения переобучения (Dropout, BatchNorm, Data Augmentation)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
858	7	102	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №15. Применение аугментации и регуляризации в Keras	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
859	7	103	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Использование предобученных моделей (Transfer Learning)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
860	7	104	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №16. Тонкая настройка MobileNet/VGG16 под собственную задачу	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
861	7	105	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Оценка и интерпретация моделей компьютерного зрения	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
862	7	106	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №17. Визуализация активаций и ошибок предсказаний	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
863	7	107	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Применение сквозного ML-пайплайна для задачи классификации изображений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
864	7	108	3	Модуль 3. Основы машинного обучения и искусственного интеллекта	Практическая работа №18. Реализация последовательной обработки: загрузка, предобработка, обучение, оценка модели	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
865	7	109	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в компьютерное зрение: задачи и применения	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
866	7	110	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №1. Установка OpenCV и загрузка изображений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
867	7	111	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №2. Преобразование RGB → HSV, выделение объектов по цвету	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
868	7	112	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с изображениями: цветовые пространства, каналы, гистограммы	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
869	7	113	4	Модуль 4. Компьютерное зрение и обработка больших данных	Фильтрация и шумоподавление: Gaussian, Median, Bilateral	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
870	7	114	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №3. Улучшение качества изображений с OpenCV	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
871	7	115	4	Модуль 4. Компьютерное зрение и обработка больших данных	Геометрические преобразования: масштабирование, поворот, аффинные преобразования	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
872	7	116	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №4. Коррекция перспективы и выравнивание объектов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
873	7	117	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение границ и контуров (Canny, Sobel, Laplacian)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
874	7	118	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №5. Поиск и отрисовка контуров объектов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
875	7	119	4	Модуль 4. Компьютерное зрение и обработка больших данных	Сегментация изображений: пороговая, адаптивная, watershed	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
876	7	120	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №6. Выделение фона и переднего плана	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
877	7	121	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обнаружение объектов: метод скользящего окна, Haar-каскады	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
878	7	122	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №7. Обнаружение лиц и глаз с помощью предобученных каскадов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
879	7	123	4	Модуль 4. Компьютерное зрение и обработка больших данных	Извлечение признаков: SIFT, SURF (через альтернативы, совместимые с РФ)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
880	7	124	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №8. Сравнение изображений по ключевым точкам (ORB, BRISK)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
881	7	125	4	Модуль 4. Компьютерное зрение и обработка больших данных	Работа с видео: чтение, запись, обработка кадров	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
882	7	126	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №9. Обнаружение движущихся объектов в видеопотоке	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
883	7	127	4	Модуль 4. Компьютерное зрение и обработка больших данных	Обработка больших объёмов изображений (пакетная обработка)	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
884	7	128	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №10. Создание пайплайна для обработки тысяч изображений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
885	7	129	4	Модуль 4. Компьютерное зрение и обработка больших данных	Анализ структурированных и полуструктурированных данных в контексте Big Data	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
886	7	130	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №11. Работа с датасетами >1 ГБ через chunking и Dask	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
887	7	131	4	Модуль 4. Компьютерное зрение и обработка больших данных	Введение в распределённые вычисления: Dask и локальные кластеры	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
888	7	132	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №12. Параллельная обработка данных без облачных сервисов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
889	7	133	4	Модуль 4. Компьютерное зрение и обработка больших данных	Хранение и обработка данных: Apache Parquet, DuckDB	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
890	7	134	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №13. Эффективное хранение и запросы к большим данным	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
891	7	135	4	Модуль 4. Компьютерное зрение и обработка больших данных	Основы MLOps: сохранение и загрузка моделей, логирование экспериментов	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
892	7	136	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №14. Сохранение модели в формате .h5 / .pkl и восстановление	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
893	7	137	4	Модуль 4. Компьютерное зрение и обработка больших данных	Развёртывание ML-модели: локальный REST API на Flask/FastAPI	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
894	7	138	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №15. Создание API для получения предсказаний модели по HTTP	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
895	7	139	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компьютерного зрения в аналитические системы	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
896	7	140	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №16. Генерация отчётов с визуализацией результатов обработки изображений	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
897	7	141	4	Модуль 4. Компьютерное зрение и обработка больших данных	Этические и правовые аспекты работы со зрительными данными	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
898	7	142	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №17. Обезличивание изображений и соблюдение требований к персональным данным	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
899	7	143	4	Модуль 4. Компьютерное зрение и обработка больших данных	Интеграция компонентов компьютерного зрения и анализа данных в единую рабочую схему	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
900	7	144	4	Модуль 4. Компьютерное зрение и обработка больших данных	Практическая работа №18. Последовательная реализация этапов: пакетная обработка изображений, применение модели, генерация отчёта	\N	\N	\N	\N	1	2026-03-12 12:32:29.694565
\.


--
-- Name: contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contacts_id_seq', 18, true);


--
-- Name: contract_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contract_id_seq', 185, true);


--
-- Name: contract_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contract_type_id_seq', 12, true);


--
-- Name: education_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.education_id_seq', 17, true);


--
-- Name: holiday_calendar_day_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.holiday_calendar_day_id_seq', 4, true);


--
-- Name: learning_program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.learning_program_id_seq', 482, true);


--
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.organization_id_seq', 1, true);


--
-- Name: passport_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passport_id_seq', 5, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.person_id_seq', 7, true);


--
-- Name: program_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_module_id_seq', 136, true);


--
-- Name: program_view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_view_id_seq', 1, false);


--
-- Name: teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_id_seq', 1, true);


--
-- Name: workload_batch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workload_batch_id_seq', 4, true);


--
-- Name: workload_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workload_document_id_seq', 7, true);


--
-- Name: workload_schedule_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workload_schedule_entry_id_seq', 900, true);


--
-- Name: base_education base_education_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.base_education
    ADD CONSTRAINT base_education_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: contract contract_contract_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_contract_number_key UNIQUE (contract_number);


--
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- Name: contract_type contract_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_type
    ADD CONSTRAINT contract_type_pkey PRIMARY KEY (id);


--
-- Name: education edu_series_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT edu_series_number UNIQUE (series, number);


--
-- Name: education_level education_level_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education_level
    ADD CONSTRAINT education_level_pkey PRIMARY KEY (id);


--
-- Name: education education_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_pkey PRIMARY KEY (id);


--
-- Name: gender gender_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id);


--
-- Name: holiday_calendar_day holiday_calendar_day_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holiday_calendar_day
    ADD CONSTRAINT holiday_calendar_day_pkey PRIMARY KEY (id);


--
-- Name: learning_program learning_program_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_program
    ADD CONSTRAINT learning_program_pkey PRIMARY KEY (id);


--
-- Name: organization organization_inn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_inn_key UNIQUE (inn);


--
-- Name: organization organization_ogrn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_ogrn_key UNIQUE (ogrn);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: passport passport_person_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_person_id_key UNIQUE (person_id);


--
-- Name: passport passport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: passport passport_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_unique UNIQUE (series, number);


--
-- Name: person person_inn_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_inn_key UNIQUE (inn);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: person person_snils_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_snils_key UNIQUE (snils);


--
-- Name: program_module program_module_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_module
    ADD CONSTRAINT program_module_pkey PRIMARY KEY (id);


--
-- Name: program_view program_view_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_view
    ADD CONSTRAINT program_view_pkey PRIMARY KEY (id);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- Name: workload_batch workload_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_batch
    ADD CONSTRAINT workload_batch_pkey PRIMARY KEY (id);


--
-- Name: workload_document workload_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_document
    ADD CONSTRAINT workload_document_pkey PRIMARY KEY (id);


--
-- Name: workload_schedule_entry workload_schedule_entry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_schedule_entry
    ADD CONSTRAINT workload_schedule_entry_pkey PRIMARY KEY (id);


--
-- Name: idx_contacts_phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contacts_phone ON public.contacts USING btree (contact_phone);


--
-- Name: idx_passport_series_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_passport_series_number ON public.passport USING btree (series, number);


--
-- Name: idx_person_inn; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_inn ON public.person USING btree (inn);


--
-- Name: idx_person_snils; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_snils ON public.person USING btree (snils);


--
-- Name: idx_program_module_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_program_module_number ON public.program_module USING btree (program_id, module_number);


--
-- Name: idx_program_module_program_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_program_module_program_id ON public.program_module USING btree (program_id);


--
-- Name: idx_teacher_full_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teacher_full_name ON public.teacher USING btree (full_name);


--
-- Name: ix_holiday_calendar_day_holiday_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_holiday_calendar_day_holiday_date ON public.holiday_calendar_day USING btree (holiday_date);


--
-- Name: ix_workload_batch_program_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_batch_program_id ON public.workload_batch USING btree (program_id);


--
-- Name: ix_workload_batch_teacher_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_batch_teacher_id ON public.workload_batch USING btree (teacher_id);


--
-- Name: ix_workload_document_batch_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_document_batch_id ON public.workload_document USING btree (batch_id);


--
-- Name: ix_workload_document_contract_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_document_contract_id ON public.workload_document USING btree (contract_id);


--
-- Name: ix_workload_document_listener_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_document_listener_id ON public.workload_document USING btree (listener_id);


--
-- Name: ix_workload_document_program_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_document_program_id ON public.workload_document USING btree (program_id);


--
-- Name: ix_workload_document_teacher_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_document_teacher_id ON public.workload_document USING btree (teacher_id);


--
-- Name: ix_workload_schedule_entry_document_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_workload_schedule_entry_document_id ON public.workload_schedule_entry USING btree (workload_document_id);


--
-- Name: contract contract_contract_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_contract_type_id_fkey FOREIGN KEY (contract_type_id) REFERENCES public.contract_type(id);


--
-- Name: contract contract_listener_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_listener_id_fkey FOREIGN KEY (listener_id) REFERENCES public.person(id);


--
-- Name: contract contract_payer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_payer_id_fkey FOREIGN KEY (payer_id) REFERENCES public.person(id);


--
-- Name: contract contract_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.learning_program(id);


--
-- Name: education education_base_education_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_base_education_id_fkey FOREIGN KEY (base_education_id) REFERENCES public.base_education(id);


--
-- Name: education education_education_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_education_level_id_fkey FOREIGN KEY (education_level_id) REFERENCES public.education_level(id);


--
-- Name: education education_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.education
    ADD CONSTRAINT education_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: person fk_person_contacts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT fk_person_contacts FOREIGN KEY (contacts_id) REFERENCES public.contacts(id) ON DELETE SET NULL;


--
-- Name: program_module fk_program_module_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_module
    ADD CONSTRAINT fk_program_module_program FOREIGN KEY (program_id) REFERENCES public.learning_program(id) ON DELETE CASCADE;


--
-- Name: workload_batch fk_workload_batch_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_batch
    ADD CONSTRAINT fk_workload_batch_program FOREIGN KEY (program_id) REFERENCES public.learning_program(id) ON DELETE RESTRICT;


--
-- Name: workload_batch fk_workload_batch_teacher; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_batch
    ADD CONSTRAINT fk_workload_batch_teacher FOREIGN KEY (teacher_id) REFERENCES public.teacher(id) ON DELETE SET NULL;


--
-- Name: workload_document fk_workload_document_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_document
    ADD CONSTRAINT fk_workload_document_program FOREIGN KEY (program_id) REFERENCES public.learning_program(id) ON DELETE RESTRICT;


--
-- Name: workload_document fk_workload_document_teacher; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_document
    ADD CONSTRAINT fk_workload_document_teacher FOREIGN KEY (teacher_id) REFERENCES public.teacher(id) ON DELETE SET NULL;


--
-- Name: workload_schedule_entry fk_workload_schedule_entry_document; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_schedule_entry
    ADD CONSTRAINT fk_workload_schedule_entry_document FOREIGN KEY (workload_document_id) REFERENCES public.workload_document(id) ON DELETE CASCADE;


--
-- Name: learning_program learning_program_program_view_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learning_program
    ADD CONSTRAINT learning_program_program_view_id_fkey FOREIGN KEY (program_view_id) REFERENCES public.program_view(id);


--
-- Name: passport passport_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passport
    ADD CONSTRAINT passport_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: person person_gender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.gender(id);


--
-- PostgreSQL database dump complete
--

