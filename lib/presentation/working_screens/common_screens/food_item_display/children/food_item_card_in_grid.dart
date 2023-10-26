import 'package:flutter/material.dart';

import '../../../../../models/api_models/product/product.dart';

class FoodItemCardInGrid extends StatelessWidget {
  final Product product;

  const FoodItemCardInGrid({super.key, required this.product});

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
            const Image(
              image: AssetImage('images/burger.jpg'),
              fit: BoxFit.fill,
              height: 100,
              width: 100,
            ),
            Text(
              product.productName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8,),
            Text(
                product.productPrice.toString(),
                textAlign: TextAlign.center,
              style: const  TextStyle(fontSize: 18,fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8,),
            Expanded(
              child: Material(

                child: Center(
                  child: Ink(
                    color: Colors.yellow,
                    height: 100.0,
                    child: InkWell(
                        onTap: () { /* ... */ },
                        child: const Center(
                          child: Text('Add'),
                        )
                    ),
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
