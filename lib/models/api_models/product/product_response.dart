
import 'package:android_pos_mini/models/api_models/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductResponse{
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String,dynamic> json) =>_$ProductResponseFromJson(json);

  Map<String,dynamic> toJson() =>_$ProductResponseToJson(this);
}