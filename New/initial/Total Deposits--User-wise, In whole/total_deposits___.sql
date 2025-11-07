-- Total Deposits  --


CREATE TABLE total_deposits_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


select * from total_deposits_daily;
SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_daily(date_,total_completed_amount, total_transactions)
SELECT 
    DATE(w.created_at) AS date,
    SUM(w.actual_amount) AS total_completed_amount,
     COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
and w.created_at >= @cutoff
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;


CREATE TABLE total_deposits_weekly (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    year_week INT NOT NULL,                       -- e.g., 202544 (YYYYWW format)
    week_start_date DATE NOT NULL,                -- first date of the week
    week_end_date DATE NOT NULL,                  -- last date of the week
    total_completed_amount DECIMAL(18, 2) NOT NULL DEFAULT 0.00, -- sum of actual_amount
    total_transactions INT NOT NULL DEFAULT 0,    -- count(*)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

);

select * from total_deposits_weekly;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_weekly(year_week,week_start_date,week_end_date,total_completed_amount, total_transactions)
SELECT 
    YEARWEEK(w.created_at, 1) AS year_week,
    MIN(DATE(w.created_at)) AS week_start_date,
    MAX(DATE(w.created_at)) AS week_end_date,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
and w.created_at >= @cutoff
GROUP BY YEARWEEK(w.created_at, 1)
ORDER BY YEARWEEK(w.created_at, 1) DESC;


select * from total_deposits_monthly;

CREATE TABLE total_deposits_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL, -- format YYYY-MM
    total_completed_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_monthly(month_,total_completed_amount,total_transactions)
SELECT 
    DATE_FORMAT(w.created_at, '%Y-%m') AS month,
    SUM(w.actual_amount) AS total_completed_amount,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
and w.created_at >= @cutoff
GROUP BY DATE_FORMAT(w.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC;


CREATE TABLE total_deposits_total (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    calculated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

select * from total_deposits_total;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_deposits_total(total_completed_amount, total_transactions)
SELECT 
SUM(w.actual_amount) AS total_completed_amount,
COUNT(*) AS total_transactions
FROM gaming_app_backend.webx_pay w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.status IN ('Completed', 'Success')
and w.created_at >= @cutoff;