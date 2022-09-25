import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/cache/shared_preference_helper.dart';
import 'package:quizu/exports/components.dart' show SplashScreen;
import 'package:quizu/exports/models.dart';
import 'package:quizu/exports/providers.dart'
    show QuestionProvider, UserProvider;
import 'package:quizu/exports/services.dart' show NetworkService;
import '../../exports/screens.dart' show HomeScreen, LoginScreen;

class DataBuilder extends StatefulWidget {
  @override
  State<DataBuilder> createState() => _DataBuilderState();
}

class _DataBuilderState extends State<DataBuilder> {
  //futures
  late final Future<User?> _fetchData;
  late final Future<String> _fetchCachedScore;
  late final Future<List<Question>> _fetchQuestions;

  //methods
  @override
  void initState() {
    super.initState();
    _fetchData = _getUser();
    _fetchCachedScore = _getCachedScore();
    _fetchQuestions = _getQuestions();
  }

  Future<User?> _getUser() async {
    final network = Provider.of<NetworkService>(context, listen: false);
    User? user = await network.getUserInfo();
    return user;
  }

  //this method is resposible to retrieve the scores from shared_preference which is 'String' object
  //where this return value will be json data, so we need to decode it to get the actual data
  Future<String> _getCachedScore() async {
    return await SharedPreferencesHelper.instace.getScore();
  }

  Future<List<Question>> _getQuestions() async {
    final network = Provider.of<NetworkService>(context, listen: false);
    return await network.getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([_fetchData, _fetchCachedScore, _fetchQuestions]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            User? user = snapshot.data![0];
            String? jsonDataScore = snapshot.data![1];
            List<Question> questions = snapshot.data![2];

            if (user != null) {
              //store the user object in user provider
              Provider.of<UserProvider>(context, listen: false)
                  .userLogedIn(user);

              //decode the json data score from the shared preferences
              List<UserScore> userScores = UserScore.decode(jsonDataScore!);
              //store it in user provider
              Provider.of<UserProvider>(context, listen: false)
                  .storeScores(userScores);

              //store questions in questions provider
              Provider.of<QuestionProvider>(context, listen: false)
                  .createList(questions);

              return HomeScreen();
            }
            return LoginScreen();
          } catch (e) {
            return LoginScreen();
          }
        } else if (snapshot.hasError) {
          return SplashScreen(
            content: 'Something Went Wrong!',
            loadingIndicator: false,
          );
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
