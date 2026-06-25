-- name: CreateIngredient :one
INSERT INTO ingredients (
  id, name, recipe_id, product_ids, created_at, created_by, updated_at, updated_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetIngredientByID :one
SELECT * FROM ingredients
WHERE id = $1;

-- name: UpdateIngredient :one
UPDATE ingredients SET
  name = $2,
  recipe_id = $3,
  product_ids = $4,
  updated_at = $5,
  updated_by = $6
WHERE id = $1
RETURNING *;

-- name: DeleteIngredient :exec
DELETE FROM ingredients
WHERE id = $1;
