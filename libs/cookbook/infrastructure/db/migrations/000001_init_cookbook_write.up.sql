BEGIN;

CREATE SCHEMA IF NOT EXISTS cookbook_write;

CREATE TYPE cookbook_write.recipes_status AS ENUM ('draft', 'inactive', 'active');
CREATE TYPE cookbook_write.recipes_visibility AS ENUM ('official', 'community', 'private');
CREATE TABLE cookbook_write.recipes (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status cookbook_write.recipes_status NOT NULL,
  visibility cookbook_write.recipes_visibility NOT NULL,
  instructions JSONB NOT NULL,
  owner_id UUID,
  owner_party_id UUID,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT,

  CONSTRAINT check_owner_id CHECK (
    (visibility = 'private' AND owner_id IS NOT NULL AND owner_party_id IS NOT NULL) OR
    (visibility = 'community' AND owner_id IS NOT NULL)
  )
);

CREATE TABLE cookbook_write.ingredients (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  recipe_id UUID NOT NULL REFERENCES cookbook_write.recipes(id) ON DELETE CASCADE,
  product_ids UUID[] NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT
);

CREATE TYPE cookbook_write.outbox_event_status AS ENUM ('pending', 'processing', 'failed');
CREATE TABLE cookbook_write.outbox_events (
  id UUID PRIMARY KEY,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status cookbook_write.outbox_event_status NOT NULL,
  retry_count INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE cookbook_write.outbox_archive_status AS ENUM ('success', 'failed');
CREATE TABLE cookbook_write.outbox_archive (
  id UUID PRIMARY KEY,
  outbox_event_id UUID NOT NULL,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status cookbook_write.outbox_archive_status NOT NULL,
  retry_count INTEGER NOT NULL,
  event_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE cookbook_write.idempotency_keys (
  key_id UUID PRIMARY KEY,
  request_hash TEXT NOT NULL,
  response JSONB NOT NULL,
  status_code INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE cookbook_write.processed_messages (
  message_id TEXT PRIMARY KEY,
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_ingredients_recipe_id ON cookbook_write.ingredients(recipe_id);

CREATE INDEX idx_outbox_events_status_created_at ON cookbook_write.outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON cookbook_write.outbox_events(trace_id);

COMMIT;

