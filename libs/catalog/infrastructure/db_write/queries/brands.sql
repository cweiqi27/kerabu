-- name: CreateBrand :one
INSERT INTO catalog_write.brands (
  id, name, status, logo_url, owner_id, visibility, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
RETURNING *;

-- name: GetBrandByID :one
SELECT * FROM catalog_write.brands
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateBrand :one
UPDATE catalog_write.brands SET
  name = $2,
  status = $3,
  logo_url = $4,
  owner_id = $5,
  visibility = $6,
  updated_at = $7,
  updated_by = $8,
  deleted_at = $9,
  deleted_by = $10
WHERE id = $1
RETURNING *;

-- name: SoftDeleteBrand :exec
UPDATE catalog_write.brands SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;

-- name: ListBrands :many
SELECT * FROM catalog_write.brands
WHERE deleted_at IS NULL
  AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
