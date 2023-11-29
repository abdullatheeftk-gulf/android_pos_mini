import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/children/category_display.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/children/food_item_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/main/main_bloc.dart';

class FoodItemDisplayScreen extends StatelessWidget {
  const FoodItemDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(context,constraints){
        final screenWidth = constraints.widthConstraints().maxWidth;
        //print(screenWidth);
        return  Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width:  screenWidth>800 ? (screenWidth>1200) ? (screenWidth>1600)? 160:120 : 80 : 40,
                    child: const CategoryDisplay(),
                  ),
                  const Expanded(child: FoodItemDisplay()),
                ],
              )
            ],
          ),
        );
      }


    );
  }
}
