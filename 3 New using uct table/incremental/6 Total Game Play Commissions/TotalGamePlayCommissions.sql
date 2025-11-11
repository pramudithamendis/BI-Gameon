
select * from TotalGamePlayCommissions;

USE gaming_app_bi;

-- Get yesterday's date in Singapore time (UTC+8)
-- SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

-- INSERT INTO TotalGamePlayCommissions (
--     date,
--     base_amount_100pct,
--     developer_share_50pct,
--     tax_18pct,
--     remainder_you_keep_32pct
-- )
-- SELECT
--     DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date,
--     SUM(pc.received_coins) AS base_amount_100pct,
--     0.50 * SUM(pc.received_coins) AS developer_share_50pct,
--     0.18 * SUM(pc.received_coins) AS tax_18pct,
--     0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
-- FROM gaming_app_backend.platform_commission pc
-- LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
-- LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
-- LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
-- LEFT JOIN gaming_app_backend.game g                    ON g.id = gs.game
-- WHERE
--     COALESCE(pc.is_active,1) = 1
--     AND DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
-- GROUP BY date
-- ON DUPLICATE KEY UPDATE
--     base_amount_100pct = VALUES(base_amount_100pct),
--     developer_share_50pct = VALUES(developer_share_50pct),
--     tax_18pct = VALUES(tax_18pct),
--     remainder_you_keep_32pct = VALUES(remainder_you_keep_32pct),
--     updated_at = CURRENT_TIMESTAMP;



select * from TotalGamePlayCommissions_monthly;

USE gaming_app_bi;

-- Get previous month in Singapore timezone (returns YYYY-MM)
SET @last_month := DATE_FORMAT(
    CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 MONTH), '+00:00', '+08:00'),
    '%Y-%m'
);

INSERT INTO TotalGamePlayCommissions_monthly (
    month_,
    base_amount_100pct,
    developer_share_50pct,
    tax_18pct,
    remainder_you_keep_32pct
)
SELECT
    DATE_FORMAT(CONVERT_TZ(gs.created_at, '+00:00', '+08:00'), '%Y-%m') AS month_,
    SUM(pc.received_coins) AS base_amount_100pct,
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,
    0.18 * SUM(pc.received_coins) AS tax_18pct,
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active,1) = 1
  AND DATE_FORMAT(CONVERT_TZ(gs.created_at, '+00:00', '+08:00'), '%Y-%m') = @last_month
GROUP BY month_
ON DUPLICATE KEY UPDATE
    base_amount_100pct      = VALUES(base_amount_100pct),
    developer_share_50pct   = VALUES(developer_share_50pct),
    tax_18pct               = VALUES(tax_18pct),
    remainder_you_keep_32pct = VALUES(remainder_you_keep_32pct),
    updated_at = CURRENT_TIMESTAMP;
select * from TotalGamePlayCommissions_monthly;



select * from TotalGamePlayCommissions_weekly;

USE gaming_app_bi;

-- Get last completed week in ISO format (Mon–Sun)
-- YEARWEEK(..., 1) ensures ISO week (week starts Monday)
SET @last_week := YEARWEEK(DATE_SUB(NOW(), INTERVAL 1 WEEK), 1);

INSERT INTO TotalGamePlayCommissions_weekly (
    year_week,
    week_start_date,
    week_end_date,
    base_amount_100pct,
    developer_share_50pct,
    tax_18pct,
    remainder_you_keep_32pct
)
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
  AND YEARWEEK(gs.created_at, 1) = @last_week
GROUP BY year_week
ON DUPLICATE KEY UPDATE
    base_amount_100pct      = VALUES(base_amount_100pct),
    developer_share_50pct   = VALUES(developer_share_50pct),
    tax_18pct               = VALUES(tax_18pct),
    remainder_you_keep_32pct= VALUES(remainder_you_keep_32pct),
    week_start_date         = VALUES(week_start_date),
    week_end_date           = VALUES(week_end_date),
    updated_at              = CURRENT_TIMESTAMP;
select * from TotalGamePlayCommissions_weekly;



select * from TotalGamePlayCommissions_daily;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (UTC+8)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO TotalGamePlayCommissions_daily (
    date_,
    base_amount_100pct,
    developer_share_50pct,
    tax_18pct,
    remainder_you_keep_32pct
)
SELECT
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
    SUM(pc.received_coins) AS base_amount_100pct,
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,
    0.18 * SUM(pc.received_coins) AS tax_18pct,
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct
FROM gaming_app_backend.platform_commission pc
LEFT JOIN gaming_app_backend.user_game_session ugs
       ON ugs.id = pc.user_game_session
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2
       ON ugs2.id = pc.user_game_sessionv2
LEFT JOIN gaming_app_backend.game_session gs
       ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)
WHERE COALESCE(pc.is_active, 1) = 1
  AND DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE
    base_amount_100pct = VALUES(base_amount_100pct),
    developer_share_50pct = VALUES(developer_share_50pct),
    tax_18pct = VALUES(tax_18pct),
    remainder_you_keep_32pct = VALUES(remainder_you_keep_32pct),
    updated_at = CURRENT_TIMESTAMP;
select * from TotalGamePlayCommissions_daily;
