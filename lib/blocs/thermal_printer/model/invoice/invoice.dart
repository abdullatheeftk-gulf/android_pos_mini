import 'package:json_annotation/json_annotation.dart';

import '../../../../models/api_models/cart/cart_product_item.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice{
  final String title;
  final List<CartProductItem> cartProductItems;
  final double total;
  final String invoiceNo;

  Invoice({required this.title, required this.cartProductItems, required this.total, required this.invoiceNo});

  Map<String,dynamic> toJson() => _$InvoiceToJson(this);
}