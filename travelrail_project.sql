-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Lun 14 Décembre 2020 à 17:37
-- Version du serveur :  10.1.10-MariaDB
-- Version de PHP :  5.6.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `travelrail_project`
--

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_new_city` (IN `name` VARCHAR(50), IN `zipcode` VARCHAR(50), IN `country` VARCHAR(50))  NO SQL
INSERT INTO city(city_name,city_zipcode,city_country)
VALUES(name,zipcode,country)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_new_client` (IN `lastName` VARCHAR(50), IN `firstName` VARCHAR(50), IN `mail` VARCHAR(50), IN `mdp` TEXT, IN `birthDate` DATE, IN `street` VARCHAR(50), IN `house` VARCHAR(50), IN `cityName` VARCHAR(50))  NO SQL
INSERT INTO client (c_lastName, c_firstName, c_mail, c_mdp, c_birth_date, c_street, c_house_nb, city_name)
VALUES(lastName, firstName, mail, mdp, birthDate, street, house, cityName)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_new_payment` (IN `type` TINYINT)  NO SQL
INSERT INTO payment(p_amount,p_type,p_date)
VALUES(0,type,curdate())$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_new_train` (IN `type` VARCHAR(50), IN `capacity` INT, IN `maintenance_date` DATE)  NO SQL
INSERT INTO train(t_type,t_capacity,t_maintenance_date)
VALUES (type,capacity,maintenance_date)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_new_travel` (IN `departure_date` DATE, IN `departure_hour` TIME, IN `departure_station` VARCHAR(50), IN `arrival_hour` TIME, IN `arrival_station` VARCHAR(50), IN `price` FLOAT, IN `train_id` INT)  NO SQL
INSERT INTO travel(tr_departure_date, tr_departure_hour, tr_departure_station, tr_arrival_hour, tr_arrival_station, tr_price, train_id)
VALUES (departure_date, departure_hour, departure_station, arrival_hour, arrival_station, price, train_id)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `creat_new_ticket` (IN `exchangeable` TINYINT, IN `refundable` TINYINT, IN `class` TINYINT, IN `departure_date` DATE, IN `departure_station` VARCHAR(50), IN `destination` VARCHAR(50), IN `reduction_card` VARCHAR(50), IN `client_id` INT, IN `payment_id` INT)  NO SQL
INSERT INTO ticket(ticket_exchangeable, ticket_refundable, ticket_class, ticket_departure_date, ticket_departure_station, ticket_destination, book_reduction_card, client_id, payment_id)
VALUES (exchangeable, refundable, class, departure_date, departure_station, destination, reduction_card, client_id, payment_id)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_avgPrice_by_destination` (IN `Destination` VARCHAR(50))  NO SQL
SELECT ticket.ticket_departure_station, AVG(ticket.ticket_price) 
FROM ticket
WHERE UCASE(ticket.ticket_destination) = UCASE(Destination)
GROUP BY ticket.ticket_departure_station$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nb_travel_by_destination` (IN `Destination` VARCHAR(50), OUT `nb_travel` INT(50))  NO SQL
SELECT COUNT(*) INTO nb_travel FROM travel
WHERE UCASE(travel.tr_arrival_station) = UCASE(Destination)

# UCASE nous permet de tout mettre en majuscule 
# Ca nous permet d'avoir le resultat souhaiter même si l'utilisateur rentre une destination en minuscule
# Par exemple paris ou PARIS au lieu de Paris
$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_passengers_by_departure` (IN `Departure` VARCHAR(50))  NO SQL
SELECT  client.c_lastName, client.c_firstName FROM client
INNER JOIN ticket on client.client_id = ticket.client_id
INNER JOIN assign on assign.ticket_id= ticket.ticket_id
INNER JOIN travel on assign.travel_id = travel.travel_id
WHERE UCASE(travel.tr_departure_station) = UCASE(Departure)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_scheduled_by_train` (IN `id_train` INT(50))  NO SQL
SELECT travel.tr_departure_station, travel.tr_departure_date, travel.tr_departure_hour, travel.tr_arrival_station, travel.tr_arrival_hour
FROM train

INNER JOIN travel ON train.train_id = travel.train_id

WHERE (train.train_id = id_train) AND (travel.tr_departure_date BETWEEN curdate() AND date_add(curdate(),INTERVAL 1 month))

# curdat() récupère la date du jour
# date_add(curdate(),INTERVAL 1 month) recupère la date dans un mois
$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_scheduled_by_travel` (IN `Departure` VARCHAR(50), IN `Destination` VARCHAR(50))  NO SQL
SELECT tr_departure_station, tr_departure_date, tr_departure_hour, tr_arrival_station, tr_arrival_hour
FROM travel
WHERE UCASE(tr_departure_station) = UCASE(Departure) AND UCASE(tr_arrival_station) = UCASE(Destination)

