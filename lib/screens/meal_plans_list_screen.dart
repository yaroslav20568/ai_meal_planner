import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class MealPlansListScreen extends StatefulWidget {
  const MealPlansListScreen({super.key});

  @override
  State<MealPlansListScreen> createState() => _MealPlansListScreenState();
}

class _MealPlansListScreenState extends State<MealPlansListScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  List<MealPlan> _mealPlans = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMealPlans();
    AnalyticsService.instance.logEvent(name: 'meal_plan_list_view');
  }

  Future<void> _loadMealPlans() async {
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
      final mealPlans = await _firestoreService.getMealPlans(user.uid);
      setState(() {
        _mealPlans = mealPlans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load meal plans';
      });
    }
  }

  void _navigateToMealPlan(MealPlan mealPlan) {
    if (mealPlan.id == null) {
      return;
    }
    Navigator.of(context).pushNamed('/meal-plan', arguments: mealPlan.id);
  }

  Widget _buildMealPlanCard(MealPlan mealPlan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          'Meal Plan - ${mealPlan.durationDays} days',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Created: ${_formatDate(mealPlan.createdAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total calories: ${mealPlan.totalCalories.toStringAsFixed(0)} kcal',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _navigateToMealPlan(mealPlan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Meal Plans',
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
                    onPressed: _loadMealPlans,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _mealPlans.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No meal plans yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first meal plan in the Planner tab',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadMealPlans,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _mealPlans.length,
                itemBuilder: (context, index) =>
                    _buildMealPlanCard(_mealPlans[index]),
              ),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
