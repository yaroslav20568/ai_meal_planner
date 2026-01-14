import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ai_meal_planner/models/index.dart';

class GeminiService {
  final Logger _logger = Logger();
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  String? get _apiKey => dotenv.env['GEMINI_API_KEY'];

  Future<String> generateMealPlan({
    required UserProfile userProfile,
    required int durationDays,
  }) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      _logger.e('GEMINI_API_KEY not found in .env');
      throw Exception('API key not found. Check .env file');
    }

    try {
      _logger.i('Starting meal plan generation request');

      final prompt = _buildPrompt(userProfile, durationDays);

      final response = await http
          .post(
            Uri.parse('$_baseUrl?key=$_apiKey'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt},
                  ],
                },
              ],
              'generationConfig': {
                'temperature': 0.7,
                'topK': 40,
                'topP': 0.95,
                'maxOutputTokens': 4096,
              },
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
        final content =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

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
1. Response must be in JSON format
2. JSON structure:
{
  "meals": [
    {
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

3. Create diverse meals for each day
4. Consider all restrictions and allergies
5. Total calories of all meals per day should be close to ${profile.dailyCalories} kcal
6. Ensure balance of macronutrients (proteins, fats, carbohydrates)
7. Include recipes for each meal

Return ONLY valid JSON without additional comments and formatting.
''';
  }
}
