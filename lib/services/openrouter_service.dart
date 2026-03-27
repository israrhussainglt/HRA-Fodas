import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/meal_planner_models.dart';
import '../core/utils/logger.dart';

class OpenRouterService {
  final Dio _dio;
  String _apiKey;
  static const String _baseUrl = 'https://openrouter.ai/api/v1';

  OpenRouterService(this._apiKey)
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(minutes: 2),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'HTTP-Referer': 'https://hrafodas.com',
            'X-Title': 'HRA-FoDAS Meal Planner',
            'Content-Type': 'application/json',
          },
        ),
      );

  /// Load API key from SharedPreferences
  Future<void> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('openrouter_api_key') ?? '';
    _apiKey = apiKey;
    // Update the Authorization header
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
  }

  /// Get current API key
  String get apiKey => _apiKey;

  /// Generate meal plan using AI
  ///
  /// This method streams the AI response in real-time.
  /// Use [onChunk] callback to receive response chunks as they arrive.
  /// Use [onComplete] callback to get the full response when done.
  /// Use [onError] callback to handle errors.
  Future<void> generateMealPlan({
    required List<MealPlannerMessage> conversationHistory,
    required String prompt,
    required String model,
    List<String>? ingredients,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    List<String>? healthConditions,
    List<AvailableInventoryItem>? availableInventory,
    String language = 'English',
    required Function(String chunk) onChunk,
    required Function(String fullResponse) onComplete,
    required Function(String error) onError,
  }) async {
    try {
      // Build the system message with dietary information
      final systemMessage = _buildSystemMessage(
        dietaryPreferences: dietaryPreferences,
        allergies: allergies,
        healthConditions: healthConditions,
        availableInventory: availableInventory,
        language: language,
      );

      // Build the full prompt with ingredients
      final fullPrompt = _buildPrompt(
        prompt: prompt,
        ingredients: ingredients,
        dietaryPreferences: dietaryPreferences,
        language: language,
      );

      // Build messages array for OpenRouter
      final messages = <Map<String, dynamic>>[
        {'role': 'system', 'content': systemMessage},
        // Add conversation history
        ...conversationHistory.map(
          (msg) => {
            'role': msg.role, // 'user' or 'assistant'
            'content': msg.content,
          },
        ),
        // Add current prompt
        {'role': 'user', 'content': fullPrompt},
      ];

      // Call OpenRouter API with streaming
      final response = await _dio.post(
        '/chat/completions',
        data: {'model': model, 'messages': messages, 'stream': true},
        options: Options(responseType: ResponseType.stream),
      );

      if (response.statusCode == 200 && response.data != null) {
        final stream = response.data.stream as Stream<List<int>>;
        final fullResponse = StringBuffer();

        await for (final chunk in stream) {
          final text = utf8.decode(chunk);
          final lines = text
              .split('\n')
              .where((line) => line.trim().isNotEmpty);

          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data == '[DONE]') continue;

              try {
                final json = jsonDecode(data) as Map<String, dynamic>;
                final choices = json['choices'] as List<dynamic>?;
                if (choices != null && choices.isNotEmpty) {
                  final delta = choices[0]['delta'] as Map<String, dynamic>?;
                  final content = delta?['content'] as String?;
                  if (content != null && content.isNotEmpty) {
                    fullResponse.write(content);
                    onChunk(content);
                  }
                }
              } catch (e) {
                // Skip invalid JSON lines
                AppLogger.warning('Error parsing chunk: $e', tag: 'OPENROUTER');
              }
            }
          }
        }

        onComplete(fullResponse.toString());
      } else {
        onError('AI service returned error: ${response.statusCode}');
      }
    } catch (e) {
      onError('Error generating meal plan: $e');
    }
  }

  /// Generate meal plan (non-streaming version)
  Future<String> generateMealPlanSync({
    required List<MealPlannerMessage> conversationHistory,
    required String prompt,
    required String model,
    List<String>? ingredients,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    List<String>? healthConditions,
    List<AvailableInventoryItem>? availableInventory,
    String language = 'English',
  }) async {
    final completer = Completer<String>();

    await generateMealPlan(
      conversationHistory: conversationHistory,
      prompt: prompt,
      model: model,
      ingredients: ingredients,
      dietaryPreferences: dietaryPreferences,
      allergies: allergies,
      healthConditions: healthConditions,
      availableInventory: availableInventory,
      language: language,
      onChunk: (_) {
        // Chunks are handled internally
      },
      onComplete: (response) {
        completer.complete(response);
      },
      onError: (error) {
        completer.completeError(error);
      },
    );

    return completer.future;
  }

  /// Build system message with dietary information
  String _buildSystemMessage({
    List<String>? dietaryPreferences,
    List<String>? allergies,
    List<String>? healthConditions,
    List<AvailableInventoryItem>? availableInventory,
    String language = 'English',
  }) {
    final buffer = StringBuffer();

    buffer.writeln('ALWAYS FORMAT YOUR RESPONSE IN MARKDOWN');
    buffer.writeln(
      'You are a helpful culinary assistant and recipe generator.',
    );
    buffer.writeln(
      'Create delicious, practical recipes based on the ingredients users provide.',
    );
    buffer.writeln('For each recipe, include:');
    buffer.writeln('- Recipe Title');
    buffer.writeln('- Ingredients list with quantities in a table');
    buffer.writeln('- Cooking instructions');
    buffer.writeln('- Estimated cooking time (only total time)');
    buffer.writeln(
      '- Nutritional information (calories, protein, carbs, fat, fiber, vitamins and minerals) in a table',
    );
    buffer.writeln('');

    // Add dietary preferences
    if (dietaryPreferences != null && dietaryPreferences.isNotEmpty) {
      buffer.writeln('USER DIETARY PREFERENCES:');
      for (final pref in dietaryPreferences) {
        buffer.writeln('- $pref');
      }
      buffer.writeln('');
    }

    // Add allergies
    if (allergies != null && allergies.isNotEmpty) {
      buffer.writeln('USER ALLERGIES (MUST AVOID):');
      for (final allergy in allergies) {
        buffer.writeln('- $allergy');
      }
      buffer.writeln('');
    }

    // Add health conditions
    if (healthConditions != null && healthConditions.isNotEmpty) {
      buffer.writeln('USER HEALTH CONDITIONS:');
      for (final condition in healthConditions) {
        buffer.writeln('- $condition');
      }
      buffer.writeln('');
    }

    // Add available inventory
    if (availableInventory != null && availableInventory.isNotEmpty) {
      buffer.writeln('AVAILABLE DONATED FOOD INVENTORY:');
      for (final item in availableInventory) {
        final expiry = item.expiryDate != null
            ? ' (expires: ${item.expiryDate!.toLocal().toString().split(' ')[0]})'
            : '';
        buffer.writeln(
          '- ${item.foodItem}: ${item.quantity} ${item.unit}$expiry',
        );
      }
      buffer.writeln('');
      buffer.writeln(
        'PRIORITIZE using items that are expiring soon to reduce food waste.',
      );
      buffer.writeln('');
    }

    buffer.writeln('IMPORTANT RULES:');
    buffer.writeln(
      '1. If any provided ingredients conflict with dietary preferences or allergies, DO NOT generate a recipe yet.',
    );
    buffer.writeln(
      '2. Instead, list each conflicting ingredient and suggest at least two suitable alternatives.',
    );
    buffer.writeln(
      '3. Ask the user to select one alternative for each conflict.',
    );
    buffer.writeln('4. Wait for user selection before generating the recipe.');
    buffer.writeln(
      '5. Once alternatives are selected, use those in the recipe and add a note about substitutions.',
    );
    buffer.writeln('6. Always respond in $language language.');

    return buffer.toString();
  }

  /// Build the full prompt with ingredients and preferences
  String _buildPrompt({
    required String prompt,
    List<String>? ingredients,
    List<String>? dietaryPreferences,
    String language = 'English',
  }) {
    final buffer = StringBuffer();

    // Add language instruction
    buffer.writeln('Respond ONLY in $language language.');
    buffer.writeln('');

    // Add ingredients if provided
    if (ingredients != null && ingredients.isNotEmpty) {
      buffer.writeln('Available Ingredients: ${ingredients.join(", ")}');
      buffer.writeln('');
    }

    // Add dietary preferences if provided
    if (dietaryPreferences != null && dietaryPreferences.isNotEmpty) {
      buffer.writeln(
        'Dietary Preferences/Restrictions: ${dietaryPreferences.join(", ")}',
      );
      buffer.writeln('');
    }

    // Add the user's prompt
    buffer.write(prompt);

    return buffer.toString();
  }

  /// Parse AI response to extract meal plan data
  /// This is a helper method to extract structured data from the AI response
  Map<String, dynamic> parseMealPlanResponse(String response) {
    // This is a basic parser. You may need to enhance it based on actual AI responses.
    final result = <String, dynamic>{
      'raw_response': response,
      'recipes': <Map<String, dynamic>>[],
    };

    // Try to extract recipe title
    final titleMatch = RegExp(r'#+\s*(.+?)(?:\n|$)').firstMatch(response);
    if (titleMatch != null) {
      result['title'] = titleMatch.group(1)?.trim();
    }

    // Try to extract cooking time
    final timeMatch = RegExp(
      r'(?:cooking time|total time)[:\s]+(\d+)\s*(?:min|minutes)',
      caseSensitive: false,
    ).firstMatch(response);
    if (timeMatch != null) {
      result['cooking_time_minutes'] = int.tryParse(timeMatch.group(1) ?? '0');
    }

    // Try to extract calories
    final caloriesMatch = RegExp(
      r'calories[:\s]+(\d+)',
      caseSensitive: false,
    ).firstMatch(response);
    if (caloriesMatch != null) {
      result['calories'] = int.tryParse(caloriesMatch.group(1) ?? '0');
    }

    return result;
  }

  /// Get available OpenRouter models
  Future<List<Map<String, dynamic>>> getAvailableModels() async {
    try {
      final response = await _dio.get('/models');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final models = data['data'] as List<dynamic>?;

        if (models != null && models.isNotEmpty) {
          return models.cast<Map<String, dynamic>>();
        }
      }

      // Return default models if API call fails
      return _getDefaultModels();
    } catch (e) {
      AppLogger.error('Error fetching models: $e', tag: 'OPENROUTER');
      // Return default models on error
      return _getDefaultModels();
    }
  }

  /// Get default models list (popular OpenRouter models)
  List<Map<String, dynamic>> _getDefaultModels() {
    return [
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
      {
        'id': 'microsoft/phi-3-mini-128k-instruct:free',
        'name': 'Phi-3 Mini (Free)',
        'description': 'Microsoft\'s compact free model',
      },
      {
        'id': 'google/gemini-flash-1.5',
        'name': 'Gemini Flash 1.5',
        'description': 'Fast Google model (requires credits)',
      },
      {
        'id': 'google/gemini-pro-1.5',
        'name': 'Gemini Pro 1.5',
        'description': 'High quality Google model (requires credits)',
      },
      {
        'id': 'anthropic/claude-3-haiku',
        'name': 'Claude 3 Haiku',
        'description': 'Fast Anthropic model (requires credits)',
      },
      {
        'id': 'openai/gpt-3.5-turbo',
        'name': 'GPT-3.5 Turbo',
        'description': 'Fast OpenAI model (requires credits)',
      },
    ];
  }

  /// Test connection to OpenRouter service
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        '/models',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      AppLogger.error('Connection test failed: $e', tag: 'OPENROUTER');
      return false;
    }
  }

  /// Generate response using OpenRouter API directly (non-streaming)
  Future<String> generateWithOpenRouter({
    required String model,
    required String prompt,
    String? systemMessage,
  }) async {
    try {
      final messages = <Map<String, dynamic>>[];

      if (systemMessage != null && systemMessage.isNotEmpty) {
        messages.add({'role': 'system', 'content': systemMessage});
      }

      messages.add({'role': 'user', 'content': prompt});

      final response = await _dio.post(
        '/chat/completions',
        data: {'model': model, 'messages': messages, 'stream': false},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>?;
        if (choices != null && choices.isNotEmpty) {
          final message = choices[0]['message'] as Map<String, dynamic>?;
          return message?['content'] as String? ?? 'No response generated';
        }
      }

      return 'Error: Invalid response from OpenRouter';
    } on DioException catch (e) {
      if (e.response?.statusCode == 402) {
        return '⚠️ **Payment Required**\n\n'
            'The selected AI model requires credits or payment.\n\n'
            '**Solutions:**\n'
            '1. Use a FREE model instead:\n'
            '   • Llama 3.2 3B (Free)\n'
            '   • Mistral 7B (Free)\n'
            '   • Gemma 2 9B (Free)\n'
            '   • Phi-3 Mini (Free)\n\n'
            '2. Add credits to your OpenRouter account:\n'
            '   • Visit openrouter.ai\n'
            '   • Go to Settings > Credits\n'
            '   • Add credits to use premium models\n\n'
            '**To change model:**\n'
            'Go to Profile > LLM Settings and select a free model.';
      } else if (e.response?.statusCode == 401) {
        return '⚠️ **Invalid API Key**\n\n'
            'Your OpenRouter API key is invalid or expired.\n\n'
            'Please update your API key in:\n'
            'Profile > LLM Settings';
      } else if (e.response?.statusCode == 429) {
        return '⚠️ **Rate Limit Exceeded**\n\n'
            'You\'ve made too many requests. Please wait a moment and try again.';
      }

      return 'Error connecting to OpenRouter: ${e.message}';
    } catch (e) {
      return 'Error connecting to OpenRouter: $e';
    }
  }

  /// Generate response with streaming support
  Stream<String> generateStreamWithOpenRouter({
    required String model,
    required String prompt,
    String? systemMessage,
  }) async* {
    try {
      final messages = <Map<String, dynamic>>[];

      if (systemMessage != null && systemMessage.isNotEmpty) {
        messages.add({'role': 'system', 'content': systemMessage});
      }

      messages.add({'role': 'user', 'content': prompt});

      final response = await _dio.post(
        '/chat/completions',
        data: {'model': model, 'messages': messages, 'stream': true},
        options: Options(responseType: ResponseType.stream),
      );

      if (response.statusCode == 200 && response.data != null) {
        final stream = response.data.stream as Stream<List<int>>;

        await for (final chunk in stream) {
          final text = utf8.decode(chunk);
          final lines = text
              .split('\n')
              .where((line) => line.trim().isNotEmpty);

          for (final line in lines) {
            if (line.startsWith('data: ')) {
              final data = line.substring(6);
              if (data == '[DONE]') continue;

              try {
                final json = jsonDecode(data) as Map<String, dynamic>;
                final choices = json['choices'] as List<dynamic>?;
                if (choices != null && choices.isNotEmpty) {
                  final delta = choices[0]['delta'] as Map<String, dynamic>?;
                  final content = delta?['content'] as String?;
                  if (content != null && content.isNotEmpty) {
                    yield content;
                  }
                }
              } catch (e) {
                // Skip invalid JSON lines
                AppLogger.warning(
                  'Error parsing stream chunk: $e',
                  tag: 'OPENROUTER',
                );
              }
            }
          }
        }
      }
    } catch (e) {
      yield 'Error: $e';
    }
  }
}
