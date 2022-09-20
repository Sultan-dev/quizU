import 'package:flutter/material.dart';
import 'package:quizu/exports/screens.dart';

class Routes {
  Routes._PrivateConstructor();

  //screens
  static const String login = 'login_screen';
  static const String verification = 'verification_screen';
  static const String home = 'home_screen';
  static const String profile = 'profile_screen';
  static const String ranking = 'ranking_screen';
  static const String result = 'result_screen';

  static final routes = <String, WidgetBuilder>{
    login: (context) => LoginScreen(),
    verification: (context) => VerificationScreen(),
    home: (context) => HomeScreen(),
    profile: (context) => ProfileScreen(),
    ranking: (context) => RankingScreen(),
    result: (context) => ResultScreen(),
  };
}
