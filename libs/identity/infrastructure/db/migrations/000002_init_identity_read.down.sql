BEGIN;

DROP INDEX IF EXISTS identity_read.idx_view_users_status;
DROP INDEX IF EXISTS identity_read.idx_view_parties_members;

DROP TABLE IF EXISTS identity_read.view_users;
DROP TABLE IF EXISTS identity_read.view_parties;

DROP SCHEMA IF EXISTS identity_read CASCADE;

COMMIT;