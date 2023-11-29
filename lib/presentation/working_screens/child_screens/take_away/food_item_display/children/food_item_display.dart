import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/children/add_product_alert_dialog.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/children/food_item_card_in_grid.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/children/food_item_card_in_list.dart';
import 'package:android_pos_mini/util/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../models/api_models/product/product.dart';

class FoodItemDisplay extends StatelessWidget {
  const FoodItemDisplay({super.key});

  void _showProductAddDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AddProductAlertDialog(
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = [];
    ProductView productView = ProductView.list;

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      listenWhen: (prev, cur) {
        if (cur is UiActionState) {
          return true;
        } else {
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur.runtimeType == GetProductsForACategorySuccessState ||
            cur.runtimeType == ProductViewStyleSelectStyleState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.runtimeType == GetProductsForACategorySuccessState) {
          products = (state as GetProductsForACategorySuccessState).products;
        }
        if (state.runtimeType == ProductViewStyleSelectStyleState) {
          productView = (state as ProductViewStyleSelectStyleState).productView;
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<MainBloc>().add(ProductViewStyleSelectEvent(
                          productView: ProductView.list));
                    },
                    icon: const Icon(Icons.list),
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<MainBloc>().add(ProductViewStyleSelectEvent(
                          productView: ProductView.grid));
                    },
                    icon: const Icon(Icons.grid_view),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: (productView == ProductView.list)
                  ? /*ListView.builder(
                        itemBuilder: (context, index) {
                          return FoodItemCardInList(
                            product: products[index],
                            productAddedEvent: (Product product) {
                              _showProductAddDialog(context, product);
                            },
                          );
                        },
                        itemCount: products.length,
                      )*/
                  FoodListViewDisplay(
                      products: products,
                      callBackFunc: (context, product) {
                        _showProductAddDialog(context, product);
                      })
                  : /*GridView.count(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      children: List.generate(
                          products.length,
                          (index) => FoodItemCardInGrid(
                                product: products[index],
                                productAddedEvent: (Product product) {
                                  _showProductAddDialog(context, product);
                                },
                              )),
                    ),*/
              FoodGridViewDisplay(products: products, callBackFunc: (context,product){
                _showProductAddDialog(context, product);
              }),
            )
          ],
        );
      },
    );
  }
}

class FoodListViewDisplay extends StatelessWidget {
  final List<Product> products;
  final Function callBackFunc;

  const FoodListViewDisplay(
      {super.key, required this.products, required this.callBackFunc});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.widthConstraints().maxWidth;
     // print(width);
      return GridView.count(
        crossAxisCount: width >= 550
            ? (width > 900)
                ? (width > 1200)
                    ? 4
                    : 3
                : 2
            : 1,
        childAspectRatio: 2.8,
        children: List.generate(
          products.length,
          (index) => FoodItemCardInList(
            product: products[index],
            productAddedEvent: (Product product) {
              /*_showProductAddDialog(context, product);*/
              callBackFunc(context, product);
            },
          ),
        ),
      );
    });
  }
}

class FoodGridViewDisplay extends StatelessWidget {
  final List<Product> products;
  final Function callBackFunc;

  const FoodGridViewDisplay(
      {super.key, required this.products, required this.callBackFunc});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.widthConstraints().maxWidth;
      //print(width);
      return GridView.count(
        crossAxisCount: width >= 550
            ? (width > 900)
                ? (width > 1200)
                    ? (width>1600) ? 7:6
                    : 5
                : 4
            : 2,
        childAspectRatio: 0.8,
        children: List.generate(
          products.length,
          (index) => FoodItemCardInGrid(
            product: products[index],
            productAddedEvent: (Product product) {
              /*_showProductAddDialog(context, product);*/
              callBackFunc(context, product);
            },
          ),
        ),
      );
    });
  }
}
