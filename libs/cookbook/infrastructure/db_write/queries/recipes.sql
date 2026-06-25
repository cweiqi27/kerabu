-- name: CreateRecipe :one
INSERT INTO recipes (
  id, name, status, visibility, instructions, owner_id, owner_party_id, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
RETURNING *;

-- name: GetRecipeByID :one
SELECT * FROM recipes
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateRecipe :one
UPDATE recipes SET
  name = $2,
  status = $3,
  visibility = $4,
  instructions = $5,
  owner_id = $6,
  owner_party_id = $7,
  updated_at = $8,
  updated_by = $9,
  deleted_at = $10,
  deleted_by = $11
WHERE id = $1
RETURNING *;

-- name: SoftDeleteRecipe :exec
UPDATE recipes SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;
