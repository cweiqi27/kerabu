BEGIN;

DROP INDEX IF EXISTS cookbook_write.idx_ingredients_recipe_id;
DROP INDEX IF EXISTS cookbook_write.idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS cookbook_write.idx_outbox_events_trace_id;

DROP TABLE IF EXISTS cookbook_write.ingredients;
DROP TABLE IF EXISTS cookbook_write.recipes;

DROP TABLE IF EXISTS cookbook_write.idempotency_keys;
DROP TABLE IF EXISTS cookbook_write.processed_messages;
DROP TABLE IF EXISTS cookbook_write.outbox_archive;
DROP TABLE IF EXISTS cookbook_write.outbox_events;

DROP TYPE IF EXISTS cookbook_write.recipes_status;
DROP TYPE IF EXISTS cookbook_write.recipes_visibility;
DROP TYPE IF EXISTS cookbook_write.outbox_event_status;
DROP TYPE IF EXISTS cookbook_write.outbox_archive_status;

DROP SCHEMA IF EXISTS cookbook_write;

COMMIT;