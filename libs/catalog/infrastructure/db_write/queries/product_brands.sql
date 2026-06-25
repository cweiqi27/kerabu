-- name: CreateProductBrand :one
INSERT INTO product_brands (product_id, brand_id, created_at, created_by)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: RemoveProductBrand :exec
DELETE FROM product_brands
WHERE product_id = $1 AND brand_id = $2;
