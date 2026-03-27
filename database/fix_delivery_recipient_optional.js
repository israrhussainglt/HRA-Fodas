/**
 * Migration: Make recipient_id optional in deliveries collection
 * 
 * This fixes the issue where volunteers cannot accept donations because
 * delivery creation fails when recipient_id is null.
 * 
 * Run with: node database/fix_delivery_recipient_optional.js
 */

const sdk = require('node-appwrite');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

const DATABASE_ID = 'hra_fodas_main';
const COLLECTION_ID = 'deliveries';
const ATTRIBUTE_KEY = 'recipient_id';

async function fixDeliveryRecipientOptional() {
    console.log('🔧 Starting migration: Make recipient_id optional in deliveries collection');
    console.log(`   Database: ${DATABASE_ID}`);
    console.log(`   Collection: ${COLLECTION_ID}`);
    console.log('');

    try {
        // Step 1: Check current attribute
        console.log('📋 Step 1: Checking current attribute configuration...');
        let currentAttr;
        try {
            currentAttr = await databases.getAttribute(DATABASE_ID, COLLECTION_ID, ATTRIBUTE_KEY);
            console.log(`   Current status: required = ${currentAttr.required}`);
            
            if (!currentAttr.required) {
                console.log('✅ Attribute is already optional - no migration needed!');
                console.log('');
                console.log('🎯 Next steps:');
                console.log('   1. Test volunteer donation acceptance in the app');
                console.log('   2. Verify deliveries appear in "My Deliveries" tab');
                return;
            }
        } catch (error) {
            console.error(`❌ Error checking attribute: ${error.message}`);
            throw error;
        }
        console.log('✅ Step 1 complete');
        console.log('');

        // Step 2: Update attribute to make it optional
        console.log('📝 Step 2: Updating recipient_id attribute to be optional...');
        console.log('   ⚠️  Note: This requires deleting and recreating the attribute');
        console.log('   ⚠️  Existing delivery records will be preserved');
        console.log('');

        // Appwrite doesn't support updating attribute requirements directly
        // We need to delete and recreate the attribute
        // But first, let's check if there are any deliveries
        console.log('🔍 Checking existing delivery records...');
        const deliveries = await databases.listDocuments(DATABASE_ID, COLLECTION_ID);
        console.log(`   Found ${deliveries.total} existing delivery records`);
        
        if (deliveries.total > 0) {
            console.log('');
            console.log('⚠️  WARNING: Cannot automatically update attribute with existing data');
            console.log('');
            console.log('📋 Manual steps required:');
            console.log('   1. Go to Appwrite Console');
            console.log('   2. Navigate to: Databases → hra_fodas_main → deliveries');
            console.log('   3. Click on "recipient_id" attribute');
            console.log('   4. Click "Update Attribute"');
            console.log('   5. Uncheck "Required"');
            console.log('   6. Save changes');
            console.log('');
            console.log('   OR use the Appwrite CLI:');
            console.log(`   appwrite databases updateStringAttribute \\`);
            console.log(`     --databaseId ${DATABASE_ID} \\`);
            console.log(`     --collectionId ${COLLECTION_ID} \\`);
            console.log(`     --key ${ATTRIBUTE_KEY} \\`);
            console.log(`     --required false`);
            console.log('');
            console.log('🔗 Direct link to collection:');
            console.log(`   ${process.env.APPWRITE_ENDPOINT.replace('/v1', '')}/console/project-${process.env.APPWRITE_PROJECT_ID}/databases/database-${DATABASE_ID}/collection-${COLLECTION_ID}`);
            return;
        }

        // If no deliveries exist, we can safely delete and recreate
        console.log('');
        console.log('📝 No existing deliveries found - safe to recreate attribute');
        console.log('   Deleting attribute...');
        
        await databases.deleteAttribute(DATABASE_ID, COLLECTION_ID, ATTRIBUTE_KEY);
        console.log('   ✅ Attribute deleted');
        
        // Wait for deletion to complete
        console.log('   ⏳ Waiting for deletion to complete...');
        await new Promise(resolve => setTimeout(resolve, 3000));
        
        console.log('   Creating new optional attribute...');
        await databases.createStringAttribute(
            DATABASE_ID,
            COLLECTION_ID,
            ATTRIBUTE_KEY,
            36,  // size
            false,  // required = false (this is the fix!)
            null,  // default
            false  // array
        );
        console.log('   ✅ Attribute recreated as optional');
        
        console.log('✅ Step 2 complete');
        console.log('');

        console.log('✨ Migration completed successfully!');
        console.log('');
        console.log('📊 Summary:');
        console.log('   - recipient_id is now optional in deliveries collection');
        console.log('   - Volunteers can now accept donations without assigned recipients');
        console.log('');
        console.log('🎯 Next steps:');
        console.log('   1. Test volunteer donation acceptance in the app');
        console.log('   2. Verify deliveries appear in "My Deliveries" tab');
        console.log('   3. Confirm recipient assignment still works when NGO requests are approved');

    } catch (error) {
        console.error('');
        console.error('❌ Migration failed:', error.message);
        console.error('');
        console.error('🔍 Troubleshooting:');
        console.error('   - Verify APPWRITE_PROJECT_ID and APPWRITE_API_KEY in .env file');
        console.error('   - Ensure the API key has database write permissions');
        console.error('   - Check that the deliveries collection exists');
        console.error('   - If deliveries exist, use manual update via Appwrite Console');
        process.exit(1);
    }
}

// Run migration
fixDeliveryRecipientOptional()
    .then(() => {
        console.log('');
        console.log('🎉 All done!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
