SET search_path TO campus, public;

-- ========================================================
-- 补充约束脚本 (Re-adding constraints)
-- 说明：为了演示 ALTER TABLE 添加约束的语法，本脚本会先尝试删除同名约束(如果存在)，
--      然后再重新添加这些约束。
-- ========================================================

-- 1. 清理可能已存在的约束 (Drop existing constraints)
-- Check Constraints
ALTER TABLE cards DROP CONSTRAINT IF EXISTS cards_balance_check;
ALTER TABLE recharge_records DROP CONSTRAINT IF EXISTS recharge_records_amount_check;
ALTER TABLE consumption_records DROP CONSTRAINT IF EXISTS consumption_records_amount_check;

-- Foreign Keys
ALTER TABLE cards DROP CONSTRAINT IF EXISTS cards_user_id_fkey;
ALTER TABLE recharge_records DROP CONSTRAINT IF EXISTS recharge_records_card_no_fkey;
ALTER TABLE consumption_records DROP CONSTRAINT IF EXISTS consumption_records_card_no_fkey;
ALTER TABLE consumption_records DROP CONSTRAINT IF EXISTS consumption_records_merchant_id_fkey;


-- 2. 添加非负/大于零约束 (Add Check Constraints)

-- 2.1 一卡通余额不可为负数
ALTER TABLE cards ADD CONSTRAINT cards_balance_check CHECK (balance >= 0);

-- 2.2 充值金额必须大于 0
ALTER TABLE recharge_records ADD CONSTRAINT recharge_records_amount_check CHECK (amount > 0);

-- 2.3 消费金额必须大于 0
ALTER TABLE consumption_records ADD CONSTRAINT consumption_records_amount_check CHECK (amount > 0);


-- 3. 添加外键约束 (Add Foreign Keys)

-- 3.1 一卡通表关联用户表 (Cards -> Users)
ALTER TABLE cards ADD CONSTRAINT cards_user_id_fkey 
    FOREIGN KEY (user_id) REFERENCES users(user_id);

-- 3.2 充值记录关联一卡通表 (Recharge -> Cards)
ALTER TABLE recharge_records ADD CONSTRAINT recharge_records_card_no_fkey 
    FOREIGN KEY (card_no) REFERENCES cards(card_no);

-- 3.3 消费记录关联一卡通表 (Consumption -> Cards)
ALTER TABLE consumption_records ADD CONSTRAINT consumption_records_card_no_fkey 
    FOREIGN KEY (card_no) REFERENCES cards(card_no);

-- 3.4 消费记录关联商户表 (Consumption -> Merchants)
ALTER TABLE consumption_records ADD CONSTRAINT consumption_records_merchant_id_fkey 
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id);
