/**
 * Migration Script: NGO Requests Schema Alignment
 * 
 * This script migrates the ngo_requests table from the old schema to the new aligned schema.
 * 
 * OLD SCHEMA:
 * - food_categories (string)
 * - quantity_needed (double)
 * - urgency (enum)
 * - status: ['open', 'partially_fulfilled', 'fulfilled', 'cancelled', 'expired']
 * 
 * NEW SCHEMA:
 * - food_category (enum: ['fresh_produce', 'dairy', 'meat', 'bakery', 'canned', 'prepared', 'other'])
 * - quantity (double)
 * - status: ['pending', 'approved', 'denied', 'converted', 'cancelled']
 * - Additional fields: ngo_name, delivery_address, denial_reason, reviewed_by, reviewed_at, converted_donation_id, metadata
 * 
 * IMPORTANT: This script will:
 * 1. Create new attributes
 * 2. Migrate existing data
 * 3. Delete old attributes (commented out for safety - uncomment after verification)
 */

const sdk = require('node-appwrite');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);
const databaseId = process.env.APPWRITE_DATABASE_ID;
const collectionId = 'ngo_requests';

// Status mapping from old to new
const statusMapping = {
    'open': 'pending',
    'partially_fulfilled': 'approved',
    'fulfilled': 'approved',
    'cancelled': 'cancelled',
    'expired': 'cancelled'
};

