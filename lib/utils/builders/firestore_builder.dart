import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/components.dart' show SplashScreen;
import 'package:quizu/exports/models.dart';
import 'package:quizu/exports/providers.dart' show UserProvider;
import 'package:quizu/exports/services.dart' show AuthService, FirestoreService;
import '../../exports/screens.dart' show HomeScreen, LoginScreen;

class FirestoreBuilder extends StatefulWidget {
  @override
  State<FirestoreBuilder> createState() => _FirestoreBuilderState();
}

class _FirestoreBuilderState extends State<FirestoreBuilder> {
  //firestore
  final firestore = FirestoreService();
  //futures
  late final Future<User?> _fetchData;

  //methods
  @override
  void initState() {
    super.initState();
    _fetchData = _getUser();
  }

  Future<User?> _getUser() async {
    return await firestore.getUser(AuthService.instance.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _fetchData,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          try {
            User? user = snapshot.data;
            if (user != null) {
              Provider.of<UserProvider>(context, listen: false)
                  .userLogedIn(user);
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
