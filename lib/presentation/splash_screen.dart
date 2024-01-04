import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:android_pos_mini/presentation/user_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RootBloc>()
      ..add(FetchWelcomeMessageEvent())
      ..add(SplashScreenLoadingTextAnimationEvent());

    return BlocConsumer<RootBloc, RootState>(
      listener: (context, state) {
        if(state.runtimeType == NavigateFromSplashScreenToLoginScreenState){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserLoginScreen()));
        }
        if(state.runtimeType == SplashScreenShowSnackbarMessageState){
          var errorMessage = (state as SplashScreenShowSnackbarMessageState).errorMessage ?? 'There have some problem while fetching welcome message';
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage))
           );
        }
      },
      listenWhen: (prev, cur) {
        if(cur is UiActionState){
          return true;
        }else{
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur is UiBuildState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        int widgetVisibilityValue = 0;
        if (state.runtimeType == SplashScreenLoadingTextAnimateState) {
          widgetVisibilityValue =
              (state as SplashScreenLoadingTextAnimateState).visibilityValue;
         // debugPrint('$widgetVisibilityValue');
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: [
                    TextSpan(
                      text: "UNIPOS\n",
                      style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Lora',
                          color: Colors.green,
                          fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: "ANDROID POS",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.brown,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 30,
                ),
                //Image.asset("assets/images/loading.gif",width: 50,height: 50,),
                Opacity(
                  opacity: widgetVisibilityValue!=-1 ? 1 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Loading',
                        style: TextStyle(fontSize: 16),
                      ),
                      Opacity(
                        opacity: widgetVisibilityValue >= 1 ? 1 : 0,
                        child: const Text('.',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Opacity(
                        opacity: widgetVisibilityValue >= 2 ? 1 : 0,
                        child: const Text('.',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Opacity(
                        opacity: widgetVisibilityValue >= 3 ? 1 : 0,
                        child: const Text('.',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Opacity(
                        opacity: widgetVisibilityValue >= 4 ? 1 : 0,
                        child: const Text('.',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
