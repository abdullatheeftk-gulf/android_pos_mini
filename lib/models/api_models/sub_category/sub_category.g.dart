// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubCategory _$SubCategoryFromJson(Map<String, dynamic> json) => SubCategory(
      subCategoryId: json['subCategoryId'] as int,
      categoryId: json['categoryId'] as int,
      subCategoryName: json['subCategoryName'] as String,
      noOfTimesOrdered: json['noOfTimesOrdered'] as int,
    );

Map<String, dynamic> _$SubCategoryToJson(SubCategory instance) =>
    <String, dynamic>{
      'subCategoryId': instance.subCategoryId,
      'categoryId': instance.categoryId,
      'subCategoryName': instance.subCategoryName,
      'noOfTimesOrdered': instance.noOfTimesOrdered,
    };
