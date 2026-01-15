import 'package:flutter/material.dart';
import 'package:ai_meal_planner/services/index.dart';

class AnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final FirebaseAnalyticsService _firebaseAnalytics =
      FirebaseAnalyticsService.instance;
  final AppMetricaService _appmetrica = AppMetricaService.instance;
  final AppsFlyerService _appsflyer = AppsFlyerService.instance;

  void _sendScreenView(PageRoute<dynamic> route) {
    final String? screenName = route.settings.name;
    if (screenName == null || screenName.isEmpty) {
      return;
    }

    final String screenClass =
        route.settings.arguments?.toString() ?? screenName;

    _firebaseAnalytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );

    _appmetrica.logScreenView(screenName: screenName, screenClass: screenClass);

    _appsflyer.logScreenView(screenName: screenName, screenClass: screenClass);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && previousRoute.settings.name != null) {
      _sendScreenView(previousRoute);
    }
  }
}
