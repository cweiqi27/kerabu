-- name: GetViewCategoryByID :one
SELECT * FROM catalog_read.view_categories
WHERE category_id = $1;

-- name: ListViewCategories :many
SELECT * FROM catalog_read.view_categories
WHERE (sqlc.arg(cursor_created_at)::timestamptz IS NULL OR (created_at, category_id) < (sqlc.arg(cursor_created_at)::timestamptz, sqlc.arg(cursor_id)::uuid))
ORDER BY created_at DESC, category_id DESC
LIMIT sqlc.arg(page_size);
