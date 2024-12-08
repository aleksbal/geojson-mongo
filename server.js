const express = require('express');
const { MongoClient } = require('mongodb');

const app = express();
const PORT = 3000;
const MONGO_URI = 'mongodb://localhost:27017';
const DATABASE_NAME = 'geo_database';

app.use(express.json());

// Endpoint to search for a feature by name
app.get('/api/search', async (req, res) => {
  const nameQuery = req.query.name;
  if (!nameQuery) {
    return res.status(400).send('Query parameter "name" is required.');
  }

  try {
    const client = new MongoClient(MONGO_URI);
    await client.connect();
    const db = client.db(DATABASE_NAME);
    const collectionNames = await db.listCollections().toArray();

    const results = [];

    // Search across all collections
    for (const { name: collectionName } of collectionNames) {
      const data = await db
        .collection(collectionName)
        .find({ 'properties.NAME': { $regex: nameQuery, $options: 'i' } }) // Case-insensitive search
        .toArray();
      results.push(...data);
    }

    res.json(results);
    await client.close();
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.listen(PORT, () => {
  console.log(`API server is running on http://localhost:${PORT}`);
});