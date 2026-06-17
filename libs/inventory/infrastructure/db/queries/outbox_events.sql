-- name: CreateOutboxEvent :one
INSERT INTO inventory_write.outbox_events (id, trace_id, event, payload, status, retry_count, created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetPendingOutboxEvents :many
SELECT * FROM inventory_write.outbox_events
WHERE status = 'pending'
  AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at ASC, id ASC
LIMIT sqlc.arg(page_size);

-- name: UpdateOutboxEventStatus :one
UPDATE inventory_write.outbox_events SET
  status = $2,
  retry_count = $3,
  updated_at = $4
WHERE id = $1
RETURNING *;
