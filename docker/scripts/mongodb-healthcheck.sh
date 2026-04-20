#!/bin/sh
# =============================================================================
# mongodb-healthcheck.sh
# Checks the health of the MongoDB container using mongosh.
# =============================================================================

# Read root credentials if available, otherwise use defaults
MONGO_USER="${MONGO_INITDB_ROOT_USERNAME:-admin}"
MONGO_PASS="${MONGO_INITDB_ROOT_PASSWORD:-admin_password}"

# Execute mongosh to ping the admin database and verify authentication.
# --quiet: Suppress shell startup logs
# --eval: Run the ping command
if mongosh --quiet \
     --username "$MONGO_USER" \
     --password "$MONGO_PASS" \
     --authenticationDatabase "admin" \
     --eval "db.adminCommand('ping').ok" | grep -q "1"; then
    echo "MongoDB is healthy."
    exit 0
else
    echo "MongoDB health check failed."
    exit 1
fi
