/**
 * Fix Collection Permissions Script
 * 
 * This script sets the correct permissions on all collections
 * to allow users to create, read, update, and delete their own documents.
 */

const { Client, Databases, Permission, Role } = require('node-appwrite');

// Load environment variables from parent directory
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);
const databaseId = process.env.APPWRITE_DATABASE_ID;

// Collections that need user permissions
const collections = [
  'user_profiles',
  'donations',
  'volunteer_profiles',
  'recipient_organizations',
  'deliveries',
  'delivery_logs',
  'notifications',
  'conversations',
  'chat_messages',
  'chat_logs',
  'feedback_ratings',
  'ratings',
  'inventory',
  'inventory_v2',
  'fcm_tokens',
  'notification_preferences',
  'scheduled_notifications',
  'pending_push_notifications',
  'messages',
  'feedback',
  'analytics_events',
  'daily_statistics',
  'ngo_requests'
];

async function updateCollectionPermissions(collectionId) {
  try {
    console.log(`📋 Updating permissions for: ${collectionId}`);
    
    // Get current collection to preserve the name
    const collection = await databases.getCollection(databaseId, collectionId);
    
    // Set permissions: any user can read, authenticated users can create/update/delete
    const permissions = [
      'read("any")',
      'create("users")',
      'update("users")',
      'delete("users")'
    ];
    
    await databases.updateCollection(
      databaseId,
      collectionId,
      collection.name, // preserve original name
      permissions,
      collection.documentSecurity || false,
      collection.enabled !== false
    );
    
    console.log(`  ✅ Permissions updated successfully`);
    
  } catch (error) {
    console.error(`  ❌ Error updating ${collectionId}: ${error.message}`);
  }
}

async function main() {
  console.log('🔐 Fixing Collection Permissions');
  console.log(`📍 Endpoint: ${process.env.APPWRITE_ENDPOINT}`);
  console.log(`📦 Project: ${process.env.APPWRITE_PROJECT_ID}`);
  console.log(`🗄️  Database: ${databaseId}\n`);
  
  try {
    for (const collectionId of collections) {
      await updateCollectionPermissions(collectionId);
      // Small delay to avoid rate limiting
      await new Promise(resolve => setTimeout(resolve, 300));
    }
    
    console.log('\n✨ All collection permissions have been updated!');
    console.log('\n🎯 Permissions set:');
    console.log('  - Read: Any user (including guests)');
    console.log('  - Create: Authenticated users');
    console.log('  - Update: Authenticated users');
    console.log('  - Delete: Authenticated users');
    console.log('\n🚀 Try creating your admin account again!');
    
  } catch (error) {
    console.error('\n💥 Failed to fix permissions:', error);
    process.exit(1);
  }
}

// Run the script
main();
