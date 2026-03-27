import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_planner_models.freezed.dart';
part 'meal_planner_models.g.dart';

// User Dietary Profile Model
@freezed
class UserDietaryProfile with _$UserDietaryProfile {
  const factory UserDietaryProfile({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'household_size') @Default(1) int householdSize,
    @JsonKey(name: 'dietary_preferences') @Default([]) List<String> dietaryPreferences,
    @Default([]) List<String> allergies,
    @JsonKey(name: 'health_conditions') @Default([]) List<String> healthConditions,
    @JsonKey(name: 'cultural_preferences') @Default([]) List<String> culturalPreferences,
    @JsonKey(name: 'budget_range') String? budgetRange,
    @JsonKey(name: 'preferred_language') @Default('English') String preferredLanguage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserDietaryProfile;

  factory UserDietaryProfile.fromJson(Map<String, dynamic> json) =>
      _$UserDietaryProfileFromJson(json);
}

// Meal Plan Model
@freezed
class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    String? description,
    @JsonKey(name: 'plan_type') required String planType, // 'daily', 'weekly', 'monthly'
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'total_calories') int? totalCalories,
    @JsonKey(name: 'total_protein') double? totalProtein,
    @JsonKey(name: 'total_carbs') double? totalCarbs,
    @JsonKey(name: 'total_fat') double? totalFat,
    @JsonKey(name: 'total_fiber') double? totalFiber,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);
}

// Meal Ingredient Model
@freezed
class MealIngredient with _$MealIngredient {
  const factory MealIngredient({
    required String name,
    required double quantity,
    required String unit,
    @JsonKey(name: 'from_donation') @Default(false) bool fromDonation,
  }) = _MealIngredient;

  factory MealIngredient.fromJson(Map<String, dynamic> json) =>
      _$MealIngredientFromJson(json);
}

// Vitamins and Minerals Model
@freezed
class VitaminsMinerals with _$VitaminsMinerals {
  const factory VitaminsMinerals({
    @JsonKey(name: 'vitamin_a') double? vitaminA,
    @JsonKey(name: 'vitamin_c') double? vitaminC,
    @JsonKey(name: 'vitamin_d') double? vitaminD,
    double? calcium,
    double? iron,
    double? potassium,
    double? sodium,
  }) = _VitaminsMinerals;

  factory VitaminsMinerals.fromJson(Map<String, dynamic> json) =>
      _$VitaminsMineralsFromJson(json);
}

// Meal Model
@freezed
class Meal with _$Meal {
  const factory Meal({
    required String id,
    @JsonKey(name: 'meal_plan_id') required String mealPlanId,
    @JsonKey(name: 'meal_type') required String mealType, // 'breakfast', 'lunch', 'dinner', 'snack'
    @JsonKey(name: 'meal_date') required DateTime mealDate,
    @JsonKey(name: 'recipe_name') required String recipeName,
    @Default([]) List<MealIngredient> ingredients,
    @Default([]) List<String> instructions,
    @JsonKey(name: 'cooking_time_minutes') int? cookingTimeMinutes,
    @JsonKey(name: 'prep_time_minutes') int? prepTimeMinutes,
    @Default(1) int servings,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    @JsonKey(name: 'vitamins_minerals') VitaminsMinerals? vitaminsMinerals,
    @JsonKey(name: 'recipe_image_url') String? recipeImageUrl,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}

// Food Inventory Item Model
@freezed
class FoodInventoryItem with _$FoodInventoryItem {
  const factory FoodInventoryItem({
    required String id,
    @JsonKey(name: 'donation_id') String? donationId,
    @JsonKey(name: 'recipient_id') required String recipientId,
    @JsonKey(name: 'food_item') required String foodItem,
    required double quantity,
    required String unit,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    String? category,
    @JsonKey(name: 'nutritional_info') Map<String, dynamic>? nutritionalInfo,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'used_quantity') @Default(0.0) double usedQuantity,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _FoodInventoryItem;

  factory FoodInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$FoodInventoryItemFromJson(json);
}

// Meal Planner Message Model
@freezed
class MealPlannerMessage with _$MealPlannerMessage {
  const factory MealPlannerMessage({
    required String role, // 'user' or 'assistant'
    required String content,
    required DateTime timestamp,
  }) = _MealPlannerMessage;

  factory MealPlannerMessage.fromJson(Map<String, dynamic> json) =>
      _$MealPlannerMessageFromJson(json);
}

// Meal Planner Conversation Model
@freezed
class MealPlannerConversation with _$MealPlannerConversation {
  const factory MealPlannerConversation({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'conversation_title') String? conversationTitle,
    @Default([]) List<MealPlannerMessage> messages,
    @JsonKey(name: 'model_used') String? modelUsed,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MealPlannerConversation;

  factory MealPlannerConversation.fromJson(Map<String, dynamic> json) =>
      _$MealPlannerConversationFromJson(json);
}

// Meal Plan Template Model
@freezed
class MealPlanTemplate with _$MealPlanTemplate {
  const factory MealPlanTemplate({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'template_name') required String templateName,
    String? description,
    @Default([]) List<Map<String, dynamic>> meals,
    @JsonKey(name: 'dietary_tags') @Default([]) List<String> dietaryTags,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,
    @JsonKey(name: 'usage_count') @Default(0) int usageCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _MealPlanTemplate;

  factory MealPlanTemplate.fromJson(Map<String, dynamic> json) =>
      _$MealPlanTemplateFromJson(json);
}

// Grocery List Item Model
@freezed
class GroceryListItem with _$GroceryListItem {
  const factory GroceryListItem({
    required String item,
    required double quantity,
    required String unit,
    String? category,
    @Default(false) bool checked,
    @JsonKey(name: 'from_donation') @Default(false) bool fromDonation,
  }) = _GroceryListItem;

  factory GroceryListItem.fromJson(Map<String, dynamic> json) =>
      _$GroceryListItemFromJson(json);
}

// Grocery List Model
@freezed
class GroceryList with _$GroceryList {
  const factory GroceryList({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'meal_plan_id') required String mealPlanId,
    @JsonKey(name: 'list_name') required String listName,
    @Default([]) List<GroceryListItem> items,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _GroceryList;

  factory GroceryList.fromJson(Map<String, dynamic> json) =>
      _$GroceryListFromJson(json);
}

// Expiring Inventory Item (for helper function)
@freezed
class ExpiringInventoryItem with _$ExpiringInventoryItem {
  const factory ExpiringInventoryItem({
    required String id,
    @JsonKey(name: 'food_item') required String foodItem,
    required double quantity,
    required String unit,
    @JsonKey(name: 'expiry_date') required DateTime expiryDate,
    @JsonKey(name: 'days_until_expiry') required int daysUntilExpiry,
  }) = _ExpiringInventoryItem;

  factory ExpiringInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$ExpiringInventoryItemFromJson(json);
}

// Available Inventory Item (for helper function)
@freezed
class AvailableInventoryItem with _$AvailableInventoryItem {
  const factory AvailableInventoryItem({
    required String id,
    @JsonKey(name: 'food_item') required String foodItem,
    required double quantity,
    required String unit,
    String? category,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
  }) = _AvailableInventoryItem;

  factory AvailableInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$AvailableInventoryItemFromJson(json);
}
