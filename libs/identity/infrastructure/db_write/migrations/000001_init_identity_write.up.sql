BEGIN;

CREATE EXTENSION IF NOT EXISTS citext;


CREATE TYPE users_status AS ENUM('inactive', 'active');
CREATE TABLE users (
  id UUID PRIMARY KEY,
  display_name TEXT NOT NULL,
  email CITEXT NOT NULL UNIQUE,
  activated BOOLEAN NOT NULL,
  avatar_url TEXT,
  idp_subject_id TEXT NOT NULL,
  idp_provider_name TEXT NOT NULL,
  status users_status NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE,

  CONSTRAINT uq_external_identity UNIQUE (idp_provider_name, idp_subject_id)
);

CREATE TYPE parties_status AS ENUM('inactive', 'active');
CREATE TABLE parties (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status parties_status NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE party_members_role AS ENUM('owner', 'admin', 'member');
CREATE TABLE party_members (
  party_id UUID NOT NULL,
  user_id UUID NOT NULL,
  role party_members_role NOT NULL,
  PRIMARY KEY (party_id, user_id),
  FOREIGN KEY (party_id) REFERENCES parties(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
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

CREATE INDEX idx_party_members_user_id ON party_members(user_id);

COMMIT;

