-- name: CreateCategory :one
INSERT INTO catalog_write.categories (
  id, status, name, parent_id, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
RETURNING *;

-- name: GetCategoryByID :one
SELECT * FROM catalog_write.categories
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateCategory :one
UPDATE catalog_write.categories SET
  status = $2,
  name = $3,
  parent_id = $4,
  updated_at = $5,
  updated_by = $6,
  deleted_at = $7,
  deleted_by = $8
WHERE id = $1
RETURNING *;

-- name: SoftDeleteCategory :exec
UPDATE catalog_write.categories SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;

-- name: ListCategories :many
SELECT * FROM catalog_write.categories
WHERE deleted_at IS NULL
  AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
