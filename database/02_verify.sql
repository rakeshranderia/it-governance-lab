\set ON_ERROR_STOP on

\echo '=== PostgreSQL verification ==='

SELECT version() AS postgres_version;

SELECT
    current_database() AS database_name,
    current_user AS connected_as;

\dt

SELECT
    id,
    name,
    type,
    status,
    purchase_price,
    created_at
FROM assets
ORDER BY id;

SELECT
    status,
    COUNT(*) AS asset_count
FROM assets
GROUP BY status
ORDER BY status;

\echo '=== Verification complete ==='
