-- Module 6 PostgreSQL-specific examples.
-- These examples are documentation-oriented and can be run manually.

-- Case-insensitive search.
SELECT *
FROM assets
WHERE name ILIKE '%laptop%';

-- Insert and immediately return the generated row.
INSERT INTO assets (name, type, status, purchase_price)
VALUES ('Demo-Asset', 'Demo', 'In Stock', 10.00)
ON CONFLICT (name) DO NOTHING
RETURNING *;

-- Upsert example.
INSERT INTO assets (name, type, status, purchase_price)
VALUES ('Demo-Asset', 'Demo', 'Active', 15.00)
ON CONFLICT (name)
DO UPDATE SET
    status = EXCLUDED.status,
    purchase_price = EXCLUDED.purchase_price,
    updated_at = CURRENT_TIMESTAMP
RETURNING *;

-- Transaction example.
BEGIN;

UPDATE assets
SET status = 'Repair',
    updated_at = CURRENT_TIMESTAMP
WHERE name = 'Demo-Asset';

ROLLBACK;

-- Cleanup demo row.
DELETE FROM assets
WHERE name = 'Demo-Asset';
