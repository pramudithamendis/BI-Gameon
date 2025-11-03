USE gaming_app_bi;

-- Get current week in Singapore timezone
SET @current_week := DATE_FORMAT(CONVERT_TZ(NOW(), '+00:00', '+08:00'), '%%x-W%%v');

INSERT INTO total_withdrawals_weekly (week, value)
SELECT 
    DATE_FORMAT(date, '%%x-W%%v') AS week,
    SUM(twd.value) AS value
FROM total_withdrawals_daily twd
WHERE DATE_FORMAT(date, '%%x-W%%v') = @current_week
GROUP BY week
ON DUPLICATE KEY UPDATE 
    value = VALUES(value),
    updated_at = CURRENT_TIMESTAMP;
