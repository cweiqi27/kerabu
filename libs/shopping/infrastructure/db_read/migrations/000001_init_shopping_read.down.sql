BEGIN;

DROP INDEX IF EXISTS idx_view_shopping_list_owner_party_id;

DROP TABLE IF EXISTS view_shops;
DROP TABLE IF EXISTS view_shopping_list;

COMMIT;

