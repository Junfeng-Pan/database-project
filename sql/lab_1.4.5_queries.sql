SET search_path TO campus, public;

-- 1. 单表查询：查询所有营业状态的商户
SELECT * FROM merchants WHERE status = '1';

-- 2. 多表查询：查询用户 '张三' 的所有消费记录
SELECT u.name, m.merchant_name, cr.amount, cr.consume_time
FROM users u
JOIN cards c ON u.user_id = c.user_id
JOIN consumption_records cr ON c.card_no = cr.card_no
JOIN merchants m ON cr.merchant_id = m.merchant_id
WHERE u.name = '张三';

-- 3. 聚合查询
-- 3.1 查询系统内总用户数
SELECT COUNT(*) AS total_users FROM users;

-- 3.2 查询某商户（例如ID为1）的平均单笔消费金额
SELECT AVG(amount) AS avg_consumption_amount FROM consumption_records WHERE merchant_id = 1;

-- 3.3 查询所有用户的总充值金额
SELECT SUM(amount) AS total_recharge_amount FROM recharge_records;

-- 4. 连接查询
-- 4.1 半连接：查询有消费记录的用户
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM cards c
    JOIN consumption_records cr ON c.card_no = cr.card_no
    WHERE c.user_id = u.user_id
);

-- 4.2 反连接：查询无充值记录的用户 (注意：这里假设 users 表里的用户可能有卡但没充过值)
SELECT * FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM cards c
    JOIN recharge_records rr ON c.card_no = rr.card_no
    WHERE c.user_id = u.user_id
);

-- 4.3 多表连接：查询用户 - 卡片 - 消费 - 商户关联信息 (Limit 5)
SELECT u.name, c.card_no, m.merchant_name, cr.amount
FROM users u
JOIN cards c ON u.user_id = c.user_id
JOIN consumption_records cr ON c.card_no = cr.card_no
JOIN merchants m ON cr.merchant_id = m.merchant_id
LIMIT 5;

-- 4.4 子查询：查询消费金额大于平均消费额的记录
SELECT * FROM consumption_records
WHERE amount > (SELECT AVG(amount) FROM consumption_records);

-- 5. ORDER BY：按消费时间降序查询用户 '张三' 的消费记录
SELECT cr.* 
FROM consumption_records cr
JOIN cards c ON cr.card_no = c.card_no
JOIN users u ON c.user_id = u.user_id
WHERE u.name = '张三'
ORDER BY cr.consume_time DESC;

-- 6. GROUP BY ... HAVING：按商户分组，查询累计消费金额超过 50 元的商户
SELECT m.merchant_name, SUM(cr.amount) as total_revenue
FROM merchants m
JOIN consumption_records cr ON m.merchant_id = cr.merchant_id
GROUP BY m.merchant_name
HAVING SUM(cr.amount) > 50;
