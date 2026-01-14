import 'package:flutter/material.dart';
import 'package:ai_meal_planner/constants/index.dart';
import 'package:ai_meal_planner/services/index.dart';

class ScreenLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showSignOutButton;

  const ScreenLayout({
    super.key,
    required this.title,
    required this.child,
    this.showSignOutButton = false,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signOut();
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/auth', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign out. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.surfaceColor,
        actions: showSignOutButton
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _handleSignOut(context),
                  tooltip: 'Sign out',
                ),
              ]
            : null,
      ),
      body: SafeArea(child: child),
    );
  }
}
