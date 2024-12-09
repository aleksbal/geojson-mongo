# Start with MongoDB base image
FROM mongo:8.0

# Set Node.js version
ENV NODE_VERSION=20.18.1

# Download and install Node.js from the official tarball
RUN apt-get update && \
    apt-get install -y jq && \
    apt-get install -y curl wget && \
    curl -fsSL "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz" | tar -xz -C /usr/local --strip-components=1 && \
    apt-get clean

# Set the working directory for the application
WORKDIR /app

# Copy application files
COPY ./package.json /app/
COPY ./server.js /app/
COPY ./geojson-files/*.geojson /app/data/
COPY ./import-geojson.sh /app/

# Install Node.js dependencies

RUN npm install

# Ensure the import script is executable
RUN chmod +x /app/import-geojson.sh

# Expose ports for MongoDB (27017) and the API (3000)
EXPOSE 27017 3000

# Start MongoDB and the API server
CMD ["bash", "-c", "mongod --dbpath /data/db --fork --logpath /var/log/mongodb.log && bash /app/import-geojson.sh && node /app/server.js"]