/**
 * Verify that recipient_id is optional and test delivery creation
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

async function verifyAndTest() {
    console.log('🔍 Verifying recipient_id attribute and testing delivery creation...\n');

    try {
        // Step 1: Check attribute configuration
        console.log('📋 Step 1: Checking recipient_id attribute...');
        const attr = await databases.getAttribute(DATABASE_ID, COLLECTION_ID, 'recipient_id');
        
        console.log('   Attribute details:');
        console.log('   - Key:', attr.key);
        console.log('   - Type:', attr.type);
        console.log('   - Required:', attr.required);
        console.log('   - Size:', attr.size);
        console.log('');

        if (attr.required) {
            console.log('❌ PROBLEM FOUND: recipient_id is still REQUIRED!');
            console.log('');
            console.log('📋 The migration did not work. Manual fix needed:');
            console.log('   1. Go to Appwrite Console');
            console.log('   2. Navigate to: Databases → hra_fodas_main → deliveries');
            console.log('   3. Click on "recipient_id" attribute');
            console.log('   4. Click "Update Attribute" button');
            console.log('   5. Uncheck "Required" checkbox');
            console.log('   6. Click "Update" to save');
            console.log('');
            console.log('🔗 Direct link:');
            const consoleUrl = process.env.APPWRITE_ENDPOINT.replace('/v1', '');
            console.log(`   ${consoleUrl}/console/project-${process.env.APPWRITE_PROJECT_ID}/databases/database-${DATABASE_ID}/collection-${COLLECTION_ID}`);
            console.log('');
            return;
        }

        console.log('✅ recipient_id is optional!');
        console.log('');

        // Step 2: Test delivery creation
        console.log('📝 Step 2: Testing delivery creation without recipient_id...');
        
        const testData = {
            donation_id: '69884d028d4e517399ba', // The yogurt donation
            volunteer_id: '6985d976e6780f2c0123', // Your volunteer ID
            // recipient_id is intentionally omitted
            status: 'assigned',
            estimated_arrival: new Date(Date.now() + 3600000).toISOString()
        };
        
        console.log('   Creating delivery with data:', JSON.stringify(testData, null, 2));
        
        const delivery = await databases.createDocument(
            DATABASE_ID,
            COLLECTION_ID,
            sdk.ID.unique(),
            testData
        );
        
        console.log('✅ Delivery created successfully!');
        console.log('   Delivery ID:', delivery.$id);
        console.log('   Donation ID:', delivery.donation_id);
        console.log('   Volunteer ID:', delivery.volunteer_id);
        console.log('   Recipient ID:', delivery.recipient_id || 'null (OK)');
        console.log('   Status:', delivery.status);
        console.log('');

        console.log('✨ SUCCESS! The database is working correctly.');
        console.log('');
        console.log('📊 Summary:');
        console.log('   ✅ recipient_id is optional in database');
        console.log('   ✅ Delivery created successfully for yogurt donation');
        console.log('   ✅ Delivery should now appear in "My Deliveries" tab');
        console.log('');
        console.log('🎯 Next steps:');
        console.log('   1. Refresh the app');
        console.log('   2. Check "My Deliveries" tab');
        console.log('   3. The yogurt delivery should now be visible');

    } catch (error) {
        console.error('❌ Error:', error.message);
        console.error('');
        
        if (error.message.includes('required') || error.message.includes('recipient_id')) {
            console.error('🔍 The error suggests recipient_id is still required.');
            console.error('   The database schema was not updated correctly.');
            console.error('');
            console.error('📋 Manual fix required - see instructions above.');
        } else {
            console.error('Error details:', error);
        }
        
        process.exit(1);
    }
}

verifyAndTest()
    .then(() => {
        console.log('🎉 Verification complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
