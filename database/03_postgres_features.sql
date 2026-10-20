-- PostgreSQL-specific examples for Module 6.

-- Case-insensitive search.
SELECT *
FROM assets
WHERE name ILIKE '%laptop%';

-- INSERT ... RETURNING.
INSERT INTO assets (name, type, status, purchase_price)
VALUES ('Demo-Asset', 'Demo', 'In Stock', 10.00)
ON CONFLICT (name) DO NOTHING
RETURNING *;

-- UPSERT.
INSERT INTO assets (name, type, status, purchase_price)
VALUES ('Demo-Asset', 'Demo', 'Active', 15.00)
ON CONFLICT (name)
DO UPDATE SET
    status = EXCLUDED.status,
    purchase_price = EXCLUDED.purchase_price,
    updated_at = CURRENT_TIMESTAMP
RETURNING *;

-- Transaction / rollback demonstration.
BEGIN;

UPDATE assets
SET status = 'Repair',
    updated_at = CURRENT_TIMESTAMP
WHERE name = 'Demo-Asset';

ROLLBACK;

-- Cleanup.
DELETE FROM assets
WHERE name = 'Demo-Asset';
