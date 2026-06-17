-- name: CreateItem :one
INSERT INTO shopping_write.items (
  id, name, list_id, product_ids, is_ticked, quantity, reason, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
RETURNING *;

-- name: GetItemByID :one
SELECT * FROM shopping_write.items
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateItem :one
UPDATE shopping_write.items SET
  name = $2,
  list_id = $3,
  product_ids = $4,
  is_ticked = $5,
  quantity = $6,
  reason = $7,
  updated_at = $8,
  updated_by = $9,
  deleted_at = $10,
  deleted_by = $11
WHERE id = $1
RETURNING *;

-- name: SoftDeleteItem :exec
UPDATE shopping_write.items SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;
