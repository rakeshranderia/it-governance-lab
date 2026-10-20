\set ON_ERROR_STOP on

\echo '=== Module 6 PostgreSQL bootstrap ==='

SELECT
    'CREATE ROLE assetapp LOGIN PASSWORD ' || quote_literal(:'app_password')
WHERE NOT EXISTS (
    SELECT 1
    FROM pg_roles
    WHERE rolname = 'assetapp'
)
\gexec

SELECT
    'CREATE DATABASE assetlab OWNER assetapp'
WHERE NOT EXISTS (
    SELECT 1
    FROM pg_database
    WHERE datname = 'assetlab'
)
\gexec

\connect assetlab

SET ROLE assetapp;

CREATE TABLE IF NOT EXISTS assets (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,
    purchase_price NUMERIC(10, 2) NOT NULL CHECK (purchase_price >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_assets_status ON assets (status);
CREATE INDEX IF NOT EXISTS idx_assets_type ON assets (type);

INSERT INTO assets (name, type, status, purchase_price)
VALUES
    ('Laptop-001', 'Laptop', 'Active', 1850.50),
    ('Monitor-001', 'Monitor', 'Repair', 650.00),
    ('Phone-001', 'Mobile', 'In Stock', 1200.00)
ON CONFLICT (name) DO NOTHING;

RESET ROLE;

\echo '=== Bootstrap complete ==='
