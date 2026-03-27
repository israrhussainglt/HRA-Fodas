// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_planner_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDietaryProfileImpl _$$UserDietaryProfileImplFromJson(
  Map<String, dynamic> json,
) => _$UserDietaryProfileImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  householdSize: (json['household_size'] as num?)?.toInt() ?? 1,
  dietaryPreferences:
      (json['dietary_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  allergies:
      (json['allergies'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  healthConditions:
      (json['health_conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  culturalPreferences:
      (json['cultural_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  budgetRange: json['budget_range'] as String?,
  preferredLanguage: json['preferred_language'] as String? ?? 'English',
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$UserDietaryProfileImplToJson(
  _$UserDietaryProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'household_size': instance.householdSize,
  'dietary_preferences': instance.dietaryPreferences,
  'allergies': instance.allergies,
  'health_conditions': instance.healthConditions,
  'cultural_preferences': instance.culturalPreferences,
  'budget_range': instance.budgetRange,
  'preferred_language': instance.preferredLanguage,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$MealPlanImpl _$$MealPlanImplFromJson(Map<String, dynamic> json) =>
    _$MealPlanImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      planType: json['plan_type'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalCalories: (json['total_calories'] as num?)?.toInt(),
      totalProtein: (json['total_protein'] as num?)?.toDouble(),
      totalCarbs: (json['total_carbs'] as num?)?.toDouble(),
      totalFat: (json['total_fat'] as num?)?.toDouble(),
      totalFiber: (json['total_fiber'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MealPlanImplToJson(_$MealPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'plan_type': instance.planType,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'total_calories': instance.totalCalories,
      'total_protein': instance.totalProtein,
      'total_carbs': instance.totalCarbs,
      'total_fat': instance.totalFat,
      'total_fiber': instance.totalFiber,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$MealIngredientImpl _$$MealIngredientImplFromJson(Map<String, dynamic> json) =>
    _$MealIngredientImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      fromDonation: json['from_donation'] as bool? ?? false,
    );

Map<String, dynamic> _$$MealIngredientImplToJson(
  _$MealIngredientImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'from_donation': instance.fromDonation,
};

_$VitaminsMineralsImpl _$$VitaminsMineralsImplFromJson(
  Map<String, dynamic> json,
) => _$VitaminsMineralsImpl(
  vitaminA: (json['vitamin_a'] as num?)?.toDouble(),
  vitaminC: (json['vitamin_c'] as num?)?.toDouble(),
  vitaminD: (json['vitamin_d'] as num?)?.toDouble(),
  calcium: (json['calcium'] as num?)?.toDouble(),
  iron: (json['iron'] as num?)?.toDouble(),
  potassium: (json['potassium'] as num?)?.toDouble(),
  sodium: (json['sodium'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$VitaminsMineralsImplToJson(
  _$VitaminsMineralsImpl instance,
) => <String, dynamic>{
  'vitamin_a': instance.vitaminA,
  'vitamin_c': instance.vitaminC,
  'vitamin_d': instance.vitaminD,
  'calcium': instance.calcium,
  'iron': instance.iron,
  'potassium': instance.potassium,
  'sodium': instance.sodium,
};

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
  id: json['id'] as String,
  mealPlanId: json['meal_plan_id'] as String,
  mealType: json['meal_type'] as String,
  mealDate: DateTime.parse(json['meal_date'] as String),
  recipeName: json['recipe_name'] as String,
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => MealIngredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  instructions:
      (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  cookingTimeMinutes: (json['cooking_time_minutes'] as num?)?.toInt(),
  prepTimeMinutes: (json['prep_time_minutes'] as num?)?.toInt(),
  servings: (json['servings'] as num?)?.toInt() ?? 1,
  calories: (json['calories'] as num?)?.toInt(),
  protein: (json['protein'] as num?)?.toDouble(),
  carbs: (json['carbs'] as num?)?.toDouble(),
  fat: (json['fat'] as num?)?.toDouble(),
  fiber: (json['fiber'] as num?)?.toDouble(),
  vitaminsMinerals: json['vitamins_minerals'] == null
      ? null
      : VitaminsMinerals.fromJson(
          json['vitamins_minerals'] as Map<String, dynamic>,
        ),
  recipeImageUrl: json['recipe_image_url'] as String?,
  notes: json['notes'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meal_plan_id': instance.mealPlanId,
      'meal_type': instance.mealType,
      'meal_date': instance.mealDate.toIso8601String(),
      'recipe_name': instance.recipeName,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'cooking_time_minutes': instance.cookingTimeMinutes,
      'prep_time_minutes': instance.prepTimeMinutes,
      'servings': instance.servings,
      'calories': instance.calories,
      'protein': instance.protein,
      'carbs': instance.carbs,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'vitamins_minerals': instance.vitaminsMinerals,
      'recipe_image_url': instance.recipeImageUrl,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$FoodInventoryItemImpl _$$FoodInventoryItemImplFromJson(
  Map<String, dynamic> json,
) => _$FoodInventoryItemImpl(
  id: json['id'] as String,
  donationId: json['donation_id'] as String?,
  recipientId: json['recipient_id'] as String,
  foodItem: json['food_item'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: json['unit'] as String,
  expiryDate: json['expiry_date'] == null
      ? null
      : DateTime.parse(json['expiry_date'] as String),
  category: json['category'] as String?,
  nutritionalInfo: json['nutritional_info'] as Map<String, dynamic>?,
  isAvailable: json['is_available'] as bool? ?? true,
  usedQuantity: (json['used_quantity'] as num?)?.toDouble() ?? 0.0,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$FoodInventoryItemImplToJson(
  _$FoodInventoryItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'donation_id': instance.donationId,
  'recipient_id': instance.recipientId,
  'food_item': instance.foodItem,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'expiry_date': instance.expiryDate?.toIso8601String(),
  'category': instance.category,
  'nutritional_info': instance.nutritionalInfo,
  'is_available': instance.isAvailable,
  'used_quantity': instance.usedQuantity,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$MealPlannerMessageImpl _$$MealPlannerMessageImplFromJson(
  Map<String, dynamic> json,
) => _$MealPlannerMessageImpl(
  role: json['role'] as String,
  content: json['content'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$$MealPlannerMessageImplToJson(
  _$MealPlannerMessageImpl instance,
) => <String, dynamic>{
  'role': instance.role,
  'content': instance.content,
  'timestamp': instance.timestamp.toIso8601String(),
};

_$MealPlannerConversationImpl _$$MealPlannerConversationImplFromJson(
  Map<String, dynamic> json,
) => _$MealPlannerConversationImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  conversationTitle: json['conversation_title'] as String?,
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => MealPlannerMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  modelUsed: json['model_used'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$MealPlannerConversationImplToJson(
  _$MealPlannerConversationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'conversation_title': instance.conversationTitle,
  'messages': instance.messages,
  'model_used': instance.modelUsed,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$MealPlanTemplateImpl _$$MealPlanTemplateImplFromJson(
  Map<String, dynamic> json,
) => _$MealPlanTemplateImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  templateName: json['template_name'] as String,
  description: json['description'] as String?,
  meals:
      (json['meals'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ??
      const [],
  dietaryTags:
      (json['dietary_tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isPublic: json['is_public'] as bool? ?? false,
  usageCount: (json['usage_count'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$MealPlanTemplateImplToJson(
  _$MealPlanTemplateImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'template_name': instance.templateName,
  'description': instance.description,
  'meals': instance.meals,
  'dietary_tags': instance.dietaryTags,
  'is_public': instance.isPublic,
  'usage_count': instance.usageCount,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$GroceryListItemImpl _$$GroceryListItemImplFromJson(
  Map<String, dynamic> json,
) => _$GroceryListItemImpl(
  item: json['item'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: json['unit'] as String,
  category: json['category'] as String?,
  checked: json['checked'] as bool? ?? false,
  fromDonation: json['from_donation'] as bool? ?? false,
);

Map<String, dynamic> _$$GroceryListItemImplToJson(
  _$GroceryListItemImpl instance,
) => <String, dynamic>{
  'item': instance.item,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'category': instance.category,
  'checked': instance.checked,
  'from_donation': instance.fromDonation,
};

_$GroceryListImpl _$$GroceryListImplFromJson(Map<String, dynamic> json) =>
    _$GroceryListImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mealPlanId: json['meal_plan_id'] as String,
      listName: json['list_name'] as String,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => GroceryListItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GroceryListImplToJson(_$GroceryListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'meal_plan_id': instance.mealPlanId,
      'list_name': instance.listName,
      'items': instance.items,
      'is_completed': instance.isCompleted,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ExpiringInventoryItemImpl _$$ExpiringInventoryItemImplFromJson(
  Map<String, dynamic> json,
) => _$ExpiringInventoryItemImpl(
  id: json['id'] as String,
  foodItem: json['food_item'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: json['unit'] as String,
  expiryDate: DateTime.parse(json['expiry_date'] as String),
  daysUntilExpiry: (json['days_until_expiry'] as num).toInt(),
);

Map<String, dynamic> _$$ExpiringInventoryItemImplToJson(
  _$ExpiringInventoryItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'food_item': instance.foodItem,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'expiry_date': instance.expiryDate.toIso8601String(),
  'days_until_expiry': instance.daysUntilExpiry,
};

_$AvailableInventoryItemImpl _$$AvailableInventoryItemImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableInventoryItemImpl(
  id: json['id'] as String,
  foodItem: json['food_item'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  unit: json['unit'] as String,
  category: json['category'] as String?,
  expiryDate: json['expiry_date'] == null
      ? null
      : DateTime.parse(json['expiry_date'] as String),
);

Map<String, dynamic> _$$AvailableInventoryItemImplToJson(
  _$AvailableInventoryItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'food_item': instance.foodItem,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'category': instance.category,
  'expiry_date': instance.expiryDate?.toIso8601String(),
};
