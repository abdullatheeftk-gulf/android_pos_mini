import 'package:flutter/material.dart';

import '../../../../../models/api_models/product/product.dart';

class FoodItemCardInList extends StatelessWidget {
  final Product product;

  const FoodItemCardInList({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        elevation: 3,
        shape:
             RoundedRectangleBorder(side: BorderSide(color: Colors.grey.shade500)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Image(
                image: AssetImage('images/burger.jpg'),
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    height: 100.0,
                    child: InkWell(
                        onTap: () { /* ... */ },
                        child: const Center(
                          child: Text('Add'),
                        )
                    ),
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
