# kerabu

A monorepo containing a full-stack application with SvelteKit frontends and Go backend services.

## Tech Stack

- **Monorepo**: Nx with Bun workspaces
- **Frontend**: SvelteKit 5 + Tailwind CSS 4 + Vite
- **Backend**: Go 1.26.4 with Domain-Driven Design (DDD) architecture
- **Database**: PostgreSQL with golang-migrate migrations
- **Package Manager**: Bun 1.3.13
- **Tooling**: Mise (version management), ESLint, Prettier

## Project Structure

```
kerabu/
├── apps/
│   ├── web/                 # SvelteKit web application
│   ├── mobile/              # SvelteKit mobile application (static)
│   └── *-service/           # Go backend microservices
├── libs/                    # Shared domain libraries (DDD)
│   ├── catalog/
│   ├── cookbook/
│   ├── identity/
│   ├── inventory/
│   ├── notification/
│   ├── shopping/
│   └── shared/
├── docs/                    # Architecture docs and ERDs
├── compose.yaml             # Docker Compose (PostgreSQL)
├── nx.json                  # Nx configuration
├── mise.toml                # Tool versions (Bun, Go)
├── go.mod                   # Go module definition
└── package.json             # Root package configuration
```

## Prerequisites

- [Bun](https://bun.sh) 1.3.13 (managed via [Mise](https://mise.jdx.dev/))
- [Go](https://go.dev) 1.26.4 (managed via Mise)
- [Docker](https://www.docker.com) (for PostgreSQL)
- [golang-migrate](https://github.com/golang-migrate/migrate) (for database migrations)

## Getting Started

### 1. Install Tools

Using Mise:

```bash
mise install
```

### 2. Install Dependencies

```bash
bun install
```

### 3. Start PostgreSQL

```bash
docker compose up -d
```

### 4. Run Database Migrations

```bash
bun run migrate-up
```

### 5. Start Development Servers

Run all apps in parallel:

```bash
bun run dev
```

Or run specific apps:

```bash
bunx nx run web:dev
bunx nx run mobile:dev
```

## Available Commands

### Root Level

```bash
bun run build          # Build all projects
bun run dev            # Start all dev servers
bun run test           # Run all tests
bun run lint           # Run all lint checks
bun run migrate-up     # Run all database migrations
```

### Web App

```bash
cd apps/web

bun run dev            # Start dev server
bun run build          # Production build
bun run preview        # Preview production build
bun run test           # Run all tests (unit + e2e)
bun run test:unit      # Run Vitest unit tests
bun run test:e2e       # Run Playwright e2e tests
bun run lint           # Run ESLint + Prettier check
bun run format         # Run Prettier format
bun run check          # Run SvelteKit type checking
```

### Mobile App

```bash
cd apps/mobile

bun run dev            # Start dev server
bun run build          # Production build
bun run preview        # Preview production build
bun run test           # Run all tests
bun run test:unit      # Run Vitest unit tests
bun run lint           # Run ESLint + Prettier check
bun run format         # Run Prettier format
bun run check          # Run SvelteKit type checking
```

### Database Migrations

```bash
# Run migrations for a specific domain
bunx nx run catalog:migrate-up
bunx nx run identity:migrate-up

# Create a new migration
bunx nx run catalog:migrate-create --args="--name=add_users_table"

# Rollback migrations
bunx nx run catalog:migrate-down
```

## Applications

### Web (`apps/web`)

The main web application built with SvelteKit 5, using the auto adapter for deployment flexibility. Features unit tests with Vitest and end-to-end tests with Playwright.

### Mobile (`apps/mobile`)

A mobile-optimized SvelteKit application using the static adapter for static site generation. Shares the same component architecture and styling as the web app.

### Backend Services (`apps/*-service`)

Go-based microservices currently scaffolded but not yet implemented. Each service is designed to follow Domain-Driven Design patterns with the corresponding `libs/*` domain library.

## Domain Libraries (`libs/*`)

Shared Go libraries following DDD layered architecture:

- **`application/`** - Use cases and application services
- **`domain/`** - Entities, value objects, domain events
- **`infrastructure/`** - Repositories, external adapters, database migrations

## Notes

- The Go backend services are currently empty and need implementation.
- Each domain library manages its own PostgreSQL schema migrations with a separate migrations table.
- TypeScript strict mode is enabled across all frontend projects.

## License

MIT
