import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_pos_mini/models/api_models/cart/cart_product_item.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

import 'package:image/image.dart' as Img;
import 'package:intl/intl.dart';

class ThermalPrinterRepository {
  PrinterType defaultPrinterType = PrinterType.usb;

  /*StreamSubscription<PrinterDevice>? _subscription;
  StreamSubscription<USBStatus>? _subscriptionUsbStatus;*/
  USBStatus _currentUsbStatus = USBStatus.none;

  final List<MyPrintDevice> _devices = [];
  MyPrintDevice? selectedPrinter;

  List<int>? pendingTask;

  final PrinterManager printerManager;

  ThermalPrinterRepository({required this.printerManager});

  bool _isConnected = false;

  // Get usb status
  USBStatus getUsbStatus() {
    PrinterManager.instance.stateUSB.listen(
          (status) {
        _currentUsbStatus = status;
        if (Platform.isAndroid) {
          if (status == USBStatus.connected && pendingTask != null) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              PrinterManager.instance
                  .send(type: PrinterType.usb, bytes: pendingTask!);
              pendingTask = null;
            });
          }
        }
      },
    );
    return _currentUsbStatus;
  }

  // Scan for available devices
  List<MyPrintDevice> scanForAvailablePrinters() {
    _devices.clear();

    printerManager.discovery(type: defaultPrinterType).listen(
          (device) {
        final MyPrintDevice myPrintDevice = MyPrintDevice(
          deviceName: device.name,
          address: device.address,
          vendorId: device.vendorId,
          productId: device.productId,
          typePrinter: defaultPrinterType,
        );
        _devices.add(myPrintDevice);
      },
    );

    return _devices;
  }

  // Select Printer device
  Future<MyPrintDevice> selectDevice(MyPrintDevice device) async {
    if (selectedPrinter != null) {
      if ((device.address != selectedPrinter!.address) ||
          (device.typePrinter == PrinterType.usb &&
              selectedPrinter!.vendorId != device.vendorId)) {
        await PrinterManager.instance
            .disconnect(type: selectedPrinter!.typePrinter);
      }
    }

    selectedPrinter = device;

    return selectedPrinter!;
  }

  // connect device
  Future<String> connectDevice(MyPrintDevice device) async {
    _isConnected = false;
    if (selectedPrinter == null) {
      return "Printer is not selected";
    }
    switch (device.typePrinter) {
      case PrinterType.usb:
        {
          try {
            if (!_isConnected) {
              final status = await printerManager.connect(
                type: selectedPrinter!.typePrinter,
                model: UsbPrinterInput(
                  name: selectedPrinter!.deviceName,
                  productId: selectedPrinter!.productId,
                  vendorId: selectedPrinter!.vendorId,
                ),
              );
              _isConnected = status;
              if (status) {
                return "Connected";
              } else {
                return "Not Connected";
              }
            } else {
              return "Usb printer Already connected";
            }
          } catch (e) {
            return "Error:- ${e.toString()}";
          }

          break;
        }
    /*case PrinterType.network:
        {
          try {
            if (_isConnected) {
              await printManager.connect(
                type: selectedPrinter!.typePrinter,
                model: TcpPrinterInput(
                  ipAddress: selectedPrinter!.address!,
                ),
              );
            } else {
              error += "Already connected";
            }
            _isConnected = true;
            setState(() {});
          } catch (e) {
            error += e.toString();
            setState(() {});
          }

          break;
        }*/
      default:
        {
          return "Default problem";
        }
    }
  }

  Future<String> testPrint() async {
    if (selectedPrinter == null) {
      const error = "No printer connected";
      return error;
    }

    try {
      List<int> bytes = [];
      final profile = await CapabilityProfile.load();

      final generator = Generator(PaperSize.mm58, profile);

      bytes += generator.text('Android pos mini');
      bytes += generator.qrcode("https://translate.google.com/");

      final printer = selectedPrinter!;

      switch (selectedPrinter!.typePrinter) {
        case PrinterType.usb:
          {
            bytes += generator.feed(0);
            bytes += generator.cut();
            await printerManager.connect(
              type: printer.typePrinter,
              model: UsbPrinterInput(
                name: printer.deviceName,
                productId: printer.productId,
                vendorId: printer.vendorId,
              ),
            );
            pendingTask = null;
            printerManager.send(type: printer.typePrinter, bytes: bytes);
            return "Printed";
            break;
          }
      /* case PrinterType.network:
          {
            bytes += generator.feed(0);
            bytes += generator.cut();
            await printerManager.connect(
                type: printer.typePrinter,
                model: TcpPrinterInput(ipAddress: printer.address!));
            break;
          }*/
        default:
          {
            return "No error";
          }
      }
    } catch (e) {
      final error = e.toString();
      return error;
    }
  }

  Future<String> printInvoice({
    required String title,
    required List<CartProductItem> cartProductItems,
    required double total,
    required String invoiceNo,
    required PaperSize paperSize,
    required List<Uint8List> listOfTextImages,
  }) async {
    if (cartProductItems.length != listOfTextImages.length) {
      return "Image conversion error";
    }

    if (selectedPrinter == null) {
      const error = "No printer connected";
      return error;
    }
    try {
      List<int> bytes = [];

      final profile = await CapabilityProfile.load();

      final generator = Generator(paperSize, profile);

      bytes += generator.text(
        title,
        linesAfter: 1,
        styles: const PosStyles(
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            align: PosAlign.center),
      );

      bytes += generator.text(
        "================================",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      bytes += generator.text(
        "Invoice No: $invoiceNo",
        styles: const PosStyles(align: PosAlign.center),
      );

      bytes += generator.text(
        "================================",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      // Cart Products row title
      bytes += generator.row([
        PosColumn(
          text: 'Qty',
          width: 3,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: 'Price',
          width: 4,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: 'Total',
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      bytes += generator.text(
        "---------------------------------",
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      );

      var i = 0;
      for (final cartProduct in cartProductItems) {
        final qty = cartProduct.noOfItemsOrdered;
        final price = cartProduct.product!.productPrice;

        final productTotal = qty * price;
        bytes += generator.text(
          "${i + 1}, ${cartProduct.cartProductName}",
          styles: const PosStyles(
            align: PosAlign.left,
            bold: true,
          ),
        );

        try {
          final convertedImage = listOfTextImages[i];
          final image = Img.decodeImage(convertedImage);
          if (image != null) {
            bytes += generator.image(image, align: PosAlign.right);
          }
        } catch (e) {
          e.toString();
        }

        bytes += generator.row([
          PosColumn(
            text: qty.toString(),
            width: 3,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: price.toString(),
            width: 4,
            styles: const PosStyles(align: PosAlign.center),
          ),
          PosColumn(
            text: productTotal.toString(),
            width: 5,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);

        bytes += generator.text(
          "---------------------------------",
          styles: const PosStyles(
            align: PosAlign.center,
          ),
        );

        i++;
      }

      bytes += generator.text(
        "Total:- $total",
        styles: const PosStyles(align: PosAlign.right, bold: true),
        linesAfter: 1,
      );

      bytes += generator.text("---------------------------------",
          styles: const PosStyles(
            align: PosAlign.center,
          ),
          linesAfter: 1,);
      bytes += generator.qrcode(
        "https://translate.google.com/",
        size: QRSize.Size6,
      );

      final dateTime = DateTime.now();
      final dateFormatter = DateFormat("dd/MM/yyy, h:mm a");
      final String date = dateFormatter.format(dateTime);
      bytes += generator.text("Date:-$date");

      //final dateFormat = DateFormat("dd/MM/yyyy, h:mm a");

      final printer = selectedPrinter!;

      switch (selectedPrinter!.typePrinter) {
        case PrinterType.usb:
          {
            bytes += generator.feed(0);
            bytes += generator.cut();
            await printerManager.connect(
              type: printer.typePrinter,
              model: UsbPrinterInput(
                name: printer.deviceName,
                productId: printer.productId,
                vendorId: printer.vendorId,
              ),
            );
            pendingTask = null;
            break;
          }

        case PrinterType.network:
          {
            bytes += generator.feed(0);
            bytes += generator.cut();
            await printerManager.connect(
                type: printer.typePrinter,
                model: TcpPrinterInput(ipAddress: printer.address!));
            break;
          }
        default:
          {}
      }

      printerManager.send(type: printer.typePrinter, bytes: bytes);
      return "Printed";
    } catch (e) {
      final error = e.toString();
      return error;
    }
  }
}

class MyPrintDevice {
  int? id;
  String? deviceName;
  String? address;
  String? port;
  String? vendorId;
  String? productId;
  bool? isBle;

  PrinterType typePrinter;
  bool? state;

  MyPrintDevice({
    this.deviceName,
    this.address,
    this.port,
    this.state,
    this.vendorId,
    this.productId,
    this.typePrinter = PrinterType.usb,
    this.isBle = false,
  });
}
