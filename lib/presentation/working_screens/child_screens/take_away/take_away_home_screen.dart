import 'package:android_pos_mini/presentation/working_screens/common_screens/food_item_display/food_item_display_screen.dart';
import 'package:flutter/material.dart';

class TakeAwayHomeScreen extends StatelessWidget {
  const TakeAwayHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 85,
            title: const TabBar(tabs: [
              Tab(icon: Icon(Icons.restaurant_menu,),text: 'Items',),
              Tab(icon: Icon(Icons.search),text: 'Search',),
              Tab(icon: Icon(Icons.shopping_cart),text: 'Cart',),
            ],
            ),
            backgroundColor: Colors.orange,
          ),
          body: TabBarView(
            children: [
                FoodItemDisplayScreen(),
                Text('Food search'),
              Text('Cart'),
            ],
          ),
        ),
      ),
    );
  }
}
