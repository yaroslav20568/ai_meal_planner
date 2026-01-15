import 'package:logger/logger.dart';
import 'package:ai_meal_planner/services/analytics/firebase_analytics_service.dart';
import 'package:ai_meal_planner/services/analytics/appmetrica_service.dart';
import 'package:ai_meal_planner/services/analytics/appsflyer_service.dart';

class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance {
    _instance ??= AnalyticsService._();
    return _instance!;
  }

  AnalyticsService._();

  final Logger _logger = Logger();
  final FirebaseAnalyticsService _firebase = FirebaseAnalyticsService.instance;
  final AppMetricaService _appmetrica = AppMetricaService.instance;
  final AppsFlyerService _appsflyer = AppsFlyerService.instance;

  bool _isInitialized = false;

  Future<void> initialize({
    String? appmetricaApiKey,
    String? appsflyerDevKey,
    String? appsflyerAppId,
  }) async {
    if (_isInitialized) {
      return;
    }

    try {
      await _firebase.initialize();
      await _firebase.logAppOpen();
    } catch (e) {
      _logger.e('Failed to initialize Firebase Analytics: $e');
    }

    try {
      await _appmetrica.initialize(apiKey: appmetricaApiKey);
    } catch (e) {
      _logger.e('Failed to initialize AppMetrica: $e');
    }

    try {
      await _appsflyer.initialize(
        devKey: appsflyerDevKey,
        appId: appsflyerAppId,
      );
    } catch (e) {
      _logger.e('Failed to initialize AppsFlyer: $e');
    }

    _isInitialized = true;
    _logger.i('Analytics services initialized');
  }

  bool get isInitialized => _isInitialized;

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_isInitialized) {
      _logger.w('Analytics not initialized, skipping event: $name');
      return;
    }

    try {
      final appsflyerParams = parameters?.map<String, dynamic>(
        (key, value) => MapEntry(
          key,
          value is String
              ? value
              : value is num
              ? value
              : value.toString(),
        ),
      );

      await Future.wait([
        _firebase.logEvent(name: name, parameters: parameters),
        _appmetrica.logEvent(name: name, parameters: parameters),
        _appsflyer.logEvent(eventName: name, eventValues: appsflyerParams),
      ], eagerError: false);
      _logger.d('Analytics event logged to all services: $name');
    } catch (e) {
      _logger.e('Failed to log analytics event $name: $e');
    }
  }

  Future<void> setUserProperty({required String name, String? value}) async {
    if (!_isInitialized) {
      _logger.w('Analytics not initialized, skipping user property: $name');
      return;
    }

    try {
      await Future.wait([
        _firebase.setUserProperty(name: name, value: value),
        _appmetrica.setUserProperty(name: name, value: value),
        _appsflyer.setUserProperty(name: name, value: value),
      ], eagerError: false);
      _logger.d('Analytics user property set in all services: $name = $value');
    } catch (e) {
      _logger.e('Failed to set analytics user property $name: $e');
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!_isInitialized) {
      _logger.w('Analytics not initialized, skipping setUserId');
      return;
    }

    try {
      await Future.wait([
        _firebase.setUserId(userId),
        _appmetrica.setUserId(userId),
        _appsflyer.setUserId(userId),
      ], eagerError: false);
      _logger.d('Analytics userId set in all services: $userId');
    } catch (e) {
      _logger.e('Failed to set analytics userId: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isInitialized) {
      _logger.w('Analytics not initialized, skipping screen view: $screenName');
      return;
    }

    try {
      await Future.wait([
        _firebase.logScreenView(
          screenName: screenName,
          screenClass: screenClass,
        ),
        _appmetrica.logScreenView(
          screenName: screenName,
          screenClass: screenClass,
        ),
        _appsflyer.logScreenView(
          screenName: screenName,
          screenClass: screenClass,
        ),
      ], eagerError: false);
      _logger.d('Analytics screen view logged to all services: $screenName');
    } catch (e) {
      _logger.e('Failed to log analytics screen view $screenName: $e');
    }
  }

  Future<void> logAppOpen() async {
    if (!_isInitialized) {
      _logger.w('Analytics not initialized, skipping app_open');
      return;
    }

    try {
      await _firebase.logAppOpen();
      _logger.d('Analytics app_open event logged');
    } catch (e) {
      _logger.e('Failed to log analytics app_open: $e');
    }
  }

  bool get isFirebaseInitialized => _firebase.isInitialized;
  bool get isAppMetricaInitialized => _appmetrica.isInitialized;
  bool get isAppsFlyerInitialized => _appsflyer.isInitialized;
}
