import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/utils/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class UserProfileForm extends StatefulWidget {
  final ValueChanged<UserProfile> onProfileCreated;

  const UserProfileForm({super.key, required this.onProfileCreated});

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _gender = 'Male';
  String _activityLevel = 'Moderate';
  String _goal = 'Maintenance';
  final List<String> _dietaryRestrictions = [];
  final List<String> _allergies = [];

  final List<String> _availableRestrictions = [
    'Vegetarian',
    'Vegan',
    'Gluten-free',
    'Lactose-free',
    'Keto',
    'Paleo',
  ];

  final List<String> _availableAllergies = [
    'Nuts',
    'Dairy',
    'Eggs',
    'Fish',
    'Seafood',
    'Soy',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateAndSave() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        height: double.parse(_heightController.text),
        gender: _gender,
        activityLevel: _activityLevel,
        goal: _goal,
        dietaryRestrictions: _dietaryRestrictions,
        allergies: _allergies,
        dailyCalories: CalorieCalculator.calculateDailyCalories(
          UserProfile(
            name: _nameController.text,
            age: int.parse(_ageController.text),
            weight: double.parse(_weightController.text),
            height: double.parse(_heightController.text),
            gender: _gender,
            activityLevel: _activityLevel,
            goal: _goal,
            dietaryRestrictions: _dietaryRestrictions,
            allergies: _allergies,
            dailyCalories: 0,
          ),
        ),
      );

      widget.onProfileCreated(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PersonalInfoFields(
            nameController: _nameController,
            ageController: _ageController,
            gender: _gender,
            onGenderChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          PhysicalInfoFields(
            weightController: _weightController,
            heightController: _heightController,
          ),
          const SizedBox(height: 16),
          ActivityAndGoalFields(
            activityLevel: _activityLevel,
            goal: _goal,
            onActivityLevelChanged: (value) {
              setState(() {
                _activityLevel = value;
              });
            },
            onGoalChanged: (value) {
              setState(() {
                _goal = value;
              });
            },
          ),
          const SizedBox(height: 24),
          DietaryRestrictionsSection(
            availableRestrictions: _availableRestrictions,
            selectedRestrictions: _dietaryRestrictions,
            onRestrictionToggled: (restriction) {
              setState(() {
                if (_dietaryRestrictions.contains(restriction)) {
                  _dietaryRestrictions.remove(restriction);
                } else {
                  _dietaryRestrictions.add(restriction);
                }
              });
            },
          ),
          const SizedBox(height: 24),
          AllergiesSection(
            availableAllergies: _availableAllergies,
            selectedAllergies: _allergies,
            onAllergyToggled: (allergy) {
              setState(() {
                if (_allergies.contains(allergy)) {
                  _allergies.remove(allergy);
                } else {
                  _allergies.add(allergy);
                }
              });
            },
          ),
          const SizedBox(height: 32),
          PrimaryButton(text: 'Create Meal Plan', onPressed: _calculateAndSave),
        ],
      ),
    );
  }
}
