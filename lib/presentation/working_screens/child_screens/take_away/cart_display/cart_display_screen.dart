import 'package:android_pos_mini/models/api_models/cart/cart_product_item.dart';
//import 'package:android_pos_mini/presentation/working_screens/print_preview_screen/print_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/main/main_bloc.dart';
import '../../../../../models/api_models/cart/cart.dart';

class CartDisplayScreen extends StatefulWidget {
  const CartDisplayScreen({super.key});

  @override
  State<CartDisplayScreen> createState() => _CartDisplayScreenState();
}

class _CartDisplayScreenState extends State<CartDisplayScreen> {
  @override
  void initState() {
    context.read<MainBloc>().add(ShowCartProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool showProgressBar = false;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        /*if (state.runtimeType ==
            NavigateFromTheCartDisplayScreenToPrintPreviewScreen) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PrintPreviewScreen()));
        }*/
        if (state.runtimeType == ShowGenerateInvoiceErrorAsSnackBarState) {
          final message = (state as ShowGenerateInvoiceErrorAsSnackBarState).message;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
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
        if (cur is UiBuildState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (state.runtimeType == ApiFetchingStartedState) {
          showProgressBar = true;
        }
        switch (state.runtimeType) {
          case ApiFetchingStartedState:
            {
              showProgressBar = true;
              break;
            }
          case ApiFetchingFailedState:
            {
              showProgressBar = false;
              break;
            }
          case GenerateInvoiceSuccessState:
            {
              showProgressBar = false;
              break;
            }
          default:
            {
              showProgressBar = false;
            }
        }
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              showProgressBar
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
              const CartDisplayScreenList()
            ],
          ),
        );
      },
    );
  }
}

class CartDisplayScreenList extends StatelessWidget {
  const CartDisplayScreenList({super.key});

  void _showSubmitAlertDialog(List<CartProductItem> cartProductItems,
      double total, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SubmitButtonAlertDialog(
          cartProductItems: cartProductItems,
          total: total,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartProductItem> cartProductItems = [];
    double total = 0;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: BlocBuilder<MainBloc, MainState>(
          buildWhen: (prev, cur) {
            if (cur.runtimeType == ShowProductsAreAddedToCartState) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state.runtimeType == ShowProductsAreAddedToCartState) {
              cartProductItems =
                  (state as ShowProductsAreAddedToCartState).cartProductItems;
              total = state.total;
            }
            if (cartProductItems.isNotEmpty) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              color: Colors.blue),
                          child: const Center(
                            child: Text(
                              '#',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              color: Colors.blue),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Text(
                              'Item',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              color: Colors.blue),
                          child: const Center(
                            child: Text(
                              'Qty',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              color: Colors.blue),
                          child: const Center(
                            child: Text(
                              'Price',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              color: Colors.blue),
                          child: const Center(
                            child: Text(
                              'Amnt',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                              color: Colors.blue),
                          child: const Center(
                            child: Text(''),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: CartData(
                    cartProductItems: cartProductItems,
                    total: total,
                  )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showSubmitAlertDialog(
                                cartProductItems, total, context);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0, padding: EdgeInsets.all(8)),
                          child: const Text(
                            'Generate Invoice',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}

class CartData extends StatelessWidget {
  final List<CartProductItem> cartProductItems;
  final double total;

  const CartData(
      {super.key, required this.cartProductItems, required this.total});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == cartProductItems.length) {
          return Row(
            children: [
              const Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(''),
                  ),
                ),
              ),
              const Expanded(
                flex: 13,
                child: Text(
                  'Total',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    '$total',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(''),
              ),
            ],
          );
        }
        final productPrice =
            cartProductItems[index].product?.productPrice ?? 0.0;
        final qty = cartProductItems[index].noOfItemsOrdered;
        final amount = productPrice * qty;
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(
                  child: Text('${index + 1}'),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                alignment: Alignment.centerLeft,
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          cartProductItems[index].cartProductName,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      if (cartProductItems[index].cartProductLocalName != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            cartProductItems[index].cartProductLocalName!,
                            textAlign: TextAlign.end,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(
                  child: QtyTextForField(
                    value: cartProductItems[index].noOfItemsOrdered.toInt(),
                    callBackFunc: (value) {
                      final nQty = double.parse(value);
                      context.read<MainBloc>().add(
                          ReArrangeCartProductItemsQtyEvent(
                              index: index, qty: nQty));
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(
                  child:
                      Text('${cartProductItems[index].product?.productPrice}'),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(
                  child: Text('$amount'),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black12)),
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      context
                          .read<MainBloc>()
                          .add(DeleteCartProductItemEvent(index: index));
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      itemCount: cartProductItems.length + 1,
    );
  }
}

class QtyTextForField extends StatefulWidget {
  final int value;
  final Function callBackFunc;

  const QtyTextForField(
      {super.key, required this.value, required this.callBackFunc});

  @override
  State<QtyTextForField> createState() => _QtyTextForFieldState();
}

class _QtyTextForFieldState extends State<QtyTextForField> {
  late String _qtyString;
  final _qtyController = TextEditingController();

  @override
  void initState() {
    _qtyString = widget.value.toString();
    _qtyController.text = _qtyString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _qtyController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      maxLines: 1,
      decoration: const InputDecoration.collapsed(hintText: ''),
      onChanged: (value) {
        try {
          final result = int.tryParse(value);
          if (result != null) {
            widget.callBackFunc(value);
          }
        } catch (e) {
          e.runtimeType;
        }
      },
      onFieldSubmitted: (value) {
        widget.callBackFunc(value);
      },
    );
  }
}

class SubmitButtonAlertDialog extends StatefulWidget {
  final List<CartProductItem> cartProductItems;
  final double total;

  const SubmitButtonAlertDialog(
      {super.key, required this.cartProductItems, required this.total});

  @override
  State<SubmitButtonAlertDialog> createState() =>
      _SubmitButtonAlertDialogState();
}

class _SubmitButtonAlertDialogState extends State<SubmitButtonAlertDialog> {
  final _infoController = TextEditingController();
  final _customerNameController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Generate Invoice'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _customerNameController,
            decoration: const InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Enter Customer name ',
                hintStyle: TextStyle(color: Colors.black12),
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _infoController,
            decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Enter Note about Invoice ',
                hintStyle: TextStyle(color: Colors.black12),
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {
                final cart = Cart(
                  invoiceNo: 0,
                  total: widget.total,
                  totalTaxAmount: 0.0,
                  net: widget.total,
                  customerName: _customerNameController.text,
                  info: _infoController.text,
                  cartProductItems: widget.cartProductItems,
                  userId: null,
                  adminUserId: null,
                );
                context.read<MainBloc>().add(GenerateInvoiceEvent(cart: cart));
                Navigator.pop(context);
              },
              child: const Text('Submit'))
        ],
      ),
    );
  }
}
