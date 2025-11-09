#!/bin/bash
set -e

# Load .env file if it exists
if [ -f "/solr-init/.env" ]; then
  export $(grep -v '^#' /solr-init/.env | xargs)
fi

SOLR_USER=${SOLR_USER:-solr}
SOLR_PASS=${SOLR_PASS:-SolrRocks}
SOLR_HOME="/var/solr"
SECURITY_FILE="$SOLR_HOME/security.json"

echo "Using SOLR_USER=$SOLR_USER"

# Wait until Solr is up
until curl -s "http://localhost:8983/solr/admin/info/system" > /dev/null; do
  echo "Waiting for Solr to start..."
  sleep 3
done

# Enable BasicAuth if not already enabled
if [ ! -f "$SECURITY_FILE" ]; then
    echo "Generating Solr security.json with BasicAuth..."
    solr auth enable \
        -type basicAuth \
        -credentials "$SOLR_USER:$SOLR_PASS" \
        -blockUnknown true
    echo "✅ security.json created at $SECURITY_FILE"
else
    echo "security.json already exists, skipping..."
fi

# Don't start Solr here; the main container already runs it
