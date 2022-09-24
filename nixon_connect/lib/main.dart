import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Cubit/channels/channels_cubit.dart';
import 'Cubit/join_room/join_room_cubit.dart';
import 'Handlers/local_database_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'Cubit/create_room/create_room_cubit.dart';
import 'Views/Screens/Launch/splash_screen.dart';

import 'Common/theme.dart';
import 'Cubit/auth/auth_cubit.dart';
import 'WorkManager/callback_dispatcher.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await LocalDatabase().init();
  await Workmanager().initialize(
    callbackDispatcher,
  );
  await Workmanager().registerPeriodicTask(
    "1",
    "fetch_location",
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 10),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChannelsCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
              BlocProvider.of<ChannelsCubit>(context)),
        ),
        BlocProvider(
          create: (context) => CreateRoomCubit(),
        ),
        BlocProvider(create: (context) => JoinRoomCubit())
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
