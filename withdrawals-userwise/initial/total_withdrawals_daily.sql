Create table total_withdrawals_daily_userwise(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user INT NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)

drop table total_withdrawals_daily_userwise
select * from total_withdrawals_daily_userwise

SET @cutoff := '2025-08-26 18:30:00';
INSERT INTO total_withdrawals_daily_userwise (`user`, `value`)
SELECT 
user_id as user,
SUM(w.withdrawal_amount) AS value
FROM gaming_app_backend.`user_withdrawals` w
WHERE w.created_at >= @cutoff
GROUP BY user
ORDER BY user;

select * from total_withdrawals_daily_userwise


select sum(value) from total_withdrawals_daily;
SELECT sum(withdrawal_amount) FROM gaming_app_backend.user_withdrawals where created_at >= '2025-08-26 18:30:00';