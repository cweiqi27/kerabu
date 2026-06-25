-- name: CreateProductProvider :one
INSERT INTO catalog_write.product_providers (product_id, provider_id, created_at, created_by)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: RemoveProductProvider :exec
DELETE FROM catalog_write.product_providers
WHERE product_id = $1 AND provider_id = $2;
