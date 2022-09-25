import 'package:flutter/foundation.dart';
import 'package:quizu/exports/models.dart' show User, UserScore;
import 'dart:math';

class UserProvider extends ChangeNotifier {
  User? _user;
  List<UserScore> _scores = [];

  void userLogedIn(User user) {
    _user = user;
  }

  void storeScores(List<UserScore> scores) {
    _scores = scores;
  }

  void addScore(UserScore score) {
    _scores.add(score);
  }

  int getMaxScore() {
    List<int> scores =
        List.generate(_scores.length, (index) => _scores[index].score);
    return scores.reduce(max);
  }

  User get user => _user!;
  List<UserScore> get scores => _scores;
}
