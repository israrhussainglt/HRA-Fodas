# HRA-FoDAS Project Structure

## Overview

HRA-FoDAS is a production-ready Flutter mobile application (iOS & Android) for food donation management. This document provides a comprehensive overview of the project structure and organization.

## Root Directory Structure

```
hra-fodas/
├── android/              # Android native code and configuration
├── ios/                  # iOS native code and configuration
├── assets/               # Static assets (images, icons)
├── lib/                  # Flutter application source code
├── functions/            # Appwrite serverless functions
├── config/               # Configuration files (JSON)
├── docs/                 # Project documentation
├── scripts/              # Build and deployment scripts
├── .env.example          # Environment variables template
├── pubspec.yaml          # Flutter dependencies
└── README.md             # Main documentation
```

## Application Code Structure (`lib/`)

### Core (`lib/core/`)
Foundation layer containing shared utilities and configurations.

```
core/
├── constants/           # App-wide constants
│   ├── app_constants.dart
│   ├── web_env_stub.dart
│   └── web_env_web.dart
├── enums/              # Enumerations
│   └── enums.dart      # UserRole, DonationStatus, etc.
├── theme/              # UI theming
│   └── app_theme.dart  # Colors, text styles, themes
└── utils/              # Utility functions
    └── logger.dart     # Structured logging (AppLogger)
```

### Data Layer (`lib/data/`)
Data models and repository pattern for data access.

```
data/
├── models/             # Data models (Freezed + JSON Serializable)
│   ├── admin_report.dart
│   ├── analytics_data.dart
│   ├── chat_message.dart
│   ├── delivery.dart
│   ├── donation.dart
│   ├── feedback_rating.dart
│   ├── inventory_item.dart
│   ├── meal_planner_models.dart
│   ├── ngo_request.dart
│   ├── notification_model.dart
│   ├── route_models.dart
│   ├── trust_score.dart
│   └── user_profile.dart
└── repositories/       # Data access layer
    ├── admin_repository.dart
    ├── analytics_repository.dart
    ├── auth_repository.dart
    ├── chat_repository.dart
    ├── delivery_repository.dart
    ├── dietary_profile_repository.dart
    ├── donation_repository.dart
    ├── feedback_repository.dart
    ├── food_inventory_repository.dart
    ├── inventory_repository.dart
    ├── meal_planner_repository.dart
    ├── ngo_request_repository.dart
    ├── notification_repository.dart
    └── route_repository.dart
```

### State Management (`lib/providers/`)
Riverpod providers for state management.

```
providers/
├── admin_providers.dart        # Admin dashboard state
├── meal_planner_providers.dart # AI meal planner state
├── providers.dart              # Core providers (auth, user, etc.)
└── route_providers.dart        # Route optimization state
```

### Navigation (`lib/router/`)
GoRouter configuration for app navigation.

### Services (`lib/services/`)
Business logic and external service integrations.

```
services/
├── appwrite_notification_service.dart      # Appwrite notifications
├── automatic_push_processor.dart           # Auto push processing
├── background_location_service.dart        # Background location
├── cross_device_notification_service.dart  # Multi-device sync
├── directions_service.dart                 # Map directions
├── enhanced_notification_service.dart      # Enhanced notifications
├── firebase_admin_service.dart             # Firebase admin SDK
├── geocoding_service.dart                  # Address geocoding
├── geofencing_service.dart                 # Geofencing
├── location_service.dart                   # Location tracking
├── maps_service.dart                       # Maps integration
├── meal_planner_history_service.dart       # Meal history
├── openrouter_service.dart                 # AI integration
├── route_optimization_service.dart         # Route optimization
├── target_registration_service.dart        # FCM target registration
├── tile_cache_service.dart                 # Map tile caching
├── traffic_aware_routing_service.dart      # Traffic routing
└── voice_input_service.dart                # Voice recognition
```

### User Interface (`lib/ui/`)
All UI components organized by feature.

