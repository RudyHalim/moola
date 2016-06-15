-- phpMyAdmin SQL Dump
-- version 4.6.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 15, 2016 at 02:01 PM
-- Server version: 5.7.12
-- PHP Version: 5.5.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `db_moola`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `exchange_value` decimal(9,2) NOT NULL COMMENT 'rate conversion value',
  `markup_value` decimal(9,2) NOT NULL COMMENT 'markup to be added to exchange_value'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `configs`
--

CREATE TABLE `configs` (
  `config_id` int(1) UNSIGNED NOT NULL,
  `servicecharge_currency` varchar(3) NOT NULL COMMENT '3 digits following ISO 4217 Currency Codes',
  `servicecharge_value` decimal(9,2) NOT NULL COMMENT 'to be displayed at the confirmation page adding to total amount charged'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `configs`
--

INSERT INTO `configs` (`config_id`, `servicecharge_currency`, `servicecharge_value`) VALUES
(1, 'SGD', '1.25');

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `country_id` int(3) UNSIGNED NOT NULL,
  `country_name` varchar(30) NOT NULL,
  `country_currency` varchar(3) NOT NULL COMMENT '3 digits following ISO 4217 Currency Codes',
  `country_trade` enum('Y','N') DEFAULT 'Y' COMMENT 'open for trade currency or not',
  `markup_value` decimal(9,2) NOT NULL COMMENT 'markup for each currency code following the country code'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='This data table also used for user''s country registration';

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`country_id`, `country_name`, `country_currency`, `country_trade`, `markup_value`) VALUES
(1, 'Singapore', 'SGD', 'Y', '0.11'),
(2, 'Malaysia', 'MYR', 'Y', '0.12'),
(3, 'Thailand', 'THB', 'Y', '0.13'),
(4, 'Vietnam', 'VND', 'Y', '0.14'),
(5, 'Indonesia', 'IDR', 'N', '0.15'),
(6, 'China', 'RMB', 'N', '0.16'),
(7, 'India', 'INR', 'N', '0.17'),
(8, 'Myanmar', 'MMK', 'N', '0.18');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) UNSIGNED NOT NULL,
  `invoice_no` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `orderstatus_id` int(11) NOT NULL,
  `created_dt` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `orderitem_id` int(11) UNSIGNED NOT NULL,
  `invoice_no` varchar(50) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `seller_currency` varchar(3) NOT NULL COMMENT '3 digits following ISO 4217 Currency Codes',
  `seller_value` decimal(9,2) NOT NULL,
  `exchange_currency` varchar(3) NOT NULL COMMENT '3 digits following ISO 4217 Currency Codes',
  `exchange_value` decimal(9,2) NOT NULL COMMENT 'rate conversion value',
  `markup_value` decimal(9,2) NOT NULL COMMENT 'markup to be added to exchange_value'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `order_status`
--

CREATE TABLE `order_status` (
  `orderstatus_id` int(2) UNSIGNED NOT NULL,
  `orderstatus_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `order_status`
--

INSERT INTO `order_status` (`orderstatus_id`, `orderstatus_name`) VALUES
(1, 'pending'),
(2, 'processing'),
(3, 'completed');

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `page_id` int(5) UNSIGNED NOT NULL,
  `url_addr` varchar(225) NOT NULL,
  `page_title` varchar(225) NOT NULL,
  `page_content` text NOT NULL,
  `is_active` enum('Y','N') DEFAULT 'Y',
  `created_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int(11) NOT NULL,
  `updated_dt` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) UNSIGNED NOT NULL,
  `seller_id` int(11) NOT NULL COMMENT 'seller''s user id',
  `seller_currency` varchar(3) NOT NULL COMMENT '3 digits following ISO 4217 Currency Codes',
  `seller_value` decimal(9,2) NOT NULL,
  `exchange_currency` varchar(3) NOT NULL COMMENT '3 digits following ISO 4217 Currency Codes',
  `product_status` enum('Y','N') DEFAULT 'Y' COMMENT 'whether a product is allowed to display and can be purchased',
  `buyer_id` int(11) NOT NULL COMMENT 'to flag the order has been taken'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(3) UNSIGNED NOT NULL,
  `role_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(1, 'Super Admin'),
(2, 'Regular Customer'),
(3, 'Special Customer');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) UNSIGNED NOT NULL,
  `email_addr` varchar(100) NOT NULL,
  `passwd` varchar(225) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `gender` enum('male','female') DEFAULT 'male',
  `phone_no` varchar(20) NOT NULL,
  `display_image` varchar(200) DEFAULT NULL,
  `country_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email_addr`, `passwd`, `first_name`, `last_name`, `gender`, `phone_no`, `display_image`, `country_id`, `role_id`) VALUES
(1, 'rudyhalim.microsoft@gmail.com', '81dc9bdb52d04dc20036dbd8313ed055', 'Rudy', 'Halim', 'male', '085780886425', NULL, 5, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `configs`
--
ALTER TABLE `configs`
  ADD PRIMARY KEY (`config_id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`country_id`),
  ADD UNIQUE KEY `country_name` (`country_name`,`country_currency`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`orderitem_id`);

--
-- Indexes for table `order_status`
--
ALTER TABLE `order_status`
  ADD PRIMARY KEY (`orderstatus_id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`page_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `cart_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `configs`
--
ALTER TABLE `configs`
  MODIFY `config_id` int(1) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `country_id` int(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `orderitem_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `order_status`
--
ALTER TABLE `order_status`
  MODIFY `orderstatus_id` int(2) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `page_id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;