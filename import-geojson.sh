#!/bin/bash

MONGO_HOST=localhost
MONGO_PORT=27017
DB_NAME=geo_database
COLLECTION_NAME_PREFIX=geojson_

echo "Waiting for MongoDB to start..."
sleep 5

for file in /app/data/*.geojson; do
  if [ -f "$file" ]; then
    collection_name="${COLLECTION_NAME_PREFIX}$(basename "$file" .geojson)"
    echo "Processing $file for collection $collection_name..."

    # Extract the features array from the FeatureCollection
    jq '.features' "$file" > "$file.features"

    # Check if the features array was successfully extracted
    if [ $? -eq 0 ]; then
      echo "Importing features from $file into $DB_NAME.$collection_name..."
      mongoimport --host "$MONGO_HOST" --port "$MONGO_PORT" \
        --db "$DB_NAME" --collection "$collection_name" \
        --file "$file.features" --jsonArray
      echo "Import of $file complete."
    else
      echo "Failed to extract features from $file. Skipping."
    fi

    # Clean up temporary file
    rm -f "$file.features"
  else
    echo "No GeoJSON files found in /app/data/"
  fi
done

echo "GeoJSON import complete."
