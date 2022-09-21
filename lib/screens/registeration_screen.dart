import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/components.dart'
    show CustomElevatedButton, LoadingIndicator, Logo, NameTextField;
import 'package:quizu/exports/models.dart' show User;
import 'package:quizu/exports/providers.dart';
import 'package:quizu/exports/services.dart';
import 'package:quizu/routes/routes.dart';

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({super.key});

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  //firestore
  final firestore = FirestoreService();
  // keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  // controllers
  TextEditingController nameController = TextEditingController();

  // values
  bool _isChecked = false;
  bool _submitted = false;
  bool _isLoading = false;

  //methods
  // after clicking on done
  bool _onSubmit() {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  Future<void> _saveAndNavigate() async {
    if (!_isLoading) {
      if (_onSubmit()) {
        isLoading(true);
        User user = User(
            name: nameController.text.trim(),
            phoneNumber: AuthService.instance.phoneNumber,
            scores: []);
        await firestore.createUser(user.toJson(), AuthService.instance.uid);
        Provider.of<UserProvider>(context, listen: false).userLogedIn(user);
        isLoading(false);
        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Logo(),
                  SizedBox(height: 50),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'What\'s your name?',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: NameTextField(
                      controller: nameController,
                      submitted: _submitted,
                    ),
                  ),
                  SizedBox(height: 50),
                  CustomElevatedButton(
                    text: 'Done',
                    onPressed: () async {
                      await _saveAndNavigate();
                    },
                  ),
                ],
              ),
            ),
            LoadingIndicator(isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}
