import 'package:json_annotation/json_annotation.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
class SignInModel {
  String? nik;
  String? username;
  String? password;

  SignInModel({
    this.nik,
    this.password,
    this.username,
  });

  /// factory.
  factory SignInModel.fromJson(Map<String, dynamic> json) => _$SignInModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignInModelToJson(this);
}
