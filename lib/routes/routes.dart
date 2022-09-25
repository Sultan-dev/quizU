import 'package:flutter/material.dart';
import 'package:quizu/exports/screens.dart';
import 'package:quizu/exports/utils.dart' show DataBuilder;

class Routes {
  Routes._PrivateConstructor();

  //screens
  static const String login = 'login_screen';
  static const String verification = 'verification_screen';
  static const String home = 'home_screen';
  static const String profile = 'profile_screen';
  static const String ranking = 'ranking_screen';
  static const String result = 'result_screen';
  static const String registeration = 'registeration_screen';
  static const String question_presenter = 'question_presenter_screen';
  static const String wrong_answers = 'wrong_answers_screen';

  //builders
  static const String data_builder = 'data_builder';

  static final routes = <String, WidgetBuilder>{
    login: (context) => LoginScreen(),
    //verification: (context) => VerificationScreen(),
    home: (context) => HomeScreen(),
    profile: (context) => ProfileScreen(),
    ranking: (context) => RankingScreen(),
    //result: (context) => ResultScreen(),
    //registeration: (context) => RegisterationScreen(),
    data_builder: (context) => DataBuilder(),
    wrong_answers: (context) => WrongAnswersScreen()
  };
}
