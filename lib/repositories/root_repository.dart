import 'dart:convert';

import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:android_pos_mini/models/api_models/admin/admin_user.dart';
import 'package:android_pos_mini/models/api_models/error/general_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/api_models/admin/admin_response.dart';

class RootRepository {
  final Dio _dio;

  RootRepository(this._dio);

  Future<UiBuildState> getWelcomeMessage() async {
    try {
      final response = await _dio.get("");

      if (response.statusCode == 200) {
        final String data = response.data;
        //debugPrint(data);
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
        errorCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiFetchingFailedState(errorString: e.toString(), errorCode: 600);
    }
  }

  Future<dynamic> adminLogin(AdminUser adminUser) async {
    try {
      final response = await _dio.post(
        '/admin/loginAdminUser',
        data: jsonEncode(adminUser.toJson()),
        options: Options(headers: {
          Headers.contentTypeHeader: 'application/json',
          "sample": "my_sample"
        }),
      );

      if (response.statusCode == 200) {
        // debugPrint(response.data.toString());
        final AdminResponse adminResponse =
            AdminResponse.fromJson(response.data);
        //debugPrint(adminResponse.token);
        return adminResponse;
      } else {
        /*debugPrint('else error');
        return ApiFetchingFailedState(
          errorString: response.statusMessage,
          errorCode: response.statusCode,
        );*/
        //debugPrint("llllllllllllllll");
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
      //debugPrint("llllllllllllllll888888");

      debugPrint(e.toString());
      return GeneralError(
          message: e.response?.data, code: e.response?.statusCode ?? 601);
    } catch (e) {
      debugPrint(e.toString());
      if (e.runtimeType.toString() == '_TypeError') {
        return GeneralError(message: "JsonConvertException", code: 604);
      }
      return GeneralError(message: e.runtimeType.toString(), code: 603);
    }
  }
}
