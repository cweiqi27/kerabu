BEGIN;

DROP TABLE IF EXISTS catalog_write.brand_tags;
DROP TABLE IF EXISTS catalog_write.product_brands;
DROP TABLE IF EXISTS catalog_write.product_categories;
DROP TABLE IF EXISTS catalog_write.product_providers;
DROP TABLE IF EXISTS catalog_write.category_tags;

DROP TABLE IF EXISTS catalog_write.provider_raw_data;
DROP TABLE IF EXISTS catalog_write.tags;

DROP TABLE IF EXISTS catalog_write.brands;
DROP TABLE IF EXISTS catalog_write.providers;
DROP TABLE IF EXISTS catalog_write.categories;
DROP TABLE IF EXISTS catalog_write.products;

DROP TABLE IF EXISTS catalog_write.idempotency_keys;
DROP TABLE IF EXISTS catalog_write.processed_messages;
DROP TABLE IF EXISTS catalog_write.outbox_archive;
DROP TABLE IF EXISTS catalog_write.outbox_events;

DROP TYPE IF EXISTS catalog_write.provider_raw_data_status;
DROP TYPE IF EXISTS catalog_write.provider_status;
DROP TYPE IF EXISTS catalog_write.brand_status;
DROP TYPE IF EXISTS catalog_write.outbox_archive_status;
DROP TYPE IF EXISTS catalog_write.outbox_event_status;
DROP TYPE IF EXISTS catalog_write.category_status;
DROP TYPE IF EXISTS catalog_write.product_status;
DROP TYPE IF EXISTS catalog_write.product_visibility;
DROP TYPE IF EXISTS catalog_write.product_net_unit;
DROP TYPE IF EXISTS catalog_write.brand_visibility;

DROP SCHEMA IF EXISTS catalog_write;

COMMIT;

