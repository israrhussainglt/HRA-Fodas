const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;

async function checkInventoryV2() {
    try {
        console.log('🔎 Checking inventory_v2 collection...');

        // Check if it exists
        try {
            const collection = await databases.getCollection(databaseId, 'inventory_v2');
            console.log('✅ Found inventory_v2');
            console.log('🔒 Permissions:', collection.$permissions);

            // Check create permission
            const canCreate = collection.$permissions.some(p => p.includes('create("users")') || p.includes('create("any")'));
            console.log('📝 Can Authenticated Users Create?', canCreate ? 'YES' : 'NO');

            if (!canCreate) {
                console.log('⚠️ Attempting to fix permissions on inventory_v2...');
                try {
                    await databases.updateCollection(
                        databaseId,
                        'inventory_v2',
                        collection.name,
                        [
                            sdk.Permission.read(sdk.Role.any()),
                            sdk.Permission.create(sdk.Role.users()),
                            sdk.Permission.update(sdk.Role.users()),
                            sdk.Permission.delete(sdk.Role.users()),
                        ],
                        true
                    );
                    console.log('✅ Permissions fixed for inventory_v2!');
                } catch (e) {
                    console.error('❌ Failed to fix inventory_v2 permissions:', e.message);
                }
            }

        } catch (e) {
            console.error('❌ inventory_v2 not found:', e.message);
        }

    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

checkInventoryV2();
