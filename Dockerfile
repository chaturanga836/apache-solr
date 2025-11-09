# Start from the official Solr base image
FROM solr:9.6.1

USER root
RUN apt-get update && apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*
# Copy initialization script into Solr's init directory
# Make sure the script is already executable before build (chmod +x locally)
COPY scripts/generate-security.py /docker-entrypoint-initdb.d/
COPY scripts/init-security.sh /docker-entrypoint-initdb.d/
COPY .env /docker-entrypoint-initdb.d/.env

# Ensure init-security.sh is executable
RUN chmod +x /docker-entrypoint-initdb.d/init-security.sh

# Expose Solr port
EXPOSE 8983

# Switch back to Solr user
USER solr
# Default entrypoint provided by Solr image
# ENTRYPOINT ["docker-entrypoint.sh"]
# CMD ["solr-foreground"]
