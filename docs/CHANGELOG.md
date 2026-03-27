# Changelog

All notable changes to HRA-FoDAS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-17

### Added
- 🎉 Initial production release
- ✅ Complete food donation management system
- ✅ Multi-role support (Donor, Volunteer, Recipient, Admin)
- ✅ Real-time push notifications via Firebase FCM
- ✅ In-app chat system
- ✅ Google Maps integration for delivery tracking
- ✅ Inventory management for recipients
- ✅ Analytics dashboard for admins
- ✅ Feedback and rating system
- 🤖 AI-powered meal planner with local LLM support
- 🔧 LLM configuration settings (Ollama integration)
- 📱 Support for multiple AI models (llama3.2, mistral, mixtral, phi3, gemma2)
- 🥗 Dietary preference management
- 🍽️ Recipe generation with nutritional information
- 📊 Meal plan database schema
- 🔐 Row Level Security on all database tables
- 🔔 Notification badge with unread counts
- 📸 Image upload for donations
- 🗺️ Location-based donation search
- 📈 Delivery statistics and history
- 🔄 Real-time status updates

### Features by Role

#### Donors
- Create and manage food donations
- Upload photos of food items
- Set pickup times and locations
- Track donation status in real-time
- View delivery history
- Receive push notifications for status updates
- Access AI meal planner for recipe suggestions

#### Volunteers
- Browse available donations
- Accept delivery assignments
- Update delivery status (Scheduled → Picked Up → Delivered)
- View delivery history and statistics
- Receive instant push notifications for new donations
- In-app chat with donors and recipients
- Access AI meal planner

#### Recipients (NGOs)
- Browse and request donations
- Track incoming deliveries
- Manage food inventory
- Get alerts for expiring items
- View delivery history
- Access AI meal planner for meal planning
- Generate recipes based on available inventory

#### Admins
- Comprehensive analytics dashboard
- User management
- Monitor all donations and deliveries
- Generate reports
- System-wide notifications

### Technical Stack
- Flutter 3.10.4+
- Dart 3.0.0+
- Supabase (Backend, Auth, Storage, Realtime)
- Firebase Cloud Messaging (Push Notifications)
- Riverpod 2.6.1 (State Management)
- GoRouter 14.6.2 (Navigation)
- Dio 5.7.0 (HTTP Client)
- Ollama (Local LLM Integration)
- Google Maps Flutter
- Freezed (Code Generation)

### Database Schema
- user_profiles
- donations
- deliveries
- notifications
- fcm_tokens
- notification_preferences
- conversations
- messages
- inventory
- feedback_ratings
- analytics_data
- meal_plans
- meals
- dietary_profiles
- food_inventory
- grocery_lists
- meal_plan_templates

### Security
- Environment variables for sensitive data
- Row Level Security (RLS) on all tables
- Role-based access control
- Secure authentication via Supabase Auth
- Firebase service account for FCM
- Proper .gitignore configuration

### Documentation
- Comprehensive README.md
- Detailed SETUP_GUIDE.md
- CONTRIBUTING.md guidelines
- DEPLOYMENT_CHECKLIST.md
- PRODUCTION_CHECKLIST.md
- Example configuration files

### Known Limitations
- AI meal planner requires local Ollama installation
- Push notifications require Firebase configuration
- Google Maps requires API key
- iOS build requires macOS

## [Unreleased]

### Planned Features
- Multi-language support
- Dark mode
- Offline mode improvements
- Advanced analytics
- Export functionality
- Scheduled donations
- Recurring donations
- Donation templates
- Advanced search filters
- Donation categories
- Nutrition tracking
- Meal plan sharing
- Recipe favorites
- Shopping list generation

---

For more details, see the [README](README.md) and [SETUP_GUIDE](SETUP_GUIDE.md).
