FROM solr:9.6.1

# Copy the Python script
COPY scripts/generate-security.py /docker-entrypoint-initdb.d/

# Copy .env for environment variables (optional, you can also pass at runtime)
COPY .env /docker-entrypoint-initdb.d/.env

# Ensure the script is executable
RUN chmod +x /docker-entrypoint-initdb.d/generate-security.py

# Expose Solr port
EXPOSE 8983

# Start Solr (entrypoint is already set in base image)
CMD ["solr-foreground"]
