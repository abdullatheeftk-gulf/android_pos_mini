import 'dart:async';
import 'dart:io';

import 'package:android_pos_mini/general_functions/pair.dart';
import 'package:android_pos_mini/models/api_models/cart/cart.dart';
import 'package:android_pos_mini/models/api_models/cart/cart_product_item.dart';
import 'package:android_pos_mini/models/api_models/categories/category.dart';
import 'package:android_pos_mini/repositories/main_repository.dart';
import 'package:android_pos_mini/repositories/thermal_printer_repository.dart';
import 'package:android_pos_mini/util/product_view.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';


import '../../models/api_models/error/general_error.dart';
import '../../models/api_models/product/product.dart';


part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final Dio dio;
  final PrinterManager printerManager;
  late MainRepository _mainRepository;
  final MethodChannel methodChannel;
  late ThermalPrinterRepository _thermalPrinterRepository;
  final List<Pair<int, String>> _listOfCategory = List.empty(growable: true);
  final List<CartProductItem> cartProductItems = List.empty(growable: true);
  double total = 0.0;
  String _invoiceNo = '';

  // Thermal Printer
  bool _isThermalPrinterConnected = false;
  USBStatus usbStatus = USBStatus.none;

  // Text 2 image conversion
  List<Uint8List> listOfTextImages = [];

  MainBloc(
      {required this.printerManager,
      required this.dio,
      required this.methodChannel})
      : super(MainInitial()) {
    _listOfCategory.add(Pair(first: -1, second: "Add New"));
    _mainRepository = MainRepository(dio);
    _thermalPrinterRepository =
        ThermalPrinterRepository(printerManager: printerManager);

    on<NavigationDrawerItemClickedEvent>(navigationDrawerItemClickedEvent);

    on<CategoryLoadingEvent>(categoryLoadingEvent);

    on<ProductForACategoryLoadingEvent>(productForACategoryLoadingEvent);

    on<SearchForProductByKeyEvent>(searchForProductByKeyEvent);

    on<ProductViewStyleSelectEvent>(productViewStyleSelectEvent);

    on<CategoriesSelectedForProductEvent>(categoriesSelectedForProductEvent);

    on<EmptyTheListOfCategoriesForProductEvent>(
        emptyTheListOfCategoriesForProductEvent);

    on<RemoveOneItemFromTheProductAddCategoryListEvent>(
        removeOneItemFromTheProductAddCategoryListEvent);

    on<AddAProductEvent>(addAProductEvent);

    on<TranslateTextEvent>(translateTextEvent);

    on<TransliterateTextEvent>(transliterateTextEvent);

    on<ShowSnackBarInAddProductScreenEvent>(
        showSnackBarInAddProductScreenEvent);

    on<ShowSnackBarInProductSearchScreenEvent>(
        showSnackBarInProductSearchScreenEvent);

    on<AddProductToCartEvent>(addProductToCartEvent);

    on<ShowCartProductsEvent>(showCartProductsEvent);

    //on<EmptyCartProductEvent>(emptyCartProductEvent);

    on<ShowLengthOfTheCartProductItemsEvent>(
        showLengthOfTheCartProductItemsEvent);

    on<ReArrangeCartProductItemsQtyEvent>(reArrangeCartProductItemsQtyEvent);

    on<DeleteCartProductItemEvent>(deleteCartProductItemEvent);

    on<GenerateInvoiceEvent>(generateInvoiceEvent);

    on<PrintPreviewInitEvent>(printPreviewInitEvent);

    on<ResetOrdersEvent>(resetOrdersEvent);

    // Thermal printer events
    on<ScanForAvailableThermalPrintersEvent>(
        scanForAvailableThermalPrintersEvent);
    on<GetUsbPrinterStatusEvent>(getUsbPrinterStatusEvent);
    on<NavigateFromMainScreenToThermalPrinterScreenEvent>(
        navigateFromMainScreenToThermalPrinterScreenEvent);
    on<ConnectToThermalPrinterEvent>(connectToThermalPrinterEvent);
    on<TestThermalPrintEvent>(testThermalPrintEvent);
    on<PrintInvoiceOnThermalPrinterEvent>(printInvoiceOnThermalPrinterEvent);
  }



  FutureOr<void> navigationDrawerItemClickedEvent(
      NavigationDrawerItemClickedEvent event, Emitter<MainState> emit) async {
    final String menuName = event.menuName;

    emit(NavigationDrawerItemClickedState(menuName: menuName));
  }

  FutureOr<void> categoryLoadingEvent(
      CategoryLoadingEvent event, Emitter<MainState> emit) async {
    try {
      // emit(ApiFetchingStartedState());
      final dynamic result = await _mainRepository.getCategoryList();

      if (result.runtimeType == List<Category>) {
        final categories = result as List<Category>;
        /*debugPrint('--------------');
        for (var element in categories) {
          debugPrint(element.categoryName);
        }*/
        emit(CategoryLoadingSuccessState(categories: categories));
      } else {
        final generalError = result as GeneralError;
        // debugPrint('${generalError.message},- ${generalError.code}');
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
        //emit(LoginScreenShowSnackbarMessageState(errorMessage: generalError.message ?? 'There have some problem'));
      }
    } catch (e) {
      //debugPrint(e.toString());
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> productForACategoryLoadingEvent(
      ProductForACategoryLoadingEvent event, Emitter<MainState> emit) async {
    try {
      emit(ApiFetchingStartedState());
      final int categoryId = event.categoryId;
      emit(CategoryClickedState(categoryId: categoryId));
      final dynamic result =
          await _mainRepository.getProductsForACategory(categoryId);

      if (result.runtimeType == List<Product>) {
        final products = result as List<Product>;

        emit(GetProductsForACategorySuccessState(products: products));
      } else {
        final generalError = result as GeneralError;
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
      }
    } catch (e) {
      //debugPrint(e.toString());
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> productViewStyleSelectEvent(
      ProductViewStyleSelectEvent event, Emitter<MainState> emit) async {
    final ProductView productView = event.productView;
    emit(ProductViewStyleSelectStyleState(productView: productView));
  }

  FutureOr<void> categoriesSelectedForProductEvent(
      CategoriesSelectedForProductEvent event, Emitter<MainState> emit) {
    final Category category = event.category;
    final bool isCategoryClicked = event.isCategoryChecked;

    if (isCategoryClicked) {
      // print("is category clicked");
      _listOfCategory
          .add(Pair(first: category.categoryId, second: category.categoryName));
    } else {
      //print("is category not clicked");
      final v = _listOfCategory.contains(
          Pair(first: category.categoryId, second: category.categoryName));
      // print(v);
      _listOfCategory
          .removeWhere((element) => element.first == category.categoryId);
    }
    emit(CategorySelectedForProductState(listOfCategory: _listOfCategory));
  }

  FutureOr<void> emptyTheListOfCategoriesForProductEvent(
      EmptyTheListOfCategoriesForProductEvent event, Emitter<MainState> emit) {
    _listOfCategory.clear();
  }

  FutureOr<void> removeOneItemFromTheProductAddCategoryListEvent(
      RemoveOneItemFromTheProductAddCategoryListEvent event,
      Emitter<MainState> emit) {
    final int categoryId = event.categoryId;

    print('----------------');
    for (var element in _listOfCategory) {
      print(element.toString());
    }
    _listOfCategory.removeWhere((element) => element.first == categoryId);
    emit(CategorySelectedForProductState(listOfCategory: _listOfCategory));
  }

  FutureOr<void> addAProductEvent(
      AddAProductEvent event, Emitter<MainState> emit) async {
    final Product product = event.product;
    final File? file = event.file;
    try {
      emit(ApiFetchingStartedState());
      final result = await MainRepository(dio).addAProduct(product, file);
      if (result.runtimeType == int) {
        if (result > 0) {
          //print('Success');
          // print(result);
          emit(AddProductSuccessState(productId: result));
        }
      } else {
        //print("error");
        final GeneralError generalError = result as GeneralError;
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
      }
    } catch (e) {
      //debugPrint(e.toString());
      //print('Error string ${e.toString()}');
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> translateTextEvent(
      TranslateTextEvent event, Emitter<MainState> emit) async {
    try {
      final value = event.value;
      final result = await _mainRepository.translate(value);
      if (result.runtimeType == String) {
        final value = result as String;
        emit(TranslateTextState(value: value));
      } else {
        final generalError = result as GeneralError;
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
      }
    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> transliterateTextEvent(
      TransliterateTextEvent event, Emitter<MainState> emit) async {
    try {
      final value = event.value;
      final result = await _mainRepository.transliterate(value);
      if (result.runtimeType == String) {
        final value = result as String;
        emit(TranslateTextState(value: value));
      } else {
        final generalError = result as GeneralError;
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
      }
    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> showSnackBarInAddProductScreenEvent(
      ShowSnackBarInAddProductScreenEvent event, Emitter<MainState> emit) {
    final String message = event.message;
    emit(ShowSnackBarInAddProductScreenState(message: message));
  }

  FutureOr<void> searchForProductByKeyEvent(
      SearchForProductByKeyEvent event, Emitter<MainState> emit) async {
    try {
      final String key = event.key;
      emit(ApiFetchingStartedState());
      final result = await _mainRepository.searchAProduct(key);
      if (result.runtimeType == List<Product>) {
        final products = result as List<Product>;

        if (products.isEmpty) {
          emit(ShowSnackBarInProductSearchScreenState(message: 'No products'));
        }

        emit(SearchProductByKeySuccessState(products: products));
      } else {
        final generalError = result as GeneralError;
        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));
        emit(ShowSnackBarInProductSearchScreenState(
            message: generalError.message ?? 'There have some problem'));
      }
    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
      emit(ShowSnackBarInProductSearchScreenState(message: e.toString()));
    }
  }

  FutureOr<void> showSnackBarInProductSearchScreenEvent(
      ShowSnackBarInProductSearchScreenEvent event, Emitter<MainState> emit) {
    final message = event.message;
    emit(ShowSnackBarInProductSearchScreenState(message: message));
  }

  FutureOr<void> addProductToCartEvent(
      AddProductToCartEvent event, Emitter<MainState> emit) {
    final Product product = event.product;
    final note = event.note;
    final noOfItemsOrdered = event.noOfItemsOrdered;

    final CartProductItem cartProductItem = CartProductItem(
      noOfItemsOrdered: noOfItemsOrdered,
      note: note,
      cartProductName: product.productName,
      cartProductLocalName: product.productLocalName,
      product: product,
    );

    cartProductItems.add(cartProductItem);
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));
  }

  FutureOr<void> showCartProductsEvent(
      ShowCartProductsEvent event, Emitter<MainState> emit) {
    total = 0.0;
    for (var element in cartProductItems) {
      final quantity = element.noOfItemsOrdered;
      final price = element.product?.productPrice ?? 0.0;
      total += quantity * price;
    }
    emit(ShowProductsAreAddedToCartState(
        cartProductItems: cartProductItems, total: total));
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));
    emit(
        ThermalPrinterConnectionState(isConnected: _isThermalPrinterConnected));
  }

  FutureOr<void> showLengthOfTheCartProductItemsEvent(
      ShowLengthOfTheCartProductItemsEvent event, Emitter<MainState> emit) {
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));
  }

  FutureOr<void> reArrangeCartProductItemsQtyEvent(
      ReArrangeCartProductItemsQtyEvent event, Emitter<MainState> emit) {
    final int index = event.index;
    final double qty = event.qty;
    total = 0.0;

    var i = 0;
    cartProductItems.indexWhere((element) {
      if (index == i) {
        element.noOfItemsOrdered = qty;
        i++;
        return true;
      } else {
        i++;
        return false;
      }
    });
    for (var element in cartProductItems) {
      final quantity = element.noOfItemsOrdered;
      final price = element.product?.productPrice ?? 0.0;
      total += quantity * price;
    }
    emit(ShowProductsAreAddedToCartState(
        cartProductItems: cartProductItems, total: total));
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));
  }

  FutureOr<void> deleteCartProductItemEvent(
      DeleteCartProductItemEvent event, Emitter<MainState> emit) {
    final int index = event.index;
    total = 0.0;
    cartProductItems.removeAt(index);
    for (var element in cartProductItems) {
      final quantity = element.noOfItemsOrdered;
      final price = element.product?.productPrice ?? 0.0;
      total += quantity * price;
    }
    emit(ShowProductsAreAddedToCartState(
        cartProductItems: cartProductItems, total: total));
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));
  }

  FutureOr<void> generateInvoiceEvent(
      GenerateInvoiceEvent event, Emitter<MainState> emit) async {
    try {
      emit(ApiFetchingStartedState());

      final Cart cart = event.cart;

      final result = await _mainRepository.generateInvoice(cart);

      if (result.runtimeType == String) {
        final invoiceNo = result as String;

        _invoiceNo = invoiceNo;

        final cartProductItems = cart.cartProductItems;

        final isConverted = await convertTextToImage(cartProductItems);
        // Todo

        emit(GenerateInvoiceSuccessState(invoiceNo: invoiceNo));

        emit(NavigateFromTheCartDisplayScreenToPrintPreviewScreenState(
          cartProductItems: cartProductItems,
          total: total,
          invoiceNo: _invoiceNo,
        ));

        if (isConverted) {
          emit(SuccessSnackBarPrintInvoiceOnThermalPrinterState(
              isThermalPrintSuccess: "converted : ${listOfTextImages.length}"));
        } else {
          emit(SuccessSnackBarPrintInvoiceOnThermalPrinterState(
              isThermalPrintSuccess: "failed: ${listOfTextImages.length}"));
        }
      } else {
        final generalError = result as GeneralError;

        emit(ApiFetchingFailedState(
            errorString: generalError.message, errorCode: generalError.code));

        emit(ShowGenerateInvoiceErrorAsSnackBarState(
            message: generalError.message ??
                "There have some error while generating invoice"));
      }
    } catch (e) {
      emit(ApiFetchingFailedState(errorString: e.toString(), errorCode: 700));
    }
  }

  FutureOr<void> printPreviewInitEvent(
      PrintPreviewInitEvent event, Emitter<MainState> emit) {
    emit(PrintPreviewInitState(
      invoiceNo: _invoiceNo,
      total: total,
      cartProductItems: cartProductItems,
    ));
  }

  FutureOr<void> resetOrdersEvent(
      ResetOrdersEvent event, Emitter<MainState> emit) {
    total = 0.0;
    cartProductItems.clear();
    _invoiceNo = "";
    emit(ShowProductsAreAddedToCartState(
        cartProductItems: cartProductItems, total: total));
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));
  }

  // thermal printer
  FutureOr<void> scanForAvailableThermalPrintersEvent(
      ScanForAvailableThermalPrintersEvent event,
      Emitter<MainState> emit) async {
    final printDevices = _thermalPrinterRepository.scanForAvailablePrinters();
    emit(ThermalPrinterAvailablePrinterState(devices: printDevices));
  }

  FutureOr<void> getUsbPrinterStatusEvent(
      GetUsbPrinterStatusEvent event, Emitter<MainState> emit) {
    usbStatus = _thermalPrinterRepository.getUsbStatus();
    if (usbStatus == USBStatus.none) {
      _isThermalPrinterConnected = false;
    } else if (usbStatus == USBStatus.connected) {
      _isThermalPrinterConnected = true;
    } else {
      _isThermalPrinterConnected = false;
    }
    emit(ThermalPrinterUsbConnectionState(usbStatus: usbStatus));
  }

  FutureOr<void> navigateFromMainScreenToThermalPrinterScreenEvent(
      NavigateFromMainScreenToThermalPrinterScreenEvent event,
      Emitter<MainState> emit) {
    emit(NavigateFromMainScreenToThermalPrinterScreenState());
  }

  FutureOr<void> connectToThermalPrinterEvent(
      ConnectToThermalPrinterEvent event, Emitter<MainState> emit) async {
    final device = event.device;
    _isThermalPrinterConnected = false;
    if (!_isThermalPrinterConnected) {
      final myPrintDevice =
          await _thermalPrinterRepository.selectDevice(device);
      final result =
          await _thermalPrinterRepository.connectDevice(myPrintDevice);
      if (result == "Connected") {
        _isThermalPrinterConnected = true;
        emit(ThermalPrinterConnectionState(
            isConnected: _isThermalPrinterConnected));
      } else {
        _isThermalPrinterConnected = false;
      }
      emit(ThermalPrintConnectionStatus(connectionStatus: result));
    } else {
      emit(ThermalPrintConnectionStatus(
          connectionStatus: "Thermal printer already connected"));
    }
  }

  FutureOr<void> testThermalPrintEvent(
      TestThermalPrintEvent event, Emitter<MainState> emit) async {
    _thermalPrinterRepository.testPrint();
  }

  FutureOr<void> printInvoiceOnThermalPrinterEvent(
      PrintInvoiceOnThermalPrinterEvent event, Emitter<MainState> emit) async {
    final cartProductItems = event.cartProductItems;
    final net = event.total;
    final invoiceNo = event.invoiceNo;
    /*final isConverted = await convertTextToImage(cartProductItems);
    if(!isConverted){
      emit(SuccessSnackBarPrintInvoiceOnThermalPrinterState(
          isThermalPrintSuccess: "There have some problem on converting image"));
    }else {*/
    emit(SuccessSnackBarPrintInvoiceOnThermalPrinterState(
        isThermalPrintSuccess:
            "length of the image list = ${listOfTextImages.length} ${cartProductItems.length}"));
    final result = await _thermalPrinterRepository.printInvoice(
      title: "Unipospro",
      cartProductItems: cartProductItems,
      total: net,
      invoiceNo: invoiceNo,
      paperSize: PaperSize.mm58,
      listOfTextImages: listOfTextImages,
    );
    emit(SuccessSnackBarPrintInvoiceOnThermalPrinterState(
        isThermalPrintSuccess: result));

    /*total = 0.0;
    cartProductItems.clear();
    _invoiceNo = "";
    emit(ShowProductsAreAddedToCartState(
        cartProductItems: cartProductItems, total: total));
    emit(ShowLengthOfTheProductsAreAddedToCartState(
        length: cartProductItems.length));*/

    // }
  }

  Future<bool> convertTextToImage(
      List<CartProductItem> cartProductItems) async {
    listOfTextImages.clear();

    try {
      for (final cartProductItem in cartProductItems) {
        final productLocalName = cartProductItem.cartProductLocalName;

        final Uint8List productLocalNameImage = await methodChannel
            .invokeMethod("convertTextToImage", {"text": productLocalName});

        listOfTextImages.add(productLocalNameImage);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