```
ui/
├── screens/            # Full-screen views
│   ├── admin/         # Admin dashboard and management
│   ├── auth/          # Login, register, verification
│   ├── chat/          # Chat and conversations
│   ├── debug/         # Debug and testing screens
│   ├── delivery/      # Delivery tracking
│   ├── donation/      # Donation details
│   ├── donor/         # Donor dashboard and actions
│   ├── feedback/      # Feedback submission
│   ├── home/          # Home screen
│   ├── meal_planner/  # AI meal planner
│   ├── notifications/ # Notifications list
│   ├── profile/       # User profile and settings
│   ├── recipient/     # Recipient dashboard and inventory
│   ├── route/         # Route planning and maps
│   ├── settings/      # App settings
│   └── volunteer/     # Volunteer dashboard and map
└── widgets/           # Reusable UI components
    ├── donation_card.dart
    ├── enhanced_map_widget.dart
    ├── feedback_rating_widget.dart
    ├── notification_badge.dart
    ├── notification_popup.dart
    ├── place_search_widget.dart
    ├── simple_labeled_map.dart
    ├── stats_card.dart
    └── voice_wave_animation.dart
```

## Backend Functions (`functions/`)

Appwrite serverless functions for backend processing.

```
functions/
├── donation-events/        # Donation event handlers
│   ├── src/
│   │   └── main.js
│   ├── package.json
│   └── package-lock.json
└── notification-sender/    # Push notification sender
    ├── src/
    │   └── main.js
    ├── package.json
    └── package-lock.json
```

## Documentation (`docs/`)

Project documentation and guides.

```
docs/
├── ADMIN_SETUP_COMPLETE.md           # Admin setup guide
├── CHANGELOG.md                       # Version history
├── CONTRIBUTING.md                    # Contribution guidelines
├── NOTIFICATION_WORKFLOW_SYSTEM.md   # Notification workflows
├── QUICK_START.md                     # Quick start guide
└── PROJECT_STRUCTURE.md               # This file
```

## Build Scripts (`scripts/`)

Convenient batch scripts for common tasks.

```
scripts/
├── build-release.bat      # Build standard release APK
├── build-split-apk.bat    # Build split APKs (smaller)
├── run-codegen.bat        # Run Freezed/JSON code generation
└── deploy-functions.bat   # Deploy Appwrite functions
```

## Configuration Files

### Configuration Directory (`config/`)
All JSON configuration files are organized in the `config/` folder:

```
config/
├── appwrite.json              # Appwrite CLI configuration
├── appwrite.config.json       # Appwrite project settings
├── firebase.json              # Firebase configuration
├── firebase_service_account.json  # Firebase admin credentials (not in git)
├── package.json               # Node.js dependencies for functions
└── package-lock.json          # Node.js dependency lock file
```

### Flutter Configuration
- `pubspec.yaml` - Dependencies and assets
- `analysis_options.yaml` - Dart analyzer rules
- `devtools_options.yaml` - DevTools configuration

### Environment
- `.env` - Environment variables (not in git)
- `.env.example` - Environment template

### Build Configuration
- `android/` - Android build configuration
- `ios/` - iOS build configuration

## Key Features by Module

### Authentication & User Management
- **Files**: `lib/data/repositories/auth_repository.dart`, `lib/ui/screens/auth/`
- **Features**: Login, register, email verification, role-based access

### Donation Management
- **Files**: `lib/data/repositories/donation_repository.dart`, `lib/ui/screens/donor/`, `lib/ui/screens/donation/`
- **Features**: Create, edit, track donations with status workflow

### Delivery System
- **Files**: `lib/data/repositories/delivery_repository.dart`, `lib/ui/screens/volunteer/`, `lib/ui/screens/delivery/`
- **Features**: Accept deliveries, track status, route optimization

### Notifications
- **Files**: `lib/services/*notification*.dart`, `lib/ui/screens/notifications/`
- **Features**: Push notifications, in-app notifications, multi-device sync

### Admin Dashboard
- **Files**: `lib/ui/screens/admin/`, `lib/data/repositories/admin_repository.dart`
- **Features**: Analytics, user management, reports, feedback moderation

