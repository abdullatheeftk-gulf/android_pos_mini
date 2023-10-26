import 'dart:async';

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

  MainBloc({required this.dio}) : super(MainInitial()) {
    _mainRepository = MainRepository(dio);
    on<NavigationDrawerItemClickedEvent>(navigationDrawerItemClickedEvent);

    on<CategoryLoadingEvent>(categoryLoadingEvent);

    on<ProductForACategoryLoadingEvent>(productForACategoryLoadingEvent);

    on<ProductViewStyleSelectEvent>(productViewStyleSelectEvent);
  }






  FutureOr<void> navigationDrawerItemClickedEvent(NavigationDrawerItemClickedEvent event, Emitter<MainState> emit) async{
    final String menuName = event.menuName;
    emit(NavigationDrawerItemClickedState(menuName: menuName));
  }

  FutureOr<void> categoryLoadingEvent(CategoryLoadingEvent event, Emitter<MainState> emit) async{
    try{
      emit(ApiFetchingStartedState());
      final dynamic result = await _mainRepository.getCategoryList();

      if(result.runtimeType ==  List<Category>){
        final categories = result as List<Category>;
        /*debugPrint('--------------');
        for (var element in categories) {
          debugPrint(element.categoryName);
        }*/
        emit(CategoryLoadingSuccessState(categories:categories ));
      }else{
        final generalError = result as GeneralError;
       // debugPrint('${generalError.message},- ${generalError.code}');
        emit(ApiFetchingFailedState(errorString: generalError.message, errorCode: generalError.code));
        //emit(LoginScreenShowSnackbarMessageState(errorMessage: generalError.message ?? 'There have some problem'));
      }

    }catch(e){
      //debugPrint(e.toString());
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> productForACategoryLoadingEvent(ProductForACategoryLoadingEvent event, Emitter<MainState> emit) async{
    try{
      emit(ApiFetchingStartedState());
      final int categoryId = event.categoryId;
      emit(CategoryClickedState(categoryId: categoryId));
      final dynamic result = await _mainRepository.getProductsForACategory(categoryId);

      if(result.runtimeType ==  List<Product>){
        final products = result as List<Product>;
        debugPrint('--------------');
        for (var element in products) {
          debugPrint(element.productName);
        }
        emit(GetProductsForACategorySuccessState(products: products));
      }else{
        final generalError = result as GeneralError;
        // debugPrint('${generalError.message},- ${generalError.code}');
        emit(ApiFetchingFailedState(errorString: generalError.message, errorCode: generalError.code));
        //emit(LoginScreenShowSnackbarMessageState(errorMessage: generalError.message ?? 'There have some problem'));
      }

    }catch(e){
      //debugPrint(e.toString());
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> productViewStyleSelectEvent(ProductViewStyleSelectEvent event, Emitter<MainState> emit) async{
    final ProductView productView = event.productView;
    emit(ProductViewStyleSelectStyleState(productView: productView));

  }
}
