SET search_path TO campus, public;

-- 1. Insert Users (20 rows)
INSERT INTO users (name, identity_no, phone, password, user_type) VALUES 
('张三', '110101200001010001', '13800138001', 'password123', 'Student'),
('李四', '110101200001010002', '13800138002', 'password123', 'Student'),
('王五', '110101200001010003', '13800138003', 'password123', 'Teacher'),
('赵六', '110101200001010004', '13800138004', 'password123', 'Student'),
('孙七', '110101200001010005', '13800138005', 'password123', 'Student'),
('周八', '110101200001010006', '13800138006', 'password123', 'Teacher'),
('吴九', '110101200001010007', '13800138007', 'password123', 'Student'),
('郑十', '110101200001010008', '13800138008', 'password123', 'Student'),
('钱十一', '110101200001010009', '13800138009', 'password123', 'Student'),
('陈十二', '110101200001010010', '13800138010', 'password123', 'Teacher'),
('刘十三', '110101200001010011', '13800138011', 'password123', 'Student'),
('林十四', '110101200001010012', '13800138012', 'password123', 'Student'),
('黄十五', '110101200001010013', '13800138013', 'password123', 'Teacher'),
('杨十六', '110101200001010014', '13800138014', 'password123', 'Student'),
('朱十七', '110101200001010015', '13800138015', 'password123', 'Student'),
('秦十八', '110101200001010016', '13800138016', 'password123', 'Student'),
('尤十九', '110101200001010017', '13800138017', 'password123', 'Teacher'),
('许二十', '110101200001010018', '13800138018', 'password123', 'Student'),
('何二十一', '110101200001010019', '13800138019', 'password123', 'Student'),
('吕二十二', '110101200001010020', '13800138020', 'password123', 'Student');

-- 2. Insert Merchants (10 rows)
INSERT INTO merchants (merchant_name, merchant_type, address, contact_person, status) VALUES 
('第一食堂', 'Canteen', 'North District', 'Manager Zhang', '1'),
('第二食堂', 'Canteen', 'South District', 'Manager Li', '1'),
('校园超市', 'Supermarket', 'Central Area', 'Manager Wang', '1'),
('学苑书店', 'Bookstore', 'Library 1F', 'Manager Zhao', '1'),
('校医院', 'Hospital', 'East Gate', 'Dr. Sun', '1'),
('体育馆', 'Gym', 'West District', 'Coach Zhou', '1'),
('打印店', 'Print Shop', 'Teaching Bldg A', 'Boss Wu', '1'),
('咖啡厅', 'Cafe', 'Library 2F', 'Barista Zheng', '1'),
('水果店', 'Fruit Shop', 'Dorm Area', 'Boss Qian', '1'),
('理发店', 'Barber', 'Dorm Area', 'Barber Chen', '1');

-- 3. Insert Cards (20 rows, linked to user_id 1-20)
-- Assuming user_id starts from 1 because of SERIAL.
INSERT INTO cards (card_no, user_id, balance, status) VALUES 
('2023000100000001', 1, 100.00, '0'),
('2023000100000002', 2, 50.00, '0'),
('2023000100000003', 3, 200.00, '0'),
('2023000100000004', 4, 10.00, '0'),
('2023000100000005', 5, 80.00, '0'),
('2023000100000006', 6, 150.00, '0'),
('2023000100000007', 7, 30.00, '0'),
('2023000100000008', 8, 45.00, '0'),
('2023000100000009', 9, 60.00, '0'),
('2023000100000010', 10, 300.00, '0'),
('2023000100000011', 11, 20.00, '0'),
('2023000100000012', 12, 100.00, '0'),
('2023000100000013', 13, 90.00, '0'),
('2023000100000014', 14, 55.00, '0'),
('2023000100000015', 15, 75.00, '0'),
('2023000100000016', 16, 120.00, '0'),
('2023000100000017', 17, 10.00, '0'),
('2023000100000018', 18, 5.00, '0'),
('2023000100000019', 19, 200.00, '0'),
('2023000100000020', 20, 88.00, '0');