async function migrateSchema() {
    console.log('🚀 Starting NGO Requests Schema Migration...\n');

    try {
        // Step 1: Create new enum attribute for food_category
        console.log('📝 Step 1: Creating food_category enum attribute...');
        try {
            await databases.createEnumAttribute(
                databaseId,
                collectionId,
                'food_category',
                ['fresh_produce', 'dairy', 'meat', 'bakery', 'canned', 'prepared', 'other'],
                false, // not required initially to allow migration
                null,  // no default
                false  // not array
            );
            console.log('✅ Created food_category enum attribute\n');
        } catch (error) {
            if (error.code === 409) {
                console.log('⚠️  food_category attribute already exists, skipping...\n');
            } else {
                throw error;
            }
        }

        // Step 2: Create new double attribute for quantity
        console.log('📝 Step 2: Creating quantity double attribute...');
        try {
            await databases.createFloatAttribute(
                databaseId,
                collectionId,
                'quantity',
                false, // not required initially
                null,  // no min
                null,  // no max
                null,  // no default
                false  // not array
            );
            console.log('✅ Created quantity double attribute\n');
        } catch (error) {
            if (error.code === 409) {
                console.log('⚠️  quantity attribute already exists, skipping...\n');
            } else {
                throw error;
            }
        }

        // Step 3: Create additional string attributes
        console.log('📝 Step 3: Creating additional string attributes...');
        const stringAttributes = [
            { key: 'ngo_name', size: 255 },
            { key: 'delivery_address', size: 500 },
            { key: 'denial_reason', size: 1000 },
            { key: 'reviewed_by', size: 36 },
            { key: 'converted_donation_id', size: 36 },
            { key: 'metadata', size: 5000, default: '{}' }
        ];

        for (const attr of stringAttributes) {
            try {
                await databases.createStringAttribute(
                    databaseId,
                    collectionId,
                    attr.key,
                    attr.size,
                    false, // not required
                    attr.default || null,
                    false  // not array
                );
                console.log(`✅ Created ${attr.key} string attribute`);
            } catch (error) {
                if (error.code === 409) {
                    console.log(`⚠️  ${attr.key} attribute already exists, skipping...`);
                } else {
                    throw error;
                }
            }
        }
        console.log('');

        // Step 4: Create datetime attribute for reviewed_at
        console.log('📝 Step 4: Creating reviewed_at datetime attribute...');
        try {
            await databases.createDatetimeAttribute(
                databaseId,
                collectionId,
                'reviewed_at',
                false, // not required
                null,  // no default
                false  // not array
            );
            console.log('✅ Created reviewed_at datetime attribute\n');
        } catch (error) {
            if (error.code === 409) {
                console.log('⚠️  reviewed_at attribute already exists, skipping...\n');
            } else {
                throw error;
            }
        }

        // Step 5: Wait for attributes to be available
        console.log('⏳ Waiting 5 seconds for attributes to be available...');
        await new Promise(resolve => setTimeout(resolve, 5000));
        console.log('');

        // Step 6: Migrate existing data
        console.log('📝 Step 6: Migrating existing data...');
        const response = await databases.listDocuments(
            databaseId,
            collectionId,
            [sdk.Query.limit(100)] // Process in batches
        );

        console.log(`Found ${response.documents.length} documents to migrate\n`);

        let successCount = 0;
        let errorCount = 0;

        for (const doc of response.documents) {
            try {
                const updates = {};

                // Migrate food_categories to food_category
                if (doc.food_categories) {
                    // Map old string values to new enum values
                    const oldValue = doc.food_categories.toLowerCase();
                    if (oldValue.includes('produce') || oldValue.includes('fruit') || oldValue.includes('vegetable')) {
                        updates.food_category = 'fresh_produce';
                    } else if (oldValue.includes('dairy')) {
                        updates.food_category = 'dairy';
                    } else if (oldValue.includes('meat')) {
                        updates.food_category = 'meat';
                    } else if (oldValue.includes('bakery') || oldValue.includes('bread')) {
                        updates.food_category = 'bakery';
                    } else if (oldValue.includes('canned')) {
                        updates.food_category = 'canned';
                    } else if (oldValue.includes('prepared') || oldValue.includes('cooked')) {
                        updates.food_category = 'prepared';
                    } else {
                        updates.food_category = 'other';
                    }
                }

                // Migrate quantity_needed to quantity
                if (doc.quantity_needed !== undefined) {
                    updates.quantity = doc.quantity_needed;
                }

                // Migrate status
                if (doc.status && statusMapping[doc.status]) {
                    updates.status = statusMapping[doc.status];
                }

                // Only update if there are changes
                if (Object.keys(updates).length > 0) {
                    await databases.updateDocument(
                        databaseId,
                        collectionId,
                        doc.$id,
                        updates
                    );
                    successCount++;
                    console.log(`✅ Migrated document ${doc.$id}`);
                }
            } catch (error) {
                errorCount++;
                console.error(`❌ Error migrating document ${doc.$id}:`, error.message);
            }
        }

        console.log(`\n📊 Migration Summary:`);
        console.log(`   - Total documents: ${response.documents.length}`);
        console.log(`   - Successfully migrated: ${successCount}`);
        console.log(`   - Errors: ${errorCount}\n`);

        // Step 7: Instructions for manual cleanup
        console.log('📝 Step 7: Manual cleanup required');
        console.log('⚠️  IMPORTANT: After verifying the migration, you should:');
        console.log('   1. Verify all data migrated correctly');
        console.log('   2. Update the status enum to remove old values');
        console.log('   3. Delete old attributes: food_categories, quantity_needed, urgency, fulfilled_quantity');
        console.log('   4. Make food_category and quantity required');
        console.log('');
        console.log('   To delete old attributes, uncomment the cleanup section in this script and run again.\n');

        // CLEANUP SECTION (COMMENTED OUT FOR SAFETY)
        // Uncomment after verifying migration
        /*
        console.log('🗑️  Deleting old attributes...');
        
        try {
            await databases.deleteAttribute(databaseId, collectionId, 'food_categories');
            console.log('✅ Deleted food_categories attribute');
        } catch (error) {
            console.error('❌ Error deleting food_categories:', error.message);
        }

        try {
            await databases.deleteAttribute(databaseId, collectionId, 'quantity_needed');
            console.log('✅ Deleted quantity_needed attribute');
        } catch (error) {
            console.error('❌ Error deleting quantity_needed:', error.message);
        }

        try {
            await databases.deleteAttribute(databaseId, collectionId, 'urgency');
            console.log('✅ Deleted urgency attribute');
        } catch (error) {
            console.error('❌ Error deleting urgency:', error.message);
        }

        try {
            await databases.deleteAttribute(databaseId, collectionId, 'fulfilled_quantity');
            console.log('✅ Deleted fulfilled_quantity attribute');
        } catch (error) {
            console.error('❌ Error deleting fulfilled_quantity:', error.message);
        }
        */

        console.log('✅ Migration completed successfully!\n');

    } catch (error) {
        console.error('❌ Migration failed:', error);
        throw error;
    }
}

// Run migration
migrateSchema()
    .then(() => {
        console.log('🎉 All done!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
