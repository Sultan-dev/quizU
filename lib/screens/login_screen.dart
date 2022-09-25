import 'package:flutter/material.dart';
import 'package:quizu/exports/components.dart'
    show CustomElevatedButton, LoadingIndicator, Logo, PhoneTextField;
import 'package:quizu/routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  // controllers
  TextEditingController phoneController = TextEditingController();

  // values
  bool _submitted = false;
  bool _isLoading = false;

  // methods
  void initState() {
    super.initState();

    //controller listener for detecting if user type 0 at the beginning of the phone number
    //user needs to enter the phone number in this format: 551236754
    phoneController.addListener(
      () {
        if (phoneController.text.isNotEmpty &&
            phoneController.text[0].contains('0') &&
            phoneController.text.length >= 2) {
          phoneController.text =
              phoneController.text.replaceFirst(RegExp(r'^0+'), '');
          phoneController.selection = TextSelection.fromPosition(
              TextPosition(offset: phoneController.text.length));
        }
      },
    );
  }

  bool _onSubmit() {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      return true;
    }
    return false;
  }

  void isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _loginAndNavigate() {
    if (!_isLoading) {
      if (_onSubmit()) {
        isLoading(true);
        String mobile = '0${phoneController.text.trim()}';
        isLoading(false);
        Navigator.of(context).pushNamed(Routes.verification, arguments: mobile);
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mobile Number',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: PhoneTextField(
                      controller: phoneController,
                      submitted: _submitted,
                    ),
                  ),
                  SizedBox(height: 50),
                  CustomElevatedButton(
                    text: 'Start',
                    onPressed: () {
                      _loginAndNavigate();
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
