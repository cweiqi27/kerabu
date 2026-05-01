# Product Requirements Document: Lab Monorepo & Portfolio

## 1. Project Vision

A high-tier, performance-first technical portfolio and "workshop" indexer. The UI must reflect neutral tones and Japandi, minimalist aesthetics.

---

## 2. Immediate Milestone: Phase 1 Landing Page

The landing page must be a single-page entry point focused on Professional Credibility and Communication.

### 2.1 Feature: Work Experience Timeline

    Requirement: Declarative rendering of career history from Astro Content Collections.

    Data Source: src/content/experience/*.md.

### 2.2 Feature: Reactive Contact Section

    Requirement: A Svelte 5 island using Runes.

    Logic: Cmd+K or a visible button triggers a modal for direct contact via email or social links.

    Acceptance Criteria: Must use $state for modal visibility and $derived for character counts in any text inputs.

## 3. Technical Constraints (Non-Negotiable)

- Category Constraint
- Framework Astro 6.x (Using workerd runtime via Vite Environment API).
- Reactivity Svelte 5 Runes only. No export let or writable stores.
- Language Strict TypeScript. noImplicitAny: true, exactOptionalPropertyTypes: true.
- Testing TDD via Vitest. Tests must be written and fail before logic is implemented.
- Styling Tailwind CSS. No custom CSS files. Use a 4px grid system.
- Build Tools Bun for all scripts and package management. Nx for task orchestration.

## 4. UI/UX Design System (The "Hardware" Vibe)

The site must feel "built," not "designed."

    Palette: * Base: #0A0A0A (Carbon fiber depth)

        Surface: #121212 (Anodized aluminum)

        Accent: #10B981 (Emerald-500) for "Active" states only.

    Typography: JetBrains Mono (Code/Metadata), Inter (Body Prose).

    Climate Consideration: Avoid heavy backdrop-blur or complex CSS gradients to ensure performance in high-humidity/high-heat mobile browsing scenarios.

## 5. AI Agent Workflow Protocol

Agents must follow this state machine for every task:

    PLAN (Nemotron 3 Super): Analyze architecture.md and this file. Output a task list.

    TEST (Big Pickle): Generate failing Vitest files in @portfolio/src/lib/.

    BUILD (MiniMax M2.5): Implement logic/UI until tests pass. Strictly declarative code.

    REVIEW (Nemotron 3 Super): Audit for any types, accessibility (WCAG AA), and Svelte 5 syntax correctness.

## 6. Success Metrics

Lighthouse: 100/100/100/100 on desktop.

Bundle Size: < 15kb initial JS payload (excluding Svelte runtime).

Stability: Zero hydration mismatches on Cloudflare Workers (workerd).

## Instructions for the Agent

    DO NOT deviate from the Svelte 5 Runes pattern. DO NOT use imperative addEventListener calls. DO NOT implement the UI before the Vitest suite is verified as "Failing."
