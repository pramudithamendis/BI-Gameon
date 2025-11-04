CREATE TABLE Total_Game_Plays_without_AI_and_Train_With_AI (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_sessions INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

drop table Total_Game_Plays_without_AI_and_Train_With_AI;
select * from Total_Game_Plays_without_AI_and_Train_With_AI;

insert into Total_Game_Plays_without_AI_and_Train_With_AI(total_sessions)
SELECT 
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs 
    ON gs.id = ugs.game_session
WHERE 
    gs.created_at > '2025-09-27'
    AND gs.game_session_mode NOT IN (3, 5)

