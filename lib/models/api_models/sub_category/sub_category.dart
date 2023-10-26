
import 'package:json_annotation/json_annotation.dart';

part 'sub_category.g.dart';

@JsonSerializable()
class SubCategory{
  final int subCategoryId;
  final int categoryId;
  final String subCategoryName;
  final int noOfTimesOrdered;

  SubCategory({required this.subCategoryId, required this.categoryId, required this.subCategoryName, required this.noOfTimesOrdered});

  factory SubCategory.fromJson(Map<String,dynamic> json) => _$SubCategoryFromJson(json);

  Map<String,dynamic> toJson() => _$SubCategoryToJson(this);
}