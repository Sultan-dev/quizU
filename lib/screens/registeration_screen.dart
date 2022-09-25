import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/cache/shared_preference_helper.dart';
import 'package:quizu/exports/components.dart'
    show
        CustomElevatedButton,
        CustomSnackbar,
        LoadingIndicator,
        Logo,
        NameTextField;
import 'package:quizu/exports/models.dart' show User;
import 'package:quizu/exports/providers.dart';
import 'package:quizu/exports/services.dart';
import 'package:quizu/routes/routes.dart';

class RegisterationScreen extends StatefulWidget {
  final String mobile;
  const RegisterationScreen({
    required this.mobile,
  });

  @override
  State<RegisterationScreen> createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  // keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  // controllers
  TextEditingController nameController = TextEditingController();

  // values
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
        try {
          final network = Provider.of<NetworkService>(context, listen: false);

          //store user name
          await network.storeUserName(nameController.text.trim());

          //get user token
          String token = await SharedPreferencesHelper.instace.getToken();

          //create user object
          User user = User(
            name: nameController.text.trim(),
            mobile: widget.mobile,
            token: token,
          );

          Provider.of<UserProvider>(context, listen: false).userLogedIn(user);
          isLoading(false);

          //will need to get the questions and scores from cache prefs
          //so we need to go to the data builder
          Navigator.of(context).pushReplacementNamed(Routes.data_builder);
        } catch (e) {
          if (e.toString() == 'Token is invalid') {
            CustomSnackbar.showSnackBar(context, "Sign-in Error");
            Navigator.of(context).pushReplacementNamed(Routes.login);
          } else {
            CustomSnackbar.showSnackBar(context, e.toString());
          }
        }
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Logo(),
                    SizedBox(height: 50),
                    Text(
                      'What\'s your name?',
                      style: Theme.of(context).textTheme.headline6,
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
      ),
    );
  }
}
