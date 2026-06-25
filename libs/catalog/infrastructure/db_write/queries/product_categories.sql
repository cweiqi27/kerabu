-- name: CreateProductCategory :one
INSERT INTO product_categories (product_id, category_id, created_at, created_by)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: RemoveProductCategory :exec
DELETE FROM product_categories
WHERE product_id = $1 AND category_id = $2;
