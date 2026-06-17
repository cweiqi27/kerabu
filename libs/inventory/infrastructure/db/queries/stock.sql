-- name: CreateStock :one
INSERT INTO inventory_write.stock (
  id, product_id, area_id, status, owner_party_id, quantity, quantity_display, net_value, net_unit, remaining_value, expires_at, created_at, created_by, updated_at, updated_by, deleted_at, deleted_by
) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
RETURNING *;

-- name: GetStockByID :one
SELECT * FROM inventory_write.stock
WHERE id = $1 AND deleted_at IS NULL;

-- name: UpdateStock :one
UPDATE inventory_write.stock SET
  product_id = $2,
  area_id = $3,
  status = $4,
  owner_party_id = $5,
  quantity = $6,
  quantity_display = $7,
  net_value = $8,
  net_unit = $9,
  remaining_value = $10,
  expires_at = $11,
  updated_at = $12,
  updated_by = $13,
  deleted_at = $14,
  deleted_by = $15
WHERE id = $1
RETURNING *;

-- name: SoftDeleteStock :exec
UPDATE inventory_write.stock SET
  deleted_at = $2,
  deleted_by = $3
WHERE id = $1;
