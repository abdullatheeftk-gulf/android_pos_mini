import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:android_pos_mini/presentation/splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://192.168.246.194:8081'));
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
        BlocProvider(
          create: (context) => RootBloc(dio: dio),
        ),
        BlocProvider(
          create: (context) => MainBloc(dio: dio),
        )
      ],
      child: MaterialApp(
        title: 'Unipos Android',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
