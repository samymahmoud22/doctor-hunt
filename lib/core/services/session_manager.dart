import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../enums/user_role.dart';
import '../utils/app_constants.dart';
import '../../features/common/auth/data/models/user_model.dart';

/// Centralized manager for persistent app session, onboarding, and auth state.
///
/// Implements [ChangeNotifier] so it can act as a [refreshListenable]
/// for GoRouter to automatically re-evaluate route guards.
class SessionManager extends ChangeNotifier {
  final SharedPreferences prefs;
  final SupabaseClient? supabaseClient;

  static const String keyIsAuthenticated = 'is_authenticated';
  static const String keyUserId = 'current_user_id';
  static const String keyUserEmail = 'current_user_email';
  static const String keyUserName = 'current_user_name';

  SessionManager({
    required this.prefs,
    this.supabaseClient,
  });

  /// Whether the user has completed or skipped the onboarding flow.
  bool get isOnboardingCompleted =>
      prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;

  /// Sets the onboarding status and notifies listeners.
  Future<void> setOnboardingCompleted(bool completed) async {
    await prefs.setBool(AppConstants.onboardingCompletedKey, completed);
    notifyListeners();
  }

  /// Whether the user is authenticated (locally persisted or active Supabase session).
  bool get isAuthenticated {
    final localAuth = prefs.getBool(keyIsAuthenticated) ?? false;
    final supabaseAuth = supabaseClient?.auth.currentSession != null;
    return localAuth || supabaseAuth;
  }

  /// The active user role, defaulting to [AppConstants.defaultRole].
  UserRole get userRole {
    final roleStr = prefs.getString(AppConstants.selectedRoleKey);
    if (roleStr != null && roleStr.isNotEmpty) {
      return UserRole.fromString(roleStr);
    }
    final metaRole = supabaseClient?.auth.currentUser?.userMetadata?['role'] as String?;
    if (metaRole != null && metaRole.isNotEmpty) {
      return UserRole.fromString(metaRole);
    }
    return AppConstants.defaultRole;
  }

  /// Cached user ID.
  String? get userId =>
      prefs.getString(keyUserId) ?? supabaseClient?.auth.currentUser?.id;

  /// Cached user email.
  String? get userEmail =>
      prefs.getString(keyUserEmail) ?? supabaseClient?.auth.currentUser?.email;

  /// Cached user full name.
  String? get userName =>
      prefs.getString(keyUserName) ??
      (supabaseClient?.auth.currentUser?.userMetadata?['full_name'] as String?);

  /// Saves user session details after successful login/registration.
  Future<void> saveUserSession(UserModel user) async {
    await prefs.setBool(keyIsAuthenticated, true);
    await prefs.setString(AppConstants.selectedRoleKey, user.role.value);
    await prefs.setString(keyUserId, user.id);
    await prefs.setString(keyUserEmail, user.email);
    await prefs.setString(keyUserName, user.fullName);
    notifyListeners();
  }

  /// Clears user session details on logout.
  /// Note: Keeps onboarding status intact so returning users aren't forced to onboard again.
  Future<void> clearUserSession() async {
    await prefs.setBool(keyIsAuthenticated, false);
    await prefs.remove(keyUserId);
    await prefs.remove(keyUserEmail);
    await prefs.remove(keyUserName);
    notifyListeners();
  }

  /// Sets the active role and notifies listeners.
  Future<void> setRole(UserRole role) async {
    await prefs.setString(AppConstants.selectedRoleKey, role.value);
    notifyListeners();
  }
}
