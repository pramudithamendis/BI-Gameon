USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_withdrawals_daily_userwise (user, value)
SELECT 
    user_id as user,
    SUM(u.withdrawal_amount)
FROM gaming_app_backend.`user_withdrawals` u
WHERE DATE(CONVERT_TZ(u.created_at, '+00:00', '+08:00')) = @yesterday,
GROUP BY user
ON DUPLICATE KEY UPDATE 
    value = VALUES(value),
    updated_at = CURRENT_TIMESTAMP;

--
select * from total_withdrawals_daily;
