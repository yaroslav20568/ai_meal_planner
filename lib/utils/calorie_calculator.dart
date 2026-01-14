import 'package:ai_meal_planner/models/index.dart';

class CalorieCalculator {
  static int calculateDailyCalories(UserProfile profile) {
    double bmr;

    if (profile.gender.toLowerCase() == 'male' ||
        profile.gender.toLowerCase() == 'm' ||
        profile.gender.toLowerCase() == 'мужской') {
      bmr =
          88.362 +
          (13.397 * profile.weight) +
          (4.799 * profile.height) -
          (5.677 * profile.age);
    } else {
      bmr =
          447.593 +
          (9.247 * profile.weight) +
          (3.098 * profile.height) -
          (4.330 * profile.age);
    }

    double activityMultiplier;
    switch (profile.activityLevel.toLowerCase()) {
      case 'sedentary':
      case 'минимальная':
        activityMultiplier = 1.2;
        break;
      case 'light':
      case 'легкая':
        activityMultiplier = 1.375;
        break;
      case 'moderate':
      case 'умеренная':
        activityMultiplier = 1.55;
        break;
      case 'active':
      case 'высокая':
        activityMultiplier = 1.725;
        break;
      case 'very active':
      case 'очень высокая':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.375;
    }

    double tdee = bmr * activityMultiplier;

    switch (profile.goal.toLowerCase()) {
      case 'weight loss':
      case 'похудение':
        tdee *= 0.85;
        break;
      case 'weight gain':
      case 'muscle gain':
      case 'набор массы':
        tdee *= 1.15;
        break;
      case 'maintenance':
      case 'поддержание':
      default:
        break;
    }

    return tdee.round();
  }
}
