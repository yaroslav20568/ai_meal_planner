import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:logger/logger.dart';

class AppsFlyerService {
  static AppsFlyerService? _instance;
  static AppsFlyerService get instance {
    _instance ??= AppsFlyerService._();
    return _instance!;
  }

  AppsFlyerService._();

  AppsflyerSdk? _appsFlyerSdk;
  final Logger _logger = Logger();
  bool _isInitialized = false;

  Future<void> initialize({String? devKey, String? appId}) async {
    if (_isInitialized) {
      return;
    }

    if (devKey == null || devKey.isEmpty) {
      _logger.w('AppsFlyer dev key not provided, skipping initialization');
      return;
    }

    try {
      final options = AppsFlyerOptions(
        afDevKey: devKey,
        appId: appId ?? '',
        showDebug: true,
        timeToWaitForATTUserAuthorization: 60,
      );

      _appsFlyerSdk = AppsflyerSdk(options);

      await _appsFlyerSdk!.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
      );

      _appsFlyerSdk!.onInstallConversionData((data) {
        _logger.d('AppsFlyer conversion data: $data');
      });

      _appsFlyerSdk!.onAppOpenAttribution((data) {
        _logger.d('AppsFlyer app open attribution: $data');
      });

      _isInitialized = true;
      _logger.i('AppsFlyer initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize AppsFlyer: $e');
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized && _appsFlyerSdk != null;

  Future<void> logEvent({
    required String eventName,
    Map<String, dynamic>? eventValues,
  }) async {
    if (!isInitialized) {
      _logger.w('AppsFlyer not initialized, skipping event: $eventName');
      return;
    }

    try {
      await _appsFlyerSdk!.logEvent(eventName, eventValues ?? {});
      _logger.d('AppsFlyer event logged: $eventName');
    } catch (e) {
      _logger.e('Failed to log AppsFlyer event $eventName: $e');
    }
  }

  Future<void> setUserId(String? userId) async {
    if (!isInitialized) {
      _logger.w('AppsFlyer not initialized, skipping setUserId');
      return;
    }

    try {
      if (userId != null) {
        _appsFlyerSdk!.setCustomerUserId(userId);
        _logger.d('AppsFlyer userId set: $userId');
      }
    } catch (e) {
      _logger.e('Failed to set AppsFlyer userId: $e');
    }
  }

  Future<void> setUserProperty({required String name, String? value}) async {
    if (!isInitialized) {
      _logger.w('AppsFlyer not initialized, skipping user property: $name');
      return;
    }

    try {
      _appsFlyerSdk!.setAdditionalData({name: value ?? ''});
      _logger.d('AppsFlyer user property set: $name = $value');
    } catch (e) {
      _logger.e('Failed to set AppsFlyer user property $name: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!isInitialized) {
      _logger.w('AppsFlyer not initialized, skipping screen view: $screenName');
      return;
    }

    try {
      final eventValues = <String, dynamic>{
        'screen_name': screenName,
        if (screenClass != null) 'screen_class': screenClass,
      };
      await _appsFlyerSdk!.logEvent('screen_view', eventValues);
      _logger.d('AppsFlyer screen view logged: $screenName');
    } catch (e) {
      _logger.e('Failed to log AppsFlyer screen view $screenName: $e');
    }
  }
}
