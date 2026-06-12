package main

import (
	"context"
	"fmt"
	"time"

	"github.com/cweiqi27/kerabu/libs/shared/infrastructure/db/postgres"
)

func main() {
	ctx := context.Background()

	pool, err := postgres.NewConnection(ctx, "postgres://postgres:postgres@localhost:5432/kerabu", nil)
	if err != nil {
		fmt.Printf("Error: %s", err.Error())
	}

	pingCtx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	if err = pool.Ping(pingCtx); err != nil {
		fmt.Printf("Pool error: %s", err.Error())
	}

	_, err = pool.Exec(pingCtx, "INSERT INTO catalog_write.providers (name, status, created_at, created_by) VALUES ('test', 'active', $1, $2)", time.Now(), time.Now())
	if err != nil {
		fmt.Printf("SQL Error: %s", err.Error())
	}

	defer pool.Close()
}
