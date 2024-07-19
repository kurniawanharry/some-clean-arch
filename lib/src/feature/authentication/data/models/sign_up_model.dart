import 'package:json_annotation/json_annotation.dart';
part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel {
  String? nik;
  String? name;
  String? photo;
  String? ktp;
  String? gender;
  String? birthDate;
  String? disability;
  String? address;
  String? latitude;
  String? longitude;
  String? fatherName;
  String? motherName;
  String? placeId;
  // String? password;

  SignUpModel({
    this.nik,
    // this.password,
    this.name,
    this.photo,
    this.ktp,
    this.address,
    this.birthDate,
    this.disability,
    this.gender,
    this.latitude,
    this.longitude,
    this.fatherName,
    this.motherName,
    this.placeId,
  });

  /// factory.
  factory SignUpModel.fromJson(Map<String, dynamic> json) => _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
