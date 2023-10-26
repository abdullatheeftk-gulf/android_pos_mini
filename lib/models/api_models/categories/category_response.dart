
import 'package:android_pos_mini/models/api_models/categories/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_response.g.dart';
@JsonSerializable(explicitToJson: true)
class CategoryResponse{
  final List<Category> result;

  CategoryResponse({required this.result});

  factory CategoryResponse.fromJson(Map<String,dynamic> json) => _$CategoryResponseFromJson(json);
}