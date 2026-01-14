import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/screens/index.dart';
import 'package:ai_meal_planner/models/index.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Meal Planner',
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/generate': (context) {
          final profile =
              ModalRoute.of(context)!.settings.arguments as UserProfile;
          return MealPlanGenerationScreen(userProfile: profile);
        },
        '/meal-plan': (context) {
          final mealPlan =
              ModalRoute.of(context)!.settings.arguments as MealPlan;
          return MealPlanDisplayScreen(mealPlan: mealPlan);
        },
      },
    );
  }
}
