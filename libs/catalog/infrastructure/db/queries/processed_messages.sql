-- name: CreateProcessedMessage :one
INSERT INTO catalog_write.processed_messages (message_id, processed_at)
VALUES ($1, $2)
RETURNING *;

-- name: GetProcessedMessageByID :one
SELECT * FROM catalog_write.processed_messages
WHERE message_id = $1;
