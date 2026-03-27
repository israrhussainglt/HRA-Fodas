/**
 * Mark a delivery as delivered for testing
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
const DELIVERY_ID = '69884e6b001bc6ecab38'; // Yogurt delivery

async function markDelivered() {
    console.log('🚚 Marking delivery as delivered...\n');

    try {
        // Update delivery status to delivered
        const delivery = await databases.updateDocument(
            DATABASE_ID,
            DELIVERIES_COLLECTION,
            DELIVERY_ID,
            {
                status: 'delivered',
                delivery_time: new Date().toISOString()
            }
        );

        console.log('✅ Delivery updated successfully!');
        console.log(`   Delivery ID: ${delivery.$id}`);
        console.log(`   Status: ${delivery.status}`);
        console.log(`   Delivery Time: ${delivery.delivery_time}`);
        console.log('');
        console.log('🎯 Now restart the app and check:');
        console.log('   1. Home tab "Completed" counter should show 1');
        console.log('   2. This delivery should show as "Delivered" in My Deliveries');

    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

markDelivered()
    .then(() => {
        console.log('🎉 Complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
