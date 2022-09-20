import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizu/exports/services.dart' show AuthService;

class AuthBuilder extends StatefulWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User?>) builder;
  AuthBuilder({required this.builder});

  @override
  State<AuthBuilder> createState() => _AuthBuilderState();
}

class _AuthBuilderState extends State<AuthBuilder> {
  //streams
  late final Stream<User?> _userStream;

  //methods
  @override
  void initState() {
    super.initState();
    _userStream = _getUserStream();
  }

  Stream<User?> _getUserStream() {
    return AuthService.instance.user;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userStream,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        return widget.builder(context, snapshot);
      },
    );
  }
}