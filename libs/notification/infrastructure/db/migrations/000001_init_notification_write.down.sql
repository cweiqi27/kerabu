BEGIN;


DROP TABLE IF EXISTS notification_write.inbox_messages;

DROP TABLE IF EXISTS notification_write.idempotency_keys;
DROP TABLE IF EXISTS notification_write.processed_messages;
DROP TABLE IF EXISTS notification_write.outbox_archive;
DROP TABLE IF EXISTS notification_write.outbox_events;

DROP TYPE IF EXISTS notification_write.inbox_messages_status;

DROP TYPE IF EXISTS notification_write.outbox_event_status;
DROP TYPE IF EXISTS notification_write.outbox_archive_status;


DROP SCHEMA IF EXISTS notification_write;

COMMIT;

