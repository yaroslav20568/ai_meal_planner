import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
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
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
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

      final user = _authService.currentUser;
      if (user != null) {
        try {
          await _firestoreService.saveMealPlan(
            userId: user.uid,
            mealPlan: mealPlan,
          );
        } catch (e) {
          if (mounted) {
            setState(() {
              _errorMessage =
                  'Meal plan generated but failed to save. Please try again.';
              _isGenerating = false;
            });
            return;
          }
        }
      }

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
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
            Button(
              text: 'Generate Meal Plan',
              onPressed: _generateMealPlan,
              isLoading: _isGenerating,
              loadingText: 'Generating plan...',
            ),
            if (_isGenerating) ...[
              const SizedBox(height: 24),
              const Text(
                'This may take a few minutes...',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
