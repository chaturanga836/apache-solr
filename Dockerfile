FROM solr:9.6.1

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 curl && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/ /opt/solr-tools/
RUN chmod +x /opt/solr-tools/*.sh

USER solr
EXPOSE 8983
