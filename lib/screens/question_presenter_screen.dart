import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/cache/shared_preference_helper.dart';
import 'package:quizu/exports/components.dart' show CustomSnackbar;
import 'package:quizu/exports/models.dart' show UserScore;
import 'package:quizu/exports/services.dart';
import 'package:quizu/providers/question_provider.dart';
import 'package:quizu/providers/user_provider.dart';
import 'package:quizu/routes/routes.dart';

class QuestionPresenterScreen extends StatefulWidget {
  const QuestionPresenterScreen({super.key});

  @override
  State<QuestionPresenterScreen> createState() =>
      _QuestionPresenterScreenState();
}

class _QuestionPresenterScreenState extends State<QuestionPresenterScreen> {
  //controller
  PageController controller = PageController();
  //values
  Timer? timer;
  static const maxSeconds = 59;
  static const maxMinutes = 1;
  int _seconds = maxSeconds;
  int _minutes = maxMinutes;
  int _correctAnswers = 0;
  bool _skipClicked = false;

  //methods
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  //will start during building the ui
  void _startTimer() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (_seconds > 0) {
          setState(() => _seconds--);
        } else if (_minutes == 1) {
          //1 minute finished and left 1 minute
          setState(() {
            _minutes--;
            _seconds = maxSeconds;
          });
        } else {
          //2 minute finished we need to navigate to result screen
          _storeScoreAndNavigate();
          Navigator.of(context)
              .pushReplacementNamed(Routes.result, arguments: _correctAnswers);
        }
      },
    );
  }

  Future<void> _storeScoreAndNavigate() async {
    try {
      //store user score in user provider
      //create UserScore object
      UserScore score = UserScore(date: DateTime.now(), score: _correctAnswers);

      //store it in the user provider
      final user = Provider.of<UserProvider>(context, listen: false);
      user.addScore(score);

      //get the highest score in the user score list;
      int max = user.getMaxScore();

      //store this result in the API
      final network = Provider.of<NetworkService>(context, listen: false);
      await network.postScore(max);

      //store the user scores in cache preferences
      //encode the list to be able to store in the cache
      String jsonData = UserScore.encode(user.scores);

      await SharedPreferencesHelper.instace.storeScore(jsonData);
    } catch (e) {
      CustomSnackbar.showSnackBar(context, e.toString());
    }
  }

  Widget _buildButton(int index, int numQuestions) {
    return ElevatedButton(
      onPressed: () {
        if (index != numQuestions) {
          //user is allowed with one skip, so we need to hide it whe is clicked and move to next page
          setState(() {
            _skipClicked = true;
          });
          controller.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        } else {
          Navigator.of(context)
              .pushReplacementNamed(Routes.result, arguments: _correctAnswers);
        }
      },
      child: Text(
        index != numQuestions ? "Skip 🔥" : "Finish",
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        fixedSize: Size(120, 50),
        elevation: 0,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions =
        Provider.of<QuestionProvider>(context, listen: false).questions;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: questions.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '0${_minutes}:${_seconds == 0 ? '00' : _seconds < 10 ? '0${_seconds}' : _seconds} ⏳',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 50),
              Text(
                "${questions[i].question}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6!,
              ),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: questions[i].answers.map((e) {
                    return TextButton(
                      onPressed: () {
                        if (e == questions[i].correct) {
                          //increments the correct answers and move to next page
                          _correctAnswers++;
                          controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.wrong_answers);
                        }
                      },
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 25),
              if (!_skipClicked) _buildButton(i, questions.length - 1),
            ],
          );
        },
      ),
    );
  }
}
