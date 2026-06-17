BEGIN;

DROP TABLE IF EXISTS inventory_read.view_stock;
DROP TABLE IF EXISTS inventory_read.view_stock_transactions;

DROP SCHEMA IF EXISTS inventory_read CASCADE;

COMMIT;

