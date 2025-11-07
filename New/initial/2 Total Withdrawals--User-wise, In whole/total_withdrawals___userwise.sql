-- Total withdrawals --

select * from total_withdrawals_daily_userwise;

USE gaming_app_bi;

drop table total_withdrawals_daily_userwise;
select * from total_withdrawals_daily_userwise;
CREATE TABLE total_withdrawals_daily_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    user_id BIGINT NOT NULL,
    username VARCHAR(255) NOT NULL,
    total_withdrawal_amount DECIMAL(18, 2) NOT NULL DEFAULT 0,
    total_amount_lkr DECIMAL(18, 2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email(date_,user_id)
);


SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_daily_userwise(date_,user_id,username,total_withdrawal_amount,total_amount_lkr,total_transactions) SELECT DATE(w.created_at) AS date, u.id AS user_id, u.first_name AS username, SUM(w.withdrawal_amount) AS total_withdrawal_amount, SUM(w.amount_lkr) AS total_amount_lkr, COUNT(*) AS total_transactions FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND w.amount_lkr IS NOT NULL AND u.email NOT LIKE '%@gameonworld.ai%' and w.created_at >= @cutoff GROUP BY date, u.id, u.first_name ORDER BY date DESC, total_amount_lkr DESC;
select * from total_withdrawals_daily_userwise;

select * from total_withdrawals_weekly_userwise;

USE gaming_app_bi;

drop table total_withdrawals_monthly_userwise;
CREATE TABLE total_withdrawals_monthly_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL, -- Format YYYY-MM
    user_id BIGINT NOT NULL,
    username VARCHAR(255) NOT NULL,
    total_withdrawal_amount DECIMAL(18,2) DEFAULT 0,
    total_amount_lkr DECIMAL(18,2) DEFAULT 0,
    total_transactions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_email(month_,user_id)
);


SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_monthly_userwise(month_,user_id,username,total_withdrawal_amount,total_amount_lkr,total_transactions) SELECT DATE_FORMAT(w.created_at, '%Y-%m') AS month, u.id AS user_id, u.first_name AS username, SUM(w.withdrawal_amount) AS total_withdrawal_amount, SUM(w.amount_lkr) AS total_amount_lkr, COUNT(*) AS total_transactions FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND w.amount_lkr IS NOT NULL AND u.email NOT LIKE '%@gameonworld.ai%' and w.created_at >= @cutoff GROUP BY month, u.id, u.first_name ORDER BY month DESC, total_amount_lkr DESC;
select * from total_withdrawals_monthly_userwise;


select * from total_withdrawals_monthly_userwise;

drop table total_withdrawals_weekly_userwise;
CREATE TABLE total_withdrawals_weekly_userwise (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    week_label VARCHAR(10) NOT NULL,           -- Example: 2025-W35
    user_id BIGINT UNSIGNED NOT NULL,
    username VARCHAR(255) NOT NULL,
    
    total_withdrawal_amount DECIMAL(18, 6) NOT NULL DEFAULT 0,  -- crypto/token value
    total_amount_lkr DECIMAL(18, 2) NOT NULL DEFAULT 0,         -- value in LKR
    total_transactions INT NOT NULL DEFAULT 0,                  -- number of withdrawals
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
     UNIQUE KEY unique_user_email(week_label,user_id)

);

select * from total_withdrawals_weekly_userwise;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_withdrawals_weekly_userwise(week_label,user_id,username,total_withdrawal_amount,total_amount_lkr,total_transactions)
SELECT 
    CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) AS week_label,  
    u.id AS user_id,
    u.first_name AS username,
    SUM(w.withdrawal_amount) AS total_withdrawal_amount,
    SUM(w.amount_lkr) AS total_amount_lkr,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user u
JOIN gaming_app_backend.user_withdrawals w 
    ON w.user_id = u.id
WHERE w.is_active = 1
  AND w.status = 'Approved'
  AND w.amount_lkr IS NOT NULL
  AND u.email NOT LIKE '%@gameonworld.ai%'
  and w.created_at >= @cutoff
GROUP BY 
    week_label,
    u.id,
    u.first_name
ORDER BY 
    week_label DESC,
    total_amount_lkr DESC;
select * from total_withdrawals_weekly_userwise;


select * from total_withdrawals_total_userwise;

USE gaming_app_bi;


CREATE TABLE total_withdrawals_total_userwise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    username VARCHAR(255) NOT NULL,
    withdrawal_id BIGINT NOT NULL,
    status_ VARCHAR(50) NOT NULL,
    withdrawal_amount DECIMAL(18, 2) DEFAULT 0,
    amount_lkr DECIMAL(18, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


SET @cutoff := '2025-09-27 18:30:00'; insert into total_withdrawals_total_userwise(user_id,username,withdrawal_id,status_,withdrawal_amount,amount_lkr) SELECT u.id AS user_id, u.first_name AS username, w.id AS withdrawal_id, w.status, w.withdrawal_amount, w.amount_lkr FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND u.email NOT LIKE '%@gameonworld.ai%' AND w.amount_lkr IS NOT NULL and w.created_at >= @cutoff ORDER BY w.created_at DESC;
