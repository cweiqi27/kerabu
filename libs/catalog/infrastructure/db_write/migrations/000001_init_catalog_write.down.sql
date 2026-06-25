BEGIN;

DROP TABLE IF EXISTS brand_tags;
DROP TABLE IF EXISTS product_brands;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS product_providers;
DROP TABLE IF EXISTS category_tags;

DROP TABLE IF EXISTS provider_raw_data;
DROP TABLE IF EXISTS tags;

DROP TABLE IF EXISTS brands;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS idempotency_keys;
DROP TABLE IF EXISTS processed_messages;
DROP TABLE IF EXISTS outbox_archive;
DROP TABLE IF EXISTS outbox_events;

DROP TYPE IF EXISTS provider_raw_data_status;
DROP TYPE IF EXISTS provider_status;
DROP TYPE IF EXISTS brand_status;
DROP TYPE IF EXISTS outbox_archive_status;
DROP TYPE IF EXISTS outbox_event_status;
DROP TYPE IF EXISTS category_status;
DROP TYPE IF EXISTS product_status;
DROP TYPE IF EXISTS product_visibility;
DROP TYPE IF EXISTS product_net_unit;
DROP TYPE IF EXISTS brand_visibility;

COMMIT;

