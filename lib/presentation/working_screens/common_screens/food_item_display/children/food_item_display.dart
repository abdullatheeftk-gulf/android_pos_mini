import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/presentation/working_screens/common_screens/food_item_display/children/food_item_card_in_grid.dart';
import 'package:android_pos_mini/presentation/working_screens/common_screens/food_item_display/children/food_item_card_in_list.dart';
import 'package:android_pos_mini/util/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/api_models/product/product.dart';

class FoodItemDisplay extends StatelessWidget {
  const FoodItemDisplay({super.key});

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
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          return FoodItemCardInList(product: products[index]);
                        },
                        itemCount: products.length,
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        children: List.generate(products.length, (index) => FoodItemCardInGrid(product: products[index])),
                      ))
          ],
        );
      },
    );
  }
}
