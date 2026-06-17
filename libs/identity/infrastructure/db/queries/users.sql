-- name: CreateUser :one
INSERT INTO identity_write.users (
  id, display_name, email, activated, avatar_url, idp_subject_id, idp_provider_name, status, created_at, updated_at, deleted_at
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
RETURNING *;

-- name: GetUserByID :one
SELECT * FROM identity_write.users
WHERE id = $1 AND deleted_at IS NULL;

-- name: GetUserByEmail :one
SELECT * FROM identity_write.users
WHERE email = $1 AND deleted_at IS NULL;

-- name: UpdateUser :one
UPDATE identity_write.users SET
  display_name = $2,
  email = $3,
  activated = $4,
  avatar_url = $5,
  idp_subject_id = $6,
  idp_provider_name = $7,
  status = $8,
  updated_at = $9,
  deleted_at = $10
WHERE id = $1
RETURNING *;

-- name: SoftDeleteUser :exec
UPDATE identity_write.users SET
  deleted_at = $2
WHERE id = $1;
