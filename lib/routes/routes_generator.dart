import 'package:flutter/material.dart';
import 'package:quizu/exports/screens.dart';
import 'package:quizu/exports/utils.dart' show FirestoreBuilder;
import 'package:quizu/routes/routes.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => LoginScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.result:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => ResultScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.home:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => HomeScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.ranking:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => RankingScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.profile:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => ProfileScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.verification:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => VerificationScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.registeration:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => RegisterationScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.firestore_builder:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => FirestoreBuilder(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
