import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/screens/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/navigation/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = Logger();

  try {
    await dotenv.load(fileName: '.env');
    logger.i('Environment variables loaded successfully');
  } catch (e) {
    logger.e('Failed to load .env file: $e');
    rethrow;
  }

  try {
    await Firebase.initializeApp();
    final firebaseApp = Firebase.app();
    logger.i('Firebase initialized successfully: ${firebaseApp.name}');
  } catch (e) {
    logger.e('Firebase initialization failed: $e');
    rethrow;
  }

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
    logger.e('Analytics initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final AnalyticsRouteObserver routeObserver = AnalyticsRouteObserver();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return MaterialApp(
      title: 'AI Meal Planner',
      theme: ThemeData(useMaterial3: true),
      navigatorObservers: [routeObserver],
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainScreen();
          }
          return const AuthScreen();
        },
      ),
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
