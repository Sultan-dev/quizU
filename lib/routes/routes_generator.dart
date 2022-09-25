import 'package:flutter/material.dart';
import 'package:quizu/exports/screens.dart';
import 'package:quizu/exports/utils.dart' show DataBuilder;
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
        final score = settings.arguments as int; //mobile

        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => ResultScreen(score: score),
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
        final mobile = settings.arguments as String; //mobile
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => VerificationScreen(mobile: mobile),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.registeration:
        final mobile = settings.arguments as String; //mobile

        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => RegisterationScreen(mobile: mobile),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.data_builder:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => DataBuilder(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.question_presenter:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => QuestionPresenterScreen(),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c));
      case Routes.wrong_answers:
        return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => WrongAnswersScreen(),
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
