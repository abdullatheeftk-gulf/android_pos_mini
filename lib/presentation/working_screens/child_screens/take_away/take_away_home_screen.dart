import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/cart_display/cart_display_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/food_item_display_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/product_search/product_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TakeAwayHomeScreen extends StatefulWidget {
  const TakeAwayHomeScreen({super.key});

  @override
  State<TakeAwayHomeScreen> createState() => _TakeAwayHomeScreenState();
}

class _TakeAwayHomeScreenState extends State<TakeAwayHomeScreen> {

  @override
  void initState() {
    context.read<MainBloc>().add(ShowLengthOfTheCartProductItemsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int? length;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 85,
            title: TabBar(
              tabs: [
                const Tab(
                  icon: Icon(
                    Icons.restaurant_menu,
                  ),
                  text: 'Items',
                ),
                const Tab(
                  icon: Icon(Icons.search),
                  text: 'Search',
                ),
                Tab(
                  icon: BlocBuilder<MainBloc, MainState>(
                    buildWhen: (prev, cur) {
                      if (cur.runtimeType ==
                          ShowLengthOfTheProductsAreAddedToCartState) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      if (state.runtimeType ==
                          ShowLengthOfTheProductsAreAddedToCartState) {
                        length = (state
                                as ShowLengthOfTheProductsAreAddedToCartState)
                            .length;
                      }
                     // print('build Bloc selector');
                      return (length != null && length != 0)
                          ? Badge(
                              label: Text('$length'),
                              backgroundColor: Colors.blue,
                              child: const Icon(Icons.shopping_cart),
                            )
                          : const Icon(Icons.shopping_cart);
                    },
                  ),
                  text: 'Cart',
                ),
              ],
            ),
            backgroundColor: Colors.orange,
          ),
          body: const TabBarView(
            children: [
              FoodItemDisplayScreen(),
              ProductSearchScreen(),
              CartDisplayScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
