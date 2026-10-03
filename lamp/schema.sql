CREATE DATABASE IF NOT EXISTS assetlab;

USE assetlab;

CREATE TABLE IF NOT EXISTS assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_name VARCHAR(100) NOT NULL,
    asset_type VARCHAR(50),
    status VARCHAR(30)
);

INSERT INTO assets (asset_name, asset_type, status)
VALUES
('Laptop-001','Laptop','Active'),
('Monitor-001','Monitor','Active'),
('Phone-001','Mobile','In Stock');
