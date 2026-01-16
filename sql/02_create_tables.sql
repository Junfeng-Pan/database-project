-- Set search path to ensure tables are created in the correct schema
SET search_path TO campus, public;

-- 1. 用户表 (Users)
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    identity_no CHAR(18) NOT NULL UNIQUE,
    phone VARCHAR(11),
    email VARCHAR(50),
    password VARCHAR(32) NOT NULL,
    user_type VARCHAR(10) CHECK(user_type IN ('Student', 'Teacher'))
);

-- 2. 商户表 (Merchants)
CREATE TABLE merchants (
    merchant_id SERIAL PRIMARY KEY,
    merchant_name VARCHAR(50) NOT NULL,
    merchant_type VARCHAR(20),
    address VARCHAR(100),
    contact_person VARCHAR(20),
    status CHAR(1) DEFAULT '1' -- 1:营业, 0:停业
);

-- 3. 一卡通表 (Cards)
CREATE TABLE cards (
    card_no CHAR(16) PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    balance DECIMAL(10,2) DEFAULT 0 CHECK(balance >= 0),
    status CHAR(1) DEFAULT '0', -- 0:正常, 1:挂失, 2:注销
    open_date TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 4. 充值记录表 (Recharge_Records)
CREATE TABLE recharge_records (
    recharge_id BIGSERIAL PRIMARY KEY,
    card_no CHAR(16) NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK(amount > 0),
    recharge_time TIMESTAMP DEFAULT NOW(),
    method VARCHAR(10),
    FOREIGN KEY (card_no) REFERENCES cards(card_no)
);

-- 5. 消费记录表 (Consumption_Records)
CREATE TABLE consumption_records (
    consumption_id BIGSERIAL PRIMARY KEY,
    card_no CHAR(16) NOT NULL,
    merchant_id INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK(amount > 0),
    consume_time TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (card_no) REFERENCES cards(card_no),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);
