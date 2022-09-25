import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizu/exports/utils.dart' show AppReg;

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool submitted;
  const PhoneTextField({
    required this.controller,
    required this.submitted,
  });

  //methods
  //check phone format
  bool _phoneReg() {
    String phone = '+966' + controller.text.trim();
    return AppReg.phoneNumber.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.subtitle1!.copyWith(height: 1.2),
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(AppReg.numbers),
      ],
      autofillHints: [
        AutofillHints.telephoneNumber,
      ],
      
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.done,
      maxLength: 9,
      autovalidateMode: submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        hintText: "5XXXXXXXX",
        hintStyle: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(height: 1.2, color: Colors.grey),
        hintTextDirection: TextDirection.ltr,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 8,
          ),
          child: Text(
            '🇸🇦',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
      validator: (String? text) {
        if (text == null || text.isEmpty) {
          return "Required field";
        } else if (controller.text.length < 9) {
          return "Must be 9 digits";
        } else if (!AppReg.numbers.hasMatch(controller.text)) {
          return "Only numbers 0...9";
        } else if (!_phoneReg()) {
          return "Phone number is not valid";
        }
        return null;
      },
      onChanged: (value) {
        if (value.length == 9) {
          FocusScope.of(context).unfocus();
        }
      },
    );
  }
}
