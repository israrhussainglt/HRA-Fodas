/**
 * Fix Missing Attributes Script
 * 
 * This script adds the missing attributes that failed during initial creation
 * because they had both required=true and default values.
 */

const fs = require('fs');
const { Client, Databases } = require('node-appwrite');

// Load environment variables from parent directory
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);
const databaseId = process.env.APPWRITE_DATABASE_ID;

// Define missing attributes (required=false with defaults)
const missingAttributes = [
  // user_profiles
  {
    collectionId: 'user_profiles',
    attributes: [
      { key: 'role', type: 'enum', elements: ['donor', 'volunteer', 'recipient', 'admin'], required: false, default: 'donor' },
      { key: 'is_verified', type: 'boolean', required: false, default: false },
      { key: 'is_active', type: 'boolean', required: false, default: true }
    ]
  },
  // donations
  {
    collectionId: 'donations',
    attributes: [
      { key: 'status', type: 'enum', elements: ['pending', 'assigned', 'picked_up', 'in_transit', 'delivered', 'cancelled', 'expired'], required: false, default: 'pending' }
    ]
  },
  // volunteer_profiles
  {
    collectionId: 'volunteer_profiles',
    attributes: [
      { key: 'is_available', type: 'boolean', required: false, default: true },
      { key: 'total_deliveries', type: 'integer', required: false, default: 0 },
      { key: 'rating', type: 'double', required: false, default: 0 }
    ]
  },
  // recipient_organizations
  {
    collectionId: 'recipient_organizations',
    attributes: [
      { key: 'is_verified', type: 'boolean', required: false, default: false },
      { key: 'is_active', type: 'boolean', required: false, default: true }
    ]
  },
  // deliveries
  {
    collectionId: 'deliveries',
    attributes: [
      { key: 'status', type: 'enum', elements: ['assigned', 'accepted', 'picked_up', 'in_transit', 'delivered', 'cancelled'], required: false, default: 'assigned' }
    ]
  },
  // notifications
  {
    collectionId: 'notifications',
    attributes: [
      { key: 'is_read', type: 'boolean', required: false, default: false }
    ]
  },
  // chat_messages
  {
    collectionId: 'chat_messages',
    attributes: [
      { key: 'type', type: 'string', size: 50, required: false, default: 'text' },
      { key: 'is_read', type: 'boolean', required: false, default: false }
    ]
  },
  // chat_logs
  {
    collectionId: 'chat_logs',
    attributes: [
      { key: 'is_offline', type: 'boolean', required: false, default: false }
    ]
  },
  // feedback_ratings
  {
    collectionId: 'feedback_ratings',
    attributes: [
      { key: 'is_anonymous', type: 'boolean', required: false, default: false }
    ]
  },
  // inventory
  {
    collectionId: 'inventory',
    attributes: [
      { key: 'status', type: 'string', size: 50, required: false, default: 'available' }
    ]
  },
  // inventory_v2
  {
    collectionId: 'inventory_v2',
    attributes: [
      { key: 'quantity', type: 'double', required: false, default: 0 },
      { key: 'unit', type: 'string', size: 50, required: false, default: 'kg' }
    ]
  },
  // fcm_tokens
  {
    collectionId: 'fcm_tokens',
    attributes: [
      { key: 'is_active', type: 'boolean', required: false, default: true }
    ]
  },
  // notification_preferences
  {
    collectionId: 'notification_preferences',
    attributes: [
      { key: 'new_donation_alerts', type: 'boolean', required: false, default: true },
      { key: 'pickup_reminders', type: 'boolean', required: false, default: true },
      { key: 'status_updates', type: 'boolean', required: false, default: true },
      { key: 'chat_messages', type: 'boolean', required: false, default: true },
      { key: 'all_notifications_enabled', type: 'boolean', required: false, default: true }
    ]
  },
  // scheduled_notifications
  {
    collectionId: 'scheduled_notifications',
    attributes: [
      { key: 'status', type: 'enum', elements: ['pending', 'sent', 'failed', 'cancelled'], required: false, default: 'pending' }
    ]
  },
  // pending_push_notifications
  {
    collectionId: 'pending_push_notifications',
    attributes: [
      { key: 'status', type: 'enum', elements: ['pending', 'sent', 'failed'], required: false, default: 'pending' }
    ]
  },
  // messages
  {
    collectionId: 'messages',
    attributes: [
      { key: 'is_read', type: 'boolean', required: false, default: false }
    ]
  },
  // feedback
  {
    collectionId: 'feedback',
    attributes: [
      { key: 'status', type: 'string', size: 50, required: false, default: 'pending' }
    ]
  },
  // daily_statistics
  {
    collectionId: 'daily_statistics',
    attributes: [
      { key: 'total_donations', type: 'integer', required: false, default: 0 },
      { key: 'total_deliveries', type: 'integer', required: false, default: 0 },
      { key: 'total_weight_kg', type: 'double', required: false, default: 0 },
      { key: 'active_donors', type: 'integer', required: false, default: 0 },
      { key: 'active_volunteers', type: 'integer', required: false, default: 0 },
      { key: 'active_recipients', type: 'integer', required: false, default: 0 }
    ]
  },
  // ngo_requests
  {
    collectionId: 'ngo_requests',
    attributes: [
      { key: 'status', type: 'enum', elements: ['open', 'partially_fulfilled', 'fulfilled', 'cancelled', 'expired'], required: false, default: 'open' },
      { key: 'fulfilled_quantity', type: 'double', required: false, default: 0 }
    ]
  }
];

