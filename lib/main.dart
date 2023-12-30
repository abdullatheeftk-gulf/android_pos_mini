import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:android_pos_mini/presentation/splash_screen.dart';
import 'package:android_pos_mini/util/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';


final Dio dio = Dio(BaseOptions(baseUrl: Constants.baseUrlWebAndDesktop));
final PrinterManager printerManager = PrinterManager.instance;
const MethodChannel methodChannel =  MethodChannel("text2image");

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
        BlocProvider(
          create: (context) => RootBloc(dio: dio),
        ),
        BlocProvider(
          create: (context) => MainBloc(dio: dio,printerManager: printerManager,methodChannel: methodChannel),
        )
      ],
      child: MaterialApp(
        title: 'Unipos Android',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          useMaterial3: true,
        ),
        home: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          final width = constraints.widthConstraints().maxWidth;
          print(width);

          return const SplashScreen();
        },

        ),
      ),
    );
  }
}
