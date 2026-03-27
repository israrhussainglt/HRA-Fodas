const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;
const newCollectionId = 'inventory_fixed';

async function createNewInventoryCollection() {
    try {
        console.log('🔨 Creating new inventory collection...');

        // 1. Create Collection
        try {
            await databases.createCollection(
                databaseId,
                newCollectionId,
                'Inventory Fixed',
                [
                    sdk.Permission.read(sdk.Role.any()),
                    sdk.Permission.create(sdk.Role.users()),
                    sdk.Permission.update(sdk.Role.users()),
                    sdk.Permission.delete(sdk.Role.users()),
                ],
                true // documentSecurity
            );
            console.log('✅ Collection created');
        } catch (e) {
            if (e.code === 409) {
                console.log('⚠️ Collection already exists, proceeding to update attributes...');
            } else {
                throw e;
            }
        }

        // 2. Create Attributes
        const attributes = [
            { key: 'organization_id', type: 'string', size: 255, required: true },
            { key: 'donation_id', type: 'string', size: 255, required: false },
            { key: 'item_name', type: 'string', size: 255, required: true },
            { key: 'food_category', type: 'string', size: 255, required: true },
            { key: 'quantity', type: 'double', required: true },
            { key: 'unit', type: 'string', size: 50, required: true },
            { key: 'expiration_date', type: 'datetime', required: true },
            { key: 'received_date', type: 'datetime', required: true },
            { key: 'notes', type: 'string', size: 1000, required: false },
            { key: 'created_at', type: 'datetime', required: false },
            { key: 'updated_at', type: 'datetime', required: false },
        ];

        for (const attr of attributes) {
            try {
                if (attr.type === 'string') {
                    await databases.createStringAttribute(databaseId, newCollectionId, attr.key, attr.size, attr.required);
                } else if (attr.type === 'double') {
                    await databases.createFloatAttribute(databaseId, newCollectionId, attr.key, attr.required);
                } else if (attr.type === 'datetime') {
                    await databases.createDatetimeAttribute(databaseId, newCollectionId, attr.key, attr.required);
                }
                console.log(`   + Attribute '${attr.key}' created`);
                // Small delay to prevent rate limits
                await new Promise(r => setTimeout(r, 200));
            } catch (e) {
                if (e.code === 409) {
                    console.log(`   = Attribute '${attr.key}' already exists`);
                } else {
                    console.error(`   x Failed to create attribute '${attr.key}':`, e.message);
                }
            }
        }

        // 3. Create Indexes
        try {
            await databases.createIndex(databaseId, newCollectionId, 'idx_org_id', 'key', ['organization_id'], ['ASC']);
            console.log('   + Index idx_org_id created');
        } catch (e) {
            if (e.code !== 409) console.error('   x Failed to create index:', e.message);
        }

        console.log('\n✅ New inventory collection ready!');
        console.log(`🆔 Collection ID: ${newCollectionId}`);

    } catch (error) {
        console.error('❌ Failed:', error);
    }
}

createNewInventoryCollection();
