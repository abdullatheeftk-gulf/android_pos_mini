import 'package:json_annotation/json_annotation.dart';

import '../sub_category/sub_category.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category{
  final int categoryId;
  final String categoryName;
  final int noOfTimesOrdered;
  final List<SubCategory> subCategories;

  Category({required this.categoryId, required this.categoryName, required this.noOfTimesOrdered, required this.subCategories});

  factory Category.fromJson(Map<String,dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);


}