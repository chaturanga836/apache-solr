#!/bin/bash
set -e

ZK_HOST="zookeeper:2181"
COLLECTION="ranger_audits"
CONFIG_NAME="ranger_audits"
CONFIG_DIR="/opt/solr-config/ranger_audits"

echo "Waiting for Solr to be ready..."
until curl -s http://localhost:8983/solr/admin/info/system >/dev/null; do
  sleep 2
done

echo "Solr is up."

# Upload configset if missing
if ! solr zk ls /configs -z "$ZK_HOST" | grep -q "$CONFIG_NAME"; then
  echo "Uploading configset $CONFIG_NAME to Zookeeper..."
  solr zk upconfig -z "$ZK_HOST" \
    -n "$CONFIG_NAME" \
    -d "$CONFIG_DIR"
else
  echo "Configset $CONFIG_NAME already exists."
fi

# Create collection if missing
if ! curl -s "http://localhost:8983/solr/admin/collections?action=LIST" | grep -q "$COLLECTION"; then
  echo "Creating collection $COLLECTION..."
  solr create_collection \
    -c "$COLLECTION" \
    -n "$CONFIG_NAME" \
    -shards 1 \
    -replicationFactor 1
else
  echo "Collection $COLLECTION already exists."
fi

echo "Solr init complete."
