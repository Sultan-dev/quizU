import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final onPressed;
  final String text;
  const CustomElevatedButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.button!.copyWith(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[400],
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        elevation: 0,
      ),
    );
  }
}
