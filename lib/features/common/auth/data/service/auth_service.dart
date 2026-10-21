import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/constants/supabase_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;

  AuthService({
    SupabaseClient? client,
    GoogleSignIn? googleSignIn,
  })  : _client = client ?? Supabase.instance.client,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              serverClientId: SupabaseConstants.webClientId,
            );

  Future<UserModel> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('User authentication failed');
      }

      final metadata = user.userMetadata;
      final savedRoleStr = metadata?['role'] as String?;
      final savedRole = savedRoleStr != null
          ? UserRole.fromString(savedRoleStr)
          : role;

      return UserModel(
        id: user.id,
        email: user.email ?? email,
        fullName: (metadata?['full_name'] as String?) ??
            (metadata?['fullName'] as String?) ??
            (metadata?['name'] as String?) ??
            email.split('@').first,
        role: savedRole,
      );
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role.value,
        },
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Registration failed');
      }

      return UserModel(
        id: user.id,
        email: user.email ?? email,
        fullName: fullName,
        role: role,
      );
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> loginWithGoogle({required UserRole role}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In canceled by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('No ID Token found from Google Sign-In');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Google Authentication failed');
      }

      final metadata = user.userMetadata;

      return UserModel(
        id: user.id,
        email: user.email ?? googleUser.email,
        fullName: (metadata?['full_name'] as String?) ??
            (metadata?['name'] as String?) ??
            googleUser.displayName ??
            'Google User',
        role: role,
      );
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.doctorhunt.app://login-callback',
      );
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );
      if (response.session == null && response.user == null) {
        throw Exception('OTP verification failed');
      }
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    try {
      await _client.auth.signOut();
    } catch (_) {}
  }

  String _handleAuthException(AuthException e) {
    final message = e.message.toLowerCase();
    if (message.contains('bad gateway') ||
        e.statusCode == '502' ||
        message.contains('gateway')) {
      return 'سيرفر Supabase غير متاح حالياً (Bad Gateway). يرجى التأكد من استعادة/تشغيل المشروع من لوحة تحكم Supabase.';
    } else if (message.contains('invalid login credentials') ||
        message.contains('invalid credentials')) {
      return 'Incorrect email or password.';
    } else if (message.contains('user already registered') ||
        message.contains('already registered')) {
      return 'An account already exists for this email.';
    } else if (message.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    } else if (message.contains('invalid email')) {
      return 'The email address is invalid.';
    } else if (message.contains('weak password') ||
        message.contains('password should be')) {
      return 'The password provided is too weak. Please use at least 6 characters.';
    } else if (message.contains('expired') ||
        message.contains('otp_expired')) {
      return 'The verification code has expired. Please request a new code.';
    } else if (message.contains('token') &&
        (message.contains('invalid') || message.contains('not found'))) {
      return 'The verification code is invalid. Please double check and try again.';
    } else if (message.contains('rate limit') ||
        message.contains('over_email_send_rate_limit')) {
      return 'Too many requests. Please wait a moment before trying again.';
    } else if (message.contains('user not found')) {
      return 'No account was found with this email address.';
    } else {
      return e.message;
    }
  }
}
