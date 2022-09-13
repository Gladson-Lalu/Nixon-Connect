import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Cubit/auth/auth_cubit.dart';
import '../ChatHome/home_screen.dart';
import '../Login/login_screen.dart';
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
          const Duration(milliseconds: 1800),
          () => BlocProvider.of<AuthCubit>(context)
              .getUser());
    }.call();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const HomeScreen()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen()));
          }
        },
        builder: (context, state) {
          return Center(
            child: LogoBuild(
              size: size.width,
            ),
          );
        },
      ),
    );
  }
}
