// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiProduct _$MultiProductFromJson(Map<String, dynamic> json) => MultiProduct(
      multiProductId: json['multiProductId'] as int,
      parentProductId: json['parentProductId'] as int,
      multiProductName: json['multiProductName'] as String,
      multiProductImage: json['multiProductImage'] as String?,
      noOfTimesOrdered: json['noOfTimesOrdered'] as int,
      info: json['info'] as String,
    );

Map<String, dynamic> _$MultiProductToJson(MultiProduct instance) =>
    <String, dynamic>{
      'multiProductId': instance.multiProductId,
      'parentProductId': instance.parentProductId,
      'multiProductName': instance.multiProductName,
      'multiProductImage': instance.multiProductImage,
      'noOfTimesOrdered': instance.noOfTimesOrdered,
      'info': instance.info,
    };
