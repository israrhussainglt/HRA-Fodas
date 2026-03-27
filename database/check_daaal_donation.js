/**
 * Check Daaal donation and NGO requests
 */

const sdk = require('node-appwrite');
require('dotenv').config();

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

const DATABASE_ID = 'hra_fodas_main';

async function checkDaaalDonation() {
    console.log('🔍 Checking for Daaal donation and NGO requests...\n');

    try {
        // Get all donations
        console.log('📋 Step 1: Searching for Daaal donation...');
        const donations = await databases.listDocuments(DATABASE_ID, 'donations', []);
        
        const daaalDonation = donations.documents.find(d => 
            d.title && d.title.toLowerCase().includes('daaal')
        );
        
        if (daaalDonation) {
            console.log('✅ Found Daaal donation:\n');
            console.log(`   Donation ID: ${daaalDonation.$id}`);
            console.log(`   Title: ${daaalDonation.title}`);
            console.log(`   Quantity: ${daaalDonation.quantity} ${daaalDonation.unit}`);
            console.log(`   Category: ${daaalDonation.food_category}`);
            console.log(`   Status: ${daaalDonation.status}`);
            console.log(`   Donor ID: ${daaalDonation.donor_id}`);
            console.log(`   Assigned Volunteer: ${daaalDonation.assigned_volunteer_id || 'None'}`);
            console.log(`   Assigned Recipient: ${daaalDonation.assigned_recipient_id || 'None'}`);
            console.log(`   Created: ${daaalDonation.$createdAt}`);
            console.log('');

            // Check for NGO requests for this donation
            console.log('📋 Step 2: Checking NGO requests for this donation...');
            const ngoRequests = await databases.listDocuments(DATABASE_ID, 'ngo_requests', []);
            
            const requestsForDaaal = ngoRequests.documents.filter(r => 
                r.donation_id === daaalDonation.$id
            );
            
            if (requestsForDaaal.length > 0) {
                console.log(`✅ Found ${requestsForDaaal.length} NGO request(s) for Daaal:\n`);
                requestsForDaaal.forEach((request, index) => {
                    console.log(`   ${index + 1}. Request ID: ${request.$id}`);
                    console.log(`      NGO ID: ${request.recipient_id || request.ngo_id}`);
                    console.log(`      NGO Name: ${request.ngo_name}`);
                    console.log(`      Status: ${request.status}`);
                    console.log(`      Created: ${request.$createdAt}`);
                    console.log('');
                });
            } else {
                console.log('❌ NO NGO requests found for this donation!\n');
                console.log('   This is the issue - the donation shows "Already Requested"');
                console.log('   but there are no actual requests in the database.\n');
            }

            // Check all NGO requests to see if any are pending
            console.log('📋 Step 3: Checking all NGO requests...');
            const allRequests = ngoRequests.documents;
            console.log(`   Total NGO requests in database: ${allRequests.length}\n`);
            
            if (allRequests.length > 0) {
                console.log('   All NGO requests:\n');
                allRequests.forEach((request, index) => {
                    console.log(`   ${index + 1}. Request ID: ${request.$id}`);
                    console.log(`      Donation ID: ${request.donation_id || 'None'}`);
                    console.log(`      NGO ID: ${request.recipient_id || request.ngo_id}`);
                    console.log(`      Status: ${request.status}`);
                    console.log(`      Title: ${request.title}`);
                    console.log('');
                });
            }

        } else {
            console.log('❌ Daaal donation not found in database!\n');
            console.log('   Showing recent donations:\n');
            
            const recentDonations = donations.documents.slice(0, 5);
            recentDonations.forEach((donation, index) => {
                console.log(`   ${index + 1}. ${donation.title}`);
                console.log(`      ID: ${donation.$id}`);
                console.log(`      Status: ${donation.status}`);
                console.log(`      Created: ${donation.$createdAt}`);
                console.log('');
            });
        }

    } catch (error) {
        console.error('❌ Error:', error.message);
        if (error.response) {
            console.error('Response:', error.response);
        }
    }
}

checkDaaalDonation()
    .then(() => {
        console.log('🎉 Check complete!');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Fatal error:', error);
        process.exit(1);
    });
