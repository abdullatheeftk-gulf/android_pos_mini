
import 'dart:io';

import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:android_pos_mini/blocs/thermal_printer/thermal_cubit.dart';
import 'package:android_pos_mini/presentation/splash_screen.dart';
import 'package:android_pos_mini/util/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Dio dio = Dio(BaseOptions(baseUrl: Constants.baseUrlWebAndDesktop));

void main() {
  /* Logger.root.activateLogcat();
  Logger.root.level = Level.ALL;*/
  runApp(MyApp(
    dio: dio,
  ));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        if(Platform.isAndroid)
        BlocProvider(
          create: (context)=>ThermalCubit(),
        ),
        BlocProvider(
          create: (context) => RootBloc(dio: dio),
        ),
        BlocProvider(
          create: (context) => MainBloc(
            dio: dio,
          ),
        ),
      ],
      child: MaterialApp(
          title: 'Unipos',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
            useMaterial3: true,
          ),
          home: const SplashScreen()),
    );
  }
}
