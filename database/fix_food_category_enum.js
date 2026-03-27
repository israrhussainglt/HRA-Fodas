/**
 * Fix Food Category Enum Script
 * 
 * This script deletes and recreates the food_category attribute
 * with the correct enum values to match the app.
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

async function fixFoodCategoryEnum() {
  console.log('🔧 Fixing Food Category Enum');
  console.log(`📍 Endpoint: ${process.env.APPWRITE_ENDPOINT}`);
  console.log(`📦 Project: ${process.env.APPWRITE_PROJECT_ID}`);
  console.log(`🗄️  Database: ${databaseId}\n`);
  
  try {
    const collectionId = 'donations';
    const attributeKey = 'food_category';
    
    console.log('⚠️  WARNING: This will delete the food_category attribute!');
    console.log('   Any existing donation data will lose their food_category values.');
    console.log('   Press Ctrl+C to cancel, or wait 5 seconds to continue...\n');
    
    await new Promise(resolve => setTimeout(resolve, 5000));
    
    // Step 1: Delete the old attribute
    console.log('Step 1: Deleting old food_category attribute...');
    try {
      await databases.deleteAttribute(databaseId, collectionId, attributeKey);
      console.log('✅ Old attribute deleted');
    } catch (error) {
      if (error.code === 404) {
        console.log('⏭️  Attribute doesn\'t exist, skipping deletion');
      } else {
        throw error;
      }
    }
    
    // Wait for deletion to complete
    console.log('⏳ Waiting for deletion to complete...');
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // Step 2: Create the new attribute with correct enum values
    console.log('\nStep 2: Creating new food_category attribute...');
    await databases.createEnumAttribute(
      databaseId,
      collectionId,
      attributeKey,
      ['fresh_produce', 'dairy', 'meat', 'bakery', 'canned', 'prepared', 'other'],
      true, // required
      null, // no default since it's required
      false // not an array
    );
    console.log('✅ New attribute created with correct enum values');
    
    console.log('\n✨ Food category enum has been fixed!');
    console.log('\n📋 New enum values:');
    console.log('   - fresh_produce (Fresh Produce)');
    console.log('   - dairy (Dairy)');
    console.log('   - meat (Meat)');
    console.log('   - bakery (Bakery)');
    console.log('   - canned (Canned Goods)');
    console.log('   - prepared (Prepared Food)');
    console.log('   - other (Other)');
    console.log('\n🚀 Try creating a donation again!');
    
  } catch (error) {
    console.error('\n💥 Failed to fix food category enum:', error.message);
    process.exit(1);
  }
}

// Run the script
fixFoodCategoryEnum();
