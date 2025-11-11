CREATE TABLE total_deposits_cumulative (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL UNIQUE,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


select * from total_deposits_cumulative;

USE gaming_app_bi;

SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO total_deposits_cumulative (date, value)
SELECT 
    date,
    SUM(value) OVER (ORDER BY date) AS value
FROM total_deposits_daily
WHERE date >= DATE(@cutoff)
ORDER BY date;

select * from total_deposits_cumulative;