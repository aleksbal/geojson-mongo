#!/bin/bash

# Set MongoDB details
MONGO_HOST=localhost
MONGO_PORT=27017
DB_NAME=geo_database
COLLECTION_NAME_PREFIX=geojson_

# Import each GeoJSON file
for file in /app/data/*.geojson; do
  collection_name="${COLLECTION_NAME_PREFIX}$(basename "$file" .geojson)"
  echo "Importing $file into $DB_NAME.$collection_name..."
  mongoimport --host "$MONGO_HOST" --port "$MONGO_PORT" --db "$DB_NAME" --collection "$collection_name" --file "$file" --jsonArray
done

echo "GeoJSON import complete."