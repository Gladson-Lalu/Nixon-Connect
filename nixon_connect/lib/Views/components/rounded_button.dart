import 'package:flutter/material.dart';

import '../../Common/constant.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.isLoading,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: newElevatedButton(),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Colors.white),
              ),
            )
          : Text(
              text,
              style: TextStyle(color: textColor),
            ),
      onPressed: press,
      style: ElevatedButton.styleFrom(
          primary: color,
          padding: const EdgeInsets.symmetric(
              horizontal: 40, vertical: 20),
          textStyle: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500)),
    );
  }
}
