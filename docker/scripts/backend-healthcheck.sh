#!/bin/sh
# =============================================================================
# backend-healthcheck.sh
# Checks the health of the Express backend service.
# =============================================================================

# Read port from environment variable, default to 5001
PORT="${PORT:-5001}"

# Query the root endpoint '/' of the Express backend.
# -q: Quiet mode
# -O -: Write document content to stdout (redirected to /dev/null)
# -T 5: 5-second timeout
if wget -q -T 5 -O - "http://localhost:${PORT}/" > /dev/null; then
    echo "Backend is healthy."
    exit 0
else
    echo "Backend health check failed."
    exit 1
fi
