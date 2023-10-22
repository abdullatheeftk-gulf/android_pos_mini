
import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioRepository{
  final Dio _dio;

  DioRepository(this._dio);

  Future<UiBuildState> getWelcomeMessage() async {
    try {
      
      final response = await _dio.get("");
      if (response.statusCode == 200) {
        final String data = response.data;
        debugPrint(data);
        return SplashScreenWelcomeMessageFetchState(welcomeMessage: data);
      } else {
        return ApiFetchingFailedState(
            errorString: response.statusMessage,
            errorCode: response.statusCode,
          );
      }
    } on DioException catch (e) {
      return ApiFetchingFailedState(
          errorString: e.response?.statusMessage,
          errorCode: e.response?.statusCode,);
    } catch (e) {
      return ApiFetchingFailedState(errorString: e.toString(), errorCode: 600);
    }
  }
}