import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/enums.dart';
import '../models/user_profile.dart';
import '../../core/enums/enums.dart';
import '../../appwrite_options.dart';
import '../../services/target_registration_service.dart';
import '../../core/utils/logger.dart';

class AuthRepository {
  final Account _account;
  final TablesDB _databases; // Changed from _databases to _databases
  final Client _client;

  AuthRepository(this._account, this._databases, this._client);

  // Get current user session
  Future<models.User?> get currentUser async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> get isLoggedIn async {
    try {
      await _account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<models.User> signUp({
    required String email,
    required String password,
    required String fullName,
    required UserRole role,
  }) async {
    try {
      AppLogger.auth('Starting sign up process...', tag: 'AUTH');
      AppLogger.debug('Email: $email', tag: 'AUTH');
      AppLogger.debug('Name: $fullName', tag: 'AUTH');
      AppLogger.debug('Role: ${role.dbValue}', tag: 'AUTH');

      // Create user account
      AppLogger.debug('Step 1: Creating user account...', tag: 'AUTH');
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: fullName,
      );
      AppLogger.success(
        'User account created! User ID: ${user.$id}',
        tag: 'AUTH',
      );

      // Email verification temporarily disabled for development
      // TODO: Re-enable email verification in production
      // Create session temporarily to send verification email
      // print('   Step 2: Creating temporary session...');
      // await _account.createEmailPasswordSession(
      //   email: email,
      //   password: password,
      // );
      // print('   ✅ Temporary session created');

      // Send email verification
      // print('   Step 3: Sending verification email...');
      // await sendEmailVerification();
      // print('   ✅ Verification email sent!');

      // Create user profile in database
      AppLogger.debug(
        'Step 2: Creating user profile in database...',
        tag: 'AUTH',
      );
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        rowId: user.$id,
        data: {
          'email': email,
          'full_name': fullName,
          'role': role.dbValue,
          'is_verified': true, // Auto-verified for development
          'is_active': true,
        },
      );
      AppLogger.success('User profile created!', tag: 'AUTH');

      // Auto-login after signup for better UX (since email verification is disabled)
      AppLogger.debug('Step 3: Creating session for new user...', tag: 'AUTH');
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      AppLogger.success('Session created for new user!', tag: 'AUTH');

      // Register FCM target for push notifications
      try {
        AppLogger.notification(
          'Registering FCM target for new user: ${user.$id}',
          tag: 'AUTH',
        );

        await TargetRegistrationService.instance.registerCurrentUserTarget(
          userId: user.$id,
          appwriteClient: _client,
          account: _account,
        );

        AppLogger.success(
          'FCM target registration completed for new user',
          tag: 'AUTH',
        );
      } catch (targetError) {
        AppLogger.warning(
          'FCM target registration failed for new user (continuing signup)',
          tag: 'AUTH',
          error: targetError,
        );
        // Don't fail signup if target registration fails
      }

      AppLogger.success('Sign up completed successfully!', tag: 'AUTH');

      return user;
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Sign up failed',
        tag: 'AUTH',
        error: 'Code: ${e.code}, Type: ${e.type}, Message: ${e.message}',
      );
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected sign up error', tag: 'AUTH', error: e);
      throw Exception('Sign up failed: $e');
    }
  }

  Future<models.Session> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.auth('Attempting sign in for: $email', tag: 'AUTH');

      // Create session
      final session = await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      AppLogger.success(
        'Session created! Session ID: ${session.$id}',
        tag: 'AUTH',
      );

      // Register FCM target for push notifications
      try {
        final user = await _account.get();
        AppLogger.notification(
          'Registering FCM target for user: ${user.$id}',
          tag: 'AUTH',
        );

        await TargetRegistrationService.instance.registerCurrentUserTarget(
          userId: user.$id,
          appwriteClient: _client,
          account: _account,
        );

        AppLogger.success('FCM target registration completed', tag: 'AUTH');
      } catch (targetError) {
        AppLogger.warning(
          'FCM target registration failed (continuing login)',
          tag: 'AUTH',
          error: targetError,
        );
        // Don't fail login if target registration fails
      }

      // Email verification temporarily disabled for development
      // TODO: Re-enable email verification in production
      // Check email verification status
      // final user = await _account.get();
      // if (!user.emailVerification) {
      //   print('❌ [AUTH] Email not verified for: $email');
      //   // Delete the session since email is not verified
      //   await _account.deleteSession(sessionId: 'current');
      //   throw Exception(
      //     'Please verify your email before logging in. Check your inbox for the verification link.',
      //   );
      // }

      AppLogger.success('Sign in successful!', tag: 'AUTH');
      return session;
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Sign in failed',
        tag: 'AUTH',
        error: 'Code: ${e.code}, Type: ${e.type}, Message: ${e.message}',
      );
      throw Exception('Sign in failed: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected sign in error', tag: 'AUTH', error: e);
      throw Exception('Sign in failed: $e');
    }
  }

  Future<models.Session> signInWithGoogle() async {
    try {
      AppLogger.auth('Starting Google OAuth...', tag: 'AUTH');
      AppLogger.debug('Project ID: ${AppwriteOptions.projectId}', tag: 'AUTH');
      AppLogger.debug(
        'Database ID: ${AppwriteOptions.databaseId}',
        tag: 'AUTH',
      );
      AppLogger.debug('Endpoint: ${AppwriteOptions.endpoint}', tag: 'AUTH');

      // Log account object state
      AppLogger.debug('Account object: $_account', tag: 'AUTH');
      AppLogger.debug('Account type: ${_account.runtimeType}', tag: 'AUTH');

      // Check if we can access account before OAuth
      try {
        final preUser = await _account.get();
        AppLogger.warning(
          'User already logged in: ${preUser.$id}',
          tag: 'AUTH',
        );
        AppLogger.info('Logging out existing session first...', tag: 'AUTH');
        await _account.deleteSession(sessionId: 'current');
      } catch (e) {
        AppLogger.debug(
          'No existing session (expected for new login)',
          tag: 'AUTH',
        );
      }

      final successUrl =
          'appwrite-callback-${AppwriteOptions.projectId}://oauth2/success';
      final failureUrl =
          'appwrite-callback-${AppwriteOptions.projectId}://oauth2/failure';

      AppLogger.debug('Success URL: $successUrl', tag: 'AUTH');
      AppLogger.debug('Failure URL: $failureUrl', tag: 'AUTH');
      AppLogger.debug('Provider: Google', tag: 'AUTH');
      AppLogger.debug(
        'Provider enum value: ${OAuthProvider.google}',
        tag: 'AUTH',
      );
      AppLogger.debug(
        'Provider enum name: ${OAuthProvider.google.name}',
        tag: 'AUTH',
      );

      // Create OAuth2 session with custom callback URLs for mobile
      AppLogger.auth('Calling createOAuth2Session...', tag: 'AUTH');
      AppLogger.debug('Parameters:', tag: 'AUTH');
      AppLogger.debug('  - provider: ${OAuthProvider.google}', tag: 'AUTH');
      AppLogger.debug('  - success: $successUrl', tag: 'AUTH');
      AppLogger.debug('  - failure: $failureUrl', tag: 'AUTH');

      final result = await _account.createOAuth2Session(
        provider: OAuthProvider.google,
        success: successUrl,
        failure: failureUrl,
      );

      AppLogger.success(
        'createOAuth2Session returned successfully!',
        tag: 'AUTH',
      );
      AppLogger.debug('Result: $result', tag: 'AUTH');
      AppLogger.debug('Result type: ${result.runtimeType}', tag: 'AUTH');

      // Wait a moment for the OAuth flow to complete
      AppLogger.info('Waiting for OAuth flow to complete...', tag: 'AUTH');
      await Future.delayed(const Duration(seconds: 3));

      // Try to get the user
      AppLogger.debug('Attempting to get current user...', tag: 'AUTH');
      final user = await _account.get();
      AppLogger.success('User retrieved successfully!', tag: 'AUTH');
      AppLogger.debug('User ID: ${user.$id}', tag: 'AUTH');
      AppLogger.debug('Email: ${user.email}', tag: 'AUTH');
      AppLogger.debug('Name: ${user.name}', tag: 'AUTH');
      AppLogger.debug('Email Verified: ${user.emailVerification}', tag: 'AUTH');

      // Check if user profile exists, if not create it
      AppLogger.database('Checking if user profile exists...', tag: 'AUTH');
      try {
        final profile = await getUserProfile(user.$id);
        AppLogger.success('User profile already exists', tag: 'AUTH');
        AppLogger.debug('Profile ID: ${profile?.id}', tag: 'AUTH');
        AppLogger.debug('Profile Role: ${profile?.role}', tag: 'AUTH');
      } catch (e) {
        // Profile doesn't exist, create it
        AppLogger.database(
          'User profile not found, creating new profile...',
          tag: 'AUTH',
        );
        AppLogger.debug('Creating with:', tag: 'AUTH');
        AppLogger.debug('- Email: ${user.email}', tag: 'AUTH');
        AppLogger.debug('- Name: ${user.name}', tag: 'AUTH');
        AppLogger.debug('- Role: donor (default)', tag: 'AUTH');
        AppLogger.debug('- Verified: true (OAuth)', tag: 'AUTH');

        await _databases.createRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.userProfilesCollection,
          rowId: user.$id,
          data: {
            'email': user.email,
            'full_name': user.name,
            'role': 'donor', // Default role for OAuth users
            'is_verified': true, // OAuth users are auto-verified
            'is_active': true,
          },
        );
        AppLogger.success('User profile created successfully!', tag: 'AUTH');
      }

      // Get the session
      AppLogger.auth('Fetching active sessions...', tag: 'AUTH');
      final sessions = await _account.listSessions();
      AppLogger.debug(
        'Total sessions: ${sessions.sessions.length}',
        tag: 'AUTH',
      );

      if (sessions.sessions.isEmpty) {
        AppLogger.error('No sessions found after OAuth!', tag: 'AUTH');
        throw Exception('No session found after OAuth');
      }

      final session = sessions.sessions.first;
      AppLogger.success('Active session found!', tag: 'AUTH');
      AppLogger.debug('Session ID: ${session.$id}', tag: 'AUTH');
      AppLogger.debug('Provider: ${session.provider}', tag: 'AUTH');
      AppLogger.debug('Created: ${session.$createdAt}', tag: 'AUTH');

      // Register FCM target for push notifications
      try {
        AppLogger.notification(
          'Registering FCM target for Google OAuth user: ${user.$id}',
          tag: 'AUTH',
        );

        await TargetRegistrationService.instance.registerCurrentUserTarget(
          userId: user.$id,
          appwriteClient: _client,
          account: _account,
        );

        AppLogger.success(
          'FCM target registration completed for Google OAuth',
          tag: 'AUTH',
        );
      } catch (targetError) {
        AppLogger.warning(
          'FCM target registration failed for Google OAuth (continuing login)',
          tag: 'AUTH',
          error: targetError,
        );
        // Don't fail login if target registration fails
      }

      return session;
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Google OAuth failed with AppwriteException',
        tag: 'AUTH',
        error: 'Code: ${e.code}, Type: ${e.type}, Message: ${e.message}',
      );

      // Provide specific guidance based on error type
      if (e.message?.contains('Key and Secret') == true) {
        AppLogger.error(
          '"Key and Secret" error: Google OAuth provider is NOT properly configured',
          tag: 'AUTH',
        );
        AppLogger.info(
          'Please verify in Appwrite Console: https://cloud.appwrite.io/console/project-${AppwriteOptions.projectId}/auth',
          tag: 'AUTH',
        );
      } else if (e.message?.contains('region') == true ||
          e.message?.contains('endpoint') == true) {
        AppLogger.error(
          'Region/Endpoint error: Current endpoint: ${AppwriteOptions.endpoint}',
          tag: 'AUTH',
        );
      } else if (e.code == 401) {
        AppLogger.error(
          '401 Unauthorized: OAuth provider not enabled or invalid credentials',
          tag: 'AUTH',
        );
      } else if (e.code == 404) {
        AppLogger.error('404 Not Found: OAuth endpoint not found', tag: 'AUTH');
      }

      throw Exception('Google sign in failed: ${e.message}');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected Google OAuth error',
        tag: 'AUTH',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      AppLogger.auth('Signing out...', tag: 'AUTH');

      // Get current user before deleting session
      String? userId;
      try {
        final user = await _account.get();
        userId = user.$id;
      } catch (e) {
        AppLogger.warning(
          'Could not get current user for target cleanup',
          tag: 'AUTH',
          error: e,
        );
      }

      // Unregister FCM target
      if (userId != null) {
        try {
          AppLogger.notification(
            'Unregistering FCM target for user: $userId',
            tag: 'AUTH',
          );
          await TargetRegistrationService.instance.unregisterCurrentUserTarget(
            userId: userId,
          );
          AppLogger.success('FCM target unregistered', tag: 'AUTH');
        } catch (targetError) {
          AppLogger.warning(
            'FCM target unregistration failed (continuing logout)',
            tag: 'AUTH',
            error: targetError,
          );
        }
      }

      // Delete session
      await _account.deleteSession(sessionId: 'current');
      AppLogger.success('Session deleted successfully', tag: 'AUTH');
    } on AppwriteException catch (e) {
      // If user is already logged out (guests role), treat as success
      if (e.code == 401 || e.message?.contains('guests') == true) {
        AppLogger.info('User already logged out (guests role)', tag: 'AUTH');
        return; // Treat as successful sign out
      }
      AppLogger.error(
        'Sign out failed',
        tag: 'AUTH',
        error: 'Code: ${e.code}, Type: ${e.type}, Message: ${e.message}',
      );
      throw Exception('Sign out failed: ${e.message}');
    } catch (e) {
      AppLogger.error('Unexpected sign out error', tag: 'AUTH', error: e);
      throw Exception('Sign out failed: $e');
    }
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      AppLogger.database('Fetching user profile for: $userId', tag: 'AUTH');
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        rowId: userId,
      );

      AppLogger.success('User profile fetched successfully', tag: 'AUTH');
      return UserProfile.fromJson(response.data);
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to get user profile',
        tag: 'AUTH',
        error: 'Code: ${e.code}, Type: ${e.type}, Message: ${e.message}',
      );
      if (e.code == 404) return null;
      throw Exception('Failed to get user profile: ${e.message}');
    } catch (e) {
      AppLogger.error(
        'Unexpected error getting profile',
        tag: 'AUTH',
        error: e,
      );
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        rowId: profile.id,
        data: profile.toUpdateJson(), // Use toUpdateJson instead of toJson
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to update user profile: ${e.message}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'https://your-app-url.com/reset-password',
      );
    } on AppwriteException catch (e) {
      throw Exception('Password reset failed: ${e.message}');
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      AppLogger.auth('Sending email verification...', tag: 'AUTH');
      await _account.createEmailVerification(
        url: 'https://your-app-url.com/verify-email',
      );
      AppLogger.success('Verification email sent successfully', tag: 'AUTH');
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to send verification email',
        tag: 'AUTH',
        error: e.message,
      );
      throw Exception('Failed to send verification email: ${e.message}');
    }
  }

  // Check if current user's email is verified
  Future<bool> isEmailVerified() async {
    try {
      final user = await _account.get();
      return user.emailVerification;
    } catch (e) {
      return false;
    }
  }

  // Complete email verification with secret from email link
  Future<void> verifyEmail({
    required String userId,
    required String secret,
  }) async {
    try {
      AppLogger.auth('Verifying email...', tag: 'AUTH');
      await _account.updateEmailVerification(userId: userId, secret: secret);
      AppLogger.success('Email verified successfully!', tag: 'AUTH');
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Email verification failed',
        tag: 'AUTH',
        error: e.message,
      );
      throw Exception('Email verification failed: ${e.message}');
    }
  }

  // Update user profile verification status
  Future<void> updateUserVerificationStatus({
    required String userId,
    required bool isVerified,
  }) async {
    try {
      AppLogger.database('Updating user verification status...', tag: 'AUTH');
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        rowId: userId,
        data: {'is_verified': isVerified},
      );
      AppLogger.success('User verification status updated!', tag: 'AUTH');
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to update verification status',
        tag: 'AUTH',
        error: e.message,
      );
      throw Exception('Failed to update verification status: ${e.message}');
    }
  }

  // Get users by role (for notifications)
  Future<List<UserProfile>> getUsersByRole(UserRole role) async {
    try {
      AppLogger.database(
        'Fetching users with role: ${role.dbValue}',
        tag: 'AUTH',
      );
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        queries: [
          Query.equal('role', role.dbValue),
          Query.equal('is_active', true),
        ],
      );

      AppLogger.success('Found ${response.rows.length} users', tag: 'AUTH');
      return response.rows
          .map((doc) => UserProfile.fromJson(doc.data))
          .toList();
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to get users by role',
        tag: 'AUTH',
        error: e.message,
      );
      throw Exception('Failed to get users by role: ${e.message}');
    }
  }
}
