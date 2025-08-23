-- =======================================
-- ZENESX FRAMEWORK DATABASE SCHEMA
-- Basierend auf PlumeESX mit ZS Banking Integration
-- =======================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- =======================================
-- MAIN USERS TABLE
-- =======================================
CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(60) NOT NULL,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `metadata` longtext DEFAULT NULL,
  `position` longtext DEFAULT NULL,
  `firstname` varchar(16) DEFAULT NULL,
  `lastname` varchar(16) DEFAULT NULL,
  `dateofbirth` varchar(10) DEFAULT NULL,
  `sex` varchar(1) DEFAULT 'M',
  `height` int(11) DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT 0,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(1) DEFAULT 0,
  `last_property` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_seen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `phone_number` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `id` (`id`),
  KEY `last_seen` (`last_seen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- JOBS SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- ITEMS SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` float NOT NULL DEFAULT 1,
  `rare` tinyint(4) NOT NULL DEFAULT 0,
  `can_remove` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- DATASTORE SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `datastore_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_datastore_data_name_owner` (`name`,`owner`),
  KEY `index_datastore_data_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- ADDON ACCOUNTS
-- =======================================
CREATE TABLE IF NOT EXISTS `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `addon_account_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_name` varchar(100) DEFAULT NULL,
  `money` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_addon_account_data_account_name_owner` (`account_name`,`owner`),
  KEY `index_addon_account_data_account_name` (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- ADDON INVENTORY
-- =======================================
CREATE TABLE IF NOT EXISTS `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(100) NOT NULL,
  `shared` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `addon_inventory_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventory_name` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addon_inventory_items_inventory_name_name` (`inventory_name`,`name`),
  KEY `index_addon_inventory_items_inventory_name_name_owner` (`inventory_name`,`name`,`owner`),
  KEY `index_addon_inventory_inventory_name` (`inventory_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- BILLING SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `sender` varchar(60) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(60) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- LICENSES SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- VEHICLES SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(60) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `job` varchar(20) DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `parking` varchar(60) DEFAULT NULL,
  `pound` varchar(60) DEFAULT NULL,
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`plate`),
  KEY `owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `vehicles` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- SOCIETY SYSTEM
-- =======================================
CREATE TABLE IF NOT EXISTS `society` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  `account` varchar(60) NOT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- ZS BANKING SYSTEM TABLES
-- =======================================

-- ZS Banking Crypto Transactions Table
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

-- ZS Banking Transfer History
CREATE TABLE IF NOT EXISTS `banking_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_identifier` varchar(60) NOT NULL,
  `to_identifier` varchar(60) NOT NULL,
  `from_name` varchar(255) DEFAULT NULL,
  `to_name` varchar(255) DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `fee` decimal(15,2) DEFAULT 0.00,
  `reason` varchar(255) DEFAULT NULL,
  `transfer_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `success` tinyint(1) NOT NULL DEFAULT 1,
  `error_message` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_from_identifier` (`from_identifier`),
  KEY `idx_to_identifier` (`to_identifier`),
  KEY `idx_transfer_date` (`transfer_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ZS Banking Account History