### AI Meal Planner
- **Files**: `lib/services/openrouter_service.dart`, `lib/ui/screens/meal_planner/`
- **Features**: AI-powered meal planning with dietary preferences

### Chat System
- **Files**: `lib/data/repositories/chat_repository.dart`, `lib/ui/screens/chat/`
- **Features**: Real-time messaging between users

### Inventory Management
- **Files**: `lib/data/repositories/inventory_repository.dart`, `lib/ui/screens/recipient/`
- **Features**: Track received items, expiry alerts, low stock notifications

## Development Workflow

### 1. Code Generation
Run when models change:
```bash
scripts\run-codegen.bat
```

### 2. Local Development
```bash
flutter run
```

### 3. Build Release
```bash
scripts\build-release.bat
# or
scripts\build-split-apk.bat
```

### 4. Deploy Functions
```bash
scripts\deploy-functions.bat
```

## Architecture Patterns

### State Management
- **Pattern**: Riverpod with code generation
- **Location**: `lib/providers/`
- **Usage**: Reactive state management with dependency injection

### Data Layer
- **Pattern**: Repository pattern
- **Location**: `lib/data/repositories/`
- **Usage**: Abstraction over Appwrite API calls

### Models
- **Pattern**: Freezed + JSON Serializable
- **Location**: `lib/data/models/`
- **Usage**: Immutable data classes with JSON serialization

### Navigation
- **Pattern**: Declarative routing with GoRouter
- **Location**: `lib/router/`
- **Usage**: Type-safe navigation with deep linking

### Logging
- **Pattern**: Structured logging with AppLogger
- **Location**: `lib/core/utils/logger.dart`
- **Usage**: Production-ready logging with tags and levels

## Best Practices

1. **No print statements** - Use `AppLogger` for all logging
2. **Structured error handling** - Try-catch with user feedback
3. **Immutable models** - Use Freezed for all data models
4. **Repository pattern** - All data access through repositories
5. **Provider pattern** - State management with Riverpod
6. **Type safety** - Leverage Dart's strong typing
7. **Code generation** - Use build_runner for boilerplate
8. **Environment variables** - Never commit sensitive data
9. **Documentation** - Comment complex logic
10. **Testing** - Write tests for critical paths

## Platform Support

- ✅ **Android**: Minimum SDK 24 (Android 7.0)
- ✅ **iOS**: Minimum iOS 12.0
- ❌ **Web**: Not supported
- ❌ **Desktop**: Not supported (Windows, macOS, Linux removed)

## Dependencies Overview

### Core
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `appwrite` - Backend services
- `firebase_core` + `firebase_messaging` - Push notifications

### UI
- `flutter_map` - Maps
- `fl_chart` - Charts
- `shimmer` - Loading effects
- `cached_network_image` - Image caching

### Data
- `freezed` + `json_serializable` - Model generation
- `shared_preferences` - Local storage
- `hive_flutter` - Local database

### Services
- `geolocator` + `geocoding` - Location services
- `dio` + `http` - HTTP clients
- `speech_to_text` - Voice input
- `flutter_local_notifications` - Local notifications

## Security Considerations

1. **Environment Variables**: All sensitive data in `.env`
2. **Appwrite Permissions**: Row-level security configured
3. **Firebase Rules**: Secure FCM token storage
4. **No Hardcoded Secrets**: Use environment variables
5. **Secure Storage**: Sensitive data encrypted
6. **API Keys**: Never commit to git
7. **User Authentication**: Session-based with Appwrite
8. **Role-Based Access**: Enforced at repository level

## Deployment Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Run code generation: `scripts\run-codegen.bat`
- [ ] Test on physical devices (Android + iOS)
- [ ] Build release APK: `scripts\build-release.bat`
- [ ] Test release APK on devices
- [ ] Update `CHANGELOG.md`
- [ ] Create git tag for version
- [ ] Deploy Appwrite functions: `scripts\deploy-functions.bat`
- [ ] Update Firebase configuration if needed
- [ ] Submit to app stores

---

**Last Updated**: January 26, 2026
**Version**: 1.0.0
**Status**: Production Ready
