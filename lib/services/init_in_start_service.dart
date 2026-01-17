import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/services/index.dart';

class InitInStartService {
  static final Logger _logger = Logger();

  static Future<void> initializeServices() async {
    _logger.i(
      '=== AI Meal Planner - InitInStartService - Services Initialization ===',
    );
    await _loadEnvironmentVariables();
    await _initializeFirebase();
    await _requestATTAuthorization();
    await _initializeAnalytics();
    await _initializeAds();
    _logger.i('=== InitInStartService - Services Initialization Complete ===');
  }

  static Future<void> _loadEnvironmentVariables() async {
    try {
      await dotenv.load(fileName: '.env');
      _logger.i('Environment variables loaded successfully');
    } catch (e) {
      _logger.e('Failed to load .env file: $e');
      rethrow;
    }
  }

  static Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      final firebaseApp = Firebase.app();
      _logger.i('Firebase initialized successfully: ${firebaseApp.name}');
    } catch (e) {
      _logger.e('Firebase initialization failed: $e');
      rethrow;
    }
  }

  static Future<void> _requestATTAuthorization() async {
    try {
      final attService = ATTService.instance;
      final status = await attService.requestTrackingAuthorization();
      _logger.i('ATT authorization requested, status: $status');
    } catch (e) {
      _logger.e('Failed to request ATT authorization: $e');
    }
  }

  static Future<void> _initializeAnalytics() async {
    try {
      final appmetricaApiKey = dotenv.env['APPMETRICA_API_KEY'];
      final appsflyerDevKey = dotenv.env['APPSFLYER_DEV_KEY'];
      final appsflyerAppId = dotenv.env['APPSFLYER_APP_ID'];

      await AnalyticsService.instance.initialize(
        appmetricaApiKey: appmetricaApiKey,
        appsflyerDevKey: appsflyerDevKey,
        appsflyerAppId: appsflyerAppId,
      );
    } catch (e) {
      _logger.e('Analytics initialization failed: $e');
    }
  }

  static Future<void> _initializeAds() async {
    try {
      await AdService.instance.initialize();
    } catch (e) {
      _logger.e('AdMob initialization failed: $e');
    }
  }
}
