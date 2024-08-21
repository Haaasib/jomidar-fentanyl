CREATE TABLE IF NOT EXISTS `jomidar_fentanyl` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `owner` varchar(50) NOT NULL,
    `model` varchar(255) NOT NULL,
    `position` text NOT NULL,
    `rotation` text NOT NULL,
    `amount` int(11) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
