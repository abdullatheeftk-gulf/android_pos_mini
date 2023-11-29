import 'package:android_pos_mini/util/constants.dart';
import 'package:flutter/material.dart';
import '../../../../../../models/api_models/product/product.dart';
import 'package:flutter/foundation.dart';

class FoodItemCardInGrid extends StatelessWidget {
  final Product product;
  final Function productAddedEvent;

  const FoodItemCardInGrid({super.key, required this.product, required this.productAddedEvent});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape:
          RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade500)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.network(
              "${Constants.baseUrlWebAndDesktop}/downloadAnImage/${product.productImage}",
              height: 100,
              errorBuilder: (context, exception, stackTrace) {
                return const Center(child: Text('Error'));
              },
            ),
            Text(
              product.productName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              product.productPrice.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Material(
                child: Center(
                  child: Ink(
                    color: Colors.yellow,
                    height: 100.0,
                    child: InkWell(
                        onTap: () {
                          productAddedEvent(product);
                        },
                        child: const Center(
                          child: Text('Add'),
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
