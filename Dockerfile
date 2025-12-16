FROM solr:9.6.1

USER root

# Optional: install python if needed
RUN apt-get update && \
    apt-get install -y python3 && \
    rm -rf /var/lib/apt/lists/*

# Copy helper scripts
COPY scripts/generate-security.py /opt/solr-tools/generate-security.py
COPY scripts/init-security.sh /opt/solr-tools/init-security.sh
RUN chmod +x /opt/solr-tools/init-security.sh

# --- Fix ownership of /var/solr ---
RUN mkdir -p /var/solr && chown -R solr:solr /var/solr

USER solr
EXPOSE 8983
