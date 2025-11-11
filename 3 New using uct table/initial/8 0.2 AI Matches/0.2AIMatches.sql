CREATE TABLE _02AiMatches (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(255),
    player_email VARCHAR(255) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table _02AiMatches;

select * from _02AiMatches;

INSERT INTO _02AiMatches (
    player_name, player_email, total_ai_matches, player_wins,
    player_losses, spend_amount_usd
)
SELECT 
    CONCAT(u_player.first_name, ' ', u_player.last_name) AS player_name,
    u_player.email AS player_email,
   COUNT(*) AS total_ai_matches,
   SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN 0.20 ELSE 0 END), 2) AS spend_amount_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
WHERE 
    gs.created_at >= '2025-10-15'
    AND u_player.id NOT IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)   
    AND u_opponent.id IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)     
GROUP BY 
    u_player.id
ORDER BY 
    spend_amount_usd DESC;
select * from _02AiMatches;

drop table _02AiMatches_monthly;

drop table _02AiMatches_monthly;
CREATE TABLE _02AiMatches_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL,                              -- Format: YYYY-MM
    player_id BIGINT NOT NULL,                              -- Reference to user table
    player_name VARCHAR(255),
    player_email VARCHAR(255) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,   -- 0.20 per loss
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key month_player_id(month_,player_id)
   );

drop table _02AiMatches_monthly;
select * from _02AiMatches_monthly;

INSERT INTO _02AiMatches_monthly
(
    month_, player_id, player_name, player_email,
    total_ai_matches, player_wins, player_losses, spend_amount_usd
)
SELECT 
    DATE_FORMAT(gs.created_at, '%Y-%m') AS month_, 
    u_player.id AS player_id,
    CONCAT(u_player.first_name, ' ', u_player.last_name) AS player_name,
    u_player.email AS player_email,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN 0.20 ELSE 0 END), 2) AS spend_amount_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
WHERE 
    u_player.id NOT IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
    AND u_opponent.id IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
GROUP BY 
    month_, 
    u_player.id
ORDER BY 
    month_ DESC,
    spend_amount_usd DESC;
select * from _02AiMatches_monthly;

drop table _02AiMatches_weekly;
CREATE TABLE _02AiMatches_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    week_label VARCHAR(10) NOT NULL ,        -- e.g. 2025-W05
    player_name VARCHAR(255),
    player_email VARCHAR(255) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key month_player_id(week_label,player_email)
);

drop table _02AiMatches_weekly;
select * from _02AiMatches_weekly;

insert into _02AiMatches_weekly(
    week_label, player_name, player_email,
    total_ai_matches, player_wins, player_losses, spend_amount_usd
)
SELECT 
    CONCAT(YEAR(gs.created_at), '-W', LPAD(WEEK(gs.created_at, 1), 2, '0')) AS week_label, 
    CONCAT(u_player.first_name, ' ', u_player.last_name) AS player_name,
    u_player.email AS player_email,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN 0.20 ELSE 0 END), 2) AS spend_amount_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
WHERE 
    u_player.id NOT IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
    AND u_opponent.id IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
GROUP BY 
    week_label, 
    u_player.id
ORDER BY 
    week_label DESC,
    spend_amount_usd DESC;
select * from _02AiMatches_weekly;

drop table _02AiMatches_daily;
CREATE TABLE _02AiMatches_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    date_ DATE NOT NULL,
    player_name VARCHAR(150),
    player_email VARCHAR(150) NOT NULL,
    total_ai_matches INT NOT NULL DEFAULT 0,
    player_wins INT NOT NULL DEFAULT 0,
    player_losses INT NOT NULL DEFAULT 0,
    spend_amount_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    unique key month_player_id(date_,player_email)
);

drop table _02AiMatches_daily;
select * from _02AiMatches_daily;

insert into _02AiMatches_daily (
    date_, player_name, player_email, total_ai_matches, player_wins, player_losses, spend_amount_usd
)
SELECT 
    DATE(gs.created_at) AS date_,  
    CONCAT(u_player.first_name, ' ', u_player.last_name) AS player_name,
    u_player.email AS player_email,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS player_losses,
    ROUND(SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN 0.20 ELSE 0 END), 2) AS spend_amount_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user u_player 
    ON u_player.id = ugp.user
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
WHERE 
    u_player.id NOT IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
    AND u_opponent.id IN (1109,1110,1111,1112,1113,1164,1165,1166,1167,1168,1169)
GROUP BY 
    date_, 
    u_player.id
ORDER BY 
    date_ DESC,
    spend_amount_usd DESC;
select * from _02AiMatches_daily;
