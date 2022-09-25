import 'package:flutter/material.dart';
import 'package:quizu/routes/routes.dart';
import 'package:share_plus/share_plus.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).pushReplacementNamed(Routes.home);
              },
              icon: Icon(
                Icons.close_outlined,
                color: Colors.black,
                size: 28,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "🏁",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              Text(
                "You have completed",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 15),
              Text(
                "${score}",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 15),
              Text(
                "correct answers!",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () async {
                  await Share.share(
                      "I answered ${score} correct answers in QuizU!");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Share",
                      style: Theme.of(context).textTheme.button!.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
