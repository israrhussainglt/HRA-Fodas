# HRA-FoDAS Deployment Guide

Complete guide for deploying HRA-FoDAS to production environments.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Backend Configuration](#backend-configuration)
4. [Building the App](#building-the-app)
5. [Testing](#testing)
6. [App Store Deployment](#app-store-deployment)
7. [Post-Deployment](#post-deployment)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

- **Flutter SDK**: 3.38.5 or higher
- **Dart SDK**: 3.10.4 or higher
- **Android Studio**: Latest version (for Android builds)
- **Xcode**: Latest version (for iOS builds, macOS only)
- **Appwrite CLI**: For function deployment
- **Git**: For version control

### Required Accounts

- **Appwrite Cloud**: [cloud.appwrite.io](https://cloud.appwrite.io)
- **Firebase Console**: [console.firebase.google.com](https://console.firebase.google.com)
- **Google Play Console**: For Android deployment
- **Apple Developer**: For iOS deployment
- **OpenRouter** (Optional): For AI meal planner

## Environment Setup

### 1. Clone and Install

```bash
git clone https://github.com/yourusername/hra-fodas.git
cd hra-fodas
flutter pub get
```

### 2. Configure Environment Variables

Copy the example environment file:

```bash
copy .env.example .env
```

Edit `.env` with your credentials:

```env
# Appwrite Configuration
APPWRITE_ENDPOINT=https://nyc.cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your-project-id
APPWRITE_DATABASE_ID=your-database-id

# App Information
APP_NAME=HRA-FoDAS
APP_TAGLINE=Food Donation & Distribution Platform

# OpenRouter (Optional - for AI Meal Planner)
OPENROUTER_API_KEY=your-openrouter-key
```

### 3. Firebase Setup

#### Android

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or select existing
3. Add Android app:
   - Package name: `com.hrafodas.food_donation_app`
   - Download `google-services.json`
   - Place in `android/app/`

#### iOS

1. In Firebase Console, add iOS app:
   - Bundle ID: `com.hrafodas.foodDonationApp`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`

#### Enable Firebase Cloud Messaging

1. In Firebase Console → Project Settings → Cloud Messaging
2. Enable Cloud Messaging API
3. Note down Server Key (for Appwrite function)

## Backend Configuration

### Appwrite Setup

#### 1. Create Project

```bash
# Login to Appwrite CLI
appwrite login

# Initialize project
appwrite init project
```

#### 2. Create Database

In Appwrite Console:
1. Go to Databases → Create Database
2. Name: `hra_fodas_main`
3. Copy Database ID to `.env`

#### 3. Create Collections

Required collections with permissions:

| Collection | Permissions |
|------------|-------------|
| user_profiles | Read: users, Create: users, Update: users, Delete: users |
| donations | Read: users, Create: users, Update: users, Delete: users |
| deliveries | Read: users, Create: users, Update: users, Delete: users |
| notifications | Read: users, Create: users, Update: users, Delete: users |
| fcm_tokens | Read: users, Create: users, Update: users, Delete: users |
| conversations | Read: users, Create: users, Update: users, Delete: users |
| messages | Read: users, Create: users, Update: users, Delete: users |
| inventory | Read: users, Create: users, Update: users, Delete: users |
| admin_reports | Read: users, Create: users, Update: users, Delete: users |
| trust_scores | Read: users, Create: users, Update: users, Delete: users |
| feedback_moderation | Read: users, Create: users, Update: users, Delete: users |
| ngo_requests | Read: users, Create: users, Update: users, Delete: users |

**⚠️ CRITICAL**: All collections MUST have DELETE permission for users!

#### 4. Deploy Functions

```bash
# Use the deployment script
scripts\deploy-functions.bat

# Or manually
cd functions/donation-events
appwrite deploy function
cd ../notification-sender
appwrite deploy function
```

#### 5. Configure Function Environment Variables

For `notification-sender` function:
- `FIREBASE_SERVER_KEY`: Your Firebase Cloud Messaging server key
- `APPWRITE_API_KEY`: Appwrite API key with appropriate permissions

### Database Schema

See [QUICK_START.md](QUICK_START.md) for detailed schema information.

## Building the App

### Development Build

```bash
# Run on connected device
flutter run

# Run with specific flavor (if configured)
flutter run --flavor dev
```

### Production Build

#### Android APK (Standard)

```bash
# Use build script
scripts\build-release.bat

# Or manually
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Android APK (Split - Recommended)

```bash
# Use build script
scripts\build-split-apk.bat

# Or manually
flutter build apk --split-per-abi --release
```

Outputs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM) ← Most common
- `app-x86_64-release.apk` (64-bit Intel)

#### Android App Bundle (Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS Build

```bash
# Open Xcode
open ios/Runner.xcworkspace

# Or build from command line
flutter build ios --release
```

## Testing

### Pre-Deployment Testing Checklist

#### Functional Testing

- [ ] User registration and login
- [ ] Email verification flow
- [ ] Profile creation and editing
- [ ] Create donation (with images)
- [ ] Browse donations (search/filter)
- [ ] Accept delivery (volunteer)
- [ ] Update delivery status
- [ ] Push notifications received
- [ ] In-app notifications work
- [ ] Mark notification as read
- [ ] Delete notification
- [ ] Chat functionality
- [ ] AI meal planner
- [ ] Map integration
- [ ] Route optimization
- [ ] Inventory management
- [ ] Admin dashboard access
- [ ] User management (admin)
- [ ] Analytics dashboard

#### Device Testing

Test on multiple devices:

**Android**:
- [ ] Android 7.0 (API 24) - Minimum supported
- [ ] Android 10 (API 29)
- [ ] Android 12+ (API 31+)
- [ ] Different screen sizes (phone, tablet)

**iOS**:
- [ ] iOS 12.0 - Minimum supported
- [ ] iOS 14
- [ ] iOS 15+
- [ ] Different screen sizes (iPhone SE, iPhone 14, iPad)

#### Performance Testing

- [ ] App launches in < 3 seconds
- [ ] Smooth scrolling (60 FPS)
- [ ] Images load efficiently
- [ ] No memory leaks
- [ ] Battery usage acceptable
- [ ] Network error handling
- [ ] Offline functionality

#### Security Testing

- [ ] API keys not exposed
- [ ] Secure data transmission
- [ ] Proper authentication
- [ ] Role-based access control
- [ ] No sensitive data in logs
- [ ] Secure local storage

## App Store Deployment

### Google Play Store (Android)

#### 1. Prepare Assets

- App icon: 512x512 PNG
- Feature graphic: 1024x500 PNG
- Screenshots: At least 2 per device type
- Privacy policy URL
- App description

#### 2. Create Release

1. Go to [Google Play Console](https://play.google.com/console)
2. Create app or select existing
3. Go to Production → Create new release
4. Upload `app-release.aab`
5. Fill in release notes
6. Review and rollout

#### 3. Store Listing

- Title: HRA-FoDAS
- Short description: Food donation management platform
- Full description: See README.md
- Category: Social
- Content rating: Everyone
- Privacy policy: Required

### Apple App Store (iOS)

#### 1. Prepare Assets

- App icon: 1024x1024 PNG
- Screenshots: Required for all device sizes
- Privacy policy URL
- App description

#### 2. Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps → + → New App
3. Fill in app information
4. Upload build via Xcode or Transporter

#### 3. Submit for Review

1. Complete all required information
2. Add screenshots
3. Set pricing (Free)
4. Submit for review

## Post-Deployment

### Monitoring

#### 1. Set Up Analytics

- Firebase Analytics
- Crashlytics for crash reporting
- Performance monitoring

#### 2. Monitor Metrics

- Daily active users (DAU)
- Crash-free rate
- API response times
- Push notification delivery rate
- User retention

### Maintenance

#### Regular Tasks

- [ ] Monitor error logs
- [ ] Review user feedback
- [ ] Update dependencies monthly
- [ ] Security patches
- [ ] Performance optimization
- [ ] Feature requests

#### Version Updates

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Run tests
4. Build release
5. Test release build
6. Deploy to stores
7. Create git tag

## Troubleshooting

### Common Issues

#### Build Failures

**Issue**: Gradle build fails
```bash
# Solution
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

**Issue**: iOS build fails
```bash
# Solution
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter build ios
```

#### Runtime Issues

**Issue**: Push notifications not working
- Check Firebase configuration
- Verify FCM token registration
- Check Appwrite function logs
- Verify device permissions

**Issue**: Appwrite connection fails
- Check `.env` configuration
- Verify project ID and endpoint
- Check network connectivity
- Review Appwrite console logs

**Issue**: Images not loading
- Check storage permissions in Appwrite
- Verify image URLs
- Check network connectivity
- Review cached_network_image configuration

### Debug Mode

Enable debug logging:

```dart
// In main.dart
AppLogger.setLogLevel(LogLevel.debug);
```

View logs:
```bash
# Android
adb logcat | findstr "flutter"

# iOS
flutter logs
```

### Support Resources

- **Documentation**: See `docs/` folder
- **Issues**: GitHub Issues
- **Appwrite Docs**: [appwrite.io/docs](https://appwrite.io/docs)
- **Flutter Docs**: [flutter.dev/docs](https://flutter.dev/docs)
- **Firebase Docs**: [firebase.google.com/docs](https://firebase.google.com/docs)

## Rollback Procedure

If deployment fails:

1. **Immediate**: Rollback to previous version in store console
2. **Investigate**: Check logs and error reports
3. **Fix**: Address the issue in code
4. **Test**: Thoroughly test the fix
5. **Redeploy**: Follow deployment process again

## Security Checklist

Before deployment:

- [ ] All API keys in environment variables
- [ ] No hardcoded credentials
- [ ] `.env` in `.gitignore`
- [ ] Firebase rules configured
- [ ] Appwrite permissions set correctly
- [ ] SSL/TLS enabled
- [ ] Input validation implemented
- [ ] Error messages don't expose sensitive data
- [ ] Logging doesn't include PII
- [ ] Third-party dependencies reviewed

## Performance Optimization

Before deployment:

- [ ] Images optimized and compressed
- [ ] Lazy loading implemented
- [ ] Caching configured
- [ ] Database queries optimized
- [ ] Network requests minimized
- [ ] App size optimized
- [ ] Startup time < 3 seconds
- [ ] Smooth animations (60 FPS)

## Compliance

Ensure compliance with:

- [ ] GDPR (if serving EU users)
- [ ] CCPA (if serving California users)
- [ ] App Store guidelines
- [ ] Play Store policies
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Data retention policy
- [ ] User data deletion process

---

**Last Updated**: January 26, 2026
**Version**: 1.0.0
**Status**: Production Ready

For questions or issues, please refer to the main [README.md](../README.md) or open an issue on GitHub.
