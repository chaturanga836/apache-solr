FROM solr:9.6.1

USER root

# Optional: install python if your security scripts require it
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 && \
    rm -rf /var/lib/apt/lists/*

# Copy helper / security scripts
COPY scripts/ /opt/solr-tools/
RUN chmod +x /opt/solr-tools/*.sh

# DO NOT chown /var/solr
# Docker named volume will handle ownership correctly

USER solr
EXPOSE 8983
