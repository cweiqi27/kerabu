-- name: CreateProcessedMessage :one
INSERT INTO cookbook_write.processed_messages (message_id, processed_at)
VALUES ($1, $2)
RETURNING *;

-- name: GetProcessedMessageByID :one
SELECT * FROM cookbook_write.processed_messages
WHERE message_id = $1;
