import 'package:appwrite/appwrite.dart';
import '../models/meal_planner_models.dart';
import '../../appwrite_options.dart';

class DietaryProfileRepository {
  final TablesDB _databases; // Changed from Databases to TablesDB
  final Realtime _realtime;

  DietaryProfileRepository(this._databases, this._realtime);

  /// Get user's dietary profile
  Stream<UserDietaryProfile?> getUserDietaryProfile(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value(null);
  }

  /// Get dietary profile by ID
  Future<UserDietaryProfile?> getDietaryProfileById(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        queries: [Query.equal('user_id', userId)],
      );

      if (response.rows.isEmpty) return null;
      return UserDietaryProfile.fromJson({
        ...response.rows.first.data,
        'id': response.rows.first.$id,
      });
    } catch (e) {
      return null;
    }
  }

  /// Create dietary profile
  Future<UserDietaryProfile> createDietaryProfile({
    required String userId,
    int householdSize = 1,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    List<String>? healthConditions,
    List<String>? culturalPreferences,
    String? budgetRange,
    String preferredLanguage = 'English',
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      rowId: ID.unique(),
      data: {
        'user_id': userId,
        'household_size': householdSize,
        'dietary_preferences': dietaryPreferences ?? [],
        'allergies': allergies ?? [],
        'health_conditions': healthConditions ?? [],
        'cultural_preferences': culturalPreferences ?? [],
        'budget_range': budgetRange,
        'preferred_language': preferredLanguage,
      },
    );

    return UserDietaryProfile.fromJson({...response.data, 'id': response.$id});
  }

  /// Update dietary profile
  Future<UserDietaryProfile> updateDietaryProfile({
    required String userId,
    int? householdSize,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    List<String>? healthConditions,
    List<String>? culturalPreferences,
    String? budgetRange,
    String? preferredLanguage,
  }) async {
    final updates = <String, dynamic>{};

    if (householdSize != null) updates['household_size'] = householdSize;
    if (dietaryPreferences != null) {
      updates['dietary_preferences'] = dietaryPreferences;
    }
    if (allergies != null) updates['allergies'] = allergies;
    if (healthConditions != null) {
      updates['health_conditions'] = healthConditions;
    }
    if (culturalPreferences != null) {
      updates['cultural_preferences'] = culturalPreferences;
    }
    if (budgetRange != null) updates['budget_range'] = budgetRange;
    if (preferredLanguage != null) {
      updates['preferred_language'] = preferredLanguage;
    }

    // Get existing profile
    final existing = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    if (existing.rows.isEmpty) {
      throw Exception('Dietary profile not found');
    }

    final response = await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      rowId: existing.rows.first.$id,
      data: updates,
    );

    return UserDietaryProfile.fromJson({...response.data, 'id': response.$id});
  }

  /// Add dietary preference
  Future<void> addDietaryPreference(String userId, String preference) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final preferences = List<String>.from(profile.dietaryPreferences);
    if (!preferences.contains(preference)) {
      preferences.add(preference);

      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        queries: [Query.equal('user_id', userId)],
      );

      if (existing.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'user_dietary_profiles',
          rowId: existing.rows.first.$id,
          data: {'dietary_preferences': preferences},
        );
      }
    }
  }

  /// Remove dietary preference
  Future<void> removeDietaryPreference(String userId, String preference) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final preferences = List<String>.from(profile.dietaryPreferences);
    preferences.remove(preference);

    final existing = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    if (existing.rows.isNotEmpty) {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        rowId: existing.rows.first.$id,
        data: {'dietary_preferences': preferences},
      );
    }
  }

  /// Add allergy
  Future<void> addAllergy(String userId, String allergy) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final allergies = List<String>.from(profile.allergies);
    if (!allergies.contains(allergy)) {
      allergies.add(allergy);

      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        queries: [Query.equal('user_id', userId)],
      );

      if (existing.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'user_dietary_profiles',
          rowId: existing.rows.first.$id,
          data: {'allergies': allergies},
        );
      }
    }
  }

  /// Remove allergy
  Future<void> removeAllergy(String userId, String allergy) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final allergies = List<String>.from(profile.allergies);
    allergies.remove(allergy);

    final existing = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    if (existing.rows.isNotEmpty) {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        rowId: existing.rows.first.$id,
        data: {'allergies': allergies},
      );
    }
  }

  /// Add health condition
  Future<void> addHealthCondition(String userId, String condition) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final conditions = List<String>.from(profile.healthConditions);
    if (!conditions.contains(condition)) {
      conditions.add(condition);

      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        queries: [Query.equal('user_id', userId)],
      );

      if (existing.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'user_dietary_profiles',
          rowId: existing.rows.first.$id,
          data: {'health_conditions': conditions},
        );
      }
    }
  }

  /// Remove health condition
  Future<void> removeHealthCondition(String userId, String condition) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final conditions = List<String>.from(profile.healthConditions);
    conditions.remove(condition);

    final existing = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    if (existing.rows.isNotEmpty) {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        rowId: existing.rows.first.$id,
        data: {'health_conditions': conditions},
      );
    }
  }

  /// Add cultural preference
  Future<void> addCulturalPreference(String userId, String preference) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final preferences = List<String>.from(profile.culturalPreferences);
    if (!preferences.contains(preference)) {
      preferences.add(preference);

      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        queries: [Query.equal('user_id', userId)],
      );

      if (existing.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'user_dietary_profiles',
          rowId: existing.rows.first.$id,
          data: {'cultural_preferences': preferences},
        );
      }
    }
  }

  /// Remove cultural preference
  Future<void> removeCulturalPreference(
    String userId,
    String preference,
  ) async {
    final profile = await getDietaryProfileById(userId);
    if (profile == null) return;

    final preferences = List<String>.from(profile.culturalPreferences);
    preferences.remove(preference);

    final existing = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    if (existing.rows.isNotEmpty) {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        rowId: existing.rows.first.$id,
        data: {'cultural_preferences': preferences},
      );
    }
  }

  /// Delete dietary profile
  Future<void> deleteDietaryProfile(String userId) async {
    final existing = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    if (existing.rows.isNotEmpty) {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'user_dietary_profiles',
        rowId: existing.rows.first.$id,
      );
    }
  }

  /// Check if user has dietary profile
  Future<bool> hasDietaryProfile(String userId) async {
    final response = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'user_dietary_profiles',
      queries: [Query.equal('user_id', userId)],
    );

    return response.rows.isNotEmpty;
  }
}
