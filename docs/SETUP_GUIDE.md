# 🚀 Complete Setup Guide

This guide will walk you through setting up the HRA-FoDAS application from scratch.

## Prerequisites

- Flutter SDK 3.38.5+
- Dart SDK 3.10.4+
- Android Studio or VS Code
- Git
- Node.js (for database scripts)

## Step 1: Clone and Install

```bash
# Clone repository
git clone https://github.com/yourusername/hra-fodas.git
cd hra-fodas

# Install Flutter dependencies
flutter pub get

# Install Node.js dependencies (for database scripts)
cd database
npm install
cd ..
```

## Step 2: Create Appwrite Project

1. Go to [Appwrite Console](https://cloud.appwrite.io)
2. Click "Create Project"
3. Name: `HRA-FoDAS-Main`
4. Region: Choose closest to your users (e.g., New York)
5. Copy the **Project ID**

### Create Database

1. Go to Databases → Create Database
2. Name: `hra_fodas_main`
3. Copy the **Database ID**

### Import Schema

Option A: Using Script (Recommended)
```bash
cd database
node create_appwrite_schema.js
```

Option B: Manual Import
1. Use `database/tables_schema.json`
2. Create each collection manually
3. Configure columns, indexes, and permissions

### Configure Permissions

For each collection, set these permissions:
- **Read**: `users`
- **Create**: `users`
- **Update**: `users`
- **Delete**: `users` ⚠️ Required!

## Step 3: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Name: `HRA-FoDAS-Main`
4. Disable Google Analytics (optional)
5. Click "Create project"

### Add Android App

1. Click "Add app" → Android icon
2. Package name: `com.hrafodas.food_donation_app`
3. App nickname: `HRA-FoDAS Android`
4. Click "Register app"
5. Download `google-services.json`
6. Place in `android/app/google-services.json`

### Add iOS App (Optional)

1. Click "Add app" → iOS icon
2. Bundle ID: `com.hrafodas.food_donation_app`
3. App nickname: `HRA-FoDAS iOS`
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Place in `ios/Runner/GoogleService-Info.plist`

### Enable Cloud Messaging

1. Go to Project Settings → Cloud Messaging
2. Verify Cloud Messaging API is enabled
3. If not, click "Enable"

### Generate Service Account

1. Go to Project Settings → Service Accounts
2. Click "Generate new private key"
3. Click "Generate key"
4. Save as `config/firebase_service_account.json`

## Step 4: Configure Environment Variables

1. Copy the example file:
```bash
cp .env.example .env
```

2. Edit `.env` with your credentials:

```env
# ============================================
# APPWRITE CONFIGURATION
# ============================================
APPWRITE_ENDPOINT=https://nyc.cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-appwrite-project-id
APPWRITE_DATABASE_ID=hra_fodas_main

# ============================================
# FIREBASE CONFIGURATION
# ============================================
FIREBASE_PROJECT_ID=your-firebase-project-id
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_STORAGE_BUCKET=your-project.firebasestorage.app
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com

# Firebase Web Configuration
FIREBASE_WEB_API_KEY=your-web-api-key
FIREBASE_WEB_APP_ID=your-web-app-id

# Firebase Android Configuration
FIREBASE_ANDROID_API_KEY=your-android-api-key
FIREBASE_ANDROID_APP_ID=your-android-app-id

# Firebase iOS Configuration
FIREBASE_IOS_API_KEY=your-ios-api-key
FIREBASE_IOS_APP_ID=your-ios-app-id
FIREBASE_IOS_BUNDLE_ID=com.hrafodas.food_donation_app

# ============================================
# APP CONFIGURATION
# ============================================
APP_NAME=HRA-FoDAS
APP_TAGLINE=Food Donation & Distribution Platform
```

## Step 5: Verify Configuration

Run the verification script:

```bash
scripts\verify-migration.bat
```

This will check:
- ✅ `.env` file exists and has correct values
- ✅ `google-services.json` exists
- ✅ `firebase_service_account.json` exists
- ✅ All files contain new project IDs

## Step 6: Build and Run

```bash
# Clean build
flutter clean
flutter pub get

# Run on Android
flutter run -d android

# Or run on iOS
flutter run -d ios
```

## Step 7: Create First Admin

1. Launch the app
2. You'll see the "First-Time Setup" screen
3. Fill in admin details:
   - Full Name
   - Email
   - Password (min 8 chars, uppercase, lowercase, number)
   - Confirm Password
4. Click "Create Admin Account"
5. You'll be redirected to login screen
6. Login with your admin credentials

**Note**: This setup screen only appears once and is locked after the first admin is created.

## Step 8: Test the App

### Test Checklist

- [ ] Admin login works
- [ ] Create donation (as donor)
- [ ] Accept delivery (as volunteer)
- [ ] Update delivery status
- [ ] Push notifications work
- [ ] Mark notification as read
- [ ] Delete notification
- [ ] Chat functionality
- [ ] AI meal planner
- [ ] Map integration

## Troubleshooting

### Issue: "No admin user exists"

**Solution**: Complete the first-time setup screen to create the admin account.

### Issue: "Delete permission denied"

**Solution**: Configure DELETE permissions in Appwrite Console for all collections.

### Issue: "Firebase initialization failed"

**Solution**: 
1. Verify `google-services.json` is in `android/app/`
2. Check package name matches: `com.hrafodas.food_donation_app`
3. Verify Firebase project ID in `.env`

### Issue: "Service account not found"

**Solution**: 
1. Verify `config/firebase_service_account.json` exists
2. Check file is not in `.gitignore` (it should be!)
3. Regenerate service account key from Firebase Console

## Next Steps

1. **Create Test Users**: Create donor, volunteer, and recipient accounts
2. **Test Features**: Go through the test checklist
3. **Configure Notifications**: Test push notifications on real devices
4. **Deploy Functions**: Deploy Appwrite functions if needed
5. **Build Release**: Use `scripts\build-release.bat` for production APK

## Additional Resources

- [Appwrite Documentation](https://appwrite.io/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
- [Project Documentation](../docs/)

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review logs in the console
3. Check [GitHub Issues](https://github.com/yourusername/hra-fodas/issues)
4. Contact support team

---

**Setup complete! You're ready to start developing! 🎉**
