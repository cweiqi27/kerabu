BEGIN;

CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE view_users (
  id UUID PRIMARY KEY,
  display_name TEXT NOT NULL,
  email CITEXT NOT NULL UNIQUE,
  activated BOOLEAN NOT NULL,
  avatar_url TEXT,
  idp_subject_id TEXT NOT NULL,
  idp_provider_name TEXT NOT NULL,
  parties JSONB NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE view_parties (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  members JSONB NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_view_users_status ON view_users(status);

CREATE INDEX idx_view_parties_members ON view_parties USING GIN (members);

COMMIT;
