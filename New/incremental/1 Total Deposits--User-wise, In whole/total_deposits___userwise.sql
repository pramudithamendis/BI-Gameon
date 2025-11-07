-- Total Deposits - User-wise  --

select * from total_deposits_daily_userwise;

USE gaming_app_bi;

-- Get yesterday in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_deposits_daily_userwise
    (user_id, email, first_name, last_name, date_, total_completed_amount, total_transactions)
SELECT 
    w.user AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE 
    w.status IN ('Completed', 'Success')
    AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY 
    w.user,
    u.email,
    u.first_name,
    u.last_name,
    date_
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

select * from total_deposits_daily_userwise;
select * from total_deposits_total_userwise;


select * from total_deposits_weekly_userwise;
-- Get last week's year and ISO week number in Singapore timezone (+08:00)
SET @now_sg := CONVERT_TZ(NOW(), '+00:00', '+08:00');
SET @last_week_start := DATE_SUB(@now_sg, INTERVAL 1 WEEK);

SET @year := YEAR(@last_week_start);
SET @week_num := WEEK(@last_week_start, 1);
SET @week_label := CONCAT(@year, '-W', LPAD(@week_num, 2, '0'));

INSERT INTO total_deposits_weekly_userwise
(user_id, email, first_name, last_name, year, week_number, week_label, total_completed_amount, total_transactions)
SELECT 
    w.user AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    YEAR(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS year,
    WEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1) AS week_number,
    CONCAT(
        YEAR(CONVERT_TZ(w.created_at, '+00:00', '+08:00')),
        '-W',
        LPAD(WEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1), 2, '0')
    ) AS week_label,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
AND CONCAT(
        YEAR(CONVERT_TZ(w.created_at, '+00:00', '+08:00')),
        '-W',
        LPAD(WEEK(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), 1), 2, '0')
    ) = @week_label
GROUP BY user_id, email, first_name, last_name, year, week_number, week_label
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

select * from total_deposits_weekly_userwise;

drop table total_deposits_monthly_userwise;
select * from total_deposits_monthly_userwise;

USE gaming_app_bi;

-- Get LAST MONTH in Singapore timezone (+08:00)
SET @last_month := DATE_FORMAT(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'), '%Y-%m');

INSERT INTO total_deposits_monthly_userwise
    (user_id, email, first_name, last_name, month_, total_completed_amount, total_transactions)
SELECT 
    w.user AS user_id,
    u.email,
    u.first_name,
    u.last_name,
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') AS month_,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE 
    w.status IN ('Completed', 'Success')
    AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY 
    w.user, u.email, u.first_name, u.last_name, month_
ON DUPLICATE KEY UPDATE 
    total_completed_amount = VALUES(total_completed_amount),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;
select * from total_deposits_monthly_userwise;

select * from total_deposits_total_userwise;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (+08:00)
-- SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- INSERT INTO total_deposits_total_userwise (
--     date,
--     user_id,
--     email,
--     first_name,
--     last_name,
--     total_completed_amount,
--     total_transactions
-- )
-- SELECT 
--     @yesterday AS date,
--     w.user AS user_id,
--     u.email,
--     u.first_name,
--     u.last_name,
--     SUM(w.actual_amount) AS total_completed_amount,
--     COUNT(*) AS total_transactions
-- FROM gaming_app_backend.webx_pay w
-- JOIN gaming_app_backend.user u ON w.user = u.id
-- WHERE 
--     w.status IN ('Completed', 'Success')
--     AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
-- GROUP BY 
--     w.user, u.email, u.first_name, u.last_name
-- ON DUPLICATE KEY UPDATE
--     total_completed_amount = VALUES(total_completed_amount),
--     total_transactions = VALUES(total_transactions),
--     updated_at = CURRENT_TIMESTAMP;
