import 'package:json_annotation/json_annotation.dart';
part 'edit_model.g.dart';

@JsonSerializable()
class EditModel {
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

  EditModel({
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
  factory EditModel.fromJson(Map<String, dynamic> json) => _$EditModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditModelToJson(this);
}
