BEGIN;

CREATE SCHEMA IF NOT EXISTS notification_read;

CREATE TABLE notification_read.view_inbox_messages (
  inbox_message_id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  name TEXT NOT NULL,
  status TEXT NOT NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  link_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT
);

CREATE INDEX idx_view_inbox_messages_list ON notification_read.view_inbox_messages(user_id, created_at);

COMMIT;

