-- name: CreateArea :one
INSERT INTO inventory_write.areas (
  id, name, status, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
RETURNING *;

-- name: GetAreaByID :one
SELECT * FROM inventory_write.areas
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateArea :one
UPDATE inventory_write.areas SET
  name = $2,
  status = $3,
  updated_at = $4,
  updated_by = $5,
  deleted_at = $6,
  deleted_by = $7
WHERE id = $1
RETURNING *;

-- name: SoftDeleteArea :exec
UPDATE inventory_write.areas SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;
