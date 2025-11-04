-- Total withdrawals --

select * from total_withdrawals_daily_userwise;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_withdrawals_daily_userwise
    (date_, user_id, username, total_withdrawal_amount, total_amount_lkr, total_transactions)
SELECT 
    DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) AS date_, 
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
  AND DATE(CONVERT_TZ(w.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY 
    date_,
    u.id,
    u.first_name
ON DUPLICATE KEY UPDATE
    total_withdrawal_amount = VALUES(total_withdrawal_amount),
    total_amount_lkr = VALUES(total_amount_lkr),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;

select * from total_withdrawals_weekly_userwise;


USE gaming_app_bi;

-- Get last week's label in Singapore timezone (+08:00)
SET @last_week := CONCAT(
    YEAR(CONVERT_TZ(NOW(), '+00:00', '+08:00') - INTERVAL 1 WEEK),
    '-W',
    LPAD(WEEK(CONVERT_TZ(NOW(), '+00:00', '+08:00') - INTERVAL 1 WEEK, 1), 2, '0')
);

INSERT INTO total_withdrawals_weekly_userwise
    (week_label, user_id, username, total_withdrawal_amount, total_amount_lkr, total_transactions)
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
WHERE 
    w.is_active = 1
    AND w.status = 'Approved'
    AND w.amount_lkr IS NOT NULL
    AND u.email NOT LIKE '%@gameonworld.ai%'
    AND CONCAT(YEAR(w.created_at), '-W', LPAD(WEEK(w.created_at, 1), 2, '0')) = @last_week
GROUP BY 
    week_label,
    u.id,
    u.first_name
ON DUPLICATE KEY UPDATE
    total_withdrawal_amount = VALUES(total_withdrawal_amount),
    total_amount_lkr = VALUES(total_amount_lkr),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;



USE gaming_app_bi;

-- Get last month's year-month string in Singapore time (+08:00)
SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%Y-%m'
);

INSERT INTO total_withdrawals_monthly_userwise
(
    month_,
    user_id,
    username,
    total_withdrawal_amount,
    total_amount_lkr,
    total_transactions
)
SELECT 
    DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') AS month_,
    u.id AS user_id,
    u.first_name AS username,
    SUM(w.withdrawal_amount) AS total_withdrawal_amount,
    SUM(w.amount_lkr) AS total_amount_lkr,
    COUNT(*) AS total_transactions
FROM gaming_app_backend.user u
JOIN gaming_app_backend.user_withdrawals w 
    ON w.user_id = u.id
WHERE 
    w.is_active = 1
    AND w.status = 'Approved'
    AND w.amount_lkr IS NOT NULL
    AND u.email NOT LIKE '%@gameonworld.ai%'
    AND DATE_FORMAT(CONVERT_TZ(w.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY 
    month_,
    u.id,
    u.first_name
ON DUPLICATE KEY UPDATE
    total_withdrawal_amount = VALUES(total_withdrawal_amount),
    total_amount_lkr = VALUES(total_amount_lkr),
    total_transactions = VALUES(total_transactions),
    updated_at = CURRENT_TIMESTAMP;


select * from total_withdrawals_monthly_userwise;


select * from total_withdrawals_total_userwise;

USE gaming_app_bi;

-- Get yesterday's date (Singapore timezone +08:00)
SET @yesterday_start := CONVERT_TZ(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '+00:00', '+08:00');
SET @yesterday_end   := CONVERT_TZ(CURDATE(), '+00:00', '+08:00');

INSERT INTO total_withdrawals_total_userwise
    (user_id, username, withdrawal_id, status_, withdrawal_amount, amount_lkr, created_at)
SELECT 
    u.id AS user_id,
    u.first_name AS username,
    w.id AS withdrawal_id,
    w.status AS status_,
    w.withdrawal_amount,
    w.amount_lkr,
    w.created_at
FROM gaming_app_backend.user u
JOIN gaming_app_backend.user_withdrawals w 
    ON w.user_id = u.id
WHERE w.is_active = 1
  AND w.status = 'Approved'
  AND u.email NOT LIKE '%@gameonworld.ai%'
  AND w.amount_lkr IS NOT NULL
  AND w.created_at >= @yesterday_start
  AND w.created_at < @yesterday_end
ON DUPLICATE KEY UPDATE
    status_ = VALUES(status_),
    withdrawal_amount = VALUES(withdrawal_amount),
    amount_lkr = VALUES(amount_lkr),
    updated_at = CURRENT_TIMESTAMP;
