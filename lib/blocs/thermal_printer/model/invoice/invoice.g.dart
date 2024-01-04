// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      title: json['title'] as String,
      cartProductItems: (json['cartProductItems'] as List<dynamic>)
          .map((e) => CartProductItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      invoiceNo: json['invoiceNo'] as String,
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'title': instance.title,
      'cartProductItems': instance.cartProductItems,
      'total': instance.total,
      'invoiceNo': instance.invoiceNo,
    };
