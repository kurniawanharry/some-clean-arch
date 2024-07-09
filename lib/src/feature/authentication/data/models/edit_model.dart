import 'package:json_annotation/json_annotation.dart';
part 'edit_model.g.dart';

@JsonSerializable()
class EditModel {
  String? nik;
  String? name;
  String? gender;
  String? birthDate;
  String? disability;
  String? address;
  double? latitude;
  double? longitude;

  EditModel({
    this.nik,
    this.name,
    this.address,
    this.birthDate,
    this.disability,
    this.gender,
    this.latitude,
    this.longitude,
  });

  /// factory.
  factory EditModel.fromJson(Map<String, dynamic> json) => _$EditModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditModelToJson(this);
}
