drop table users_total;

CREATE TABLE users_total (
    id BIGINT NOT NULL AUTO_INCREMENT,
    metrics VARCHAR(100) NOT NULL,          -- e.g., 'total_users'
    data_type VARCHAR(50) NOT NULL,         -- e.g., 'card'
    f_list JSON NOT NULL,                   -- JSON array of field names
    value_list JSON NOT NULL,               -- JSON object containing key:value pairs
    metric_date DATETIME NOT NULL,          -- Metric timestamp (string formatted OR stored as DATETIME)
    created_at DATETIME NOT NULL,           -- Insert time
    primary key(id)
);

select * from users_total;

insert into users_total(metrics, data_type,f_list,value_list,metric_date,created_at)
SELECT 
    'total_users' AS metrics,
    'card' AS data_type,
    JSON_ARRAY('total_users') AS f_list,
    JSON_OBJECT('total_users', COUNT(*)) AS value_list,
    DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') AS metric_date,
    NOW() AS created_at
FROM gaming_app_backend.`user`
WHERE created_at > '2025-08-26 18:30:00';
select * from users_total;

drop table users_monthly;
CREATE TABLE users_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    period DATE NOT NULL unique,             -- first date of the month
    frequency ENUM('daily','weekly','monthly','yearly') NOT NULL,
    user_count INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from users_monthly;

insert into users_monthly(period,frequency,user_count)
SELECT 
    DATE(MIN(created_at)) AS period,
    'monthly' AS frequency,
    COUNT(*) AS user_count
FROM gaming_app_backend.`user`
WHERE created_at > '2025-08-26 18:30:00'
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY period;
select * from users_monthly;

drop table users_weekly;
CREATE TABLE users_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    period DATE NOT NULL unique,
    frequency ENUM('daily', 'weekly', 'monthly') NOT NULL DEFAULT 'weekly',
    user_count INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from users_weekly;

insert into users_weekly(period,frequency,user_count)
SELECT 
    DATE(max(created_at)) AS period,
    'weekly' AS frequency,
    COUNT(*) AS user_count
FROM gaming_app_backend.`user`
WHERE created_at > '2025-08-26 18:30:00'
GROUP BY YEAR(created_at), WEEK(created_at)
ORDER BY period;
select * from users_weekly;


drop table users_daily;
CREATE TABLE users_daily (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    period DATE NOT NULL unique ,
    frequency ENUM('daily', 'weekly', 'monthly') NOT NULL DEFAULT 'daily',
    user_count INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from users_daily;

insert into users_daily(period,frequency,user_count)
SELECT 
    DATE(created_at) AS period,
    'daily' AS frequency,
    COUNT(*) AS user_count
FROM gaming_app_backend.`user`
WHERE created_at > '2025-08-26 18:30:00'
GROUP BY DATE(created_at)
ORDER BY period;
select * from users_daily;