/**
 * Upload Schema to Appwrite
 * 
 * This script reads the appwrite_schema.json file and creates/updates
 * the database schema in Appwrite.
 * 
 * IMPORTANT: This script will:
 * 1. Create the database if it doesn't exist
 * 2. Create collections that don't exist
 * 3. Create attributes that don't exist
 * 4. Create indexes that don't exist
 * 
 * It will NOT:
 * - Delete existing collections
 * - Delete existing attributes
 * - Modify existing attributes
 * - Delete existing indexes
 * 
 * For schema changes, use the specific migration scripts.
 */

const sdk = require('node-appwrite');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

// Read schema file
const schemaPath = path.join(__dirname, 'appwrite_schema.json');
const schema = JSON.parse(fs.readFileSync(schemaPath, 'utf8'));

async function uploadSchema() {
    console.log('🚀 Starting schema upload to Appwrite...\n');
    console.log(`📁 Database ID: ${schema.databaseId}\n`);

    try {
        // Step 1: Ensure database exists
        console.log('📝 Step 1: Checking database...');
        try {
            await databases.get(schema.databaseId);
            console.log('✅ Database exists\n');
        } catch (error) {
            if (error.code === 404) {
                console.log('⚠️  Database not found, creating...');
                await databases.create(
                    schema.databaseId,
                    'HRA FODAS Main Database'
                );
                console.log('✅ Database created\n');
            } else {
                throw error;
            }
        }

        // Step 2: Process each collection
        console.log('📝 Step 2: Processing collections...\n');
        
        for (const collection of schema.collections) {
            console.log(`\n📦 Processing collection: ${collection.name}`);
            console.log('─'.repeat(50));

            // Check if collection exists
            let collectionExists = false;
            try {
                await databases.getCollection(schema.databaseId, collection.id);
                collectionExists = true;
                console.log('✅ Collection exists');
            } catch (error) {
                if (error.code === 404) {
                    console.log('⚠️  Collection not found, creating...');
                    try {
                        await databases.createCollection(
                            schema.databaseId,
                            collection.id,
                            collection.name,
                            collection.permissions || []
                        );
                        console.log('✅ Collection created');
                    } catch (createError) {
                        console.error(`❌ Error creating collection: ${createError.message}`);
                        continue;
                    }
                } else {
                    throw error;
                }
            }

            // Wait a bit for collection to be ready
            if (!collectionExists) {
                await new Promise(resolve => setTimeout(resolve, 2000));
            }

            // Process attributes
            console.log(`\n  📋 Processing ${collection.attributes.length} attributes...`);
            for (const attr of collection.attributes) {
                try {
                    // Check if attribute exists
                    try {
                        await databases.getAttribute(schema.databaseId, collection.id, attr.key);
                        console.log(`  ✓ ${attr.key} (${attr.type}) - exists`);
                        continue;
                    } catch (error) {
                        if (error.code !== 404) throw error;
                    }

                    // Create attribute based on type
                    switch (attr.type) {
                        case 'string':
                            await databases.createStringAttribute(
                                schema.databaseId,
                                collection.id,
                                attr.key,
                                attr.size,
                                attr.required || false,
                                attr.default || null,
                                attr.array || false
                            );
                            break;

                        case 'integer':
                            await databases.createIntegerAttribute(
                                schema.databaseId,
                                collection.id,
                                attr.key,
                                attr.required || false,
                                attr.min || null,
                                attr.max || null,
                                attr.default || null,
                                attr.array || false
                            );
                            break;

                        case 'double':
                            await databases.createFloatAttribute(
                                schema.databaseId,
                                collection.id,
                                attr.key,
                                attr.required || false,
                                attr.min || null,
                                attr.max || null,
                                attr.default || null,
                                attr.array || false
                            );
                            break;

                        case 'boolean':
                            await databases.createBooleanAttribute(
                                schema.databaseId,
                                collection.id,
                                attr.key,
                                attr.required || false,
                                attr.default || null,
                                attr.array || false
                            );
                            break;

                        case 'datetime':
                            await databases.createDatetimeAttribute(
                                schema.databaseId,
                                collection.id,
                                attr.key,
                                attr.required || false,
                                attr.default || null,
                                attr.array || false
                            );
                            break;

                        case 'enum':
                            await databases.createEnumAttribute(
                                schema.databaseId,
                                collection.id,
                                attr.key,
                                attr.elements,
                                attr.required || false,
                                attr.default || null,
                                attr.array || false
                            );
                            break;

                        default:
                            console.log(`  ⚠️  Unknown attribute type: ${attr.type} for ${attr.key}`);
                            continue;
                    }

                    console.log(`  ✅ ${attr.key} (${attr.type}) - created`);

                    // Small delay between attribute creations
                    await new Promise(resolve => setTimeout(resolve, 500));

                } catch (error) {
                    if (error.code === 409) {
                        console.log(`  ✓ ${attr.key} (${attr.type}) - already exists`);
                    } else {
                        console.error(`  ❌ ${attr.key} (${attr.type}) - error: ${error.message}`);
                    }
                }
            }

            // Wait for attributes to be available
            console.log(`\n  ⏳ Waiting for attributes to be available...`);
            await new Promise(resolve => setTimeout(resolve, 3000));

            // Process indexes
            if (collection.indexes && collection.indexes.length > 0) {
                console.log(`\n  🔍 Processing ${collection.indexes.length} indexes...`);
                for (const index of collection.indexes) {
                    try {
                        // Check if index exists
                        try {
                            await databases.getIndex(schema.databaseId, collection.id, index.key);
                            console.log(`  ✓ ${index.key} - exists`);
                            continue;
                        } catch (error) {
                            if (error.code !== 404) throw error;
                        }

                        // Create index
                        await databases.createIndex(
                            schema.databaseId,
                            collection.id,
                            index.key,
                            index.type,
                            index.attributes,
                            index.orders || []
                        );

                        console.log(`  ✅ ${index.key} - created`);

                        // Small delay between index creations
                        await new Promise(resolve => setTimeout(resolve, 500));

                    } catch (error) {
                        if (error.code === 409) {
                            console.log(`  ✓ ${index.key} - already exists`);
                        } else {
                            console.error(`  ❌ ${index.key} - error: ${error.message}`);
                        }
                    }
                }
            }

            console.log(`\n✅ Completed collection: ${collection.name}`);
        }

        console.log('\n' + '='.repeat(50));
        console.log('✅ Schema upload completed successfully!');
        console.log('='.repeat(50) + '\n');

    } catch (error) {
        console.error('\n❌ Schema upload failed:', error);
        throw error;
    }
}

// Run upload
uploadSchema()
    .then(() => {
        console.log('🎉 All done!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
