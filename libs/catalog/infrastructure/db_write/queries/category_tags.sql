-- name: CreateCategoryTag :one
INSERT INTO catalog_write.category_tags (category_id, tag_id, created_at, created_by)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: RemoveCategoryTag :exec
DELETE FROM catalog_write.category_tags
WHERE category_id = $1 AND tag_id = $2;
