import 'package:flutter/foundation.dart';
import 'package:quizu/exports/models.dart' show User;

class UserProvider extends ChangeNotifier {
  User? _user;

  void userLogedIn(User user) {
    _user = user;
  }

  User get user => _user!;
}
