import 'package:flutter_bloc/flutter_bloc.dart';
import 'choose_role_state.dart';

class ChooseRoleCubit extends Cubit<ChooseRoleState> {
  ChooseRoleCubit() : super(const ChooseRoleState());

  void selectRole(String role) {
    emit(state.copyWith(selectedRole: role));
  }
}
