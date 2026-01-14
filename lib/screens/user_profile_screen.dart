import 'package:flutter/material.dart';
import 'package:ai_meal_planner/widgets/index.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'User Profile',
      child: UserProfileForm(
        onProfileCreated: (profile) {
          Navigator.of(context).pushNamed('/generate', arguments: profile);
        },
      ),
    );
  }
}
