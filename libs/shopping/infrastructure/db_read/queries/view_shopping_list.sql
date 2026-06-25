-- name: GetViewShoppingListByID :one
SELECT * FROM view_shopping_list
WHERE list_id = $1;

-- name: ListViewShoppingLists :many
SELECT * FROM view_shopping_list
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, list_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, list_id DESC
LIMIT sqlc.arg(page_size);
