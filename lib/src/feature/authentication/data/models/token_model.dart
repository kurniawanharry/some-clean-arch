import 'package:json_annotation/json_annotation.dart';
part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  String? accessToken;
  String? tokenType;
  int? userType;
  int? expiresIn;

  TokenModel({
    this.accessToken,
    this.tokenType,
    this.userType,
    this.expiresIn,
  });

  /// factory.
  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);

  static List<TokenModel> fromJsonList(List? json) {
    return json?.map((e) => TokenModel.fromJson(e)).toList() ?? [];
  }
}
