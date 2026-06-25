BEGIN;

CREATE TYPE recipes_status AS ENUM ('draft', 'inactive', 'active');
CREATE TYPE recipes_visibility AS ENUM ('official', 'community', 'private');
CREATE TABLE recipes (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status recipes_status NOT NULL,
  visibility recipes_visibility NOT NULL,
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

CREATE TABLE ingredients (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  recipe_id UUID NOT NULL REFERENCES recipes(id) ON DELETE CASCADE,
  product_ids UUID[] NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT
);

CREATE TYPE outbox_event_status AS ENUM ('pending', 'processing', 'failed');
CREATE TABLE outbox_events (
  id UUID PRIMARY KEY,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status outbox_event_status NOT NULL,
  retry_count INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE outbox_archive_status AS ENUM ('success', 'failed');
CREATE TABLE outbox_archive (
  id UUID PRIMARY KEY,
  outbox_event_id UUID NOT NULL,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status outbox_archive_status NOT NULL,
  retry_count INTEGER NOT NULL,
  event_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE idempotency_keys (
  key_id UUID PRIMARY KEY,
  request_hash TEXT NOT NULL,
  response JSONB NOT NULL,
  status_code INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE processed_messages (
  message_id TEXT PRIMARY KEY,
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_ingredients_recipe_id ON ingredients(recipe_id);

CREATE INDEX idx_outbox_events_status_created_at ON outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON outbox_events(trace_id);

COMMIT;