# UCASE nous permet de tout mettre en majuscule 
# Ca nous permet d'avoir le resultat souhaiter même si l'utilisateur rentre une destination en minuscule
# Par exemple paris ou PARIS au lieu de Paris
$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_travel_chara_by_departure` (IN `Departure` VARCHAR(50))  NO SQL
SELECT * FROM travel
WHERE UCASE(travel.tr_departure_station) = UCASE(Departure)

# UCASE nous permet de tout mettre en majuscule 
# Ca nous permet d'avoir le resultat souhaiter même si l'utilisateur rentre une destination en minuscule
# Par exemple paris ou PARIS au lieu de Paris
$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_travel_passengersNames_by_trainType` (IN `train_type` VARCHAR(50))  NO SQL
SELECT travel.tr_departure_date, travel.tr_departure_hour, travel.tr_departure_station, travel.tr_arrival_station, travel.tr_arrival_hour, client.c_lastName, client.c_firstName FROM assign
INNER JOIN ticket on assign.ticket_id = ticket.ticket_id
INNER JOIN client on client.client_id = ticket.client_id
INNER JOIN travel on assign.travel_id = travel.travel_id
INNER JOIN train on travel.train_id = train.train_id
WHERE UCASE(train.t_type) = UCASE(train_type)

# UCASE nous permet de tout mettre en majuscule 
# Ca nous permet d'avoir le resultat souhaiter même si l'utilisateur rentre une destination en minuscule
# Par exemple ter ou Ter au lieu de TER
$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `annual sales report`
--
CREATE TABLE `annual sales report` (
`YEAR(payment.p_date)` int(4)
,`SUM(payment.p_amount)` decimal(32,2)
,`ROUND(AVG(payment.p_amount),2)` decimal(11,2)
);

-- --------------------------------------------------------

--
-- Structure de la table `assign`
--

