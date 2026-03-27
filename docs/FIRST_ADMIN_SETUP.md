# First-Run Admin Setup Feature

## Overview

The app now includes an automatic first-run admin setup screen that appears when no administrator account exists in the system. This ensures that the app can be deployed to a fresh database and the first admin can be created through the UI.

## How It Works

### 1. Automatic Detection

On every app launch, the router checks if an admin user exists:
- If **no admin exists** → Redirects to `/setup` screen
- If **admin exists** → Normal authentication flow

### 2. Setup Screen

The First Admin Setup screen (`/setup`) provides:
- Clean, professional UI with app branding
- Form validation for all fields
- Strong password requirements
- Security warnings
- One-time use (locked after first admin is created)

### 3. Admin Creation Process

When the form is submitted:

1. **Validation Check**: Verifies no admin exists (double-check)
2. **Create Auth Account**: Creates user in Appwrite Auth
3. **Create Profile**: Creates user profile with `role: 'admin'`
4. **Auto-Verification**: Admin is automatically verified
5. **Redirect to Login**: User can now login with admin credentials

## Password Requirements

The setup enforces strong passwords:
- Minimum 8 characters
- At least one uppercase letter
- At least one lowercase letter
- At least one number

## Security Features

### One-Time Setup
- Can only be used when **zero** admin users exist
- Once an admin is created, the setup is permanently locked
- Attempting to access `/setup` after admin exists redirects to login

### Error Handling
- If database check fails, assumes admin exists (fail-safe)
- Clear error messages for users
- Prevents accidental duplicate admin creation

### Auto-Verification
- Admin accounts are automatically verified
- No email verification required for first admin
- Immediate access after creation

## User Flow

```
App Launch
    ↓
Check for Admin
    ↓
┌─────────────────┐
│  No Admin?      │
└─────────────────┘
    ↓ Yes              ↓ No
    ↓                  ↓
Setup Screen      Login Screen
    ↓
Create Admin
    ↓
Login Screen
    ↓
Admin Dashboard
```

## Files Created/Modified

### New Files
- `lib/data/repositories/setup_repository.dart` - Admin check and creation logic
- `lib/ui/screens/setup/first_admin_setup_screen.dart` - Setup UI
- `docs/FIRST_ADMIN_SETUP.md` - This documentation

### Modified Files
- `lib/providers/providers.dart` - Added setup repository provider
- `lib/router/app_router.dart` - Added setup route and redirect logic

## API Reference

### SetupRepository

```dart
class SetupRepository {
  /// Check if any admin user exists
  Future<bool> hasAdminUser()
  
  /// Create the first admin user (only works if no admin exists)
  Future<models.User> createFirstAdmin({
    required String email,
    required String password,
    required String fullName,
  })
}
```

### Providers

```dart
// Check if admin exists
final hasAdminUserProvider = FutureProvider<bool>

// Setup repository
final setupRepositoryProvider = Provider<SetupRepository>
```

## Testing

### Test Scenario 1: Fresh Database
1. Deploy app with empty database
2. Launch app
3. Should automatically show setup screen
4. Create admin account
5. Should redirect to login
6. Login with admin credentials
7. Should see admin dashboard

### Test Scenario 2: Existing Admin
1. Launch app with existing admin
2. Should show login screen (not setup)
3. Attempting to navigate to `/setup` should redirect to login

### Test Scenario 3: Error Handling
1. Try to create admin with weak password
2. Should show validation errors
3. Try to create admin with existing email
4. Should show appropriate error message

## Deployment Checklist

When deploying to a new environment:

1. ✅ Ensure database schema is migrated
2. ✅ Update `.env` with new project credentials
3. ✅ Launch app - setup screen should appear
4. ✅ Create first admin account
5. ✅ Login and verify admin dashboard access
6. ✅ Verify setup screen is no longer accessible

## Troubleshooting

### Setup Screen Not Appearing
- Check database connection
- Verify `user_profiles` table exists
- Check console logs for errors

### Cannot Create Admin
- Verify Appwrite permissions allow user creation
- Check if email already exists
- Review Appwrite console for auth errors

### Setup Screen Still Appears After Creating Admin
- Verify admin profile was created in database
- Check `role` field is set to `'admin'`
- Restart app to refresh provider cache

## Future Enhancements

Potential improvements:
- [ ] Email verification for admin (optional)
- [ ] Multi-step setup wizard
- [ ] Organization details collection
- [ ] Initial configuration settings
- [ ] Setup completion email
- [ ] Admin invitation system (for additional admins)

## Security Considerations

1. **Production Deployment**: Consider requiring email verification for admin
2. **Password Policy**: Current requirements are basic - consider stronger policies
3. **Rate Limiting**: Add rate limiting to prevent brute force attempts
4. **Audit Logging**: Log admin creation events
5. **2FA**: Consider adding two-factor authentication for admin accounts

## Related Documentation

- [Admin Dashboard Setup](./ADMIN_SETUP_COMPLETE.md)
- [Security Configuration](./SECURITY_CONFIGURATION.md)
- [Deployment Guide](./DEPLOYMENT_GUIDE.md)

---

**Version**: 1.0.0  
**Date**: January 27, 2026  
**Status**: Production Ready ✅
