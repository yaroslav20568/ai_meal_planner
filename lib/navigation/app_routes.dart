import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/screens/index.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/auth': (context) => const AuthScreen(),
    '/profile': (context) => const UserProfileScreen(),
    '/generate': (context) {
      final profile = ModalRoute.of(context)!.settings.arguments as UserProfile;
      return MealPlanGenerationScreen(userProfile: profile);
    },
    '/meal-plan': (context) {
      final mealPlan = ModalRoute.of(context)!.settings.arguments as MealPlan;
      return MealPlanDisplayScreen(mealPlan: mealPlan);
    },
  };
}
