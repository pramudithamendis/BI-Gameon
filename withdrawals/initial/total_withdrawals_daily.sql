Create table total_withdrawals_daily(
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)


select * from total_withdrawals_daily

SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_withdrawals_daily (date, value)
SELECT 
DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date,
-- COUNT(*) AS value
SUM(w.withdrawal_amount) AS value
FROM gaming_app_backend.`user_withdrawals` w
WHERE w.created_at >= @cutoff
GROUP BY date
ORDER BY date;

select * from total_withdrawals_daily


select sum(value) from total_withdrawals_daily;
SELECT sum(withdrawal_amount) FROM gaming_app_backend.user_withdrawals where created_at >= '2025-08-26 18:30:00';