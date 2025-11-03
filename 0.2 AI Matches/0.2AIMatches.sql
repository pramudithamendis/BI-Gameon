USE gaming_app_bi;
--
Create table _02AIMatches(
 id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(150) NOT NULL,
    player_email VARCHAR(150) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    report_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_player (player_id),
    INDEX idx_report_date (report_date)
);
--
select * from users;
--
SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO _02AIMatches (player_name,player_email,total_ai_matches,player_wins,player_losses,spend_amount_usd)
SELECT 
    CONCAT(u_player.first_name, ' ', u_player.last_name) AS player_name,
    u_player.email AS player_email,
   COUNT(*) AS total_ai_matches,
   SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN 0.20 ELSE 0 END), 2) AS spend_amount_usd
FROM  gaming_app_backend.game_session gs
JOIN  gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
JOIN  gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN  gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
WHERE 
    gs.created_at >= '2025-10-15'
    AND u_player.id NOT IN (1109,1110,1111,1112,1113)   
    AND u_opponent.id IN (1109,1110,1111,1112,1113)     
GROUP BY 
    u_player.id
ORDER BY 
    spend_amount_usd DESC;
--
select * from users;
