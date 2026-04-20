#!/bin/sh
# =============================================================================
# ai-healthcheck.sh
# Checks the health of the FastAPI AI service using Python's built-in urllib.
# =============================================================================

PORT="${PORT:-8000}"

# Run inline Python script to query the /health endpoint.
# This approach avoids depending on curl/wget, which may not be present in slim images.
python3 -c "
import urllib.request
import json
import sys

try:
    response = urllib.request.urlopen('http://localhost:${PORT}/health', timeout=5)
    data = json.loads(response.read().decode())
    if data.get('status') == 'healthy':
        print('AI Service is healthy.')
        sys.exit(0)
    else:
        print(f'AI Service returned status: {data.get(\"status\")}')
        sys.exit(1)
except Exception as e:
    print(f'Health check query failed: {e}')
    sys.exit(1)
"
