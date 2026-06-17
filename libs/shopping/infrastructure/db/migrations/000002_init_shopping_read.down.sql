BEGIN;

DROP INDEX IF EXISTS shopping_read.idx_view_shopping_list_owner_party_id;

DROP TABLE IF EXISTS shopping_read.view_shops;
DROP TABLE IF EXISTS shopping_read.view_shopping_list;

DROP SCHEMA IF EXISTS shopping_read;

COMMIT;

