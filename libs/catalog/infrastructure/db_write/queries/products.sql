-- name: CreateProduct :one
INSERT INTO catalog_write.products (
  id, status, name, barcode, net_value, net_unit, image_url, nutriscore, nova_group, owner_id, visibility, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
RETURNING *;

-- name: GetProductByID :one
SELECT * FROM catalog_write.products
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetProductByBarcode :one
SELECT * FROM catalog_write.products
WHERE barcode = $1 AND deleted_at IS NULL;

-- name: UpdateProduct :one
UPDATE catalog_write.products SET
  status = $2,
  name = $3,
  barcode = $4,
  net_value = $5,
  net_unit = $6,
  image_url = $7,
  nutriscore = $8,
  nova_group = $9,
  owner_id = $10,
  visibility = $11,
  updated_at = $12,
  updated_by = $13,
  deleted_at = $14,
  deleted_by = $15
WHERE id = $1
RETURNING *;

-- name: SoftDeleteProduct :exec
UPDATE catalog_write.products SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;

-- name: ListProducts :many
SELECT * FROM catalog_write.products
WHERE deleted_at IS NULL
  AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
