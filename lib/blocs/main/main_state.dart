part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

// For building ui
class UiBuildState extends MainState{}

// For navigating
class UiActionState extends MainState{}





// For Api Fetching started state
class ApiFetchingStartedState extends UiBuildState{}

// For Api Fetching failed state
class ApiFetchingFailedState extends UiBuildState{
  final String? errorString;
  final int? errorCode;

  ApiFetchingFailedState({required this.errorString,required this.errorCode});
}



// ProductViewStyle state
class ProductViewStyleSelectStyleState extends UiBuildState{
  final ProductView productView;

  ProductViewStyleSelectStyleState({required this.productView});
}



// Navigation drawer click classes
class NavigationDrawerItemClickedState extends UiBuildState{
  final String menuName;

  NavigationDrawerItemClickedState({required this.menuName});
}








// Category Loading from backend state
class CategoryLoadingSuccessState extends UiBuildState{
  final List<Category> categories;

  CategoryLoadingSuccessState({required this.categories});
}

// Get Products for a Category
class GetProductsForACategorySuccessState extends UiBuildState{
  final List<Product> products;

  GetProductsForACategorySuccessState({required this.products});
}

class CategoryClickedState extends UiBuildState{
  final int categoryId;

  CategoryClickedState({required this.categoryId});

}

