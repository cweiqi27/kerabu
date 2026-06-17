BEGIN;

CREATE SCHEMA IF NOT EXISTS shopping_write;

CREATE TYPE shopping_write.shops_status AS ENUM('inactive', 'active');
CREATE TABLE shopping_write.shops (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status shopping_write.shops_status NOT NULL,
  provider TEXT NOT NULL CHECK (provider IN ('manual', 'open_street_map')),
  place_id TEXT,
  place_url TEXT,
  latitude DECIMAL(10, 7),
  longitude DECIMAL(10, 7),
  formatted_address TEXT NOT NULL,
  address_components JSONB,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT,

  CONSTRAINT unique_provider_place UNIQUE (provider, place_id),
  CONSTRAINT check_provider_data CHECK (
    (provider = 'manual') OR
    (provider = 'open_street_map' AND place_id IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL)
  )
);

CREATE TYPE shopping_write.lists_status AS ENUM('draft', 'ready', 'active', 'completed', 'discarded');
CREATE TABLE shopping_write.lists (
  id UUID PRIMARY KEY,
  name TEXT,
  status shopping_write.lists_status NOT NULL,
  shopping_date DATE,
  owner_party_id UUID NOT NULL,
  shop_id UUID REFERENCES shopping_write.shops(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE shopping_write.items (
  id UUID PRIMARY KEY,
  name TEXT,
  list_id UUID NOT NULL REFERENCES shopping_write.lists(id) ON DELETE CASCADE,
  product_ids UUID[] NOT NULL,
  is_ticked BOOLEAN NOT NULL,
  quantity INTEGER NOT NULL,
  reason TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE shopping_write.outbox_event_status AS ENUM ('pending', 'processing', 'failed');
CREATE TABLE shopping_write.outbox_events (
  id UUID PRIMARY KEY,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status shopping_write.outbox_event_status NOT NULL,
  retry_count INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE shopping_write.outbox_archive_status AS ENUM ('success', 'failed');
CREATE TABLE shopping_write.outbox_archive (
  id UUID PRIMARY KEY,
  outbox_event_id UUID NOT NULL,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status shopping_write.outbox_archive_status NOT NULL,
  retry_count INTEGER NOT NULL,
  event_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE shopping_write.idempotency_keys (
  key_id UUID PRIMARY KEY,
  request_hash TEXT NOT NULL,
  response JSONB NOT NULL,
  status_code INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE shopping_write.processed_messages (
  message_id TEXT PRIMARY KEY,
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_lists_shop_id ON shopping_write.lists(shop_id);

CREATE INDEX idx_items_list_id ON shopping_write.items(list_id);

CREATE INDEX idx_outbox_events_status_created_at ON shopping_write.outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON shopping_write.outbox_events(trace_id);

COMMIT;

