// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditModel _$EditModelFromJson(Map<String, dynamic> json) => EditModel(
      nik: json['nik'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      birthDate: json['birth_date'] as String?,
      disability: json['disability'] as String?,
      gender: json['gender'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
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
    };
