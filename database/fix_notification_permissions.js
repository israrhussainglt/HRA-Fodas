const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

// Initialize Appwrite client
const client = new sdk.Client();
const databases = new sdk.Databases(client);

client
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const DATABASE_ID = process.env.APPWRITE_DATABASE_ID || '69845ba80021edbcd155';
const NOTIFICATIONS_COLLECTION_ID = 'notifications';

async function fixNotificationPermissions() {
  try {
    console.log('🔧 Fixing Notification Collection Permissions...\n');

    // Get current collection configuration
    console.log('📋 Fetching current collection configuration...');
    const collection = await databases.getCollection(
      DATABASE_ID,
      NOTIFICATIONS_COLLECTION_ID
    );

    console.log('Current permissions:', collection.permissions);

    // Check if create("any") permission already exists
    const hasCreateAny = collection.permissions.some(
      perm => perm === 'create("any")' || perm === 'create(any)'
    );

    if (hasCreateAny) {
      console.log('✅ Collection already has create("any") permission!');
      console.log('No changes needed.\n');
      return;
    }

    // Add create("any") permission
    console.log('\n🔨 Adding create("any") permission...');
    const updatedPermissions = [
      ...collection.permissions,
      'create("any")'
    ];

    await databases.updateCollection(
      DATABASE_ID,
      NOTIFICATIONS_COLLECTION_ID,
      collection.name,
      updatedPermissions,
      collection.documentSecurity,
      collection.enabled
    );

    console.log('✅ Permission added successfully!');

    // Verify the change
    console.log('\n🔍 Verifying changes...');
    const updatedCollection = await databases.getCollection(
      DATABASE_ID,
      NOTIFICATIONS_COLLECTION_ID
    );

    console.log('Updated permissions:', updatedCollection.permissions);

    const hasCreateAnyNow = updatedCollection.permissions.some(
      perm => perm === 'create("any")' || perm === 'create(any)'
    );

    if (hasCreateAnyNow) {
      console.log('\n✅ SUCCESS! Notification permissions configured correctly.');
      console.log('\n📝 What this means:');
      console.log('   - Any authenticated user can now create notifications');
      console.log('   - Volunteers can create notifications for donors');
      console.log('   - Donors can create notifications for volunteers/recipients');
      console.log('   - Cross-user notifications will work properly');
      console.log('\n🎉 You can now test the notification system!');
    } else {
      console.log('\n⚠️  WARNING: Permission may not have been applied correctly.');
      console.log('Please check Appwrite Console manually.');
    }

  } catch (error) {
    console.error('\n❌ Error fixing notification permissions:', error.message);
    
    if (error.code === 401) {
      console.error('\n🔑 Authentication Error:');
      console.error('   - Check your APPWRITE_API_KEY in .env file');
      console.error('   - Make sure the API key has "databases.write" scope');
    } else if (error.code === 404) {
      console.error('\n🔍 Not Found Error:');
      console.error('   - Check APPWRITE_DATABASE_ID in .env file');
      console.error('   - Verify notifications collection exists');
    } else {
      console.error('\n💡 Troubleshooting:');
      console.error('   1. Verify .env file has correct Appwrite credentials');
      console.error('   2. Check API key has "databases.write" permission');
      console.error('   3. Manually configure in Appwrite Console:');
      console.error('      - Go to Databases → notifications collection');
      console.error('      - Settings tab → Collection Permissions');
      console.error('      - Add: create("any")');
    }
    
    process.exit(1);
  }
}

// Run the fix
console.log('╔════════════════════════════════════════════════════════╗');
console.log('║   Appwrite Notification Permissions Fix Script        ║');
console.log('╚════════════════════════════════════════════════════════╝\n');

fixNotificationPermissions();
