import 'package:json_annotation/json_annotation.dart';
part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  int? id;
  String? nik;
  String? name;
  String? username;
  String? gender;
  String? birthDate;
  String? disability;
  String? address;
  String? latitude;
  String? longitude;
  bool? isVerified;
  String? createdAt;
  String? updatedAt;
  String? password;
  String? fatherName;
  String? motherName;
  String? photo;
  String? ktp;

  UserResponseModel({
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
    this.photo,
    this.ktp,
  });

  /// factory.
  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);

  static List<UserResponseModel> fromJsonList(List? json) {
    return json?.map((e) => UserResponseModel.fromJson(e)).toList() ?? [];
  }
}
