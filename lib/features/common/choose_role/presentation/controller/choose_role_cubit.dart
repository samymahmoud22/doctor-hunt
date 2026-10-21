import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'choose_role_state.dart';

class ChooseRoleCubit extends Cubit<ChooseRoleState> {
  ChooseRoleCubit() : super(const ChooseRoleState());

  void selectRole(UserRole role) {
    emit(state.copyWith(selectedRole: role));
  }
}
