SET search_path TO campus, public;

-- 1. 新用户的创建和授权
-- 1.1 创建用户 card_user
-- (如果已存在先删除，确保脚本可重复运行)
DROP USER IF EXISTS card_user;
CREATE USER card_user WITH PASSWORD 'Gauss#3campus';

-- 1.2 授权
-- 授予 schema 使用权限
GRANT USAGE ON SCHEMA campus TO card_user;
-- 授予特定表查询权限
GRANT SELECT ON TABLE cards TO card_user;
GRANT SELECT ON TABLE consumption_records TO card_user;

-- 注意：脚本中无法直接切换用户连接。
-- 下面的 SQL 语句是在 "omm" 用户下执行的，用于验证环境。
-- 实际的 "新用户连接" 测试将在 shell 命令中通过 gsql -U card_user 来完成。

-- 2. 删除 campus_card 模式 (慎重操作，放在最后)
-- DROP SCHEMA campus CASCADE; 
-- (暂时注释掉，以免误删导致无法后续查看数据。如需严格按照文档“删除模式”，请取消注释)
