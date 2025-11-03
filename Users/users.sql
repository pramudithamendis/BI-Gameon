USE gaming_app_bi;
--
Create table users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    metrics VARCHAR(100) NOT NULL,          -- e.g. 'total_users'
    data_type VARCHAR(50) NOT NULL,         -- e.g. 'card'
    f_list JSON NOT NULL,                   -- JSON_ARRAY(...)
    value_list JSON NOT NULL,               -- JSON_OBJECT(...)
    metric_date DATETIME NOT NULL,          -- formatted date string
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
)
--
select * from users;
--
SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO users (metrics,data_type,f_list,value_list,metric_date,created_at)
SELECT 
    'total_users' AS metrics,
    'card' AS data_type,
    JSON_ARRAY('total_users') AS f_list,
    JSON_OBJECT('total_users', COUNT(*)) AS value_list,
    DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') AS metric_date,
    NOW() AS created_at
FROM gaming_app_backend.`user`
WHERE created_at > '2025-08-26 18:30:00'
--
select * from users;
