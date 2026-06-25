-- name: GetViewBrandByID :one
SELECT * FROM catalog_read.view_brands
WHERE brand_id = $1;

-- name: ListViewBrands :many
SELECT * FROM catalog_read.view_brands
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, brand_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, brand_id DESC
LIMIT sqlc.arg(page_size);
