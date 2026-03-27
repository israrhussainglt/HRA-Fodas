/**
 * Test delivery creation using TablesDB API
 * 
 * This tests if we can create a delivery with null recipient_id
 * using the new TablesDB API that the app uses
 */

const sdk = require('node-appwrite');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const tablesDB = new sdk.TablesDB(client);

const DATABASE_ID = 'hra_fodas_main';
const DELIVERIES_TABLE = 'deliveries';

async function testDeliveryCreation() {
    console.log('🧪 Testing delivery creation with TablesDB API...\n');

    try {
        // Test 1: Create delivery without recipient_id
        console.log('📝 Test 1: Creating delivery without recipient_id...');
        
        const testData = {
            donation_id: 'test_donation_' + Date.now(),
            volunteer_id: 'test_volunteer_' + Date.now(),
            // recipient_id is intentionally omitted (null)
            status: 'assigned',
            estimated_arrival: new Date(Date.now() + 3600000).toISOString()
        };
        
        console.log('   Data:', JSON.stringify(testData, null, 2));
        
        const delivery = await tablesDB.createRow(
            DATABASE_ID,
            DELIVERIES_TABLE,
            sdk.ID.unique(),
            testData
        );
        
        console.log('✅ Test 1 PASSED: Delivery created successfully!');
        console.log('   Delivery ID:', delivery.$id);
        console.log('   Recipient ID:', delivery.data.recipient_id || 'null (as expected)');
        console.log('');

        // Test 2: Update with recipient_id
        console.log('📝 Test 2: Updating delivery with recipient_id...');
        
        const updated = await tablesDB.updateRow(
            DATABASE_ID,
            DELIVERIES_TABLE,
            delivery.$id,
            {
                recipient_id: 'test_recipient_' + Date.now()
            }
        );
        
        console.log('✅ Test 2 PASSED: Delivery updated with recipient!');
        console.log('   Recipient ID:', updated.data.recipient_id);
        console.log('');

        // Cleanup
        console.log('🧹 Cleaning up test data...');
        await tablesDB.deleteRow(DATABASE_ID, DELIVERIES_TABLE, delivery.$id);
        console.log('✅ Cleanup complete');
        console.log('');

        console.log('✨ All tests passed!');
        console.log('');
        console.log('📊 Summary:');
        console.log('   ✅ Deliveries can be created without recipient_id');
        console.log('   ✅ Recipients can be assigned later');
        console.log('   ✅ The database schema is correctly configured');
        console.log('');
        console.log('🔍 Next: Check why the app is not creating deliveries');
        console.log('   Possible issues:');
        console.log('   1. App needs to be restarted');
        console.log('   2. Error in delivery creation code');
        console.log('   3. Check app logs for errors');

    } catch (error) {
        console.error('❌ Test failed:', error.message);
        console.error('');
        console.error('Error details:', error);
        console.error('');
        console.error('🔍 This means the schema is still not updated correctly.');
        console.error('   The recipient_id field is still required in the database.');
        console.error('');
        console.error('📋 Manual fix required:');
        console.error('   1. Go to Appwrite Console');
        console.error('   2. Navigate to: Databases → hra_fodas_main → deliveries');
        console.error('   3. Click on "recipient_id" attribute');
        console.error('   4. Click "Update Attribute"');
        console.error('   5. Uncheck "Required"');
        console.error('   6. Save changes');
        process.exit(1);
    }
}

testDeliveryCreation()
    .then(() => {
        console.log('🎉 Test complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
