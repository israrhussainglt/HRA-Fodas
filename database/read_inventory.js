const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;

async function readInventory() {
    try {
        console.log('📖 Attempting to read inventory...');
        const result = await databases.listDocuments(
            databaseId,
            'inventory',
            [sdk.Query.limit(5)]
        );
        console.log(`✅ Success! Read ${result.total} items.`);
        console.log('Sample item:', result.documents[0]);
    } catch (error) {
        console.error('❌ Read failed:', error.message);
    }
}

readInventory();
