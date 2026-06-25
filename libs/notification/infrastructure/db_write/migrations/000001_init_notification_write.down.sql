BEGIN;

DROP TABLE IF EXISTS inbox_messages;

DROP TABLE IF EXISTS idempotency_keys;
DROP TABLE IF EXISTS processed_messages;
DROP TABLE IF EXISTS outbox_archive;
DROP TABLE IF EXISTS outbox_events;

DROP TYPE IF EXISTS inbox_messages_status;

DROP TYPE IF EXISTS outbox_event_status;
DROP TYPE IF EXISTS outbox_archive_status;


COMMIT;

