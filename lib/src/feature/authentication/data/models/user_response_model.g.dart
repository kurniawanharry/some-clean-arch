// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponseModel _$UserResponseModelFromJson(Map<String, dynamic> json) => UserResponseModel(
      nik: json['nik'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      address: json['address'] as String?,
      birthDate: json['birth_date'] as String?,
      disability: json['disability'] as String?,
      gender: json['gender'] as String?,
      isVerified: json['is_verified'] as bool?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      // latitude: (json['latitude'] as num?)?.toDouble(),
      // longitude: (json['longitude'] as num?)?.toDouble(),
      // latitude: (json['latitude'] as num?)?.toDouble(),
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserResponseModelToJson(UserResponseModel instance) => <String, dynamic>{
      'id': instance.id,
      'nik': instance.nik,
      'name': instance.name,
      'username': instance.username,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'disability': instance.disability,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_verified': instance.isVerified,
      'password': instance.password,
    };
