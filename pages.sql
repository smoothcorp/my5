-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 01, 2012 at 11:59 PM
-- Server version: 5.1.33
-- PHP Version: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `my5`
--

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--
DROP TABLE IF EXISTS `pages`;

CREATE TABLE IF NOT EXISTS `pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `show_in_menu` tinyint(1) DEFAULT '1',
  `link_url` varchar(255) DEFAULT NULL,
  `menu_match` varchar(255) DEFAULT NULL,
  `deletable` tinyint(1) DEFAULT '1',
  `custom_title_type` varchar(255) DEFAULT 'none',
  `draft` tinyint(1) DEFAULT '0',
  `skip_to_first_child` tinyint(1) DEFAULT '0',
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `custom_position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pages_on_depth` (`depth`),
  KEY `index_pages_on_id` (`id`),
  KEY `index_pages_on_lft` (`lft`),
  KEY `index_pages_on_parent_id` (`parent_id`),
  KEY `index_pages_on_rgt` (`rgt`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`id`, `parent_id`, `position`, `path`, `created_at`, `updated_at`, `show_in_menu`, `link_url`, `menu_match`, `deletable`, `custom_title_type`, `draft`, `skip_to_first_child`, `lft`, `rgt`, `depth`, `custom_position`) VALUES
(1, NULL, 0, NULL, '2011-08-12 03:43:02', '2012-03-15 04:54:18', 1, '/', NULL, 0, 'text', 0, 0, 1, 48, NULL, NULL),
(2, 1, 0, NULL, '2011-08-12 03:43:02', '2011-08-12 03:43:02', 0, NULL, '^/404$', 0, 'none', 0, 0, 2, 3, NULL, NULL),
(3, 1, 1, NULL, '2011-08-12 03:43:02', '2012-03-05 02:10:58', 1, '', NULL, 1, 'text', 0, 0, 20, 39, NULL, 4),
(4, 1, 2, NULL, '2011-08-12 04:57:41', '2012-03-05 02:11:13', 1, '', NULL, 1, 'none', 0, 0, 40, 41, NULL, 5),
(5, 1, 3, NULL, '2011-08-12 04:57:55', '2012-03-05 02:10:48', 1, '', NULL, 1, 'none', 0, 0, 10, 15, NULL, 3),
(6, 1, 4, NULL, '2011-08-12 04:58:08', '2012-05-20 11:33:56', 1, '', NULL, 1, 'none', 0, 0, 4, 9, NULL, 1),
(7, NULL, 5, NULL, '2011-08-12 05:49:02', '2011-08-16 02:48:48', 0, '/customers', '^/customers(\\/|\\/.+?|)$', 0, 'none', 0, 0, 49, 50, NULL, NULL),
(9, NULL, 6, NULL, '2011-08-13 01:10:00', '2011-08-15 05:19:45', 0, '/corporations', '^/corporations(\\/|\\/.+?|)$', 0, 'none', 0, 0, 51, 52, NULL, NULL),
(10, NULL, 7, NULL, '2011-08-23 02:05:05', '2011-08-23 02:05:05', 0, '/videos', '^/videos(\\/|\\/.+?|)$', 0, 'none', 0, 0, 53, 54, NULL, NULL),
(11, NULL, 8, NULL, '2011-08-23 02:23:31', '2011-08-23 02:23:31', 0, '/symptomatics', '^/symptomatics(\\/|\\/.+?|)$', 0, 'none', 0, 0, 55, 56, NULL, NULL),
(12, NULL, 9, NULL, '2011-09-06 01:54:41', '2011-09-06 01:54:41', 0, '/audios', '^/audios(\\/|\\/.+?|)$', 0, 'none', 0, 0, 57, 58, NULL, NULL),
(13, NULL, 10, NULL, '2011-09-06 02:32:41', '2011-09-06 02:32:41', 0, '/my_eqs', '^/my_eqs(\\/|\\/.+?|)$', 0, 'none', 0, 0, 59, 60, NULL, NULL),
(14, NULL, 11, NULL, '2011-09-26 02:46:20', '2011-09-26 02:46:20', 0, '/mini_modules', '^/mini_modules(\\/|\\/.+?|)$', 0, 'none', 0, 0, 61, 62, NULL, NULL),
(15, NULL, 12, NULL, '2011-09-26 05:23:10', '2011-09-26 05:23:10', 0, '/audio_programs', '^/audio_programs(\\/|\\/.+?|)$', 0, 'none', 0, 0, 63, 64, NULL, NULL),
(16, 6, 13, NULL, '2011-09-27 11:10:13', '2012-03-04 10:04:04', 0, '', NULL, 1, 'none', 0, 0, 5, 6, NULL, NULL),
(18, 5, 15, NULL, '2011-10-07 05:04:04', '2012-03-05 05:33:08', 0, '', NULL, 1, 'none', 0, 0, 11, 12, NULL, NULL),
(19, 5, 16, NULL, '2011-10-07 05:04:19', '2011-12-02 01:46:53', 0, '', NULL, 1, 'none', 0, 0, 13, 14, NULL, NULL),
(21, 3, 18, NULL, '2011-10-07 05:04:50', '2012-03-01 09:18:20', 0, '', NULL, 1, 'none', 0, 0, 21, 22, NULL, NULL),
(22, 3, 19, NULL, '2011-10-07 05:05:08', '2011-10-24 23:11:53', 0, '', NULL, 1, 'none', 0, 0, 23, 24, NULL, NULL),
(23, 3, 20, NULL, '2011-10-07 05:05:29', '2011-12-02 01:50:12', 0, '', NULL, 1, 'none', 0, 0, 25, 26, NULL, NULL),
(24, 3, 21, NULL, '2011-10-07 05:05:44', '2012-05-06 23:57:08', 0, '', NULL, 1, 'none', 0, 0, 27, 28, NULL, NULL),
(25, 3, 22, NULL, '2011-10-07 05:06:02', '2011-10-11 21:19:51', 0, '', NULL, 1, 'none', 0, 0, 29, 30, NULL, NULL),
(26, 3, 23, NULL, '2011-10-07 05:06:15', '2011-10-24 23:11:07', 0, '', NULL, 1, 'none', 0, 0, 31, 32, NULL, NULL),
(27, 28, 24, NULL, '2011-10-07 05:06:35', '2011-10-07 05:07:20', 0, '', NULL, 1, 'none', 0, 0, 45, 46, NULL, NULL),
(28, 1, 25, NULL, '2011-10-07 05:06:46', '2012-03-01 04:21:12', 0, '', NULL, 1, 'none', 0, 1, 42, 47, NULL, NULL),
(29, 28, 26, NULL, '2011-10-07 05:07:00', '2011-10-07 05:07:00', 0, '', NULL, 1, 'none', 0, 0, 43, 44, NULL, NULL),
(30, NULL, 13, NULL, '2011-10-12 12:09:09', '2011-10-12 12:09:09', 0, '/subscriptions', '^/subscriptions(\\/|\\/.+?|)$', 0, 'none', 0, 0, 65, 66, NULL, NULL),
(31, 3, 27, NULL, '2011-10-26 11:23:53', '2012-05-21 05:04:25', 0, '', NULL, 1, 'none', 0, 0, 33, 34, NULL, NULL),
(32, 3, 28, NULL, '2011-10-26 11:33:59', '2011-12-02 02:03:21', 0, '', NULL, 1, 'none', 0, 0, 35, 36, NULL, NULL),
(33, 3, 29, NULL, '2011-10-26 11:54:54', '2011-10-27 21:49:51', 0, '', NULL, 1, 'none', 0, 0, 37, 38, NULL, NULL),
(34, 1, 30, NULL, '2012-02-29 00:04:23', '2012-03-12 05:14:12', 1, '', NULL, 1, 'none', 0, 0, 16, 19, NULL, 2),
(35, 6, 31, NULL, '2012-02-29 06:07:02', '2012-03-03 00:10:23', 0, '', NULL, 1, 'text', 0, 0, 7, 8, NULL, NULL),
(36, 34, 32, NULL, '2012-03-01 03:29:29', '2012-03-03 00:09:24', 0, '', NULL, 1, 'none', 0, 0, 17, 18, NULL, NULL);
