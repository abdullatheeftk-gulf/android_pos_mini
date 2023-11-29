// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      invoiceNo: json['invoiceNo'] as int,
      total: (json['total'] as num).toDouble(),
      totalTaxAmount: (json['totalTaxAmount'] as num).toDouble(),
      net: (json['net'] as num).toDouble(),
      customerName: json['customerName'] as String?,
      info: json['info'] as String?,
      cartProductItems: (json['cartProductItems'] as List<dynamic>)
          .map((e) => CartProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as int?,
      adminUserId: json['adminUserId'] as int?,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'invoiceNo': instance.invoiceNo,
      'total': instance.total,
      'totalTaxAmount': instance.totalTaxAmount,
      'net': instance.net,
      'customerName': instance.customerName,
      'info': instance.info,
      'cartProductItems':
          instance.cartProductItems.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
      'adminUserId': instance.adminUserId,
    };
