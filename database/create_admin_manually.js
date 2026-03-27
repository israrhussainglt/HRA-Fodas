/**
 * Manual Admin Creation Script
 * 
 * This script creates an admin user profile directly using the API key,
 * bypassing permission issues during first-time setup.
 */

const { Client, Databases, Account, ID } = require('node-appwrite');
const readline = require('readline');

// Load environment variables from parent directory
require('dotenv').config({ path: '../.env' });

const client = new Client()
  .setEndpoint(process.env.APPWRITE_ENDPOINT || 'https://nyc.cloud.appwrite.io/v1')
  .setProject(process.env.APPWRITE_PROJECT_ID)
  .setKey(process.env.APPWRITE_API_KEY);

const databases = new Databases(client);
const account = new Account(client);
const databaseId = process.env.APPWRITE_DATABASE_ID;

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function question(query) {
  return new Promise(resolve => rl.question(query, resolve));
}

async function createAdminUser() {
  console.log('🔐 Manual Admin User Creation');
  console.log('================================\n');
  
  try {
    // Get user input
    const fullName = await question('Enter admin full name: ');
    const email = await question('Enter admin email: ');
    const password = await question('Enter admin password (min 8 chars): ');
    
    console.log('\n📝 Creating admin user...\n');
    
    // Step 1: Create auth account using API key
    console.log('Step 1: Creating authentication account...');
    const userId = ID.unique();
    
    // Use Users API to create account with API key
    const response = await fetch(`${process.env.APPWRITE_ENDPOINT}/users`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-Appwrite-Project': process.env.APPWRITE_PROJECT_ID,
        'X-Appwrite-Key': process.env.APPWRITE_API_KEY
      },
      body: JSON.stringify({
        userId: userId,
        email: email,
        password: password,
        name: fullName
      })
    });
    
    if (!response.ok) {
      const error = await response.json();
      throw new Error(`Failed to create user: ${error.message}`);
    }
    
    const user = await response.json();
    console.log(`✅ Auth account created: ${user.$id}`);
    
    // Step 2: Create user profile using API key (bypasses permissions)
    console.log('\nStep 2: Creating admin profile...');
    await databases.createDocument(
      databaseId,
      'user_profiles',
      user.$id,
      {
        email: email,
        full_name: fullName,
        role: 'admin',
        is_verified: true,
        is_active: true
      }
    );
    
    console.log('✅ Admin profile created!');
    
    console.log('\n🎉 SUCCESS! Admin user created successfully!');
    console.log('\n📋 Admin Details:');
    console.log(`   User ID: ${user.$id}`);
    console.log(`   Email: ${email}`);
    console.log(`   Name: ${fullName}`);
    console.log(`   Role: admin`);
    console.log('\n🚀 You can now login to the app with these credentials!');
    
  } catch (error) {
    console.error('\n❌ Error creating admin user:', error.message);
    console.error('\nDetails:', error);
  } finally {
    rl.close();
  }
}

// Run the script
createAdminUser();
