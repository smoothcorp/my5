-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 02, 2012 at 12:31 AM
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
-- Table structure for table `page_translations`
--
DROP TABLE IF EXISTS `page_translations`;
CREATE TABLE IF NOT EXISTS `page_translations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) DEFAULT NULL,
  `locale` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `custom_title` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_page_translations_on_page_id` (`page_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=37 ;

--
-- Dumping data for table `page_translations`
--

INSERT INTO `page_translations` (`id`, `page_id`, `locale`, `title`, `custom_title`, `created_at`, `updated_at`) VALUES
(1, 1, 'en', 'Home', '', '2011-08-12 03:43:02', '2011-08-15 05:03:38'),
(2, 2, 'en', 'Page not found', NULL, '2011-08-12 03:43:02', '2011-08-12 03:43:02'),
(3, 3, 'en', 'About Us', 'About Us', '2011-08-12 03:43:02', '2012-03-01 09:19:05'),
(4, 4, 'en', 'Contact Us', '', '2011-08-12 04:57:41', '2011-08-12 04:57:41'),
(5, 5, 'en', 'Pricing', '', '2011-08-12 04:57:55', '2011-08-12 04:57:55'),
(6, 6, 'en', 'Features', '', '2011-08-12 04:58:08', '2012-05-20 11:33:56'),
(7, 7, 'en', 'Customers', '', '2011-08-12 05:49:02', '2011-08-15 05:19:35'),
(8, 8, 'en', 'Corporations', NULL, '2011-08-13 00:45:50', '2011-08-13 00:45:50'),
(9, 9, 'en', 'Corporations', '', '2011-08-13 01:10:00', '2011-08-15 05:19:45'),
(10, 10, 'en', 'Videos', NULL, '2011-08-23 02:05:05', '2011-08-23 02:05:05'),
(11, 11, 'en', 'Symptomatics', NULL, '2011-08-23 02:23:31', '2011-08-23 02:23:31'),
(12, 12, 'en', 'Audios', NULL, '2011-09-06 01:54:41', '2011-09-06 01:54:41'),
(13, 13, 'en', 'My Eqs', NULL, '2011-09-06 02:32:41', '2011-09-06 02:32:41'),
(14, 14, 'en', 'Mini Modules', NULL, '2011-09-26 02:46:21', '2011-09-26 02:46:21'),
(15, 15, 'en', 'Audio Programs', NULL, '2011-09-26 05:23:10', '2011-09-26 05:23:10'),
(16, 16, 'en', 'Workplace', '', '2011-09-27 11:10:13', '2011-09-27 11:10:14'),
(18, 18, 'en', 'Individual membership', '', '2011-10-07 05:04:04', '2011-10-09 08:38:36'),
(19, 19, 'en', 'Corporate and enterprise membership', '', '2011-10-07 05:04:19', '2011-10-09 08:39:22'),
(21, 21, 'en', 'Values', '', '2011-10-07 05:04:50', '2011-10-07 05:04:50'),
(22, 22, 'en', 'People', '', '2011-10-07 05:05:09', '2011-10-07 05:05:09'),
(23, 23, 'en', 'Tim Norris', '', '2011-10-07 05:05:29', '2011-10-07 05:05:29'),
(24, 24, 'en', 'Testimonials', '', '2011-10-07 05:05:44', '2011-10-07 05:05:44'),
(25, 25, 'en', 'Careers', '', '2011-10-07 05:06:02', '2011-10-07 05:06:02'),
(26, 26, 'en', 'Vision', '', '2011-10-07 05:06:15', '2011-10-07 05:06:15'),
(27, 27, 'en', 'FAQ', '', '2011-10-07 05:06:35', '2011-10-07 05:06:35'),
(28, 28, 'en', 'Help', '', '2011-10-07 05:06:46', '2011-10-07 05:06:46'),
(29, 29, 'en', 'Support', '', '2011-10-07 05:07:00', '2011-10-07 05:07:00'),
(30, 30, 'en', 'Subscriptions', NULL, '2011-10-12 12:09:09', '2011-10-12 12:09:09'),
(31, 31, 'en', 'End User Licence Agreement - Terms and Conditions', '', '2011-10-26 11:23:53', '2012-05-21 05:04:25'),
(32, 32, 'en', 'Privacy policy', '', '2011-10-26 11:33:59', '2011-10-26 11:34:35'),
(33, 33, 'en', 'Terms and Conditions', '', '2011-10-26 11:54:54', '2011-10-26 11:54:54'),
(34, 34, 'en', 'Services', '', '2012-02-29 00:04:23', '2012-03-05 02:24:06'),
(35, 35, 'en', 'Workshops and Seminars', 'Workshops and Seminars', '2012-02-29 06:07:02', '2012-02-29 06:07:02'),
(36, 36, 'en', 'Corporates', '', '2012-03-01 03:29:29', '2012-03-01 03:30:43');
