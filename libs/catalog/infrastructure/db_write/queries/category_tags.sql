-- name: CreateCategoryTag :one
INSERT INTO category_tags (category_id, tag_id, created_at, created_by)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: RemoveCategoryTag :exec
DELETE FROM category_tags
WHERE category_id = $1 AND tag_id = $2;
