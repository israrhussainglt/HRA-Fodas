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

async function checkNotifications() {
  try {
    console.log('Fetching all notifications...\n');
    const response = await databases.listDocuments(
      databaseId,
      notificationsCollection
    );

    console.log(`Total notifications: ${response.total}\n`);

    if (response.documents.length === 0) {
      console.log('✅ No notifications in database - this is good!');
      return;
    }

    console.log('Notifications found:');
    response.documents.forEach((doc, index) => {
      console.log(`\n${index + 1}. ID: ${doc.$id}`);
      console.log(`   User: ${doc.user_id}`);
      console.log(`   Title: ${doc.title}`);
      console.log(`   Type: ${doc.type}`);
      console.log(`   Data field: ${JSON.stringify(doc.data)}`);
      console.log(`   Data type: ${typeof doc.data}`);
    });
  } catch (error) {
    console.error('Error:', error.message);
    if (error.response) {
      console.error('Response:', error.response);
    }
  }
}

checkNotifications();
