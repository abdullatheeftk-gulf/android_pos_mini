// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiProduct _$MultiProductFromJson(Map<String, dynamic> json) => MultiProduct(
      multiProductId: json['multiProductId'] as int,
      parentProductId: json['parentProductId'] as int,
      multiProductName: json['multiProductName'] as String,
      multiProductLocalName: json['multiProductLocalName'] as String?,
      multiProductImage: json['multiProductImage'] as String?,
      info: json['info'] as String,
    );

Map<String, dynamic> _$MultiProductToJson(MultiProduct instance) =>
    <String, dynamic>{
      'multiProductId': instance.multiProductId,
      'parentProductId': instance.parentProductId,
      'multiProductName': instance.multiProductName,
      'multiProductImage': instance.multiProductImage,
      'multiProductLocalName': instance.multiProductLocalName,
      'info': instance.info,
    };
