# =============================================================================
# STAGE 1 — deps
# Install ALL dependencies (including devDependencies) because Tailwind CSS,
# ESLint, and the Next.js build pipeline are devDependencies needed at build time.
# =============================================================================
FROM node:20-alpine AS deps

WORKDIR /app

# Copy manifests first — cached layer, only re-runs if lockfile changes
COPY package.json package-lock.json ./

# Install all dependencies (dev + prod) for the build stage
RUN npm ci


# =============================================================================
# STAGE 2 — builder
# Run `next build` to produce the optimised production bundle.
# With `output: 'standalone'` in next.config.mjs, Next.js produces a
# self-contained server in .next/standalone/ — no node_modules needed at runtime.
# =============================================================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copy all node_modules from the deps stage
COPY --from=deps /app/node_modules ./node_modules

# Copy all frontend source files
COPY . .

# Disable Next.js telemetry during CI/build
ENV NEXT_TELEMETRY_DISABLED=1 \
    NODE_ENV=production

# Build the Next.js application.
# --turbopack matches the actual "build" script in package.json:
#   "build": "next build --turbopack"
# The output will be in .next/standalone/ (requires output:'standalone' in next.config.mjs)
RUN npm run build


# =============================================================================
# STAGE 3 — runner
# Final minimal image — only the standalone server output.
# No node_modules directory needed thanks to standalone mode.
# Final image is typically 100–150MB instead of 1GB+.
# =============================================================================
FROM node:20-alpine AS runner

WORKDIR /app

# ─── Non-root user ───────────────────────────────────────────────────────────
RUN addgroup -S drivest && adduser -S drivest -G drivest

# ─── Runtime environment ─────────────────────────────────────────────────────
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3000 \
    HOSTNAME=0.0.0.0

# ─── Copy build output from builder ──────────────────────────────────────────

# Static public assets (images, icons, fonts etc.)
COPY --from=builder /app/public ./public

# The standalone server — a fully self-contained Node.js server
COPY --from=builder --chown=drivest:drivest /app/.next/standalone ./

# Static Next.js build output (JS chunks, CSS, source maps)
# Must sit at .next/static relative to the standalone server
COPY --from=builder --chown=drivest:drivest /app/.next/static ./.next/static

# ─── Drop privileges ─────────────────────────────────────────────────────────
USER drivest

# ─── Expose port ─────────────────────────────────────────────────────────────
EXPOSE 3000

# ─── Health check ────────────────────────────────────────────────────────────
# Next.js responds at "/" once the server is ready.
# --start-period=60s gives Next.js time to initialise before counting failures.
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1

# ─── Start command ───────────────────────────────────────────────────────────
# standalone output generates server.js at the root of .next/standalone/
# This is the correct entry point for the standalone Next.js server.
CMD ["node", "server.js"]
