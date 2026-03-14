-- ============================================
-- Database Initialization Script
-- MPT2512 Contract Management System
-- ============================================
-- This script creates all tables and populates reference data
-- Run this on a fresh PostgreSQL database

-- Drop existing tables if they exist (cascade to drop foreign keys)
DROP TABLE IF EXISTS workload_schedule_entry CASCADE;
DROP TABLE IF EXISTS workload_document CASCADE;
DROP TABLE IF EXISTS workload_batch CASCADE;
DROP TABLE IF EXISTS contract CASCADE;
DROP TABLE IF EXISTS passport CASCADE;
DROP TABLE IF EXISTS education CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS program_module CASCADE;
DROP TABLE IF EXISTS learning_program CASCADE;
DROP TABLE IF EXISTS organization CASCADE;
DROP TABLE IF EXISTS contacts CASCADE;
DROP TABLE IF EXISTS holiday_calendar_day CASCADE;
DROP TABLE IF EXISTS teacher CASCADE;
DROP TABLE IF EXISTS contract_type CASCADE;
DROP TABLE IF EXISTS program_view CASCADE;
DROP TABLE IF EXISTS base_education CASCADE;
DROP TABLE IF EXISTS education_level CASCADE;
DROP TABLE IF EXISTS gender CASCADE;
DROP TYPE IF EXISTS person_type CASCADE;

-- ============================================
-- ENUMS
-- ============================================

CREATE TYPE person_type AS ENUM (
    'individual',
    'legal_entity'
);

-- ============================================
-- REFERENCE TABLES (Справочники)
-- ============================================

