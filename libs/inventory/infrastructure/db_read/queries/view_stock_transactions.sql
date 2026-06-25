-- name: GetViewStockTransactionByID :one
SELECT * FROM view_stock_transactions
WHERE id = $1;

-- name: ListViewStockTransactions :many
SELECT * FROM view_stock_transactions
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
