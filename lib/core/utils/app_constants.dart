import '../enums/user_role.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Doctor Hunt';
  static const String selectedRoleKey = 'selected_user_role';
  static const String onboardingCompletedKey = 'onboarding_completed';

  static const UserRole defaultRole = UserRole.patient;

  static String get rolePatient => UserRole.patient.name;
  static String get roleAdmin => UserRole.admin.name;
}
