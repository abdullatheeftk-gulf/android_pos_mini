import 'dart:io';

import 'package:android_pos_mini/util/constants.dart';
import 'package:dio/dio.dart';

import '../main.dart';


//final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:8081/"));

void uploadProductImage(List<dynamic> args) async{
  try {
    final int productId = args[0] as int;
    print('upload image $productId');
    final FormData formData = args[1] as FormData;
    print('upla $formData');

    final response = await dio.post(
      '${Constants.addProductImage}/$productId',
      data: formData,

    );

    if (response.statusCode == 200) {
      print(response.data);
    } else {
      print('error');
    }
  }catch(e){
    print(e.toString());
  }

}
