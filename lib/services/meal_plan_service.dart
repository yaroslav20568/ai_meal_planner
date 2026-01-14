import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/gemini_service.dart';

class MealPlanService {
  final Logger _logger = Logger();
  final GeminiService _geminiService = GeminiService();

  Future<MealPlan> generateMealPlan({
    required UserProfile userProfile,
    required int durationDays,
  }) async {
    try {
      _logger.i('Generating meal plan for ${userProfile.name}');

      final aiResponse = await _geminiService.generateMealPlan(
        userProfile: userProfile,
        durationDays: durationDays,
      );

      final meals = _parseMealsFromResponse(aiResponse);

      final totalCalories = meals.fold<double>(
        0,
        (sum, meal) => sum + meal.calories,
      );
      final totalProteins = meals.fold<double>(
        0,
        (sum, meal) => sum + meal.proteins,
      );
      final totalCarbs = meals.fold<double>(0, (sum, meal) => sum + meal.carbs);
      final totalFats = meals.fold<double>(0, (sum, meal) => sum + meal.fats);

      final mealPlan = MealPlan(
        createdAt: DateTime.now(),
        userProfile: userProfile,
        meals: meals,
        durationDays: durationDays,
        totalCalories: totalCalories,
        totalProteins: totalProteins,
        totalCarbs: totalCarbs,
        totalFats: totalFats,
      );

      _logger.i('Meal plan generated successfully with ${meals.length} meals');
      return mealPlan;
    } catch (e) {
      _logger.e('Error generating meal plan: $e');
      rethrow;
    }
  }

  List<Meal> _parseMealsFromResponse(String response) {
    try {
      String cleanedResponse = response.trim();

      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(
          0,
          cleanedResponse.length - 3,
        );
      }
      cleanedResponse = cleanedResponse.trim();

      final jsonData = jsonDecode(cleanedResponse) as Map<String, dynamic>;
      final mealsList = jsonData['meals'] as List<dynamic>;

      return mealsList
          .map((mealJson) => Meal.fromJson(mealJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.e('Error parsing meals from response: $e');
      _logger.e('Response was: $response');
      throw Exception('Error parsing AI response: ${e.toString()}');
    }
  }
}
