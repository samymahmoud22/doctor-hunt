import 'package:equatable/equatable.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';

class ChooseRoleState extends Equatable {
  final UserRole selectedRole;

  const ChooseRoleState({
    this.selectedRole = UserRole.patient,
  });

  ChooseRoleState copyWith({
    UserRole? selectedRole,
  }) {
    return ChooseRoleState(
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }

  @override
  List<Object?> get props => [selectedRole];
}
