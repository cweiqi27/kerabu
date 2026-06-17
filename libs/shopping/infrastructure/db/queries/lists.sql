-- name: CreateList :one
INSERT INTO shopping_write.lists (
  id, name, status, shopping_date, owner_party_id, shop_id, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
RETURNING *;

-- name: GetListByID :one
SELECT * FROM shopping_write.lists
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateList :one
UPDATE shopping_write.lists SET
  name = $2,
  status = $3,
  shopping_date = $4,
  owner_party_id = $5,
  shop_id = $6,
  updated_at = $7,
  updated_by = $8,
  deleted_at = $9,
  deleted_by = $10
WHERE id = $1
RETURNING *;

-- name: SoftDeleteList :exec
UPDATE shopping_write.lists SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;
