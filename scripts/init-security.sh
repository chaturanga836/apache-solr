#!/bin/bash
set -e

echo ">>> Running security initialization"

# Run Python script to generate security.json
python3 /docker-entrypoint-initdb.d/generate-security.py

# Move generated file into Solr data directory if it exists
if [ -f /docker-entrypoint-initdb.d/security.json ]; then
  mv /docker-entrypoint-initdb.d/security.json /var/solr/data/security.json
  echo "security.json moved to /var/solr/data/"
else
  echo "Warning: security.json not found!"
fi
