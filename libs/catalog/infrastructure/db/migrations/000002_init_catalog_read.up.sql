BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE SCHEMA IF NOT EXISTS catalog_read;

CREATE TABLE catalog_read.view_products (
  product_id UUID PRIMARY KEY,
  product_name TEXT NOT NULL,
  barcode TEXT,
  status TEXT NOT NULL,
  owner_id UUID,
  visibility TEXT NOT NULL,
  brands JSONB NOT NULL,
  categories JSONB NOT NULL,
  quantity_display TEXT NOT NULL,
  net_value NUMERIC(10, 3) NOT NULL,
  net_unit TEXT NOT NULL,
  image_url TEXT,
  nutriscore TEXT,
  nova_group INTEGER,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE catalog_read.view_brands (
  brand_id UUID PRIMARY KEY,
  brand_name TEXT NOT NULL,
  status TEXT NOT NULL,
  owner_id UUID,
  visibility TEXT NOT NULL,
  tags JSONB NOT NULL,
  product_count INTEGER NOT NULL,
  tag_count INTEGER NOT NULL,
  logo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);


CREATE TABLE catalog_read.view_categories (
  category_id UUID PRIMARY KEY,
  category_name TEXT NOT NULL,
  status TEXT NOT NULL,
  parent JSONB,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_view_products_barcode ON catalog_read.view_products(barcode);
CREATE INDEX idx_view_products_global_active
  ON catalog_read.view_products (LOWER(product_name))
  WHERE visibility IN ('official', 'community') AND status = 'active';
CREATE INDEX idx_view_products_private_owner
  ON catalog_read.view_products (owner_id, LOWER(product_name))
  WHERE visibility IN ('private');
CREATE INDEX idx_view_products_product_name_trgm ON catalog_read.view_products USING GIN (product_name gin_trgm_ops)
  WHERE visibility IN ('official', 'community') AND status = 'active';
CREATE INDEX idx_view_products_brands ON catalog_read.view_products USING GIN (brands jsonb_path_ops)
  WHERE visibility IN ('official', 'community') AND status = 'active';
CREATE INDEX idx_view_products_categories ON catalog_read.view_products USING GIN (categories jsonb_path_ops)
  WHERE visibility IN ('official', 'community') AND status = 'active';

CREATE INDEX idx_view_brands_status_created_at ON catalog_read.view_brands(status, created_at DESC);
CREATE INDEX idx_view_brands_brand_name_trgm ON catalog_read.view_brands USING GIN (brand_name gin_trgm_ops);
CREATE INDEX idx_view_brands_global_active
  ON catalog_read.view_brands (LOWER(brand_name))
  WHERE visibility IN ('official', 'community') AND status = 'active';
CREATE INDEX idx_view_brands_private_owner
  ON catalog_read.view_brands (owner_id, LOWER(brand_name))
  WHERE visibility IN ('private');

COMMIT;

