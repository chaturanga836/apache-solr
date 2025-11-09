# Start from the official Solr base image
FROM solr:9.6.1

# Copy initialization script into Solr's init directory
# Make sure the script is already executable before build (chmod +x locally)
COPY scripts/generate-security.py /docker-entrypoint-initdb.d/
COPY scripts/init-security.sh /docker-entrypoint-initdb.d/
COPY .env /docker-entrypoint-initdb.d/.env

# Expose Solr's default port
EXPOSE 8983

# Default entrypoint provided by Solr image
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["solr-foreground"]
