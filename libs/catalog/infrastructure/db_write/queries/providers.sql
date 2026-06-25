-- name: CreateProvider :one
INSERT INTO providers (
  id, name, status, website_url, logo_url, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING *;

-- name: GetProviderByID :one
SELECT * FROM providers
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateProvider :one
UPDATE providers SET
  name = $2,
  status = $3,
  website_url = $4,
  logo_url = $5,
  updated_at = $6,
  updated_by = $7,
  deleted_at = $8,
  deleted_by = $9
WHERE id = $1
RETURNING *;

-- name: SoftDeleteProvider :exec
UPDATE providers SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;

-- name: ListProviders :many
SELECT * FROM providers
WHERE deleted_at IS NULL
  AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
