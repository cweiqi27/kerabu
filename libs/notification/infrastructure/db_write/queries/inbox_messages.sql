-- name: CreateInboxMessage :one
INSERT INTO inbox_messages (id, user_id, name, status, title, content, link_url, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
RETURNING *;

-- name: GetInboxMessageById :one
SELECT * FROM inbox_messages
WHERE id = $1;

-- name: UpdateInboxMessage :one
UPDATE inbox_messages SET
  name = $2,
  status = $3,
  title = $4,
  content = $5,
  link_url = $6,
  updated_at = $7,
  updated_by = $8
WHERE id = $1
RETURNING *;

-- name: SoftDeleteInboxMessage :exec
UPDATE inbox_messages SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1
RETURNING *;
