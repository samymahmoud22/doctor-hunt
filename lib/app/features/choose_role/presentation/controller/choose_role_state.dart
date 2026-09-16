import 'package:equatable/equatable.dart';

class ChooseRoleState extends Equatable {
  final String selectedRole; // 'patient' or 'admin'

  const ChooseRoleState({
    this.selectedRole = 'patient',
  });

  ChooseRoleState copyWith({
    String? selectedRole,
  }) {
    return ChooseRoleState(
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }

  @override
  List<Object?> get props => [selectedRole];
}
