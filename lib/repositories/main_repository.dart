import 'dart:convert';
import 'dart:io';

import 'package:android_pos_mini/models/api_models/cart/cart.dart';
import 'package:android_pos_mini/models/api_models/categories/category_response.dart';
import 'package:android_pos_mini/models/api_models/product/product_response.dart';
import 'package:android_pos_mini/util/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';

import '../general_functions/upload_product_image.dart';
import '../models/api_models/categories/category.dart';
import '../models/api_models/error/general_error.dart';
import '../models/api_models/product/product.dart';

class MainRepository {
  final Dio _dio;

  MainRepository(this._dio);

  Future<dynamic> getCategoryList() async {
    try {
      final response = await _dio.get(Constants.getAllCategories);

      if (response.statusCode == 200) {
        final List<Category> categories =
            CategoryResponse.fromJson(response.data).result;
        return categories;
      } else {
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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

  Future<dynamic> getProductsForACategory(int categoryId) async {
    try {
      final response =
          await _dio.get('${Constants.getProductByACategory}/$categoryId');
      if (response.statusCode == 200) {
        final List<Product> products =
            ProductResponse.fromJson(response.data).products;
        return products;
      } else if (response.statusCode == 204) {
        final List<Product> products = List.empty();
        return products;
      } else {
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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

  Future<dynamic> addAProduct(Product product, File? file) async {
    try {
      final response = await _dio.post(
        Constants.addAProduct,
        data: jsonEncode(product.toJson()),
        options:
            Options(headers: {Headers.contentTypeHeader: 'application/json'}),
      );
      if (response.statusCode == 201) {
        //print(response.data);
        try {
          final productId = response.data as int;
          print('productId $productId');
          if (file != null) {
            String fileName = file.path.split('/').last;
            FormData formData = FormData.fromMap({
              "file":
                  await MultipartFile.fromFile(file.path, filename: fileName),
            });
            compute(uploadProductImage, [productId, formData]);
          }
        } catch (e) {
          print(e.toString());
        }

        return response.data;
      } else {
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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

  Future<dynamic> translate(String value) async {
    try {
      final response = await _dio.get('${Constants.translate}/$value');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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

  Future<dynamic> transliterate(String value) async {
    try {
      final response = await _dio.get('${Constants.transliterate}/$value');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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

  Future<dynamic> searchAProduct(String key) async {
    try {
      final response = await _dio.get('${Constants.searchAProduct}/$key');
      if (response.statusCode == 200) {
        print('Success');
        final List<Product> products =
            ProductResponse.fromJson(response.data).products;
        return products;
      } else if (response.statusCode == 204) {
        final List<Product> products = List.empty();
        return products;
      } else {
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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

  Future<dynamic> generateInvoice(Cart cart) async {
    try {
      final response = await _dio.post(
        Constants.generateInvoice,
        data: jsonEncode(cart.toJson()),
        options:
            Options(headers: {Headers.contentTypeHeader: 'application/json'}),
      );
      if(response.statusCode == 200){
        final result = response.data;
        return result;
      }else{
        return GeneralError(message: "Unknown Exception", code: 600);
      }
    } on DioException catch (e) {
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
