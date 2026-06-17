-- name: GetViewStockByID :one
SELECT * FROM inventory_read.view_stock
WHERE stock_id = $1;

-- name: ListViewStock :many
SELECT * FROM inventory_read.view_stock
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, stock_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, stock_id DESC
LIMIT sqlc.arg(page_size);