-- Gender (Пол)
CREATE TABLE gender (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO gender (id, name) VALUES
(1, 'Мужской'),
(2, 'Женский');

-- Base Education (Базовое образование)
CREATE TABLE base_education (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO base_education (id, name) VALUES
(1, 'Среднее'),
(2, 'Среднее профиссиональное'),
(3, 'Высшее');

-- Education Level (Уровень образования)
CREATE TABLE education_level (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO education_level (id, name) VALUES
(1, 'Бакалавр'),
(2, 'Магистратура'),
(3, 'Специалитет');

-- Program View (Вид программы: ДОП, ПП, ПК)
CREATE TABLE program_view (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

INSERT INTO program_view (id, name) VALUES
(1, 'ДОП'),
(2, 'ПП'),
(3, 'ПК');

-- Contract Type (Тип договора)
CREATE TABLE contract_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    file_path VARCHAR(1000) NOT NULL DEFAULT ''
);

INSERT INTO contract_type (id, name, file_path) VALUES
(1, 'Договор ДОП физических лиц (трёхсторонний)', 'C:\Dogovora\Договор ДОП физ лиц.docx'),
(2, 'Договор ПК физических лиц (двухсторонний)', 'C:\Dogovora\Договор ПК физ лиц.docx'),
(3, 'Договор ДОП юридических лиц (трёхсторонний)', 'C:\Dogovora\Договор ДОП юр лиц.docx'),
(4, 'Договор ПП физических лиц (двухсторонний)', 'C:\Dogovora\Договор ПП физ лиц.docx'),
(5, 'Договор ПП юридических лиц (двухсторонний)', 'C:\Dogovora\Договор ПП юр лиц.docx');

-- ============================================
-- MAIN TABLES
-- ============================================

-- Contacts (Контакты)
CREATE TABLE contacts (
    id BIGSERIAL PRIMARY KEY,
    residence_address VARCHAR(1000),
    home_phone VARCHAR(50),
    contact_phone VARCHAR(50) NOT NULL,
    work_phone VARCHAR(50),
    email VARCHAR(254),
    postal_code VARCHAR(20),
    region VARCHAR(200),
    city VARCHAR(200),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Organization (Организация)
CREATE TABLE organization (
    id BIGSERIAL PRIMARY KEY,
    organization_name VARCHAR(500) NOT NULL,
    director_fio VARCHAR(300) NOT NULL,
    ogrn VARCHAR(13) NOT NULL CHECK (ogrn ~ '^[0-9]{13}$'),
    inn VARCHAR(10) NOT NULL CHECK (inn ~ '^[0-9]{10}$'),
    kpp VARCHAR(9) NOT NULL CHECK (kpp ~ '^[0-9]{9}$'),
    legal_address VARCHAR(1000) NOT NULL,
    email VARCHAR(254),
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Person (Физическое лицо)
CREATE TABLE person (
    id BIGSERIAL PRIMARY KEY,
    last_name VARCHAR(200) NOT NULL,
    first_name VARCHAR(200) NOT NULL,
    patronymic VARCHAR(200),
    date_of_birth DATE NOT NULL,
    gender_id SMALLINT NOT NULL REFERENCES gender(id),
    place_of_birth VARCHAR(500),
    citizenship VARCHAR(200) NOT NULL,
    snils VARCHAR(11) NOT NULL CHECK (snils ~ '^[0-9]{11}$'),
    inn VARCHAR(12) CHECK (inn IS NULL OR inn ~ '^[0-9]{10}([0-9]{2})?$'),
    workplace VARCHAR(500),
    position VARCHAR(200),
    contacts_id BIGINT REFERENCES contacts(id),
    education_id BIGINT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Passport (Паспорт)
CREATE TABLE passport (
    id BIGSERIAL PRIMARY KEY,
    person_id BIGINT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
    series VARCHAR(10) NOT NULL,
    number VARCHAR(10) NOT NULL,
    issuance_date DATE NOT NULL,
    issued_by VARCHAR(500) NOT NULL,
    division_code VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL,
    registration_address VARCHAR(1000),
    passport_valid_from DATE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Education (Образование)
CREATE TABLE education (
    id BIGSERIAL PRIMARY KEY,
    person_id BIGINT NOT NULL REFERENCES person(id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL,
    base_education_id SMALLINT REFERENCES base_education(id),
    education_level_id SMALLINT REFERENCES education_level(id),
    series VARCHAR(50),
    number VARCHAR(100) NOT NULL,
    issue_date DATE NOT NULL,
    issued_by VARCHAR(500) NOT NULL,
    place_of_issue VARCHAR(500) NOT NULL,
    specialty VARCHAR(300),
    city VARCHAR(200),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Add foreign key from person to education
ALTER TABLE person ADD CONSTRAINT fk_person_education 
    FOREIGN KEY (education_id) REFERENCES education(id);

-- Learning Program (Программа обучения)
CREATE TABLE learning_program (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(500) NOT NULL,
    format VARCHAR(200) NOT NULL,
    program_view_id INTEGER NOT NULL REFERENCES program_view(id),
    hours INTEGER NOT NULL CHECK (hours >= 0),
    lessons_count INTEGER NOT NULL CHECK (lessons_count >= 0),
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    image VARCHAR(255),
    source_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON COLUMN learning_program.source_url IS 'URL программы на сайте 25-12.ru';

-- Program Module (Модуль программы)
CREATE TABLE program_module (
    id BIGSERIAL PRIMARY KEY,
    program_id BIGINT NOT NULL REFERENCES learning_program(id) ON DELETE CASCADE,
    module_number INTEGER NOT NULL,
    module_name VARCHAR(500) NOT NULL,
    description TEXT,
    hours INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE program_module IS 'Модули программ обучения';
COMMENT ON COLUMN program_module.module_number IS 'Номер модуля по порядку';
COMMENT ON COLUMN program_module.module_name IS 'Название модуля';
COMMENT ON COLUMN program_module.description IS 'Описание модуля';
COMMENT ON COLUMN program_module.hours IS 'Количество часов модуля';

-- Teacher (Преподаватель)
CREATE TABLE teacher (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

COMMENT ON TABLE teacher IS 'Таблица преподавателей';
COMMENT ON COLUMN teacher.id IS 'Уникальный идентификатор преподавателя';
COMMENT ON COLUMN teacher.full_name IS 'ФИО преподавателя';

-- Contract (Договор)
CREATE TABLE contract (
    id BIGSERIAL PRIMARY KEY,
    contract_number VARCHAR(200) NOT NULL,
    contract_date DATE NOT NULL,
    contract_type_id INTEGER NOT NULL REFERENCES contract_type(id),
    program_id BIGINT NOT NULL REFERENCES learning_program(id),
    start_date DATE,
    end_date DATE,
    is_group BOOLEAN NOT NULL DEFAULT FALSE,
    payer_id BIGINT NOT NULL REFERENCES person(id),
    listener_id BIGINT NOT NULL REFERENCES person(id),
    signer_id INTEGER,
    itog_document_option_key VARCHAR(50),
    time_option_key VARCHAR(50),
    study_option_key VARCHAR(50),
    payment_option_key VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Holiday Calendar (Календарь праздников)
CREATE TABLE holiday_calendar_day (
    id BIGSERIAL PRIMARY KEY,
    holiday_date DATE NOT NULL,
    holiday_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- Workload Batch (Пакет нагрузки)
CREATE TABLE workload_batch (
    id BIGSERIAL PRIMARY KEY,
    program_id BIGINT NOT NULL REFERENCES learning_program(id),
    teacher_id BIGINT REFERENCES teacher(id),
    group_name VARCHAR(255),
    is_group BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- Workload Document (Документ нагрузки)
CREATE TABLE workload_document (
    id BIGSERIAL PRIMARY KEY,
    program_id BIGINT NOT NULL REFERENCES learning_program(id),
    teacher_id BIGINT REFERENCES teacher(id),
    program_type VARCHAR(255),
    file_name VARCHAR(500) NOT NULL,
    file_path VARCHAR(1000) NOT NULL,
    batch_id BIGINT REFERENCES workload_batch(id),
    contract_id BIGINT REFERENCES contract(id),
    listener_id BIGINT REFERENCES person(id),
    group_name VARCHAR(255),
    is_group BOOLEAN NOT NULL DEFAULT FALSE,
    generated_at TIMESTAMP DEFAULT NOW() NOT NULL,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- Workload Schedule Entry (Запись расписания нагрузки)
CREATE TABLE workload_schedule_entry (
    id BIGSERIAL PRIMARY KEY,
    workload_document_id BIGINT NOT NULL REFERENCES workload_document(id) ON DELETE CASCADE,
    lesson_number INTEGER NOT NULL,
    module_number INTEGER,
    module_name VARCHAR(500),
    topic TEXT NOT NULL,
    lesson_date DATE,
    day_of_week VARCHAR(50),
    start_time TIME,
    end_time TIME,
    hours INTEGER,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_person_snils ON person(snils);
CREATE INDEX idx_person_contacts ON person(contacts_id);
CREATE INDEX idx_passport_person ON passport(person_id);
CREATE INDEX idx_education_person ON education(person_id);
CREATE INDEX idx_contract_payer ON contract(payer_id);
CREATE INDEX idx_contract_listener ON contract(listener_id);
CREATE INDEX idx_contract_program ON contract(program_id);
CREATE INDEX idx_program_module_program ON program_module(program_id);
CREATE INDEX idx_workload_document_program ON workload_document(program_id);
CREATE INDEX idx_workload_schedule_document ON workload_schedule_entry(workload_document_id);

-- ============================================
-- COMPLETION MESSAGE
-- ============================================

DO $$
BEGIN
    RAISE NOTICE '✅ Database initialized successfully!';
    RAISE NOTICE '📊 Reference tables populated:';
    RAISE NOTICE '   - Gender (Пол): 2 records';
    RAISE NOTICE '   - Base Education (Базовое образование): 3 records';
    RAISE NOTICE '   - Education Level (Уровень образования): 3 records';
    RAISE NOTICE '   - Program View (Вид программы): 3 records (ДОП, ПП, ПК)';
    RAISE NOTICE '   - Contract Type (Тип договора): 5 records';
    RAISE NOTICE '';
    RAISE NOTICE '🎯 Ready to use!';
END $$;
