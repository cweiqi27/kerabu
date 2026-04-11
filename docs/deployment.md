# Deployment Specification

## Production (Cloudflare Pages)

- **Build Command:** `bun run nx build portfolio`
- **Output Directory:** `apps/portfolio/dist`
- **Configuration:** Managed via `apps/portfolio/wrangler.toml`.
- **Environment:** Node.js 20+ (compatibility mode) with Bun for local building.

## Staging (Local Homelab)

- **Strategy:** Build OCI image via `nx-container`.
- **Hosting:** Deploy to single-node k3s cluster on Debian 13.
- **Network:** Isolated via Tailscale.
