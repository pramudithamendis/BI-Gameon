USE gaming_app_bi;
--
Create table totalGamePlayersWithoutAIAndTrainWithAI(
    id INT AUTO_INCREMENT PRIMARY KEY,
    value INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
--
select * from totalGamePlayersWithoutAIAndTrainWithAI;
--
SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO totalGamePlayersWithoutAIAndTrainWithAI (value)
SELECT 
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE 
    gs.created_at > '2025-09-27'
    AND gs.game_session_mode NOT IN (3, 5);
--
select * from totalGamePlayersWithoutAIAndTrainWithAI;
