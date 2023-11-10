
import 'package:flutter/material.dart';

class CheckBoxForCategoriesDisplay extends StatefulWidget {
  bool isChecked;
  final Function callBack;
  CheckBoxForCategoriesDisplay({super.key, required this.callBack,required this.isChecked});

  @override
  State<CheckBoxForCategoriesDisplay> createState() => _CheckBoxForCategoriesDisplayState();
}

class _CheckBoxForCategoriesDisplayState extends State<CheckBoxForCategoriesDisplay> {

  @override
  Widget build(BuildContext context) {

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }
    return Checkbox(
      checkColor: Colors.green,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.isChecked,
      onChanged: (bool? value) {
        widget.callBack(value!);
        setState(() {
         widget. isChecked = value;
        });
      },
    );
  }
}
