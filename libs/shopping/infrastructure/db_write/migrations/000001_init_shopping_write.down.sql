BEGIN;

DROP INDEX IF EXISTS idx_outbox_events_trace_id;
DROP INDEX IF EXISTS idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS idx_items_list_id;
DROP INDEX IF EXISTS idx_lists_shop_id;

DROP TABLE IF EXISTS processed_messages;
DROP TABLE IF EXISTS idempotency_keys;
DROP TABLE IF EXISTS outbox_archive;
DROP TABLE IF EXISTS outbox_events;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS lists;
DROP TABLE IF EXISTS shops;

DROP TYPE IF EXISTS outbox_archive_status;
DROP TYPE IF EXISTS outbox_event_status;
DROP TYPE IF EXISTS lists_status;
DROP TYPE IF EXISTS shops_status;

COMMIT;

