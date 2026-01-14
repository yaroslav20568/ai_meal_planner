import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/models/index.dart';

class OpenAIService {
  final Logger _logger = Logger();
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  String? get _apiKey => dotenv.env['OPENAI_API_KEY'];

  Future<String> generateMealPlan({
    required UserProfile userProfile,
    required int durationDays,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      _logger.e('OPENAI_API_KEY not found in .env');
      throw Exception('API key not found. Check .env file');
    }

    try {
      _logger.i('Starting meal plan generation request');

      final prompt = _buildPrompt(userProfile, durationDays);

      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': 'gpt-4o-mini',
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are a professional nutritionist. Generate meal plans in JSON format only, without any additional text or markdown formatting.',
                },
                {'role': 'user', 'content': prompt},
              ],
              'temperature': 0.7,
              'max_tokens': 8000,
            }),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              _logger.e('Request timeout');
              throw Exception('API request timeout exceeded');
            },
          );

      _logger.i('API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'];

        if (content != null) {
          _logger.i('Meal plan generated successfully');
          return content;
        } else {
          _logger.e('Invalid response format: ${response.body}');
          throw Exception('Invalid API response format');
        }
      } else {
        _logger.e('API error: ${response.statusCode} - ${response.body}');
        throw Exception('API error: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      _logger.e('Network error: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      _logger.e('Unexpected error: $e');
      rethrow;
    }
  }

  String _buildPrompt(UserProfile profile, int durationDays) {
    final restrictions = profile.dietaryRestrictions.isNotEmpty
        ? 'Dietary restrictions: ${profile.dietaryRestrictions.join(', ')}. '
        : '';

    final allergies = profile.allergies.isNotEmpty
        ? 'Allergies: ${profile.allergies.join(', ')}. '
        : '';

    return '''
Create a detailed meal plan for $durationDays days for a person with the following parameters:
- Name: ${profile.name}
- Age: ${profile.age} years
- Weight: ${profile.weight} kg
- Height: ${profile.height} cm
- Gender: ${profile.gender}
- Activity level: ${profile.activityLevel}
- Goal: ${profile.goal}
- Target daily calories: ${profile.dailyCalories} kcal
$restrictions$allergies

Response requirements:
1. Response must be in JSON format ONLY
2. JSON structure - IMPORTANT: Each meal MUST have a "day" field (1, 2, 3, etc.):
{
  "meals": [
    {
      "day": 1,
      "name": "meal name",
      "description": "brief description",
      "calories": number,
      "proteins": number in grams,
      "carbs": number in grams,
      "fats": number in grams,
      "ingredients": ["ingredient1", "ingredient2", ...],
      "mealType": "breakfast/lunch/dinner/snack",
      "recipe": "detailed cooking recipe"
    }
  ]
}

3. CRITICAL: Create DIFFERENT meals for EACH day. Do NOT repeat the same meals across days.
4. For each day, create breakfast, lunch, dinner, and optionally snacks
5. Total calories of all meals per day should be close to ${profile.dailyCalories} kcal
6. Ensure balance of macronutrients (proteins, fats, carbohydrates) for each day
7. Include recipes for each meal
8. Create unique meals for all $durationDays days - variety is essential

Return ONLY valid JSON without any markdown formatting, code blocks, or additional comments.
''';
  }
}
