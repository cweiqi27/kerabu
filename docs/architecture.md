# Architecture: Lab Monorepo

## 1. Core Stack

- **Orchestrator:** Nx (Monorepo management) + Mise (Tool versioning)
- **Runtime:** Bun (Strict TypeScript compliance)
- **Frontend:** Astro 6.x (SSG) + Svelte 5 (Islands / Runes)
- **Styling:** Tailwind CSS (Declarative, design-token driven)

## 2. Component Philosophy

- **Server-First:** 90% of the site should be static Astro components.
- **Client-Islands:** Use Svelte 5 for state-heavy UI (System diagrams, project filters).
- **Strictness:** `tsconfig.json` set to `strict: true`. No `any` types allowed.

## 3. The "Lab" Registry

- **Discovery:** The portfolio app must dynamically index sub-projects within `apps/` by reading their `project.json` files.
- **Showcase:** Every kerabu project must provide a `manifest.json` describing its tech stack and entry point.
