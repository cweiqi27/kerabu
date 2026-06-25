-- name: CreateTag :one
INSERT INTO catalog_write.tags (
  id, name, provider_id, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
RETURNING *;

-- name: GetTagByID :one
SELECT * FROM catalog_write.tags
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetTagByName :one
SELECT * FROM catalog_write.tags
WHERE name = $1 AND deleted_at IS NULL;

-- name: UpdateTag :one
UPDATE catalog_write.tags SET
  name = $2,
  provider_id = $3,
  updated_at = $4,
  updated_by = $5,
  deleted_at = $6,
  deleted_by = $7
WHERE id = $1
RETURNING *;

-- name: SoftDeleteTag :exec
UPDATE catalog_write.tags SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;

-- name: ListTags :many
SELECT * FROM catalog_write.tags
WHERE deleted_at IS NULL
  AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
