-- name: CreateIngredient :one
INSERT INTO cookbook_write.ingredients (
  id, name, recipe_id, product_ids, created_at, created_by, updated_at, updated_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetIngredientByID :one
SELECT * FROM cookbook_write.ingredients
WHERE id = $1;

-- name: UpdateIngredient :one
UPDATE cookbook_write.ingredients SET
  name = $2,
  recipe_id = $3,
  product_ids = $4,
  updated_at = $5,
  updated_by = $6
WHERE id = $1
RETURNING *;

-- name: DeleteIngredient :exec
DELETE FROM cookbook_write.ingredients
WHERE id = $1;
