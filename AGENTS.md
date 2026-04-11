# Agent Guidelines for /workspace/lab

This document provides guidelines for AI agents operating in this repository.

## Project Overview

- **Type**: Nx monorepo with Bun workspaces
- **Main Application**: Astro-based portfolio site (`apps/portfolio`)
- **Package Manager**: Bun (latest)
- **Language**: TypeScript (strict mode enabled)

## Build/Lint/Test Commands

### Root Level Commands

```bash
# Build all projects
bun run build

# Run nx commands for the monorepo
bunx nx run-many --target=build
bunx nx run-many --target=dev
```

### Portfolio App Commands

```bash
# Navigate to the app directory
cd apps/portfolio

# Development
bun run dev          # Start dev server (http://localhost:4321)
bun run build        # Production build
bun run preview      # Preview production build
bun run astro        # Run Astro CLI commands
```

### Running Single Tests

This project uses Astro which doesn't have built-in test infrastructure. If tests are added:

```bash
# Vitest
bun vitest run src/components.test.ts
bun vitest run --watch  # Watch mode

# Playwright for e2e tests
bun playwright test
bun playwright test src/e2e/spec.spec.ts --project=chromium
```

### Nx Commands

```bash
# Affected projects only (faster CI)
bunx nx affected --target=build
bunx nx affected --target=test

# Run specific project
bunx nx run portfolio:dev
bunx nx run portfolio:build

# List projects
bunx nx show projects
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
  return `Hello, ${name}`;
}

interface User {
  id: string;
  name: string;
  email: string;
}

// Avoid
function greet(name: any): any { ... }
```

### Astro Components (.astro files)

- Frontmatter uses standard JavaScript/TypeScript (no `;` at end of statements)
- Component props defined in frontmatter with TypeScript interfaces
- Use 2-space indentation for HTML/template content
- CSS in `<style>` blocks uses 2-space indentation
- Prefer kebab-case for CSS custom properties

```astro
---
interface Props {
  title: string;
  description?: string;
}

const { title, description = 'Default description' } = Astro.props;
---

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

### File Naming Conventions

- **Astro components**: PascalCase (`Welcome.astro`, `UserCard.astro`)
- **Layouts**: PascalCase (`Layout.astro`)
- **Pages**: kebab-case (`index.astro`, `about-us.astro`)
- **TypeScript/JS files**: camelCase or kebab-case
- **Directories**: kebab-case (`src/components`, `src/layouts`)

### Import Conventions

- Astro components: Relative imports
- Frontmatter: Use relative paths, no `./` prefix not needed within same dir
- Asset imports: Use `import.meta.url` for asset paths where needed
- CSS imports: Not needed with Astro's scoped styles

```astro
---
import Welcome from '../components/Welcome.astro';
import Layout from '../layouts/Layout.astro';
import astroLogo from '../assets/astro.svg';
---
```

### CSS Guidelines

- Use scoped styles within Astro components
- Follow existing indentation (2 spaces)
- Use CSS custom properties (variables) for theming
- Prefer flexbox and grid for layouts
- Use semantic color names when possible

```astro
<style>
  :root {
    --color-primary: #3245ff;
    --spacing-md: 16px;
  }

  .container {
    display: flex;
    gap: var(--spacing-md);
  }
</style>
```

### Error Handling

- Use try/catch for async operations
- Provide meaningful error messages
- Let TypeScript types guide error handling

```typescript
try {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  const data = await response.json();
} catch (error) {
  console.error("Failed to fetch data:", error);
  throw error;
}
```

## Project Structure

```
/workspace/lab
├── apps/
│   └── portfolio/          # Main Astro application
│       ├── src/
│       │   ├── components/ # Astro components
│       │   ├── layouts/    # Page layouts
│       │   ├── pages/      # Routes
│       │   └── assets/      # Static assets
│       ├── public/         # Public static files
│       ├── project.json    # Nx project config
│       └── astro.config.mjs
├── packages/               # Shared libraries (if added)
├── services/               # Backend services (if added)
├── nx.json                 # Nx configuration
├── tsconfig.base.json      # Base TypeScript config
├── bunfig.toml            # Bun configuration
└── bun.lockb              # Workspace config (auto-generated)
```

## Common Patterns

### Astro Props Pattern

```astro
---
interface Props {
  title: string;
  items?: string[];
}

const { title, items = [] } = Astro.props;
---

<ul>
  {items.map(item => <li>{item}</li>)}
</ul>
```

### Using Asset Paths

```astro
---
import image from '../assets/photo.jpg';
---
<img src={image.src} alt="Description" />
```

## VSCode Configuration

Recommended extensions (auto-suggested via `.vscode/extensions.json`):

- Astro

## Notes for Agents

1. **No linting/formatting configured**: This project doesn't currently have ESLint, Prettier, or other linters set up. Code style is determined by Astro conventions and TypeScript strict mode.

2. **Cloudflare Pages deployment**: The project uses `wrangler.toml` suggesting Cloudflare Pages deployment.

3. **Strict TypeScript**: The tsconfig extends `astro/tsconfigs/strict` which enables strict null checks and other strict options.

4. **Monorepo structure**: When adding new apps/libs, update `pnpm-workspace.yaml` if they're not in `apps/*` or `packages/*`.

5. **Before committing**: Verify builds pass with `pnpm build` and check TypeScript compiles without errors.
