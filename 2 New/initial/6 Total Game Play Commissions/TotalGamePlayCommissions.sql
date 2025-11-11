
CREATE TABLE TotalGamePlayCommissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    summary_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    base_amount_100pct DECIMAL(18,2) NOT NULL,
    developer_share_50pct DECIMAL(18,2) NOT NULL,
    tax_18pct DECIMAL(18,2) NOT NULL,
    remainder_you_keep_32pct DECIMAL(18,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from TotalGamePlayCommissions;

insert into TotalGamePlayCommissions(base_amount_100pct,
developer_share_50pct,
tax_18pct,
remainder_you_keep_32pct)
SELECT                                        
    SUM(pc.received_coins) AS base_amount_100pct,                                        
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,                                        
    0.18 * SUM(pc.received_coins) AS tax_18pct,                                        
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct                                        
FROM gaming_app_backend.platform_commission pc                                        
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session                                        
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2                                        
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)                                        
LEFT JOIN gaming_app_backend.game g                    ON g.id = gs.game                                        
WHERE COALESCE(pc.is_active,1) = 1                                        
  AND gs.created_at > '2025-09-27 18:30:00';
  
  
  
  drop table TotalGamePlayCommissions_monthly;
  CREATE TABLE TotalGamePlayCommissions_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ CHAR(7) NOT NULL unique,  -- Format: YYYY-MM
    base_amount_100pct DECIMAL(18,2) NOT NULL,
    developer_share_50pct DECIMAL(18,2) NOT NULL,
    tax_18pct DECIMAL(18,2) NOT NULL,
    remainder_you_keep_32pct DECIMAL(18,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from TotalGamePlayCommissions_monthly;

insert into TotalGamePlayCommissions_monthly(month_,base_amount_100pct,developer_share_50pct,tax_18pct,remainder_you_keep_32pct)
SELECT
DATE_FORMAT(gs.created_at, '%Y-%m') AS month_,
SUM(pc.received_coins) AS base_amount_100pct,
0.50 * SUM(pc.received_coins) AS developer_share_50pct,
0.18 * SUM(pc.received_coins) AS tax_18pct,
0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active,1) = 1
  AND gs.created_at >= '2025-09-27'
GROUP BY DATE_FORMAT(gs.created_at, '%Y-%m')
ORDER BY DATE_FORMAT(gs.created_at, '%Y-%m') DESC;
select * from TotalGamePlayCommissions_monthly;


drop table TotalGamePlayCommissions_weekly;
CREATE TABLE TotalGamePlayCommissions_weekly (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,

    year_week INT NOT NULL unique,                         -- e.g. 202540 (ISO week format)
    week_start_date DATE NOT NULL,                  -- Monday of the week
    week_end_date DATE NOT NULL,                    -- Sunday of the week

    base_amount_100pct DECIMAL(18,2) NOT NULL,      -- Total received_coins
    developer_share_50pct DECIMAL(18,2) NOT NULL,   -- 50% of base amount
    tax_18pct DECIMAL(18,2) NOT NULL,               -- 18% of base amount
    remainder_you_keep_32pct DECIMAL(18,2) NOT NULL,-- Remaining 32%

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from TotalGamePlayCommissions_weekly;

insert into TotalGamePlayCommissions_weekly(year_week,week_start_date,week_end_date,base_amount_100pct,developer_share_50pct,tax_18pct,remainder_you_keep_32pct)
SELECT
    YEARWEEK(gs.created_at, 1) AS year_week,
    MIN(DATE(gs.created_at)) AS week_start_date,
    MAX(DATE(gs.created_at)) AS week_end_date,
    SUM(pc.received_coins) AS base_amount_100pct,
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,
    0.18 * SUM(pc.received_coins) AS tax_18pct,
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active,1) = 1
  AND gs.created_at >= '2025-09-27'
GROUP BY YEARWEEK(gs.created_at, 1)
ORDER BY YEARWEEK(gs.created_at, 1) DESC;
select * from TotalGamePlayCommissions_weekly;


drop table TotalGamePlayCommissions_daily;
CREATE TABLE TotalGamePlayCommissions_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL unique,
    base_amount_100pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    developer_share_50pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    tax_18pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    remainder_you_keep_32pct DECIMAL(18, 4) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from TotalGamePlayCommissions_daily;

insert into TotalGamePlayCommissions_daily(date_,base_amount_100pct,developer_share_50pct,tax_18pct,remainder_you_keep_32pct)
SELECT
    DATE(gs.created_at) AS date,
    SUM(pc.received_coins) AS base_amount_100pct,
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,
    0.18 * SUM(pc.received_coins) AS tax_18pct,
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active,1) = 1
  AND gs.created_at >= '2025-09-27'
GROUP BY DATE(gs.created_at)
ORDER BY DATE(gs.created_at) DESC;

select * from TotalGamePlayCommissions_daily;
