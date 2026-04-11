# Architectural Decision Records (ADR)

## ADR-001: Declarative State with Svelte 5

- **Decision:** Use Svelte 5 Runes (`$state`, `$derived`, `$effect`) exclusively.
- **Reasoning:** Eliminates imperative DOM manipulation. Aligns with the "Declarative" requirement.
- **Constraint:** Avoid legacy Svelte 4 `export let` syntax.

## ADR-002: TDD (Test-Driven Development)

- **Decision:** All logic in `src/lib` or complex Svelte components must have a `.test.ts` file.
- **Tooling:** Vitest + Svelte Testing Library.
- **Agent Instruction:** Write the test failure case _before_ implementing the feature logic.

## ADR-003: Content-Addressable Metadata

- **Decision:** Use Astro Content Collections with **Zod** for schema validation.
- **Reasoning:** Provides a type-safe bridge between Markdown files and the UI.
