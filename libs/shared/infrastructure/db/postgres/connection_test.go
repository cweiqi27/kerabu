package postgres

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestNewConnection_InvalidDSN(t *testing.T) {
	ctx := context.Background()

	cfg := DBConfig{
		MaxConns:        0,
		MinConns:        0,
		MaxConnIdleTime: 0,
	}

	// Test with invalid DSN
	conn, err := NewConnection(ctx, "invalid-dsn", &cfg)
	assert.Error(t, err)
	assert.Nil(t, conn)
}

func TestNewConnection_UnreachableHost(t *testing.T) {
	ctx := context.Background()

	cfg := DBConfig{
		MaxConns:        0,
		MinConns:        0,
		MaxConnIdleTime: 0,
	}

	// Test with unreachable host
	conn, err := NewConnection(ctx, "postgres://user:pass@unreachable-host:5432/db?connect_timeout=1", &cfg)
	assert.Error(t, err)
	assert.Nil(t, conn)
}
