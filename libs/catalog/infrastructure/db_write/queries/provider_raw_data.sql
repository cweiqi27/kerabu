-- name: CreateProviderRawData :one
INSERT INTO catalog_write.provider_raw_data (
  id, barcode, status, provider_id, raw_data, fetched_at, processed_at
) VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *;

-- name: GetProviderRawDataByID :one
SELECT * FROM catalog_write.provider_raw_data
WHERE id = $1;

-- name: UpdateProviderRawDataStatus :one
UPDATE catalog_write.provider_raw_data SET
  status = $2,
  processed_at = $3
WHERE id = $1
RETURNING *;
