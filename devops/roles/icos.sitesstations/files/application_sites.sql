-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 30, 2017 at 12:13 PM
-- Server version: 5.7.20-0ubuntu0.16.04.1
-- PHP Version: 7.0.22-0ubuntu0.16.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `application_sites`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `uid` varchar(50) NOT NULL,
  `application_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `visitor` int(11) NOT NULL,
  `plan` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `startYear` int(11) NOT NULL,
  `fundingBy` varchar(255) NOT NULL,
  `visitStart` date NOT NULL,
  `visitEnd` date NOT NULL,
  `samplingLocationOther` varchar(255) NOT NULL,
  `experimentalDesign` text NOT NULL,
  `samplingSubjectAndRate` text NOT NULL,
  `supportingDrawingFile` varchar(255) NOT NULL,
  `stayOverNight` tinyint(1) NOT NULL,
  `participantsFemale` int(11) NOT NULL,
  `participantsMale` int(11) NOT NULL,
  `participantsOther` int(11) NOT NULL,
  `deskAccess` tinyint(1) NOT NULL,
  `workshopAccess` tinyint(1) NOT NULL,
  `workShopAccessSpecification` text NOT NULL,
  `staffSupportOther` text NOT NULL,
  `powerConsuption` tinyint(1) NOT NULL,
  `internetAccess` tinyint(1) NOT NULL,
  `safteyIssuesText` text NOT NULL,
  `otherExplainingInformationFile` varchar(255) NOT NULL,
  `othersSpecification` text NOT NULL,
  `projectComments` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `application_conference_rooms`
--

CREATE TABLE `application_conference_rooms` (
  `application_id` varchar(255) NOT NULL,
  `room_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `application_course_levels`
--

CREATE TABLE `application_course_levels` (
  `application_id` varchar(255) NOT NULL,
  `course_level_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `application_includes`
--

CREATE TABLE `application_includes` (
  `application_id` varchar(255) NOT NULL,
  `includes_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `application_review_comments`
--

CREATE TABLE `application_review_comments` (
  `application_id` varchar(255) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `comment_date` date NOT NULL,
  `comment` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `application_review_status`
--

CREATE TABLE `application_review_status` (
  `application_id` varchar(50) NOT NULL,
  `contact_id` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `station_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `application_sampling_locations`
--

CREATE TABLE `application_sampling_locations` (
  `application_id` varchar(255) NOT NULL,
  `samplingLocation_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `application_staff_supports`
--

CREATE TABLE `application_staff_supports` (
  `application_id` varchar(255) NOT NULL,
  `support_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `application_stations`
--

CREATE TABLE `application_stations` (
  `application_id` varchar(50) NOT NULL,
  `station_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `application_stations`
--

INSERT INTO `application_stations` (`application_id`, `station_id`) VALUES
('59afc032eb042', 9),
('59c21c5208412', 5),
('59d38cce1c83f', 7),
('59d60ad034b12', 9),
('59d60ad034b12', 5),
('59d60ad034b12', 6);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Table structure for table `stations`
--

CREATE TABLE `stations` (
  `ID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stations`
--

INSERT INTO `stations` (`ID`, `Name`) VALUES
(1, 'Lönnstorp'),
(2, 'Asa'),
(3, 'Skogaryd'),
(4, 'Grimsö'),
(5, 'Erken'),
(6, 'Röbäcksdalen'),
(7, 'Svartberget'),
(8, 'Tarfala'),
(9, 'Abisko');

-- --------------------------------------------------------

--
-- Table structure for table `station_contacts`
--

CREATE TABLE `station_contacts` (
  `id` int(11) NOT NULL,
  `station_id` int(11) NOT NULL,
  `role` int(11) NOT NULL DEFAULT '0',
  `contact_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_contacts_with_stations`
--
CREATE TABLE `view_contacts_with_stations` (
`id` int(11)
,`first_name` varchar(255)
,`last_name` varchar(255)
,`email` varchar(255)
,`station_id` int(11)
,`role` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `visitors`
--

CREATE TABLE `visitors` (
  `id` int(11) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phoneNo` varchar(50) NOT NULL,
  `title` int(11) NOT NULL,
  `gender` int(11) NOT NULL,
  `institute` varchar(255) NOT NULL,
  `department` varchar(255) NOT NULL,
  `postalCode` varchar(50) NOT NULL,
  `postalAddress` varchar(255) NOT NULL,
  `country` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- --------------------------------------------------------

--
-- Structure for view `view_contacts_with_stations`
--
DROP TABLE IF EXISTS `view_contacts_with_stations`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_contacts_with_stations`  AS  select `contacts`.`id` AS `id`,`contacts`.`first_name` AS `first_name`,`contacts`.`last_name` AS `last_name`,`contacts`.`email` AS `email`,`station_contacts`.`station_id` AS `station_id`,`station_contacts`.`role` AS `role` from (`contacts` join `station_contacts` on((`station_contacts`.`contact_id` = `contacts`.`id`))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`uid`),
  ADD UNIQUE KEY `uid` (`uid`);

--
-- Indexes for table `application_status_NOTUSED`
--
-- ALTER TABLE `application_status_NOTUSED`
--   ADD PRIMARY KEY (`status`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `stations`
--
ALTER TABLE `stations`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `ID` (`ID`);

--
-- Indexes for table `station_contacts`
--
ALTER TABLE `station_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `visitors`
--
ALTER TABLE `visitors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uid` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `station_contacts`
--
ALTER TABLE `station_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `visitors`
--
ALTER TABLE `visitors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
