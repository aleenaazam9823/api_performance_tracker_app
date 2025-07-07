-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 07, 2025 at 01:23 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `performance`
--

-- --------------------------------------------------------

--
-- Table structure for table `activities`
--

CREATE TABLE `activities` (
  `id` int(11) NOT NULL,
  `conference_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `status` enum('Not Started','In Progress','Completed') DEFAULT 'Not Started',
  `percent_complete` int(11) DEFAULT 0,
  `is_deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activities`
--

INSERT INTO `activities` (`id`, `conference_id`, `title`, `status`, `percent_complete`, `is_deleted`) VALUES
(1, 1, 'Registration Setup', 'In Progress', 75, 0),
(2, 1, 'Welcome Desk', 'Not Started', 0, 0),
(3, 1, 'Marketing Launch Plan', '', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `activity_parts`
--

CREATE TABLE `activity_parts` (
  `id` int(11) NOT NULL,
  `activity_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `status` enum('Pending','Completed') NOT NULL DEFAULT 'Pending',
  `is_deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_parts`
--

INSERT INTO `activity_parts` (`id`, `activity_id`, `title`, `status`, `is_deleted`) VALUES
(1, 1, 'Kiosk Setup', 'Completed', 0),
(2, 1, 'Printer Setup', 'Completed', 0),
(3, 3, 'Create Campaign', 'Pending', 0),
(4, 3, 'Distribute Ads', 'Pending', 0);

-- --------------------------------------------------------

--
-- Table structure for table `activity_part_responsibles`
--

CREATE TABLE `activity_part_responsibles` (
  `id` int(11) NOT NULL,
  `activity_part_id` int(11) NOT NULL,
  `responsible_id` int(11) NOT NULL,
  `assigned_at` datetime DEFAULT current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_part_responsibles`
--

INSERT INTO `activity_part_responsibles` (`id`, `activity_part_id`, `responsible_id`, `assigned_at`, `is_deleted`) VALUES
(1, 1, 24, '2025-06-21 14:09:40', 1),
(2, 1, 29, '2025-06-21 14:09:40', 1),
(3, 2, 30, '2025-06-21 14:09:40', 1),
(4, 1, 5, '2025-06-22 19:48:50', 1),
(5, 1, 4, '2025-06-22 19:52:52', 1),
(6, 3, 8, '2025-06-24 11:59:26', 1),
(7, 2, 9, '2025-06-24 12:01:29', 1),
(8, 2, 23, '2025-06-24 13:36:55', 0),
(9, 1, 19, '2025-06-24 13:42:05', 0);

-- --------------------------------------------------------

--
-- Table structure for table `conferences`
--

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `banner_image` text DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `modified_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conferences`
--

INSERT INTO `conferences` (`id`, `name`, `start_date`, `end_date`, `banner_image`, `is_deleted`, `created_at`, `modified_at`) VALUES
(1, 'CAD Intervention', '2025-07-07', '2025-07-11', 'assets/images/CAD Intervenation.png', 0, '2025-06-13 12:38:04', '2025-06-13 12:38:04'),
(2, 'SHS 2025', '2025-04-25', '2025-04-27', 'assets/images/SHS 2025.png', 0, '2025-06-13 12:38:04', '2025-06-13 12:38:04'),
(3, 'CARDICON', '2025-02-08', '2025-02-09', 'assets/images/CARDICON 2025.png', 0, '2025-06-13 12:38:04', '2025-06-13 12:38:04'),
(4, 'CSI', '2025-02-28', '2025-03-02', 'assets/images/CSI Chh. Sambhaji Nagari - 2025.png', 0, '2025-06-13 12:38:04', '2025-06-13 12:38:04'),
(5, 'IJCTO', '2025-06-18', '2025-06-19', 'assets/images/IJCTO 2025 .png', 0, '2025-06-13 12:38:04', '2025-06-13 12:38:04'),
(6, 'Sentient Summit', '2025-01-16', '2025-01-18', 'assets/images/Sentient Summit 2025.png', 0, '2025-06-13 12:38:04', '2025-06-13 12:38:04');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `role` varchar(255) DEFAULT NULL,
  `is_active` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `modified_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role`, `is_active`, `created_at`, `modified_at`) VALUES
(1, 'Master Admin', 0, '2025-06-19 17:08:49', '2025-06-19 17:08:49'),
(2, 'Supervisor', 0, '2025-06-19 17:08:49', '2025-06-19 17:08:49'),
(3, 'Process Owner', 0, '2025-06-19 17:08:49', '2025-06-19 17:08:49'),
(4, 'Executors', 0, '2025-06-19 17:08:49', '2025-06-19 17:08:49'),
(5, 'User', 0, '2025-06-19 17:08:49', '2025-06-19 17:08:49');

-- --------------------------------------------------------

--
-- Table structure for table `sub_activities`
--

CREATE TABLE `sub_activities` (
  `id` int(11) NOT NULL,
  `activity_parts_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `status` enum('Pending','Completed') DEFAULT 'Pending',
  `is_deleted` tinyint(1) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `modified_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_activities`
--

INSERT INTO `sub_activities` (`id`, `activity_parts_id`, `title`, `status`, `is_deleted`, `created_at`, `modified_at`) VALUES
(1, 1, 'Material unloading from truck to registration area', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 12:42:38'),
(2, 1, 'Kiosk assembly and readiness', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 12:43:07'),
(3, 1, 'Flex pasting', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:02:16'),
(4, 1, 'TV installation', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:56:02'),
(5, 1, 'Printer Placement', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:56:12'),
(6, 1, 'Power Supply', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:56:22'),
(7, 3, 'Cable Masking', 'Pending', 0, '2025-06-20 11:26:21', '2025-07-07 12:01:12'),
(8, 1, 'Help desk setup - Table', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:56:32'),
(9, 1, 'Help desk setup - Chairs', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:56:41'),
(10, 1, 'Help desk setup - Table Masking', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 14:56:49'),
(11, 2, 'Printer installation', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 15:55:42'),
(12, 2, 'Software configuration and setup & Testing', 'Completed', 0, '2025-06-20 11:26:21', '2025-07-07 16:50:06');

-- --------------------------------------------------------

--
-- Table structure for table `sub_activity_media`
--

CREATE TABLE `sub_activity_media` (
  `id` int(11) NOT NULL,
  `sub_activity_id` int(11) NOT NULL,
  `media_upload` varchar(255) NOT NULL,
  `media_type` varchar(50) NOT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp(),
  `remark` text DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT 0,
  `completed_by` int(25) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_activity_media`
--

INSERT INTO `sub_activity_media` (`id`, `sub_activity_id`, `media_upload`, `media_type`, `uploaded_at`, `remark`, `is_deleted`, `completed_by`) VALUES
(29, 1, 'http://192.168.16.47/Tracker/uploads/686b736663673_469bf8a5-70bd-453a-ba0c-91b09982fa364922147548312947530.jpg', 'image', '2025-07-07 09:12:38', '', 0, 49),
(30, 2, 'http://192.168.16.47/Tracker/uploads/686b73833ad55_c8f67cc3-e1b8-4ddf-9d69-71c426ac858c6553430329382286144.mp4', 'video', '2025-07-07 09:13:07', '', 0, 49),
(31, 3, 'http://192.168.16.47/Tracker/uploads/686b86107a23c_2b3a3523-383e-47f1-b888-088a5f6f9f0f1715852666002347074.mp4', 'video', '2025-07-07 10:32:16', '', 0, 49),
(32, 11, 'http://192.168.16.47/Tracker/uploads/686b8885308c6_882face6-8f23-4c37-b180-41420a6782951910764298707066913.jpg', 'image', '2025-07-07 10:42:45', '', 0, 49),
(33, 12, 'http://192.168.16.47/Tracker/uploads/686b888c1d074_88ebcc45-ebf5-479f-86cb-4e611994d09a4234790771743443770.jpg', 'image', '2025-07-07 10:42:52', '', 0, 49),
(34, 11, 'http://192.168.16.47/Tracker/uploads/686b8a8c3fed4_1a239be6-4205-415a-8397-d4b5d4f655d78395290571406422291.jpg', 'image', '2025-07-07 10:51:24', '', 0, 49),
(35, 12, 'http://192.168.16.47/Tracker/uploads/686b8a9301919_82a76235-806d-42d8-abc2-1e50403b9bf45130658471290908038.jpg', 'image', '2025-07-07 10:51:31', '', 0, 49),
(36, 11, 'http://192.168.16.47/Tracker/uploads/686b916b0f877_de5823e4-c43a-453c-8164-15de21b8e6ac7525604314057552147.jpg', 'image', '2025-07-07 11:20:43', '', 0, 49),
(37, 11, 'http://192.168.16.47/Tracker/uploads/686b916f288ed_de5823e4-c43a-453c-8164-15de21b8e6ac7525604314057552147.jpg', 'image', '2025-07-07 11:20:47', '', 0, 49),
(38, 12, 'http://192.168.16.47/Tracker/uploads/686b91756858d_7f82777c-a2d9-4a17-b0a9-f2030595a40d2580702261424165496.jpg', 'image', '2025-07-07 11:20:53', '', 0, 49),
(39, 4, 'http://192.168.16.47/Tracker/uploads/686b92aa9ffac_11d04ee0-f2c3-4dde-bc26-2fb97ff84f497721184517568573770.jpg', 'image', '2025-07-07 11:26:02', '', 0, 49),
(40, 5, 'http://192.168.16.47/Tracker/uploads/686b92b4c7789_0c12793e-f1fa-44bb-9315-d5605ac5e9267996043457781884179.jpg', 'image', '2025-07-07 11:26:12', '', 0, 49),
(41, 6, 'http://192.168.16.47/Tracker/uploads/686b92be50def_6a4dd3e5-402c-42e9-ac32-8196b5bd2b6d5078469164519475686.jpg', 'image', '2025-07-07 11:26:22', '', 0, 49),
(42, 8, 'http://192.168.16.47/Tracker/uploads/686b92c8ed60d_827e9b38-ef31-4d25-bfe4-9cd26606d2fc3526380223686785675.jpg', 'image', '2025-07-07 11:26:32', '', 0, 49),
(43, 9, 'http://192.168.16.47/Tracker/uploads/686b92d182297_94c20acc-7b34-4392-8928-08b8ff7aca8c6732890855855701002.jpg', 'image', '2025-07-07 11:26:41', '', 0, 49),
(44, 10, 'http://192.168.16.47/Tracker/uploads/686b92d97d32d_eebc1121-3886-4d3d-98c8-a2101219639b5536748031024835945.jpg', 'image', '2025-07-07 11:26:49', '', 0, 49),
(45, 11, 'http://192.168.16.47/Tracker/uploads/686b9419ccfcb_33fe2be2-f923-4a80-80bd-669c558878d51213785842358319026.jpg', 'image', '2025-07-07 11:32:09', '', 0, 49),
(46, 11, 'http://192.168.16.47/Tracker/uploads/686b941a63ca5_33fe2be2-f923-4a80-80bd-669c558878d51213785842358319026.jpg', 'image', '2025-07-07 11:32:10', '', 0, 49),
(47, 12, 'http://192.168.16.47/Tracker/uploads/686b94219eec3_50ecf014-6b22-4c4b-82b0-c91bc068622b7179615821951882988.jpg', 'image', '2025-07-07 11:32:17', '', 0, 49),
(48, 11, 'http://192.168.16.47/Tracker/uploads/686b952fb3a88_89cbbafc-9066-4bf0-9cd5-ef8104d4abfa9199915245877129090.jpg', 'image', '2025-07-07 11:36:47', '', 0, 49),
(49, 11, 'http://192.168.16.47/Tracker/uploads/686b95308326a_89cbbafc-9066-4bf0-9cd5-ef8104d4abfa9199915245877129090.jpg', 'image', '2025-07-07 11:36:48', '', 0, 49),
(50, 11, 'http://192.168.16.47/Tracker/uploads/686b95326ef32_89cbbafc-9066-4bf0-9cd5-ef8104d4abfa9199915245877129090.jpg', 'image', '2025-07-07 11:36:50', '', 0, 49),
(51, 12, 'http://192.168.16.47/Tracker/uploads/686b95390e363_ee15b123-f5a5-48da-b0dc-7fd7ac8e3e4d2110455632506701132.jpg', 'image', '2025-07-07 11:36:57', '', 0, 49),
(52, 11, 'http://192.168.16.47/Tracker/uploads/686b9614d0e14_93875500-0294-468f-9e36-a85b7ece6fca7498639403164584553.jpg', 'image', '2025-07-07 11:40:36', '', 0, 49),
(53, 11, 'http://192.168.16.47/Tracker/uploads/686b9a2024ef9_37181144-1468-4859-b4fa-e4049024bed16623770448945234585.jpg', 'image', '2025-07-07 11:57:52', '', 0, 49),
(54, 11, 'http://192.168.16.47/Tracker/uploads/686b9bb7eef6d_eb741ebd-f916-422d-af3c-c4ddd1a83d7f5246012162186665290.jpg', 'image', '2025-07-07 12:04:39', '', 0, 49),
(55, 12, 'http://192.168.16.47/Tracker/uploads/686b9d9463db8_879e1941-5274-4ade-8ca5-c2e902996a7d5978229253574196513.jpg', 'image', '2025-07-07 12:12:36', '', 0, 49),
(56, 11, 'http://192.168.16.47/Tracker/uploads/686b9f1171f29_dd02115f-3e1b-4364-81d4-72680b2fae47396935146142055643.jpg', 'image', '2025-07-07 12:18:57', '', 0, 49),
(57, 11, 'http://192.168.16.47/Tracker/uploads/686b9fee8380c_f0179c4c-56cb-4e2b-907b-b965ed3dc6b82036384758082601635.jpg', 'image', '2025-07-07 12:22:38', '', 0, 49),
(58, 12, 'http://192.168.16.47/Tracker/uploads/686ba037a1441_f31edcc9-61ea-4899-a089-e6a31cf13ed2520904576562656708.jpg', 'image', '2025-07-07 12:23:51', '', 0, 49),
(59, 11, 'http://192.168.16.47/Tracker/uploads/686ba0a6ac062_51433cc2-7cf4-45ad-84fe-c7d742dce1291015895730421962298.jpg', 'image', '2025-07-07 12:25:42', '', 0, 49),
(60, 12, 'http://192.168.16.47/Tracker/uploads/686ba12f72a0f_d947b320-aadf-415f-801d-ef29588284cf5710584985450357008.jpg', 'image', '2025-07-07 12:27:59', '', 0, 49),
(61, 12, 'http://192.168.16.47/Tracker/uploads/686ba1a028736_ca7a9fc6-add3-4f33-98fa-db09e065f9582478956771763485345.jpg', 'image', '2025-07-07 12:29:52', '', 0, 49),
(62, 12, 'http://192.168.16.47/Tracker/uploads/686ba2fd7ffe7_27b90bf2-0095-4dfa-9c42-1bdff6b1c27f5469544376820711233.jpg', 'image', '2025-07-07 12:35:41', '', 0, 49),
(63, 12, 'http://192.168.16.47/Tracker/uploads/686ba36aea966_4056268f-9ec4-415f-8157-c1c37b1f2e057729537458936441954.jpg', 'image', '2025-07-07 12:37:30', '', 0, 49),
(64, 12, 'http://192.168.16.47/Tracker/uploads/686ba461691f7_4fe32dd8-84fd-408b-832f-024ca08783618654615671107209151.jpg', 'image', '2025-07-07 12:41:37', '', 0, 49),
(65, 12, 'http://192.168.16.47/Tracker/uploads/686ba5ef94bf6_e6119dc5-bd05-4af3-a9be-c25d6a586d3d293619614032556431.jpg', 'image', '2025-07-07 12:48:15', '', 0, 49),
(66, 12, 'http://192.168.16.47/Tracker/uploads/686ba5f0c40ba_e6119dc5-bd05-4af3-a9be-c25d6a586d3d293619614032556431.jpg', 'image', '2025-07-07 12:48:16', '', 0, 49),
(67, 12, 'http://192.168.16.47/Tracker/uploads/686bad667bb97_4158c8c6-22f7-484b-bb0a-bae9ee301dcb3154229408732479550.jpg', 'image', '2025-07-07 13:20:06', '', 0, 49);

-- --------------------------------------------------------

--
-- Table structure for table `sub_activity_responsibles`
--

CREATE TABLE `sub_activity_responsibles` (
  `id` int(11) NOT NULL,
  `sub_activity_id` int(11) NOT NULL,
  `responsible_id` int(11) NOT NULL,
  `assigned_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_deleted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_activity_responsibles`
--

INSERT INTO `sub_activity_responsibles` (`id`, `sub_activity_id`, `responsible_id`, `assigned_at`, `is_deleted`) VALUES
(1, 1, 25, '2025-06-24 13:44:40', 1),
(2, 2, 26, '2025-06-21 15:58:18', 0),
(3, 3, 27, '2025-06-21 15:58:18', 0),
(4, 4, 24, '2025-06-21 15:58:18', 0),
(5, 5, 25, '2025-06-21 15:58:18', 0),
(6, 6, 26, '2025-06-21 15:58:18', 0),
(7, 7, 27, '2025-06-21 15:58:18', 0),
(8, 9, 25, '2025-06-21 15:58:18', 0),
(9, 10, 25, '2025-06-21 15:58:18', 0),
(10, 1, 24, '2025-06-21 15:58:18', 1),
(11, 2, 14, '2025-06-21 15:58:18', 0),
(12, 1, 24, '2025-06-24 13:35:31', 1),
(13, 1, 6, '2025-06-24 13:45:03', 0),
(14, 1, 5, '2025-06-24 13:54:07', 1),
(15, 1, 8, '2025-06-24 13:56:58', 0),
(16, 1, 7, '2025-06-24 13:59:16', 1),
(17, 1, 2, '2025-06-24 14:18:15', 0),
(18, 1, 10, '2025-06-24 14:20:17', 0),
(19, 1, 3, '2025-06-24 14:27:25', 0),
(20, 2, 4, '2025-06-24 14:27:39', 0),
(21, 2, 5, '2025-06-24 14:27:39', 0),
(22, 2, 3, '2025-06-24 14:27:39', 0),
(23, 2, 8, '2025-06-24 14:27:39', 0),
(24, 2, 7, '2025-06-24 14:27:39', 0),
(25, 2, 6, '2025-06-24 14:27:39', 0),
(26, 2, 10, '2025-06-24 14:27:39', 0),
(27, 3, 5, '2025-06-24 14:34:33', 0),
(28, 3, 2, '2025-06-24 14:34:40', 0),
(29, 3, 1, '2025-06-24 14:34:40', 0),
(30, 3, 3, '2025-06-24 14:34:40', 0),
(31, 3, 4, '2025-06-24 14:34:40', 0),
(32, 3, 6, '2025-06-24 14:34:40', 0),
(33, 3, 7, '2025-06-24 14:34:56', 0),
(34, 12, 6, '2025-07-02 15:42:47', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `role_id` int(11) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `has_password` tinyint(4) DEFAULT 0,
  `is_active` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `modified_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role_id`, `first_name`, `last_name`, `email`, `password`, `has_password`, `is_active`, `created_at`, `modified_at`) VALUES
(1, 1, 'Sameer', 'Mardikar', 'sam@promaxevents.in', '$2y$10$8Shv1zidJfxnQcIK43NYQu5/TwZGX2lyf/vSSBthSX.BNuFlDv33G', 1, 0, '2025-06-19 17:22:24', '2025-06-20 16:20:21'),
(2, 3, 'Harshawardhan', 'Badkas', 'badkas@promaxevents.in', '$2y$10$HrKT8y.Zxg77Smc9MBs2feC2fGMG.ARaC8NKftLwcWqMbPoRXM2Pu', 1, 0, '2025-06-19 17:22:24', '2025-06-22 17:35:50'),
(3, 3, 'Rahul', 'Chawda', 'rahul@promaxevents.in', '$2y$10$IDwKFbI.M5xf8QydyQdN6eJUoJEGKEpsj9TP9CN.zr3uFKRs7vXBq', 1, 0, '2025-06-19 17:22:24', '2025-06-22 17:36:57'),
(4, 3, 'Krunal', 'Jaware', 'j.kunalavpromax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(5, 3, 'Ashish', 'Kanekar', 'kanekarashish@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(6, 2, 'Shruti', 'Deshpande', 'Deshpande', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(7, 3, 'Rasika', 'Dhakras', 'rasika@promaxevents.in', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(8, 4, 'Akshay', 'Mane', 'akshaymane@promaxevents.in', '$2y$10$SaoQYP40SgWqzvfU6db3DOxOPEg6Mve45oAqJNwFPMNQRAI79U6Yy', 1, 0, '2025-06-19 17:22:24', '2025-07-02 21:25:46'),
(9, 5, 'Nikita', 'Lakhani', 'nikitalakhani.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(10, 5, 'Chanchal', 'Jethani', 'chanchal.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(11, 5, 'Anuja', 'Kulkarni', 'anuja.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(12, 5, 'Pooja', 'Chandok', 'pooja.promax9@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(13, 3, 'Shilpa', 'Gadkari', 'shilpa@promaxevents.in', '$2y$10$MoY666oKNhu6yfBah4vb/OXlpNlrg5daN6koG11cZF1amKZNXxobK', 1, 0, '2025-06-19 17:22:24', '2025-06-20 16:57:30'),
(14, 2, 'Prasad', 'Mahure', 'prasadmahure72@gmail.com', '$2y$10$to1n15Czx0mWRPEVu4kkfuPpVkxbYdvuQAo.dAEE1Km4QBIQ53P3e', 1, 0, '2025-06-19 17:22:24', '2025-06-20 16:30:09'),
(15, 3, 'Diksha', 'Gajbhiye', 'dikshagajbhiyeee@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(16, 3, 'Akshay', 'Kothekar', 'akshaykothekar3726@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(17, 3, 'Manjiri', 'Ahirrao', 'ahirraom49@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(18, 2, 'Anu', 'Sabharwal', 'anu@promaxevents.in', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(19, 3, 'Devyani', 'Dhoble', 'devyani.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(20, 5, 'Prakash', 'Wadodkar', 'promaxbooks@gmail.com', '$2y$10$ao2UN4T5eUG/H0IZcv.JPesI7Y3mbJCVlZK9exMZCwGnQj4oQde1q', 1, 0, '2025-06-19 17:22:24', '2025-06-20 16:37:48'),
(21, 5, 'Dnyanesh', 'Khorgade', 'dnkhorgade@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(22, 3, 'Vedangi', 'Dubbulwar', 'vedangi.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(23, 3, 'Mukund', 'Deshpande', 'mukunddeshpande2016@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(24, 4, 'Tanmay', 'Dahake', 'tanmay.promax@gmail.com', '$2y$10$tOmQfmd3kqNLnsFkjs3M4udI6TTVnpjItJDn8zJc10vjapM8pFocu', 1, 0, '2025-06-19 17:22:24', '2025-07-02 21:23:58'),
(25, 4, 'Rajesh', 'Uikey', 'rajeshsuikey@gmail.com', '$2y$10$fY3ceVHcmACOniyAFjEuS.pkW.U8Km4t.O.dI0PeMRzx92qcgvCqS', 1, 0, '2025-06-19 17:22:24', '2025-07-07 11:08:05'),
(26, 4, 'Nikhil', 'Urkande', 'urkandenikhil@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(27, 4, 'Gulshan', 'Uikey', 'gulshanuikey75@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(28, 3, 'Sonal', 'Kamble', 'sonalpromax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(29, 3, 'Sagar', 'Kadam', 'sagar.promax.in@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(30, 4, 'Prathit', 'Thapar', 'prathit.promaxevents@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(31, 4, 'Devansh', 'Tripathi', 'devanshtripathi494@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(32, 5, 'Amit', 'Badkas', 'amit@promaxevents.in', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(33, 3, 'Dhara', 'Mehta', 'dharamehta0496@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(34, 5, 'Aboli', 'Kulkarni', 'abolipskulkarni@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(35, 3, 'Pramesh', 'Saroj', 'prameshyadav24@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(36, 3, 'Prathamesh', 'Naidu', 'prathameshnaidu2002@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(37, 5, 'Samiksha', 'KADU', 'samikshapromax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(38, 4, 'Arvind', 'Padole', 'padolearvind12@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(39, 4, 'Manthan', 'Bhure', 'manthanbhure549@gmail.com ', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(40, 4, 'Kedar', 'Borkar', 'kedarborkar25@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(41, 5, 'Pankaj', 'Deshmukh', 'pankaj@promaxevents.in', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(42, 3, 'Sayyed', 'Ali Raza', 'sayyed.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(43, 3, 'Soumyadip', 'Ghosh', 'soumyadipsontughosh@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(44, 3, 'Narayan', 'Shishupal', 'narayanshishupal9@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(45, 3, 'Shefali', 'Mishra', 'shefalim.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(46, 4, 'Devanand', 'Uike', 'uikedevanand998@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(47, 3, 'Jayanto', 'Sarkar', 'joyantosarkar2670@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(48, 2, 'Harshal', 'Nehare', 'harshalnehare7@gmail.com', '$2y$10$FyvLkh0tZ9qek0uFKYSDSuhfiqSLGIywzDeAOnlPW/Mrxc1yv1ryG', 1, 0, '2025-06-19 17:22:24', '2025-06-20 16:16:48'),
(49, 2, 'Aleena ', 'Azam Ansari', 'azamaleena9823@gmail.com', '$2y$10$IegU1RjlVacUbqRaIJKb7uZG.m4QdCsPdc.cd7Hdm9KlV8Ql18slq', 1, 0, '2025-06-19 17:22:24', '2025-07-02 21:40:03'),
(50, 5, 'Mansi', 'Kothari', 'mansikothari.promax@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(51, 4, 'Shreyash', 'Bandhe', 'shreyashbandhe@outlook.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24'),
(52, 5, 'Ar. lavina', 'Bhutada', 'lavinabhutada2000@gmail.com', NULL, 0, 0, '2025-06-19 17:22:24', '2025-06-19 17:22:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activities`
--
ALTER TABLE `activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `confernece` (`conference_id`);

--
-- Indexes for table `activity_parts`
--
ALTER TABLE `activity_parts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity` (`activity_id`);

--
-- Indexes for table `activity_part_responsibles`
--
ALTER TABLE `activity_part_responsibles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activityid` (`activity_part_id`),
  ADD KEY `responsible_id` (`responsible_id`);

--
-- Indexes for table `conferences`
--
ALTER TABLE `conferences`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sub_activities`
--
ALTER TABLE `sub_activities`
  ADD PRIMARY KEY (`id`),
  ADD KEY `activity part` (`activity_parts_id`);

--
-- Indexes for table `sub_activity_media`
--
ALTER TABLE `sub_activity_media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_activity_id` (`sub_activity_id`),
  ADD KEY `completed` (`completed_by`);

--
-- Indexes for table `sub_activity_responsibles`
--
ALTER TABLE `sub_activity_responsibles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activities`
--
ALTER TABLE `activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `activity_parts`
--
ALTER TABLE `activity_parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `activity_part_responsibles`
--
ALTER TABLE `activity_part_responsibles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `conferences`
--
ALTER TABLE `conferences`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sub_activities`
--
ALTER TABLE `sub_activities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `sub_activity_media`
--
ALTER TABLE `sub_activity_media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `sub_activity_responsibles`
--
ALTER TABLE `sub_activity_responsibles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `activities`
--
ALTER TABLE `activities`
  ADD CONSTRAINT `confernece` FOREIGN KEY (`conference_id`) REFERENCES `conferences` (`id`);

--
-- Constraints for table `activity_parts`
--
ALTER TABLE `activity_parts`
  ADD CONSTRAINT `activity` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`);

--
-- Constraints for table `activity_part_responsibles`
--
ALTER TABLE `activity_part_responsibles`
  ADD CONSTRAINT `activityid` FOREIGN KEY (`activity_part_id`) REFERENCES `activity_parts` (`id`),
  ADD CONSTRAINT `responsible_id` FOREIGN KEY (`responsible_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `sub_activities`
--
ALTER TABLE `sub_activities`
  ADD CONSTRAINT `activity part` FOREIGN KEY (`activity_parts_id`) REFERENCES `activity_parts` (`id`);

--
-- Constraints for table `sub_activity_media`
--
ALTER TABLE `sub_activity_media`
  ADD CONSTRAINT `completed` FOREIGN KEY (`completed_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `sub_activity_id` FOREIGN KEY (`sub_activity_id`) REFERENCES `sub_activities` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
