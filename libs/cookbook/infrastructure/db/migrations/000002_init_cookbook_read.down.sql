BEGIN;

DROP INDEX IF EXISTS cookbook_read.idx_view_recipes_status;

DROP TABLE IF EXISTS cookbook_read.view_recipes;

DROP SCHEMA IF EXISTS cookbook_read CASCADE;

COMMIT;