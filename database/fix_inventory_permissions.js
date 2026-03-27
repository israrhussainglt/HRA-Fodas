const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;
const inventoryCollectionId = 'inventory';

async function fixInventoryPermissions() {
    try {
        console.log('🔧 Fixing inventory collection permissions...');
        console.log(`Database ID: ${databaseId}`);
        console.log(`Collection ID: ${inventoryCollectionId}`);

        // Update collection permissions
        const response = await databases.updateCollection(
            databaseId,
            inventoryCollectionId,
            inventoryCollectionId, // name
            [
                // Allow any authenticated user to read inventory items
                sdk.Permission.read(sdk.Role.users()),

                // Allow recipients to create their own inventory items
                sdk.Permission.create(sdk.Role.users()),

                // Allow users to update their own inventory items (by organization_id)
                sdk.Permission.update(sdk.Role.users()),

                // Allow users to delete their own inventory items
                sdk.Permission.delete(sdk.Role.users()),
            ],
            true, // documentSecurity - enable for row-level permissions
            true  // enabled
        );

        console.log('✅ Inventory collection permissions updated successfully!');
        console.log('\nNew permissions:');
        console.log('- Read: Any authenticated user');
        console.log('- Create: Any authenticated user');
        console.log('- Update: Any authenticated user');
        console.log('- Delete: Any authenticated user');
        console.log('\nNote: Consider adding attribute-level permissions for organization_id to restrict access to own items only.');

    } catch (error) {
        console.error('❌ Error fixing permissions:', error.message);
        if (error.response) {
            console.error('Response:', error.response);
        }
        process.exit(1);
    }
}

fixInventoryPermissions();
