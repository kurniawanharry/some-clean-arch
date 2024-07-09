// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
      userType: (json['user_type'] as num?)?.toInt(),
      expiresIn: (json['expires_in'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user_type': instance.userType,
      'expires_in': instance.expiresIn,
    };
