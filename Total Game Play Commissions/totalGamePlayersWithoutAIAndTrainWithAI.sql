USE gaming_app_bi;
--
Create table totalGamePlayCommissions(
    id INT AUTO_INCREMENT PRIMARY KEY,
    base_amount_100pct INT NOT NULL,
    developer_share_50pct INT NOT NULL,
    tax_18pct INT NOT NULL,
    remainder_you_keep_32pct INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
--
select * from totalGamePlayCommissions;
--
SET @cutoff := '2025-08-26 18:30:00';

INSERT INTO totalGamePlayCommissions (base_amount_100pct,developer_share_50pct,tax_18pct,remainder_you_keep_32pct)
SELECT                                        
    SUM(pc.received_coins) AS base_amount_100pct,                                        
    0.50 * SUM(pc.received_coins) AS developer_share_50pct,                                        
    0.18 * SUM(pc.received_coins) AS tax_18pct,                                        
    0.32 * SUM(pc.received_coins) AS remainder_you_keep_32pct                                        
FROM gaming_app_backend.platform_commission pc                                        
LEFT JOIN gaming_app_backend.user_game_session ugs     ON ugs.id = user_game_session                                        
LEFT JOIN gaming_app_backend.user_game_session_v2 ugs2 ON ugs2.id = user_game_sessionv2                                        
LEFT JOIN gaming_app_backend.game_session gs           ON gs.id = COALESCE(ugs.game_session, ugs2.game_session)                                        
LEFT JOIN gaming_app_backend.game g                    ON g.id = gs.game                                        
WHERE COALESCE(pc.is_active,1) = 1                                        
  AND gs.created_at > '2025-09-27 18:30:00';
--
select * from totalGamePlayCommissions;
