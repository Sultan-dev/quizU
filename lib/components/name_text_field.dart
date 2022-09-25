import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted;
  const NameTextField({
    required this.controller,
    required this.submitted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 95,
        child: TextFormField(
          style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.2),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          controller: controller,
          textInputAction: TextInputAction.next,
          autovalidateMode: submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            hintTextDirection: TextDirection.rtl,
            errorMaxLines: 3,
            errorStyle: TextStyle(fontSize: 10, color: Colors.red),
            counterText: '',
          ),
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return "Required field";
            }
            return null;
          },
        ),
      ),
    );
  }
}
