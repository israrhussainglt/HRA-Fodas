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

async function deleteAllNotifications() {
  try {
    console.log('Fetching all notifications...');
    const response = await databases.listDocuments(
      databaseId,
      notificationsCollection
    );

    console.log(`Found ${response.total} notifications to delete\n`);

    if (response.documents.length === 0) {
      console.log('No notifications to delete.');
      return;
    }

    for (const doc of response.documents) {
      try {
        await databases.deleteDocument(
          databaseId,
          notificationsCollection,
          doc.$id
        );
        console.log(`✓ Deleted notification: ${doc.$id}`);
      } catch (error) {
        console.error(`✗ Failed to delete notification ${doc.$id}:`, error.message);
      }
    }

    console.log(`\n✅ Deleted ${response.documents.length} notifications successfully!`);
  } catch (error) {
    console.error('Error:', error.message);
    if (error.response) {
      console.error('Response:', error.response);
    }
  }
}

deleteAllNotifications();
