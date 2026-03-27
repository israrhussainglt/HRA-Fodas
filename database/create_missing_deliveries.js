/**
 * Create missing delivery records for donations with assigned volunteers
 */

const sdk = require('node-appwrite');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

const DATABASE_ID = 'hra_fodas_main';
const DONATIONS_COLLECTION = 'donations';
const DELIVERIES_COLLECTION = 'deliveries';

async function createMissingDeliveries() {
    console.log('🔧 Creating missing delivery records...\n');

    try {
        // Get all donations with assigned volunteers
        const donations = await databases.listDocuments(DATABASE_ID, DONATIONS_COLLECTION);
        const assignedDonations = donations.documents.filter(d => d.assigned_volunteer_id);
        
        console.log(`Found ${assignedDonations.length} donations with assigned volunteers\n`);

        // Get existing deliveries
        const deliveries = await databases.listDocuments(DATABASE_ID, DELIVERIES_COLLECTION);
        const existingDeliveryDonationIds = new Set(
            deliveries.documents.map(d => d.donation_id)
        );

        // Find donations missing deliveries
        const missingDeliveries = assignedDonations.filter(
            d => !existingDeliveryDonationIds.has(d.$id) && d.status !== 'cancelled'
        );

        if (missingDeliveries.length === 0) {
            console.log('✅ No missing deliveries found - all donations have delivery records!');
            return;
        }

        console.log(`Found ${missingDeliveries.length} donations missing delivery records:\n`);

        // Create missing deliveries
        for (const donation of missingDeliveries) {
            console.log(`📝 Creating delivery for: ${donation.title}`);
            console.log(`   Donation ID: ${donation.$id}`);
            console.log(`   Volunteer ID: ${donation.assigned_volunteer_id}`);

            const deliveryData = {
                donation_id: donation.$id,
                volunteer_id: donation.assigned_volunteer_id,
                recipient_id: donation.assigned_recipient_id || null,
                status: 'assigned',
                estimated_arrival: new Date(
                    new Date(donation.pickup_start_time).getTime() + 3600000
                ).toISOString()
            };

            // Remove null values
            Object.keys(deliveryData).forEach(key => {
                if (deliveryData[key] === null) {
                    delete deliveryData[key];
                }
            });

            try {
                const delivery = await databases.createDocument(
                    DATABASE_ID,
                    DELIVERIES_COLLECTION,
                    sdk.ID.unique(),
                    deliveryData
                );

                console.log(`   ✅ Delivery created: ${delivery.$id}`);
            } catch (error) {
                console.log(`   ❌ Failed to create delivery: ${error.message}`);
            }
            console.log('');
        }

        console.log('✨ Delivery creation complete!');
        console.log('');
        console.log('📊 Summary:');
        console.log(`   Created ${missingDeliveries.length} delivery records`);
        console.log('   All donations now have delivery records');
        console.log('');
        console.log('🎯 Next steps:');
        console.log('   1. Refresh the app');
        console.log('   2. Check "My Deliveries" tab');
        console.log('   3. All accepted deliveries should now be visible');

    } catch (error) {
        console.error('❌ Error:', error.message);
        console.error('');
        console.error('Error details:', error);
        process.exit(1);
    }
}

createMissingDeliveries()
    .then(() => {
        console.log('🎉 Complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
