import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._PrivateConstructor();

  static final AuthService instance = AuthService._PrivateConstructor();

  //firebase auth
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  //values
  String? _uid;
  String? _verificationID;
  int? _resendToken;
  String? _phoneNumber; // to be in this format: +9665XXXXXXXX

  //getters
  String get uid => _uid!;
  String get phoneNumber => _phoneNumber!;

  User? get current_user => _auth.currentUser;

  //get stream data about the user activities (sign-ins)
  Stream<User?> get user => _auth.authStateChanges();

  //setters
  void setUID(String? uid) {
    _uid = uid;
  }

  void setPhoneNumber(String? phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  Future<void> verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          throw e;
        },
        codeSent: (String verificationID, resendingToken) async {
          debugPrint('verif $verificationID');
          _verificationID = verificationID;
          _resendToken = resendingToken;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationID = verificationID;
        },
        timeout: Duration(seconds: 60),
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signInWithCredential(String smsCode) async {
    try {
      debugPrint('verif $_verificationID');
      UserCredential userCred = await _auth.signInWithCredential(
        await PhoneAuthProvider.credential(
          verificationId: _verificationID.toString(),
          smsCode: smsCode.trim(),
        ),
      );

      if (userCred.user != null) {
        _user = userCred.user;
        _uid = _user!.uid;
        debugPrint('success user signed with phone number');
        return true;
      }
      //user signed out
      throw 'user signed out';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw "invalid OTP";
      }
      throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _uid = null;
  }
}
