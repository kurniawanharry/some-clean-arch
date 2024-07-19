// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditModel _$EditModelFromJson(Map<String, dynamic> json) => EditModel(
      nik: json['nik'] as String?,
      // password: json['password'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      ktp: json['ktp'] as String?,
      address: json['address'] as String?,
      birthDate: json['birth_date'] as String?,
      disability: json['disability'] as String?,
      gender: json['gender'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      // latitude: (json['latitude'] as num?)?.toDouble(),
      // longitude: (json['longitude'] as num?)?.toDouble(),
      fatherName: json['father_name'] as String?,
      motherName: json['mother_name'] as String?,
      placeId: json['place_id'] as String?,
    );

Map<String, dynamic> _$EditModelToJson(EditModel instance) => <String, dynamic>{
      'nik': instance.nik,
      'name': instance.name,
      'gender': instance.gender,
      'birth_date': instance.birthDate,
      'disability': instance.disability,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      // 'password': instance.password,
      'father_name': instance.fatherName,
      'mother_name': instance.motherName,
      'place_id': instance.placeId,
      'photo': instance.photo,
      'ktp': instance.ktp,
    };
