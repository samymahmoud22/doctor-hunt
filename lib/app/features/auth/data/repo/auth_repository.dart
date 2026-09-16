import '../models/user_model.dart';
import '../service/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<UserModel> login({
    required String email,
    required String password,
    required String role,
  }) async {
    return await _authService.login(
      email: email,
      password: password,
      role: role,
    );
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    return await _authService.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );
  }

  Future<UserModel> loginWithGoogle({required String role}) async {
    return await _authService.loginWithGoogle(role: role);
  }

  Future<UserModel> loginWithFacebook({required String role}) async {
    return await _authService.loginWithFacebook(role: role);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}
