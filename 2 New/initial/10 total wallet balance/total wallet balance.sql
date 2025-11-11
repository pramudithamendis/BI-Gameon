
CREATE TABLE wallet_balance(
    id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    total_balance BIGINT NOT NULL DEFAULT 0,
    total_hold BIGINT NOT NULL DEFAULT 0,
    available_balance BIGINT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

select * from wallet_balance;

insert into wallet_balance(id,email,first_name,last_name,total_balance,total_hold,available_balance)
SELECT 
    u.id as id,
    u.email as email,
    u.first_name as first_name,
    u.last_name as last_name,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1  
   AND uca.is_active = 1             
WHERE u.is_active = 1
GROUP BY u.id, u.email, u.total_coins
ORDER BY available_balance DESC;


drop table wallet_balance_monthly;
CREATE TABLE wallet_balance_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id                BIGINT NOT NULL,
    email                  VARCHAR(255) NOT NULL,
    first_name             VARCHAR(150),
    last_name              VARCHAR(150),
    month_                  CHAR(7),             -- format: YYYY-MM
    total_balance          DECIMAL(18,2) NOT NULL,       -- u.total_coins
    total_hold             DECIMAL(18,2) NOT NULL,       -- SUM(uca.coins)
    available_balance      DECIMAL(18,2) NOT NULL,       -- total_balance - total_hold
    created_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key user_id_month(user_id,month_)
 );

drop table wallet_balance_monthly;
select * from wallet_balance_monthly;

insert into wallet_balance_monthly(user_id, email,first_name,last_name,month_, total_balance,total_hold, available_balance)
SELECT 
    u.id AS user_id,
    u.email as email,
    u.first_name as first_name,
    u.last_name as last_name,
    DATE_FORMAT(uca.created_at, '%Y-%m') AS month_,  
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1    
   AND uca.is_active = 1
WHERE u.is_active = 1
GROUP BY 
    u.id, 
    u.email, 
    u.first_name, 
    u.last_name,
    u.total_coins,
    DATE_FORMAT(uca.created_at, '%Y-%m')
ORDER BY 
    month_ DESC,
    available_balance DESC;
select * from wallet_balance_monthly;


drop table wallet_balance_weekly;
CREATE TABLE wallet_balance_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    year_ INT ,
    week_number INT,
    week_label VARCHAR(10),         -- e.g. "2025-W06"
    total_balance DECIMAL(18,2) NOT NULL,    -- u.total_coins
    total_hold DECIMAL(18,2) NOT NULL,       -- SUM(uca.coins)
    available_balance DECIMAL(18,2) NOT NULL,-- total_balance - total_hold
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key user_id_month(user_id,week_label)
);

drop table wallet_balance_weekly;
select * from wallet_balance_weekly;
insert into wallet_balance_weekly(user_id,email,first_name,last_name,year_,week_number,week_label,total_balance,total_hold,available_balance)
SELECT 
    u.id AS user_id,
    u.email as email,
    u.first_name as first_name,
    u.last_name as last_name,
    YEAR(uca.created_at) AS year_,
    WEEK(uca.created_at, 1) AS week_number,  -- ISO week (Mon–Sun)
    CONCAT(YEAR(uca.created_at), '-W', LPAD(WEEK(uca.created_at, 1), 2, '0')) AS week_label,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1
   AND uca.is_active = 1
WHERE u.is_active = 1
GROUP BY 
    user_id,
    email,
    first_name,
    last_name,
    year_,
    week_number,
    week_label,
    YEAR(uca.created_at),
    WEEK(uca.created_at, 1)
ORDER BY 
    year_ DESC,
    week_number DESC,
    available_balance DESC;
select * from wallet_balance_weekly;


drop table wallet_balance_daily;
CREATE TABLE wallet_balance_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),

    date_ DATE ,

    total_balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_hold DECIMAL(18,2) NOT NULL DEFAULT 0,
    available_balance DECIMAL(18,2) NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key user_id_month(user_id,date_)
);

drop table wallet_balance_daily;
select * from wallet_balance_daily;

insert into wallet_balance_daily(user_id,email,first_name,last_name,date_,total_balance,total_hold,available_balance)
SELECT 
    u.id AS user_id,
    u.email as email,
    u.first_name as first_name,
    u.last_name as last_name,
    DATE(uca.created_at) AS date_,
    u.total_coins AS total_balance,
    IFNULL(SUM(uca.coins), 0) AS total_hold,
    (u.total_coins - IFNULL(SUM(uca.coins), 0)) AS available_balance
FROM gaming_app_backend.user u
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON uca.user = u.id
   AND uca.user_coin_action_type = 1   
   AND uca.is_active = 1
WHERE u.is_active = 1
GROUP BY 
    u.id,
    u.email,
    u.first_name,
    u.last_name,
    u.total_coins,
   date_
ORDER BY 
    date_ DESC,
    available_balance DESC;
select * from wallet_balance_daily;
