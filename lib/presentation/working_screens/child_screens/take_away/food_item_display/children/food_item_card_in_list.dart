import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../models/api_models/product/product.dart';

class FoodItemCardInList extends StatelessWidget {
  final Product product;
  final Function productAddedEvent;

  const FoodItemCardInList(
      {super.key, required this.product, required this.productAddedEvent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade500)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Image.network(
                  "${Constants.baseUrlWebAndDesktop}/downloadAnImage/${product.productImage}",
                  errorBuilder: (context, exception, stackTrace) {
                    return const Center(child: Text('Error'));
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.productName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      product.productPrice.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ),
              Material(
                color: Colors.teal[900],
                child: Center(
                  child: Ink(
                    color: Colors.yellow,
                    width: 100.0,
                    // height: 100.0,
                    child: InkWell(
                        onTap: () {
                          productAddedEvent(product);
                        },
                        child: const Center(
                          child: Text('Add'),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
