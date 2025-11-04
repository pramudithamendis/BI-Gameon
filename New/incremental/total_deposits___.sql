-- Total Deposits  --

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_deposits_daily (date_, total_completed_amount, total_transactions)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
  AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;


USE gaming_app_bi;

-- Get last week's year_week number based on Singapore timezone
SET @last_week_yearweek := YEARWEEK(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 WEEK), '+00:00', '+08:00'), 1);

INSERT INTO total_deposits_weekly (
    year_week,
    week_start_date,
    week_end_date,
    total_completed_amount,
    total_transactions
)
SELECT 
    YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS year_week,
    MIN(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_start_date,
    MAX(DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00'))) AS week_end_date,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_oapp_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
  AND YEARWEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) = @last_week_yearweek
GROUP BY year_week
ON DUPLICATE KEY UPDATE 
    -- ONLY update amounts, not date ranges
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;



select * from total_deposits_monthly;

USE gaming_app_bi;

-- Get last month in Singapore time (+08:00)
SET @last_month := DATE_FORMAT(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'), '%Y-%m');

INSERT INTO total_deposits_monthly (month_, total_completed_amount, total_transactions)
SELECT 
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') AS month_,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY month_
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions     = VALUES(total_transactions),
    updated_at             = CURRENT_TIMESTAMP;


select * from total_deposits_total;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_deposits_total (date, total_completed_amount, total_transactions)
SELECT
    @yesterday AS date,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
  AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
ON DUPLICATE KEY UPDATE
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
