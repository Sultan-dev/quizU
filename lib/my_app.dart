import 'package:flutter/material.dart';
import 'package:quizu/exports/components.dart' show SplashScreen;
import 'package:quizu/exports/screens.dart' show LoginScreen;
import 'package:quizu/exports/utils.dart' show AuthBuilder, DataBuilder;
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
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool? result = snapshot.data;
            if (result != null) {
              if (result) {
                //token is verified
                return DataBuilder();
              }
              //not registered
              return LoginScreen();
            }
          }
          if (snapshot.hasError) {
            return SplashScreen(
              content: 'Something Went Wrong!',
              loadingIndicator: false,
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}
