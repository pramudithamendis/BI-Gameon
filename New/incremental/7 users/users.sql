
select * from users_total;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (YYYY-MM-DD only)
-- SET @yesterday_date := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- INSERT INTO users_total (metrics, data_type, f_list, value_list, metric_date, created_at)
-- SELECT
--     'total_users' AS metrics,
--     'card' AS data_type,
--     JSON_ARRAY('total_users') AS f_list,
--     JSON_OBJECT('total_users', COUNT(*)) AS value_list,
--     @yesterday_date AS metric_date,
--     NOW() AS created_at
-- FROM gaming_app_backend.`user`
-- WHERE DATE(CONVERT_TZ(created_at, '+00:00', '+08:00')) = @yesterday_date
-- ON DUPLICATE KEY UPDATE
--     value_list = VALUES(value_list),
--     updated_at = CURRENT_TIMESTAMP;





select * from users_monthly;

USE gaming_app_bi;

-- Get the previous month in Singapore timezone
SET @prev_month := DATE_FORMAT(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'), '%Y-%m-01');

INSERT INTO users_monthly (period, frequency, user_count)
SELECT
    @prev_month AS period,
    'monthly' AS frequency,
    COUNT(*) AS user_count
FROM gaming_app_backend.`user` u
WHERE DATE_FORMAT(CONVERT_TZ(u.created_at, '+00:00', '+08:00'), '%Y-%m-01') = @prev_month
GROUP BY period
ON DUPLICATE KEY UPDATE
    user_count = VALUES(user_count),
    updated_at = CURRENT_TIMESTAMP;
select * from users_monthly;




select * from users_weekly;

USE gaming_app_bi;

-- Compute last week's Monday–Sunday period in Singapore time
SET @last_week_start := DATE_SUB(
    DATE(CONVERT_TZ(NOW(), '+00:00', '+08:00')),
    INTERVAL (WEEKDAY(CONVERT_TZ(NOW(), '+00:00', '+08:00')) + 7) DAY
);

SET @last_week_end := DATE_ADD(@last_week_start, INTERVAL 6 DAY);

INSERT INTO users_weekly (period, frequency, user_count)
SELECT
    @last_week_end AS period,          -- store week ending date (Sunday)
    'weekly' AS frequency,
    COUNT(*) AS user_count
FROM gaming_app_backend.`user`
WHERE DATE(CONVERT_TZ(created_at, '+00:00', '+08:00')) BETWEEN @last_week_start AND @last_week_end
ON DUPLICATE KEY UPDATE
    user_count = VALUES(user_count),
    updated_at = CURRENT_TIMESTAMP;
select * from users_weekly;


select * from users_daily;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO users_daily (period, frequency, user_count)
SELECT 
    DATE(CONVERT_TZ(u.created_at, '+00:00', '+08:00')) AS period,
    'daily' AS frequency,
    COUNT(*) AS user_count
FROM gaming_app_backend.`user` u
WHERE DATE(CONVERT_TZ(u.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY period
ON DUPLICATE KEY UPDATE
    user_count = VALUES(user_count),
    updated_at = CURRENT_TIMESTAMP;
select * from users_daily;
