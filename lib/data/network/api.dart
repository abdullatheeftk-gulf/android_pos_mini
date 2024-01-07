
import 'package:android_pos_mini/util/api_error.dart';
import 'package:android_pos_mini/util/constants.dart';
import 'package:dio/dio.dart';

class Api{
  final Dio _dio =Dio(BaseOptions(baseUrl: Constants.baseUrlWebAndDesktop));

  Future<dynamic> getWelcomeMessage() async{
    try{

    }on DioException catch (e) {
      return ApiError(
        errorMessage: e.response?.statusMessage ?? "There have some problem while fetching welcome message, Check your network",
        code: e.response?.statusCode ?? Constants.generalApiCallingErrorCode,
      );
    } catch (e) {
      return ApiError(
        errorMessage: e.toString(),
        code: Constants.generalApiCallingErrorCode,
      );
    }
  }

}