
import 'package:json_annotation/json_annotation.dart';

import 'cart_product_item.dart';

part 'cart.g.dart';

@JsonSerializable(explicitToJson: true)
class Cart{

  final int invoiceNo;
  final double total;
  final double totalTaxAmount;
  final double net;
  final String? customerName;
  final String? info;
  final List<CartProductItem> cartProductItems;
  final int? userId;
  final int? adminUserId;

  Cart({required this.invoiceNo, required this.total, required this.totalTaxAmount, required this.net, required this.customerName, required this.info, required this.cartProductItems, required this.userId, required this.adminUserId});

  factory Cart.fromJson(Map<String,dynamic> json) =>_$CartFromJson(json);

  Map<String,dynamic> toJson() =>_$CartToJson(this);

}