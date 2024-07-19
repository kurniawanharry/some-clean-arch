// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package:some_app/src/feature/authentication/data/models/employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) => EmployeeModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
