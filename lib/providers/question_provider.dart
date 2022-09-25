import 'package:flutter/foundation.dart';
import 'package:quizu/exports/models.dart' show Question;

class QuestionProvider extends ChangeNotifier {
  List<Question> _questions = [];

  void createList(List<Question> questions) {
    _questions = questions;
  }

  //getters
  List<Question> get questions => _questions;
}
