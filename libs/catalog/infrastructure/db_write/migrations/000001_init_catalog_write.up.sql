BEGIN;

CREATE TYPE product_status AS ENUM ('inactive', 'active', 'archived');
CREATE TYPE product_net_unit AS ENUM('g', 'kg', 'ml', 'l');
CREATE TYPE product_visibility AS ENUM ('official', 'community', 'private');
CREATE TABLE products (
  id UUID PRIMARY KEY,
  status product_status NOT NULL,
  name TEXT NOT NULL,
  barcode TEXT,
  net_value NUMERIC(10, 3) NOT NULL,
  net_unit product_net_unit NOT NULL,
  image_url TEXT,
  nutriscore TEXT,
  nova_group INTEGER,
  owner_id UUID,
  visibility product_visibility NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE category_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE categories (
  id UUID PRIMARY KEY,
  status category_status NOT NULL,
  name TEXT NOT NULL,
  parent_id UUID REFERENCES categories(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE product_categories (
  product_id UUID NOT NULL,
  category_id UUID NOT NULL,
  PRIMARY KEY (product_id, category_id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (category_id) REFERENCES categories(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE provider_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE providers (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status provider_status NOT NULL,
  website_url TEXT,
  logo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE product_providers (
  product_id UUID NOT NULL,
  provider_id UUID NOT NULL,
  PRIMARY KEY (product_id, provider_id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (provider_id) REFERENCES providers(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TABLE tags (
  id UUID PRIMARY KEY,
  name TEXT UNIQUE NOT NULL,
  provider_id UUID REFERENCES providers(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE category_tags (
  category_id UUID NOT NULL,
  tag_id UUID NOT NULL,
  PRIMARY KEY (category_id, tag_id),
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE brand_visibility AS ENUM ('official', 'community', 'private');
CREATE TYPE brand_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE brands (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  status brand_status NOT NULL,
  logo_url TEXT,
  owner_id UUID,
  visibility brand_visibility NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TABLE brand_tags (
  brand_id UUID NOT NULL,
  tag_id UUID NOT NULL,
  PRIMARY KEY (brand_id, tag_id),
  FOREIGN KEY (brand_id) REFERENCES brands(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TABLE product_brands (
  product_id UUID NOT NULL,
  brand_id UUID NOT NULL,
  PRIMARY KEY (product_id, brand_id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (brand_id) REFERENCES brands(id),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL
);

CREATE TYPE provider_raw_data_status AS ENUM('pending', 'processed', 'failed');
CREATE TABLE provider_raw_data (
  id UUID PRIMARY KEY,
  barcode TEXT,
  status provider_raw_data_status NOT NULL,
  provider_id UUID NOT NULL REFERENCES providers(id),
  raw_data JSONB NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE NOT NULL,
  processed_at TIMESTAMP WITH TIME ZONE
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


CREATE INDEX idx_products_barcode ON products(barcode);

CREATE INDEX idx_categories_parent_id ON categories(parent_id);

CREATE INDEX idx_product_categories_category_id ON product_categories(category_id);

CREATE INDEX idx_product_providers_provider_id ON product_providers(provider_id);

CREATE INDEX idx_tags_provider_id ON tags(provider_id);

CREATE INDEX idx_category_tags_tag_id ON category_tags(tag_id);

CREATE INDEX idx_brand_tags_tag_id ON brand_tags(tag_id);

CREATE INDEX idx_product_brands_brand_id ON product_brands(brand_id);

CREATE INDEX idx_outbox_events_status_created_at ON outbox_events(status, created_at ASC);
CREATE INDEX idx_outbox_events_trace_id ON outbox_events(trace_id);

CREATE INDEX idx_provider_raw_data_provider_id_status ON provider_raw_data(provider_id, status);
CREATE INDEX idx_provider_raw_data_barcode ON provider_raw_data(barcode);

COMMIT;

