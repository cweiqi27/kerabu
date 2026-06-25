-- name: CreateProviderRawData :one
INSERT INTO provider_raw_data (
  id, barcode, status, provider_id, raw_data, fetched_at, processed_at
) VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING *;

-- name: GetProviderRawDataByID :one
SELECT * FROM provider_raw_data
WHERE id = $1;

-- name: UpdateProviderRawDataStatus :one
UPDATE provider_raw_data SET
  status = $2,
  processed_at = $3
WHERE id = $1
RETURNING *;
