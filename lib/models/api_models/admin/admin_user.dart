import 'package:json_annotation/json_annotation.dart';

part 'admin_user.g.dart';

@JsonSerializable()
class AdminUser{

  @JsonKey(defaultValue: 0,name: "adminId")
  int id = 0;

  String adminName;

  String adminPassword;

  String licenseKey;

  bool isLicenceKeyVerified;

  AdminUser({required this.adminName, required this.adminPassword, required  this.licenseKey, required this.isLicenceKeyVerified});

  factory AdminUser.fromJson(Map<String,dynamic> json) => _$AdminUserFromJson(json);

  Map<String, dynamic> toJson() => _$AdminUserToJson(this);

}