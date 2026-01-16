-- 1. Create Database
-- Note: You might need to run this command separately or connected to 'postgres' database.
-- CREATE DATABASE campus_card WITH ENCODING = 'UTF8';

-- 2. Switch to the new database (if using gsql/psql)
-- \c campus_card

-- 3. Create Schema
CREATE SCHEMA IF NOT EXISTS campus;

-- 4. Set search path
SET search_path TO campus, public;