async function createAttribute(collectionId, attr) {
  try {
    // Check if attribute exists
    const existingAttrs = await databases.listAttributes(databaseId, collectionId);
    const attrExists = existingAttrs.attributes.some(a => a.key === attr.key);
    
    if (attrExists) {
      console.log(`    ⏭️  Attribute already exists: ${attr.key}`);
      return;
    }
    
    // Create attribute based on type
    switch (attr.type) {
      case 'string':
        await databases.createStringAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.size,
          attr.required,
          attr.default,
          false
        );
        break;
        
      case 'integer':
        await databases.createIntegerAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.required,
          attr.min,
          attr.max,
          attr.default,
          false
        );
        break;
        
      case 'double':
        await databases.createFloatAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.required,
          attr.min,
          attr.max,
          attr.default,
          false
        );
        break;
        
      case 'boolean':
        await databases.createBooleanAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.required,
          attr.default,
          false
        );
        break;
        
      case 'enum':
        await databases.createEnumAttribute(
          databaseId,
          collectionId,
          attr.key,
          attr.elements,
          attr.required,
          attr.default,
          false
        );
        break;
        
      default:
        console.log(`    ⚠️  Unknown attribute type: ${attr.type} for ${attr.key}`);
    }
    
    console.log(`    ✅ Created attribute: ${attr.key} (${attr.type})`);
    
    // Wait to avoid rate limiting
    await new Promise(resolve => setTimeout(resolve, 500));
    
  } catch (error) {
    if (error.code === 409) {
      console.log(`    ⏭️  Attribute already exists: ${attr.key}`);
    } else {
      console.error(`    ❌ Error creating attribute ${attr.key}: ${error.message}`);
    }
  }
}

async function main() {
  console.log('🔧 Fixing Missing Attributes');
  console.log(`📍 Endpoint: ${process.env.APPWRITE_ENDPOINT}`);
  console.log(`📦 Project: ${process.env.APPWRITE_PROJECT_ID}`);
  console.log(`🗄️  Database: ${databaseId}\n`);
  
  try {
    for (const collection of missingAttributes) {
      console.log(`📋 Processing collection: ${collection.collectionId}`);
      console.log(`  📝 Creating ${collection.attributes.length} attributes...`);
      
      for (const attr of collection.attributes) {
        await createAttribute(collection.collectionId, attr);
      }
      
      console.log('');
    }
    
    console.log('✨ All missing attributes have been added!');
    console.log('\n🎯 Next step: Run your Flutter app again with "flutter run"');
    
  } catch (error) {
    console.error('\n💥 Failed to fix attributes:', error);
    process.exit(1);
  }
}

// Run the script
main();
