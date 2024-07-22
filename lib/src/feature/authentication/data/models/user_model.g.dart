// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
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
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
      placeId: json['place_id'] as String?,
      // latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: json['longitude'] as String?,
      photo: json['photo'] as String?,
      ktp: json['ktp'] as String?,
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
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
      'father_name': instance.fatherName,
      'mother_name': instance.motherName,
      'place_id': instance.placeId,
      'photo': instance.photo,
      'ktp': instance.ktp,
    };
