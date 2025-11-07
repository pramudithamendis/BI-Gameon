-- Total withdrawals --

select * from total_withdrawals_daily;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_withdrawals_daily (date_, total_withdrawal_usd, total_withdrawal_lkr)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.withdrawal_amount) AS total_withdrawal_usd,
    SUM(w.amount_lkr) AS total_withdrawal_lkr
FROM gaming_app_backend.user u
JOIN gaming_app_backend.user_withdrawals w 
    ON w.user_id = u.id
WHERE w.is_active = 1
  AND w.status = 'Approved'
  AND u.email NOT LIKE '%@gameonworld.ai%'
  AND w.amount_lkr IS NOT NULL
  AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_withdrawal_usd = VALUES(total_withdrawal_usd),
    total_withdrawal_lkr = VALUES(total_withdrawal_lkr),
    updated_at = CURRENT_TIMESTAMP;
select * from total_withdrawals_daily;


select * from total_withdrawals_weekly;

USE gaming_app_bi;

-- Get the year-week for the LAST completed week in Singapore timezone
SET @last_week := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);

INSERT INTO total_withdrawals_weekly (
    year_week,
    week_start_date,
    week_end_date,
    total_withdrawal_usd,
    total_withdrawal_lkr
)
SELECT 
    YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS year_week,
    MIN(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_start_date,
    MAX(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_end_date,
    SUM(w.withdrawal_amount) AS total_withdrawal_usd,
    SUM(w.amount_lkr) AS total_withdrawal_lkr
FROM gaming_app_backend.user u
JOIN gaming_app_backend.user_withdrawals w 
    ON w.user_id = u.id
WHERE w.is_active = 1
  AND w.status = 'Approved'
  AND u.email NOT LIKE '%@gameonworld.ai%'
  AND w.amount_lkr IS NOT NULL
  AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week
GROUP BY year_week
ON DUPLICATE KEY UPDATE 
    total_withdrawal_usd = VALUES(total_withdrawal_usd),
    total_withdrawal_lkr = VALUES(total_withdrawal_lkr),
    week_start_date = VALUES(week_start_date),
    week_end_date = VALUES(week_end_date),
    updated_at = CURRENT_TIMESTAMP;


select * from total_withdrawals_monthly;

USE gaming_app_bi;

-- Get last month's year-month in Singapore timezone (+08:00)
SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%Y-%m'
);

INSERT INTO total_withdrawals_monthly (month_, total_withdrawal_usd, total_withdrawal_lkr)
SELECT 
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') AS month,
    SUM(w.withdrawal_amount) AS total_withdrawal_usd,
    SUM(w.amount_lkr) AS total_withdrawal_lkr
FROM gaming_app_backend.user u
JOIN gaming_app_backend.user_withdrawals w 
    ON w.user_id = u.id
WHERE w.is_active = 1
  AND w.status = 'Approved'
  AND u.email NOT LIKE '%@gameonworld.ai%'
  AND w.amount_lkr IS NOT NULL
  AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY month
ON DUPLICATE KEY UPDATE 
    total_withdrawal_usd = VALUES(total_withdrawal_usd),
    total_withdrawal_lkr = VALUES(total_withdrawal_lkr),
    updated_at = CURRENT_TIMESTAMP;
select * from total_withdrawals_monthly;


drop table total_withdrawals_total;

select * from total_withdrawals_total;

-- USE gaming_app_bi;

-- -- Get yesterday's date in Singapore timezone (+08:00)
-- SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- INSERT INTO total_withdrawals_total (date, total_withdrawal_usd, total_withdrawal_lkr)
-- SELECT 
--     @yesterday AS date,
--     SUM(w.withdrawal_amount) AS total_withdrawal_usd,
--     SUM(w.amount_lkr) AS total_withdrawal_lkr
-- FROM gaming_app_backend.user u
-- JOIN gaming_app_backend.user_withdrawals w 
--     ON w.user_id = u.id
-- WHERE w.is_active = 1
--   AND w.status = 'Approved'
--   AND u.email NOT LIKE '%@gameonworld.ai%'
--   AND w.amount_lkr IS NOT NULL
--   AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
-- ON DUPLICATE KEY UPDATE 
--     total_withdrawal_usd = VALUES(total_withdrawal_usd),
--     total_withdrawal_lkr = VALUES(total_withdrawal_lkr),
--     updated_at = CURRENT_TIMESTAMP;

