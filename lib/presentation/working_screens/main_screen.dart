import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/general_functions/general_functions.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/take_away_home_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/common_screens/food_item_display/food_item_display_screen.dart';

//import 'package:android_pos_mini/blocs/root/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../general_functions/pair.dart';

class MainScreen extends StatelessWidget {
  final String userName;

  MainScreen({super.key, required this.userName});

  final List<Pair<String, String>> _drawerMenuItems = [
    Pair(first: 'Take Away', second: 'take_away.png'),
    Pair(first: 'Table', second: 'table.png'),
    Pair(first: 'Edit', second: 'edit.png'),
    Pair(first: 'Add Item', second: 'add_product.png'),
    Pair(first: 'Setting', second: 'setting.png'),
  ];

  @override
  Widget build(BuildContext context) {
    String drawerMenuName = 'Take Away';
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
        if (cur is UiBuildState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.runtimeType == NavigationDrawerItemClickedState) {
          drawerMenuName = (state as NavigationDrawerItemClickedState).menuName;
        }
        return Scaffold(
            appBar: AppBar(
              title: Text(drawerMenuName),
              centerTitle: false,
              automaticallyImplyLeading: false,
            ),
            endDrawer: Drawer(
              width: 100,
              child: SafeArea(
                child: ListView.separated(
                  itemBuilder: (context, index) {

                    return drawerMenu(context, _drawerMenuItems[index], drawerMenuName);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox();
                  },
                  itemCount: _drawerMenuItems.length,
                ),
              ),
            ),
            body: _getBodyWidget(drawerMenuName));
      },
    );
  }

  Widget _getBodyWidget(String drawerMenuName) {
    switch (drawerMenuName) {
      case 'Take Away':
        {
          return const TakeAwayHomeScreen();
        }
      default:
        {
          return const Center(child: Text('Sample'));
        }
    }
  }
}
