# Use the official PostgreSQL image from the Docker Hub
FROM postgres:16.3

# Set environment variables
ENV POSTGRES_USER=replica
ENV POSTGRES_PASSWORD=12345
ENV POSTGRES_DB=primary_db

# Copy the init.sql file to the Docker image
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the PostgreSQL port
EXPOSE 5432
