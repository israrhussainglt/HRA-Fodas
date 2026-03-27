/**
 * Check deliveries in the database
 * 
 * This script checks all deliveries and helps debug why they're not showing up
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
const DONATIONS_COLLECTION = 'donations';

async function checkDeliveries() {
    console.log('🔍 Checking deliveries in database...\n');

    try {
        // Check all deliveries
        console.log('📋 Step 1: Listing all deliveries...');
        const deliveries = await databases.listDocuments(DATABASE_ID, DELIVERIES_COLLECTION);
        
        console.log(`   Found ${deliveries.total} delivery records\n`);
        
        if (deliveries.total === 0) {
            console.log('❌ No deliveries found in database!');
            console.log('   This means delivery creation is still failing.\n');
        } else {
            console.log('✅ Deliveries found:\n');
            deliveries.documents.forEach((delivery, index) => {
                console.log(`   ${index + 1}. Delivery ID: ${delivery.$id}`);
                console.log(`      Donation ID: ${delivery.donation_id}`);
                console.log(`      Volunteer ID: ${delivery.volunteer_id}`);
                console.log(`      Recipient ID: ${delivery.recipient_id || 'null (OK)'}`);
                console.log(`      Status: ${delivery.status}`);
                console.log(`      Created: ${delivery.$createdAt}`);
                console.log('');
            });
        }

        // Check donations with assigned volunteers
        console.log('📋 Step 2: Checking donations with assigned volunteers...');
        const donations = await databases.listDocuments(DATABASE_ID, DONATIONS_COLLECTION);
        
        const assignedDonations = donations.documents.filter(d => d.assigned_volunteer_id);
        console.log(`   Found ${assignedDonations.length} donations with assigned volunteers\n`);
        
        if (assignedDonations.length > 0) {
            console.log('✅ Assigned donations:\n');
            assignedDonations.forEach((donation, index) => {
                console.log(`   ${index + 1}. Donation: ${donation.title}`);
                console.log(`      Donation ID: ${donation.$id}`);
                console.log(`      Volunteer ID: ${donation.assigned_volunteer_id}`);
                console.log(`      Recipient ID: ${donation.assigned_recipient_id || 'null'}`);
                console.log(`      Status: ${donation.status}`);
                
                // Check if there's a matching delivery
                const matchingDelivery = deliveries.documents.find(
                    d => d.donation_id === donation.$id
                );
                
                if (matchingDelivery) {
                    console.log(`      ✅ Has delivery record: ${matchingDelivery.$id}`);
                } else {
                    console.log(`      ❌ NO DELIVERY RECORD FOUND!`);
                }
                console.log('');
            });
        }

        // Check for the specific yogurt donation
        console.log('📋 Step 3: Looking for yogurt donation...');
        const yogurtDonations = donations.documents.filter(d => 
            d.title.toLowerCase().includes('yogurt') || 
            d.title.toLowerCase().includes('yoghurt')
        );
        
        if (yogurtDonations.length > 0) {
            console.log(`   Found ${yogurtDonations.length} yogurt donation(s):\n`);
            yogurtDonations.forEach((donation, index) => {
                console.log(`   ${index + 1}. ${donation.title}`);
                console.log(`      Donation ID: ${donation.$id}`);
                console.log(`      Volunteer ID: ${donation.assigned_volunteer_id || 'NOT ASSIGNED'}`);
                console.log(`      Status: ${donation.status}`);
                
                const matchingDelivery = deliveries.documents.find(
                    d => d.donation_id === donation.$id
                );
                
                if (matchingDelivery) {
                    console.log(`      ✅ Has delivery: ${matchingDelivery.$id}`);
                } else {
                    console.log(`      ❌ NO DELIVERY RECORD!`);
                }
                console.log('');
            });
        } else {
            console.log('   ⚠️  No yogurt donations found\n');
        }

        // Summary
        console.log('📊 Summary:');
        console.log(`   Total deliveries: ${deliveries.total}`);
        console.log(`   Donations with volunteers: ${assignedDonations.length}`);
        console.log(`   Deliveries missing: ${assignedDonations.length - deliveries.total}`);
        console.log('');

        if (assignedDonations.length > deliveries.total) {
            console.log('⚠️  ISSUE DETECTED:');
            console.log('   Some donations have assigned volunteers but no delivery records!');
            console.log('   This means delivery creation is still failing.\n');
            
            console.log('🔍 Possible causes:');
            console.log('   1. App needs to be restarted to pick up schema changes');
            console.log('   2. There might be an error in the delivery creation code');
            console.log('   3. Check app logs for error messages');
            console.log('   4. Verify the recipient_id attribute is truly optional in Appwrite console');
        }

    } catch (error) {
        console.error('❌ Error:', error.message);
        console.error('');
        console.error('Stack:', error.stack);
    }
}

checkDeliveries()
    .then(() => {
        console.log('🎉 Check complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
