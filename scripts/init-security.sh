#!/bin/bash
set -e

echo ">>> Initializing Solr security (idempotent)"

SECURITY_FILE="/var/solr/data/security.json"
SCRIPT_PATH="/opt/solr-tools/generate-security.py"

# Generate security.json using Python script
python3 "$SCRIPT_PATH"

# Check if generated security.json exists in the same folder as the script
if [ -f "/opt/solr-tools/security.json" ]; then
    # Only move if it doesn't exist already, or overwrite if different
    if [ ! -f "$SECURITY_FILE" ] || ! cmp -s "/opt/solr-tools/security.json" "$SECURITY_FILE"; then
        mv "/opt/solr-tools/security.json" "$SECURITY_FILE"
        echo "✅ security.json moved to $SECURITY_FILE"
        chown solr:solr "$SECURITY_FILE"
    else
        echo "ℹ️ security.json already up-to-date, skipping move"
    fi
else
    echo "⚠️ Warning: security.json not found after generation!"
fi
