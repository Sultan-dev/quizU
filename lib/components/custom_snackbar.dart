import 'package:flutter/material.dart';

class CustomSnackbar{
  CustomSnackbar._PrivateConstructor();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
  }
}