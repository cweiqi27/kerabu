-- name: CreateShop :one
INSERT INTO shops (
  id, name, status, provider, place_id, place_url, latitude, longitude, formatted_address, address_components, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
RETURNING *;

-- name: GetShopByID :one
SELECT * FROM shops
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateShop :one
UPDATE shops SET
  name = $2,
  status = $3,
  provider = $4,
  place_id = $5,
  place_url = $6,
  latitude = $7,
  longitude = $8,
  formatted_address = $9,
  address_components = $10,
  updated_at = $11,
  updated_by = $12,
  deleted_at = $13,
  deleted_by = $14
WHERE id = $1
RETURNING *;

-- name: SoftDeleteShop :exec
UPDATE shops SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;
