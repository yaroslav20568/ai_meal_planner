import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class UserProfileScreen extends StatefulWidget {
  final UserProfile? initialProfile;

  const UserProfileScreen({super.key, this.initialProfile});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  Future<void> _onProfileCreated(UserProfile profile) async {
    final analytics = AnalyticsService.instance;
    final user = _authService.currentUser;
    final isUpdate = widget.initialProfile != null;

    if (user != null) {
      try {
        await _firestoreService.saveUserProfile(
          userId: user.uid,
          profile: profile,
        );

        await analytics.logEvent(
          name: isUpdate ? 'profile_update' : 'profile_save',
          parameters: {
            'has_allergies': profile.allergies.isNotEmpty,
            'has_restrictions': profile.dietaryRestrictions.isNotEmpty,
            'activity_level': profile.activityLevel,
            'goal': profile.goal,
          },
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save profile. Please try again.'),
            ),
          );
          return;
        }
      }
    }

    if (mounted) {
      Navigator.of(context).pushNamed('/generate', arguments: profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'User Profile',
      showSignOutButton: true,
      child: UserProfileForm(
        initialProfile: widget.initialProfile,
        onProfileCreated: _onProfileCreated,
      ),
    );
  }
}
