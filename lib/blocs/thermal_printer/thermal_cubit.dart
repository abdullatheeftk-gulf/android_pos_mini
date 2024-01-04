import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_pos_mini/blocs/thermal_printer/model/invoice/invoice.dart';
import 'package:android_pos_mini/models/api_models/cart/cart_product_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'model/product/product.dart';

part 'thermal_state.dart';

class ThermalCubit extends Cubit<ThermalState> {
  final MethodChannel methodChannel =
      const MethodChannel("XPrint_method_channel");
  final EventChannel xPrinterConnectEventChannel =
      const EventChannel("XPrint_event_channel");
  late Stream<dynamic> xPrinterConnectionStatusStream;

  late StreamSubscription xPrinterStreamSubscription;

  ThermalCubit() : super(ThermalInitial()) {
    if (Platform.isAndroid) {
      getUsbAddress();
    }
    xPrinterConnectionStatusStream =
        xPrinterConnectEventChannel.receiveBroadcastStream();

    xPrinterStreamSubscription = xPrinterConnectionStatusStream.listen((event) {
      if (event is String) {
        switch (event) {
          case "UsbAvailable":
            {
              getUsbAddress();
              break;
            }
          case "UsbDetached":
            {
              emit(GetUsbAddressState(
                  usbAddress: "No usb printers connected",
                  usbPrinterAvailable: false));
              break;
            }
          case "UsbConnected":
            {
              emit(ConnectedToUsbPrinterState(isConnected: true));
              break;
            }
          case "UsbDisconnected":
            {
              emit(ConnectedToUsbPrinterState(isConnected: false));
              break;
            }
          case "UsbPrintSuccess":
            {
              emit(PrintSuccessState());
              break;
            }
          case "UsbPrintFailed":
            {
              emit(PrintFailedState());
              break;
            }
          default:
            {}
        }
      }
    });
  }

  void getUsbAddress() async {
    final String usbName = await methodChannel.invokeMethod("getUsbAddress");
    if (usbName == "No usb printers connected") {
      emit(GetUsbAddressState(usbAddress: usbName, usbPrinterAvailable: false));
    } else {
      emit(GetUsbAddressState(usbAddress: usbName, usbPrinterAvailable: true));
    }
  }

  void connectUsbPrinter() async {
    final bool isConnected = await methodChannel.invokeMethod("usbConnect");
    emit(ConnectedToUsbPrinterState(isConnected: isConnected));
  }

  void doTestPrintInText() async {
    await methodChannel
        .invokeMethod("testTextPrint", {"textToPrint": "Assalamualikum"});
  }

  void doTestPrintArabicText(String s) async {
    await methodChannel.invokeMethod("testArabicTextPrint", {"textToPrint": s});
  }

  void doTestFullEscPosTicket() async {
    List<Product> products = [
      Product(
        name: "Porotta",
        localName: "بوروتا",
        qty: 1,
        price: 10.0,
      ),
      Product(
        name: "Chicken Biriyani",
        localName: "برياني دجاج",
        qty: 2,
        price: 110.0,
      ),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      /*
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),
      Product(name: "Porotta", localName: "بوروتا", qty: 1, price: 10.0),
      Product(
          name: "Chicken Biriyani",
          localName: "برياني دجاج",
          qty: 2,
          price: 110.0),
      Product(
          name: "Beef Biriyani",
          localName: "برياني لحم البقر",
          qty: 1,
          price: 140.0),
      Product(
          name: "Coco Cola bottle 400 ml ",
          localName: "زجاجة كوكو كولا ٤۰۰ مل",
          qty: 1,
          price: 50.0),
      Product(
          name: "One long-name product for sample- size is not defined ",
          localName: "لم يتم تعريف منتج واحد طويل الاسم لحجم العينة",
          qty: 1,
          price: 100.0),*/
    ];

    final serializedProductList =
        products.map((product) => jsonEncode(product.toJson())).toList();

    await methodChannel.invokeMethod(
        "printEscPosFullTicket", serializedProductList);
  }

  @override
  Future<void> close() {
    xPrinterStreamSubscription.cancel();
    return super.close();
  }

  void printInvoice({
    required String title,
    required List<CartProductItem> cartProductItems,
    required double total,
    required String invoiceNo,
  }) async{

    final invoice = Invoice(title: title, cartProductItems: cartProductItems, total: total, invoiceNo: invoiceNo);
    final serializedInvoice = jsonEncode(invoice.toJson());
    await methodChannel.invokeMethod("printInvoice",serializedInvoice);

  }
}
