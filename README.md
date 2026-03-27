# 🍱 HRA-FoDAS - Food Donation & Distribution System

A comprehensive Flutter mobile application for iOS and Android that manages food donations, connecting donors with recipients through volunteer delivery services. Built with Flutter, Appwrite, Firebase Cloud Messaging, and AI-powered meal planning.

[![Flutter](https://img.shields.io/badge/Flutter-3.38.5+-02569B?logo=flutter)](https://flutter.dev)
[![Appwrite](https://img.shields.io/badge/Appwrite-Backend-F02E65?logo=appwrite)](https://appwrite.io)
[![Firebase](https://img.shields.io/badge/Firebase-FCM-FFCA28?logo=firebase)](https://firebase.google.com)
[![Production Ready](https://img.shields.io/badge/Status-Production%20Ready-success)](https://github.com)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue)](https://flutter.dev)

## ✨ Features

### 👨‍🌾 For Donors
- ✅ Create and manage food donation listings with photos
- ✅ Set pickup times, locations, and expiry dates
- ✅ Real-time donation status tracking
- ✅ Push notifications for status updates
- ✅ Search and filter donation history
- ✅ View delivery completion and feedback
- ✅ Google OAuth sign-in
- ✅ AI-powered meal planner

### 🚚 For Volunteers
- ✅ Browse available donations with search/filter
- ✅ Real-time push notifications for new donations
- ✅ Accept delivery assignments
- ✅ Update delivery status (Scheduled → Picked Up → Delivered)
- ✅ Track delivery history and statistics
- ✅ In-app chat with donors and recipients
- ✅ Notification badge with unread count
- ✅ Route optimization with maps

### 🏢 For Recipients (NGOs/Organizations)
- ✅ Browse and request available donations
- ✅ Track incoming deliveries
- ✅ Inventory management system
- ✅ Expiring items alerts
- ✅ Low stock notifications
- ✅ Delivery history and analytics
- ✅ AI-powered meal planner with dietary preferences

### 🤖 AI Meal Planner
- ✅ Chat-based interface for meal planning
- ✅ Ingredient management with custom additions
- ✅ Dietary preference selection (Vegetarian, Vegan, Halal, Keto, etc.)
- ✅ OpenRouter API integration with multiple AI models
- ✅ Free models available (Llama 3.2, Mistral, Gemma 2, Phi-3)
- ✅ Recipe generation with nutritional information
- ✅ Markdown-formatted responses
- ✅ Multi-language support
- ✅ Available for all user roles

### 👨‍💼 For Admins
- ✅ Comprehensive analytics dashboard
- ✅ User management and role assignment
- ✅ Monitor all donations and deliveries
- ✅ Generate reports and statistics
- ✅ System-wide notifications

### 🔐 Security & Production Features
- ✅ Structured logging with AppLogger (production-ready)
- ✅ No debug prints in production code
- ✅ Role-based access control
- ✅ Secure session management
- ✅ Environment-based configuration
- ✅ Firebase Cloud Messaging (FCM) for push notifications
- ✅ Proper error handling throughout
- ✅ User feedback for all actions

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: 3.38.5 or higher
- **Dart SDK**: 3.10.4 or higher
- **Android Studio** or **VS Code** with Flutter extensions
- **Appwrite Account**: [Sign up here](https://cloud.appwrite.io)
- **Firebase Account**: For push notifications
- **OpenRouter API Key** (Optional): For AI meal planner - [Get here](https://openrouter.ai)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/hra-fodas.git
   cd hra-fodas
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your credentials:
   ```env
   # Appwrite Configuration
   APPWRITE_ENDPOINT=https://nyc.cloud.appwrite.io/v1
   APPWRITE_PROJECT_ID=hra-fodas-main
   APPWRITE_DATABASE_ID=hra_fodas_main
   
   # Firebase Configuration
   FIREBASE_PROJECT_ID=hra-fodas-main
   FIREBASE_MESSAGING_SENDER_ID=your-sender-id
   FIREBASE_STORAGE_BUCKET=hra-fodas-main.firebasestorage.app
   FIREBASE_WEB_API_KEY=your-api-key
   FIREBASE_ANDROID_API_KEY=your-api-key
   FIREBASE_IOS_API_KEY=your-api-key
   
   # App Configuration
   APP_NAME=HRA-FoDAS
   APP_TAGLINE=Food Donation & Distribution Platform
   ```

4. **Set up Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Add Android app with package name: `com.hrafodas.food_donation_app`
   - Download `google-services.json` and place in `android/app/`
   - Add iOS app with bundle ID: `com.hrafodas.food_donation_app` (optional)
   - Download `GoogleService-Info.plist` and place in `ios/Runner/` (optional)
   - Generate service account key and save as `config/firebase_service_account.json`
   - Enable Firebase Cloud Messaging (FCM)

5. **Set up Appwrite**

   a. **Create Appwrite Project**
   - Go to [Appwrite Console](https://cloud.appwrite.io)
   - Create a new project
   - Copy the Project ID to your `.env` file

   b. **Create Database**
   - Go to Databases → Create Database
   - Name it `hra_fodas_main`
   - Copy the Database ID to your `.env` file

   c. **Import Database Schema**
   - Use the provided schema files in `database/` folder
   - Run `database/create_appwrite_schema.js` to create all collections
   - Or manually create collections using `database/tables_schema.json`

   d. **Configure Permissions**
   - **IMPORTANT**: Configure permissions for each collection:
     - **Read**: `users` (any authenticated user)
     - **Create**: `users`
     - **Update**: `users`
     - **Delete**: `users` ⚠️ **REQUIRED for notifications and donations**

6. **Create First Admin User**
   - Run the app for the first time
   - You'll see the First-Time Setup screen
   - Create your admin account
   - This screen will only appear once (locked after first admin is created)

7. **Run the app**
   ```bash
   # For Android
   flutter run

   # For release build
   flutter run --release
   ```

## 📱 Building Production APK

### Quick Build Scripts

We've provided convenient batch scripts in the `scripts/` folder:

```bash
# Build standard release APK
scripts\build-release.bat

# Build split APKs (smaller sizes, recommended)
scripts\build-split-apk.bat

# Run code generation (Freezed, JSON Serializable)
scripts\run-codegen.bat

# Deploy Appwrite functions
scripts\deploy-functions.bat
```

### Manual Build Commands

### Generate App Icon
Your logo at `assets/icons/logo.png` will be used as the app icon.

```bash
# Generate icons
dart run flutter_launcher_icons
```

### Build Release APK

```bash
# Clean build
flutter clean

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (for Play Store)

```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Build Split APKs (Smaller Size)

```bash
flutter build apk --split-per-abi --release

# Outputs:
# - app-armeabi-v7a-release.apk (32-bit ARM)
# - app-arm64-v8a-release.apk (64-bit ARM) ← Most common
# - app-x86_64-release.apk (64-bit Intel)
```

## 🗄️ Database Schema

### Core Collections

#### user_profiles
- User information and roles
- Fields: `id`, `email`, `full_name`, `role`, `phone`, `address`, `avatar_url`, `is_verified`, `created_at`

#### donations
- Food donation listings
- Fields: `id`, `donor_id`, `title`, `description`, `food_type`, `quantity`, `unit`, `expiry_date`, `pickup_location`, `status`, `images`, `created_at`

#### deliveries
- Delivery assignments and tracking
- Fields: `id`, `donation_id`, `volunteer_id`, `recipient_id`, `status`, `pickup_time`, `delivery_time`, `notes`

#### notifications
- In-app and push notifications
- Fields: `id`, `user_id`, `type`, `title`, `message`, `is_read`, `related_entity_id`, `created_at`
- **⚠️ IMPORTANT**: Must have DELETE permission for users

#### fcm_tokens
- Firebase Cloud Messaging device tokens
- Fields: `id`, `user_id`, `token`, `device_name`, `is_active`, `created_at`

#### conversations
- Chat conversations between users
- Fields: `id`, `participant_ids`, `last_message`, `last_message_at`, `created_at`

#### messages
- Chat messages
- Fields: `id`, `conversation_id`, `sender_id`, `content`, `is_read`, `created_at`

#### inventory
- Recipient inventory management
- Fields: `id`, `recipient_id`, `food_item`, `quantity`, `unit`, `expiry_date`, `status`

### Required Permissions

All collections must have these permissions configured in Appwrite Console:

```
Read: users
Create: users
Update: users
Delete: users  ⚠️ CRITICAL - Required for delete functionality
```

## 🔧 Configuration

### Appwrite Configuration

File: `lib/appwrite_options.dart`

```dart
class AppwriteOptions {
  static const String endpoint = 'https://nyc.cloud.appwrite.io/v1';
  static const String projectId = '696cdfe8000b650ae9cf';
  static const String databaseId = 'hra_fodas_main';
  
  // Collection IDs
  static const String userProfilesCollection = 'user_profiles';
  static const String donationsCollection = 'donations';
  static const String notificationsCollection = 'notifications';
  // ... more collections
}
```

### Firebase Configuration

Files:
- `android/app/google-services.json` (Download from Firebase Console)
- `lib/firebase_options.dart` (Auto-generated or manual)

### Logging Configuration

The app uses structured logging with `AppLogger`:

```dart
// Info logging
AppLogger.info('User logged in', tag: 'AUTH');

// Success logging
AppLogger.success('Profile updated', tag: 'PROFILE');

// Error logging
AppLogger.error('Failed to load data', tag: 'DATA', error: e);

// Warning logging
AppLogger.warning('Network slow', tag: 'NETWORK');

// Debug logging (only in debug mode)
AppLogger.debug('Debug info', tag: 'DEBUG');
```

## 🏗️ Architecture

### Tech Stack

- **Frontend**: Flutter 3.38.5 (Dart 3.10.4)
- **State Management**: Riverpod 2.6.1
- **Navigation**: GoRouter 14.6.2
- **Backend**: Appwrite (Database + Auth + Storage + Realtime)
- **Push Notifications**: Firebase Cloud Messaging (FCM)
- **AI Integration**: OpenRouter API (Multiple LLM providers)
- **HTTP Client**: Dio 5.7.0
- **Maps**: Flutter Map (OpenStreetMap)
- **Local Notifications**: flutter_local_notifications 18.0.1
- **Image Handling**: image_picker, cached_network_image
- **Code Generation**: Freezed, json_serializable, riverpod_generator

## 🏗️ Project Structure

```
hra-fodas/
├── android/              # Android native code
├── ios/                  # iOS native code
├── assets/               # Images, icons, fonts
├── lib/                  # Flutter application code
│   ├── core/            # Core utilities, theme, constants
│   ├── data/            # Models and repositories
│   ├── providers/       # Riverpod state management
│   ├── router/          # Navigation configuration
│   ├── services/        # Firebase, notifications, AI
│   └── ui/              # Screens and widgets
├── functions/           # Appwrite serverless functions
├── config/              # Configuration files (JSON)
│   ├── appwrite.json
│   ├── appwrite.config.json
│   ├── firebase.json
│   └── firebase_service_account.json  ⚠️ NOT in git
├── database/            # Database schema and scripts
│   ├── appwrite_schema.json
│   ├── tables_schema.json
│   ├── create_appwrite_schema.js
│   ├── create_admin_user.js
│   ├── verify_appwrite_schema.js
│   ├── README.md
│   └── SCHEMA_MAPPING.md
├── docs/                # Documentation files
│   ├── CHANGELOG.md
│   ├── CONTRIBUTING.md
│   ├── DEPLOYMENT_GUIDE.md
│   ├── FIREBASE_MIGRATION_COMPLETE.md
│   ├── FIRST_ADMIN_SETUP.md
│   ├── NGO_REQUESTS_FEATURE.md
│   ├── NGO_REQUESTS_TESTING_GUIDE.md
│   ├── NOTIFICATION_WORKFLOW_SYSTEM.md
│   ├── PROJECT_STRUCTURE.md
│   ├── QUICK_START.md
│   ├── REALTIME_AUTO_REFRESH.md
│   ├── SECURITY_CONFIGURATION.md
│   └── SECURITY_FIX_CREDENTIALS.md
├── scripts/             # Build and deployment scripts
│   ├── build-release.bat
│   ├── build-split-apk.bat
│   ├── run-codegen.bat
│   ├── deploy-functions.bat
│   ├── update-firebase-config.bat
│   └── verify-migration.bat
├── creds/               # Credentials folder (NOT in git)
│   ├── google-services siddman.json
│   └── hra-fodas-main-firebase-adminsdk-*.json
├── .env                 # Environment variables ⚠️ NOT in git
├── .env.example         # Environment variables template
├── .gitignore           # Git ignore rules
├── pubspec.yaml         # Flutter dependencies
└── README.md            # This file
```

## 🧪 Testing

### Test Accounts

Create test accounts with different roles:

1. **Donor Account**
   - Email: donor@test.com
   - Password: test1234
   - Role: donor

2. **Volunteer Account**
   - Email: volunteer@test.com
   - Password: test1234
   - Role: volunteer

3. **Recipient Account**
   - Email: recipient@test.com
   - Password: test1234
   - Role: recipient

### Testing Checklist

- [ ] User registration and login
- [ ] Profile editing (name, phone, address)
- [ ] Create donation
- [ ] Accept delivery (volunteer)
- [ ] Update delivery status
- [ ] Push notifications
- [ ] Mark notification as read
- [ ] Delete notification
- [ ] Delete all notifications
- [ ] Mark all as read
- [ ] Chat functionality
- [ ] AI meal planner
- [ ] Map integration
- [ ] Image uploads

## 🚨 Known Issues & Solutions

### Issue: Delete Notifications/Donations Fails

**Error**: `AppwriteException: user_unauthorized (401)`

**Solution**: Configure DELETE permissions in Appwrite Console

1. Go to your Appwrite Console
2. Navigate to Database → Collections
3. For each collection (notifications, donations):
   - Click Settings → Permissions
   - Add DELETE permission for "Users" role
   - Save changes

**Direct Links**:
- [Notifications Collection Settings](https://cloud.appwrite.io/console/project-696cdfe8000b650ae9cf/databases/database-hra_fodas_main/collection-notifications/settings)
- [Donations Collection Settings](https://cloud.appwrite.io/console/project-696cdfe8000b650ae9cf/databases/database-hra_fodas_main/collection-donations/settings)

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Backend & Auth
  appwrite: ^20.3.3
  
  # State Management
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  
  # Navigation
  go_router: ^14.6.2
  
  # Firebase
  firebase_core: ^3.6.0
  firebase_messaging: ^15.1.3
  
  # Notifications
  flutter_local_notifications: ^18.0.1
  
  # HTTP & Network
  dio: ^5.7.0
  http: ^1.2.1
  connectivity_plus: ^6.1.1
  
  # Maps & Location
  flutter_map: ^7.0.2
  latlong2: ^0.9.1
  geolocator: ^13.0.2
  geocoding: ^3.0.0
  
  # UI Components
  flutter_svg: ^2.0.16
  shimmer: ^3.0.0
  fl_chart: ^0.69.2
  cached_network_image: ^3.4.1
  
  # Image Handling
  image_picker: ^1.1.2
  
  # Storage
  shared_preferences: ^2.3.4
  hive_flutter: ^1.1.0
  path_provider: ^2.1.5
  
  # Utils
  intl: ^0.20.1
  uuid: ^4.5.1
  equatable: ^2.0.7
  timeago: ^3.7.0
  flutter_dotenv: ^5.2.1
  crypto: ^3.0.6
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.13
  json_serializable: ^6.8.0
  freezed: ^2.5.7
  riverpod_generator: ^2.6.2
  flutter_launcher_icons: ^0.14.2
```

## 🔐 Security Best Practices

### Credentials Management

1. **Never commit sensitive files**:
   - `.env` - Environment variables
   - `config/firebase_service_account.json` - Firebase service account
   - `android/app/google-services.json` - Android Firebase config
   - `ios/Runner/GoogleService-Info.plist` - iOS Firebase config
   - `android/key.properties` - Android signing keys
   - `android/app/upload-keystore.jks` - Android keystore
   - `creds/` folder - All credential files

2. **Use environment variables** for all sensitive data:
   - All credentials loaded from `.env` file
   - Firebase service account loaded from external JSON file
   - No hardcoded credentials in source code

3. **Git Protection**:
   - All sensitive files are in `.gitignore`
   - Use `.env.example` as template for team members
   - Never commit actual credentials

### Appwrite Security

1. **Enable proper permissions**:
   - Row-level security for sensitive data
   - Collection-level permissions for shared data
   - **DELETE permission required** for notifications and donations

2. **Role-based access control**:
   - Admin: Full system access
   - Donor: Create and manage donations
   - Volunteer: Accept and manage deliveries
   - Recipient: Request donations and manage inventory

### Code Security

1. **Structured logging** instead of print statements:
   - Use `AppLogger` for all logging
   - No `print()` or `debugPrint()` in production code
   - Sensitive data never logged

2. **Proper error handling**:
   - Try-catch blocks around async operations
   - User-friendly error messages
   - Detailed logging for debugging (without sensitive data)

3. **Firebase credentials**:
   - Service account loaded from external file at runtime
   - Not hardcoded in source code
   - Protected by `.gitignore`

### Production Deployment

1. **Firebase Admin Service**:
   - Move to backend service (Appwrite Function or Cloud Function)
   - Never include service account in client app
   - Use server-side API for push notifications

2. **API Keys**:
   - Use environment-specific keys
   - Rotate keys regularly
   - Monitor usage in Firebase/Appwrite consoles

3. **App Signing**:
   - Use proper signing keys for production
   - Store keys securely (not in repository)
   - Enable Play App Signing for Android

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` before committing
- Use `AppLogger` for all logging (no print statements)
- Add comments for complex logic
- Write meaningful commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Appwrite for the backend infrastructure
- Firebase for push notifications
- OpenRouter for AI integration
- All contributors and testers

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/hra-fodas/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/hra-fodas/discussions)
- **Email**: support@hrafodas.com

## 🌟 Project Status

✅ **Production Ready** - Version 1.0.0

- All features implemented and tested
- Production-level logging
- Proper error handling
- User feedback for all actions
- No debug prints
- Optimized APK build
- Ready for deployment

---

**Made with ❤️ for reducing food waste and helping communities**
