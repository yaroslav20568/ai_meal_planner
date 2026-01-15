import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlanDisplayScreen extends StatefulWidget {
  final String mealPlanId;

  const MealPlanDisplayScreen({super.key, required this.mealPlanId});

  @override
  State<MealPlanDisplayScreen> createState() => _MealPlanDisplayScreenState();
}

class _MealPlanDisplayScreenState extends State<MealPlanDisplayScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  MealPlan? _mealPlan;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }

  Future<void> _loadMealPlan() async {
    final user = _authService.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not authenticated';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final mealPlan = await _firestoreService.getMealPlan(
        userId: user.uid,
        mealPlanId: widget.mealPlanId,
      );
      if (mounted) {
        setState(() {
          _mealPlan = mealPlan;
          _isLoading = false;
          if (mealPlan == null) {
            _errorMessage = 'Meal plan not found';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load meal plan';
        });
      }
    }
  }

  Map<int, List<Meal>> _groupMealsByDay(MealPlan mealPlan) {
    final mealsByDay = <int, List<Meal>>{};
    for (var meal in mealPlan.meals) {
      mealsByDay.putIfAbsent(meal.day, () => []).add(meal);
    }
    return mealsByDay;
  }

  List<int> _getSortedDays(Map<int, List<Meal>> mealsByDay) {
    return mealsByDay.keys.toList()..sort();
  }

  Widget _buildDaySection(int day, Map<int, List<Meal>> mealsByDay) {
    final meals = mealsByDay[day]!;
    return DaySection(day: day, meals: meals);
  }

  Widget _buildContent() {
    if (_mealPlan == null) {
      return const SizedBox.shrink();
    }

    final mealsByDay = _groupMealsByDay(_mealPlan!);
    final sortedDays = _getSortedDays(mealsByDay);

    return Column(
      children: [
        MealPlanSummaryHeader(mealPlan: _mealPlan!),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedDays.length,
            itemBuilder: (context, index) =>
                _buildDaySection(sortedDays[index], mealsByDay),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Meal Plan',
      showSignOutButton: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadMealPlan,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _buildContent(),
    );
  }
}
