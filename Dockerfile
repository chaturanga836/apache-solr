FROM solr:9.6.1

USER root

# Optional: install python ONLY if you truly need it
RUN apt-get update && \
    apt-get install -y python3 && \
    rm -rf /var/lib/apt/lists/*

# Copy security helper (NOT auto-executed)
COPY scripts/generate-security.py /opt/solr-tools/generate-security.py
COPY scripts/init-security.sh /opt/solr-tools/init-security.sh
RUN chmod +x /opt/solr-tools/init-security.sh

USER solr
EXPOSE 8983
