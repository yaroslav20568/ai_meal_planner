import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:logger/logger.dart';

class AppMetricaService {
  static AppMetricaService? _instance;
  static AppMetricaService get instance {
    _instance ??= AppMetricaService._();
    return _instance!;
  }

  AppMetricaService._();

  final Logger _logger = Logger();
  bool _isInitialized = false;

  Future<void> initialize({String? apiKey}) async {
    if (_isInitialized) {
      return;
    }

    if (apiKey == null || apiKey.isEmpty) {
      _logger.w('AppMetrica API key not provided, skipping initialization');
      return;
    }

    try {
      final config = AppMetricaConfig(
        apiKey,
        logs: true,
        sessionTimeout: 20,
        locationTracking: false,
      );

      await AppMetrica.activate(config);
      _isInitialized = true;
      _logger.i('AppMetrica initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize AppMetrica: $e');
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized;

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!isInitialized) {
      _logger.w('AppMetrica not initialized, skipping event: $name');
      return;
    }

    try {
      if (parameters != null && parameters.isNotEmpty) {
        final paramsString = parameters.entries
            .map((e) => '${e.key}=${e.value}')
            .join(', ');
        await AppMetrica.reportEvent('$name ($paramsString)');
      } else {
        await AppMetrica.reportEvent(name);
      }
      _logger.d('AppMetrica event logged: $name');
    } catch (e) {
      _logger.e('Failed to log AppMetrica event $name: $e');
    }
  }

  Future<void> setUserProperty({required String name, String? value}) async {
    if (!isInitialized) {
      _logger.w('AppMetrica not initialized, skipping user property: $name');
      return;
    }

    try {
      if (value != null) {
        await AppMetrica.setUserProfileID(value);
      }
      _logger.d('AppMetrica user property set: $name = $value');
    } catch (e) {
      _logger.e('Failed to set AppMetrica user property $name: $e');
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!isInitialized) {
      _logger.w('AppMetrica not initialized, skipping setUserId');
      return;
    }

    try {
      if (userId != null) {
        await AppMetrica.setUserProfileID(userId);
      }
      _logger.d('AppMetrica userId set: $userId');
    } catch (e) {
      _logger.e('Failed to set AppMetrica userId: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!isInitialized) {
      _logger.w(
        'AppMetrica not initialized, skipping screen view: $screenName',
      );
      return;
    }

    try {
      final eventName = screenClass != null
          ? 'screen_view: $screenName ($screenClass)'
          : 'screen_view: $screenName';
      await AppMetrica.reportEvent(eventName);
      _logger.d('AppMetrica screen view logged: $screenName');
    } catch (e) {
      _logger.e('Failed to log AppMetrica screen view $screenName: $e');
    }
  }

  Future<void> reportError({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (!isInitialized) {
      _logger.w('AppMetrica not initialized, skipping error report');
      return;
    }

    try {
      final errorMessage = error != null
          ? '$message: ${error.toString()}'
          : message;
      await AppMetrica.reportEvent('error: $errorMessage');
      _logger.d('AppMetrica error reported: $message');
    } catch (e) {
      _logger.e('Failed to report AppMetrica error: $e');
    }
  }
}
