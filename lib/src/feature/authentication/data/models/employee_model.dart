import 'package:json_annotation/json_annotation.dart';
part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  final int? id;
  final String? name;
  final String? username;
  final String? password;
  String? createdAt;
  String? updatedAt;

  EmployeeModel({
    this.id,
    this.name,
    this.username,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  /// factory.
  factory EmployeeModel.fromJson(Map<String, dynamic> json) => _$EmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);

  static List<EmployeeModel> fromJsonList(List? json) {
    return json?.map((e) => EmployeeModel.fromJson(e)).toList() ?? [];
  }
}
