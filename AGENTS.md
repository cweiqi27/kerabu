# Agent Guidelines for kerabu

This document provides guidelines for AI agents operating in this repository.

## Project Overview

- **Type**: Nx monorepo with Bun workspaces
- **Package Manager**: Bun 1.3.13 (managed via Mise)
- **Go Version**: 1.26.4 (managed via Mise)
- **Language**: TypeScript (strict mode enabled) + Go
- **Frontend**: SvelteKit 5 + Tailwind CSS 4 + Vite
- **Backend**: Go services with Domain-Driven Design (DDD) architecture
- **Database**: PostgreSQL with golang-migrate migrations

## Applications

### Web (`apps/web`)

- **Stack**: SvelteKit 5, Tailwind CSS 4, Vite, TypeScript
- **Testing**: Vitest (unit), Playwright (e2e)
- **Adapter**: Auto (SvelteKit adapter-auto)

### Mobile (`apps/mobile`)

- **Stack**: SvelteKit 5, Tailwind CSS 4, Vite, TypeScript
- **Testing**: Vitest (unit)
- **Adapter**: Static (SvelteKit adapter-static)

### Backend Services (`apps/*-service`)

Go-based microservices (currently scaffolded):

- `api-gateway`
- `catalog-service`
- `cookbook-service`
- `identity-service`
- `inventory-service`
- `notification-service`
- `shopping-service`

## Domain Libraries (`libs/*`)

Shared domain logic following DDD layered architecture:

```
libs/{domain}/
├── application/      # Use cases and application services
├── domain/           # Entities, value objects, domain events
└── infrastructure/   # Repositories, external adapters, migrations
```

Available libraries: `catalog`, `cookbook`, `identity`, `inventory`, `notification`, `shopping`, `shared`

## Build/Lint/Test Commands

### Root Level Commands

```bash
# Build all projects
bun run build

# Development (runs in parallel)
bun run dev

# Run all tests
bun run test

# Run all lint checks
bun run lint
```

### Web App Commands

```bash
# Navigate to the app directory
cd apps/web

# Development
bun run dev          # Start dev server
bun run build        # Production build
bun run preview      # Preview production build

# Testing
bun run test         # Run all tests (unit + e2e)
bun run test:unit    # Run Vitest unit tests
bun run test:e2e     # Run Playwright e2e tests

# Code quality
bun run lint         # Run ESLint + Prettier check
bun run format       # Run Prettier format
bun run check        # Run SvelteKit type checking
```

### Mobile App Commands

```bash
# Navigate to the app directory
cd apps/mobile

# Development
bun run dev          # Start dev server
bun run build        # Production build
bun run preview      # Preview production build

# Testing
bun run test         # Run all tests
bun run test:unit    # Run Vitest unit tests

# Code quality
bun run lint         # Run ESLint + Prettier check
bun run format       # Run Prettier format
bun run check        # Run SvelteKit type checking
```

### Nx Commands

```bash
# Affected projects only (faster CI)
bunx nx affected --target=build
bunx nx affected --target=test

# Run specific project
bunx nx run web:dev
bunx nx run web:build
bunx nx run mobile:dev
bunx nx run mobile:build

# List projects
bunx nx show projects
```

### Database Migrations

Each domain library has its own migration targets:

```bash
# Run all migrations
bun run migrate-up

# Run migrations for a specific domain
bunx nx run catalog:migrate-up
bunx nx run identity:migrate-up

# Create a new migration
bunx nx run catalog:migrate-create --args="--name=add_users_table"

# Rollback migrations
bunx nx run catalog:migrate-down
```

### Docker Services

```bash
# Start PostgreSQL
docker compose up -d

# Stop PostgreSQL
docker compose down
```

## Code Style Guidelines

### TypeScript

- **Strict mode is enabled** - all strict checks are on
- Use explicit types for function parameters and return values
- Avoid `any` type; use `unknown` when type is truly unknown
- Use `interface` for object shapes, `type` for unions/intersections

```typescript
// Good
function greet(name: string): string {
  return `Hello, ${name}`
}

interface User {
  id: string
  name: string
  email: string
}

// Avoid
function greet(name: any): any { ... }
```

### Svelte Components (.svelte files)

- Use Svelte 5 runes syntax (`$state`, `$derived`, `$effect`, etc.)
- Component props defined with TypeScript interfaces
- Use 2-space indentation for HTML/template content
- CSS in `<style>` blocks uses 2-space indentation

```svelte
<script lang="ts">
  interface Props {
    title: string
    description?: string
  }

  let { title, description = 'Default description' }: Props = $props()
</script>

<div class="component">
  <h1>{title}</h1>
  <p>{description}</p>
</div>

<style>
  .component {
    display: flex;
    padding: 16px;
  }
</style>
```

### Go

- Follow standard Go formatting (`gofmt`)
- Use explicit error handling
- Domain packages follow DDD: `application/`, `domain/`, `infrastructure/`

