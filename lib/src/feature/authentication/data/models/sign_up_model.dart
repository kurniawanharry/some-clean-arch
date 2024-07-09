import 'package:json_annotation/json_annotation.dart';
part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel {
  String? nik;
  String? name;
  String? gender;
  String? birthDate;
  String? disability;
  String? address;
  double? latitude;
  double? longitude;
  String? password;

  SignUpModel({
    this.nik,
    this.password,
    this.name,
    this.address,
    this.birthDate,
    this.disability,
    this.gender,
    this.latitude,
    this.longitude,
  });

  /// factory.
  factory SignUpModel.fromJson(Map<String, dynamic> json) => _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);
}
