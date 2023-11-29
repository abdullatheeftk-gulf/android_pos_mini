// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_product_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProductItem _$CartProductItemFromJson(Map<String, dynamic> json) =>
    CartProductItem(
      noOfItemsOrdered: (json['noOfItemsOrdered'] as num).toDouble(),
      note: json['note'] as String?,
      cartProductName: json['cartProductName'] as String,
      cartProductLocalName: json['cartProductLocalName'] as String?,
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartProductItemToJson(CartProductItem instance) =>
    <String, dynamic>{
      'noOfItemsOrdered': instance.noOfItemsOrdered,
      'note': instance.note,
      'cartProductName': instance.cartProductName,
      'cartProductLocalName': instance.cartProductLocalName,
      'product': instance.product?.toJson(),
    };
