const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databaseId = process.env.APPWRITE_DATABASE_ID;
const notificationsCollection = 'notifications';

async function verifyNotificationsDeleted() {
  try {
    console.log('Checking notifications in database...\n');
    
    const response = await databases.listDocuments(
      databaseId,
      notificationsCollection
    );

    console.log(`Total notifications: ${response.total}`);
    
    if (response.total === 0) {
      console.log('\n✅ SUCCESS: All notifications have been deleted!');
      console.log('You can now proceed with the Flutter fix.');
    } else {
      console.log(`\n⚠️  WARNING: Found ${response.total} notifications still in database`);
      console.log('Run delete_all_notifications.js to delete them.');
      
      console.log('\nFirst 5 notifications:');
      response.documents.slice(0, 5).forEach((doc, index) => {
        console.log(`\n${index + 1}. ID: ${doc.$id}`);
        console.log(`   User: ${doc.user_id}`);
        console.log(`   Title: ${doc.title}`);
        console.log(`   Data field: ${doc.data || 'null'}`);
      });
    }
  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.response) {
      console.error('Response:', error.response);
    }
  }
}

verifyNotificationsDeleted();
