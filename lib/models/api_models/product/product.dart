
import 'package:json_annotation/json_annotation.dart';

import '../multi_product/multi_product.dart';
part 'product.g.dart';

@JsonSerializable(explicitToJson: true)
class Product{
  final int productId;
  final String productName;
  final double productPrice;
  final double productTaxInPercentage;
  final String? productImage;
  final int noOfTimesOrdered;
  final String? info;
  final int? subCategoryId;
  final List<MultiProduct> multiProducts;
  final List<int> categories;

  Product({required this.productId, required this.productName, required this.productPrice, required this.productTaxInPercentage, required this.productImage, required this.noOfTimesOrdered, required this.info, required this.subCategoryId, required this.multiProducts, required this.categories});


  factory Product.fromJson(Map<String,dynamic> json) =>_$ProductFromJson(json);

  Map<String,dynamic> toJson() => _$ProductToJson(this);


}