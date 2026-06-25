-- name: CreateIdempotencyKey :one
INSERT INTO catalog_write.idempotency_keys (key_id, request_hash, response, status_code, created_at)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetIdempotencyKeyByID :one
SELECT * FROM catalog_write.idempotency_keys
WHERE key_id = $1;
