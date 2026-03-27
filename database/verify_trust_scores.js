const { Client, Databases } = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);
const databaseId = 'hra_fodas_main';
const collectionId = 'trust_scores';

async function verifyTrustScoresTable() {
  try {
    console.log('Verifying trust_scores collection...\n');

    // Get collection details
    const collection = await databases.getCollection(databaseId, collectionId);
    console.log('✅ Collection found:', collection.name);
    console.log('   ID:', collection.$id);
    console.log('   Permissions:', collection.$permissions);

    // Get attributes
    const attributes = await databases.listAttributes(databaseId, collectionId);
    console.log('\n📝 Attributes:', attributes.total);
    attributes.attributes.forEach(attr => {
      console.log(`   - ${attr.key} (${attr.type})${attr.required ? ' [required]' : ''}`);
    });

    // Get indexes
    const indexes = await databases.listIndexes(databaseId, collectionId);
    console.log('\n🔍 Indexes:', indexes.total);
    indexes.indexes.forEach(index => {
      console.log(`   - ${index.key} (${index.type}) on [${index.attributes.join(', ')}]`);
    });

    console.log('\n✅ Trust scores table is properly configured!');

  } catch (error) {
    console.error('❌ Error verifying trust_scores table:', error.message);
    process.exit(1);
  }
}

verifyTrustScoresTable();
