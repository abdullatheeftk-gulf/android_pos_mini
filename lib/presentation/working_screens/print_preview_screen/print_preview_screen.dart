import 'package:android_pos_mini/models/api_models/cart/cart_product_item.dart';

// import 'package:android_pos_mini/repositories/my_print_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:printing/printing.dart';

import '../../../blocs/main/main_bloc.dart';
import '../main_screen.dart';

class PrintPreviewScreen extends StatefulWidget {
  const PrintPreviewScreen({super.key});

  @override
  State<PrintPreviewScreen> createState() => _PrintPreviewScreenState();
}

class _PrintPreviewScreenState extends State<PrintPreviewScreen> {
  @override
  void initState() {
    context.read<MainBloc>().add(PrintPreviewInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String invoiceNo = "";
    double total = 0.0;
    List<CartProductItem> cartProductItems = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Preview'),
        elevation: 6,
      ),
      body: BlocConsumer<MainBloc, MainState>(
        listener: (BuildContext context, MainState state) {
          final message =
              (state as SuccessSnackBarPrintInvoiceOnThermalPrinterState)
                  .isThermalPrintSuccess;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
          if (message == "Printed") {
            context.read<MainBloc>().add(ResetOrdersEvent());

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(userName: ''),
              ),
              (route) => false,
            );

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
          if (cur.runtimeType == PrintPreviewInitState) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case PrintPreviewInitState:
              {
                invoiceNo = (state as PrintPreviewInitState).invoiceNo;
                total = state.total;
                cartProductItems = state.cartProductItems;
                break;
              }
            default:
              {}
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.widthConstraints().maxWidth;
              // print(screenWidth);
              return Center(
                child: Container(
                  alignment: Alignment.center,
                  width: screenWidth > 600 ? 600 : screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Unipospro',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Invoice:- ',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              invoiceNo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                        const Text(
                          "==================================================================================================",
                          maxLines: 1,
                        ),
                        const Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  '#',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline),
                                )),
                            Expanded(
                                flex: 8,
                                child: Text(
                                  'Item',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline),
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  'qty',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline),
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline),
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  'Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        ),
                        Expanded(
                          child: ItemDisplay(
                            cartProductItems: cartProductItems,
                            total: total,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyPrintPreview(
                                          title: "Unipospro",
                                          cartProductItems: cartProductItems,
                                          total: total,
                                          invoiceNo: invoiceNo),
                                    ),
                                  );*/
                                  /*context
                                      .read<MainBloc>()
                                      .add(ResetOrdersEvent());*/

                                  context.read<MainBloc>().add(
                                        PrintInvoiceOnThermalPrinterEvent(
                                          cartProductItems: cartProductItems,
                                          total: total,
                                          invoiceNo: invoiceNo,
                                        ),
                                      );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Print'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

makeSomeDelay(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 1000));
}

class ItemDisplay extends StatelessWidget {
  final List<CartProductItem> cartProductItems;
  final double total;

  const ItemDisplay(
      {super.key, required this.cartProductItems, required this.total});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == cartProductItems.length) {
          return Column(
            children: [
              const Divider(),
              Row(
                children: [
                  const Expanded(flex: 2, child: Text('')),
                  const Expanded(flex: 8, child: Text('')),
                  const Expanded(
                      flex: 6,
                      child: Text('Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  Expanded(
                      flex: 3,
                      child: Text(
                        '$total',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          );
        }
        final qty = cartProductItems[index].noOfItemsOrdered;
        final price = cartProductItems[index].product?.productPrice ?? 0;
        final t = qty * price;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: Text('${index + 1}')),
            Expanded(
                flex: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartProductItems[index].cartProductName),
                    if (cartProductItems[index].cartProductLocalName != null)
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                              cartProductItems[index].cartProductLocalName ??
                                  ""))
                  ],
                )),
            Expanded(flex: 3, child: Text('$qty')),
            Expanded(flex: 3, child: Text('$price')),
            Expanded(flex: 3, child: Text('$t')),
          ],
        );
      },
      itemCount: cartProductItems.length + 1,
    );
  }
}
