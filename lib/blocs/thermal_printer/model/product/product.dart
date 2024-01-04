import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product{
  final String name;
  final String? localName;
  final double qty;
  final double price;

  Product({required this.name, required this.localName, required this.qty, required this.price});

  factory Product.fromJson(Map<String,dynamic> json) => _$ProductFromJson(json);

  Map<String,dynamic> toJson() => _$ProductToJson(this);


}