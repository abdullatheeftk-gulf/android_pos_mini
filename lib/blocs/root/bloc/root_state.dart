part of 'root_bloc.dart';

@immutable
sealed class RootState {}

final class RootInitial extends RootState {}

// For building ui
class UiBuildState extends RootState{}

// For navigating
class UiActionState extends RootState{}

// For Api Fetching started state 
class ApiFetchingStartedState extends UiBuildState{}

// For Api Fetching failed state
class ApiFetchingFailedState extends UiBuildState{
  final String? errorString;
  final int? errorCode;
  
  ApiFetchingFailedState({required this.errorString,required this.errorCode});
}


// Splash screen api welcome message fetching state
class SplashScreenWelcomeMessageFetchState extends UiBuildState{
  final String welcomeMessage;

  SplashScreenWelcomeMessageFetchState({required this.welcomeMessage});
}

class SplashScreenLoadingTextAnimateState extends UiBuildState{
  final int visibilityValue;

  SplashScreenLoadingTextAnimateState({required this.visibilityValue});
}





// Navigation states

// Splash to Login
class NavigateFromSplashScreenToLoginScreen extends UiActionState{}


// Snackbar show state
class SplashScreenShowSnackbarMessageState extends UiActionState{
  final String? errorMessage;

  SplashScreenShowSnackbarMessageState({required this.errorMessage});
}



