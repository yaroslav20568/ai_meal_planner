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
          : LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                final availableHeight = constraints.maxHeight;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: availableHeight),
                    child: IntrinsicHeight(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isLandscape
                                ? constraints.maxWidth * 0.1
                                : 24,
                            vertical: isLandscape ? 16 : 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: isLandscape ? 60 : 80,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(height: isLandscape ? 16 : 24),
                              const Text(
                                'Welcome to AI Meal Planner',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isLandscape ? 12 : 16),
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
                                SizedBox(height: isLandscape ? 12 : 16),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.errorColor,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              SizedBox(height: isLandscape ? 24 : 48),
                              Button(
                                text: 'Generate Meal Plan',
                                onPressed: _navigateToGenerate,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isLandscape ? 24 : 32,
                                  vertical: isLandscape ? 12 : 16,
                                ),
                                fontSize: isLandscape ? 16 : 18,
                              ),
                              if (_userProfile != null) ...[
                                SizedBox(height: isLandscape ? 12 : 16),
                                Button(
                                  text: 'Edit Profile',
                                  onPressed: _navigateToEditProfile,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isLandscape ? 24 : 32,
                                    vertical: isLandscape ? 12 : 16,
                                  ),
                                  fontSize: isLandscape ? 16 : 18,
                                ),
                              ],
                              const SizedBox(height: 24),
                              BannerAdWidget(
                                adUnitId: AdConstants.bannerAdUnitId,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
