-- Total withdrawals --


select * from total_withdrawals_daily;

USE gaming_app_bi;

drop table total_withdrawals_total;
CREATE TABLE total_withdrawals_total (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT primary key,
    total_withdrawal_usd DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_withdrawal_lkr DECIMAL(18,2) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from total_withdrawals_total;

SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_total(total_withdrawal_usd, total_withdrawal_lkr) SELECT SUM(w.withdrawal_amount) AS total_withdrawal_usd, SUM(w.amount_lkr) AS total_withdrawal_lkr FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND u.email NOT LIKE '%@gameonworld.ai%' AND w.amount_lkr IS NOT NULL and w.created_at >= @cutoff;


select * from total_withdrawals_weekly;

USE gaming_app_bi;

drop table total_withdrawals_weekly;
CREATE TABLE total_withdrawals_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT primary key,
    year_week INT NOT NULL COMMENT 'Format: YYYYWW (e.g., 202544)' unique,
    week_start_date DATE NOT NULL,
    week_end_date DATE NOT NULL,
    total_withdrawal_usd DECIMAL(18, 2) DEFAULT 0,
    total_withdrawal_lkr DECIMAL(18, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;


SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_weekly(year_week,week_start_date,week_end_date,total_withdrawal_usd,total_withdrawal_lkr) SELECT YEARWEEK(w.created_at, 1) AS year_week, MIN(DATE(w.created_at)) AS week_start_date, MAX(DATE(w.created_at)) AS week_end_date, SUM(w.withdrawal_amount) AS total_withdrawal_usd, SUM(w.amount_lkr) AS total_withdrawal_lkr FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND u.email NOT LIKE '%@gameonworld.ai%' AND w.amount_lkr IS NOT NULL and w.created_at >= @cutoff GROUP BY YEARWEEK(w.created_at, 1) ORDER BY YEARWEEK(w.created_at, 1) DESC;
select * from total_withdrawals_weekly;

select * from total_withdrawals_monthly;

USE gaming_app_bi;

select * from total_withdrawals_monthly;
drop table total_withdrawals_monthly;
CREATE TABLE total_withdrawals_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique, -- Format: YYYY-MM
    total_withdrawal_usd DECIMAL(15,2) DEFAULT 0,
    total_withdrawal_lkr DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_monthly(month_,total_withdrawal_usd,total_withdrawal_lkr) SELECT DATE_FORMAT(w.created_at, '%Y-%m') AS month, SUM(w.withdrawal_amount) AS total_withdrawal_usd, SUM(w.amount_lkr) AS total_withdrawal_lkr FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND u.email NOT LIKE '%@gameonworld.ai%' AND w.amount_lkr IS NOT NULL and w.created_at >= @cutoff GROUP BY DATE_FORMAT(w.created_at, '%Y-%m') ORDER BY DATE_FORMAT(w.created_at, '%Y-%m') DESC;
select * from total_withdrawals_monthly;


drop table total_withdrawals_total;

select * from total_withdrawals_total;

USE gaming_app_bi;

drop table total_withdrawals_daily;
CREATE TABLE total_withdrawals_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL unique,
    total_withdrawal_usd DECIMAL(18, 2) NOT NULL DEFAULT 0,
    total_withdrawal_lkr DECIMAL(18, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SET @cutoff := '2025-09-27 18:30:00'; 
insert into total_withdrawals_daily(date_,total_withdrawal_usd,total_withdrawal_lkr) SELECT DATE(w.created_at) AS date, SUM(w.withdrawal_amount) AS total_withdrawal_usd, SUM(w.amount_lkr) AS total_withdrawal_lkr FROM gaming_app_backend.user u JOIN gaming_app_backend.user_withdrawals w ON w.user_id = u.id WHERE w.is_active = 1 AND w.status = 'Approved' AND u.email NOT LIKE '%@gameonworld.ai%' AND w.amount_lkr IS NOT NULL and w.created_at >= @cutoff GROUP BY DATE(w.created_at) ORDER BY DATE(w.created_at) DESC;
select * from total_withdrawals_daily;