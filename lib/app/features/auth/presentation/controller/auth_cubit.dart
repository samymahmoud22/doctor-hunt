import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({AuthRepository? repository})
      : _repository = repository ?? AuthRepository(),
        super(const AuthState());

  void setRole(String role) {
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
      final user = await _repository.login(
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
      final user = await _repository.register(
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
      final user = await _repository.loginWithGoogle(role: state.role);
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

  Future<void> loginWithFacebook() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _repository.loginWithFacebook(role: state.role);
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

  Future<void> sendPasswordReset(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _repository.sendPasswordResetEmail(email);
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Password reset link sent to $email',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> logout() async {
    await _repository.signOut();
    emit(const AuthState());
  }
}
