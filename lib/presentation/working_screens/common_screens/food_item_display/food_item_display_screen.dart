import 'package:android_pos_mini/presentation/working_screens/common_screens/food_item_display/children/category_display.dart';
import 'package:android_pos_mini/presentation/working_screens/common_screens/food_item_display/children/food_item_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/main/main_bloc.dart';

class FoodItemDisplayScreen extends StatelessWidget {
  const FoodItemDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              //SizedBox(width: 40, child: CategoryDisplay(),),
              SizedBox(width: 40,child: CategoryDisplay()),
              const Expanded(child: FoodItemDisplay()),
            ],
          )
        ],
      ),
    );
  }
}