CREATE TABLE IF NOT EXISTS `banking_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `player_name` varchar(255) DEFAULT NULL,
  `transaction_type` enum('deposit','withdraw','transfer_in','transfer_out','crypto_buy','crypto_sell') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `balance_before` decimal(15,2) NOT NULL,
  `balance_after` decimal(15,2) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_identifier` (`identifier`),
  KEY `idx_transaction_date` (`transaction_date`),
  KEY `idx_transaction_type` (`transaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================
-- DEFAULT DATA INSERTS
-- =======================================

-- Jobs
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('unemployed', 'Unemployed', 0),
('police', 'Police', 1),
('ambulance', 'EMS', 1),
('mechanic', 'Mechanic', 1),
('taxi', 'Taxi', 0),
('cardealer', 'Car Dealer', 1),
('realestateagent', 'Real Estate Agent', 1),
('banker', 'Banker', 1),
('fisherman', 'Fisherman', 0),
('fueler', 'Fueler', 0),
('lumberjack', 'Lumberjack', 0),
('miner', 'Miner', 0),
('reporter', 'Reporter', 0),
('slaughterer', 'Slaughterer', 0),
('trucker', 'Trucker', 0),
('weazel', 'Weazel News', 1);

-- Job Grades (Basic setup for each job)
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('unemployed', 0, 'unemployed', 'Unemployed', 200, '{}', '{}'),
('police', 0, 'recruit', 'Recruit', 20, '{}', '{}'),
('police', 1, 'officer', 'Officer', 40, '{}', '{}'),
('police', 2, 'sergeant', 'Sergeant', 60, '{}', '{}'),
('police', 3, 'lieutenant', 'Lieutenant', 85, '{}', '{}'),
('police', 4, 'chief', 'Chief', 100, '{}', '{}'),
('ambulance', 0, 'ambulance', 'Jr. EMT', 20, '{}', '{}'),
('ambulance', 1, 'doctor', 'EMT', 40, '{}', '{}'),
('ambulance', 2, 'chief_doctor', 'Sr. EMT', 60, '{}', '{}'),
('ambulance', 3, 'boss', 'Chief', 80, '{}', '{}'),
('mechanic', 0, 'recrue', 'Trainee', 12, '{}', '{}'),
('mechanic', 1, 'novice', 'Novice', 24, '{}', '{}'),
('mechanic', 2, 'experimente', 'Experienced', 36, '{}', '{}'),
('mechanic', 3, 'chief', 'Chief', 48, '{}', '{}'),
('mechanic', 4, 'boss', 'Boss', 0, '{}', '{}'),
('taxi', 0, 'recrue', 'Trainee', 12, '[{"tshirt_1":59,"tshirt_2":0,"torso_1":87,"torso_2":0,"shoes_1":35,"shoes_2":0,"pants_1":36,"pants_2":0,"arms":27,"helmet_1":5,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":0,"decals_1":0,"decals_2":0,"mask_1":0}]', '[{"tshirt_1":36,"tshirt_2":0,"torso_1":48,"torso_2":0,"shoes_1":49,"shoes_2":0,"pants_1":44,"pants_2":4,"arms":1,"helmet_1":11,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":5,"decals_1":0,"decals_2":0,"mask_1":0}]'),
('taxi', 1, 'novice', 'Cabbie', 24, '[{"tshirt_1":59,"tshirt_2":0,"torso_1":87,"torso_2":0,"shoes_1":35,"shoes_2":0,"pants_1":36,"pants_2":0,"arms":27,"helmet_1":5,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":0,"decals_1":0,"decals_2":0,"mask_1":0}]', '[{"tshirt_1":36,"tshirt_2":0,"torso_1":48,"torso_2":0,"shoes_1":49,"shoes_2":0,"pants_1":44,"pants_2":4,"arms":1,"helmet_1":11,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":5,"decals_1":0,"decals_2":0,"mask_1":0}]'),
('taxi', 2, 'experimente', 'Experienced', 36, '[{"tshirt_1":59,"tshirt_2":0,"torso_1":87,"torso_2":0,"shoes_1":35,"shoes_2":0,"pants_1":36,"pants_2":0,"arms":27,"helmet_1":5,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":0,"decals_1":0,"decals_2":0,"mask_1":0}]', '[{"tshirt_1":36,"tshirt_2":0,"torso_1":48,"torso_2":0,"shoes_1":49,"shoes_2":0,"pants_1":44,"pants_2":4,"arms":1,"helmet_1":11,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":5,"decals_1":0,"decals_2":0,"mask_1":0}]'),
('taxi', 3, 'uber', 'Uber Cabbie', 48, '[{"tshirt_1":59,"tshirt_2":0,"torso_1":87,"torso_2":0,"shoes_1":35,"shoes_2":0,"pants_1":36,"pants_2":0,"arms":27,"helmet_1":5,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":0,"decals_1":0,"decals_2":0,"mask_1":0}]', '[{"tshirt_1":36,"tshirt_2":0,"torso_1":48,"torso_2":0,"shoes_1":49,"shoes_2":0,"pants_1":44,"pants_2":4,"arms":1,"helmet_1":11,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":5,"decals_1":0,"decals_2":0,"mask_1":0}]'),
('taxi', 4, 'boss', 'Boss', 0, '[{"tshirt_1":59,"tshirt_2":0,"torso_1":87,"torso_2":0,"shoes_1":35,"shoes_2":0,"pants_1":36,"pants_2":0,"arms":27,"helmet_1":5,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":0,"decals_1":0,"decals_2":0,"mask_1":0}]', '[{"tshirt_1":36,"tshirt_2":0,"torso_1":48,"torso_2":0,"shoes_1":49,"shoes_2":0,"pants_1":44,"pants_2":4,"arms":1,"helmet_1":11,"helmet_2":0,"bags_1":0,"bags_2":0,"chain_1":0,"chain_2":0,"ears_1":-1,"glasses_1":5,"decals_1":0,"decals_2":0,"mask_1":0}]');

-- Basic Items
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('bread', 'Bread', 1, 0, 1),
('water', 'Water', 1, 0, 1),
('phone', 'Phone', 1, 0, 1),
('money', 'Dirty Money', 0, 0, 1),
('fishingrod', 'Fishing Rod', 2, 0, 1),
('fish', 'Fish', 1, 0, 1),
('alive_chicken', 'Living Chicken', 1, 0, 1),
('slaughtered_chicken', 'Slaughtered Chicken', 1, 0, 1),
('packaged_chicken', 'Packaged Chicken', 1, 0, 1),
('cutted_wood', 'Cut Wood', 1, 0, 1),
('packaged_plank', 'Packaged Plank', 1, 0, 1),
('stone', 'Stone', 1, 0, 1),
('washed_stone', 'Washed Stone', 1, 0, 1),
('copper', 'Copper', 1, 0, 1),
('iron', 'Iron', 1, 0, 1),
('gold', 'Gold', 1, 0, 1),
('diamond', 'Diamond', 1, 0, 1),
('petrol', 'Oil', 1, 0, 1),
('petrol_raffin', 'Processed Oil', 1, 0, 1),
('essence', 'Gas', 1, 0, 1);

-- Datastore
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('society_police', 'Police', 1),
('society_ambulance', 'EMS', 1),
('society_mechanic', 'Mechanic', 1),
('society_taxi', 'Taxi', 1),
('society_cardealer', 'Car Dealer', 1),
('user_ears', 'Ears', 0),
('user_glasses', 'Glasses', 0),
('user_helmet', 'Helmet', 0),
('user_mask', 'Mask', 0);

-- Addon Accounts
INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_police', 'Police', 1),
('society_ambulance', 'EMS', 1),
('society_mechanic', 'Mechanic', 1),
('society_taxi', 'Taxi', 1),
('society_cardealer', 'Car Dealer', 1),
('caution', 'Caution', 0),
('bank', 'Bank', 0);

-- Addon Inventory
INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_police', 'Police', 1),
('society_ambulance', 'EMS', 1),
('society_mechanic', 'Mechanic', 1),
('society_taxi', 'Taxi', 1),
('society_cardealer', 'Car Dealer', 1);

-- Vehicle Categories
INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
('compacts', 'Compacts'),
('sedans', 'Sedans'),
('suvs', 'SUVs'),
('coupes', 'Coupes'),
('muscle', 'Muscle'),
('sports_classics', 'Sports Classics'),
('sports', 'Sports'),
('super', 'Super'),
('motorcycles', 'Motorcycles'),
('off_road', 'Off Road'),
('industrial', 'Industrial'),
('utility', 'Utility'),
('vans', 'Vans'),
('cycles', 'Cycles'),
('boats', 'Boats'),
('helicopters', 'Helicopters'),
('planes', 'Planes'),
('service', 'Service'),
('emergency', 'Emergency'),
('military', 'Military'),
('commercial', 'Commercial');

-- Society Data
INSERT INTO `society` (`name`, `label`, `account`, `money`) VALUES
('police', 'Police', 'society_police', 50000),
('ambulance', 'EMS', 'society_ambulance', 50000),
('mechanic', 'Mechanic', 'society_mechanic', 25000),
('taxi', 'Taxi', 'society_taxi', 15000),
('cardealer', 'Car Dealer', 'society_cardealer', 75000);

-- =======================================
-- ZS BANKING INDEXES FOR PERFORMANCE
-- =======================================

-- Zusätzliche Indizes für bessere Performance
CREATE INDEX IF NOT EXISTS `idx_identifier_date` ON `banking_crypto_transactions` (`identifier`, `transaction_date` DESC);
CREATE INDEX IF NOT EXISTS `idx_success_type` ON `banking_crypto_transactions` (`success`, `transaction_type`);
CREATE INDEX IF NOT EXISTS `idx_currency_date` ON `banking_crypto_transactions` (`crypto_currency`, `transaction_date` DESC);
CREATE INDEX IF NOT EXISTS `idx_banking_history_identifier_date` ON `banking_history` (`identifier`, `transaction_date` DESC);
CREATE INDEX IF NOT EXISTS `idx_transfers_date` ON `banking_transfers` (`transfer_date` DESC);

COMMIT;