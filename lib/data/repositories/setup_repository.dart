import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../../appwrite_options.dart';
import '../../core/utils/logger.dart';

class SetupRepository {
  final TablesDB _databases;
  final Account _account;

  SetupRepository(this._databases, this._account);

  /// Check if any admin user exists in the system
  Future<bool> hasAdminUser() async {
    try {
      AppLogger.info('Checking if admin user exists...', tag: 'SETUP');

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        queries: [Query.equal('role', 'admin'), Query.limit(1)],
      );

      final hasAdmin = response.rows.isNotEmpty;
      AppLogger.info(
        'Admin check result: ${hasAdmin ? "Admin exists" : "No admin found"}',
        tag: 'SETUP',
      );

      return hasAdmin;
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to check for admin user',
        tag: 'SETUP',
        error: 'Code: ${e.code}, Message: ${e.message}',
      );
      // If we can't check, assume admin exists to prevent accidental creation
      return true;
    } catch (e) {
      AppLogger.error(
        'Unexpected error checking admin',
        tag: 'SETUP',
        error: e,
      );
      return true;
    }
  }

  /// Create the first admin user (only works if no admin exists)
  Future<models.User> createFirstAdmin({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      AppLogger.auth('Creating first admin user...', tag: 'SETUP');

      // Double-check no admin exists in database
      final hasAdmin = await hasAdminUser();
      if (hasAdmin) {
        throw Exception(
          'Admin user already exists. Cannot create another admin through setup.',
        );
      }

      models.User user;
      bool accountAlreadyExists = false;

      // Step 1: Try to create user account
      AppLogger.debug('Step 1: Creating admin account...', tag: 'SETUP');
      try {
        user = await _account.create(
          userId: ID.unique(),
          email: email,
          password: password,
          name: fullName,
        );
        AppLogger.success('Admin account created: ${user.$id}', tag: 'SETUP');
      } on AppwriteException catch (e) {
        // If user already exists (409), we need to handle it
        if (e.code == 409) {
          accountAlreadyExists = true;
          AppLogger.warning(
            'User account already exists in Auth, will create profile only',
            tag: 'SETUP',
          );

          // Try to login to get the user ID
          try {
            final session = await _account.createEmailPasswordSession(
              email: email,
              password: password,
            );
            user = await _account.get();
            AppLogger.success(
              'Retrieved existing account: ${user.$id}',
              tag: 'SETUP',
            );

            // Check if this user already has a profile
            try {
              final existingProfile = await _databases.getRow(
                databaseId: AppwriteOptions.databaseId,
                tableId: AppwriteOptions.userProfilesCollection,
                rowId: user.$id,
              );

              // Logout the session we just created
              await _account.deleteSession(sessionId: session.$id);

              // If profile exists, check if it's admin
              if (existingProfile.data['role'] == 'admin') {
                throw Exception(
                  'This email already has an admin account. Please login instead.',
                );
              } else {
                throw Exception(
                  'This email is already registered with a different role. Please use a different email.',
                );
              }
            } on AppwriteException catch (profileError) {
              // Profile doesn't exist (404), we can create it
              if (profileError.code == 404) {
                AppLogger.info(
                  'No profile found for existing account, will create admin profile',
                  tag: 'SETUP',
                );
                // Logout the session
                await _account.deleteSession(sessionId: session.$id);
              } else {
                // Logout the session
                await _account.deleteSession(sessionId: session.$id);
                rethrow;
              }
            }
          } catch (loginError) {
            if (loginError is AppwriteException) {
              throw Exception(
                'User account exists but credentials are incorrect. Please use the correct password.',
              );
            }
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      // Step 2: Create user profile with admin role
      AppLogger.debug('Step 2: Creating admin profile...', tag: 'SETUP');
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        rowId: user.$id,
        data: {
          'email': email,
          'full_name': fullName,
          'role': 'admin',
          'is_verified': true, // Admin is auto-verified
          'is_active': true,
        },
      );
      AppLogger.success('Admin profile created!', tag: 'SETUP');

      if (accountAlreadyExists) {
        AppLogger.success(
          '🎉 Admin profile linked to existing account!',
          tag: 'SETUP',
        );
      } else {
        AppLogger.success(
          '🎉 First admin user created successfully!',
          tag: 'SETUP',
        );
      }

      return user;
    } on AppwriteException catch (e) {
      AppLogger.error(
        'Failed to create admin user',
        tag: 'SETUP',
        error: 'Code: ${e.code}, Message: ${e.message}',
      );
      throw Exception('Failed to create admin user: ${e.message}');
    } catch (e) {
      AppLogger.error(
        'Unexpected error creating admin',
        tag: 'SETUP',
        error: e,
      );
      throw Exception('Failed to create admin user: $e');
    }
  }
}
