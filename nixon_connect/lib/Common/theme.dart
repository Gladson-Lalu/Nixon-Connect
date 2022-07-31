import 'package:flutter/material.dart';
import 'package:nixon_connect/Common/constant.dart';

ThemeData primaryTheme() {
  return ThemeData(
      primaryColor: kPrimaryColor,
      backgroundColor: kBackgroundColor,
      primarySwatch: Colors.blueGrey,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all<
            RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
      )));
}
