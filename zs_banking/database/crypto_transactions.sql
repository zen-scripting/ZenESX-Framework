-- =======================================
-- ZS BANKING CRYPTO TRANSACTIONS TABLE
-- =======================================

CREATE TABLE IF NOT EXISTS `banking_crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `transaction_type` enum('buy','sell') NOT NULL,
  `crypto_currency` varchar(10) NOT NULL,
  `crypto_amount` decimal(20,8) NOT NULL,
  `usd_amount` decimal(15,2) NOT NULL,
  `exchange_rate` decimal(15,8) NOT NULL,
  `fee_amount` decimal(15,2) DEFAULT 0.00,
  `total_amount` decimal(15,2) NOT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `success` tinyint(1) NOT NULL DEFAULT 1,
  `error_message` text DEFAULT NULL,
  `server_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_identifier` (`identifier`),
  KEY `idx_transaction_date` (`transaction_date`),
  KEY `idx_crypto_currency` (`crypto_currency`),
  KEY `idx_transaction_type` (`transaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- VIEWS FOR BETTER DATA ACCESS
-- =======================================

-- View für Player Crypto History
CREATE OR REPLACE VIEW `banking_crypto_player_history` AS
SELECT 
    bct.*,
    DATE_FORMAT(bct.transaction_date, '%Y-%m-%d %H:%i:%s') as formatted_date,
    CASE 
        WHEN bct.transaction_type = 'buy' THEN CONCAT('+', bct.crypto_amount, ' ', bct.crypto_currency)
        ELSE CONCAT('-', bct.crypto_amount, ' ', bct.crypto_currency)
    END as crypto_change,
    CASE 
        WHEN bct.transaction_type = 'buy' THEN CONCAT('-$', bct.total_amount)
        ELSE CONCAT('+$', bct.total_amount)
    END as usd_change
FROM `banking_crypto_transactions` bct
WHERE bct.success = 1;

-- View für tägliche Statistiken
CREATE OR REPLACE VIEW `banking_crypto_daily_stats` AS
SELECT 
    DATE(transaction_date) as trade_date,
    crypto_currency,
    COUNT(*) as total_transactions,
    SUM(CASE WHEN transaction_type = 'buy' THEN 1 ELSE 0 END) as buy_transactions,
    SUM(CASE WHEN transaction_type = 'sell' THEN 1 ELSE 0 END) as sell_transactions,
    SUM(usd_amount) as total_volume,
    AVG(exchange_rate) as avg_rate,
    SUM(fee_amount) as total_fees
FROM `banking_crypto_transactions`
WHERE success = 1
GROUP BY DATE(transaction_date), crypto_currency;

-- =======================================
-- INDEXES FOR PERFORMANCE
-- =======================================

-- Zusätzliche Indizes für bessere Performance
CREATE INDEX IF NOT EXISTS `idx_identifier_date` ON `banking_crypto_transactions` (`identifier`, `transaction_date` DESC);
CREATE INDEX IF NOT EXISTS `idx_success_type` ON `banking_crypto_transactions` (`success`, `transaction_type`);
CREATE INDEX IF NOT EXISTS `idx_currency_date` ON `banking_crypto_transactions` (`crypto_currency`, `transaction_date` DESC);

-- =======================================
-- SAMPLE DATA (OPTIONAL)
-- =======================================

-- Beispiel-Daten für Tests (optional - kann entfernt werden)
/*
INSERT INTO `banking_crypto_transactions` 
(`identifier`, `player_name`, `transaction_type`, `crypto_currency`, `crypto_amount`, `usd_amount`, `exchange_rate`, `fee_amount`, `total_amount`, `success`) 
VALUES 
('steam:12345', 'TestPlayer', 'buy', 'BTC', 0.001, 50.00, 50000.00, 2.50, 52.50, 1),
('steam:12345', 'TestPlayer', 'sell', 'ETH', 0.025, 100.00, 4000.00, 5.00, 95.00, 1),
('steam:67890', 'AnotherPlayer', 'buy', 'ADA', 1000.00, 500.00, 0.50, 25.00, 525.00, 1);
*/

