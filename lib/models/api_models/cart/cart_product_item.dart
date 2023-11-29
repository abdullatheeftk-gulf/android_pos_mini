
import 'package:json_annotation/json_annotation.dart';

import '../product/product.dart';

part 'cart_product_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CartProductItem{
  double noOfItemsOrdered;
  final String? note;
  final String cartProductName;
  final String? cartProductLocalName;
  final Product? product;

  CartProductItem({required this.noOfItemsOrdered, required this.note, required this.cartProductName, required this.cartProductLocalName, required this.product});

  factory CartProductItem.fromJson(Map<String, dynamic> json) => _$CartProductItemFromJson(json);

  Map<String,dynamic> toJson() => _$CartProductItemToJson(this);
}