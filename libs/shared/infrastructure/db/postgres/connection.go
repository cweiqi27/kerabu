package postgres

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
)

type DBConfig struct {
	MaxConns        int32
	MinConns        int32
	MaxConnIdleTime time.Duration
}

func NewConnection(ctx context.Context, dsn string, cfg *DBConfig) (*pgxpool.Pool, error) {
	config, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		return nil, err
	}

	if cfg == nil {
		cfg = &DBConfig{}
	}
	if cfg.MaxConns <= 0 {
		cfg.MaxConns = 4
	}
	if cfg.MinConns <= 0 {
		cfg.MinConns = 1
	}
	if cfg.MaxConnIdleTime <= 0 {
		cfg.MaxConnIdleTime = 5 * time.Minute
	}

	config.MaxConns = cfg.MaxConns
	config.MinConns = cfg.MinConns
	config.MaxConnIdleTime = cfg.MaxConnIdleTime

	return pgxpool.NewWithConfig(ctx, config)
}
