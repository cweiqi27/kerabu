BEGIN;


CREATE TYPE inbox_messages_status AS ENUM ('unread', 'read');
CREATE TABLE inbox_messages (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  name TEXT NOT NULL,
  status inbox_messages_status NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  link_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
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

CREATE INDEX idx_outbox_events_status_created_at ON outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON outbox_events(trace_id);

COMMIT;

