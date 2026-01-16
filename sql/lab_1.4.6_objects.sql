SET search_path TO campus, public;

-- 1. 视图操作
-- 1.1 创建视图：展示用户ID、姓名及其主卡余额
CREATE VIEW v_user_balance AS
SELECT u.user_id, u.name, c.balance
FROM users u
JOIN cards c ON u.user_id = c.user_id;

-- 1.2 使用视图进行查询
SELECT * FROM v_user_balance WHERE balance > 100;

-- 1.3 重命名视图
ALTER VIEW v_user_balance RENAME TO v_user_balance_old;

-- 1.4 删除视图
DROP VIEW v_user_balance_old;


-- 2. 索引操作
-- 2.1 创建索引：在商户表的商户名称字段上创建索引
CREATE INDEX idx_merchant_name ON merchants(merchant_name);

-- 2.2 重建索引
REINDEX INDEX idx_merchant_name;

-- 2.3 重命名索引
ALTER INDEX idx_merchant_name RENAME TO idx_merch_name_new;

-- 2.4 删除索引
DROP INDEX idx_merch_name_new;
