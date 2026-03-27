import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../providers/meal_planner_providers.dart';
import '../../../providers/providers.dart';
import '../../../data/models/meal_planner_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../widgets/voice_wave_animation.dart';

class MealPlannerScreen extends ConsumerStatefulWidget {
  final bool embedded;

  const MealPlannerScreen({super.key, this.embedded = false});

  @override
  ConsumerState<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends ConsumerState<MealPlannerScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _ingredientController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load API key and fetch available models from OpenRouter
    Future.microtask(() async {
      final openRouterService = ref.read(openRouterServiceProvider);
      await openRouterService.loadApiKey();
      ref.read(fetchModelsProvider);

      // Clear any existing conversation state first
      ref.read(chatMessagesProvider.notifier).state = [];
      ref.read(aiResponseStreamProvider.notifier).state = '';
      ref.read(currentIngredientsProvider.notifier).state = [];
      ref.read(currentDietaryPreferencesProvider.notifier).state = [];

      // Restore previous session if exists
      await _restoreSession();

      // Load inventory items if user is a recipient/NGO
      await _loadInventoryItems();
    });
  }

  Future<void> _loadInventoryItems() async {
    try {
      // Get current user
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;

      if (user == null) {
        return;
      }

      // Get user profile to check if they're a recipient/NGO
      final profileAsync = ref.read(userProfileProvider);
      final profile = profileAsync.value;

      if (profile?.role == UserRole.recipient) {
        // Load inventory items
        final inventoryRepo = ref.read(inventoryRepositoryProvider);
        final inventory = await inventoryRepo.getInventory(user.$id);

        if (inventory.isNotEmpty) {
          // Extract ingredient names from inventory
          final inventoryIngredients = inventory
              .where((item) => item.quantity > 0 && !item.isExpired)
              .map((item) => '${item.name} (${item.quantity} ${item.unit})')
              .toList();

          if (inventoryIngredients.isNotEmpty && mounted) {
            // Add to current ingredients if not already present
            final currentIngredients = ref.read(currentIngredientsProvider);
            final combined = <String>{
              ...currentIngredients,
              ...inventoryIngredients,
            }.toList();
            ref.read(currentIngredientsProvider.notifier).state = combined;

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Loaded ${inventoryIngredients.length} items from inventory',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No valid inventory items found (check expiration dates and quantities)',
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No inventory items found. Add items in the Inventory tab first.',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Don't show any message for non-recipients
        // The inventory sync is only relevant when they explicitly try to use it
      }
    } catch (e) {
      // Show detailed error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading inventory: $e'),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restoreSession() async {
    final historyService = ref.read(mealPlannerHistoryServiceProvider);
    final session = await historyService.getCurrentSession();

    if (session != null && mounted) {
      // Restore ingredients
      final ingredients =
          (session['ingredients'] as List?)?.cast<String>() ?? [];
      if (ingredients.isNotEmpty) {
        ref.read(currentIngredientsProvider.notifier).state = ingredients;
      }

      // Restore preferences
      final preferences =
          (session['preferences'] as List?)?.cast<String>() ?? [];
      if (preferences.isNotEmpty) {
        ref.read(currentDietaryPreferencesProvider.notifier).state =
            preferences;
      }

      // Restore language
      final language = session['language'] as String?;
      if (language != null) {
        ref.read(selectedLanguageProvider.notifier).state = language;
      }

      // Restore conversation messages from history
      final history = await historyService.getHistory();
      if (history.isNotEmpty) {
        final messages = history.map((msg) {
          return {
            'role': msg['role'] as String,
            'content': msg['content'] as String,
          };
        }).toList();
        ref.read(chatMessagesProvider.notifier).state = messages;
      }

      // Restore AI response
      final assistantResponse = session['assistantResponse'] as String?;
      if (assistantResponse != null && assistantResponse.isNotEmpty) {
        ref.read(aiResponseStreamProvider.notifier).state = assistantResponse;
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dietaryProfile = ref.watch(userDietaryProfileProvider);
    final aiLoading = ref.watch(aiLoadingProvider);
    final aiResponse = ref.watch(aiResponseStreamProvider);
    final ingredients = ref.watch(currentIngredientsProvider);
    final selectedPreferences = ref.watch(currentDietaryPreferencesProvider);

    return _buildContent(
      Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            // Header with menu button
            _buildHeader(
              context,
              dietaryProfile,
              ingredients,
              selectedPreferences,
            ),

            // Chat messages
            Expanded(child: _buildChatMessages(aiLoading, aiResponse)),

            // Input field
            SafeArea(child: _buildMessageInput(aiLoading)),
          ],
        ),
        endDrawer: _buildSidebar(ingredients, selectedPreferences),
      ),
    );
  }

  Widget _buildContent(Widget child) {
    if (widget.embedded) {
      return child;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('AI Meal Planner')),
      body: child,
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AsyncValue<UserDietaryProfile?> dietaryProfile,
    List<String> ingredients,
    List<String> selectedPreferences,
  ) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        final isRecipient = profile?.role == UserRole.recipient;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.restaurant_menu,
                color: AppTheme.primaryColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Meal Planner',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isRecipient
                          ? 'Get meal plans from your inventory'
                          : 'Get personalized meal plans with AI',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Sync inventory button for recipients
              if (isRecipient)
                IconButton(
                  icon: const Icon(Icons.sync, color: AppTheme.primaryColor),
                  onPressed: () => _loadInventoryItems(),
                  tooltip: 'Sync with Inventory',
                ),
              // Badge showing ingredient and preference count
              if (ingredients.isNotEmpty || selectedPreferences.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${ingredients.length + selectedPreferences.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Menu button to open sidebar
              IconButton(
                icon: const Icon(Icons.menu, color: AppTheme.primaryColor),
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                tooltip: 'Ingredients & Preferences',
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: const Text('Error loading profile'),
      ),
    );
  }

  Widget _buildSidebar(
    List<String> ingredients,
    List<String> selectedPreferences,
  ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Sidebar header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Ingredients & Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildIngredientSection(ingredients),
                    const SizedBox(height: 24),
                    _buildDietaryPreferencesSection(selectedPreferences),
                    const SizedBox(height: 24),
                    // Clear all button
                    if (ingredients.isNotEmpty ||
                        selectedPreferences.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ref
                                    .read(currentIngredientsProvider.notifier)
                                    .state =
                                [];
                            ref
                                    .read(
                                      currentDietaryPreferencesProvider
                                          .notifier,
                                    )
                                    .state =
                                [];
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Cleared all ingredients and preferences',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear All'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientSection(List<String> ingredients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Ingredients',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ingredientController,
                decoration: const InputDecoration(
                  hintText: 'Add ingredient',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) => _addIngredient(value),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _addIngredient(_ingredientController.text),
              icon: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
        if (ingredients.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ingredients.map((ingredient) {
              return Chip(
                label: Text(ingredient),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeIngredient(ingredient),
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              );
            }).toList(),
          ),
        ] else ...[
          const SizedBox(height: 12),
          Text(
            'No ingredients added yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDietaryPreferencesSection(List<String> selectedPreferences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dietary Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              [
                'Vegetarian',
                'Vegan',
                'Halal',
                'Kosher',
                'Gluten-Free',
                'Diabetic-Friendly',
                'Keto',
                'Low-Sodium',
                'Low-Fat',
                'High-Protein',
              ].map((pref) {
                final isSelected = selectedPreferences.contains(pref);
                return FilterChip(
                  label: Text(pref),
                  selected: isSelected,
                  onSelected: (selected) => _togglePreference(pref),
                  selectedColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                );
              }).toList(),
        ),
        if (selectedPreferences.isEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'No preferences selected',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChatMessages(bool aiLoading, String aiResponse) {
    final chatMessages = ref.watch(chatMessagesProvider);

    return Column(
      children: [
        // Reset chat button
        if (chatMessages.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            child: TextButton.icon(
              onPressed: _resetChat,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Chat'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
        Expanded(
          child: chatMessages.isEmpty && !aiLoading
              ? _buildWelcomeMessage()
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatMessages.length + (aiLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the end
                    if (index == chatMessages.length && aiLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final message = chatMessages[index];
                    final isUser = message['role'] == 'user';
                    final content = message['content'] as String;

                    return _buildMessageBubble(content, isUser: isUser);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    final profileAsync = ref.watch(userProfileProvider);
    final isRecipient = profileAsync.value?.role == UserRole.recipient;
    final ingredients = ref.watch(currentIngredientsProvider);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: AppTheme.primaryColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to AI Meal Planner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isRecipient
                  ? ingredients.isEmpty
                        ? 'Sync your inventory to get started,\nor add ingredients manually!'
                        : 'Ask me what you can make with your inventory!'
                  : 'Add ingredients and dietary preferences above,\nthen ask me to generate a meal plan!',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: isRecipient
                  ? [
                      _buildSuggestionChip(
                        'What can I make from my inventory?',
                      ),
                      _buildSuggestionChip('Quick recipes with what I have'),
                      _buildSuggestionChip('Use expiring items first'),
                      _buildSuggestionChip(
                        'What are popular Pakistani dishes?',
                      ),
                    ]
                  : [
                      _buildSuggestionChip('Generate weekly meal plan'),
                      _buildSuggestionChip('Healthy breakfast ideas'),
                      _buildSuggestionChip('Quick dinner recipes'),
                      _buildSuggestionChip(
                        'What are the best dishes in Pakistan?',
                      ),
                    ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
    );
  }

  Widget _buildMessageBubble(String message, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isUser
            ? Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
              )
            : MarkdownBody(
                data: message,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  // Paragraph styles
                  p: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  // Header styles
                  h1: const TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  h2: const TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  h3: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  h4: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  // Text formatting
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  em: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                  // List styles
                  listBullet: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  // Table styles
                  tableHead: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                  ),
                  tableBody: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                  tableBorder: TableBorder.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  // Code styles
                  code: TextStyle(
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.black87,
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  // Blockquote styles
                  blockquote: TextStyle(
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                  blockquoteDecoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      left: BorderSide(color: AppTheme.primaryColor, width: 4),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMessageInput(bool aiLoading) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Language selector button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: DropdownButton<String>(
              value: selectedLanguage,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: Colors.black87,
              ),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              isDense: true,
              dropdownColor: Colors.white,
              items: _getTopLanguages().map((lang) {
                return DropdownMenuItem(
                  value: lang['name'],
                  child: Text(
                    lang['code']!,
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(selectedLanguageProvider.notifier).state = value;
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Ask for meal suggestions...',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              maxLines: 1,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          // Voice input button
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: aiLoading ? null : _startVoiceInput,
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.mic,
                size: 22,
                color: aiLoading ? Colors.grey : AppTheme.primaryColor,
              ),
              tooltip: 'Voice input',
            ),
          ),
          const SizedBox(width: 4),
          // Send button
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton.filled(
              onPressed: aiLoading ? null : _sendMessage,
              padding: EdgeInsets.zero,
              icon: aiLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Get top 10 world languages with their codes
  List<Map<String, String>> _getTopLanguages() {
    return [
      {'code': 'EN', 'name': 'English'},
      {'code': 'ZH', 'name': 'Chinese'},
      {'code': 'ES', 'name': 'Spanish'},
      {'code': 'HI', 'name': 'Hindi'},
      {'code': 'AR', 'name': 'Arabic'},
      {'code': 'FR', 'name': 'French'},
      {'code': 'RU', 'name': 'Russian'},
      {'code': 'PT', 'name': 'Portuguese'},
      {'code': 'DE', 'name': 'German'},
      {'code': 'JA', 'name': 'Japanese'},
    ];
  }

  void _startVoiceInput() async {
    final selectedLanguage = ref.read(selectedLanguageProvider);
    final voiceService = ref.read(voiceInputServiceProvider);

    // Initialize voice service
    final initialized = await voiceService.initialize();
    if (!initialized) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.mic_off, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Microphone Permission',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: const Text(
              'This app needs microphone access to use voice input.\n\n'
              'Please go to your device Settings > Apps > HRA-FoDAS > Permissions '
              'and enable Microphone access.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Permission.microphone.request();
                },
                child: const Text('Request Permission'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Show voice input dialog
    if (!mounted) return;

    final dialogKey = GlobalKey<VoiceInputDialogState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VoiceInputDialog(
        key: dialogKey,
        language: selectedLanguage,
        onResult: (text) {
          _messageController.text = text;
        },
        onCancel: () async {
          await voiceService.stopListening();
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );

    // Wait for dialog to build
    await Future.delayed(const Duration(milliseconds: 100));

    // Start listening
    try {
      final localeId = voiceService.getLocaleId(selectedLanguage);
      dialogKey.currentState?.setListening(true);

      await voiceService.startListening(
        localeId: localeId,
        onResult: (text) {
          dialogKey.currentState?.updateRecognizedText(text);
        },
        onSoundLevel: (level) {
          dialogKey.currentState?.updateSoundLevel(level);
        },
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _addIngredient(String ingredient) {
    if (ingredient.trim().isEmpty) return;

    final ingredients = ref.read(currentIngredientsProvider);
    if (!ingredients.contains(ingredient.trim())) {
      ref.read(currentIngredientsProvider.notifier).state = [
        ...ingredients,
        ingredient.trim(),
      ];
    }
    _ingredientController.clear();
  }

  void _removeIngredient(String ingredient) {
    final ingredients = ref.read(currentIngredientsProvider);
    ref.read(currentIngredientsProvider.notifier).state = ingredients
        .where((i) => i != ingredient)
        .toList();
  }

  void _togglePreference(String preference) {
    final preferences = ref.read(currentDietaryPreferencesProvider);
    if (preferences.contains(preference)) {
      ref.read(currentDietaryPreferencesProvider.notifier).state = preferences
          .where((p) => p != preference)
          .toList();
    } else {
      ref.read(currentDietaryPreferencesProvider.notifier).state = [
        ...preferences,
        preference,
      ];
    }
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final ingredients = ref.read(currentIngredientsProvider);
    final preferences = ref.read(currentDietaryPreferencesProvider);
    final selectedModel = ref.read(selectedModelProvider);
    final selectedLanguage = ref.read(selectedLanguageProvider);
    final openRouterService = ref.read(openRouterServiceProvider);
    final historyService = ref.read(mealPlannerHistoryServiceProvider);

    // Load API key from SharedPreferences
    await openRouterService.loadApiKey();

    // Check if API key is set
    if (openRouterService.apiKey.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please configure your OpenRouter API key in Profile > LLM Settings',
            ),
            backgroundColor: AppTheme.warningColor,
            duration: Duration(seconds: 5),
          ),
        );
      }
      return;
    }

    // Add user message to chat UI
    final chatMessages = ref.read(chatMessagesProvider);
    ref.read(chatMessagesProvider.notifier).state = [
      ...chatMessages,
      {'role': 'user', 'content': message},
    ];

    // Save user message to history
    await historyService.saveMessage(
      role: 'user',
      content: message,
      language: selectedLanguage,
      ingredients: ingredients,
      preferences: preferences,
    );

    // Build the system message
    final systemMessage = _buildSystemMessage(preferences, selectedLanguage);

    // Build the full prompt
    final fullPrompt = _buildPrompt(
      message,
      ingredients,
      preferences,
      selectedLanguage,
    );

    // Clear input and show loading
    _messageController.clear();
    ref.read(aiLoadingProvider.notifier).state = true;
    ref.read(aiResponseStreamProvider.notifier).state = '';

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      // Generate response using OpenRouter
      final response = await openRouterService.generateWithOpenRouter(
        model: selectedModel,
        prompt: fullPrompt,
        systemMessage: systemMessage,
      );

      if (mounted) {
        // Add assistant message to chat UI
        final updatedMessages = ref.read(chatMessagesProvider);
        ref.read(chatMessagesProvider.notifier).state = [
          ...updatedMessages,
          {'role': 'assistant', 'content': response},
        ];

        ref.read(aiResponseStreamProvider.notifier).state = response;

        // Save assistant response to history
        await historyService.saveMessage(
          role: 'assistant',
          content: response,
          language: selectedLanguage,
        );

        // Save current session
        await historyService.saveCurrentSession(
          userMessage: message,
          assistantResponse: response,
          language: selectedLanguage,
          ingredients: ingredients,
          preferences: preferences,
        );

        // Scroll to bottom after response
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        final errorMessage =
            'Error: Could not connect to OpenRouter API.\n\n'
            'Please make sure:\n'
            '1. Your OpenRouter API key is set in Profile > LLM Settings\n'
            '2. You have internet connection\n'
            '3. The selected model is available\n\n'
            'Error details: $e';

        // Add error message to chat UI
        final updatedMessages = ref.read(chatMessagesProvider);
        ref.read(chatMessagesProvider.notifier).state = [
          ...updatedMessages,
          {'role': 'assistant', 'content': errorMessage},
        ];

        ref.read(aiResponseStreamProvider.notifier).state = errorMessage;

        // Save error to history
        await historyService.saveMessage(
          role: 'assistant',
          content: errorMessage,
          language: selectedLanguage,
        );
      }
    } finally {
      if (mounted) {
        ref.read(aiLoadingProvider.notifier).state = false;
      }
    }
  }

  String _buildSystemMessage(List<String> preferences, String language) {
    final profileAsync = ref.read(userProfileProvider);
    final isRecipient = profileAsync.value?.role == UserRole.recipient;

    final buffer = StringBuffer();
    buffer.writeln('# AI Culinary Assistant Instructions');
    buffer.writeln('');
    buffer.writeln('**ALWAYS FORMAT YOUR RESPONSE IN PROPER MARKDOWN**');
    buffer.writeln('');
    buffer.writeln(
      'You are a helpful culinary assistant with extensive knowledge of world cuisines, cooking techniques, and food culture.',
    );
    buffer.writeln('');

    if (isRecipient) {
      buffer.writeln('## Operating Mode: NGO/Food Bank Assistant');
      buffer.writeln('');
      buffer.writeln('### CRITICAL DISTINCTION:');
      buffer.writeln('');
      buffer.writeln('**FOR GENERAL CULINARY QUESTIONS:**');
      buffer.writeln(
        '- Questions about "best dishes", "popular food", "traditional cuisine", etc.',
      );
      buffer.writeln('- Answer using your full knowledge base');
      buffer.writeln('- DO NOT mention inventory constraints');
      buffer.writeln(
        '- Provide comprehensive cultural and culinary information',
      );
      buffer.writeln(
        '- Examples: "What are the best dishes in Pakistan?", "Tell me about Italian cuisine"',
      );
      buffer.writeln('');
      buffer.writeln('**FOR INVENTORY-BASED RECIPE REQUESTS:**');
      buffer.writeln(
        '- Questions like "What can I make with my inventory?", "Recipe using what I have"',
      );
      buffer.writeln('- ONLY then apply inventory constraints');
      buffer.writeln('- Use only ingredients from the provided inventory list');
      buffer.writeln('- Prioritize items close to expiration');
      buffer.writeln('');
    } else {
      buffer.writeln('## Operating Mode: General Culinary Assistant');
      buffer.writeln(
        'Provide comprehensive culinary advice, recipes, and food knowledge.',
      );
      buffer.writeln('');
    }

    buffer.writeln('## Response Format Guidelines:');
    buffer.writeln('');
    buffer.writeln('### For Recipe Requests:');
    buffer.writeln('1. **Recipe Title** (as H2 heading)');
    buffer.writeln('2. **Description** (brief overview)');
    buffer.writeln('3. **Ingredients** (formatted as a proper markdown table)');
    buffer.writeln('4. **Instructions** (numbered steps)');
    buffer.writeln('5. **Cooking Time** (preparation + cooking)');
    buffer.writeln('6. **Nutritional Information** (formatted as a table)');
    buffer.writeln('');
    buffer.writeln('### For General Questions:');
    buffer.writeln('- Provide detailed, informative answers');
    buffer.writeln('- Use proper markdown formatting');
    buffer.writeln('- Include cultural context when relevant');
    buffer.writeln('- Be comprehensive and educational');
    buffer.writeln('');

    if (preferences.isNotEmpty) {
      buffer.writeln('## User Dietary Preferences:');
      for (final pref in preferences) {
        buffer.writeln('- $pref');
      }
      buffer.writeln('');
    }

    buffer.writeln('## Core Instructions:');
    buffer.writeln('- Always respond in **$language** language');
    buffer.writeln(
      '- Use proper markdown formatting with headers, tables, and lists',
    );
    buffer.writeln(
      '- Distinguish between general questions and recipe requests',
    );
    buffer.writeln('- Be detailed, helpful, and culturally aware');

    return buffer.toString();
  }

  String _buildPrompt(
    String message,
    List<String> ingredients,
    List<String> preferences,
    String language,
  ) {
    final profileAsync = ref.read(userProfileProvider);
    final isRecipient = profileAsync.value?.role == UserRole.recipient;

    final buffer = StringBuffer();

    buffer.writeln('**Language**: Respond ONLY in $language language.');
    buffer.writeln('');

    // Check if this is a recipe/cooking related question
    final isRecipeQuestion = _isRecipeRelatedQuestion(message);

    // Only include inventory and preferences for recipe questions
    if (isRecipeQuestion) {
      if (ingredients.isNotEmpty) {
        if (isRecipient) {
          buffer.writeln('## 🥘 Current Inventory (Available Food Items)');
          buffer.writeln('');
          buffer.writeln('| Item | Quantity |');
          buffer.writeln('|------|----------|');
          for (final ingredient in ingredients) {
            buffer.writeln('| $ingredient | Available |');
          }
          buffer.writeln('');
          buffer.writeln(
            '> **Note**: Please use ONLY the items listed above for recipe suggestions.',
          );
          buffer.writeln('');
        } else {
          buffer.writeln('## 🥗 Available Ingredients:');
          buffer.writeln('');
          for (final ingredient in ingredients) {
            buffer.writeln('- $ingredient');
          }
          buffer.writeln('');
        }
      }

      if (preferences.isNotEmpty) {
        buffer.writeln('## 🍽️ Dietary Preferences:');
        buffer.writeln('');
        for (final pref in preferences) {
          buffer.writeln('- $pref');
        }
        buffer.writeln('');
      }
    } else {
      // For general questions, explicitly state this is not a recipe request
      buffer.writeln('## � General Culinary Question');
      buffer.writeln(
        'This is a general question about food, cuisine, or culinary knowledge.',
      );
      buffer.writeln(
        'Please provide comprehensive information based on your knowledge.',
      );
      buffer.writeln('');
    }

    buffer.writeln('## 💬 User Question:');
    buffer.writeln(message);

    return buffer.toString();
  }

  // Helper method to determine if the question is recipe-related
  bool _isRecipeRelatedQuestion(String message) {
    final lowerMessage = message.toLowerCase();

    // General knowledge questions should not be treated as recipe questions
    final generalQuestionPatterns = [
      'what are the best',
      'what are',
      'what is',
      'tell me about',
      'best dishes in',
      'popular dishes',
      'famous food',
      'traditional food',
      'cuisine of',
      'food culture',
      'history of',
    ];

    // Check if it's a general question first
    for (final pattern in generalQuestionPatterns) {
      if (lowerMessage.contains(pattern)) {
        return false; // It's a general question, not a recipe request
      }
    }

    // Inventory-specific keywords that indicate recipe requests
    final inventoryRecipeKeywords = [
      'what can i make',
      'recipe with',
      'cook with',
      'use my inventory',
      'from my ingredients',
      'with what i have',
      'quick recipes',
      'use expiring',
    ];

    // Check for inventory-based recipe requests
    for (final keyword in inventoryRecipeKeywords) {
      if (lowerMessage.contains(keyword)) {
        return true;
      }
    }

    // General recipe keywords (but only if not a general question)
    final recipeKeywords = [
      'recipe for',
      'how to cook',
      'how to make',
      'cooking instructions',
      'meal plan',
      'breakfast recipe',
      'lunch recipe',
      'dinner recipe',
    ];

    final isRecipe = recipeKeywords.any(
      (keyword) => lowerMessage.contains(keyword),
    );
    return isRecipe;
  }

  void _resetChat() async {
    final historyService = ref.read(mealPlannerHistoryServiceProvider);

    // Clear current session
    await historyService.clearCurrentSession();

    // Clear chat messages
    ref.read(chatMessagesProvider.notifier).state = [];
    ref.read(aiResponseStreamProvider.notifier).state = '';
    ref.read(aiLoadingProvider.notifier).state = false;
    ref.read(currentIngredientsProvider.notifier).state = [];
    ref.read(currentDietaryPreferencesProvider.notifier).state = [];
    _messageController.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Chat reset successfully')));
  }
}
