import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizu/exports/components.dart' show SplashScreen;
import 'package:quizu/exports/screens.dart' show LoginScreen, HomeScreen;
import 'package:quizu/exports/services.dart' show AuthService;
import 'package:quizu/exports/utils.dart' show AuthBuilder;
import 'package:quizu/routes/routes_generator.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesGenerator.generateRoute,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffffffff),
      ),
      home: AuthBuilder(
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user != null) {
              AuthService.instance.setUID(user.uid);
              debugPrint(AuthService.instance.uid);
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          }
          if (snapshot.hasError) {
            return SplashScreen(
              content: 'errors.went_wrong',
              loadingIndicator: false,
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}
