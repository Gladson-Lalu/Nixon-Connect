import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nixon_connect/Services/auth_service.dart';
import 'package:nixon_connect/cubit/auth_cubit.dart';

import 'Common/theme.dart';
import 'Views/Screens/Launch/splash_screen.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: primaryTheme(),
        title: 'Nixon Connect',
        home: const LaunchScreen(),
      ),
    );
  }
}
