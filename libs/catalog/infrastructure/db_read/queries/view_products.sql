-- name: GetViewProductByID :one
SELECT * FROM view_products
WHERE product_id = $1;

-- name: GetViewProductByBarcode :one
SELECT * FROM view_products
WHERE barcode = $1;

-- name: ListViewProducts :many
SELECT * FROM view_products
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, product_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, product_id DESC
LIMIT sqlc.arg(page_size);

-- name: SearchViewProducts :many
SELECT * FROM view_products
WHERE (
  (status = 'active' AND visibility IN ('official', 'community'))
  OR (visibility = 'private' AND owner_id = sqlc.arg(owner_id)::uuid)
)
AND (sqlc.arg(search_query)::text IS NULL OR product_name ILIKE '%' || sqlc.arg(search_query)::text || '%')
AND (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, product_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, product_id DESC
LIMIT sqlc.arg(page_size);
