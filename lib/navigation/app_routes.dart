import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/screens/index.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/auth': (context) => const AuthScreen(),
    '/profile': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final profile = arguments is UserProfile ? arguments : null;
      return UserProfileScreen(initialProfile: profile);
    },
    '/generate': (context) {
      final profile = ModalRoute.of(context)!.settings.arguments as UserProfile;
      return MealPlanGenerationScreen(userProfile: profile);
    },
    '/meal-plan': (context) {
      final mealPlanId = ModalRoute.of(context)!.settings.arguments as String;
      return MealPlanDisplayScreen(mealPlanId: mealPlanId);
    },
  };
}
