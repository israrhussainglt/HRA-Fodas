import 'package:appwrite/appwrite.dart';
import '../models/meal_planner_models.dart';
import '../../appwrite_options.dart';

class MealPlannerRepository {
  final TablesDB _databases; // Changed from Databases to TablesDB
  final Realtime _realtime;

  MealPlannerRepository(this._databases, this._realtime);

  // Meal Plans

  /// Get all meal plans for a user
  Stream<List<MealPlan>> getMealPlans(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get current active meal plan
  Stream<MealPlan?> getCurrentMealPlan(String userId) async* {
    // TODO: Implement Appwrite Realtime subscriptions
    yield null;
  }

  /// Get meal plan by ID
  Future<MealPlan?> getMealPlanById(String mealPlanId) async {
    try {
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'meal_plans',
        rowId: mealPlanId,
      );

      return MealPlan.fromJson({...response.data, 'id': response.$id});
    } catch (e) {
      return null;
    }
  }

  /// Create a new meal plan
  Future<MealPlan> createMealPlan({
    required String userId,
    required String title,
    String? description,
    required String planType,
    required DateTime startDate,
    required DateTime endDate,
    int? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? totalFiber,
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_plans',
      rowId: ID.unique(),
      data: {
        'user_id': userId,
        'title': title,
        'description': description,
        'plan_type': planType,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'total_calories': totalCalories,
        'total_protein': totalProtein,
        'total_carbs': totalCarbs,
        'total_fat': totalFat,
        'total_fiber': totalFiber,
        'is_active': true,
      },
    );

    return MealPlan.fromJson({...response.data, 'id': response.$id});
  }

