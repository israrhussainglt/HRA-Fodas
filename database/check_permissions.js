/**
 * Check Current Permissions Script
 * 
 * This script checks the current permissions on collections
 */

const { Client, Databases } = require('node-appwrite');

// Load environment variables from parent directory
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);
const databaseId = process.env.APPWRITE_DATABASE_ID;

async function checkPermissions() {
  console.log('🔍 Checking Collection Permissions\n');
  
  try {
    const collection = await databases.getCollection(databaseId, 'user_profiles');
    
    console.log('📋 user_profiles collection:');
    console.log('   Name:', collection.name);
    console.log('   Document Security:', collection.documentSecurity);
    console.log('   Enabled:', collection.enabled);
    console.log('   Permissions:', JSON.stringify(collection.$permissions, null, 2));
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

checkPermissions();
