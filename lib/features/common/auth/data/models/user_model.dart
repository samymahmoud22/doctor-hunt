import 'package:equatable/equatable.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      role: UserRole.fromString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role.value,
    };
  }

  @override
  List<Object?> get props => [id, email, fullName, role];
}
