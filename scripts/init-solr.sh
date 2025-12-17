#!/bin/bash
set -e

CONFIG_NAME="ranger_audits"
CONF_DIR="/opt/solr-config/ranger_audits/conf"
COLLECTION_NAME="ranger_audits"
SHARDS=1
REPLICATION=1
ZK_HOST="zookeeper:2181"

# Wait until Solr is ready
echo "Waiting for Solr to be ready..."
until curl -s "http://localhost:8983/solr/admin/cores?action=STATUS" >/dev/null; do
  sleep 3
done

# Upload config to ZooKeeper
if ! solr zk ls -z $ZK_HOST | grep -q $CONFIG_NAME; then
  echo "Uploading Ranger config to ZooKeeper..."
  solr zk upconfig -n $CONFIG_NAME -d $CONF_DIR -z $ZK_HOST
else
  echo "Config $CONFIG_NAME already exists in ZK."
fi

# Create collection if it does not exist
if ! curl -s "http://localhost:8983/solr/admin/collections?action=LIST" | grep -q $COLLECTION_NAME; then
  echo "Creating Solr collection $COLLECTION_NAME..."
  solr create -c $COLLECTION_NAME -d $CONFIG_NAME -shards $SHARDS -replicationFactor $REPLICATION -z $ZK_HOST
else
  echo "Collection $COLLECTION_NAME already exists."
fi

echo "SolrCloud is ready with Ranger Audit collection."
