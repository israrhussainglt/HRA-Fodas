import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../core/utils/logger.dart';

class VoiceInputService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  /// Initialize speech recognition
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Check if microphone permission is already granted
      var status = await Permission.microphone.status;

      // Only request if not already granted
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          AppLogger.warning('Microphone permission denied', tag: 'VOICE_INPUT');
          return false;
        }
      }

      // Initialize speech recognition
      _isInitialized = await _speech.initialize(
        onError: (error) {
          AppLogger.error(
            'Speech recognition error: ${error.errorMsg}',
            tag: 'VOICE_INPUT',
          );
        },
        onStatus: (status) {
          AppLogger.debug(
            'Speech recognition status: $status',
            tag: 'VOICE_INPUT',
          );
        },
        debugLogging: false,
      );

      return _isInitialized;
    } catch (e) {
      AppLogger.error(
        'Error initializing speech recognition: $e',
        tag: 'VOICE_INPUT',
      );
      return false;
    }
  }

  /// Check if speech recognition is available
  bool get isAvailable => _speech.isAvailable;

  /// Check if currently listening
  bool get isListening => _speech.isListening;

  /// Get available locales for speech recognition
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speech.locales();
  }

  /// Start listening for voice input
  Future<void> startListening({
    required Function(String text) onResult,
    required Function(double level) onSoundLevel,
    String localeId = 'en_US',
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) {
        throw Exception('Failed to initialize speech recognition');
      }
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    AppLogger.debug(
      'Starting to listen with locale: $localeId',
      tag: 'VOICE_INPUT',
    );

    await _speech.listen(
      onResult: (result) {
        AppLogger.debug(
          'Speech result: ${result.recognizedWords}, final: ${result.finalResult}',
          tag: 'VOICE_INPUT',
        );
        onResult(result.recognizedWords);
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 5),
      onSoundLevelChange: (level) {
        onSoundLevel(level);
      },
      localeId: localeId,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      ),
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
  }

  /// Dispose resources
  void dispose() {
    _speech.stop();
  }

  /// Get locale ID from language name
  String getLocaleId(String language) {
    final localeMap = {
      'English': 'en_US',
      'Chinese': 'zh_CN',
      'Spanish': 'es_ES',
      'Hindi': 'hi_IN',
      'Arabic': 'ar_SA',
      'French': 'fr_FR',
      'Russian': 'ru_RU',
      'Portuguese': 'pt_BR',
      'German': 'de_DE',
      'Japanese': 'ja_JP',
    };
    return localeMap[language] ?? 'en_US';
  }
}
