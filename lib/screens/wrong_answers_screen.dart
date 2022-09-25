import 'package:flutter/material.dart';
import 'package:quizu/routes/routes.dart';

class WrongAnswersScreen extends StatelessWidget {
  const WrongAnswersScreen({super.key});

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "😢",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 50),
              Text(
                "Wrong Answer",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(Routes.question_presenter);
                },
                child: Text(
                  "Try Again",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
