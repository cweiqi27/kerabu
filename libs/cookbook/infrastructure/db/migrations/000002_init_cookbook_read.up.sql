BEGIN;

CREATE SCHEMA IF NOT EXISTS cookbook_read;

CREATE TABLE cookbook_read.view_recipes (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status TEXT NOT NULL,
  instructions JSONB NOT NULL,
  ingredients JSONB NOT NULL,
  owner_id UUID,
  owner_party_id UUID,
  visibility TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT
);


CREATE INDEX idx_view_recipes_status ON cookbook_read.view_recipes(status);

COMMIT;

