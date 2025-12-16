#!/bin/bash
set -e

echo ">>> Initializing Solr security (idempotent)"

python3 /opt/solr-tools/generate-security.py
