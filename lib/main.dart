import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/providers.dart' show UserProvider;
import 'package:quizu/my_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ProviderSetup());
}

class ProviderSetup extends StatelessWidget {
  const ProviderSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    );
  }
}
