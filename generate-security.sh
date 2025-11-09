#!/bin/bash
set -e

SOLR_USER=${SOLR_USER:-solr}
SOLR_PASS=${SOLR_PASS:-SolrRocks}
SOLR_HOME="/var/solr/data"
SECURITY_FILE="$SOLR_HOME/security.json"

# Wait until Solr is up
until curl -s "http://localhost:8983/solr/admin/info/system" > /dev/null; do
  echo "Waiting for Solr to start..."
  sleep 3
done

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

# Start Solr in foreground
exec solr start -f

