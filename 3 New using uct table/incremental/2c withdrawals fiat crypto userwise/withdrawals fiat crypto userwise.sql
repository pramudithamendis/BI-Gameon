
-- user_coin_transaction_method
	-- 3 withdrawal
    -- 4 fiat-deposit
    -- 5 crypto-deposit
    -- 9 crypto-withdrawal

drop table total_withdrawals_fiat_daily_userwise;


select * from total_withdrawals_fiat_daily_userwise;
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));
 
SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_fiat_daily_userwise(user_id, email, first_name, last_name, date_, total_completed_amount, total_transactions) 
SELECT w.user AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    DATE(w.created_at) AS date,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id 
	WHERE w.user_coin_transaction_method = 3
    and w.created_at >= @cutoff 
     AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday

GROUP BY w.user,
    u.email,
    u.first_name,
    u.last_name,
    DATE(w.created_at) ORDER BY date DESC,
    total_completed_amount DESC
    ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
    
select * from total_withdrawals_fiat_daily_userwise;

select * from total_withdrawals_fiat_total_userwise;

select * from total_withdrawals_fiat_weekly_userwise;


select * from total_withdrawals_fiat_weekly_userwise;
SET @last_week_yearweek := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);
  
SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_fiat_weekly_userwise(user_id, email,first_name,last_name,year,week_number,week_label,total_completed_amount,total_transactions) 
SELECT w.user AS user_id,
 u.email, 
 u.first_name, 
 u.last_name, 
 YEAR(w.created_at) AS year, 
 WEEK(w.created_at, 1) AS week_number, 
 CONCAT(YEAR(w.created_at), '-W', 
 LPAD(WEEK(w.created_at, 1), 2, '0')) AS week_label, 
 SUM(w.coins) AS total_completed_amount, 
 COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id 
	WHERE w.user_coin_transaction_method = 3 and w.created_at >= @cutoff AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week_yearweek

GROUP BY user_id, u.email, u.first_name, u.last_name, YEAR(w.created_at), WEEK(w.created_at, 1), CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) 
ORDER BY year DESC, week_number DESC, total_completed_amount DESC
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
select * from total_withdrawals_fiat_weekly_userwise;

drop table total_withdrawals_fiat_monthly_userwise;
select * from total_withdrawals_fiat_monthly_userwise;

USE gaming_app_bi;

select * from total_withdrawals_fiat_monthly_userwise;


select * from total_withdrawals_fiat_monthly_userwise;
SET @last_month := DATE_FORMAT(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'), '%Y-%m');

SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_fiat_monthly_userwise(user_id,email,first_name,last_name,month_,total_completed_amount,total_transactions) 
SELECT w.user AS user_id, u.email, u.first_name, u.last_name, DATE_FORMAT(w.created_at, '%Y-%m') AS month, SUM(w.coins) AS total_completed_amount, COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
	WHERE w.user_coin_transaction_method = 3 and w.created_at >= @cutoff AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month

 GROUP BY w.user, u.email, u.first_name, u.last_name, DATE_FORMAT(w.created_at, '%Y-%m') 
 ORDER BY month DESC, total_completed_amount DESC
 ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions     = VALUES(total_transactions),
    updated_at             = CURRENT_TIMESTAMP;
select * from total_withdrawals_fiat_monthly_userwise;

select * from total_withdrawals_fiat_total_userwise;

USE gaming_app_bi;

select * from total_withdrawals_fiat_total_userwise;

select * from total_withdrawals_fiat_total_userwise;

-- SET @cutoff := '2025-09-27 18:30:00'; 
-- insert into total_withdrawals_fiat_total_userwise(user_id,email,first_name,last_name,total_completed_amount,total_transactions) 
-- SELECT w.user AS user_id, u.email, u.first_name, u.last_name, SUM(w.coins) AS total_completed_amount, COUNT(*) AS total_transactions 
-- 	FROM gaming_app_backend.user_coin_transaction w

-- JOIN gaming_app_backend.user u ON w.user = u.id 
-- WHERE w.user_coin_transaction_method = 3 and w.created_at >= @cutoff 
-- GROUP BY w.user, u.email, u.first_name, u.last_name 
-- ORDER BY total_completed_amount DESC;
select * from total_withdrawals_fiat_total_userwise;



///////////////////


select * from total_withdrawals_crypto_daily_userwise;
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_crypto_daily_userwise(user_id, email, first_name, last_name, date_, total_completed_amount, total_transactions) 
SELECT w.user AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    DATE(w.created_at) AS date,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id 
	WHERE w.user_coin_transaction_method = 9
    and w.created_at >= @cutoff 
      AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday

GROUP BY w.user,
    u.email,
    u.first_name,
    u.last_name,
    DATE(w.created_at) ORDER BY date DESC,
    total_completed_amount DESC
    ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
select * from total_withdrawals_crypto_daily_userwise;


select * from total_withdrawals_crypto_weekly_userwise;
SET @last_week_yearweek := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);

SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_crypto_weekly_userwise(user_id, email,first_name,last_name,year,week_number,week_label,total_completed_amount,total_transactions) 
SELECT w.user AS user_id,
 u.email, 
 u.first_name, 
 u.last_name, 
 YEAR(w.created_at) AS year, 
 WEEK(w.created_at, 1) AS week_number, 
 CONCAT(YEAR(w.created_at), '-W', 
 LPAD(WEEK(w.created_at, 1), 2, '0')) AS week_label, 
 SUM(w.coins) AS total_completed_amount, 
 COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id 
	WHERE w.user_coin_transaction_method = 9 and w.created_at >= @cutoff   AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week_yearweek

GROUP BY user_id, u.email, u.first_name, u.last_name, YEAR(w.created_at), WEEK(w.created_at, 1), CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) 
ORDER BY year DESC, week_number DESC, total_completed_amount DESC
ON DUPLICATE KEY UPDATE 
    -- ONLY update amounts, not date ranges
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
select * from total_withdrawals_crypto_weekly_userwise;

drop table total_withdrawals_crypto_monthly_userwise;
select * from total_withdrawals_crypto_monthly_userwise;

USE gaming_app_bi;

select * from total_withdrawals_crypto_monthly_userwise;


select * from total_withdrawals_crypto_monthly_userwise;
SET @last_month := DATE_FORMAT(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'), '%Y-%m');
SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_crypto_monthly_userwise(user_id,email,first_name,last_name,month_,total_completed_amount,total_transactions) 
SELECT w.user AS user_id, u.email, u.first_name, u.last_name, DATE_FORMAT(w.created_at, '%Y-%m') AS month, SUM(w.coins) AS total_completed_amount, COUNT(*) AS total_transactions 
	FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
	WHERE w.user_coin_transaction_method = 9 and w.created_at >= @cutoff AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month

 GROUP BY w.user, u.email, u.first_name, u.last_name, DATE_FORMAT(w.created_at, '%Y-%m') 
 ORDER BY month DESC, total_completed_amount DESC
 ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions     = VALUES(total_transactions),
    updated_at             = CURRENT_TIMESTAMP;
select * from total_withdrawals_crypto_monthly_userwise;

select * from total_withdrawals_crypto_total_userwise;

USE gaming_app_bi;

select * from total_withdrawals_crypto_total_userwise;

select * from total_withdrawals_crypto_total_userwise;

-- SET @cutoff := '2025-09-27 18:30:00'; 
-- insert into total_withdrawals_crypto_total_userwise(user_id,email,first_name,last_name,total_completed_amount,total_transactions) 
-- SELECT w.user AS user_id, u.email, u.first_name, u.last_name, SUM(w.coins) AS total_completed_amount, COUNT(*) AS total_transactions 
-- 	FROM gaming_app_backend.user_coin_transaction w

-- JOIN gaming_app_backend.user u ON w.user = u.id 
-- WHERE w.user_coin_transaction_method = 9 and w.created_at >= @cutoff 
-- GROUP BY w.user, u.email, u.first_name, u.last_name 
-- ORDER BY total_completed_amount DESC;
-- select * from total_withdrawals_crypto_total_userwise;