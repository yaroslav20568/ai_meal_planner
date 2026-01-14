import 'package:ai_meal_planner/models/meal.dart';
import 'package:ai_meal_planner/models/user_profile.dart';

class MealPlan {
  final String? id;
  final DateTime createdAt;
  final UserProfile userProfile;
  final List<Meal> meals;
  final int durationDays;
  final double totalCalories;
  final double totalProteins;
  final double totalCarbs;
  final double totalFats;

  MealPlan({
    this.id,
    required this.createdAt,
    required this.userProfile,
    required this.meals,
    required this.durationDays,
    required this.totalCalories,
    required this.totalProteins,
    required this.totalCarbs,
    required this.totalFats,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'userProfile': userProfile.toJson(),
      'meals': meals.map((m) => m.toJson()).toList(),
      'durationDays': durationDays,
      'totalCalories': totalCalories,
      'totalProteins': totalProteins,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    };
  }

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      userProfile: UserProfile.fromJson(json['userProfile']),
      meals: (json['meals'] as List)
          .map((m) => Meal.fromJson(m as Map<String, dynamic>))
          .toList(),
      durationDays: json['durationDays'] ?? 0,
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalProteins: (json['totalProteins'] ?? 0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0).toDouble(),
      totalFats: (json['totalFats'] ?? 0).toDouble(),
    );
  }
}
