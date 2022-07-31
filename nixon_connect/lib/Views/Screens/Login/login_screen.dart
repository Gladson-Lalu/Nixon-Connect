import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nixon_connect/Common/constant.dart';
import 'package:nixon_connect/Views/Screens/ChatHome/home_screen.dart';
import 'package:nixon_connect/cubit/auth_cubit.dart';

import '../../components/already_have_an_account_check.dart';
import '../../components/background.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../Signup/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isForgot = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Nixon Connect",
                  style: GoogleFonts.lobster(
                    textStyle: const TextStyle(
                        fontSize: 28, letterSpacing: 4),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                isForgot
                    ? Text(
                        "FORGOT PASSWORD",
                        style: textStyle.copyWith(
                            color: Colors.black),
                      )
                    : Text(
                        "LOGIN",
                        style: textStyle.copyWith(
                            color: Colors.black),
                      ),
                buildLoginForgotForm(size, context),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isForgot = !isForgot;
                    });
                  },
                  child: isForgot
                      ? Text(
                          "Login Now!",
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "Forgot Password",
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                ),
                SizedBox(height: size.height * 0.02),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildLoginForgotForm(Size size, BuildContext ctx) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
      firstChild: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                //navigate to home screen
                if (state is AuthLoaded) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            const HomePage())),
                    ModalRoute.withName('/'),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return RoundedButton(
                      isLoading: true,
                      text: '',
                      press: () {});
                } else {
                  return RoundedButton(
                      isLoading: false,
                      text: "LOGIN",
                      press: () => {
                            BlocProvider.of<AuthCubit>(ctx)
                                .handleSignIn(
                              email: email,
                              password: password,
                            ),
                          });
                }
              },
            ),
          ]),
      secondChild: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            RoundedButton(
              isLoading: false,
              text: "CONTINUE",
              press: () {},
            ),
          ]),
      crossFadeState: isForgot
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}
