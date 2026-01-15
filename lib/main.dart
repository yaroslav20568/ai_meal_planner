import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_meal_planner/screens/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/navigation/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await InitInStartService.initializeServices();

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
