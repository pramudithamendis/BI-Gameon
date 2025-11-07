

select * from total_game_plays_total;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone (+08:00)
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_game_plays_total (date, total_sessions)
SELECT 
    @yesterday AS date,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;


-- CREATE TABLE total_game_plays_monthly (
--     id BIGINT AUTO_INCREMENT PRIMARY KEY,
--     month_year VARCHAR(7) NOT NULL,   -- format: YYYY-MM
--     total_sessions INT NOT NULL,
--     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );


-- insert into total_game_plays_monthly("",total_sessions)
-- SELECT 
--     COUNT(DISTINCT gs.id) AS total_sessions
-- FROM gaming_app_backend.game_session gs
-- JOIN gaming_app_backend.user_game_session ugs
--     ON gs.id = ugs.game_session
-- WHERE YEAR(gs.created_at) = YEAR(CURDATE())   
--   AND MONTH(gs.created_at) = MONTH(CURDATE()); 



select * from total_game_plays_weekly;

USE gaming_app_bi;

-- Define last week in ISO week format (Monday–Sunday)
SET @last_week := YEARWEEK(DATE_SUB(CURDATE(), INTERVAL 1 WEEK), 1);

-- Calculate week start + week end for last week (Singapore time +08:00)
SET @week_start := DATE_SUB(
    DATE_FORMAT(CONVERT_TZ(CURDATE(), '+00:00', '+08:00'), '%Y-%m-%d'),
    INTERVAL (WEEKDAY(CONVERT_TZ(CURDATE(), '+00:00', '+08:00')) + 7) DAY
);
SET @week_end := DATE_ADD(@week_start, INTERVAL 6 DAY);

INSERT INTO total_game_plays_weekly (week_start, week_end, total_sessions)
SELECT
    @week_start AS week_start,
    @week_end AS week_end,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE YEARWEEK(CONVERT_TZ(gs.created_at, '+00:00', '+08:00'), 1) = @last_week
ON DUPLICATE KEY UPDATE
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;
select * from total_game_plays_weekly;


select * from total_game_plays_daily;

USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO total_game_plays_daily (date_, total_sessions)
SELECT 
    DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) AS date_,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE DATE(CONVERT_TZ(gs.created_at, '+00:00', '+08:00')) = @yesterday
GROUP BY date_
ON DUPLICATE KEY UPDATE 
    total_sessions = VALUES(total_sessions),
    updated_at = CURRENT_TIMESTAMP;
select * from total_game_plays_daily;


