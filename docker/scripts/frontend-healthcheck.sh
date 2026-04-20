#!/bin/sh
# =============================================================================
# frontend-healthcheck.sh
# Checks the health of the Next.js Frontend service.
# =============================================================================

# Read port from environment variable, default to 3000
PORT="${PORT:-3000}"

# Query the root endpoint '/' of the Next.js container.
# -q: Quiet mode
# -O -: Output fetched page to stdout (redirected to /dev/null)
# -T 5: 5-second timeout
if wget -q -T 5 -O - "http://localhost:${PORT}/" > /dev/null; then
    echo "Frontend is healthy."
    exit 0
else
    echo "Frontend health check failed."
    exit 1
fi
