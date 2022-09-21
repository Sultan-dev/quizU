import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/components.dart'
    show CustomElevatedButton, CustomSnackbar, LoadingIndicator, Logo, OTPField;
import 'package:quizu/exports/models.dart' show User;
import 'package:quizu/exports/providers.dart' show UserProvider;
import 'package:quizu/exports/services.dart';
import 'package:quizu/routes/routes.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  //database
  final firestore = FirestoreService();

  // controllers
  TextEditingController fieldOneController = TextEditingController();
  TextEditingController fieldTwoController = TextEditingController();
  TextEditingController fieldThreeController = TextEditingController();
  TextEditingController fieldFourController = TextEditingController();
  TextEditingController fieldFiveController = TextEditingController();
  TextEditingController fieldSixController = TextEditingController();

  // values
  static const maxSeconds = 60;
  int _seconds = maxSeconds;
  bool _stopped = false;
  Timer? timer;
  bool _isLoading = false;
  String _OTP = '';

  // methods
  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
    _startTimer();
  }

  //calling auth provide to verify the phone number
  Future<void> _verifyPhoneNumber() async {
    try {
      await AuthService.instance.verifyPhoneNumber();
    } catch (e) {
      CustomSnackbar.showSnackBar(context, e.toString());
    }
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
        (fieldFourController.text.isEmpty || fieldFourController.text == '') ||
        (fieldFiveController.text.isEmpty || fieldFiveController.text == '') ||
        (fieldSixController.text.isEmpty || fieldSixController.text == '')) {
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
    fieldFiveController.clear();
    fieldSixController.clear();
  }

  void _gatherOTP() {
    _OTP = fieldOneController.text.trim() +
        fieldTwoController.text.trim() +
        fieldThreeController.text.trim() +
        fieldFourController.text.trim() +
        fieldFiveController.text.trim() +
        fieldSixController.text.trim();
  }

  Future<void> _verify() async {
    if (!_isLoading) {
      stopTimer();
      _gatherOTP();
      if (_onSubmit()) {
        isLoading(true);
        try {
          bool result = await AuthService.instance.signInWithCredential(_OTP);
          if (result) {
            //successful sing in
            bool isExists =
                await firestore.checkUserExistance(AuthService.instance.uid);
            if (isExists) {
              await _getUserDataAndNavigate();
            } else {
              isLoading(false);
              Navigator.of(context).pushReplacementNamed(Routes.registeration);
            }
          }
        } catch (e) {
          isLoading(false);
          CustomSnackbar.showSnackBar(context, e.toString());
        }
      }
    }
  }

  Future<void> _getUserDataAndNavigate() async {
    try {
      User? user = await firestore.getUser(AuthService.instance.uid);
      isLoading(false);
      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).userLogedIn(user);
        Navigator.of(context).pushReplacementNamed(Routes.home);
      } else {
        //no doc created with this crossponding user
        Navigator.of(context).pushReplacementNamed(Routes.registeration);
      }
    } catch (e) {
      CustomSnackbar.showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    fieldOneController.dispose();
    fieldTwoController.dispose();
    fieldThreeController.dispose();
    fieldFourController.dispose();
    fieldFiveController.dispose();
    fieldSixController.dispose();
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
                                'Please enter the OTP code sent to your mobile',
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
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                            Spacer(),
                            OTPField(
                              controller: fieldFiveController,
                              autofocus: false,
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                            Spacer(),
                            OTPField(
                              controller: fieldSixController,
                              autofocus: false,
                              onChanged: (value) async {
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
                                _verifyPhoneNumber();
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
