import 'package:android_pos_mini/presentation/working_screens/child_screens/add_item/children/add_product/add_product_screen.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
            AddProductScreen()
        ],
      )
    );
  }
}
