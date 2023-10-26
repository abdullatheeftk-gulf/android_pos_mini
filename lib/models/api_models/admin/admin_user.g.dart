// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => AdminUser(
      adminName: json['adminName'] as String,
      adminPassword: json['adminPassword'] as String,
      licenseKey: json['licenseKey'] as String,
      isLicenceKeyVerified: json['isLicenceKeyVerified'] as bool,
    )..id = json['adminId'] as int? ?? 0;

Map<String, dynamic> _$AdminUserToJson(AdminUser instance) => <String, dynamic>{
      'adminId': instance.id,
      'adminName': instance.adminName,
      'adminPassword': instance.adminPassword,
      'licenseKey': instance.licenseKey,
      'isLicenceKeyVerified': instance.isLicenceKeyVerified,
    };
