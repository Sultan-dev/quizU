import 'package:shared_preferences/shared_preferences.dart';

const String _token = 'token';
const String _score = 'score';

class SharedPreferencesHelper {
  SharedPreferencesHelper._PrivateConstructor();
  static final SharedPreferencesHelper instace =
      SharedPreferencesHelper._PrivateConstructor();

  //storing the token
  Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, value);
  }

  //retrieving the token
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token) ?? '';
  }

  //retrieving the token
  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_token);
  }

  //storing scores data
  Future<void> storeScore(String score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_score, score);
  }

  //retrieving the scores
  Future<String> getScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_score) ?? '';
  }

  //clear cache data
  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
