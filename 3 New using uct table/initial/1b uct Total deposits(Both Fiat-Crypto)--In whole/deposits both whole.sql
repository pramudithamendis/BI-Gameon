
-- user_coin_transaction_method
	-- 3 withdrawal
    -- 4 fiat-deposit
    -- 5 crypto-deposit
    -- 9 crypto-withdrawal

drop table uct_total_deposits_both_daily;
CREATE TABLE uct_total_deposits_both_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
select * from uct_total_deposits_both_daily;

SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_deposits_both_daily(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;
select * from uct_total_deposits_both_daily;


drop table uct_total_deposits_both_weekly;
CREATE TABLE uct_total_deposits_both_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL unique,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from uct_total_deposits_both_weekly;
SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_deposits_both_weekly(year_week,week_start_date,week_end_date,total_completed_amount, total_transactions)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC;
select * from uct_total_deposits_both_weekly;

drop table total_deposits_both_monthly;
CREATE TABLE total_deposits_both_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from total_deposits_both_monthly;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_both_monthly(month_,total_completed_amount,total_transactions)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC;
select * from total_deposits_both_monthly;


drop table total_deposits_both_total;
CREATE TABLE total_deposits_both_total (
    id BIGINT AUTO_INCREMENT PRIMARY KEY unique,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from total_deposits_both_total;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_both_total(total_completed_amount, total_transactions)
SELECT 
SUM(w.coins) AS total_completed_amount,
COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5);
select * from total_deposits_both_total;