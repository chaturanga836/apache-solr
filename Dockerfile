FROM solr:9.6.1

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/ /opt/solr-tools/
RUN chmod +x /opt/solr-tools/*.sh

COPY solr-config/ranger_audits/conf/ /opt/solr-config/ranger_audits/conf/

USER solr
EXPOSE 8983

CMD ["bash", "-c", "solr-foreground -c & /opt/solr-tools/init-solr.sh && fg"]