-- 4. Insert Recharge Records (20 rows)
INSERT INTO recharge_records (card_no, amount, method, recharge_time) VALUES 
('2023000100000001', 100.00, 'WeChat', NOW() - INTERVAL '1 day'),
('2023000100000002', 50.00, 'Alipay', NOW() - INTERVAL '2 days'),
('2023000100000003', 200.00, 'Cash', NOW() - INTERVAL '3 days'),
('2023000100000004', 50.00, 'WeChat', NOW() - INTERVAL '4 days'),
('2023000100000005', 100.00, 'Alipay', NOW() - INTERVAL '5 days'),
('2023000100000006', 150.00, 'WeChat', NOW() - INTERVAL '6 days'),
('2023000100000007', 30.00, 'Cash', NOW() - INTERVAL '7 days'),
('2023000100000008', 50.00, 'WeChat', NOW() - INTERVAL '8 days'),
('2023000100000009', 100.00, 'Alipay', NOW() - INTERVAL '9 days'),
('2023000100000010', 300.00, 'WeChat', NOW() - INTERVAL '10 days'),
('2023000100000011', 20.00, 'Cash', NOW() - INTERVAL '11 days'),
('2023000100000012', 100.00, 'WeChat', NOW() - INTERVAL '12 days'),
('2023000100000013', 90.00, 'Alipay', NOW() - INTERVAL '13 days'),
('2023000100000014', 55.00, 'WeChat', NOW() - INTERVAL '14 days'),
('2023000100000015', 75.00, 'Cash', NOW() - INTERVAL '15 days'),
('2023000100000016', 120.00, 'Alipay', NOW() - INTERVAL '16 days'),
('2023000100000017', 10.00, 'WeChat', NOW() - INTERVAL '17 days'),
('2023000100000018', 20.00, 'WeChat', NOW() - INTERVAL '18 days'),
('2023000100000019', 200.00, 'Alipay', NOW() - INTERVAL '19 days'),
('2023000100000020', 88.00, 'WeChat', NOW() - INTERVAL '20 days');

-- 5. Insert Consumption Records (30 rows)
-- Randomly mixing card_no and merchant_id (1-10)
INSERT INTO consumption_records (card_no, merchant_id, amount, consume_time) VALUES 
('2023000100000001', 1, 15.00, NOW() - INTERVAL '1 hour'),
('2023000100000001', 2, 20.00, NOW() - INTERVAL '2 hours'),
('2023000100000002', 3, 5.50, NOW() - INTERVAL '3 hours'),
('2023000100000003', 1, 12.00, NOW() - INTERVAL '4 hours'),
('2023000100000003', 4, 35.00, NOW() - INTERVAL '5 hours'),
('2023000100000004', 5, 10.00, NOW() - INTERVAL '6 hours'),
('2023000100000005', 2, 18.00, NOW() - INTERVAL '7 hours'),
('2023000100000006', 6, 25.00, NOW() - INTERVAL '8 hours'),
('2023000100000007', 7, 2.00, NOW() - INTERVAL '9 hours'),
('2023000100000008', 8, 30.00, NOW() - INTERVAL '10 hours'),
('2023000100000009', 1, 14.00, NOW() - INTERVAL '11 hours'),
('2023000100000010', 9, 22.00, NOW() - INTERVAL '12 hours'),
('2023000100000010', 3, 45.00, NOW() - INTERVAL '13 hours'),
('2023000100000011', 10, 15.00, NOW() - INTERVAL '14 hours'),
('2023000100000012', 1, 11.00, NOW() - INTERVAL '15 hours'),
('2023000100000013', 2, 16.00, NOW() - INTERVAL '16 hours'),
('2023000100000014', 4, 28.00, NOW() - INTERVAL '17 hours'),
('2023000100000015', 5, 50.00, NOW() - INTERVAL '18 hours'),
('2023000100000016', 6, 20.00, NOW() - INTERVAL '19 hours'),
('2023000100000017', 7, 1.50, NOW() - INTERVAL '20 hours'),
('2023000100000018', 8, 12.00, NOW() - INTERVAL '21 hours'),
('2023000100000019', 9, 10.00, NOW() - INTERVAL '22 hours'),
('2023000100000020', 10, 25.00, NOW() - INTERVAL '23 hours'),
('2023000100000001', 3, 8.00, NOW() - INTERVAL '24 hours'),
('2023000100000002', 1, 13.00, NOW() - INTERVAL '25 hours'),
('2023000100000003', 2, 19.00, NOW() - INTERVAL '26 hours'),
('2023000100000004', 4, 22.00, NOW() - INTERVAL '27 hours'),
('2023000100000005', 5, 9.00, NOW() - INTERVAL '28 hours'),
('2023000100000006', 6, 33.00, NOW() - INTERVAL '29 hours'),
('2023000100000007', 7, 3.00, NOW() - INTERVAL '30 hours');
