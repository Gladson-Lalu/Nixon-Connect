import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() =>
      _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState
    extends State<RoundedPasswordField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: obscureText,
        onChanged: widget.onChanged,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).primaryColor,
          ),
          suffixIcon: GestureDetector(
            child: Icon(
              Icons.visibility,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
