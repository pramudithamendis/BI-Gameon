USE gaming_app_bi;

-- Get yesterday's date in Singapore timezone
SET @yesterday := DATE(CONVERT_TZ(DATE_SUB(NOW(), INTERVAL 1 DAY), '+00:00', '+08:00'));

INSERT INTO totalGamePlayersWithoutAIAndTrainWithAI (value)
SELECT 
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE 
    gs.created_at > '2025-09-27'
    AND gs.game_session_mode NOT IN (3, 5);
WHERE DATE(CONVERT_TZ(u.created_at, '+00:00', '+08:00')) = @yesterday
ON DUPLICATE KEY UPDATE 
    value = VALUES(value),
    updated_at = CURRENT_TIMESTAMP;

--
select * from total_deposits_daily;
