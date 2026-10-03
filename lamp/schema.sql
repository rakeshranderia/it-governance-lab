CREATE DATABASE IF NOT EXISTS assetlab;

USE assetlab;

CREATE TABLE IF NOT EXISTS assets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asset_name VARCHAR(100) NOT NULL,
    asset_type VARCHAR(50),
    status VARCHAR(30)
);

-- Seed rows are added only if an asset with the same name does not already exist.
INSERT INTO assets (asset_name, asset_type, status)
SELECT 'Laptop-001', 'Laptop', 'Active'
WHERE NOT EXISTS (
    SELECT 1 FROM assets WHERE asset_name = 'Laptop-001'
);

INSERT INTO assets (asset_name, asset_type, status)
SELECT 'Monitor-001', 'Monitor', 'Active'
WHERE NOT EXISTS (
    SELECT 1 FROM assets WHERE asset_name = 'Monitor-001'
);

INSERT INTO assets (asset_name, asset_type, status)
SELECT 'Phone-001', 'Mobile', 'In Stock'
WHERE NOT EXISTS (
    SELECT 1 FROM assets WHERE asset_name = 'Phone-001'
);
