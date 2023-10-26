// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      productPrice: (json['productPrice'] as num).toDouble(),
      productTaxInPercentage:
          (json['productTaxInPercentage'] as num).toDouble(),
      productImage: json['productImage'] as String?,
      noOfTimesOrdered: json['noOfTimesOrdered'] as int,
      info: json['info'] as String?,
      subCategoryId: json['subCategoryId'] as int?,
      multiProducts: (json['multiProducts'] as List<dynamic>)
          .map((e) => MultiProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories:
          (json['categories'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'productPrice': instance.productPrice,
      'productTaxInPercentage': instance.productTaxInPercentage,
      'productImage': instance.productImage,
      'noOfTimesOrdered': instance.noOfTimesOrdered,
      'info': instance.info,
      'subCategoryId': instance.subCategoryId,
      'multiProducts': instance.multiProducts.map((e) => e.toJson()).toList(),
      'categories': instance.categories,
    };
