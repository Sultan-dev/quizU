import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/providers.dart'
    show QuestionProvider, UserProvider;
import 'package:quizu/exports/services.dart' show NetworkService;
import 'package:quizu/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderSetup());
}

class ProviderSetup extends StatelessWidget {
  const ProviderSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NetworkService()),
        ChangeNotifierProvider(create: (context) => QuestionProvider()),
      ],
      child: MyApp(),
    );
  }
}
