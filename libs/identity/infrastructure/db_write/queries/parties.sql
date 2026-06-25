-- name: CreateParty :one
INSERT INTO parties (
  id, name, status, created_at, updated_at
) VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetPartyByID :one
SELECT * FROM parties
WHERE id = $1;

-- name: UpdateParty :one
UPDATE parties SET
  name = $2,
  status = $3,
  updated_at = $4
WHERE id = $1
RETURNING *;
