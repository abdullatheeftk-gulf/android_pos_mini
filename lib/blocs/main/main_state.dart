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

class SearchProductByKeySuccessState extends UiBuildState{
  final List<Product> products;

  SearchProductByKeySuccessState({required this.products});
}

// Category Clicked State
class CategoryClickedState extends UiBuildState{
  final int categoryId;

  CategoryClickedState({required this.categoryId});
}


class CategorySelectedForProductState extends UiBuildState{
  final List<Pair<int,String>> listOfCategory;

  CategorySelectedForProductState({required this.listOfCategory});
}

class AddProductSuccessState extends UiBuildState{
  final int productId;

  AddProductSuccessState({required this.productId});
}

class NotShowProgressBarState extends UiBuildState{}

class TranslateTextState extends UiBuildState{
  final String value;

  TranslateTextState({required this.value});
}

class TransliterateTextState extends UiBuildState{
  final String value;

  TransliterateTextState({required this.value});
}

class ShowSnackBarInAddProductScreenState extends UiActionState{
  final String message;

  ShowSnackBarInAddProductScreenState({required this.message});

}

class ShowSnackBarInProductSearchScreenState extends UiActionState{
  final String message;

  ShowSnackBarInProductSearchScreenState({required this.message});
}

class ShowProductsAreAddedToCartState extends UiBuildState{
  final List<CartProductItem> cartProductItems;
  final double total;

  ShowProductsAreAddedToCartState({required this.total, required this.cartProductItems});
}

class ShowLengthOfTheProductsAreAddedToCartState extends UiBuildState{
  final int length;

  ShowLengthOfTheProductsAreAddedToCartState({required this.length});
}

class GenerateInvoiceSuccessState extends UiBuildState{
  final String invoiceNo;

  GenerateInvoiceSuccessState({required this.invoiceNo});
}

class NavigateFromTheCartDisplayScreenToPrintPreviewScreenState extends UiActionState{
  final List<CartProductItem> cartProductItems;
  final double total;
  final String invoiceNo;

  NavigateFromTheCartDisplayScreenToPrintPreviewScreenState({required this.cartProductItems, required this.total, required this.invoiceNo});
}

class ShowGenerateInvoiceErrorAsSnackBarState extends UiActionState{
  final String message;

  ShowGenerateInvoiceErrorAsSnackBarState({required this.message});

}


class PrintPreviewInitState extends UiBuildState{
  final String invoiceNo;
  final double total;
  final List<CartProductItem> cartProductItems;

  PrintPreviewInitState({required this.invoiceNo, required this.total, required this.cartProductItems});
}



// Thermal printer states

final class ThermalUsbPrinterConnectedState extends UiBuildState{
  final bool isUsbThermalPrinterConnected;

  ThermalUsbPrinterConnectedState({required this.isUsbThermalPrinterConnected});
}

final class NavigateToMainScreenToConnectToThermalScreenState extends UiActionState{}



