import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizu/exports/services.dart' show NetworkService;

class AuthBuilder extends StatefulWidget {
  final Widget Function(BuildContext, AsyncSnapshot<bool>) builder;
  AuthBuilder({required this.builder});

  @override
  State<AuthBuilder> createState() => _AuthBuilderState();
}

class _AuthBuilderState extends State<AuthBuilder> {
  //streams
  late final Future<bool> _isValidToken;

  //methods
  @override
  void initState() {
    super.initState();
    _isValidToken = _checkIsValidToken();
  }

  Future<bool> _checkIsValidToken() async{
    final network = Provider.of<NetworkService>(context, listen: false);
    bool result = await network.verifyToken();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isValidToken,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return widget.builder(context, snapshot);
      },
    );
  }
}
