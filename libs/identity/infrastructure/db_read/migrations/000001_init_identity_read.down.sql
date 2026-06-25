BEGIN;

DROP INDEX IF EXISTS idx_view_users_status;
DROP INDEX IF EXISTS idx_view_parties_members;

DROP TABLE IF EXISTS view_users;
DROP TABLE IF EXISTS view_parties;

DROP EXTENSION IF EXISTS citext;

COMMIT;
