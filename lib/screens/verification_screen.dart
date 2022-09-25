import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/components.dart'
    show CustomElevatedButton, CustomSnackbar, LoadingIndicator, Logo, OTPField;
import 'package:quizu/exports/models.dart' show User;
import 'package:quizu/exports/providers.dart' show UserProvider;
import 'package:quizu/exports/services.dart';
import 'package:quizu/routes/routes.dart';

import '../cache/shared_preference_helper.dart';

class VerificationScreen extends StatefulWidget {
  final String mobile;
  VerificationScreen({required this.mobile});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // controllers
  TextEditingController fieldOneController = TextEditingController();
  TextEditingController fieldTwoController = TextEditingController();
  TextEditingController fieldThreeController = TextEditingController();
  TextEditingController fieldFourController = TextEditingController();

  // values
  static const maxSeconds = 60;
  int _seconds = maxSeconds;
  bool _stopped = false;
  Timer? timer;
  bool _isLoading = false;
  String _otp = '';

  // methods
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  //validating data of the otp fields
  bool _onSubmit() {
    if (_checkControllers()) {
      FocusScope.of(context).unfocus();
      return true;
    }
    return false;
  }

  //check the content of the controllers to validate them
  bool _checkControllers() {
    if ((fieldOneController.text.isEmpty || fieldOneController.text == '') ||
        (fieldTwoController.text.isEmpty || fieldTwoController.text == '') ||
        (fieldThreeController.text.isEmpty ||
            fieldThreeController.text == '') ||
        (fieldFourController.text.isEmpty || fieldFourController.text == '')) {
      return false;
    }
    return true;
  }

  //will start during building the ui
  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        stopTimer();
      }
    });
  }

  // to stop the time when the the timer stops or moved to another screen
  void stopTimer() {
    timer?.cancel();
    setState(() {
      _stopped = true;
    });
  }

  //loading the screen whem checking the otp or when first time the screen is loaded
  void isLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  //if the otp is invalid it will be deleted and will ask user to enter otp again
  void _clearContentOfControllers() {
    fieldOneController.clear();
    fieldTwoController.clear();
    fieldThreeController.clear();
    fieldFourController.clear();
  }

  void _gatherOTP() {
    _otp = fieldOneController.text.trim() +
        fieldTwoController.text.trim() +
        fieldThreeController.text.trim() +
        fieldFourController.text.trim();
  }

  Future<void> _verify() async {
    if (!_isLoading) {
      stopTimer();
      _gatherOTP();
      if (_onSubmit()) {
        isLoading(true);
        try {
          final network = Provider.of<NetworkService>(context, listen: false);
          Map<String, dynamic> data = await network.login(widget.mobile, _otp);

          //if the key 'user_status' not found it will return null, it means the user is already exists
          //else then the user is new
          String userStatus = data["user_status"] ?? "already exists";

          if (userStatus == "new") {
            //new user is created
            //store token in the shared_preferences
            await SharedPreferencesHelper.instace.setToken(data["token"]);
            //navigate to user registeration to get user name
            Navigator.of(context).pushReplacementNamed(
              Routes.registeration,
              arguments: widget.mobile,
            );
          } else {
            //user signed in
            if (data["name"] == null) {
              //means the user logged in but not completed his information
              //store token in the shared_preferences
              await SharedPreferencesHelper.instace.setToken(data["token"]);
              //navigate to user registeration to get user name
              Navigator.of(context).pushReplacementNamed(
                Routes.registeration,
                arguments: widget.mobile,
              );
            } else {
              //his information is completed
              User user = User.fromJson(data);
              Provider.of<UserProvider>(context, listen: false)
                  .userLogedIn(user);
              //save token in shared prefs
              await SharedPreferencesHelper.instace.setToken(data["token"]);
              Navigator.of(context).pushReplacementNamed(Routes.data_builder);
            }
          }
        } catch (e) {
          isLoading(false);
          CustomSnackbar.showSnackBar(context, e.toString());
        }
      } else {
        CustomSnackbar.showSnackBar(context, "Fields must not be empty");
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    fieldOneController.dispose();
    fieldTwoController.dispose();
    fieldThreeController.dispose();
    fieldFourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          splashColor: Colors.grey[400],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Logo(),
                        SizedBox(height: 50),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Please enter the OTP code sent to your mobile ${widget.mobile}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(fontSize: 18),
                                softWrap: false,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            OTPField(
                              controller: fieldOneController,
                              autofocus: true,
                              onChanged: (String value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                            Spacer(),
                            OTPField(
                              controller: fieldTwoController,
                              autofocus: false,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                            Spacer(),
                            OTPField(
                              controller: fieldThreeController,
                              autofocus: false,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                            Spacer(),
                            OTPField(
                              controller: fieldFourController,
                              autofocus: false,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            if (!_isLoading) {
                              if (_stopped) {
                                setState(() {
                                  _seconds = maxSeconds;
                                  _stopped = false;
                                });
                                FocusScope.of(context).unfocus();
                                _clearContentOfControllers();
                                _startTimer();
                              }
                            }
                          },
                          child: Text(
                            _stopped
                                ? "Resend Again"
                                : '00:${_seconds == 0 ? '00' : _seconds < 10 ? '0${_seconds}' : _seconds}',
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                ?.copyWith(
                                  color: _stopped ? Colors.black : Colors.grey,
                                ),
                          ),
                        ),
                        SizedBox(height: 25),
                        CustomElevatedButton(
                          text: 'Check',
                          onPressed: () async {
                            await _verify();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            LoadingIndicator(isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}
