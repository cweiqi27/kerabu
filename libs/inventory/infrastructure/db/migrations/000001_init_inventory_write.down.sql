BEGIN;

DROP INDEX IF EXISTS inventory_write.idx_stock_product_id;
DROP INDEX IF EXISTS inventory_write.idx_stock_area_id;
DROP INDEX IF EXISTS inventory_write.idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS inventory_write.idx_outbox_events_trace_id;

DROP TABLE IF EXISTS inventory_write.stock_transactions;
DROP TABLE IF EXISTS inventory_write.stock;
DROP TABLE IF EXISTS inventory_write.areas;

DROP TABLE IF EXISTS inventory_write.idempotency_keys;
DROP TABLE IF EXISTS inventory_write.processed_messages;
DROP TABLE IF EXISTS inventory_write.outbox_archive;
DROP TABLE IF EXISTS inventory_write.outbox_events;

DROP TYPE IF EXISTS inventory_write.stock_transactions_action;
DROP TYPE IF EXISTS inventory_write.stock_status;
DROP TYPE IF EXISTS inventory_write.stock_net_unit;
DROP TYPE IF EXISTS inventory_write.area_status;
DROP TYPE IF EXISTS inventory_write.outbox_event_status;
DROP TYPE IF EXISTS inventory_write.outbox_archive_status;

DROP SCHEMA IF EXISTS inventory_write;

COMMIT;