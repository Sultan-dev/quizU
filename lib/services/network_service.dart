import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quizu/cache/shared_preference_helper.dart';
import 'package:quizu/exports/models.dart' show PlayerScore, Question, User;

//URLs for okoul API
const _login = "https://quizu.okoul.com/Login";
const _token = "https://quizu.okoul.com/Token";
const _createNewUser = "https://quizu.okoul.com/Name";
const _topScores = "https://quizu.okoul.com/TopScores";
const _getUserInfo = "https://quizu.okoul.com/UserInfo";
const _questions = "https://quizu.okoul.com/Questions";
const _postScore = "https://quizu.okoul.com/Score";

//this model for API calls
class NetworkService extends ChangeNotifier {
  //This method is used to verify the token of the user
  Future<bool> verifyToken() async {
    try {
      final uri = Uri.parse(_token);
      String token = await SharedPreferencesHelper.instace.getToken();
      //check if the token is empty or not from shared_preferences
      //if the token is empty meaning new user
      if (token != '') {
        final response = await http.get(
          uri,
          headers: {"Content-Type": "application/json", "Authorization": token},
        );

        debugPrint("verify token status code ${response.statusCode}");
        if (response.statusCode == 200) {
          //success: user exists
          return true;
        }
      }
      return false;
    } catch (e) {
      throw e;
    }
  }

  //used for login auth and the result will be a new user is created or returning the data of the user
  Future<Map<String, dynamic>> login(String phoneNumber, String otp) async {
    try {
      final uri = Uri.parse(_login);

      Map<String, dynamic> data = {"OTP": otp, "mobile": phoneNumber};

      //convert the data to json
      String body = jsonEncode(data);

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      debugPrint("login status code ${response.statusCode}");
      if (response.statusCode == 201) {
        debugPrint('success');
        //decode the json data to a map
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint('fail');
        throw "Invalid OTP";
      }
    } catch (e) {
      throw e;
    }
  }

  //this method is used to retrieve user data
  Future<User?> getUserInfo() async {
    try {
      final uri = Uri.parse(_getUserInfo);
      User? user;

      String token = await SharedPreferencesHelper.instace.getToken();

      if (token != '') {
        final response = await http.get(
          uri,
          headers: {"Content-Type": "application/json", "Authorization": token},
        );
        debugPrint("get user info status code ${response.statusCode}");
        if (response.statusCode == 200) {
          //success: user exists
          //decode the json data to a map
          Map<String, dynamic> dataJson = jsonDecode(response.body);

          //map created to add the token since the returned json data does not include token
          if (dataJson["name"] != null) {
            Map<String, dynamic> data = {
              "mobile": dataJson["mobile"],
              "name": dataJson["name"],
              "token": token
            };
            user = User.fromJson(data);
            return user;
          }
          //meaning user has not completed registering his name
          return user = null;
        }
      }
      user = null;
      return user;
    } catch (e) {
      throw e;
    }
  }

  //this method is resposible to store user name if he/she is a new user
  Future<void> storeUserName(String name) async {
    try {
      final uri = Uri.parse(_createNewUser);
      String token = await SharedPreferencesHelper.instace.getToken();
      if (token != '') {
        Map<String, dynamic> data = {"name": name};

        //convert the data to json
        String body = jsonEncode(data);
        final response = await http.post(
          uri,
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: body,
        );

        debugPrint("store user name status code ${response.statusCode}");
        if (response.statusCode == 201) {
          debugPrint("stored successfully");
          return;
        } else {
          throw "Unknown Error!";
        }
      }
      //user not signed in or token is deleted
      throw 'Token is invalid';
    } catch (e) {
      throw e;
    }
  }

  //this method is resposible to get the questions from the API
  Future<List<Question>> getQuestions() async {
    try {
      final uri = Uri.parse(_questions);

      String token = await SharedPreferencesHelper.instace.getToken();

      if (token != '') {
        final response = await http.get(
          uri,
          headers: {"Content-Type": "application/json", "Authorization": token},
        );

        debugPrint("get questions status code ${response.statusCode}");
        if (response.statusCode == 200) {
          //success
          //the result is a list of questions
          List<dynamic> data = jsonDecode(response.body);

          List<Question> questions = [];
          for (int i = 0; i < data.length; i++) {
            String correct = _getCorrectAnswerText(data[i]);
            Question question = Question(
              id: i,
              question: data[i]["Question"],
              correct: correct,
              answers: [data[i]["a"], data[i]["b"], data[i]["c"], data[i]["d"]],
            );
            questions.add(question);
          }
          return questions;
        }
      }
      //user not signed in or token is deleted
      throw 'Token is invalid';
    } catch (e) {
      throw e;
    }
  }

  //helper method to get the correct answer as full text
  String _getCorrectAnswerText(Map<String, dynamic> data) {
    if (data["correct"] == "a") {
      return data["a"];
    } else if (data["correct"] == "b") {
      return data["b"];
    } else if (data["correct"] == "c") {
      return data["c"];
    } else {
      return data["d"];
    }
  }

  //this method is resposible to get top 10 scores from the API
  Future<List<PlayerScore>> getTop10Scores() async {
    try {
      final uri = Uri.parse(_topScores);

      String token = await SharedPreferencesHelper.instace.getToken();

      if (token != '') {
        final response = await http.get(
          uri,
          headers: {"Content-Type": "application/json", "Authorization": token},
        );

        debugPrint("get top 10 scores status code ${response.statusCode}");
        if (response.statusCode == 200) {
          //success
          //the result is a list of players' scores
          List<dynamic> data = jsonDecode(response.body);

          List<PlayerScore> player_score = [];

          for (int i = 0; i < data.length; i++) {
            PlayerScore playerScore = PlayerScore.fromJson(data[i]);
            player_score.add(playerScore);
          }
          return player_score;
        }
      }
      //user not signed in or token is deleted
      throw 'Token is invalid';
    } catch (e) {
      throw e;
    }
  }

  //this method is resposible to store user score
  Future<void> postScore(int score) async {
    try {
      final uri = Uri.parse(_postScore);
      String token = await SharedPreferencesHelper.instace.getToken();
      if (token != '') {
        Map<String, dynamic> data = {"score": score.toString()};

        //convert the data to json
        String body = jsonEncode(data);
        final response = await http.post(
          uri,
          headers: {"Content-Type": "application/json", "Authorization": token},
          body: body,
        );

        debugPrint("post user score status code ${response.statusCode}");
        if (response.statusCode == 201) {
          debugPrint("stored successfully");
          return;
        } else {
          throw "Unknown Error!";
        }
      }

      //user not signed in or token is deleted
      throw 'Token is invalid';
    } catch (e) {
      throw e;
    }
  }
}
