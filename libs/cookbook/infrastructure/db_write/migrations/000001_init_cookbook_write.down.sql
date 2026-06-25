BEGIN;

DROP INDEX IF EXISTS idx_ingredients_recipe_id;
DROP INDEX IF EXISTS idx_outbox_events_status_created_at;
DROP INDEX IF EXISTS idx_outbox_events_trace_id;

DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS recipes;

DROP TABLE IF EXISTS idempotency_keys;
DROP TABLE IF EXISTS processed_messages;
DROP TABLE IF EXISTS outbox_archive;
DROP TABLE IF EXISTS outbox_events;

DROP TYPE IF EXISTS recipes_status;
DROP TYPE IF EXISTS recipes_visibility;
DROP TYPE IF EXISTS outbox_event_status;
DROP TYPE IF EXISTS outbox_archive_status;

COMMIT;
