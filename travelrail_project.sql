-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Jeu 19 Novembre 2020 à 19:22
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
CREATE DATABASE IF NOT EXISTS `travelrail_project` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `travelrail_project`;

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
  `travel_id` varchar(50) NOT NULL,
  `trip_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `assign`
--

INSERT INTO `assign` (`travel_id`, `trip_id`) VALUES
('2', '1'),
('1', '2'),
('4', '2');

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
('Bordeaux', '33000', 'France'),
('Bruxelles', '1000', 'Belgique'),
('Colombes', '92700', 'France'),
('Monaco', '98000', 'Monaco'),
('Paris', '75000', 'France'),
('Rennes', '35000', 'France'),
('Sceaux', '92330', 'France'),
('Vannes', '56000', 'France');

-- --------------------------------------------------------

--
-- Structure de la table `client`
--

CREATE TABLE `client` (
  `client_id` varchar(50) NOT NULL,
  `c_lastname` varchar(50) NOT NULL,
  `c_firstname` varchar(50) NOT NULL,
  `c_mail` varchar(50) NOT NULL,
  `c_birth_date` date NOT NULL,
  `c_street` varchar(50) NOT NULL,
  `c_house_nb` varchar(50) NOT NULL,
  `city_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `client`
--

INSERT INTO `client` (`client_id`, `c_lastname`, `c_firstname`, `c_mail`, `c_birth_date`, `c_street`, `c_house_nb`, `city_name`) VALUES
('1', 'SIMON', 'Charles', 'charles.simon@epfedu.fr', '1997-08-12', '', '', 'Vannes'),
('2', 'FABRE', 'Emma', 'emma.fabre@epfedu.fr', '1999-09-16', '', '', 'Rennes'),
('3', 'MASSY', 'Enguerran', 'enguerran.massy@epfedu.fr', '1997-11-05', 'av François Bernier ', '23', 'Colombes');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `monthly delay report`
--
CREATE TABLE `monthly delay report` (
`YEAR(travel.tr_departure_date)` int(4)
,`MONTH(travel.tr_departure_date)` int(2)
,`SEC_TO_TIME(SUM(travel.tr_delay))` time
,`SEC_TO_TIME(AVG(travel.tr_delay))` time(4)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `monthly satisfaction report`
--
CREATE TABLE `monthly satisfaction report` (
`YEAR(trip.trip_departure_date)` int(4)
,`MONTH(trip.trip_departure_date)` int(2)
,`ROUND(AVG(trip.trip_satisfaction),2)` decimal(13,2)
);

-- --------------------------------------------------------

--
-- Structure de la table `payment`
--

CREATE TABLE `payment` (
  `payment_id` varchar(50) NOT NULL,
  `p_amount` decimal(10,2) NOT NULL,
  `p_type` tinyint(1) NOT NULL,
  `p_date` date NOT NULL,
  `client_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table with the data of a payment';

--
-- Contenu de la table `payment`
--

INSERT INTO `payment` (`payment_id`, `p_amount`, `p_type`, `p_date`, `client_id`) VALUES
('1', '136.25', 0, '2020-11-10', '1'),
('10', '2.40', 1, '2020-11-19', '3'),
('2', '24.55', 0, '2020-05-20', '1'),
('3', '40.35', 1, '2019-08-06', '1'),
('4', '78.80', 0, '2019-08-13', '1'),
('5', '80.50', 1, '2020-07-15', '2'),
('6', '113.25', 1, '2020-04-21', '2'),
('7', '29.60', 0, '2019-06-11', '2'),
('8', '36.85', 0, '2020-03-16', '2'),
('9', '16.80', 0, '2019-12-26', '3');

-- --------------------------------------------------------

--
-- Structure de la table `train`
--

CREATE TABLE `train` (
  `train_id` varchar(50) NOT NULL,
  `t_type` varchar(50) NOT NULL,
  `t_capacity` int(11) NOT NULL,
  `t_maintenance_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `train`
--

INSERT INTO `train` (`train_id`, `t_type`, `t_capacity`, `t_maintenance_date`) VALUES
('1', 'TER', 100, '2020-06-16'),
('10', 'TGV', 400, '2019-08-06'),
('2', 'TER', 150, '2020-07-15'),
('3', 'TER', 200, '2019-11-13'),
('4', 'Intercités', 100, '2020-03-03'),
('5', 'Intercités', 150, '2020-07-01'),
('6', 'Intercités', 200, '2020-02-04'),
('7', 'TGV', 200, '2020-01-14'),
('8', 'TGV', 250, '2020-10-07'),
('9', 'TGV', 300, '2020-07-23');

-- --------------------------------------------------------

--
-- Structure de la table `travel`
--

CREATE TABLE `travel` (
  `travel_id` varchar(50) NOT NULL,
  `tr_departure_date` date NOT NULL,
  `tr_departure_hour` time NOT NULL,
  `tr_departure_station` varchar(50) NOT NULL,
  `tr_destination` varchar(50) NOT NULL,
  `tr_delay` time NOT NULL,
  `tr_delay_cause` varchar(50) NOT NULL,
  `train_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `travel`
--

INSERT INTO `travel` (`travel_id`, `tr_departure_date`, `tr_departure_hour`, `tr_departure_station`, `tr_destination`, `tr_delay`, `tr_delay_cause`, `train_id`) VALUES
('1', '2020-11-25', '12:00:00', 'Paris', 'Rennes', '00:00:00', '', '8'),
('2', '2020-11-20', '08:30:00', 'Paris', 'Colombes', '00:00:00', '', '5'),
('3', '2020-12-02', '10:00:00', 'Colombes', 'Paris', '00:00:05', 'Signalisation', '5'),
('4', '2020-11-20', '14:00:00', 'Bordeaux', 'Paris', '00:00:00', '', '9'),
('5', '2020-11-22', '19:20:00', 'Lyon', 'Paris', '00:15:00', 'grève', '2');

-- --------------------------------------------------------

--
-- Structure de la table `trip`
--

CREATE TABLE `trip` (
  `trip_id` varchar(50) NOT NULL,
  `trip_price` float NOT NULL,
  `trip_exchangeable` tinyint(1) NOT NULL,
  `trip_refundable` tinyint(1) NOT NULL,
  `trip_class` tinyint(1) NOT NULL,
  `trip_satisfaction` int(11) NOT NULL,
  `trip_departure_date` date NOT NULL,
  `trip_departure_station` varchar(50) NOT NULL,
  `trip_destination` varchar(50) NOT NULL,
  `trip_direct` tinyint(1) NOT NULL,
  `book_reduction_card` varchar(50) NOT NULL,
  `client_id` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `trip`
--

INSERT INTO `trip` (`trip_id`, `trip_price`, `trip_exchangeable`, `trip_refundable`, `trip_class`, `trip_satisfaction`, `trip_departure_date`, `trip_departure_station`, `trip_destination`, `trip_direct`, `book_reduction_card`, `client_id`) VALUES
('1', 0, 0, 0, 0, 5, '2020-11-11', 'Paris', 'Colombes', 0, '', '3'),
('2', 0, 1, 1, 1, 3, '2020-11-24', 'Bordeaux', 'Rennes', 1, 'Young_card', '2');

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

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monthly delay report`  AS  select year(`travel`.`tr_departure_date`) AS `YEAR(travel.tr_departure_date)`,month(`travel`.`tr_departure_date`) AS `MONTH(travel.tr_departure_date)`,sec_to_time(sum(`travel`.`tr_delay`)) AS `SEC_TO_TIME(SUM(travel.tr_delay))`,sec_to_time(avg(`travel`.`tr_delay`)) AS `SEC_TO_TIME(AVG(travel.tr_delay))` from `travel` group by year(`travel`.`tr_departure_date`),month(`travel`.`tr_departure_date`) ;

-- --------------------------------------------------------

--
-- Structure de la vue `monthly satisfaction report`
--
DROP TABLE IF EXISTS `monthly satisfaction report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monthly satisfaction report`  AS  select year(`trip`.`trip_departure_date`) AS `YEAR(trip.trip_departure_date)`,month(`trip`.`trip_departure_date`) AS `MONTH(trip.trip_departure_date)`,round(avg(`trip`.`trip_satisfaction`),2) AS `ROUND(AVG(trip.trip_satisfaction),2)` from `trip` group by year(`trip`.`trip_departure_date`),month(`trip`.`trip_departure_date`) ;

--
-- Index pour les tables exportées
--

--
-- Index pour la table `assign`
--
ALTER TABLE `assign`
  ADD KEY `travel_id` (`travel_id`),
  ADD KEY `trip_id` (`trip_id`);

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
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `client_id` (`client_id`);

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
-- Index pour la table `trip`
--
ALTER TABLE `trip`
  ADD PRIMARY KEY (`trip_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `assign`
--
ALTER TABLE `assign`
  ADD CONSTRAINT `travel_id` FOREIGN KEY (`travel_id`) REFERENCES `travel` (`travel_id`),
  ADD CONSTRAINT `trip_id` FOREIGN KEY (`trip_id`) REFERENCES `trip` (`trip_id`);

--
-- Contraintes pour la table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `city_name` FOREIGN KEY (`city_name`) REFERENCES `city` (`city_name`);

--
-- Contraintes pour la table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `client_payement_id` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`);

--
-- Contraintes pour la table `travel`
--
ALTER TABLE `travel`
  ADD CONSTRAINT `train_id` FOREIGN KEY (`train_id`) REFERENCES `train` (`train_id`);

--
-- Contraintes pour la table `trip`
--
ALTER TABLE `trip`
  ADD CONSTRAINT `client_trip_id` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
