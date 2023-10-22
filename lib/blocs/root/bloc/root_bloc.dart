// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:android_pos_mini/repositories/dio_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
final Dio dio;
late DioRepository _dioRepository;
bool _showLoadingTextInSplashScreen = true;

  RootBloc({required this.dio}) : super(RootInitial()) {
    _dioRepository = DioRepository(dio);

    on<FetchWelcomeMessageEvent>(fetchWelcomeMessageEvent);

    on<SplashScreenLoadingTextAnimationEvent>(splashScreenStarLoadingTextAnimationEvent);
  }

  FutureOr<void> fetchWelcomeMessageEvent(FetchWelcomeMessageEvent event, Emitter<RootState> emit) async{
    try {
      emit(ApiFetchingStartedState());
      final data = await _dioRepository.getWelcomeMessage();
      await Future.delayed(const Duration(seconds: 2));
      if(data.runtimeType==SplashScreenWelcomeMessageFetchState){
        _showLoadingTextInSplashScreen = false;
        emit(NavigateFromSplashScreenToLoginScreen());
      }else{
        debugPrint('false');
        var value = (data as ApiFetchingFailedState);
        emit(SplashScreenShowSnackbarMessageState(errorMessage: value.errorString));
        emit(SplashScreenLoadingTextAnimateState(visibilityValue: -1));
        _showLoadingTextInSplashScreen = false;
      }

    } catch (e) {
     // emit()
    }
  }

  




  FutureOr<void> splashScreenStarLoadingTextAnimationEvent(SplashScreenLoadingTextAnimationEvent event, Emitter<RootState> emit) async {
    try {
       while(_showLoadingTextInSplashScreen){
        debugPrint('splashScreenStarLoadingTextAnimationEvent');
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
}
