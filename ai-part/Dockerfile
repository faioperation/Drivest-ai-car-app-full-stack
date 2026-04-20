# =============================================================================
# STAGE 1 — builder
# Install Python dependencies using a full image with build tools.
# Packages like numpy, scikit-learn, and pandas need gcc to compile their
# C extensions. We do this in a separate stage to keep the final image clean.
# =============================================================================
FROM python:3.11-slim AS builder

WORKDIR /build

# Install build dependencies needed by numpy / scikit-learn / pandas
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file first to leverage layer caching.
# If requirements.txt has not changed, this layer is served from cache.
COPY requirements.txt .

# Upgrade pip and install all packages into an isolated prefix directory.
# --prefix=/install lets us copy exactly these packages into the final image.
# --no-cache-dir keeps the builder layer small.
RUN pip install --upgrade pip \
 && pip install --no-cache-dir --prefix=/install -r requirements.txt


# =============================================================================
# STAGE 2 — runner
# Lean production image with Chromium pre-installed for Selenium scraping.
#
# Why Chromium and not full Chrome?
#   The scraper uses `webdriver-manager` which auto-downloads the matching
#   ChromeDriver binary at runtime. However, in a Docker environment with no
#   internet access at runtime, we pin the system Chromium + chromedriver and
#   tell webdriver-manager to use the pre-installed driver via env vars.
#   This is the standard pattern for Selenium in Docker containers.
# =============================================================================
FROM python:3.11-slim AS runner

# ─── Install Chromium + ChromeDriver + runtime libs ──────────────────────────
# Chromium is used by Selenium via the autoscout24_working_scraper.py scraper.
# The scraper calls ChromeDriverManager().install() → we pre-install the driver
# and override with WDM_* env vars so it uses the system binary.
# fonts-liberation and libglib2.0-0 are required by Chromium in headless mode.
RUN apt-get update && apt-get install -y --no-install-recommends \
        chromium \
        chromium-driver \
        fonts-liberation \
        libglib2.0-0 \
        libnss3 \
        libgconf-2-4 \
        libfontconfig1 \
        libxss1 \
        wget \
    && rm -rf /var/lib/apt/lists/*

# ─── Create non-root user ────────────────────────────────────────────────────
RUN addgroup --system drivest && adduser --system --ingroup drivest drivest

# ─── Working directory ───────────────────────────────────────────────────────
# This must match the import paths in main.py:
#   from scrapers.automator import run_automation  → scrapers/ at WORKDIR root
#   from app.routes import router                  → app/ at WORKDIR root
WORKDIR /app

# ─── Copy installed Python packages from the builder stage ───────────────────
COPY --from=builder /install /usr/local

# ─── Copy application source code ────────────────────────────────────────────
# Copy only the directories that are actually imported / needed at runtime.
COPY app/        ./app/
COPY scrapers/   ./scrapers/
COPY scripts/    ./scripts/

# ─── Create runtime directories ──────────────────────────────────────────────
# logs/         → application log output
# data/raw/     → where the data converter writes cars_data.json (automator.py line 108)
# data/ml_models/ → where joblib ML model is stored (ai_calculations.py line 36)
RUN mkdir -p logs data/raw data/ml_models \
 && chown -R drivest:drivest /app

# ─── Drop privileges ─────────────────────────────────────────────────────────
USER drivest

# ─── Environment configuration ───────────────────────────────────────────────
ENV \
    # Python optimizations
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    # Tell webdriver-manager to use the pre-installed system chromedriver.
    # This avoids downloading a new binary at runtime (no internet needed).
    WDM_LOCAL=1 \
    WDM_CACHE_PATH=/tmp/webdriver_cache \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver \
    CHROME_BIN=/usr/bin/chromium \
    # Extra Chromium flags required for running headless in a container
    # (no sandbox because we're already inside Docker's namespace,
    #  no /dev/shm because Docker default shared memory is only 64MB)
    CHROMIUM_FLAGS="--no-sandbox --disable-dev-shm-usage --disable-gpu" \
    # FastAPI application port
    PORT=8000

# ─── Expose port ─────────────────────────────────────────────────────────────
EXPOSE 8000

# ─── Health check ────────────────────────────────────────────────────────────
# The FastAPI app has a real /health endpoint in app/main.py (lines 53-58)
# that returns {"status": "healthy", ...}
# Using Python's built-in urllib to avoid installing curl/wget separately.
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

# ─── Start command ───────────────────────────────────────────────────────────
# Entry point: app/main.py  →  FastAPI app object named `app`
# --host 0.0.0.0  → listen on all interfaces (required inside Docker)
# --workers 1     → single worker (Selenium is not thread-safe; one instance at a time)
# Do NOT use --reload in production
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
