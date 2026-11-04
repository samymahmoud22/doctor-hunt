import 'package:doctor_hunt/core/enums/user_role.dart';
import '../../../../admin/data/models/admin_doctor_model.dart';
import '../../../../admin/data/repo/admin_repository.dart';
import '../models/user_model.dart';
import '../service/auth_service.dart';

class AuthRepository {
  final AuthService authService;
  final AdminRepository? adminRepository;

  AuthRepository({required this.authService, this.adminRepository});

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
    final user = await authService.register(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
    );

    if (role.isAdmin && adminRepository != null) {
      final docName = user.fullName.startsWith('Dr.') ? user.fullName : 'Dr. ${user.fullName}';
      final existing = adminRepository!.findDoctorByName(docName);
      if (existing == null) {
        await adminRepository!.addDoctor(
          AdminDoctorModel(
            id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
            name: docName,
            specialty: 'Specialist General',
            consultationFee: 30.0,
            isActive: true,
            rating: 5.0,
            reviewsCount: 1,
          ),
        );
      }
    }

    return user;
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

  Future<Map<String, String>> getPatientProfile() async {
    return await authService.getPatientProfile();
  }

  Future<void> updatePatientProfile({
    required String fullName,
    required String phone,
  }) async {
    await authService.updatePatientProfile(
      fullName: fullName,
      phone: phone,
    );
  }

  Future<void> signOut() async {
    await authService.signOut();
  }
}
