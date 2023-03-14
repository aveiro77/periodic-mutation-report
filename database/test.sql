-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 14 Mar 2023 pada 14.57
-- Versi server: 10.4.11-MariaDB
-- Versi PHP: 7.4.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_mutation` (`p_start` DATE, `p_end` DATE)  BEGIN
  DECLARE vyear YEAR(4) DEFAULT YEAR(p_start);
  DECLARE vstart_year YEAR(4) DEFAULT YEAR(p_start);
  DECLARE vdate_start DATE DEFAULT p_start;
  DECLARE vdate_end DATE DEFAULT p_end;
  DELETE FROM `test`.`tb_temp_mutation`;
  COMMIT;
  INSERT INTO `test`.`tb_temp_mutation` (`item_id`, `item_name`, `item_unit`, `qty_initial`, `qty_begining`, `qty_in`, `qty_out`)
  (
    SELECT a.`id`, a.`name`, a.`unit`, NVL(b.`qty`, 0), NVL(c.`qty_start`, 0), NVL(d.`qty_in`, 0), NVL(e.`qty_out`, 0) FROM `test`.`tb_items` a
    LEFT OUTER JOIN `test`.`tb_opening_balance` b ON (a.`id`=b.`item_id` AND b.`year` = vyear)
    LEFT OUTER JOIN (SELECT `item_id`, SUM(`qty_in`)-SUM(`qty_out`) AS `qty_start` FROM `test`.`tb_trans` WHERE `date` >= vstart_year AND `date` < vdate_start
                     GROUP BY `item_id`
					) c ON a.`id`=c.`item_id`
	LEFT OUTER JOIN (SELECT `item_id`, SUM(`qty_in`) AS `qty_in` FROM `test`.`tb_trans` WHERE `date` BETWEEN vdate_start AND vdate_end
                     GROUP BY `item_id`	
					) d ON a.`id`= d.`item_id`
	LEFT OUTER JOIN (SELECT `item_id`, SUM(`qty_out`) AS `qty_out` FROM `test`.`tb_trans` WHERE `date` BETWEEN vdate_start AND vdate_end
                     GROUP BY `item_id`	
					) e ON a.`id`= e.`item_id`
  );
  COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_items`
--

CREATE TABLE `tb_items` (
  `id` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `unit` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `tb_items`
--

INSERT INTO `tb_items` (`id`, `name`, `unit`) VALUES
(1, 'tablet', 'pcs'),
(2, 'computer', 'pcs'),
(3, 'laptop', 'pcs'),
(4, 'fan', 'pcs'),
(5, 'hair dryer', 'pcs'),
(6, 'printer', 'pcs');

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_opening_balance`
--

CREATE TABLE `tb_opening_balance` (
  `id` int(11) NOT NULL,
  `item_id` int(11) DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `qty` double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `tb_opening_balance`
--

INSERT INTO `tb_opening_balance` (`id`, `item_id`, `year`, `qty`) VALUES
(1, 1, 2023, 0),
(3, 2, 2023, 0),
(4, 3, 2023, 100),
(5, 4, 2023, 50),
(6, 5, 2023, 20),
(7, 6, 2023, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_temp_mutation`
--

CREATE TABLE `tb_temp_mutation` (
  `register` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(45) DEFAULT NULL,
  `item_unit` varchar(45) DEFAULT NULL,
  `qty_initial` double DEFAULT NULL,
  `qty_begining` double DEFAULT NULL,
  `qty_in` double DEFAULT NULL,
  `qty_out` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `tb_temp_mutation`
--

INSERT INTO `tb_temp_mutation` (`register`, `item_id`, `item_name`, `item_unit`, `qty_initial`, `qty_begining`, `qty_in`, `qty_out`) VALUES
(1077, 1, 'tablet', 'pcs', 0, 100, 0, 0),
(1078, 2, 'computer', 'pcs', 0, 260, 0, 0),
(1079, 3, 'laptop', 'pcs', 100, 150, 0, 0),
(1080, 4, 'fan', 'pcs', 50, 0, 0, 0),
(1081, 5, 'hair dryer', 'pcs', 20, 0, 0, 0),
(1082, 6, 'printer', 'pcs', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tb_trans`
--

CREATE TABLE `tb_trans` (
  `register` int(11) NOT NULL,
  `type` smallint(1) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `qty_in` double DEFAULT NULL,
  `qty_out` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `tb_trans`
--

INSERT INTO `tb_trans` (`register`, `type`, `date`, `item_id`, `qty_in`, `qty_out`) VALUES
(1, 1, '2023-01-12', 1, 120, 0),
(2, 1, '2023-01-12', 2, 300, 0),
(3, 1, '2023-01-12', 3, 150, 0),
(4, 1, '2023-01-15', 1, 30, 0),
(5, 1, '2023-01-15', 2, 10, 0),
(6, 1, '2023-01-15', 3, 50, 0),
(7, 0, '2023-01-18', 1, 0, 50),
(8, 0, '2023-01-18', 2, 0, 50),
(9, 0, '2023-01-18', 3, 0, 50);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `vmutation`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `vmutation` (
`item_id` int(11)
,`item_name` varchar(45)
,`item_unit` varchar(45)
,`opening_balance` double
,`qty_in` double
,`qty_out` double
,`qty_ending` double
);

-- --------------------------------------------------------

--
-- Struktur untuk view `vmutation`
--
DROP TABLE IF EXISTS `vmutation`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vmutation`  AS  select `a`.`item_id` AS `item_id`,`a`.`item_name` AS `item_name`,`a`.`item_unit` AS `item_unit`,sum(`a`.`qty_initial`) + sum(`a`.`qty_begining`) AS `opening_balance`,sum(`a`.`qty_in`) AS `qty_in`,sum(`a`.`qty_out`) AS `qty_out`,sum(`a`.`qty_initial`) + sum(`a`.`qty_begining`) + sum(`a`.`qty_in`) - sum(`a`.`qty_out`) AS `qty_ending` from `tb_temp_mutation` `a` group by `a`.`item_id`,`a`.`item_name`,`a`.`item_unit` ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `tb_items`
--
ALTER TABLE `tb_items`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tb_opening_balance`
--
ALTER TABLE `tb_opening_balance`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `tb_temp_mutation`
--
ALTER TABLE `tb_temp_mutation`
  ADD PRIMARY KEY (`register`);

--
-- Indeks untuk tabel `tb_trans`
--
ALTER TABLE `tb_trans`
  ADD PRIMARY KEY (`register`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `tb_items`
--
ALTER TABLE `tb_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `tb_opening_balance`
--
ALTER TABLE `tb_opening_balance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `tb_temp_mutation`
--
ALTER TABLE `tb_temp_mutation`
  MODIFY `register` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1084;

--
-- AUTO_INCREMENT untuk tabel `tb_trans`
--
ALTER TABLE `tb_trans`
  MODIFY `register` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
