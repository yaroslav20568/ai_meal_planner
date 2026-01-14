import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/utils/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class UserProfileForm extends StatefulWidget {
  final UserProfile? initialProfile;
  final ValueChanged<UserProfile> onProfileCreated;

  const UserProfileForm({
    super.key,
    this.initialProfile,
    required this.onProfileCreated,
  });

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  late String _gender;
  late String _activityLevel;
  late String _goal;
  late final List<String> _dietaryRestrictions;
  late final List<String> _allergies;

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
  void initState() {
    super.initState();
    if (widget.initialProfile != null) {
      final profile = widget.initialProfile!;
      _nameController = TextEditingController(text: profile.name);
      _ageController = TextEditingController(text: profile.age.toString());
      _weightController = TextEditingController(
        text: profile.weight.toString(),
      );
      _heightController = TextEditingController(
        text: profile.height.toString(),
      );
      _gender = profile.gender;
      _activityLevel = profile.activityLevel;
      _goal = profile.goal;
      _dietaryRestrictions = List<String>.from(profile.dietaryRestrictions);
      _allergies = List<String>.from(profile.allergies);
    } else {
      _nameController = TextEditingController();
      _ageController = TextEditingController();
      _weightController = TextEditingController();
      _heightController = TextEditingController();
      _gender = 'Male';
      _activityLevel = 'Moderate';
      _goal = 'Maintenance';
      _dietaryRestrictions = [];
      _allergies = [];
      _fillNameFromGoogleAccount();
    }
  }

  void _fillNameFromGoogleAccount() {
    final user = _authService.currentUser;
    if (user != null &&
        user.displayName != null &&
        user.displayName!.isNotEmpty) {
      _nameController.text = user.displayName!;
    }
  }

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
          SelectableChipsSection(
            title: 'Dietary Restrictions',
            availableItems: _availableRestrictions,
            selectedItems: _dietaryRestrictions,
            onItemToggled: (restriction) {
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
          SelectableChipsSection(
            title: 'Allergies',
            availableItems: _availableAllergies,
            selectedItems: _allergies,
            onItemToggled: (allergy) {
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
          Button(text: 'Create Meal Plan', onPressed: _calculateAndSave),
        ],
      ),
    );
  }
}
