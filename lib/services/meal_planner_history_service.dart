import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MealPlannerHistoryService {
  static const String _historyKeyPrefix = 'meal_planner_history_';
  static const String _currentSessionKeyPrefix =
      'meal_planner_current_session_';
  static const int _maxHistoryItems = 50;

  final String? _userId;

  MealPlannerHistoryService({String? userId}) : _userId = userId;

  String get _historyKey => '$_historyKeyPrefix${_userId ?? 'anonymous'}';
  String get _currentSessionKey =>
      '$_currentSessionKeyPrefix${_userId ?? 'anonymous'}';

  /// Save a conversation message
  Future<void> saveMessage({
    required String role, // 'user' or 'assistant'
    required String content,
    required String language,
    List<String>? ingredients,
    List<String>? preferences,
  }) async {
    // Don't save if no user ID is provided
    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    final message = {
      'role': role,
      'content': content,
      'language': language,
      'ingredients': ingredients ?? [],
      'preferences': preferences ?? [],
      'timestamp': DateTime.now().toIso8601String(),
    };

    history.add(message);

    // Keep only the last N messages
    if (history.length > _maxHistoryItems) {
      history.removeRange(0, history.length - _maxHistoryItems);
    }

    await prefs.setString(_historyKey, jsonEncode(history));
  }

  /// Get conversation history
  Future<List<Map<String, dynamic>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);

    if (historyJson == null || historyJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      // Log error silently in production
      return [];
    }
  }

  /// Get recent conversations (grouped by session)
  Future<List<Map<String, dynamic>>> getRecentConversations({
    int limit = 10,
  }) async {
    final history = await getHistory();

    // Group messages into conversations (sessions)
    final conversations = <Map<String, dynamic>>[];
    Map<String, dynamic>? currentConversation;

    for (final message in history.reversed) {
      if (message['role'] == 'user') {
        // Start a new conversation
        if (currentConversation != null) {
          conversations.add(currentConversation);
        }
        currentConversation = {
          'userMessage': message['content'],
          'timestamp': message['timestamp'],
          'language': message['language'],
          'ingredients': message['ingredients'],
          'preferences': message['preferences'],
        };
      } else if (message['role'] == 'assistant' &&
          currentConversation != null) {
        // Add assistant response to current conversation
        currentConversation['assistantMessage'] = message['content'];
      }

      if (conversations.length >= limit) break;
    }

    // Add the last conversation if it exists
    if (currentConversation != null &&
        !conversations.contains(currentConversation)) {
      conversations.add(currentConversation);
    }

    return conversations;
  }

  /// Save current session state
  Future<void> saveCurrentSession({
    required String userMessage,
    required String assistantResponse,
    required String language,
    List<String>? ingredients,
    List<String>? preferences,
  }) async {
    // Don't save if no user ID is provided
    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();

    final session = {
      'userMessage': userMessage,
      'assistantResponse': assistantResponse,
      'language': language,
      'ingredients': ingredients ?? [],
      'preferences': preferences ?? [],
      'timestamp': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_currentSessionKey, jsonEncode(session));
  }

  /// Get current session state
  Future<Map<String, dynamic>?> getCurrentSession() async {
    // Don't load if no user ID is provided
    if (_userId == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_currentSessionKey);

    if (sessionJson == null || sessionJson.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(sessionJson) as Map<String, dynamic>;
    } catch (e) {
      // Log error silently in production
      return null;
    }
  }

  /// Clear current session
  Future<void> clearCurrentSession() async {
    // Don't clear if no user ID is provided
    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentSessionKey);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    // Don't clear if no user ID is provided
    if (_userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    await prefs.remove(_currentSessionKey);
  }

  /// Search history by keyword
  Future<List<Map<String, dynamic>>> searchHistory(String keyword) async {
    final history = await getHistory();
    final lowerKeyword = keyword.toLowerCase();

    return history.where((message) {
      final content = (message['content'] as String).toLowerCase();
      return content.contains(lowerKeyword);
    }).toList();
  }

  /// Get history for a specific language
  Future<List<Map<String, dynamic>>> getHistoryByLanguage(
    String language,
  ) async {
    final history = await getHistory();
    return history.where((message) => message['language'] == language).toList();
  }
}
