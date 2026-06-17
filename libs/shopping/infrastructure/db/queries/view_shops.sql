-- name: GetViewShopByID :one
SELECT * FROM shopping_read.view_shops
WHERE shop_id = $1;

-- name: ListViewShops :many
SELECT * FROM shopping_read.view_shops
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, shop_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, shop_id DESC
LIMIT sqlc.arg(page_size);
