
import 'package:json_annotation/json_annotation.dart';

import '../multi_product/multi_product.dart';
part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product{
  final int productId;
  final String productName;
  final String? productLocalName;
  final double productPrice;
  final double productTaxInPercentage;
  final String? productImage;
  final double noOfTimesOrdered;
  final String? info;
  final int? subCategoryId;
  final List<MultiProduct> multiProducts;
  final List<int> categories;

  Product({required this.productId, required this.productName, required this.productLocalName, required this.productPrice, required this.productTaxInPercentage, required this.productImage,  this.noOfTimesOrdered = 0, this.info,  this.subCategoryId,  required this.multiProducts , required this.categories});


  factory Product.fromJson(Map<String,dynamic> json) =>_$ProductFromJson(json);

  Map<String,dynamic> toJson() => _$ProductToJson(this);


}