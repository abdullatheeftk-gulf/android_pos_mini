import 'dart:typed_data';

import 'package:android_pos_mini/presentation/working_screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../blocs/main/main_bloc.dart';
import '../models/api_models/cart/cart_product_item.dart';

class MyPrintPreview extends StatelessWidget {
  final String title;
  final List<CartProductItem> cartProductItems;
  final double total;
  final String invoiceNo;

  const MyPrintPreview({
    super.key,
    required this.title,
    required this.cartProductItems,
    required this.total,
    required this.invoiceNo,
  });

  @override
  Widget build(BuildContext context) {
    /*context
        .read<MainBloc>()
        .add(ResetOrdersEvent());*/
    Future<Uint8List> generatePdf(
      PdfPageFormat format, {
      required String title,
      required List<CartProductItem> cartProductItems,
      required double total,
      required String invoiceNo,
    }) async {

      final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
      final font = await PdfGoogleFonts.nunitoExtraLight();
      final arabicFont = await PdfGoogleFonts.notoSansArabicLight();

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) {
            return pw.Column(
              children: [
                pw.FittedBox(
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 18,
                      font: font,
                      fontWeight: pw.FontWeight.bold,
                      decoration: pw.TextDecoration.underline,
                    ),
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                    "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
                    maxLines: 1),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('Invoice No:- '),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      invoiceNo,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                    "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
                    maxLines: 1),
                pw.Row(
                  children: [
                    pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          '#',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            decoration: pw.TextDecoration.underline,
                          ),
                        )),
                    pw.Expanded(
                        flex: 6,
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            decoration: pw.TextDecoration.underline,
                          ),
                        )),
                    pw.Expanded(
                        flex: 3,
                        child: pw.Text(
                          'qty',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            decoration: pw.TextDecoration.underline,
                          ),
                        )),
                    pw.Expanded(
                        flex: 4,
                        child: pw.Text(
                          'Price',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            decoration: pw.TextDecoration.underline,
                          ),
                        )),
                    pw.Expanded(
                        flex: 4,
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            decoration: pw.TextDecoration.underline,
                          ),
                        )),
                  ],
                ),
                pw.Expanded(
                    child: pw.ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == cartProductItems.length) {
                      return pw.Column(
                        children: [
                          pw.Text(
                              "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
                              maxLines: 1),
                          pw.Row(
                            children: [
                              pw.Expanded(flex: 2, child: pw.Text('')),
                              pw.Expanded(flex: 4, child: pw.Text('')),
                              pw.Expanded(
                                flex: 9,
                                child: pw.Text(
                                  'Total',
                                  style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                  flex: 4,
                                  child: pw.Text(
                                    '$total',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      );
                    }
                    final qty = cartProductItems[index].noOfItemsOrdered;
                    final price =
                        cartProductItems[index].product?.productPrice ?? 0;
                    final t = qty * price;
                    return pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text('${index + 1}',
                                style: pw.TextStyle(
                                  fontSize: 8,
                                  font: font,
                                ))),
                        pw.Expanded(
                          flex: 6,
                          child: pw.Column(
                            mainAxisSize: pw.MainAxisSize.min,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Align(
                                alignment: pw.Alignment.topLeft,
                                child: pw.Text(
                                  cartProductItems[index].cartProductName,
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    font: font,
                                  ),
                                ),
                              ),
                              if (cartProductItems[index]
                                      .cartProductLocalName !=
                                  null)
                                pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                    cartProductItems[index]
                                            .product
                                            ?.productLocalName ??
                                        "",
                                    textDirection: pw.TextDirection.rtl,
                                    style: pw.TextStyle(
                                        fontSize: 8, font: arabicFont),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            '$qty',
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: font,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 4,
                          child: pw.Text(
                            '$price',
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: font,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 4,
                          child: pw.Text(
                            '$t',
                            style: pw.TextStyle(
                              fontSize: 8,
                              font: font,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: cartProductItems.length + 1,
                ))
              ],
            );
          },
        ),
      );

      return pdf.save();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Preview'),
      ),
      body: PdfPreview(
          padding: const EdgeInsets.all(2),
          onPrinted: (context) {
            context.read<MainBloc>().add(ResetOrdersEvent());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(userName: '')),
                (route) => false);
          },
          build: (format) => generatePdf(format,
              title: title,
              cartProductItems: cartProductItems,
              total: total,
              invoiceNo: invoiceNo)),
    );
  }
}
