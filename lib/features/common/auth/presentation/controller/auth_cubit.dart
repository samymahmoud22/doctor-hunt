import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import '../../data/repo/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(const AuthState());

  void setRole(UserRole role) {
    emit(state.copyWith(role: role));
  }

  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await repository.login(
        email: email,
        password: password,
        role: state.role,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await repository.register(
        fullName: fullName,
        email: email,
        password: password,
        role: state.role,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await repository.loginWithGoogle(role: state.role);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await repository.sendPasswordResetEmail(email);
      emit(state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: null,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
      return false;
    }
  }

  Future<bool> verifyOtp({
    required String email,
    required String token,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await repository.verifyOtp(email: email, token: token);
      emit(state.copyWith(
        status: AuthStatus.otpVerified,
        errorMessage: null,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
      return false;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await repository.updatePassword(newPassword);
      emit(state.copyWith(
        status: AuthStatus.passwordUpdated,
        errorMessage: null,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
      return false;
    }
  }

  Future<void> logout() async {
    await repository.signOut();
    emit(const AuthState());
  }
}
