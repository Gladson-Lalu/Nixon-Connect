import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Common/constant.dart';
import '../../../Cubit/auth/auth_cubit.dart';
import '../Login/login_screen.dart';

import '../../components/already_have_an_account_check.dart';
import '../../components/rounded_button.dart';
import '../../components/rounded_input_field.dart';
import '../../components/rounded_password_field.dart';
import '../../components/background.dart';
import '../ChatHome/home_screen.dart';
import 'components/divider.dart';
import 'components/social_icon.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name = '';
  String email = '';
  String password = '';
  String userID = '';
  String confirmPassword = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Name",
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            RoundedInputField(
              hintText: "UserID",
              onChanged: (value) {
                setState(() {
                  userID = value;
                });
              },
            ),
            RoundedInputField(
              textInputType: TextInputType.emailAddress,
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
            RoundedInputField(
              hintText: "Confirm Password",
              onChanged: (value) {
                setState(() {
                  confirmPassword = value;
                });
              },
            ),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            const HomeScreen())),
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
                      text: "SIGNUP",
                      isLoading: false,
                      press: () {
                        //register user
                        BlocProvider.of<AuthCubit>(context)
                            .handleRegister(
                          name: name,
                          email: email,
                          password: password,
                          userID: userID,
                          confirmPassword: confirmPassword,
                        );
                      });
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
            const OrVerticalDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocialIcon(
                  iconSrc: facebookUri,
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: twitterUri,
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: googleUri,
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
