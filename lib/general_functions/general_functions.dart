import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/general_functions/pair.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../util/constants.dart';

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

Widget drawerMenu(BuildContext context, Pair<String, String> menu,
    String selectedMenu, double screenWidth) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: InkWell(
      onTap: () {
        context
            .read<MainBloc>()
            .add(NavigationDrawerItemClickedEvent(menuName: menu.first));
        Navigator.pop(context);
      },
      child: Card(
        elevation: 2,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: selectedMenu == menu.first
                    ? Colors.red
                    : Colors.grey.shade500),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              kIsWeb ? Image.network('${Constants.baseUrlWebAndDesktop}/static/images/${menu.second}') :
              Image(
                image: AssetImage(
                  'assets/images/${menu.second}',
                ),
                width: screenWidth >= 1200 ? 100 : 50,
                height: screenWidth >= 1200 ? 100 : 50,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                menu.first,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selectedMenu == menu.first ? Colors.red : Colors.black,
                  fontSize: screenWidth>=1200?18:14
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
