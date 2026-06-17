-- name: GetViewRecipeByID :one
SELECT * FROM cookbook_read.view_recipes
WHERE id = $1;

-- name: ListViewRecipes :many
SELECT * FROM cookbook_read.view_recipes
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, id DESC
LIMIT sqlc.arg(page_size);
