import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final String content;
  final bool loadingIndicator;
  const SplashScreen({this.content = 'loading', this.loadingIndicator = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                loadingIndicator ? CircularProgressIndicator() : Container(),
                SizedBox(height: 10),
                Text(
                  'Loading',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
