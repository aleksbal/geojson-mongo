# gejson-mongo

Docker image with MongoDB as data repository, and Node.js as API server. On startup, it loads several preconfigured GeoJSON files into repository and serves data requests via API.

## GeoJSON Resources
- Historical landmarks: https://catalog.data.gov/dataset/historic-landmarks-73030/resource/dd17654e-a940-475a-aa1c-4b1534eec54b

## How to build and test

Create Docker image
docker build --no-cache --network=host -t geojson-mongodb .

Start Docker container
docker run -d -p 27020:27017 -p 3020:3000 --name geojson-mongodb geojson-mongodb

Execute something like this (curl or Insomnia):
http://127.0.0.1:3020/api/search?name=berlin