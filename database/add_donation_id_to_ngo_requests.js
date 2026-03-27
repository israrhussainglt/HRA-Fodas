const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT)
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

async function addDonationIdField() {
    try {
        console.log('Adding donation_id field to ngo_requests collection...');
        
        await databases.createStringAttribute(
            process.env.APPWRITE_DATABASE_ID,
            'ngo_requests',
            'donation_id',
            36,
            false // not required
        );
        
        console.log('✅ Successfully added donation_id field to ngo_requests');
        console.log('   - Field: donation_id');
        console.log('   - Type: string');
        console.log('   - Size: 36');
        console.log('   - Required: false');
    } catch (error) {
        console.error('❌ Error adding donation_id field:', error.message);
        process.exit(1);
    }
}

addDonationIdField();
