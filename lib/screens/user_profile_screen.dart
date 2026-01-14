import 'package:flutter/material.dart';
import 'package:ai_meal_planner/models/index.dart';
import 'package:ai_meal_planner/services/index.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  Future<void> _onProfileCreated(UserProfile profile) async {
    final user = _authService.currentUser;
    if (user != null) {
      try {
        await _firestoreService.saveUserProfile(
          userId: user.uid,
          profile: profile,
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
      child: UserProfileForm(onProfileCreated: _onProfileCreated),
    );
  }
}
