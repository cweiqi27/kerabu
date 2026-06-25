BEGIN;


CREATE TABLE view_shopping_list (
  list_id UUID PRIMARY KEY,
  list_name TEXT,
  status TEXT NOT NULL,
  items JSONB NOT NULL,
  shopping_date DATE,
  shop_id UUID,
  shop_name TEXT,
  owner_party_id UUID NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE view_shops (
  shop_id UUID PRIMARY KEY,
  shop_name TEXT NOT NULL,
  status TEXT NOT NULL,
  provider TEXT NOT NULL,
  place_id TEXT,
  place_url TEXT,
  latitude DECIMAL(10, 7),
  longitude DECIMAL(10, 7),
  formatted_address TEXT NOT NULL,
  address_components JSONB,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_view_shopping_list_owner_party_id ON view_shopping_list(owner_party_id);

COMMIT;

