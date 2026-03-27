const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;

async function checkConnectivity() {
    try {
        console.log('📡 Checking Appwrite connectivity...');
        const result = await databases.listCollections(databaseId);
        console.log(`✅ Connected! Found ${result.total} collections.`);
        const inventory = result.collections.find(c => c.$id === 'inventory');
        if (inventory) {
            console.log('📦 Inventory collection found:', inventory.name);
            console.log('🔒 Current permissions:', inventory.$permissions);
        } else {
            console.log('❌ Inventory collection NOT found.');
        }
    } catch (error) {
        console.error('❌ Connection failed:', error.message);
    }
}

checkConnectivity();
