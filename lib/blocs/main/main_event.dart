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