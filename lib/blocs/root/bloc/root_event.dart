part of 'root_bloc.dart';

@immutable
sealed class RootEvent {}

// For Splash screen welcome message fetching event
class FetchWelcomeMessageEvent extends RootEvent {}

//
class SplashScreenLoadingTextAnimationEvent extends RootEvent{}
