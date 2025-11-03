USE gaming_app_bi;
--
Create table total_deposits_daily_userwise(
    id INT AUTO_INCREMENT PRIMARY KEY,
    user INT NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
--
drop table total_deposits_daily_userwise
select * from total_deposits_daily_userwise;
--
SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_deposits_daily_userwise (user, value)
SELECT 
user,
-- COUNT(*) AS value
SUM(w.actual_amount) AS value
FROM gaming_app_backend.`webx_pay` w
WHERE w.created_at >= @cutoff
GROUP BY user
ORDER BY user;
--
select * from total_deposits_daily_userwise;
