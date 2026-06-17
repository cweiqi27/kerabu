BEGIN;

DROP INDEX IF EXISTS identity_write.idx_party_members_user_id;
DROP INDEX IF EXISTS identity_write.idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS identity_write.idx_outbox_events_trace_id;

DROP TABLE IF EXISTS identity_write.party_members;
DROP TABLE IF EXISTS identity_write.parties;
DROP TABLE IF EXISTS identity_write.users;

DROP TABLE IF EXISTS identity_write.idempotency_keys;
DROP TABLE IF EXISTS identity_write.processed_messages;
DROP TABLE IF EXISTS identity_write.outbox_archive;
DROP TABLE IF EXISTS identity_write.outbox_events;

DROP TYPE IF EXISTS identity_write.party_members_role;
DROP TYPE IF EXISTS identity_write.parties_status;
DROP TYPE IF EXISTS identity_write.users_status;
DROP TYPE IF EXISTS identity_write.outbox_event_status;
DROP TYPE IF EXISTS identity_write.outbox_archive_status;

DROP SCHEMA IF EXISTS identity_write;

COMMIT;