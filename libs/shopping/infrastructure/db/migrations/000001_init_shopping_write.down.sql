BEGIN;

DROP INDEX IF EXISTS shopping_write.idx_outbox_events_trace_id;
DROP INDEX IF EXISTS shopping_write.idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS shopping_write.idx_items_list_id;
DROP INDEX IF EXISTS shopping_write.idx_lists_shop_id;

DROP TABLE IF EXISTS shopping_write.processed_messages;
DROP TABLE IF EXISTS shopping_write.idempotency_keys;
DROP TABLE IF EXISTS shopping_write.outbox_archive;
DROP TABLE IF EXISTS shopping_write.outbox_events;
DROP TABLE IF EXISTS shopping_write.items;
DROP TABLE IF EXISTS shopping_write.lists;
DROP TABLE IF EXISTS shopping_write.shops;

DROP TYPE IF EXISTS shopping_write.outbox_archive_status;
DROP TYPE IF EXISTS shopping_write.outbox_event_status;
DROP TYPE IF EXISTS shopping_write.lists_status;
DROP TYPE IF EXISTS shopping_write.shops_status;

DROP SCHEMA IF EXISTS shopping_write;

COMMIT;

