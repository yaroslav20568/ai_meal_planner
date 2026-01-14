import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlanGenerationForm extends StatefulWidget {
  final UserProfile userProfile;
  final ValueChanged<MealPlan> onMealPlanGenerated;

  const MealPlanGenerationForm({
    super.key,
    required this.userProfile,
    required this.onMealPlanGenerated,
  });

  @override
  State<MealPlanGenerationForm> createState() => _MealPlanGenerationFormState();
}

class _MealPlanGenerationFormState extends State<MealPlanGenerationForm> {
  final MealPlanService _mealPlanService = MealPlanService();
  bool _isGenerating = false;
  String? _errorMessage;
  int _durationDays = 7;

  Future<void> _generateMealPlan() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final mealPlan = await _mealPlanService.generateMealPlan(
        userProfile: widget.userProfile,
        durationDays: _durationDays,
      );

      if (!mounted) return;

      widget.onMealPlanGenerated(mealPlan);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Failed to generate meal plan. Please try again.';
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileSummaryCard(userProfile: widget.userProfile),
          const SizedBox(height: 24),
          DurationSlider(
            durationDays: _durationDays,
            onDurationChanged: (value) {
              setState(() {
                _durationDays = value;
              });
            },
          ),
          const SizedBox(height: 32),
          if (_errorMessage != null)
            ErrorMessageWidget(message: _errorMessage!),
          PrimaryButton(
            text: 'Generate Meal Plan',
            onPressed: _generateMealPlan,
            isLoading: _isGenerating,
            loadingText: 'Generating plan...',
            helperText: _isGenerating ? 'This may take a few minutes...' : null,
          ),
        ],
      ),
    );
  }
}
