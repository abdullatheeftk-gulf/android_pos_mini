part of 'root_bloc.dart';

@immutable
sealed class RootEvent {}

// For Splash screen welcome message fetching event
class FetchWelcomeMessageEvent extends RootEvent {}

//
class SplashScreenLoadingTextAnimationEvent extends RootEvent{}

class LoginScreenShowPasswordClickedEvent extends RootEvent{
  final bool showPassword;

  LoginScreenShowPasswordClickedEvent({required this.showPassword});
}

class LoginScreenLoginEvent extends RootEvent{
  final AdminUser adminUser;

  LoginScreenLoginEvent({required this.adminUser});

}




