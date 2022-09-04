import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType textInputType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.textCapitalization = TextCapitalization.none,
    this.icon = Icons.person,
    this.textInputType = TextInputType.text,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        textCapitalization: textCapitalization,
        keyboardType: textInputType,
        onChanged: onChanged,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
