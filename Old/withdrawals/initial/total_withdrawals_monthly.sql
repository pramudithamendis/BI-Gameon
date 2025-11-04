CREATE TABLE total_withdrawals_monthly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    month VARCHAR(10) NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
-- drop table total_withdrawals_monthly;
--
select * from total_withdrawals_monthly;
--
USE gaming_app_bi;

SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_withdrawals_monthly (month, value)
SELECT 
    DATE_FORMAT(CONVERT_TZ(m.created_at, '+00:00', '+08:00'), '%Y-%m') AS month,
    SUM(m.withdrawal_amount) AS value
FROM gaming_app_backend.`user_withdrawals` m
WHERE m.created_at >= @cutoff
GROUP BY month
ORDER BY month;
--

select * from total_withdrawals_monthly;
--

select sum(value) from total_withdrawals_monthly;
SELECT sum(withdrawal_amount) FROM gaming_app_backend.user_withdrawals where created_at >= '2025-08-26 18:30:00';