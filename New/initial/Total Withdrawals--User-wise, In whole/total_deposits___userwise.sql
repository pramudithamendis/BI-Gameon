-- Total Deposits - User-wise  --

select * from total_deposits_daily_userwise;

USE gaming_app_bi;

CREATE TABLE total_deposits_daily_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_ DATE NOT NULL,
    total_completed_amount DECIMAL(18,2) NOT NULL,
    total_transactions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


drop table total_deposits_daily_userwise; 
SET @cutoff := '2025-09-27 18:30:00'; insert into total_deposits_daily_userwise(user_id, email, first_name, last_name, date_, total_completed_amount, total_transactions) SELECT w.user AS user_id, u.email, u.first_name, u.last_name, DATE(w.created_at) AS date, SUM(w.actual_amount) AS total_completed_amount, COUNT(*) AS total_transactions FROM gaming_app_backend.webx_pay w JOIN gaming_app_backend.user u ON w.user = u.id WHERE w.status IN ('Completed', 'Success') and w.created_at >= @cutoff GROUP BY w.user, u.email, u.first_name, u.last_name, DATE(w.created_at) ORDER BY date DESC, total_completed_amount DESC;

select * from total_deposits_daily_userwise;
select * from total_deposits_total_userwise;

select * from total_deposits_weekly_userwise;

CREATE TABLE total_deposits_weekly_userwise (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150) NULL,
    last_name VARCHAR(150) NULL,
    year INT NOT NULL,
    week_number INT NOT NULL,
    week_label VARCHAR(10) NOT NULL,   -- e.g. "2025-W08"
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


SET @cutoff := '2025-09-27 18:30:00'; insert into total_deposits_weekly_userwise(user_id, email,first_name,last_name,year,week_number,week_label,total_completed_amount,total_transactions) SELECT w.user AS user_id, u.email, u.first_name, u.last_name, YEAR(w.created_at) AS year, WEEK(w.created_at, 1) AS week_number, CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) AS week_label, SUM(w.actual_amount) AS total_completed_amount, COUNT(*) AS total_transactions FROM gaming_app_backend.webx_pay w JOIN gaming_app_backend.user u ON w.user = u.id WHERE w.status IN ('Completed', 'Success') and w.created_at >= @cutoff GROUP BY user_id, u.email, u.first_name, u.last_name, YEAR(w.created_at), WEEK(w.created_at, 1), CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) ORDER BY year DESC, week_number DESC, total_completed_amount DESC;

select * from total_deposits_weekly_userwise;

drop table total_deposits_monthly_userwise;
select * from total_deposits_monthly_userwise;

USE gaming_app_bi;

CREATE TABLE total_deposits_monthly_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    month_ VARCHAR(7) NOT NULL,  -- Format: YYYY-MM
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMAMESSTAMP DEFAULT CURRENT_TIMESTAMP
);


SET @cutoff := '2025-09-27 18:30:00'; insert into total_deposits_monthly_userwise(user_id,email,first_name,last_name,month_,total_completed_amount,total_transactions) SELECT w.user AS user_id, u.email, u.first_name, u.last_name, DATE_FORMAT(w.created_at, '%Y-%m') AS month, SUM(w.actual_amount) AS total_completed_amount, COUNT(*) AS total_transactions FROM gaming_app_backend.webx_pay w JOIN gaming_app_backend.user u ON w.user = u.id WHERE w.status IN ('Completed', 'Success') and w.created_at >= @cutoff GROUP BY w.user, u.email, u.first_name, u.last_name, DATE_FORMAT(w.created_at, '%Y-%m') ORDER BY month DESC, total_completed_amount DESC;

select * from total_deposits_total_userwise;

USE gaming_app_bi;

CREATE TABLE total_deposits_total_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    email VARCHAR(255) NOT NULL,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    total_completed_amount DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


SET @cutoff := '2025-09-27 18:30:00'; insert into total_deposits_total_userwise(user_id,email,first_name,last_name,total_completed_amount,total_transactions) SELECT w.user AS user_id, u.email, u.first_name, u.last_name, SUM(w.actual_amount) AS total_completed_amount, COUNT(*) AS total_transactions FROM gaming_app_backend.webx_pay w JOIN gaming_app_backend.user u ON w.user = u.id WHERE w.status IN ('Completed', 'Success') and w.created_at >= @cutoff GROUP BY w.user, u.email, u.first_name, u.last_name ORDER BY total_completed_amount DESC;