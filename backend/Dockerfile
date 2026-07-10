# =============================================================================
# STAGE 1 — deps
# Install ONLY production dependencies with a locked lockfile.
# This layer is cached independently so a code change doesn't re-run npm ci.
# =============================================================================
FROM node:20-alpine AS deps

# Set working directory
WORKDIR /app

RUN apk add --no-cache wget

# Copy dependency manifests first (cache-friendly)
COPY package.json package-lock.json ./

# Install production dependencies only, using the exact lockfile
# --omit=dev  → skip devDependencies (nodemon is not needed in production)
# --ignore-scripts → skip lifecycle scripts that might need build tools
RUN npm install --omit=dev --no-audit --no-fund


# =============================================================================
# STAGE 2 — runner
# Final lean image — only the app code + production node_modules.
# =============================================================================
FROM node:20-alpine AS runner

# ─── System hardening ────────────────────────────────────────────────────────
# Add a non-root user+group called "drivest" for security.
# -S = system user  -G = group
RUN addgroup -S drivest && adduser -S drivest -G drivest

# ─── Working directory ───────────────────────────────────────────────────────
WORKDIR /app

# ─── Copy installed dependencies from the deps stage ─────────────────────────
COPY --from=deps /app/node_modules ./node_modules

# ─── Copy application source code ────────────────────────────────────────────
# We copy package.json again so Node can resolve "type":"module" (ESM flag)
COPY package.json ./
COPY src/ ./src/

# ─── Create runtime directories with correct ownership ───────────────────────
# The backend writes logs and (optionally) temporary upload files.
# Cloudinary handles final image storage, but multer stages files locally first.
RUN mkdir -p logs uploads && chown -R drivest:drivest /app

# ─── Drop privileges ─────────────────────────────────────────────────────────
USER drivest

# ─── Runtime environment defaults ────────────────────────────────────────────
# NODE_ENV is set to production to disable dev-only Express behaviour.
# PORT is the value server.js reads: process.env.PORT || 5001
ENV NODE_ENV=production \
  PORT=5001

# ─── Expose the application port ─────────────────────────────────────────────
EXPOSE 5001

# ─── Health check ────────────────────────────────────────────────────────────
# The root GET "/" returns "Drivest Backend is Running..."
# --interval   : run every 30 s
# --timeout    : fail after 10 s of no response
# --start-period: give the app 40 s to start before counting failures
# --retries    : mark unhealthy after 3 consecutive failures
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:5001/ || exit 1

# ─── Start command ───────────────────────────────────────────────────────────
# package.json → "start": "node src/server.js"
# server.js uses top-level await, which requires Node ≥ 14.8 and "type":"module"
CMD ["node", "src/server.js"]
