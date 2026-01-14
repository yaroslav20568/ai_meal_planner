import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _authService.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final profile = await _firestoreService.getUserProfile(user.uid);
      if (mounted) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load profile';
        });
      }
    }
  }

  void _navigateToGenerate() {
    if (_userProfile != null) {
      Navigator.of(context).pushNamed('/generate', arguments: _userProfile);
    } else {
      Navigator.of(context).pushNamed('/profile');
    }
  }

  void _navigateToEditProfile() {
    if (_userProfile != null) {
      Navigator.of(context).pushNamed('/profile', arguments: _userProfile);
    } else {
      Navigator.of(context).pushNamed('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'AI Meal Planner',
      showSignOutButton: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 80,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome to AI Meal Planner',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userProfile != null
                          ? 'Create a personalized meal plan based on your goals and preferences'
                          : 'Create your profile to get started with personalized meal plans',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.errorColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 48),
                    Button(
                      text: 'Generate Meal Plan',
                      onPressed: _navigateToGenerate,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      fontSize: 18,
                    ),
                    if (_userProfile != null) ...[
                      const SizedBox(height: 16),
                      Button(
                        text: 'Edit Profile',
                        onPressed: _navigateToEditProfile,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        fontSize: 18,
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
