import 'package:flutter/material.dart';
import 'package:nixon_connect/Views/Screens/Login/login_screen.dart';

import 'components/logo_component.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    //SignInButton Animation Delay
    () async {
      Future.delayed(
          const Duration(milliseconds: 1900),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const LoginScreen())));
    }.call();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: LogoBuild(
          size: size.width,
        ),
      ),
    );
  }
}
