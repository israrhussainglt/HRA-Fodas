# Security Configuration Guide

## Overview

All sensitive credentials and API keys are now stored in the `.env` file instead of being hardcoded in the source code. This improves security by:

1. **Preventing credential exposure** in version control
2. **Enabling environment-specific configurations** (dev, staging, production)
3. **Making credential rotation easier** without code changes
4. **Following security best practices** for credential management

## Files Updated

### 1. `lib/appwrite_options.dart`
- **Before**: Hardcoded Appwrite credentials
- **After**: Loads from environment variables using `flutter_dotenv`
- **Variables used**:
  - `APPWRITE_ENDPOINT`
  - `APPWRITE_PROJECT_ID`
  - `APPWRITE_DATABASE_ID`

### 2. `lib/firebase_options.dart`
- **Before**: Hardcoded Firebase credentials for all platforms
- **After**: Loads from environment variables using `flutter_dotenv`
- **Variables used**:
  - `FIREBASE_PROJECT_ID`
  - `FIREBASE_MESSAGING_SENDER_ID`
  - `FIREBASE_STORAGE_BUCKET`
  - `FIREBASE_AUTH_DOMAIN`
  - `FIREBASE_WEB_API_KEY` / `FIREBASE_WEB_APP_ID`
  - `FIREBASE_ANDROID_API_KEY` / `FIREBASE_ANDROID_APP_ID`
  - `FIREBASE_IOS_API_KEY` / `FIREBASE_IOS_APP_ID` / `FIREBASE_IOS_BUNDLE_ID`

### 3. `.env`
- **Updated**: Added all Firebase configuration variables
- **Security**: This file is already in `.gitignore` and won't be committed

### 4. `.env.example`
- **Updated**: Added Firebase configuration template
- **Purpose**: Serves as a template for new developers

## Setup Instructions

### For New Developers

1. **Copy the example file**:
   ```bash
   copy .env.example .env
   ```

2. **Fill in your credentials**:
   - Get Appwrite credentials from [Appwrite Console](https://cloud.appwrite.io)
   - Get Firebase credentials from [Firebase Console](https://console.firebase.google.com)

3. **Never commit `.env`**:
   - The `.env` file is already in `.gitignore`
   - Always use `.env.example` as a template

### For Existing Developers

Your existing `.env` file has been updated with the Firebase credentials that were previously hardcoded. No action needed unless you want to rotate credentials.

## Security Best Practices

### ✅ DO:
- Keep `.env` file in `.gitignore`
- Use different credentials for development and production
- Rotate API keys regularly
- Limit API key permissions to minimum required
- Monitor API usage for suspicious activity
- Use environment-specific `.env` files (`.env.dev`, `.env.prod`)

### ❌ DON'T:
- Commit `.env` file to version control
- Share credentials via email or chat
- Use production credentials in development
- Hardcode credentials in source code
- Store credentials in screenshots or documentation

## Credential Rotation

If you need to rotate credentials:

1. **Update in provider console** (Appwrite/Firebase)
2. **Update `.env` file** with new values
3. **Restart the app** to load new credentials
4. **No code changes required**

## Environment-Specific Configuration

For different environments (dev, staging, production):

1. **Create environment-specific files**:
   - `.env.dev` - Development
   - `.env.staging` - Staging
   - `.env.prod` - Production

2. **Load appropriate file** in `main.dart`:
   ```dart
   await dotenv.load(fileName: ".env.${environment}");
   ```

3. **Use build flavors** to automatically select the right environment

## Troubleshooting

### App crashes on startup
- **Cause**: Missing or invalid `.env` file
- **Solution**: Ensure `.env` exists and contains all required variables

### Empty credentials
- **Cause**: `.env` file not loaded before accessing variables
- **Solution**: Verify `dotenv.load()` is called in `main()` before any credential access

### Wrong credentials used
- **Cause**: Using wrong environment file
- **Solution**: Check which `.env` file is being loaded in `main.dart`

## Additional Resources

- [Flutter Dotenv Package](https://pub.dev/packages/flutter_dotenv)
- [Appwrite Security Best Practices](https://appwrite.io/docs/security)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)

## Questions?

If you have questions about security configuration, please:
1. Check this documentation first
2. Review `.env.example` for required variables
3. Contact the team lead for credential access
