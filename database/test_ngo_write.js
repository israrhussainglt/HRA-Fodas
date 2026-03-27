const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;
const ngoCollectionId = 'ngo_requests';

async function testNgoWrite() {
    try {
        console.log('📝 Testing write to ngo_requests...');

        // Create a dummy request
        const promise = databases.createDocument(
            databaseId,
            ngoCollectionId,
            sdk.ID.unique(),
            {
                'recipient_id': 'test_script',
                'ngo_name': 'Test Script',
                'title': 'Connection Test',
                'description': 'Testing database write access',
                'food_category': 'other',
                'quantity': 1.0,
                'unit': 'unit',
                'status': 'pending',
                'created_at': new Date().toISOString(),
                'updated_at': new Date().toISOString(),
            }
        );

        const response = await promise;
        console.log('✅ Write SUCCESS! Document ID:', response.$id);

        // Cleanup
        await databases.deleteDocument(databaseId, ngoCollectionId, response.$id);
        console.log('✅ Delete SUCCESS!');

    } catch (error) {
        console.error('❌ Write FAILED:', error);
    }
}

testNgoWrite();
