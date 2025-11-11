CREATE TABLE oldmatches (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_ai_matches INT NOT NULL DEFAULT 0,
    total_player_wins INT NOT NULL DEFAULT 0,
    total_player_losses INT NOT NULL DEFAULT 0,
    total_spent_in_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop table oldmatches;
select * from oldmatches;

insert into oldmatches(
    total_ai_matches, total_player_wins, total_player_losses, total_spent_in_usd
)
SELECT 
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS total_player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS total_player_losses,
    SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN uca.coins ELSE 0 END) AS total_spent_in_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp ON ugp.game_session = gs.id
JOIN gaming_app_backend.user_game_session ugo ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent ON u_opponent.id = ugo.user
JOIN gaming_app_backend.bot b ON b.user_id = u_opponent.id
LEFT JOIN gaming_app_backend.user_coin_action uca ON ugo.user_coin_action = uca.id
WHERE 
    gs.game_session_mode = 5
    AND DATE(gs.created_at) BETWEEN '2025-10-07' AND '2025-10-16';
    
drop table oldmatches_monthly;
CREATE TABLE oldmatches_monthly (
id BIGINT AUTO_INCREMENT PRIMARY KEY,
year_ INT NOT NULL,
month_number INT NOT NULL unique,
month_name VARCHAR(20) NOT NULL,
total_ai_matches INT NOT NULL DEFAULT 0,
total_player_wins INT NOT NULL DEFAULT 0,
total_player_losses INT NOT NULL DEFAULT 0,
total_spent_in_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from oldmatches_monthly;

insert into oldmatches_monthly(year_, month_number, month_name, total_ai_matches,total_player_wins,total_player_losses,total_spent_in_usd)
SELECT 
    YEAR(gs.created_at) AS year_,
    MONTH(gs.created_at) AS month_number,
    DATE_FORMAT(MIN(gs.created_at), '%M') AS month_name,  
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS total_player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS total_player_losses,
    SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN uca.coins ELSE 0 END) AS total_spent_in_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp 
    ON ugp.game_session = gs.id
JOIN gaming_app_backend.user_game_session ugo 
    ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent 
    ON u_opponent.id = ugo.user
JOIN gaming_app_backend.bot b 
    ON b.user_id = u_opponent.id
LEFT JOIN gaming_app_backend.user_coin_action uca 
    ON ugo.user_coin_action = uca.id
WHERE 
    gs.game_session_mode = 5
    AND DATE(gs.created_at) BETWEEN '2025-10-07' AND '2025-10-16'
GROUP BY 
    year_, month_number
ORDER BY 
    year_, month_number;
select * from oldmatches_monthly;

drop table oldmatches_weekly;
CREATE TABLE oldmatches_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    year_ INT NOT NULL,
    week_number INT NOT NULL unique,
    total_ai_matches INT DEFAULT 0,
    total_player_wins INT DEFAULT 0,
    total_player_losses INT DEFAULT 0,
    total_spent_in_usd DECIMAL(12,2) DEFAULT 0,       
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

drop table oldmatches_weekly;

select * from oldmatches_weekly;

insert into oldmatches_weekly(year_, week_number, total_ai_matches,total_player_wins,total_player_losses,total_spent_in_usd)
SELECT 
    YEAR(gs.created_at) AS year_,
    WEEK(gs.created_at, 1) AS week_number,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS total_player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS total_player_losses,
    SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN uca.coins ELSE 0 END) AS total_spent_in_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp ON ugp.game_session = gs.id
JOIN gaming_app_backend.user_game_session ugo ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent ON u_opponent.id = ugo.user
JOIN gaming_app_backend.bot b ON b.user_id = u_opponent.id
LEFT JOIN gaming_app_backend.user_coin_action uca ON ugo.user_coin_action = uca.id
WHERE 
    gs.game_session_mode = 5
    AND DATE(gs.created_at) BETWEEN '2025-10-07' AND '2025-10-16'
GROUP BY 
    year_, week_number
ORDER BY 
    year_, week_number;
select * from oldmatches_weekly;


drop table oldmatches_daily;
CREATE TABLE oldmatches_daily (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    match_date DATE NOT NULL UNIQUE,  -- One row per day

    total_ai_matches INT NOT NULL DEFAULT 0,
    total_player_wins INT NOT NULL DEFAULT 0,
    total_player_losses INT NOT NULL DEFAULT 0,
    total_spent_in_usd DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from oldmatches_daily;

insert into oldmatches_daily(match_date,total_ai_matches,total_player_wins,total_player_losses,total_spent_in_usd)
SELECT 
    DATE(gs.created_at) AS match_date,
    COUNT(*) AS total_ai_matches,
    SUM(CASE WHEN ugp.is_game_won = 1 THEN 1 ELSE 0 END) AS total_player_wins,
    SUM(CASE WHEN ugp.is_game_won = 0 AND ugp.is_game_finished = 1 THEN 1 ELSE 0 END) AS total_player_losses,
    SUM(CASE WHEN ugo.is_game_won = 0 AND ugo.is_game_finished = 1 THEN uca.coins ELSE 0 END) AS total_spent_in_usd
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugp ON ugp.game_session = gs.id
JOIN gaming_app_backend.user_game_session ugo ON ugo.game_session = gs.id AND ugo.user <> ugp.user
JOIN gaming_app_backend.user u_opponent ON u_opponent.id = ugo.user
JOIN gaming_app_backend.bot b ON b.user_id = u_opponent.id
LEFT JOIN gaming_app_backend.user_coin_action uca ON ugo.user_coin_action = uca.id
WHERE 
    gs.game_session_mode = 5
    AND DATE(gs.created_at) BETWEEN '2025-10-07' AND '2025-10-16'
GROUP BY 
    match_date
ORDER BY 
    match_date ASC;
select * from oldmatches_daily;
