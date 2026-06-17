BEGIN;

CREATE SCHEMA IF NOT EXISTS inventory_write;

CREATE TYPE inventory_write.area_status AS ENUM ('active', 'inactive');
CREATE TABLE inventory_write.areas (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status inventory_write.area_status NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE inventory_write.stock_status AS ENUM ('available', 'reserved', 'opened', 'expired', 'consumed', 'discarded', 'lost');
CREATE TYPE inventory_write.stock_net_unit AS ENUM('g', 'kg', 'ml', 'l');
CREATE TABLE inventory_write.stock (
  id UUID PRIMARY KEY,
  product_id UUID NOT NULL,
  area_id UUID REFERENCES inventory_write.areas(id),
  status inventory_write.stock_status NOT NULL,
  owner_party_id UUID NOT NULL,
  quantity INTEGER NOT NULL,
  quantity_display TEXT NOT NULL,
  net_value NUMERIC(10, 3) NOT NULL,
  net_unit inventory_write.stock_net_unit NOT NULL,
  remaining_value NUMERIC(10, 3),
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE inventory_write.stock_transactions_action AS ENUM('added', 'consumed', 'opened', 'discarded', 'expired', 'moved', 'corrected');
CREATE TABLE inventory_write.stock_transactions (
  id UUID PRIMARY KEY,
  stock_id UUID NOT NULL REFERENCES inventory_write.stock ON DELETE CASCADE,
  action TEXT NOT NULL,
  delta_quantity INTEGER NOT NULL,
  delta_remaining_value NUMERIC(10, 3) NOT NULL,
  payload JSONB NOT NULL,
  owner_party_id UUID NOT NULL,
  actor_id UUID,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE inventory_write.outbox_event_status AS ENUM ('pending', 'processing', 'failed');
CREATE TABLE inventory_write.outbox_events (
  id UUID PRIMARY KEY,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status inventory_write.outbox_event_status NOT NULL,
  retry_count INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE inventory_write.outbox_archive_status AS ENUM ('success', 'failed');
CREATE TABLE inventory_write.outbox_archive (
  id UUID PRIMARY KEY,
  outbox_event_id UUID NOT NULL,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status inventory_write.outbox_archive_status NOT NULL,
  retry_count INTEGER NOT NULL,
  event_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE inventory_write.idempotency_keys (
  key_id UUID PRIMARY KEY,
  request_hash TEXT NOT NULL,
  response JSONB NOT NULL,
  status_code INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE inventory_write.processed_messages (
  message_id TEXT PRIMARY KEY,
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_stock_product_id ON inventory_write.stock(product_id);
CREATE INDEX idx_stock_area_id ON inventory_write.stock(area_id);

CREATE INDEX idx_outbox_events_status_created_at ON inventory_write.outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON inventory_write.outbox_events(trace_id);

COMMIT;

