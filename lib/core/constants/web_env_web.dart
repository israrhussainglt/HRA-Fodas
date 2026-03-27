// Web implementation
import 'package:web/web.dart' as web;

String? getWebEnv(String key) {
  try {
    // Access window.localStorage directly
    final env = web.window.localStorage.getItem('ENV_$key');
    if (env != null) return env;

    // Fallback: try to read from a global variable
    // This is a simplified approach for web
    return null;
  } catch (e) {
    // Fallback if ENV is not available
  }
  return null;
}