CREATE TABLE `assign` (
  `travel_id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `assign`
--

INSERT INTO `assign` (`travel_id`, `ticket_id`) VALUES
(2, 1),
(1, 2),
(4, 2);

-- --------------------------------------------------------

--
-- Structure de la table `city`
--

CREATE TABLE `city` (
  `city_name` varchar(50) NOT NULL,
  `city_zipcode` varchar(50) NOT NULL,
  `city_country` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `city`
--

INSERT INTO `city` (`city_name`, `city_zipcode`, `city_country`) VALUES
('BORDEAUX', '33000', 'FRANCE'),
('BRUXELLES', '1000', 'BELGIQUE'),
('Colombes', '92700', 'France'),
('LILLE', '59000', 'FRANCE'),
('Lyon', '69000', 'France'),
('Monaco', '98000', 'Monaco'),
('MONTPELLIER', '34000', 'FRANCE'),
('NANTES', '44000', 'FRANCE'),
('NICE', '06000', 'FRANCE'),
('Paris', '75000', 'France'),
('Rennes', '35000', 'France'),
('ROUEN', '76000', 'FRANCE'),
('Sceaux', '92330', 'France'),
('TOULOUSE', '31000', 'FRANCE'),
('Vannes', '56000', 'France'),
('ZURICH', '8000', 'SUISE');

--
-- Déclencheurs `city`
--
DELIMITER $$
CREATE TRIGGER `capital_country_city` BEFORE INSERT ON `city` FOR EACH ROW SET new.city_name = upper(new.city_name), new.city_country = upper(new.city_country)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE `client` (
  `client_id` int(11) NOT NULL,
  `c_lastName` varchar(50) NOT NULL,
  `c_firstName` varchar(50) NOT NULL,
  `c_mail` varchar(255) NOT NULL,
  `c_mdp` text NOT NULL,
  `c_birth_date` date NOT NULL,
  `c_street` varchar(50) NOT NULL,
  `c_house_nb` varchar(50) NOT NULL,
  `city_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `client`
--

INSERT INTO `client` (`client_id`, `c_lastName`, `c_firstName`, `c_mail`, `c_mdp`, `c_birth_date`, `c_street`, `c_house_nb`, `city_name`) VALUES
(1, 'SIMON', 'Charles', 'charles.simon@epfedu.fr', '', '1997-08-12', '', '', 'Vannes'),
(2, 'FABRE', 'Emma', 'emma.fabre@epfedu.fr', '', '1999-06-27', '', '', 'Rennes'),
(3, 'MASSY', 'Enguerran', 'enguerran.massy@epfedu.fr', '', '1997-11-05', 'av François Bernier ', '23', 'Colombes'),
(4, 'DUPOND', 'Jean', 'jean.dupond@gmail.com', '123456', '1984-06-11', 'Rue de Rivolie', '59', 'PARIS'),
(7, 'CASTEX', 'Jean', 'jean.castex@gmail.com', 'jesuis1erministre', '1974-04-25', 'rue Marie Curie', '89', 'Rouen'),
(8, 'MACRON', 'Emmanuel', 'manu.macron@elysee.fr', 'cestmoilebosse', '1977-12-21', 'Rue du Faubourg Saint-Honoré', '55', 'PARIS'),
(9, 'FORD', 'Henry', 'henry.ford@fordmotors.com', 'jaimelesvoitures', '1863-07-30', 'rue du moteur ', '46', 'Toulouse'),
(10, 'MUSK', 'Elon', 'elon.musk@tesla.com', 'electricvorever', '1971-06-24', 'avenue des fusee', '124', 'Colombes'),
(11, 'WASHINGTON', 'George ', 'gege.wawa@usa.usa', 'jesuislepremier', '1732-04-13', 'rue de l''amerique', '12', 'Lyon'),
(12, 'WOOKIE', 'Chewbacca', 'chewbacca@starwars.univers', 'wookiefirst', '0200-12-21', 'Kashyyyk', '24', 'bruxelles'),
(13, 'CHRIST', 'Jesus', 'jesus.dieu@cieux.paradis', 'jesuispasmort', '0000-00-00', 'rue de paradis', '1', 'Paris'),
(14, 'JAMES', 'BOND', 'james.bond@mi5.uk', '007', '1953-12-13', 'rue des secret', '007', 'MONTPELLIER');

--
-- Déclencheurs `client`
--
DELIMITER $$
CREATE TRIGGER `capital_last_name` BEFORE INSERT ON `client` FOR EACH ROW SET new.c_lastName = upper(new.c_lastName)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `monthly delay report`
--
CREATE TABLE `monthly delay report` (
`YEAR(travel.tr_departure_date)` int(4)
,`MONTHNAME(travel.tr_departure_date)` varchar(9)
,`SEC_TO_TIME(SUM(travel.tr_delay))` time
,`SEC_TO_TIME(AVG(travel.tr_delay))` time(4)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `monthly sales report`
--
CREATE TABLE `monthly sales report` (
`YEAR(payment.p_date)` int(4)
,`MONTHNAME(payment.p_date)` varchar(9)
,`SUM(payment.p_amount)` decimal(32,2)
,`ROUND(AVG(payment.p_amount),2)` decimal(11,2)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `monthly satisfaction report`
--
CREATE TABLE `monthly satisfaction report` (
`YEAR(ticket.ticket_departure_date)` int(4)
,`MONTHNAME(ticket.ticket_departure_date)` varchar(9)
,`ROUND(AVG(ticket.ticket_satisfaction),2)` decimal(13,2)
);

-- --------------------------------------------------------

--
-- Structure de la table `payment`
--

CREATE TABLE `payment` (
  `payment_id` int(11) NOT NULL,
  `p_amount` decimal(10,2) NOT NULL,
  `p_type` tinyint(1) NOT NULL,
  `p_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table with the data of a payment';

--
-- Contenu de la table `payment`
--

INSERT INTO `payment` (`payment_id`, `p_amount`, `p_type`, `p_date`) VALUES
(1, '136.25', 0, '2020-11-10'),
(2, '24.55', 0, '2020-05-20'),
(3, '40.35', 1, '2019-08-06'),
(4, '78.80', 0, '2019-08-13'),
(5, '80.50', 1, '2020-07-15'),
(6, '113.25', 1, '2020-04-21'),
(7, '29.60', 0, '2019-06-11'),
(8, '36.85', 0, '2020-03-16'),
(9, '16.80', 0, '2019-12-26'),
(10, '2.40', 1, '2020-11-19');

--
-- Déclencheurs `payment`
--
DELIMITER $$
CREATE TRIGGER `set_payment_amount` AFTER INSERT ON `payment` FOR EACH ROW UPDATE payment
JOIN ticket ON payment.payment_id = ticket.payment_id
SET payment.p_amount = SUM(ticket.ticket_price)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `ticket`
--

CREATE TABLE `ticket` (
  `ticket_id` int(11) NOT NULL,
  `ticket_price` float NOT NULL,
  `ticket_exchangeable` tinyint(1) NOT NULL,
  `ticket_refundable` tinyint(1) NOT NULL,
  `ticket_class` tinyint(1) NOT NULL,
  `ticket_satisfaction` int(11) NOT NULL,
  `ticket_departure_date` date NOT NULL,
  `ticket_departure_station` varchar(50) NOT NULL,
  `ticket_destination` varchar(50) NOT NULL,
  `ticket_direct` tinyint(1) NOT NULL,
  `book_reduction_card` varchar(50) NOT NULL,
  `client_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `ticket`
--

INSERT INTO `ticket` (`ticket_id`, `ticket_price`, `ticket_exchangeable`, `ticket_refundable`, `ticket_class`, `ticket_satisfaction`, `ticket_departure_date`, `ticket_departure_station`, `ticket_destination`, `ticket_direct`, `book_reduction_card`, `client_id`, `payment_id`) VALUES
(1, 2.8, 0, 0, 0, 5, '2020-11-11', 'Paris', 'Colombes', 0, '', 3, 1),
(2, 50, 1, 1, 1, 3, '2020-11-24', 'Bordeaux', 'Rennes', 1, 'Young_card', 2, 2);

--
-- Déclencheurs `ticket`
--
DELIMITER $$
CREATE TRIGGER `set_ticketPrice` BEFORE INSERT ON `ticket` FOR EACH ROW UPDATE ticket
JOIN assign ON assign.ticket_id = ticket.ticket_id
JOIN travel ON travel.travel_id = assign.travel_id
SET ticket.ticket_price = SUM(travel.tr_price)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `set_ticketPrice_x1.2` AFTER UPDATE ON `ticket` FOR EACH ROW UPDATE ticket
SET ticket.ticket_price = ticket.ticket_price*1.2
WHERE ticket.ticket_refundable = 1 OR ticket.ticket_exchangeable = 1 OR ticket.ticket_class = 1
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `set_ticketPrice_x1.4` AFTER INSERT ON `ticket` FOR EACH ROW UPDATE ticket
SET ticket.ticket_price = ticket.ticket_price*1.4
WHERE (ticket.ticket_exchangeable = 1 AND ticket.ticket_refundable = 1)
OR (ticket.ticket_exchangeable = 1 AND ticket.ticket_class = 1) 
OR (ticket.ticket_class = 1 AND ticket.ticket_refundable = 1)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `set_ticketPrice_x1.6` BEFORE UPDATE ON `ticket` FOR EACH ROW UPDATE ticket
SET ticket.ticket_price = ticket.ticket_price*1.6
WHERE (ticket.ticket_refundable = 1 AND ticket.ticket_exchangeable = 1 AND ticket.ticket_class = 1)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Structure de la table `train`
--

CREATE TABLE `train` (
  `train_id` int(11) NOT NULL,
  `t_type` varchar(50) NOT NULL,
  `t_capacity` int(11) NOT NULL,
  `t_maintenance_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `train`
--

INSERT INTO `train` (`train_id`, `t_type`, `t_capacity`, `t_maintenance_date`) VALUES
(1, 'TER', 100, '2020-06-16'),
(2, 'TER', 150, '2020-07-15'),
(3, 'TER', 200, '2019-11-13'),
(4, 'Intercité', 100, '2020-03-03'),
(5, 'Intercité', 150, '2020-07-01'),
(6, 'Intercité', 200, '2020-02-04'),
(7, 'TGV', 200, '2020-01-14'),
(8, 'TGV', 250, '2020-10-07'),
(9, 'TGV', 300, '2020-07-23'),
(10, 'TGV', 400, '2019-08-06'),
(11, 'TER', 200, '2020-10-12'),
(12, 'TGV', 400, '2020-08-12');

-- --------------------------------------------------------

--
-- Structure de la table `travel`
--

CREATE TABLE `travel` (
  `travel_id` int(11) NOT NULL,
  `tr_departure_date` date NOT NULL,
  `tr_departure_hour` time NOT NULL,
  `tr_departure_station` varchar(50) NOT NULL,
  `tr_arrival_hour` time NOT NULL,
  `tr_arrival_station` varchar(50) NOT NULL,
  `tr_price` float NOT NULL,
  `tr_delay` time NOT NULL,
  `tr_delay_cause` varchar(50) NOT NULL,
  `train_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `travel`
--

INSERT INTO `travel` (`travel_id`, `tr_departure_date`, `tr_departure_hour`, `tr_departure_station`, `tr_arrival_hour`, `tr_arrival_station`, `tr_price`, `tr_delay`, `tr_delay_cause`, `train_id`) VALUES
(1, '2020-11-25', '12:00:00', 'Paris', '00:00:00', 'Rennes', 15, '00:00:00', '', 8),
(2, '2020-12-24', '08:30:00', 'Paris', '00:00:00', 'Colombes', 2.9, '00:00:00', '', 5),
(3, '2020-12-16', '10:00:00', 'Colombes', '00:00:00', 'Paris', 2.9, '00:00:05', 'Signalisation', 5),
(4, '2020-11-20', '14:00:00', 'Bordeaux', '00:00:00', 'Paris', 25, '00:00:00', '', 9),
(5, '2020-11-22', '19:20:00', 'Lyon', '00:00:00', 'Paris', 30, '00:15:00', 'grève', 2),
(6, '2020-09-09', '12:00:00', 'Paris', '00:00:00', 'Lyon', 30, '00:00:05', 'Signalisation', 5),
(7, '2020-12-30', '15:30:00', 'Paris', '00:00:00', 'Bordeaux', 25, '00:00:05', 'Signalisation', 9),
(8, '2020-12-21', '10:00:00', 'Colombes', '00:00:00', 'Rennes', 12, '00:00:00', '', 4),
(9, '2020-12-24', '12:00:00', 'lyon', '14:00:00', 'marseille', 25, '00:00:00', '', 8),
(10, '2020-12-30', '10:00:00', 'montpellier', '14:00:00', 'Paris', 35, '00:00:00', '', 10);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `travel sales report`
--
CREATE TABLE `travel sales report` (
`ticket_departure_station` varchar(50)
,`ticket_destination` varchar(50)
,`SUM(payment.p_amount)` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Structure de la vue `annual sales report`
--
DROP TABLE IF EXISTS `annual sales report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `annual sales report`  AS  select year(`payment`.`p_date`) AS `YEAR(payment.p_date)`,sum(`payment`.`p_amount`) AS `SUM(payment.p_amount)`,round(avg(`payment`.`p_amount`),2) AS `ROUND(AVG(payment.p_amount),2)` from `payment` group by year(`payment`.`p_date`) ;

-- --------------------------------------------------------

--
-- Structure de la vue `monthly delay report`
--
DROP TABLE IF EXISTS `monthly delay report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monthly delay report`  AS  select year(`travel`.`tr_departure_date`) AS `YEAR(travel.tr_departure_date)`,monthname(`travel`.`tr_departure_date`) AS `MONTHNAME(travel.tr_departure_date)`,sec_to_time(sum(`travel`.`tr_delay`)) AS `SEC_TO_TIME(SUM(travel.tr_delay))`,sec_to_time(avg(`travel`.`tr_delay`)) AS `SEC_TO_TIME(AVG(travel.tr_delay))` from `travel` group by year(`travel`.`tr_departure_date`),month(`travel`.`tr_departure_date`) ;

-- --------------------------------------------------------

--
-- Structure de la vue `monthly sales report`
--
DROP TABLE IF EXISTS `monthly sales report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monthly sales report`  AS  select year(`payment`.`p_date`) AS `YEAR(payment.p_date)`,monthname(`payment`.`p_date`) AS `MONTHNAME(payment.p_date)`,sum(`payment`.`p_amount`) AS `SUM(payment.p_amount)`,round(avg(`payment`.`p_amount`),2) AS `ROUND(AVG(payment.p_amount),2)` from `payment` group by year(`payment`.`p_date`),month(`payment`.`p_date`) ;

-- --------------------------------------------------------

--
-- Structure de la vue `monthly satisfaction report`
--
DROP TABLE IF EXISTS `monthly satisfaction report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monthly satisfaction report`  AS  select year(`ticket`.`ticket_departure_date`) AS `YEAR(ticket.ticket_departure_date)`,monthname(`ticket`.`ticket_departure_date`) AS `MONTHNAME(ticket.ticket_departure_date)`,round(avg(`ticket`.`ticket_satisfaction`),2) AS `ROUND(AVG(ticket.ticket_satisfaction),2)` from `ticket` group by year(`ticket`.`ticket_departure_date`),month(`ticket`.`ticket_departure_date`) ;

-- --------------------------------------------------------

--
-- Structure de la vue `travel sales report`
--
DROP TABLE IF EXISTS `travel sales report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `travel sales report`  AS  select `ticket`.`ticket_departure_station` AS `ticket_departure_station`,`ticket`.`ticket_destination` AS `ticket_destination`,sum(`payment`.`p_amount`) AS `SUM(payment.p_amount)` from (`ticket` join `payment` on((`payment`.`payment_id` = `ticket`.`payment_id`))) group by `ticket`.`ticket_departure_station`,`ticket`.`ticket_destination` ;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `assign`
--
ALTER TABLE `assign`
  ADD KEY `travel_id` (`travel_id`),
  ADD KEY `trip_id` (`ticket_id`);

--
-- Index pour la table `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`city_name`);

--
-- Index pour la table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`),
  ADD KEY `c_name` (`city_name`) USING BTREE;

--
-- Index pour la table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`);

--
-- Index pour la table `ticket`
--
ALTER TABLE `ticket`
  ADD PRIMARY KEY (`ticket_id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `payment_id` (`payment_id`);

--
-- Index pour la table `train`
--
ALTER TABLE `train`
  ADD PRIMARY KEY (`train_id`);

--
-- Index pour la table `travel`
--
ALTER TABLE `travel`
  ADD PRIMARY KEY (`travel_id`),
  ADD KEY `train_id` (`train_id`) USING BTREE;

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT pour la table `payment`
--
ALTER TABLE `payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT pour la table `ticket`
--
ALTER TABLE `ticket`
  MODIFY `ticket_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `train`
--
ALTER TABLE `train`
  MODIFY `train_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT pour la table `travel`
--
ALTER TABLE `travel`
  MODIFY `travel_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `assign`
--
ALTER TABLE `assign`
  ADD CONSTRAINT `ticket_id` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`),
  ADD CONSTRAINT `travel_id` FOREIGN KEY (`travel_id`) REFERENCES `travel` (`travel_id`);

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `city_name` FOREIGN KEY (`city_name`) REFERENCES `city` (`city_name`);

--
-- Contraintes pour la table `ticket`
--
ALTER TABLE `ticket`
  ADD CONSTRAINT `client_trip_id` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  ADD CONSTRAINT `ticket_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`payment_id`);

--
-- Contraintes pour la table `travel`
--
ALTER TABLE `travel`
  ADD CONSTRAINT `train_id` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
