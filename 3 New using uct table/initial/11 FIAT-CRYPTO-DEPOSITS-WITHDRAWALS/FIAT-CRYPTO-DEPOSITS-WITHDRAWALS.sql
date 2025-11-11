
-- user_coin_transaction_method
	-- 3 withdrawal
    -- 4 fiat-deposit
    -- 5 crypto-deposit
    -- 9 crypto-withdrawal

drop table uct_total_deposits_fiat;
CREATE TABLE uct_total_deposits_fiat (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
select * from uct_total_deposits_fiat;

SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_deposits_fiat(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.user_coin_transaction_method = 4
and w.created_at >= @cutoff
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;
select * from uct_total_deposits_fiat;




drop table uct_total_deposits_crypto;
CREATE TABLE uct_total_deposits_crypto (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
select * from uct_total_deposits_crypto;
SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_deposits_crypto(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.user_coin_transaction_method = 5
and w.created_at >= @cutoff
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;
select * from uct_total_deposits_crypto;

drop table uct_total_withdrawal_fiat;
CREATE TABLE uct_total_withdrawal_fiat (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
select * from uct_total_withdrawal_fiat;

SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_withdrawal_fiat(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.user_coin_transaction_method = 3
and w.created_at >= @cutoff
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;
select * from uct_total_withdrawal_fiat;




drop table uct_total_withdrawal_crypto;
CREATE TABLE uct_total_withdrawal_crypto (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL UNIQUE,
    total_completed_amount DECIMAL(18,2) NOT NULL DEFAULT 0,
    total_transactions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
select * from uct_total_withdrawal_crypto;

SET @cutoff := '2025-09-27 18:30:00';
insert into uct_total_withdrawal_crypto(date_,total_completed_amount, total_transactions)
SELECT 
	   DATE(w.created_at) AS date_,
	   SUM(w.coins) as total_completed_coins,
	    COUNT(*) AS total_transactions
FROM gaming_app_backend.user_coin_transaction w
JOIN gaming_app_backend.user u ON w.user = u.id
WHERE w.user_coin_transaction_method = 9
and w.created_at >= @cutoff
GROUP BY DATE(w.created_at)
ORDER BY DATE(w.created_at) DESC;
select * from uct_total_withdrawal_crypto;