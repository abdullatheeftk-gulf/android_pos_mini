import 'package:android_pos_mini/blocs/main/main_bloc.dart';
import 'package:android_pos_mini/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../models/api_models/product/product.dart';

class AddProductAlertDialog extends StatefulWidget {
  final Product product;

  const AddProductAlertDialog({super.key, required this.product});

  @override
  State<AddProductAlertDialog> createState() => _AddProductAlertDialogState();
}

class _AddProductAlertDialogState extends State<AddProductAlertDialog> {
  final _noteController = TextEditingController();
  int _noOfTimesOrdered = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.product.productName,
        textAlign: TextAlign.center,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network('${Constants.baseUrlMobile}/downloadAnImage/${widget.product.productImage}'),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'No of Items Required',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 4,
            ),
            Container(
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      if (_noOfTimesOrdered != 1) {
                        _noOfTimesOrdered--;
                        setState(() {});
                      }
                    },
                    icon: const RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        Icons.double_arrow,
                        color: Colors.red,
                      ),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  IconButton(
                    onPressed: null,
                    icon: Text(
                      '$_noOfTimesOrdered',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _noOfTimesOrdered++;
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.double_arrow,
                        color: Colors.green,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                  label: const Text('Note'),
                  hintText: 'Enter Notes about product',
                  hintStyle: TextStyle(
                    color: Colors.black26.withOpacity(0.3),
                  ),
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  context.read<MainBloc>().add(
                        AddProductToCartEvent(
                            noOfItemsOrdered: _noOfTimesOrdered.toDouble(),
                            product: widget.product,
                            note: _noteController.text),
                      );
                  Navigator.pop(context);
                },
                child: const Text('Add')),
          ],
        ),
      ),
    );
  }
}
