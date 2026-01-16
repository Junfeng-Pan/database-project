SET search_path TO campus, public;

-- 1. 修改数据
-- 1.1 修改用户 '张三' (假设ID为1) 的电话号码
SELECT phone from users where name = '张三';
UPDATE users SET phone = '13000001112' WHERE name = '张三';
SELECT phone from users where name = '张三';

-- 1.2 修改一卡通卡号 '2023000100000001' 的状态为 '1' (挂失)
SELECT status from cards where card_no = '2023000100000002';
UPDATE cards SET status = '1' WHERE card_no = '2023000100000002';
SELECT status from cards where card_no = '2023000100000002';

-- 2. 删除指定数据
-- 2.1 删除一条充值记录 (ID最小的那条)
SELECT MIN(recharge_id) FROM recharge_records;
DELETE FROM recharge_records WHERE recharge_id = (SELECT MIN(recharge_id) FROM recharge_records);
SELECT MIN(recharge_id) FROM recharge_records;

-- 2.2 删除一条消费记录 (ID最大的那条)
SELECT MAX(consumption_id) FROM consumption_records;
DELETE FROM consumption_records WHERE consumption_id = (SELECT MAX(consumption_id) FROM consumption_records);
SELECT MAX(consumption_id) FROM consumption_records;
