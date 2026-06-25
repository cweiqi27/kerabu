-- name: CreateStockTransaction :one
INSERT INTO stock_transactions (
  id, stock_id, action, delta_quantity, delta_remaining_value, payload, owner_party_id, actor_id, created_at, created_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
RETURNING *;

-- name: GetStockTransactionByID :one
SELECT * FROM stock_transactions
WHERE id = $1;
