import 'dart:async';
import 'dart:io';

import 'package:android_pos_mini/general_functions/pair.dart';
import 'package:android_pos_mini/models/api_models/categories/category.dart';
import 'package:android_pos_mini/repositories/main_repository.dart';
import 'package:android_pos_mini/util/product_view.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../models/api_models/error/general_error.dart';
import '../../models/api_models/product/product.dart';
import '../../repositories/root_repository.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final Dio dio;
  late MainRepository _mainRepository;
  final List<Pair<int, String>> _listOfCategory = List.empty(growable: true);

  MainBloc({required this.dio}) : super(MainInitial()) {
    _listOfCategory.add(Pair(first: -1, second: "Add New"));
    _mainRepository = MainRepository(dio);
    on<NavigationDrawerItemClickedEvent>(navigationDrawerItemClickedEvent);

    on<CategoryLoadingEvent>(categoryLoadingEvent);

    on<ProductForACategoryLoadingEvent>(productForACategoryLoadingEvent);

    on<ProductViewStyleSelectEvent>(productViewStyleSelectEvent);

    on<CategoriesSelectedForProductEvent>(categoriesSelectedForProductEvent);

    on<EmptyTheListOfCategoriesForProductEvent>(
        emptyTheListOfCategoriesForProductEvent);

    on<RemoveOneItemFromTheProductAddCategoryListEvent>(
        removeOneItemFromTheProductAddCategoryListEvent);

    on<AddAProductEvent>(addAProductEvent);

    on<TranslateTextEvent>(translateTextEvent);

    on<TransliterateTextEvent>(transliterateTextEvent);

    on<ShowSnackBarInAddProductScreenEvent>(
        showSnackBarInAddProductScreenEvent);
  }

  FutureOr<void> navigationDrawerItemClickedEvent(
      NavigationDrawerItemClickedEvent event, Emitter<MainState> emit) async {
    final String menuName = event.menuName;

    emit(NavigationDrawerItemClickedState(menuName: menuName));
  }

  FutureOr<void> categoryLoadingEvent(
      CategoryLoadingEvent event, Emitter<MainState> emit) async {
    try {
      // emit(ApiFetchingStartedState());
      final dynamic result = await _mainRepository.getCategoryList();

      if (result.runtimeType == List<Category>) {
        final categories = result as List<Category>;
        /*debugPrint('--------------');
        for (var element in categories) {
          debugPrint(element.categoryName);
        }*/
        emit(CategoryLoadingSuccessState(categories: categories));
      } else {
        final generalError = result as GeneralError;
        // debugPrint('${generalError.message},- ${generalError.code}');
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
        //emit(LoginScreenShowSnackbarMessageState(errorMessage: generalError.message ?? 'There have some problem'));
      }
    } catch (e) {
      //debugPrint(e.toString());
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> productForACategoryLoadingEvent(
      ProductForACategoryLoadingEvent event, Emitter<MainState> emit) async {
    try {
      emit(ApiFetchingStartedState());
      final int categoryId = event.categoryId;
      emit(CategoryClickedState(categoryId: categoryId));
      final dynamic result =
          await _mainRepository.getProductsForACategory(categoryId);

      if (result.runtimeType == List<Product>) {
        final products = result as List<Product>;
        //debugPrint('--------------');
        /*for (var element in products) {
          debugPrint(element.productName);
        }*/
        emit(GetProductsForACategorySuccessState(products: products));
      } else {
        final generalError = result as GeneralError;
        // debugPrint('${generalError.message},- ${generalError.code}');
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
        //emit(LoginScreenShowSnackbarMessageState(errorMessage: generalError.message ?? 'There have some problem'));
      }
    } catch (e) {
      //debugPrint(e.toString());
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> productViewStyleSelectEvent(
      ProductViewStyleSelectEvent event, Emitter<MainState> emit) async {
    final ProductView productView = event.productView;
    emit(ProductViewStyleSelectStyleState(productView: productView));
  }

  FutureOr<void> categoriesSelectedForProductEvent(
      CategoriesSelectedForProductEvent event, Emitter<MainState> emit) {
    final Category category = event.category;
    final bool isCategoryClicked = event.isCategoryChecked;

    if (isCategoryClicked) {
      // print("is category clicked");
      _listOfCategory
          .add(Pair(first: category.categoryId, second: category.categoryName));
    } else {
      //print("is category not clicked");
      final v = _listOfCategory.contains(
          Pair(first: category.categoryId, second: category.categoryName));
      // print(v);
      _listOfCategory
          .removeWhere((element) => element.first == category.categoryId);
    }
    emit(CategorySelectedForProductState(listOfCategory: _listOfCategory));
  }

  FutureOr<void> emptyTheListOfCategoriesForProductEvent(
      EmptyTheListOfCategoriesForProductEvent event, Emitter<MainState> emit) {
    _listOfCategory.clear();
  }

  FutureOr<void> removeOneItemFromTheProductAddCategoryListEvent(
      RemoveOneItemFromTheProductAddCategoryListEvent event,
      Emitter<MainState> emit) {
    final int categoryId = event.categoryId;

    print('----------------');
    for (var element in _listOfCategory) {
      print(element.toString());
    }
    _listOfCategory.removeWhere((element) => element.first == categoryId);
    emit(CategorySelectedForProductState(listOfCategory: _listOfCategory));
  }

  FutureOr<void> addAProductEvent(
      AddAProductEvent event, Emitter<MainState> emit) async {
    final Product product = event.product;
    final File? file = event.file;
    try {
      emit(ApiFetchingStartedState());
      final result = await MainRepository(dio).addAProduct(product, file);
      if (result.runtimeType == int) {
        if (result > 0) {
          //print('Success');
          // print(result);
          emit(AddProductSuccessState(productId: result));
        }
      } else {
        //print("error");
        final GeneralError generalError = result as GeneralError;
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
      }
    } catch (e) {
      //debugPrint(e.toString());
      //print('Error string ${e.toString()}');
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> translateTextEvent(
      TranslateTextEvent event, Emitter<MainState> emit) async {
    try {
      final value = event.value;
      final result = await _mainRepository.translate(value);
      if(result.runtimeType==String) {
        final value = result as String;
        emit(TranslateTextState(value: value));
      }else{
        final generalError = result as GeneralError;
        emit(ApiFetchingFailedState(errorString: generalError.message, errorCode: generalError.code));
      }
    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> transliterateTextEvent(
      TransliterateTextEvent event, Emitter<MainState> emit) async {
    try {
      final value = event.value;
      final result = await _mainRepository.transliterate(value);
      if(result.runtimeType == String){
        final value = result as String;
        emit(TranslateTextState(value: value));
      }else{
        final generalError = result as GeneralError;
        emit(ApiFetchingFailedState(errorString: generalError.message, errorCode: generalError.code));
      }

    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> showSnackBarInAddProductScreenEvent(
      ShowSnackBarInAddProductScreenEvent event, Emitter<MainState> emit) {
    final String message = event.message;
    emit(ShowSnackBarInAddProductScreenState(message: message));
  }
}
