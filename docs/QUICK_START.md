# 🚀 Quick Start Guide - HRA-FoDAS

## Prerequisites

- Flutter SDK (3.10.4+)
- Node.js (18+) for Appwrite Functions
- Appwrite CLI
- Firebase account
- Appwrite Cloud account

## 1. Environment Setup (5 minutes)

### Copy Environment File
```bash
cp .env.example .env
```

### Fill in Credentials
Edit `.env` and add your actual credentials:

```env
# Appwrite (from https://cloud.appwrite.io/console)
APPWRITE_ENDPOINT=https://nyc.cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-project-id
APPWRITE_DATABASE_ID=your-database-id
APPWRITE_API_KEY=your-api-key

# FCM Provider
FCM_PROVIDER_ID=fcm_provider_main

# Firebase (from Firebase Console)
FIREBASE_PROJECT_ID=your-firebase-project
FIREBASE_PRIVATE_KEY_ID=your-key-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
FIREBASE_CLIENT_ID=your-client-id
FIREBASE_CLIENT_X509_CERT_URL=https://www.googleapis.com/robot/v1/metadata/x509/...
```

**⚠️ NEVER commit .env file!**

## 2. Install Dependencies (2 minutes)

```bash
# Flutter dependencies
flutter pub get

# Appwrite Functions dependencies
cd functions/notification-sender
npm install

cd ../donation-events
npm install

cd ../..
```

## 3. Configure Firebase (10 minutes)

### Android
1. Download `google-services.json` from Firebase Console
2. Place in `android/app/google-services.json`
3. Verify `android/app/build.gradle.kts` has:
   ```kotlin
   id("com.google.gms.google-services")
   ```

### iOS (if applicable)
1. Download `GoogleService-Info.plist`
2. Place in `ios/Runner/GoogleService-Info.plist`

## 4. Configure Appwrite (15 minutes)

### Database Collections
Ensure these collections exist in your Appwrite database:
- `user_profiles`
- `donations`
- `fcm_tokens`
- `notifications`
- `pending_push_notifications` ⚠️ NEW
- `notification_preferences`

### FCM Provider Setup
1. Go to Appwrite Console → Messaging → Providers
2. Click "Add Provider" → FCM
3. Provider ID: `fcm_provider_main`
4. Upload Firebase service account JSON
5. Enable the provider

### OAuth Setup (Google Sign-In)
1. Go to Appwrite Console → Auth → Settings
2. Enable Google OAuth
3. Add Web Client ID and Secret from Google Cloud Console
4. Configure redirect URLs

## 5. Deploy Appwrite Functions (5 minutes)

```bash
# Login to Appwrite CLI
appwrite login

# Deploy notification sender
cd functions/notification-sender
appwrite deploy function

# Deploy donation events
cd ../donation-events
appwrite deploy function

cd ../..
```

### Verify Deployment
1. Go to Appwrite Console → Functions
2. Check both functions are "Ready"
3. Check logs for any errors

## 6. Run the App (2 minutes)

```bash
# Run on connected device/emulator
flutter run

# Or for specific platform
flutter run -d android
flutter run -d ios
```

## 7. Test Push Notifications (5 minutes)

### Test Flow
1. Sign up / Sign in
2. Check Appwrite Console → Databases → `fcm_tokens`
   - Verify your token is saved
3. Create a test donation
4. Check if notification appears
5. Check Appwrite Console → Functions → Logs
   - Verify `notification-sender` executed

### Troubleshooting
If notifications don't work:

1. **Check FCM Token**
   ```
   Appwrite Console → Databases → fcm_tokens
   - Is token present?
   - Is is_active = true?
   ```

2. **Check Function Logs**
   ```
   Appwrite Console → Functions → notification-sender → Logs
   - Any errors?
   - Did function execute?
   ```

3. **Check Pending Notifications**
   ```
   Appwrite Console → Databases → pending_push_notifications
   - Are records being created?
   - What's the status?
   ```

4. **Check FCM Provider**
   ```
   Appwrite Console → Messaging → Providers
   - Is provider enabled?
   - Are credentials correct?
   ```

## 8. Common Issues & Solutions

### Issue: "No FCM token"
**Solution**: 
- Ensure Firebase is initialized in `main.dart`
- Check `google-services.json` is in correct location
- Verify Firebase project ID matches

### Issue: "Provider not found"
**Solution**:
- Check `FCM_PROVIDER_ID` in `.env` matches Appwrite Console
- Verify provider is enabled in Appwrite Console

### Issue: "Permission denied"
**Solution**:
- Check Appwrite API key has correct scopes
- Verify database permissions allow function to read/write

### Issue: "Function not executing"
**Solution**:
- Check function is deployed and "Ready"
- Verify database trigger is configured correctly
- Check function logs for errors

## 9. Development Workflow

### Making Changes
1. Edit code
2. Run `flutter pub get` if dependencies changed
3. Hot reload: Press `r` in terminal
4. Hot restart: Press `R` in terminal

### Testing Notifications
1. Use test button in app (if available)
2. Or create donation to trigger notification
3. Check logs in Appwrite Console

### Debugging
1. Check Flutter logs: `flutter logs`
2. Check Appwrite Function logs: Appwrite Console → Functions
3. Check Firebase logs: Firebase Console → Cloud Messaging

## 10. Production Deployment

### Before Production
- [ ] Enable email verification (uncomment in `auth_repository.dart`)
- [ ] Replace all remaining `print` statements
- [ ] Test on physical devices
- [ ] Review security checklist in `SECURITY.md`
- [ ] Update `.env` with production credentials
- [ ] Test all authentication flows
- [ ] Test all notification scenarios
- [ ] Monitor Appwrite Function logs
- [ ] Set up error monitoring

### Production Environment
1. Create separate `.env.prod` file
2. Use production Appwrite project
3. Use production Firebase project
4. Enable email verification
5. Review and tighten database permissions
6. Set up monitoring and alerts

## 📚 Additional Resources

- **Security Guidelines**: See `SECURITY.md`
- **Fix Summary**: See `MIGRATION_FIXES_SUMMARY.md`
- **Completion Status**: See `FIXES_COMPLETED.md`
- **Appwrite Docs**: https://appwrite.io/docs
- **Firebase Docs**: https://firebase.google.com/docs

## 🆘 Need Help?

1. Check the documentation files in this repo
2. Review Appwrite Console logs
3. Check Firebase Console for FCM issues
4. Review `.env.example` for configuration help

---

**Last Updated**: 2025-01-24
**Version**: 1.0.0
