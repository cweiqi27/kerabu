BEGIN;

DROP INDEX IF EXISTS idx_stock_product_id;
DROP INDEX IF EXISTS idx_stock_area_id;
DROP INDEX IF EXISTS idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS idx_outbox_events_trace_id;

DROP TABLE IF EXISTS stock_transactions;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS areas;

DROP TABLE IF EXISTS idempotency_keys;
DROP TABLE IF EXISTS processed_messages;
DROP TABLE IF EXISTS outbox_archive;
DROP TABLE IF EXISTS outbox_events;

DROP TYPE IF EXISTS stock_transactions_action;
DROP TYPE IF EXISTS stock_status;
DROP TYPE IF EXISTS stock_net_unit;
DROP TYPE IF EXISTS area_status;
DROP TYPE IF EXISTS outbox_event_status;
DROP TYPE IF EXISTS outbox_archive_status;

COMMIT;
