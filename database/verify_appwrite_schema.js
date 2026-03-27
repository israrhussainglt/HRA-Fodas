/**
 * Appwrite Database Schema Verifier
 * 
 * This script verifies the current state of collections in Appwrite
 * and compares them with the expected schema
 * 
 * Usage: node verify_appwrite_schema.js
 */

const fs = require('fs');
const { Client, Databases } = require('node-appwrite');

// Load environment variables
require('dotenv').config();

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);

// Load schema
const schema = JSON.parse(fs.readFileSync('./database/appwrite_schema.json', 'utf8'));

async function verifyDatabase() {
  console.log('🔍 Verifying Appwrite Database Schema\n');
  console.log(`📍 Endpoint: ${process.env.APPWRITE_ENDPOINT}`);
  console.log(`📦 Project: ${process.env.APPWRITE_PROJECT_ID}`);
  console.log(`🗄️  Database: ${schema.databaseId}\n`);
  
  try {
    // Check database exists
    try {
      await databases.get(schema.databaseId);
      console.log(`✅ Database exists: ${schema.databaseId}\n`);
    } catch (error) {
      console.log(`❌ Database not found: ${schema.databaseId}\n`);
      return;
    }
    
    // Get all collections
    const collectionsResponse = await databases.listCollections(schema.databaseId);
    const existingCollections = collectionsResponse.collections;
    
    console.log(`📊 Found ${existingCollections.length} collections in Appwrite`);
    console.log(`📋 Expected ${schema.collections.length} collections from schema\n`);
    
    // Create a map of existing collections
    const existingMap = new Map(existingCollections.map(c => [c.$id, c]));
    
    // Check each expected collection
    const results = {
      existing: [],
      missing: [],
      extra: []
    };
    
    for (const expectedCollection of schema.collections) {
      const exists = existingMap.has(expectedCollection.id);
      
      if (exists) {
        const collection = existingMap.get(expectedCollection.id);
        
        // Get attributes
        const attributesResponse = await databases.listAttributes(schema.databaseId, expectedCollection.id);
        const attributes = attributesResponse.attributes;
        
        // Get indexes
        const indexesResponse = await databases.listIndexes(schema.databaseId, expectedCollection.id);
        const indexes = indexesResponse.indexes;
        
        results.existing.push({
          id: expectedCollection.id,
          name: expectedCollection.name,
          attributeCount: attributes.length,
          expectedAttributes: expectedCollection.attributes?.length || 0,
          indexCount: indexes.length,
          expectedIndexes: expectedCollection.indexes?.length || 0
        });
        
        existingMap.delete(expectedCollection.id);
      } else {
        results.missing.push({
          id: expectedCollection.id,
          name: expectedCollection.name
        });
      }
    }
    
    // Any remaining collections are extra
    results.extra = Array.from(existingMap.values()).map(c => ({
      id: c.$id,
      name: c.name
    }));
    
    // Print results
    console.log('═══════════════════════════════════════════════════════════\n');
    
    if (results.existing.length > 0) {
      console.log(`✅ EXISTING COLLECTIONS (${results.existing.length}):\n`);
      results.existing.forEach(c => {
        const attrStatus = c.attributeCount === c.expectedAttributes ? '✅' : '⚠️';
        const indexStatus = c.indexCount === c.expectedIndexes ? '✅' : '⚠️';
        console.log(`  ${c.name} (${c.id})`);
        console.log(`    ${attrStatus} Attributes: ${c.attributeCount}/${c.expectedAttributes}`);
        console.log(`    ${indexStatus} Indexes: ${c.indexCount}/${c.expectedIndexes}`);
      });
      console.log();
    }
    
    if (results.missing.length > 0) {
      console.log(`❌ MISSING COLLECTIONS (${results.missing.length}):\n`);
      results.missing.forEach(c => {
        console.log(`  ❌ ${c.name} (${c.id})`);
      });
      console.log();
    }
    
    if (results.extra.length > 0) {
      console.log(`⚠️  EXTRA COLLECTIONS (${results.extra.length}) - Not in schema:\n`);
      results.extra.forEach(c => {
        console.log(`  ⚠️  ${c.name} (${c.id})`);
      });
      console.log();
    }
    
    console.log('═══════════════════════════════════════════════════════════\n');
    
    // Summary
    if (results.missing.length === 0 && results.extra.length === 0) {
      const allAttributesMatch = results.existing.every(c => 
        c.attributeCount === c.expectedAttributes && c.indexCount === c.expectedIndexes
      );
      
      if (allAttributesMatch) {
        console.log('✨ Schema is fully synchronized!');
      } else {
        console.log('⚠️  All collections exist but some have missing attributes or indexes.');
        console.log('   Run: npm run create-schema to sync them.');
      }
    } else {
      console.log('⚠️  Schema is not fully synchronized.');
      if (results.missing.length > 0) {
        console.log(`   Missing ${results.missing.length} collection(s).`);
      }
      if (results.extra.length > 0) {
        console.log(`   Found ${results.extra.length} extra collection(s) not in schema.`);
      }
      console.log('   Run: npm run create-schema to create missing collections.');
    }
    
  } catch (error) {
    console.error('❌ Verification failed:', error.message);
    if (error.code) {
      console.error(`   Error code: ${error.code}`);
    }
    process.exit(1);
  }
}

// Run the script
verifyDatabase();
