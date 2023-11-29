part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class NavigationDrawerItemClickedEvent extends MainEvent{
  final String menuName;

  NavigationDrawerItemClickedEvent({required this.menuName});
}

class CategoryLoadingEvent extends MainEvent{}

class ProductForACategoryLoadingEvent extends MainEvent{
  final int categoryId;

  ProductForACategoryLoadingEvent({required this.categoryId});
}

class SearchForProductByKeyEvent extends MainEvent{
  final String key;

  SearchForProductByKeyEvent({required this.key});
}

class ProductViewStyleSelectEvent extends MainEvent{
  final ProductView productView;

  ProductViewStyleSelectEvent({required this.productView});

}

class CategoriesSelectedForProductEvent extends MainEvent{
  final Category category;
  final bool isCategoryChecked;

  CategoriesSelectedForProductEvent({required this.isCategoryChecked, required this.category});
}

class EmptyTheListOfCategoriesForProductEvent extends MainEvent{}

class RemoveOneItemFromTheProductAddCategoryListEvent extends MainEvent{
  final int categoryId;

  RemoveOneItemFromTheProductAddCategoryListEvent({required this.categoryId});

}

class AddAProductEvent extends MainEvent{
  final Product product;
  final File? file;

  AddAProductEvent({required this.product, required this.file});
}

class NotShowProgressBarEvent extends MainEvent{}

class TranslateTextEvent extends MainEvent{
  final String value;

  TranslateTextEvent({required this.value});
}

class TransliterateTextEvent extends MainEvent{
  final String value;

  TransliterateTextEvent({required this.value});

}




















class ShowSnackBarInAddProductScreenEvent extends MainEvent{
  final String message;

  ShowSnackBarInAddProductScreenEvent({required this.message});

}

class ShowSnackBarInProductSearchScreenEvent extends MainEvent{
  final String message;

  ShowSnackBarInProductSearchScreenEvent({required this.message});

}

class AddProductToCartEvent extends MainEvent{
  final Product product;
  final double noOfItemsOrdered;
  final String? note;

  AddProductToCartEvent({this.note,required this.noOfItemsOrdered,  required this.product});
}

class ShowCartProductsEvent extends MainEvent{}

//class EmptyCartProductEvent extends MainEvent{}

class ShowLengthOfTheCartProductItemsEvent extends MainEvent{}

class ReArrangeCartProductItemsQtyEvent extends MainEvent{
  final int index;
  final double qty;

  ReArrangeCartProductItemsQtyEvent({required this.index, required this.qty});
}

class DeleteCartProductItemEvent extends MainEvent{
  final int index;

  DeleteCartProductItemEvent({required this.index});
}

class GenerateInvoiceEvent extends MainEvent{
  final Cart cart;

  GenerateInvoiceEvent({required this.cart});
}

class PrintPreviewInitEvent extends MainEvent{

}

class ResetOrdersEvent extends MainEvent{}