### File Naming Conventions

- **Svelte components**: PascalCase (`Welcome.svelte`, `UserCard.svelte`)
- **Routes**: SvelteKit file-based routing conventions
- **TypeScript/JS files**: camelCase or kebab-case
- **Go files**: snake_case
- **Directories**: kebab-case (`src/components`, `src/routes`)

### Import Conventions

- Svelte components: Relative imports
- Asset imports: Use standard Vite asset handling
- Tailwind CSS: Utility classes only, no custom CSS imports needed

### CSS Guidelines

- Use Tailwind CSS utility classes as primary styling approach
- Follow existing indentation (2 spaces)
- Use CSS custom properties (variables) for theming when needed
- Prefer flexbox and grid for layouts

### Error Handling

- Use try/catch for async operations
- Provide meaningful error messages
- Let TypeScript types guide error handling

```typescript
try {
  const response = await fetch(url)
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  const data = await response.json()
} catch (error) {
  console.error('Failed to fetch data:', error)
  throw error
}
```

## Project Structure

```
kerabu/
├── apps/
│   ├── web/                    # SvelteKit web application
│   │   ├── src/
│   │   │   ├── routes/        # SvelteKit routes
│   │   │   └── lib/           # Shared library code
│   │   ├── static/            # Static assets
│   │   ├── project.json       # Nx project config
│   │   └── package.json
│   ├── mobile/                # SvelteKit mobile application
│   │   ├── src/
│   │   │   ├── routes/
│   │   │   └── lib/
│   │   ├── static/
│   │   ├── project.json
│   │   └── package.json
│   └── *-service/             # Go backend services (scaffolded)
├── libs/                       # Shared domain libraries
│   ├── catalog/
│   ├── cookbook/
│   ├── identity/
│   ├── inventory/
│   ├── notification/
│   ├── shopping/
│   └── shared/
│       ├── application/       # Use cases
│       ├── domain/            # Domain models
│       └── infrastructure/    # DB, external services, migrations
├── docs/                       # Architecture docs and ERDs
├── compose.yaml               # Docker Compose (PostgreSQL)
├── nx.json                    # Nx configuration
├── tsconfig.base.json         # Base TypeScript config
├── bunfig.toml               # Bun configuration
├── mise.toml                 # Mise tool versions
├── go.mod                     # Go module definition
└── bun.lock                   # Lockfile (auto-generated)
```

## Tooling

- **Linting**: ESLint with recommended JS config + Prettier integration
- **Formatting**: Prettier with tabs, no semicolons, single quotes
- **Type Checking**: TypeScript strict mode + SvelteKit sync
- **Testing**: Vitest (unit) + Playwright (e2e for web)
- **Migration**: golang-migrate for PostgreSQL schema migrations

## Notes for Agents

1. **Mise for tool versioning**: Both Bun and Go versions are managed via `mise.toml`. Ensure correct versions are active.

2. **Strict TypeScript**: The tsconfig extends strict settings. All strict checks are enabled.

3. **Monorepo structure**: Workspace packages are in `apps/*`. Bun workspaces are configured in root `package.json`.

4. **Empty backend services**: The Go services in `apps/*-service` are currently scaffolded but empty. When implementing, follow the DDD patterns established in `libs/`.

5. **Database**: PostgreSQL runs via Docker Compose. Each domain library manages its own migrations with a separate schema migrations table.

6. **Before committing**: Verify builds pass with `bun run build` and check TypeScript compiles without errors.

<!-- nx configuration start-->
<!-- Leave the start & end comments to automatically receive updates. -->

## General Guidelines for working with Nx

- For navigating/exploring the workspace, invoke the `nx-workspace` skill first - it has patterns for querying projects, targets, and dependencies
- When running tasks (for example build, lint, test, e2e, etc.), always prefer running the task through `nx` (i.e. `nx run`, `nx run-many`, `nx affected`) instead of using the underlying tooling directly
- Prefix nx commands with the workspace's package manager (e.g., `bunx nx build`, `npm exec nx test`) - avoids using globally installed CLI
- You have access to the Nx MCP server and its tools, use them to help the user
- For Nx plugin best practices, check `node_modules/@nx/<plugin>/PLUGIN.md`. Not all plugins have this file - proceed without it if unavailable.
- NEVER guess CLI flags - always check nx_docs or `--help` first when unsure

## Scaffolding & Generators

- For scaffolding tasks (creating apps, libs, project structure, setup), ALWAYS invoke the `nx-generate` skill FIRST before exploring or calling MCP tools

## When to use nx_docs

- USE for: advanced config options, unfamiliar flags, migration guides, plugin configuration, edge cases
- DON'T USE for: basic generator syntax (`nx g @nx/react:app`), standard commands, things you already know
- The `nx-generate` skill handles generator discovery internally - don't call nx_docs just to look up generator syntax

<!-- nx configuration end-->
