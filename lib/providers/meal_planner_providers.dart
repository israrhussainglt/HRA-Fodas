import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/meal_planner_models.dart';
import '../data/repositories/meal_planner_repository.dart';
import '../data/repositories/dietary_profile_repository.dart';
import '../data/repositories/food_inventory_repository.dart';
import '../services/openrouter_service.dart';
import '../services/voice_input_service.dart';
import '../services/meal_planner_history_service.dart';
import 'providers.dart';

// Repository Providers
final mealPlannerRepositoryProvider = Provider<MealPlannerRepository>((ref) {
  return MealPlannerRepository(
    ref.watch(appwriteDatabasesProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

final dietaryProfileRepositoryProvider = Provider<DietaryProfileRepository>((
  ref,
) {
  return DietaryProfileRepository(
    ref.watch(appwriteDatabasesProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

final foodInventoryRepositoryProvider = Provider<FoodInventoryRepository>((
  ref,
) {
  return FoodInventoryRepository(
    ref.watch(appwriteDatabasesProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

// Service Providers
final openRouterServiceProvider = Provider<OpenRouterService>((ref) {
  // API key will be loaded from SharedPreferences at runtime
  // For now, return a service with empty key - it will be updated when used
  return OpenRouterService('');
});

// Voice Input Service Provider
final voiceInputServiceProvider = Provider<VoiceInputService>((ref) {
  return VoiceInputService();
});

// Meal Planner History Service Provider
final mealPlannerHistoryServiceProvider = Provider<MealPlannerHistoryService>((
  ref,
) {
  final userAsync = ref.watch(currentUserProvider);
  final userId = userAsync.value?.$id;
  return MealPlannerHistoryService(userId: userId);
});

// User Dietary Profile Provider
final userDietaryProfileProvider = StreamProvider<UserDietaryProfile?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref
          .watch(dietaryProfileRepositoryProvider)
          .getUserDietaryProfile(user.$id);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// Current Active Meal Plan Provider
final currentMealPlanProvider = StreamProvider<MealPlan?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref
          .watch(mealPlannerRepositoryProvider)
          .getCurrentMealPlan(user.$id);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// All Meal Plans Provider
final mealPlansProvider = StreamProvider<List<MealPlan>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref.watch(mealPlannerRepositoryProvider).getMealPlans(user.$id);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// Meals for a specific meal plan
final mealsProvider = StreamProvider.family<List<Meal>, String>((
  ref,
  mealPlanId,
) {
  return ref.watch(mealPlannerRepositoryProvider).getMeals(mealPlanId);
});

// Food Inventory Provider
final foodInventoryProvider = StreamProvider<List<FoodInventoryItem>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref
          .watch(foodInventoryRepositoryProvider)
          .getFoodInventory(user.$id);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// Available Inventory Provider (items with quantity > 0)
final availableInventoryProvider = StreamProvider<List<AvailableInventoryItem>>(
  (ref) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) return Stream.value([]);
        return ref
            .watch(foodInventoryRepositoryProvider)
            .getAvailableInventory(user.$id);
      },
      loading: () => Stream.value([]),
      error: (_, _) => Stream.value([]),
    );
  },
);

// Expiring Items Provider (items expiring within 7 days)
final expiringItemsProvider = StreamProvider<List<ExpiringInventoryItem>>((
  ref,
) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref
          .watch(foodInventoryRepositoryProvider)
          .getExpiringInventory(user.$id, daysThreshold: 7);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// Expiring Items Count Provider (for badge)
final expiringItemsCountProvider = Provider<int>((ref) {
  final expiringItems = ref.watch(expiringItemsProvider);
  return expiringItems.when(
    data: (items) => items.length,
    loading: () => 0,
    error: (_, _) => 0,
  );
});

// AI Conversation State Provider
final aiConversationProvider = StateProvider<MealPlannerConversation?>(
  (ref) => null,
);

// Chat Messages Provider - stores the current conversation messages
final chatMessagesProvider = StateProvider<List<Map<String, dynamic>>>(
  (ref) => [],
);

// Current Ingredients State Provider (for meal planner input)
final currentIngredientsProvider = StateProvider<List<String>>((ref) => []);

// Current Dietary Preferences State Provider (for meal planner input)
final currentDietaryPreferencesProvider = StateProvider<List<String>>(
  (ref) => [],
);

// AI Loading State Provider
final aiLoadingProvider = StateProvider<bool>((ref) => false);

// AI Response Stream Provider
final aiResponseStreamProvider = StateProvider<String>((ref) => '');

// Grocery Lists Provider
final groceryListsProvider = StreamProvider<List<GroceryList>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref.watch(mealPlannerRepositoryProvider).getGroceryLists(user.$id);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// Meal Plan Templates Provider
final mealPlanTemplatesProvider = StreamProvider<List<MealPlanTemplate>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      return ref
          .watch(mealPlannerRepositoryProvider)
          .getMealPlanTemplates(user.$id);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// Public Meal Plan Templates Provider
final publicMealPlanTemplatesProvider = StreamProvider<List<MealPlanTemplate>>((
  ref,
) {
  return ref.watch(mealPlannerRepositoryProvider).getPublicMealPlanTemplates();
});

// Selected Date Provider (for meal calendar)
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Meal Plan Type Provider (daily, weekly, monthly)
final mealPlanTypeProvider = StateProvider<String>((ref) => 'weekly');

// Selected AI Model Provider
final selectedModelProvider = StateProvider<String>(
  (ref) => 'meta-llama/llama-3.2-3b-instruct:free',
);

// Available Models Provider (will be fetched from OpenRouter)
final availableModelsProvider = StateProvider<List<Map<String, dynamic>>>(
  (ref) => [
    {
      'id': 'meta-llama/llama-3.2-3b-instruct:free',
      'name': 'Llama 3.2 3B (Free)',
      'description': 'Fast and efficient, good for quick responses',
    },
    {
      'id': 'mistralai/mistral-7b-instruct:free',
      'name': 'Mistral 7B (Free)',
      'description': 'Free open-source model',
    },
    {
      'id': 'google/gemma-2-9b-it:free',
      'name': 'Gemma 2 9B (Free)',
      'description': 'Google\'s free instruction-tuned model',
    },
  ],
);

// Fetch models from OpenRouter
final fetchModelsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final openRouterService = ref.read(openRouterServiceProvider);

  try {
    // Load API key first
    await openRouterService.loadApiKey();

    // Fetch models from OpenRouter
    final models = await openRouterService.getAvailableModels();

    // Update available models
    if (models.isNotEmpty) {
      ref.read(availableModelsProvider.notifier).state = models;
      // Set first available model as default
      ref.read(selectedModelProvider.notifier).state =
          models.first['id'] as String;
    }

    return models;
  } catch (e) {
    // Log error silently in production
    // Return default models if fetch fails
    return ref.read(availableModelsProvider);
  }
});

// Selected Language Provider
final selectedLanguageProvider = StateProvider<String>((ref) => 'English');

// Dietary Preference Options
const List<String> dietaryPreferenceOptions = [
  'Vegetarian',
  'Vegan',
  'Halal',
  'Kosher',
  'Diabetic-Friendly',
  'Keto',
  'Gluten-Free',
  'Dairy-Free',
  'Nut-Free',
  'Low-Sodium',
  'Low-Fat',
  'High-Protein',
];

// Allergy Options
const List<String> allergyOptions = [
  'Peanuts',
  'Tree Nuts',
  'Dairy',
  'Eggs',
  'Shellfish',
  'Fish',
  'Soy',
  'Wheat',
  'Sesame',
  'Sulfites',
];

// Health Condition Options
const List<String> healthConditionOptions = [
  'Diabetes',
  'Hypertension',
  'Heart Disease',
  'Celiac Disease',
  'IBS',
  'Kidney Disease',
  'Obesity',
  'Anemia',
];

// Cultural Preference Options
const List<String> culturalPreferenceOptions = [
  'African',
  'Asian',
  'Mediterranean',
  'Latin American',
  'Middle Eastern',
  'Indian',
  'European',
  'Caribbean',
];

// Budget Range Options
const List<String> budgetRangeOptions = ['Low', 'Medium', 'High'];

// Food Category Options
const List<String> foodCategoryOptions = [
  'Grains',
  'Vegetables',
  'Fruits',
  'Protein',
  'Dairy',
  'Oils & Fats',
  'Snacks',
  'Other',
];

// Meal Type Options
const List<String> mealTypeOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

// Language Options (matching the existing meal planner)
const List<String> languageOptions = [
  'English',
  'Swahili',
  'Luganda',
  'Lango',
  'Acholi',
  'Lugisu',
  'Iteso',
  'Runyankole-Rukiga',
  'Runyoro-Kitara',
  'Lusoga',
  'Ateso',
  'Lubwisi',
  'Kinyarwanda',
  'Kirundi',
  'Chichewa',
  'Shona',
  'Zulu',
  'Xhosa',
  'Tswana',
  'Sesotho',
  'Amharic',
  'Oromo',
  'Somali',
  'Tigrinya',
  'Wolof',
  'Fula',
  'Hausa',
  'Yoruba',
  'Igbo',
  'Akan',
  'Lingala',
];
