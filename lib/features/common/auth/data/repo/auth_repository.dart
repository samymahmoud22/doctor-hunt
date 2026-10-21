import 'package:doctor_hunt/core/enums/user_role.dart';
import '../models/user_model.dart';
import '../service/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    return await authService.login(
      email: email,
      password: password,
      role: role,
    );
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    return await authService.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }

  Future<UserModel> loginWithGoogle({required UserRole role}) async {
    return await authService.loginWithGoogle(role: role);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await authService.sendPasswordResetEmail(email);
  }

  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    await authService.verifyOtp(email: email, token: token);
  }

  Future<void> updatePassword(String newPassword) async {
    await authService.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}
