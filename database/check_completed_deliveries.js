/**
 * Check completed deliveries for a volunteer
 */

const sdk = require('node-appwrite');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

const DATABASE_ID = 'hra_fodas_main';
const DELIVERIES_COLLECTION = 'deliveries';
const VOLUNTEER_ID = '6985d976e6780f2c0123';

async function checkCompletedDeliveries() {
    console.log('🔍 Checking completed deliveries...\n');

    try {
        // Get all deliveries for this volunteer
        const response = await databases.listDocuments(
            DATABASE_ID,
            DELIVERIES_COLLECTION,
            [sdk.Query.equal('volunteer_id', VOLUNTEER_ID)]
        );

        console.log(`Found ${response.documents.length} total deliveries for volunteer\n`);

        const completedDeliveries = response.documents.filter(d => d.status === 'delivered');
        const activeDeliveries = response.documents.filter(d => d.status !== 'delivered' && d.status !== 'cancelled' && d.status !== 'failed');

        console.log('📊 Delivery Status Summary:');
        console.log(`   Total deliveries: ${response.documents.length}`);
        console.log(`   Completed (delivered): ${completedDeliveries.length}`);
        console.log(`   Active: ${activeDeliveries.length}`);
        console.log('');

        if (completedDeliveries.length > 0) {
            console.log('✅ Completed Deliveries:');
            for (const delivery of completedDeliveries) {
                console.log(`   - Delivery ID: ${delivery.$id}`);
                console.log(`     Donation ID: ${delivery.donation_id}`);
                console.log(`     Status: ${delivery.status}`);
                console.log(`     Delivery Time: ${delivery.delivery_time || 'Not set'}`);
                console.log('');
            }
        }

        if (activeDeliveries.length > 0) {
            console.log('🚚 Active Deliveries:');
            for (const delivery of activeDeliveries) {
                console.log(`   - Delivery ID: ${delivery.$id}`);
                console.log(`     Donation ID: ${delivery.donation_id}`);
                console.log(`     Status: ${delivery.status}`);
                console.log('');
            }
        }

        console.log('🎯 Expected "Completed" count in app: ' + completedDeliveries.length);

    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

checkCompletedDeliveries()
    .then(() => {
        console.log('🎉 Check complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
