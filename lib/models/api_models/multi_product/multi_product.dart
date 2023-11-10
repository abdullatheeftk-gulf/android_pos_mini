
import 'package:json_annotation/json_annotation.dart';

part 'multi_product.g.dart';

@JsonSerializable()
class MultiProduct{
  final int multiProductId;
  final int parentProductId;
  final String multiProductName;
  final String? multiProductImage;
  final String? multiProductLocalName;
  final String info;

  MultiProduct({required this.multiProductId, required this.parentProductId, required this.multiProductName,required this.multiProductLocalName, required this.multiProductImage, required this.info});

  factory MultiProduct.fromJson(Map<String,dynamic> json) => _$MultiProductFromJson(json);

  Map<String,dynamic> toJson() => _$MultiProductToJson(this);
}