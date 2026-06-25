BEGIN;

CREATE EXTENSION IF NOT EXISTS pg_trgm;


CREATE TABLE view_stock (
  stock_id UUID PRIMARY KEY,
  product_id UUID NOT NULL,
  product_name TEXT NOT NULL,
  product_brands TEXT,
  product_categories TEXT,
  area_id UUID,
  area_name TEXT,
  quantity_display TEXT NOT NULL,
  net_unit TEXT NOT NULL,
  total_value NUMERIC(10, 3) NOT NULL,
  status TEXT NOT NULL,
  owner_party_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE view_stock_transactions (
  id UUID PRIMARY KEY,
  product_id UUID NOT NULL,
  product_name TEXT NOT NULL,
  product_brands TEXT,
  product_image_url TEXT,
  action TEXT NOT NULL,
  actor_id UUID,
  actor_name TEXT,
  quantity_display TEXT NOT NULL,
  net_unit TEXT NOT NULL,
  delta_value NUMERIC(10, 3) NOT NULL,
  owner_party_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_view_stock_product_id ON view_stock(product_id);
CREATE INDEX idx_view_stock_product_brands ON view_stock USING GIN (product_brands gin_trgm_ops);
CREATE INDEX idx_view_stock_product_categories ON view_stock USING GIN (product_categories gin_trgm_ops);
CREATE INDEX idx_view_stock_area_id ON view_stock(area_id);
CREATE INDEX idx_view_stock_owner_party_id ON view_stock(owner_party_id);

CREATE INDEX idx_view_stock_transactions ON view_stock_transactions(owner_party_id, created_at DESC);

COMMIT;

