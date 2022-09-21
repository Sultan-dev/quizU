import 'package:flutter/material.dart';
import 'package:quizu/exports/components.dart' show Logo;

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
                Logo(),
                SizedBox(height: 50),
                loadingIndicator ? CircularProgressIndicator() : Container(),
                SizedBox(height: 10),
                Text(
                  content,
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
