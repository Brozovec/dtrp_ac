CREATE TABLE IF NOT EXISTS `dtrpac-bans` (
    `ban_id` varchar(16) COLLATE utf8mb4_bin DEFAULT NULL,
    `playername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
    `license` varchar(50) COLLATE utf8mb4_bin PRIMARY KEY,
    `hex` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
    `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
    `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
    `reason` varchar(255) NOT NULL,
    `token` varchar(130) COLLATE utf8mb4_bin DEFAULT NULL,
    `token2` varchar(95) COLLATE utf8mb4_bin DEFAULT NULL,
    `token3` varchar(95) COLLATE utf8mb4_bin DEFAULT NULL,
    `token4` varchar(95) COLLATE utf8mb4_bin DEFAULT NULL,
    `token5` varchar(95) COLLATE utf8mb4_bin DEFAULT NULL,
    `token6` varchar(95) COLLATE utf8mb4_bin DEFAULT NULL,
    `token7` varchar(95) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*
    IF DTRPAC-BANS ALREADY EXISTS THEN IMPORT THAT:
*/
ALTER TABLE `dtrpac-bans`
ADD COLUMN `ban_id` varchar(16) DEFAULT NULL,
ADD COLUMN `token` varchar(130) DEFAULT NULL,
ADD COLUMN `token2` varchar(95) DEFAULT NULL,
ADD COLUMN `token3` varchar(95) DEFAULT NULL,
ADD COLUMN `token4` varchar(95) DEFAULT NULL,
ADD COLUMN `token5` varchar(95) DEFAULT NULL,
ADD COLUMN `token6` varchar(95) DEFAULT NULL,
ADD COLUMN `token7` varchar(95) DEFAULT NULL;