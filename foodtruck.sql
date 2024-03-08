CREATE TABLE IF NOT EXISTS `foodtruck_owners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `plate` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;


INSERT INTO `items` (`name`, `label`, `weight`) VALUES
	('hotdog', 'Hotdog', 1),
	('taco', 'Taco', 1),;