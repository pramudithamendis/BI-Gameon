
CREATE TABLE total_game_plays_total (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    total_sessions BIGINT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

drop table total_game_plays_total;

select * from total_game_plays_total;
SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_plays_total(total_sessions)
SELECT 
COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
ON gs.id = ugs.game_session
where gs.created_at >= @cutoff;

drop table total_game_plays_monthly;
CREATE TABLE total_game_plays_monthly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    month_ VARCHAR(7) NOT NULL unique,   -- format: YYYY-MM
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


select * from total_game_plays_monthly;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_plays_monthly(month_,total_sessions)
SELECT 
    DATE_FORMAT(gs.created_at, '%Y-%m') AS month_,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE gs.created_at >= @cutoff
GROUP BY DATE_FORMAT(gs.created_at, '%Y-%m')
ORDER BY month_;
select * from total_game_plays_monthly;


drop table total_game_plays_weekly;
CREATE TABLE total_game_plays_weekly (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    week_start DATE NOT NULL unique,
    week_end DATE NOT NULL,
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
select * from total_game_plays_weekly;

SET @cutoff := '2025-09-27 18:30:00';
insert into total_game_plays_weekly(week_start, week_end, total_sessions)
SELECT 
    MIN(DATE(gs.created_at)) AS week_start,
    MAX(DATE(gs.created_at)) AS week_end,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE YEARWEEK(gs.created_at, 1) = YEARWEEK(CURDATE(), 1)
and gs.created_at >= @cutoff;
select * from total_game_plays_weekly;


drop table total_game_plays_daily;
CREATE TABLE total_game_plays_daily(
    date_ DATE NOT NULL PRIMARY KEY unique,
    total_sessions INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

select * from total_game_plays_daily;

insert into total_game_plays_daily(date_,total_sessions)
SELECT 
    DATE(gs.created_at) AS date_,
    COUNT(DISTINCT gs.id) AS total_sessions
FROM gaming_app_backend.game_session gs
JOIN gaming_app_backend.user_game_session ugs
    ON gs.id = ugs.game_session
WHERE DATE(gs.created_at) = CURDATE()
GROUP BY DATE(gs.created_at)
ORDER BY DATE(gs.created_at);
select * from total_game_plays_daily;

