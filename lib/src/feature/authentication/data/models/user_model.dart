import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  String? nik;
  String? name;
  String? username;
  String? gender;
  String? birthDate;
  String? disability;
  String? fatherName;
  String? motherName;
  String? placeId;
  String? address;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;
  bool? isVerified;
  String? password;

  UserModel({
    this.nik,
    this.password,
    this.name,
    this.username,
    this.address,
    this.birthDate,
    this.disability,
    this.gender,
    this.isVerified,
    this.latitude,
    this.longitude,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.fatherName,
    this.motherName,
    this.placeId,
  });

  /// factory.
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static List<UserModel> fromJsonList(List? json) {
    return json?.map((e) => UserModel.fromJson(e)).toList() ?? [];
  }
}
