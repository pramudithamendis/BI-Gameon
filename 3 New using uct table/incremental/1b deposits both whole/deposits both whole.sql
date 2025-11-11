
-- user_coin_transaction_method
	-- 3 withdrawal
    -- 4 fiat-deposit
    -- 5 crypto-deposit
    -- 9 crypto-withdrawal


select * from uct_total_deposits_both_daily;
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));
SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_deposits_both_daily(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
  AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
select * from uct_total_deposits_both_daily;



select * from uct_total_deposits_both_weekly;
SET @last_week_yearweek := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);
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
  AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week_yearweek
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC
ON DUPLICATE KEY UPDATE 
    -- ONLY update amounts, not date ranges
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
select * from uct_total_deposits_both_weekly;


select * from total_deposits_both_monthly;

SET @last_month := DATE_FORMAT(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'), '%Y-%m');
SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_both_monthly(month_,total_completed_amount,total_transactions)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    SUM(w.coins) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5)
AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions     = VALUES(total_transactions),
    updated_at             = CURRENT_TIMESTAMP;
select * from total_deposits_both_monthly;

select * from total_deposits_both_total;

-- SET @cutoff := '2025-09-27 18:30:00';
-- insert into total_deposits_both_total(total_completed_amount, total_transactions)
-- SELECT 
-- SUM(w.coins) AS total_completed_amount,
-- COUNT(*) AS total_transactions
-- FROM gaming_app_backend.user_coin_transaction w
-- JOIN gaming_app_backend.user u ON w.user = u.id
-- WHERE w.created_at >= @cutoff and (w.user_coin_transaction_method = 4 or w.user_coin_transaction_method = 5);
-- select * from total_deposits_both_total;