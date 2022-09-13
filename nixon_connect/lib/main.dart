import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nixon_connect/Handlers/local_database_handler.dart';

import 'Cubit/create_room/create_room_cubit.dart';
import 'Services/auth_service.dart';
import 'Views/Screens/Launch/splash_screen.dart';

import 'Common/theme.dart';
import 'Cubit/auth/auth_cubit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await LocalDatabase().init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => CreateRoomCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: primaryTheme(),
        title: 'Nixon Connect',
        home: const LaunchScreen(),
      ),
    );
  }
}
