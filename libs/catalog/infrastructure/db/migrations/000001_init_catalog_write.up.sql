BEGIN;

CREATE SCHEMA IF NOT EXISTS catalog_write;

CREATE TYPE catalog_write.product_status AS ENUM ('inactive', 'active', 'archived');
CREATE TYPE catalog_write.product_net_unit AS ENUM('g', 'kg', 'ml', 'l');
CREATE TYPE catalog_write.product_visibility AS ENUM ('official', 'community', 'private');
CREATE TABLE catalog_write.products (
  id UUID PRIMARY KEY,
  status catalog_write.product_status NOT NULL,
  name TEXT NOT NULL,
  barcode TEXT,
  net_value NUMERIC(10, 3) NOT NULL,
  net_unit catalog_write.product_net_unit NOT NULL,
  image_url TEXT,
  nutriscore TEXT,
  nova_group INTEGER,
  owner_id UUID,
  visibility catalog_write.product_visibility NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE catalog_write.category_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE catalog_write.categories (
  id UUID PRIMARY KEY,
  status catalog_write.category_status NOT NULL,
  name TEXT NOT NULL,
  parent_id UUID REFERENCES catalog_write.categories(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE catalog_write.product_categories (
  product_id UUID NOT NULL,
  category_id UUID NOT NULL,
  PRIMARY KEY (product_id, category_id),
  FOREIGN KEY (product_id) REFERENCES catalog_write.products(id),
  FOREIGN KEY (category_id) REFERENCES catalog_write.categories(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE catalog_write.provider_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE catalog_write.providers (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status catalog_write.provider_status NOT NULL,
  website_url TEXT,
  logo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE catalog_write.product_providers (
  product_id UUID NOT NULL,
  provider_id UUID NOT NULL,
  PRIMARY KEY (product_id, provider_id),
  FOREIGN KEY (product_id) REFERENCES catalog_write.products(id),
  FOREIGN KEY (provider_id) REFERENCES catalog_write.providers(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TABLE catalog_write.tags (
  id UUID PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  provider_id UUID REFERENCES catalog_write.providers(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE catalog_write.category_tags (
  category_id UUID NOT NULL,
  tag_id UUID NOT NULL,
  PRIMARY KEY (category_id, tag_id),
  FOREIGN KEY (category_id) REFERENCES catalog_write.categories(id),
  FOREIGN KEY (tag_id) REFERENCES catalog_write.tags(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE catalog_write.brand_visibility AS ENUM ('official', 'community', 'private');
CREATE TYPE catalog_write.brand_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE catalog_write.brands (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status catalog_write.brand_status NOT NULL,
  logo_url TEXT,
  owner_id UUID,
  visibility catalog_write.brand_visibility NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE catalog_write.brand_tags (
  brand_id UUID NOT NULL,
  tag_id UUID NOT NULL,
  PRIMARY KEY (brand_id, tag_id),
  FOREIGN KEY (brand_id) REFERENCES catalog_write.brands(id),
  FOREIGN KEY (tag_id) REFERENCES catalog_write.tags(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TABLE catalog_write.product_brands (
  product_id UUID NOT NULL,
  brand_id UUID NOT NULL,
  PRIMARY KEY (product_id, brand_id),
  FOREIGN KEY (product_id) REFERENCES catalog_write.products(id),
  FOREIGN KEY (brand_id) REFERENCES catalog_write.brands(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE catalog_write.provider_raw_data_status AS ENUM('pending', 'processed', 'failed');
CREATE TABLE catalog_write.provider_raw_data (
  id UUID PRIMARY KEY,
  barcode TEXT,
  status catalog_write.provider_raw_data_status NOT NULL,
  provider_id UUID NOT NULL REFERENCES catalog_write.providers(id),
  raw_data JSONB NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE NOT NULL,
  processed_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE catalog_write.outbox_event_status AS ENUM ('pending', 'processing', 'failed');
CREATE TABLE catalog_write.outbox_events (
  id UUID PRIMARY KEY,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status catalog_write.outbox_event_status NOT NULL,
  retry_count INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TYPE catalog_write.outbox_archive_status AS ENUM ('success', 'failed');
CREATE TABLE catalog_write.outbox_archive (
  id UUID PRIMARY KEY,
  outbox_event_id UUID NOT NULL,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status catalog_write.outbox_archive_status NOT NULL,
  retry_count INTEGER NOT NULL,
  event_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE catalog_write.idempotency_keys (
  key_id UUID PRIMARY KEY,
  request_hash TEXT NOT NULL,
  response JSONB NOT NULL,
  status_code INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE catalog_write.processed_messages (
  message_id TEXT PRIMARY KEY,
  processed_at TIMESTAMP WITH TIME ZONE NOT NULL
);


CREATE INDEX idx_products_barcode ON catalog_write.products(barcode);

CREATE INDEX idx_categories_parent_id ON catalog_write.categories(parent_id);

CREATE INDEX idx_product_categories_category_id ON catalog_write.product_categories(category_id);

CREATE INDEX idx_product_providers_provider_id ON catalog_write.product_providers(provider_id);

CREATE INDEX idx_tags_provider_id ON catalog_write.tags(provider_id);

CREATE INDEX idx_category_tags_tag_id ON catalog_write.category_tags(tag_id);

CREATE INDEX idx_brand_tags_tag_id ON catalog_write.brand_tags(tag_id);

CREATE INDEX idx_product_brands_brand_id ON catalog_write.product_brands(brand_id);

CREATE INDEX idx_outbox_events_status_created_at ON catalog_write.outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON catalog_write.outbox_events(trace_id);

CREATE INDEX idx_provider_raw_data_provider_id_status ON catalog_write.provider_raw_data(provider_id, status);
CREATE INDEX idx_provider_raw_data_barcode ON catalog_write.provider_raw_data(barcode);

COMMIT;

