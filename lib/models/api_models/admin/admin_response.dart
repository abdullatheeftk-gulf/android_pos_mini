

import 'package:json_annotation/json_annotation.dart';

part 'admin_response.g.dart';

@JsonSerializable()
class AdminResponse{

  final String token;

  AdminResponse({required this.token});

  factory AdminResponse.fromJson(Map<String,dynamic> json) => _$AdminResponseFromJson(json);

  Map<String,dynamic> toJson() => _$AdminResponseToJson(this);


}