
import 'dart:async';
import 'package:android_pos_mini/models/api_models/admin/admin_response.dart';
import 'package:android_pos_mini/models/api_models/admin/admin_user.dart';
import 'package:android_pos_mini/models/api_models/error/general_error.dart';
import 'package:android_pos_mini/repositories/root_repository.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
final Dio dio;
late RootRepository _dioRepository;
bool _showLoadingTextInSplashScreen = true;

  RootBloc({required this.dio}) : super(RootInitial()) {
    _dioRepository = RootRepository(dio);

    on<FetchWelcomeMessageEvent>(fetchWelcomeMessageEvent);

    on<SplashScreenLoadingTextAnimationEvent>(splashScreenStarLoadingTextAnimationEvent);

    on<LoginScreenShowPasswordClickedEvent>(loginScreenShowPasswordClickedEvent);

    on<LoginScreenLoginEvent>(loginScreenLoginEvent);
  }

  FutureOr<void> fetchWelcomeMessageEvent(FetchWelcomeMessageEvent event, Emitter<RootState> emit) async{
    try {
      emit(ApiFetchingStartedState());
      final data = await _dioRepository.getWelcomeMessage();
      await Future.delayed(const Duration(seconds: 2));
      if(data.runtimeType==SplashScreenWelcomeMessageFetchState){
        _showLoadingTextInSplashScreen = false;
        emit(NavigateFromSplashScreenToLoginScreenState());
      }else{
        //debugPrint('false');
        var value = (data as ApiFetchingFailedState);
        emit(SplashScreenShowSnackbarMessageState(errorMessage: value.errorString));
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: -1));
        _showLoadingTextInSplashScreen = false;
      }

    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 602));
    }
  }

  




  FutureOr<void> splashScreenStarLoadingTextAnimationEvent(SplashScreenLoadingTextAnimationEvent event, Emitter<RootState> emit) async {
    try {
       while(_showLoadingTextInSplashScreen){
       // debugPrint('splashScreenStarLoadingTextAnimationEvent');
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: 1));
        await Future.delayed(const Duration(milliseconds: 750));
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: 2));
        await Future.delayed(const Duration(milliseconds: 750));
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: 3));
        await Future.delayed(const Duration(milliseconds: 750));
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: 4));
        await Future.delayed(const Duration(milliseconds: 1500));
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: 0));
        await Future.delayed(const Duration(milliseconds: 1000));
       }
    } catch (e) {
      e.toString();
    }
  }

  FutureOr<void> loginScreenShowPasswordClickedEvent(LoginScreenShowPasswordClickedEvent event, Emitter<RootState> emit) async{
    final showPassword = event.showPassword;
    emit(LoginScreenShowPasswordState(showPassword: !showPassword));
  }

  FutureOr<void> loginScreenLoginEvent(LoginScreenLoginEvent event, Emitter<RootState> emit) async{
    try {
      emit(ApiFetchingStartedState());
      final adminUser = event.adminUser;
      //print(adminUser.adminName);
      final result = await _dioRepository.adminLogin(adminUser);
      if(result.runtimeType ==  AdminResponse){
        emit(NavigateFromLoginScreenToMainScreenState(userName: adminUser.adminName));
      }else{
        final generalError = result as GeneralError;
        //debugPrint('${generalError.message},- ${generalError.code}');
        emit(ApiFetchingFailedState(errorString: generalError.message, errorCode: generalError.code));
        emit(LoginScreenShowSnackbarMessageState(errorMessage: generalError.message ?? 'There have some problem'));
      }

    }catch(e){
     /* debugPrint("999999999");
      debugPrint(e.toString());*/
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }

  }
}
