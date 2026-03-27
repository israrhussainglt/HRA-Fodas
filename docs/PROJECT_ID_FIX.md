# Project ID Configuration Fix

## Issue

The application was failing with error:
```
Code: 404, Type: database_not_found, Message: Database with the requested ID 'hra_fodas_main' could not be found.
```

## Root Cause

The `lib/core/constants/app_constants.dart` file had an **incorrect fallback project ID** hardcoded:

**Wrong Project ID**: `696cdfe8000b650ae9cf`  
**Correct Project ID**: `698457ea003c1c483173`

When the `.env` file wasn't loaded properly (especially on web), the app would fall back to the wrong project ID, causing it to look for the database in a non-existent project.

## Files Fixed

### 1. `lib/core/constants/app_constants.dart`
**Before**:
```dart
static String get appwriteProjectId =>
    _getEnv('APPWRITE_PROJECT_ID', '696cdfe8000b650ae9cf');
```

**After**:
```dart
static String get appwriteProjectId =>
    _getEnv('APPWRITE_PROJECT_ID', '698457ea003c1c483173');
```

### 2. `android/app/src/main/AndroidManifest.xml`
**Before**:
```xml
<data
    android:scheme="appwrite-callback-696cdfe8000b650ae9cf"
    android:host="oauth2"/>
```

**After**:
```xml
<data
    android:scheme="appwrite-callback-698457ea003c1c483173"
    android:host="oauth2"/>
```

## Verification

✅ Database `hra_fodas_main` exists in project `698457ea003c1c483173`  
✅ `.env` file has correct project ID  
✅ `appwrite_options.dart` correctly loads from `.env`  
✅ `app_constants.dart` now has correct fallback project ID  
✅ Android OAuth callback scheme updated

## Configuration Summary

**Correct Configuration**:
- **Appwrite Endpoint**: `https://nyc.cloud.appwrite.io/v1`
- **Project ID**: `698457ea003c1c483173`
- **Database ID**: `hra_fodas_main`

## Testing

After this fix:
1. Clear app cache/data
2. Restart the application
3. Sign in should work correctly
4. User profile should load successfully

## Related Files

- `.env` - Contains correct project ID
- `lib/appwrite_options.dart` - Loads from `.env`
- `lib/core/constants/app_constants.dart` - Fixed fallback value
- `android/app/src/main/AndroidManifest.xml` - Fixed OAuth callback

## Note

The schema migration performed earlier was **NOT** the cause of this issue. The database and all tables are intact and working correctly. This was purely a configuration mismatch in the fallback project ID.
