-- name: GetViewInboxMessageByID :one
SELECT * FROM view_inbox_messages
WHERE inbox_message_id = $1;

-- name: ListViewInboxMessagesByUser :many
SELECT * FROM view_inbox_messages
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, inbox_message_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
  AND user_id = $1
ORDER BY created_at DESC, inbox_message_id DESC
LIMIT sqlc.arg(page_size);
