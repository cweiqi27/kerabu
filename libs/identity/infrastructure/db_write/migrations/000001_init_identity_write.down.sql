BEGIN;

DROP INDEX IF EXISTS idx_party_members_user_id;
DROP INDEX IF EXISTS idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS idx_outbox_events_trace_id;

DROP TABLE IF EXISTS party_members;
DROP TABLE IF EXISTS parties;
DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS idempotency_keys;
DROP TABLE IF EXISTS processed_messages;
DROP TABLE IF EXISTS outbox_archive;
DROP TABLE IF EXISTS outbox_events;

DROP TYPE IF EXISTS party_members_role;
DROP TYPE IF EXISTS parties_status;
DROP TYPE IF EXISTS users_status;
DROP TYPE IF EXISTS outbox_event_status;
DROP TYPE IF EXISTS outbox_archive_status;

DROP EXTENSION IF EXISTS citext;

COMMIT;
