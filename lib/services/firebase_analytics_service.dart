import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class FirebaseAnalyticsService {
  static FirebaseAnalyticsService? _instance;
  static FirebaseAnalyticsService get instance {
    _instance ??= FirebaseAnalyticsService._();
    return _instance!;
  }

  FirebaseAnalyticsService._();

  FirebaseAnalytics? _analytics;
  final Logger _logger = Logger();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    try {
      _analytics = FirebaseAnalytics.instance;
      _isInitialized = true;
      _logger.i('Firebase Analytics initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize Firebase Analytics: $e');
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized && _analytics != null;

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!isInitialized) {
      _logger.w('Firebase Analytics not initialized, skipping event: $name');
      return;
    }

    try {
      await _analytics!.logEvent(name: name, parameters: parameters);
      _logger.d('Firebase Analytics event logged: $name');
    } catch (e) {
      _logger.e('Failed to log Firebase Analytics event $name: $e');
    }
  }

  Future<void> setUserProperty({required String name, String? value}) async {
    if (!isInitialized) {
      _logger.w(
        'Firebase Analytics not initialized, skipping user property: $name',
      );
      return;
    }

    try {
      await _analytics!.setUserProperty(name: name, value: value);
      _logger.d('Firebase Analytics user property set: $name = $value');
    } catch (e) {
      _logger.e('Failed to set Firebase Analytics user property $name: $e');
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!isInitialized) {
      _logger.w('Firebase Analytics not initialized, skipping setUserId');
      return;
    }

    try {
      await _analytics!.setUserId(id: userId);
      _logger.d('Firebase Analytics userId set: $userId');
    } catch (e) {
      _logger.e('Failed to set Firebase Analytics userId: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!isInitialized) {
      _logger.w(
        'Firebase Analytics not initialized, skipping screen view: $screenName',
      );
      return;
    }

    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      _logger.d('Firebase Analytics screen view logged: $screenName');
    } catch (e) {
      _logger.e('Failed to log Firebase Analytics screen view $screenName: $e');
    }
  }

  Future<void> logAppOpen() async {
    if (!isInitialized) {
      _logger.w('Firebase Analytics not initialized, skipping app_open');
      return;
    }

    try {
      await _analytics!.logAppOpen();
      _logger.d('Firebase Analytics app_open event logged');
    } catch (e) {
      _logger.e('Failed to log Firebase Analytics app_open: $e');
    }
  }

  Future<void> resetAnalyticsData() async {
    if (!isInitialized) {
      _logger.w('Firebase Analytics not initialized, skipping reset');
      return;
    }

    try {
      await _analytics!.resetAnalyticsData();
      _logger.i('Firebase Analytics data reset');
    } catch (e) {
      _logger.e('Failed to reset Firebase Analytics data: $e');
    }
  }
}
