const { Client, Databases, ID, Permission, Role } = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);
const databaseId = 'hra_fodas_main';
const collectionId = 'trust_scores';

async function createTrustScoresTable() {
  try {
    console.log('Creating trust_scores collection...');

    // Check if collection exists
    try {
      await databases.getCollection(databaseId, collectionId);
      console.log('⚠️  Collection already exists: trust_scores');
      console.log('Skipping creation. If you want to recreate it, delete it from Appwrite Console first.');
      return;
    } catch (error) {
      if (error.code !== 404) {
        throw error;
      }
    }

    // Create the collection
    await databases.createCollection(
      databaseId,
      collectionId,
      'trust_scores',
      [Permission.read(Role.any())]
    );

    console.log('✓ Collection created');

    // Create attributes
    const attributes = [
      { key: 'user_id', type: 'string', size: 36, required: true },
      { key: 'trust_score', type: 'integer', required: false, default: 50 },
      { key: 'reliability_score', type: 'integer', required: false, default: 50 },
      { key: 'total_interactions', type: 'integer', required: false, default: 0 },
      { key: 'positive_feedback_count', type: 'integer', required: false, default: 0 },
      { key: 'negative_feedback_count', type: 'integer', required: false, default: 0 },
      { key: 'completed_donations', type: 'integer', required: false, default: 0 },
      { key: 'completed_deliveries', type: 'integer', required: false, default: 0 },
      { key: 'cancelled_count', type: 'integer', required: false, default: 0 },
      { key: 'last_calculated', type: 'datetime', required: false }
    ];

    for (const attr of attributes) {
      console.log(`Creating attribute: ${attr.key}`);
      
      if (attr.type === 'string') {
        await databases.createStringAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.size,
          attr.required,
          attr.default,
          false // array
        );
      } else if (attr.type === 'integer') {
        await databases.createIntegerAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.required,
          undefined, // min
          undefined, // max
          attr.default,
          false // array
        );
      } else if (attr.type === 'datetime') {
        await databases.createDatetimeAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.required,
          attr.default,
          false // array
        );
      }

      // Wait a bit between attribute creations
      await new Promise(resolve => setTimeout(resolve, 1000));
    }

    console.log('✓ All attributes created');

    // Create unique index on user_id
    console.log('Creating index on user_id...');
    await databases.createIndex(
      databaseId,
      collectionId,
      'user_idx',
      'unique',
      ['user_id']
    );

    console.log('✓ Index created');
    console.log('\n✅ Trust scores table created successfully!');

  } catch (error) {
    console.error('❌ Error creating trust_scores table:', error.message);
    if (error.type) {
      console.error('Error type:', error.type);
    }
    if (error.code) {
      console.error('Error code:', error.code);
    }
    process.exit(1);
  }
}

createTrustScoresTable();
