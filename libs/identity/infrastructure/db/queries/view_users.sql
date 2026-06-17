-- name: GetViewUserByID :one
SELECT * FROM identity_read.view_users
WHERE id = $1;

-- name: ListViewUsers :many
SELECT * FROM identity_read.view_users
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