  /// Update meal plan
  Future<void> updateMealPlan(
    String mealPlanId,
    Map<String, dynamic> updates,
  ) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_plans',
      rowId: mealPlanId,
      data: updates,
    );
  }

  /// Delete meal plan
  Future<void> deleteMealPlan(String mealPlanId) async {
    await _databases.deleteRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_plans',
      rowId: mealPlanId,
    );
  }

  // Meals

  /// Get all meals for a meal plan
  Stream<List<Meal>> getMeals(String mealPlanId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get meals for a specific date
  Future<List<Meal>> getMealsByDate(String mealPlanId, DateTime date) async {
    final response = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meals',
      queries: [
        Query.equal('meal_plan_id', mealPlanId),
        Query.equal('meal_date', date.toIso8601String().split('T')[0]),
        Query.orderAsc('meal_type'),
      ],
    );

    return response.rows
        .map((doc) => Meal.fromJson({...doc.data, 'id': doc.$id}))
        .toList();
  }

  /// Create a new meal
  Future<Meal> createMeal({
    required String mealPlanId,
    required String mealType,
    required DateTime mealDate,
    required String recipeName,
    required List<MealIngredient> ingredients,
    List<String>? instructions,
    int? cookingTimeMinutes,
    int? prepTimeMinutes,
    int? servings,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    VitaminsMinerals? vitaminsMinerals,
    String? recipeImageUrl,
    String? notes,
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meals',
      rowId: ID.unique(),
      data: {
        'meal_plan_id': mealPlanId,
        'meal_type': mealType,
        'meal_date': mealDate.toIso8601String().split('T')[0],
        'recipe_name': recipeName,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'instructions': instructions ?? [],
        'cooking_time_minutes': cookingTimeMinutes,
        'prep_time_minutes': prepTimeMinutes,
        'servings': servings ?? 1,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
        'vitamins_minerals': vitaminsMinerals?.toJson(),
        'recipe_image_url': recipeImageUrl,
        'notes': notes,
      },
    );

    return Meal.fromJson({...response.data, 'id': response.$id});
  }

  /// Update meal
  Future<void> updateMeal(String mealId, Map<String, dynamic> updates) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meals',
      rowId: mealId,
      data: updates,
    );
  }

  /// Delete meal
  Future<void> deleteMeal(String mealId) async {
    await _databases.deleteRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meals',
      rowId: mealId,
    );
  }

  // Grocery Lists

  /// Get all grocery lists for a user
  Stream<List<GroceryList>> getGroceryLists(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Create grocery list from meal plan
  Future<GroceryList> createGroceryList({
    required String userId,
    required String mealPlanId,
    required String listName,
    required List<GroceryListItem> items,
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'grocery_lists',
      rowId: ID.unique(),
      data: {
        'user_id': userId,
        'meal_plan_id': mealPlanId,
        'list_name': listName,
        'items': items.map((i) => i.toJson()).toList(),
        'is_completed': false,
      },
    );

    return GroceryList.fromJson({...response.data, 'id': response.$id});
  }

  /// Update grocery list
  Future<void> updateGroceryList(
    String listId,
    Map<String, dynamic> updates,
  ) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'grocery_lists',
      rowId: listId,
      data: updates,
    );
  }

  /// Delete grocery list
  Future<void> deleteGroceryList(String listId) async {
    await _databases.deleteRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'grocery_lists',
      rowId: listId,
    );
  }

  // Meal Plan Templates

  /// Get user's meal plan templates
  Stream<List<MealPlanTemplate>> getMealPlanTemplates(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get public meal plan templates
  Stream<List<MealPlanTemplate>> getPublicMealPlanTemplates() {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Create meal plan template
  Future<MealPlanTemplate> createMealPlanTemplate({
    required String userId,
    required String templateName,
    String? description,
    required List<Map<String, dynamic>> meals,
    List<String>? dietaryTags,
    bool isPublic = false,
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_plan_templates',
      rowId: ID.unique(),
      data: {
        'user_id': userId,
        'template_name': templateName,
        'description': description,
        'meals': meals,
        'dietary_tags': dietaryTags ?? [],
        'is_public': isPublic,
        'usage_count': 0,
      },
    );

    return MealPlanTemplate.fromJson({...response.data, 'id': response.$id});
  }

  /// Update template usage count
  Future<void> incrementTemplateUsage(String templateId) async {
    try {
      final doc = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'meal_plan_templates',
        rowId: templateId,
      );

      final currentCount = doc.data['usage_count'] as int? ?? 0;
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'meal_plan_templates',
        rowId: templateId,
        data: {'usage_count': currentCount + 1},
      );
    } catch (e) {
      // Ignore errors
    }
  }

  /// Delete meal plan template
  Future<void> deleteMealPlanTemplate(String templateId) async {
    await _databases.deleteRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_plan_templates',
      rowId: templateId,
    );
  }

  // Conversations

  /// Get user's meal planner conversations
  Stream<List<MealPlannerConversation>> getConversations(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get conversation by ID
  Future<MealPlannerConversation?> getConversationById(
    String conversationId,
  ) async {
    try {
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'meal_planner_conversations',
        rowId: conversationId,
      );

      return MealPlannerConversation.fromJson({
        ...response.data,
        'id': response.$id,
      });
    } catch (e) {
      return null;
    }
  }

  /// Create new conversation
  Future<MealPlannerConversation> createConversation({
    required String userId,
    String? conversationTitle,
    List<MealPlannerMessage>? messages,
    String? modelUsed,
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_planner_conversations',
      rowId: ID.unique(),
      data: {
        'user_id': userId,
        'conversation_title': conversationTitle,
        'messages': messages?.map((m) => m.toJson()).toList() ?? [],
        'model_used': modelUsed,
      },
    );

    return MealPlannerConversation.fromJson({
      ...response.data,
      'id': response.$id,
    });
  }

  /// Update conversation
  Future<void> updateConversation(
    String conversationId,
    Map<String, dynamic> updates,
  ) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_planner_conversations',
      rowId: conversationId,
      data: updates,
    );
  }

  /// Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    await _databases.deleteRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'meal_planner_conversations',
      rowId: conversationId,
    );
  }
}
