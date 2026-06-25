-- name: CreateOutboxArchive :one
INSERT INTO outbox_archive (id, outbox_event_id, trace_id, event, payload, status, retry_count, event_created_at, archived_at)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
RETURNING *;

