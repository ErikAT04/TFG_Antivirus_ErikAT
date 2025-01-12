DROP DATABASE IF EXISTS m_antivirus_db;
CREATE DATABASE m_antivirus_db;
USE m_antivirus_db;

CREATE TABLE `user` (
  `email` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `device` (
  `id` varchar(255) NOT NULL,
  `dev_name` varchar(255) DEFAULT NULL,
  `dev_type` varchar(255) DEFAULT NULL,
  `last_scan` datetime DEFAULT NULL,
  `join_in` datetime DEFAULT NULL,
  `user` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  CONSTRAINT `device_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

