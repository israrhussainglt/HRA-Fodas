/**
 * Appwrite Database Schema Creator
 * 
 * This script creates all collections and attributes in Appwrite
 * based on the schema defined in appwrite_schema.json
 * 
 * Usage: node create_appwrite_schema.js
 */

const fs = require('fs');
const { Client, Databases, ID, Permission, Role } = require('node-appwrite');

// Load environment variables from parent directory
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY); // You need to set this in .env

const databases = new Databases(client);

// Load schema
const schema = JSON.parse(fs.readFileSync('./appwrite_schema.json', 'utf8'));

async function createDatabase() {
  try {
    console.log(`\n📦 Creating/Verifying database: ${schema.databaseId}`);
    
    try {
      await databases.get(schema.databaseId);
      console.log(`✅ Database already exists: ${schema.databaseId}`);
    } catch (error) {
      if (error.code === 404) {
        await databases.create(schema.databaseId, schema.databaseId);
        console.log(`✅ Created database: ${schema.databaseId}`);
      } else {
        throw error;
      }
    }
  } catch (error) {
    // If error is about max databases, just continue - database likely exists
    if (error.code === 403 && error.type === 'additional_resource_not_allowed') {
      console.log(`⚠️  Database limit reached, assuming database exists: ${schema.databaseId}`);
      return;
    }
    console.error(`❌ Error with database: ${error.message}`);
    throw error;
  }
}

async function createCollection(collectionData) {
  const { id, name, permissions, attributes, indexes } = collectionData;
  
  try {
    console.log(`\n📋 Processing collection: ${name} (${id})`);
    
    // Check if collection exists
    let collection;
    try {
      collection = await databases.getCollection(schema.databaseId, id);
      console.log(`  ✅ Collection already exists: ${name}`);
    } catch (error) {
      if (error.code === 404) {
        // Create collection
        collection = await databases.createCollection(
          schema.databaseId,
          id,
          name,
          permissions || [
            Permission.read(Role.any()),
            Permission.create(Role.users()),
            Permission.update(Role.users()),
            Permission.delete(Role.users())
          ]
        );
        console.log(`  ✅ Created collection: ${name}`);
      } else {
        throw error;
      }
    }
    
    // Create attributes
    if (attributes && attributes.length > 0) {
      console.log(`  📝 Creating ${attributes.length} attributes...`);
      
      for (const attr of attributes) {
        try {
          // Check if attribute exists
          const existingAttrs = await databases.listAttributes(schema.databaseId, id);
          const attrExists = existingAttrs.attributes.some(a => a.key === attr.key);
          
          if (attrExists) {
            console.log(`    ⏭️  Attribute already exists: ${attr.key}`);
            continue;
          }
          
          // Create attribute based on type
          switch (attr.type) {
            case 'string':
              await databases.createStringAttribute(
                schema.databaseId,
                id,
                attr.key,
                attr.size,
                attr.required,
                attr.default,
                attr.array || false
              );
              break;
              
            case 'integer':
              await databases.createIntegerAttribute(
                schema.databaseId,
                id,
                attr.key,
                attr.required,
                attr.min,
                attr.max,
                attr.default,
                attr.array || false
              );
              break;
              
            case 'double':
            case 'float':
              await databases.createFloatAttribute(
                schema.databaseId,
                id,
                attr.key,
                attr.required,
                attr.min,
                attr.max,
                attr.default,
                attr.array || false
              );
              break;
              
            case 'boolean':
              await databases.createBooleanAttribute(
                schema.databaseId,
                id,
                attr.key,
                attr.required,
                attr.default,
                attr.array || false
              );
              break;
              
            case 'datetime':
              await databases.createDatetimeAttribute(
                schema.databaseId,
                id,
                attr.key,
                attr.required,
                attr.default,
                attr.array || false
              );
              break;
              
            case 'enum':
              await databases.createEnumAttribute(
                schema.databaseId,
                id,
                attr.key,
                attr.elements,
                attr.required,
                attr.default,
                attr.array || false
              );
              break;
              
            default:
              console.log(`    ⚠️  Unknown attribute type: ${attr.type} for ${attr.key}`);
          }
          
          console.log(`    ✅ Created attribute: ${attr.key} (${attr.type})`);
          
          // Wait a bit to avoid rate limiting
          await new Promise(resolve => setTimeout(resolve, 500));
          
        } catch (error) {
          if (error.code === 409) {
            console.log(`    ⏭️  Attribute already exists: ${attr.key}`);
          } else {
            console.error(`    ❌ Error creating attribute ${attr.key}: ${error.message}`);
          }
        }
      }
    }
    
    // Create indexes
    if (indexes && indexes.length > 0) {
      console.log(`  🔍 Creating ${indexes.length} indexes...`);
      
      for (const index of indexes) {
        try {
          // Check if index exists
          const existingIndexes = await databases.listIndexes(schema.databaseId, id);
          const indexExists = existingIndexes.indexes.some(i => i.key === index.key);
          
          if (indexExists) {
            console.log(`    ⏭️  Index already exists: ${index.key}`);
            continue;
          }
          
          await databases.createIndex(
            schema.databaseId,
            id,
            index.key,
            index.type || 'key',
            index.attributes,
            index.orders || []
          );
          
          console.log(`    ✅ Created index: ${index.key}`);
          
          // Wait a bit to avoid rate limiting
          await new Promise(resolve => setTimeout(resolve, 500));
          
        } catch (error) {
          if (error.code === 409) {
            console.log(`    ⏭️  Index already exists: ${index.key}`);
          } else {
            console.error(`    ❌ Error creating index ${index.key}: ${error.message}`);
          }
        }
      }
    }
    
  } catch (error) {
    console.error(`❌ Error processing collection ${name}: ${error.message}`);
    throw error;
  }
}

async function main() {
  console.log('🚀 Starting Appwrite Schema Creation');
  console.log(`📍 Endpoint: ${process.env.APPWRITE_ENDPOINT}`);
  console.log(`📦 Project: ${process.env.APPWRITE_PROJECT_ID}`);
  console.log(`🗄️  Database: ${schema.databaseId}`);
  
  try {
    // Create database
    await createDatabase();
    
    // Create collections
    console.log(`\n📚 Creating ${schema.collections.length} collections...`);
    
    for (const collection of schema.collections) {
      await createCollection(collection);
    }
    
    console.log('\n✨ Schema creation completed successfully!');
    
  } catch (error) {
    console.error('\n💥 Schema creation failed:', error);
    process.exit(1);
  }
}

// Run the script
main();
