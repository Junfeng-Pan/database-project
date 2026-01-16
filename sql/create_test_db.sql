-- 创建测试数据库 campus_test
CREATE DATABASE campus_test WITH ENCODING = 'UTF8';

-- 连接到 campus_test 数据库（请在 gsql 中执行）
-- \c campus_test

-- 创建 schema campus_test
CREATE SCHEMA IF NOT EXISTS campus_test;

-- 设置当前 schema
SET search_path TO campus_test, public;

-- 创建测试表 campus_sites
CREATE TABLE campus_sites (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    url VARCHAR(100)
);

-- 插入测试数据
INSERT INTO campus_sites (id, name, url) VALUES
(1, 'openGauss', 'https://opengauss.org/zh/'),
(2, '华为云', 'https://www.huaweicloud.com/'),
(3, '校园一卡通官网', 'https://campus-card.edu/'),
(4, '高校信息化中心', 'https://info.edu.cn/');

-- 验证数据
SELECT * FROM campus_sites;