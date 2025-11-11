USE gaming_app_bi;
--
CREATE TABLE total_deposits_weekly (
    id INT AUTO_INCREMENT PRIMARY KEY,
    week VARCHAR(10) NOT NULL,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

--
select * from total_deposits_weekly;
--
SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_deposits_weekly (week, value)
SELECT 
DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%x-W%v') AS week,
-- COUNT(*) AS value
SUM(w.actual_amount) AS value
FROM gaming_app_backend.`webx_pay` w
WHERE w.created_at >= @cutoff
GROUP BY week
ORDER BY week;
--
select * from total_deposits_weekly;
--Check whether belows are same
select sum(value) from total_deposits_weekly
SELECT sum(actual_amount) FROM gaming_app_backend.webx_pay where created_at >= '2025-08-26 18:30:00';