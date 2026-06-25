-- name: CreateBrandTag :one
INSERT INTO catalog_write.brand_tags (brand_id, tag_id, created_at, created_by)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: RemoveBrandTag :exec
DELETE FROM catalog_write.brand_tags
WHERE brand_id = $1 AND tag_id = $2;
