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