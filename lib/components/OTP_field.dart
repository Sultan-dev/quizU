import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizu/exports/utils.dart' show AppReg;

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final Function(String) onChanged;
  const OTPField({
    required this.controller,
    required this.autofocus,
    required this.onChanged,
  });

  //textfield decoration
  static const InputDecoration OTPDecoration = InputDecoration(
    counterText: '',
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 50,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.2),
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.allow(AppReg.numbers),
          ],
          textAlign: TextAlign.center,
          maxLength: 1,
          autofocus: autofocus,
          keyboardType: TextInputType.phone,
          decoration: OTPDecoration,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
