// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: json['categoryId'] as int,
      categoryName: json['categoryName'] as String,
      noOfTimesOrdered: json['noOfTimesOrdered'] as int,
      subCategories: (json['subCategories'] as List<dynamic>)
          .map((e) => SubCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'noOfTimesOrdered': instance.noOfTimesOrdered,
      'subCategories': instance.subCategories.map((e) => e.toJson()).toList(),
    };
