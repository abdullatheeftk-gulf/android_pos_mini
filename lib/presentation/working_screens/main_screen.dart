import 'dart:io';

import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/general_functions/general_functions.dart';
import 'package:android_pos_mini/presentation/connect_thermal_printer_screen/connect_thermal_printer_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/add_item/add_item_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/take_away_home_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/child_screens/take_away/food_item_display/food_item_display_screen.dart';
import 'package:android_pos_mini/presentation/working_screens/print_preview_screen/print_preview_screen.dart';
import 'package:android_pos_mini/repositories/my_print_preview.dart';

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

        if (state.runtimeType ==
            NavigateFromTheCartDisplayScreenToPrintPreviewScreenState) {
          final total = (state
                  as NavigateFromTheCartDisplayScreenToPrintPreviewScreenState)
              .total;
          final cartProductItems = state.cartProductItems;
          final invoiceNo = state.invoiceNo;
          if(Platform.isAndroid){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const PrintPreviewScreen()
              ),
            );
          }else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MyPrintPreview(
                      title: "Unipospro",
                      cartProductItems: cartProductItems,
                      total: total,
                      invoiceNo: invoiceNo,
                    ),
              ),
            );
          }
        }

        if(state.runtimeType == NavigateToMainScreenToConnectToThermalScreenState){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ConnectThermalPrinterScreen()));
        }
      },
      listenWhen: (prev, cur) {
        if (cur is UiActionState) {
          return true;
        } else {
          return false;
        }
      },
      buildWhen: (prev, cur) {
        if (cur.runtimeType == NavigationDrawerItemClickedState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.runtimeType == NavigationDrawerItemClickedState) {
          drawerMenuName = (state as NavigationDrawerItemClickedState).menuName;
        }
        return LayoutBuilder(builder: (context, constraints) {
          final screenWidth = constraints.widthConstraints().maxWidth;
          return Scaffold(
              appBar: AppBar(
                title: Text(drawerMenuName),
                centerTitle: false,
                automaticallyImplyLeading: false,
              ),
              endDrawer: Drawer(
                width: screenWidth >= 1200 ? 200 : 100,
                child: SafeArea(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return drawerMenu(
                        context,
                        _drawerMenuItems[index],
                        drawerMenuName,
                        screenWidth,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox();
                    },
                    itemCount: _drawerMenuItems.length,
                  ),
                ),
              ),
              body: _getBodyWidget(context, drawerMenuName));
        });
      },
    );
  }

  Widget _getBodyWidget(BuildContext context, String drawerMenuName) {
    switch (drawerMenuName) {
      case 'Take Away':
        {
          print('Take Away');
          //context.read<MainBloc>().add(EmptyCartProductEvent());
          return const TakeAwayHomeScreen();
        }
      case 'Add Item':
        {
          return const AddItemScreen();
        }
      default:
        {
          return const Center(child: Text('Sample'));
        }
    }
  }
}
