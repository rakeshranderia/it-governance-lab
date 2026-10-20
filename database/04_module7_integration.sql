CREATE TABLE IF NOT EXISTS external_assets (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_system VARCHAR(50) NOT NULL,
    source_record_id VARCHAR(100) NOT NULL,
    name VARCHAR(150) NOT NULL,
    type VARCHAR(50) NOT NULL,
    status VARCHAR(30) NOT NULL,
    purchase_price NUMERIC(10, 2) NOT NULL CHECK (purchase_price >= 0),
    source_payload JSONB NOT NULL,
    imported_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_external_assets_source UNIQUE (source_system, source_record_id)
);

CREATE INDEX IF NOT EXISTS idx_external_assets_source ON external_assets (source_system);
CREATE INDEX IF NOT EXISTS idx_external_assets_status ON external_assets (status);

SELECT id, source_system, source_record_id, name, type, status, purchase_price, imported_at
FROM external_assets
ORDER BY id;
