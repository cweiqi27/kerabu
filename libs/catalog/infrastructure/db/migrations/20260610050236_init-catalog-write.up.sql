CREATE SCHEMA IF NOT EXISTS catalog_write;

CREATE TYPE catalog_write.product_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE catalog_write.products (
  id UUID PRIMARY KEY DEFAULT uuidv7(),
  status catalog_write.product_status NOT NULL,
  name TEXT NOT NULL,
  quantity_display TEXT NOT NULL,
  net_value NUMERIC(10, 3) NOT NULL,
  net_unit TEXT NOT NULL,
  unit_family TEXT NOT NULL,
  image_url TEXT,
  nutriscore TEXT,
  nova_group INTEGER,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE catalog_write.category_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE catalog_write.categories (
  id UUID PRIMARY KEY DEFAULT uuidv7(),
  status catalog_write.category_status NOT NULL,
  name TEXT NOT NULL,
  parent_id UUID,
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
  id UUID PRIMARY KEY DEFAULT uuidv7(),
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
  id UUID PRIMARY KEY DEFAULT uuidv7(),
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

CREATE TYPE catalog_write.outbox_event_status AS ENUM ('pending', 'processing', 'failed');
CREATE TABLE catalog_write.outbox_events (
  id UUID PRIMARY KEY DEFAULT uuidv7(),
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status catalog_write.outbox_event_status NOT NULL,
  retry_count INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_by TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  updated_by TEXT,
  deleted_at TIMESTAMP WITH TIME ZONE,
  deleted_by TEXT
);

CREATE TYPE catalog_write.outbox_archive_status AS ENUM ('success', 'failed');
CREATE TABLE catalog_write.outbox_archive (
  id UUID PRIMARY KEY DEFAULT uuidv7(),
  outbox_event_id UUID NOT NULL,
  trace_id UUID NOT NULL,
  event TEXT NOT NULL,
  payload JSONB NOT NULL,
  status catalog_write.outbox_archive_status NOT NULL,
  retry_count INTEGER NOT NULL,
  event_created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  event_created_by TEXT NOT NULL,
  archived_at TIMESTAMP WITH TIME ZONE NOT NULL,
  archived_by TEXT NOT NULL
);

CREATE TYPE catalog_write.brand_status AS ENUM ('inactive', 'active', 'archived');
CREATE TABLE catalog_write.brands (
  id UUID PRIMARY KEY DEFAULT uuidv7(),
  name TEXT UNIQUE NOT NULL,
  status catalog_write.brand_status NOT NULL,
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
  id UUID PRIMARY KEY DEFAULT uuidv7(),
  barcode TEXT,
  status catalog_write.provider_raw_data_status NOT NULL,
  provider_id UUID NOT NULL REFERENCES catalog_write.providers(id),
  raw_data JSONB NOT NULL,
  fetched_at TIMESTAMP WITH TIME ZONE NOT NULL,
  processed_at TIMESTAMP WITH TIME ZONE
);
